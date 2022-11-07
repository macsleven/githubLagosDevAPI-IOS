//
//  UserTableViewCell.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import UIKit
import RealmSwift

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "UserTableViewCell"
    
    private let name : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
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
     
    private let favButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "defaultImg"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
     }()
    
    private let favView: UIView = {
        let fav = UIView()
        return fav
    }()
     
    private let avatarUrl : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "defaultImg"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 40
        return imgView
     }()
     
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(avatarUrl)
        addSubview(name)
        addSubview(favView)
     }
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    func configure() {
        avatarUrl.translatesAutoresizingMaskIntoConstraints = false
        avatarUrl.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        avatarUrl.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 12).isActive = true
        avatarUrl.heightAnchor.constraint(equalToConstant: 80).isActive = true
        avatarUrl.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        name.leadingAnchor.constraint(equalTo: avatarUrl.trailingAnchor, constant: 20).isActive = true
        name.heightAnchor.constraint(equalToConstant: 80).isActive = true
        name.trailingAnchor.constraint(equalTo: favView.leadingAnchor, constant: -12).isActive = true
        
        favView.translatesAutoresizingMaskIntoConstraints = false
        favView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
       // favView.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 20).isActive = true
        favView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        favView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        favView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    }
    
    
    func setupView(name: String , url: String, id: String) {
        self.name.text = name
        self.avatarUrl.image = UIImage(named: "defaultImg")
        self.avatarUrl.image = PhotoTool.getImage(Name: id)
        if self.avatarUrl.image == nil {
            self.avatarUrl.downloadImageFrom(link: url, contentMode: UIView.ContentMode.scaleAspectFit, id: id)
        }
        let realm = try! Realm()
        if realm.object(ofType: Favourite.self, forPrimaryKey: Int(id)) != nil {
            self.favView.backgroundColor = .blue
           
        } else {
            self.favView.backgroundColor = .white
        }
    }
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode, id: String) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    if let img: UIImage = UIImage(data: data){
                        PhotoTool.saveImageDocumentDirectory(image: img, Name: id)
                        self.image = img
                }
                }
            }
        }).resume()
    }
}
