//
//  User.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import Foundation

struct UsersResponse : Codable {
    var results : [User]?
    var total_count : Int?
    var incomplete_results: Bool?

    enum CodingKeys: String, CodingKey {
        case results = "items"
        case total_count = "total_count"
        case incomplete_results = "incomplete_results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([User].self, forKey: .results)
        total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
        incomplete_results = try values.decodeIfPresent(Bool.self, forKey: .incomplete_results)
    }
}
