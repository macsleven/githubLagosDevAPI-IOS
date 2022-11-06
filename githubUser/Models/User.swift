//
//  User.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let avatarUrl: String
    let gravatar_id: String
    let url : String
    let html_url : String
    let followers_url: String
    let following_url: String
    let gists_url : String
    let starred_url : String
    let subscriptions_url: String
    let organizations_url: String
    let repos_url : String
    let events_url : String
    let received_events_url : String
    let type : String
    let site_admin : Bool
    
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
