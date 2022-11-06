//
//  UserListVC.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import UIKit

class UserListVC: UIViewController {

    var activityView = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()
    
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
        refreshControl.addTarget(self, action: #selector(refreshRouteData(_:)), for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
        showActivityIndicatory()
       // self.title = StringConstants.boundsDetails.route
    }
    
    @objc private func refreshRouteData(_ sender: Any) {
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

extension UserListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath)
        guard let customCell = cell as? UserTableViewCell else { fatalError("Unable to dequeue expected cell type: RouteTableViewCell") }
        
        let cellVM = viewModel.getCellViewModel(section: viewModel.sectionLetters, listsection: indexPath.section, row: indexPath.row )
        customCell.setupView(name: cellVM.name, url: cellVM.avatar_url)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

