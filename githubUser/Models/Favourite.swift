//
//  Favourite.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 07/11/2022.
//

import Foundation
import RealmSwift

class Favourite: Object, Comparable {
    static func < (lhs: Favourite, rhs: Favourite) -> Bool {
        lhs.name < rhs.name
    }
    
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var avatarUrl: String?
    @objc dynamic var url : String?
    @objc dynamic var html_url : String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
