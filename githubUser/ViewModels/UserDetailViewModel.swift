//
//  UserDetailViewModel.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import Foundation

class UserDetailViewModel {
    var user : User?
    
    private var vM: User = User() {
        didSet {
            self.user = vM
        }
    }
}
