//
//  APIService.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import Foundation

protocol APIServiceProtocol {
    func fetchUsers(pageNumber: Int , complete: @escaping ( _ success: Bool, _ userData: [User], _ error: Error? )->() )
    var pagenumber: Int { get set }
    var isPaginating: Bool { get set }
    var incomplete_result: Bool { get set }
}

private let sessionManager: URLSession = {
    let urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
    return URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: nil)
}()

class APIService: APIServiceProtocol {
    var pagenumber: Int = 1
    var incomplete_result = false
    
    var isPaginating = false
    
    func fetchUsers(pageNumber: Int, complete: @escaping ( _ success: Bool, _ userData: [User], _ error: Error? )->() )
    {
        guard let composedUrl = URL(string: "https://api.github.com/search/users?q=lagos&page=\(pageNumber)") else {
            fatalError("Unable to build request url")
        }
        
        isPaginating = true
        print(composedUrl)
        
        let request = URLRequest(url: composedUrl)
        
        sessionManager.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                let exResult: [User] = []
                complete( false,exResult, error )
                self.isPaginating = false
                return
            }
            
            let response = try? JSONDecoder().decode(UsersResponse.self, from: data!)
            self.incomplete_result = ((response?.incomplete_results) != nil)
            let exResult: [User] = []
            complete( true, response?.results ?? exResult, nil )
            if response?.incomplete_results ?? false {
                self.pagenumber += 1
            }
            self.isPaginating = false
        }.resume()
    }
    
}
