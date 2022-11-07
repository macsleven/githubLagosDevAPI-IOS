//
//  User.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import Foundation
import RealmSwift

final class User: Object, Codable, Comparable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.name < rhs.name
    }

    @objc dynamic var id: Int
    @objc dynamic var name: String
    @objc dynamic var avatarUrl: String
    @objc dynamic var gravatar_id: String
    @objc dynamic var url : String
    @objc dynamic var html_url : String
    @objc dynamic var followers_url: String
    @objc dynamic var following_url: String
    @objc dynamic var gists_url : String
    @objc dynamic var starred_url : String
    @objc dynamic var subscriptions_url: String
    @objc dynamic var organizations_url: String
    @objc dynamic var repos_url : String
    @objc dynamic var events_url : String
    @objc dynamic var received_events_url : String
    @objc dynamic var type : String
    @objc dynamic var site_admin : Bool
    @objc dynamic var favorite  = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarUrl = "avatar_url"
        case gravatar_id = "gravatar_id"
        case url = "url"
        case html_url = "html_url"
        case followers_url = "followers_url"
        case following_url = "following_url"
        case gists_url = "gists_url"
        case starred_url = "starred_url"
        case subscriptions_url = "subscriptions_url"
        case organizations_url = "organizations_url"
        case repos_url = "repos_url"
        case events_url = "events_url"
        case received_events_url = "received_events_url"
        case type = "type"
        case site_admin = "site_admin"
    }
}
