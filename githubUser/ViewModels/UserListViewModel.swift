//
//  UserListViewModel.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import Foundation

struct Section {
    let letter : String
    let names : [User]
}

class UserListViewModel {
    let apiService: APIServiceProtocol
    
    private var users: [User] = [User]()
    var allData : [String : [User]] =  [ : ]
    var sections = [Section]()
    var sectionLetters = [String]()
    
    private var cellViewModels: [String : [UserListCellViewModel]] = [String : [UserListCellViewModel]]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var numberOfSections: Int {
        return sections.count
    }
    
    var heightForRow: CGFloat {
        return 100
    }
    
    var heightForSection: CGFloat {
        return 20
    }
    
    //var selectedRoute: AirlineDetailsViewModel?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetch() {
        self.isLoading = true
        apiService.fetchUsers { [weak self] (success, routeDatas, error) in
            if let error = error {
                self?.isLoading = false
                self?.alertMessage = error.localizedDescription
            } else {
                self?.isLoading = false
                self?.processFetchedRoutes(users: routeDatas, complete: { allListData, listSections  in
                    self?.cellViewModels = allListData
                    self?.sections = listSections
                })
            }
        }
    }
    
    func getCellViewModel(section: [String], listsection : Int, row: Int ) -> UserListCellViewModel {
        return (cellViewModels[section[listsection]]![row])
    
    }
    
    func createCellViewModel( user: User ) -> UserListCellViewModel {
        return UserListCellViewModel(user: user, name: user.name, avatar_url: user.avatarUrl)
    }
    
    
    func processFetchedRoutes( users: [User], complete: @escaping (_ allListData: [String : [UserListCellViewModel]], _ listSections: [Section]) -> ()) {
        self.users = users // Cache
      
        let users = self.users.sorted(by: { $0.name < $1.name })
        

        let groupAllRoute = Dictionary(grouping: users, by: {String($0.name.prefix(1).capitalized)})
        let keys = groupAllRoute.keys.sorted()
        self.sections = keys.map{ Section(letter: $0, names: groupAllRoute[$0]!.sorted()) }
        sections = keys.map{ Section(letter: $0, names: groupAllRoute[$0]!.sorted()) }
        
        var vms = [String : [UserListCellViewModel]]()
        var vms2 = [UserListCellViewModel]()
        for routeDataDetails in sections.sorted(by: { $0.letter < $1.letter }) {
            vms2.removeAll()
            for dataDetails in routeDataDetails.names {
                vms2.append( createCellViewModel(user: dataDetails) )
            }
            
            vms[routeDataDetails.letter] = vms2
        }
        
        self.sectionLetters = keys.sorted()
        complete(vms, sections)
    }
}

extension UserListViewModel {
//    func userPressed( at indexPath: IndexPath ) {
//        let route = self.allData[self.sections[indexPath.section]]![indexPath.row]
//       // self.selectedRoute = AirlineDetailsViewModel(rides: route.routes!, routeLine: route.routeLine!)
//    }
}

struct UserListCellViewModel {
    let user: User
    let name: String
    let avatar_url: String
}
