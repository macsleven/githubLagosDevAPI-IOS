//
//  FavouriteListVC.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 08/11/2022.
//

import UIKit
import RealmSwift

class FavouriteListVC: UIViewController {

    var activityView = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()
   // var realm: Realm!
    var users: Results<User>!
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        
        return table
    }()
    
    var safeArea: UILayoutGuide!
    
    lazy var viewModel: FavouriteListViewModel = {
        return FavouriteListViewModel()
    }()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide

        // Init the static view
        initView()
        
        // init view model
        initVM()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshUserData(self)
        isTrashEnable()
    }
    
    func showActivityIndicatory() {
        activityView = UIActivityIndicatorView(style: .medium)
        activityView.color = .black
        activityView.center = self.view.center
        self.view.addSubview(activityView)
    }
    
    //Mark: Setup View Methods
    func initView() {
        view.addSubview(tableView)
        // setup table view
        self.setupTableViewConstraints()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshUserData(_:)), for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.title = "Favourite Dev"
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = delete
        showActivityIndicatory()
    }
    
    @objc private func addTapped() {
        print("tapping")
        self.showAlert()
    }
    
    @objc private func refreshUserData(_ sender: Any) {
        self.refreshControl.endRefreshing()
        viewModel.initFetch()
        
    }
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Clear favourite?", message:"This action will clear all favourite", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: clearFavData))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
    func clearFavData(alertAction: UIAlertAction) {
        viewModel.clearFavDb()
        isTrashEnable()
        
    }
    
    func isTrashEnable() {
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.numberOfCells > 0 ? true : false
    }
    
    fileprivate func setupTableViewConstraints() {
      tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
          tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
          tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),
          tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8)
        ])
    }
    
    func initVM() {
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityView.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.activityView.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.initFetch()
        
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "info", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension FavouriteListVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath)
        guard let customCell = cell as? UserTableViewCell else { fatalError("Unable to dequeue expected cell type: UserTableViewCell") }
        
        let cellVM = viewModel.getCellViewModel(section: viewModel.sectionLetters, listsection: indexPath.section, row: indexPath.row )
        customCell.setupView(name: cellVM.name, url: cellVM.avatar_url, id: "\(cellVM.id)")
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].letter
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].names.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let user = self.viewModel.getCellViewModel(section: self.viewModel.sectionLetters, listsection: indexPath.section, row: indexPath.row )
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, success) in
            self.viewModel.deleteFromDB(userID: user.id)
            self.isTrashEnable()
         })
         
        deleteAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UserDetailsVC()
        let realm = try! Realm()
        let user = self.viewModel.getCellViewModel(section: self.viewModel.sectionLetters, listsection: indexPath.section, row: indexPath.row )
        let specificPerson = realm.object(ofType: User.self, forPrimaryKey: user.id)
        vc.viewModel.user = specificPerson
        DispatchQueue.main.async{
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }


}
