//
//  UserDetailsVC.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import UIKit

class UserDetailsVC: UIViewController {
    
    lazy var viewModel: UserDetailViewModel = {
        return UserDetailViewModel()
    }()
    var safeArea: UILayoutGuide!
    
     let avatarUrl : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "defaultImg"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
     }()
    
     var name : UILabel = {
         let lbl = UILabel()
         lbl.textColor = .black
         lbl.text = "Macsleven"
         lbl.textAlignment = .center
         lbl.font = UIFont.boldSystemFont(ofSize: 16)
         lbl.textAlignment = .left
        return lbl
    }()
     
    private let DescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
     }()

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
        safeArea = view.layoutMarginsGuide
        initView()
    
        // init view model
        initVM()
    }
    
    func configure() {
        self.avatarUrl.translatesAutoresizingMaskIntoConstraints = false
        self.avatarUrl.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        self.avatarUrl.topAnchor.constraint(equalTo:self.view.topAnchor, constant: 100).isActive = true
        
        self.avatarUrl.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.avatarUrl.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        self.name.translatesAutoresizingMaskIntoConstraints = false
        self.name.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.name.topAnchor.constraint(equalTo: avatarUrl.bottomAnchor, constant: 16).isActive = true
    }
    
    //Mark: Setup View Methods
    func initView() {
        self.view.addSubview(avatarUrl)
        self.view.addSubview(name)
        self.configure()
    }
    
    func initVM() {
        self.setupView(name: viewModel.user!.name, id: viewModel.user!.id)
    }
    
    func setupView(name: String , id: Int) {
        self.name.text = name
        self.avatarUrl.image = UIImage(named: "defaultImg")
        self.avatarUrl.image = PhotoTool.getImage(Name: "\(id)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
