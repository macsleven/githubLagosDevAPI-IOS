//
//  CustomTabBarController.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 08/11/2022.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Tab Bar Customisation
        tabBar.unselectedItemTintColor = .systemGray

        viewControllers = [
            createTabBarItem(tabBarTitle: "Users", tabBarImage: "users", viewController: UserListVC()),
            createTabBarItem(tabBarTitle: "Favourite", tabBarImage: "favourite", viewController: FavouriteListVC())
        ]
    }

    func createTabBarItem(tabBarTitle: String, tabBarImage: String, viewController: UIViewController) -> UINavigationController {
        let navCont = UINavigationController(rootViewController: viewController)
        navCont.tabBarItem.title = tabBarTitle
        navCont.tabBarItem.image = UIImage(named: tabBarImage)
        return navCont
    }
}
