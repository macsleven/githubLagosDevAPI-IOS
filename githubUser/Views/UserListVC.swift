//
//  UserListVC.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import UIKit
import RealmSwift

class UserListVC: UIViewController {

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
    
    lazy var viewModel: UserListViewModel = {
        return UserListViewModel()
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
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let realm = RealmService.shared.realm
//        self.users = realm.objects(User.self)
//        print(Realm.Configuration.defaultConfiguration)
//    }
    
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
        showActivityIndicatory()
    }
    
    @objc private func refreshUserData(_ sender: Any) {
        self.refreshControl.endRefreshing()
        viewModel.initFetch()
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

extension UserListVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
       // self.viewModel.userPressed(at: indexPath)
        return indexPath
       
    }
    
    private func createSpinerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.apiService.isPaginating {
            return
        }
       
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100 - scrollView.frame.size.height) {
            if !viewModel.apiService.isPaginating && viewModel.apiService.incomplete_result && viewModel.apiService.pagenumber > 1  {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.tableView.tableFooterView = self.createSpinerFooter()
                }
                
                DispatchQueue.global().asyncAfter(deadline: .now()) {
                    self.viewModel.fetchMoreDate()
                    DispatchQueue.main.async {
                        self.tableView.tableFooterView = nil
                    }
                }
            }
        }
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

