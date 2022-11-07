//
//  FavouriteListViewModel.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 08/11/2022.
//

import Foundation
import RealmSwift

class FavouriteListViewModel {
    
    private var users: [Favourite] = [Favourite]()
    var allData : [String : [Favourite]] =  [ : ]
    var sections = [FavouriteSection]()
    var sectionLetters = [String]()
    
    private var cellViewModels: [String : [FavouriteListCellViewModel]] = [String : [FavouriteListCellViewModel]]() {
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
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    
    func initFetch() {
        self.loadFromDb()
    }
    
    func loadFromDb() {
        let realm = try! Realm()
        let users = realm.objects(Favourite.self)
        if !users.isEmpty {
            self.processFetchedRoutes(users: users.sorted(), complete: { allListData, listSections  in
                self.isLoading = false
                self.cellViewModels = allListData
                self.sections = listSections
            })
        } else {
            self.isLoading = false
            self.cellViewModels.removeAll()
            self.sections.removeAll()
        }
    }
    
    func clearFavDb() {
        let realm = try! Realm()
        let allUploadingObjects = realm.objects(Favourite.self)
        
        do {
            try realm.write {
                if !allUploadingObjects.isEmpty {
                    realm.delete(allUploadingObjects)
                }
                print("calling init with loadDb")
                self.loadFromDb()
            }
            
        } catch {
            print(error.localizedDescription)
            self.loadFromDb()
        }
    }
    
    func getCellViewModel(section: [String], listsection : Int, row: Int ) -> FavouriteListCellViewModel {
        return (cellViewModels[section[listsection]]![row])
    
    }
    
    func createCellViewModel( user: Favourite ) -> FavouriteListCellViewModel {
        return FavouriteListCellViewModel(user: user, name: user.name, avatar_url: user.avatarUrl!, id: user.id)
    }
    
    
    func processFetchedRoutes( users: [Favourite], complete: @escaping (_ allListData: [String : [FavouriteListCellViewModel]], _ listSections: [FavouriteSection]) -> ()) {
        self.users = users // Cache
      
        let users = self.users.sorted(by: { $0.name < $1.name })
        

        let groupAllRoute = Dictionary(grouping: users, by: {String($0.name.prefix(1).capitalized)})
        let keys = groupAllRoute.keys.sorted()
        self.sections = keys.map{ FavouriteSection(letter: $0, names: groupAllRoute[$0]!.sorted()) }
        sections = keys.map{ FavouriteSection(letter: $0, names: groupAllRoute[$0]!.sorted()) }
        
        var vms = [String : [FavouriteListCellViewModel]]()
        var vms2 = [FavouriteListCellViewModel]()
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

struct FavouriteSection {
    let letter : String
    let names : [Favourite]
}

struct FavouriteListCellViewModel {
    let user: Favourite
    let name: String
    let avatar_url: String
    let id: Int
}
