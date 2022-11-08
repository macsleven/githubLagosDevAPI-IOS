//
//  APIServiceTest.swift
//  githubUserTests
//
//  Created by Suleiman Abubakar on 08/11/2022.
//

import XCTest

@testable import githubUser
@testable import RealmSwift

final class APIServiceTest: XCTestCase {

    var sut: APIService?
    
    override func setUp() {
        super.setUp()
        sut = APIService()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_fetch_users() {
        
        // Given A apiservice
        let sut = self.sut!
        
        // When fetch routes
        let expect = XCTestExpectation(description: "callback")
        
        sut.fetchUsers(pageNumber: 1, complete: { (success, allUsers, error) in
            expect.fulfill()
            for user in allUsers {
                XCTAssertNotNil(user)
            }
        })
        
        wait(for: [expect], timeout: 5.1)
    }

}
