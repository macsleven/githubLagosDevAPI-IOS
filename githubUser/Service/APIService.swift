//
//  APIService.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import Foundation

protocol APIServiceProtocol {
    func fetchUsers( complete: @escaping ( _ success: Bool, _ userData: [User], _ error: Error? )->() )

}

private let sessionManager: URLSession = {
    let urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
    return URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: nil)
}()

class APIService: APIServiceProtocol {
    
    func fetchUsers( complete: @escaping ( _ success: Bool, _ userData: [User], _ error: Error? )->() )
    {
        guard let composedUrl = URL(string: "https://api.github.com/search/users?q=lagos&page=1") else {
            fatalError("Unable to build request url")
        }
        
        let request = URLRequest(url: composedUrl)
        
        sessionManager.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                let exResult: [User] = []
                complete( false,exResult, error )
                return
            }
            
            let response = try? JSONDecoder().decode(UsersResponse.self, from: data!)
            complete( true, (response?.results)!, nil )
        }.resume()
    }
    
}
