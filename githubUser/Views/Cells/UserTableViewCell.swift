//
//  UserTableViewCell.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import UIKit

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
     
    private let avatarUrl : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "defaultImg"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
     }()
     
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(avatarUrl)
        addSubview(name)
     //addSubview(DescriptionLabel)
     //addSubview(favButton)
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
        name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
    
    func setupView(name: String , url: String, id: String) {
        self.name.text = name
        self.avatarUrl.image = UIImage(named: "defaultImg")
        self.avatarUrl.image = PhotoTool.getImage(Name: id)
        if self.avatarUrl.image == nil {
            self.avatarUrl.downloadImageFrom(link: url, contentMode: UIView.ContentMode.scaleAspectFit, id: id)
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
