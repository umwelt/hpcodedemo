//
//  GrocerestAPIUserTest.swift
//  Grocerest
//
//  Created by Cristian Bellomo on 25/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import XCTest
import SwiftyJSON

/**
 The library is not covered by tests in its entirety because every method does essentially the
 same thing over and over (a simple HTTP request). Only those method which behave differently from
 the others are tested or if they are representative of a category of methods.
 
 If you encounter problems while using the GrocerestAPI library then you are encouraged to write tests
 even for the methods that troubled you to help you debug the code.
 */
class GrocerestAPITest: XCTestCase {
    
    // MARK: User's categories
    
    func testUserCategories() {
        let expectation = expectationWithDescription("User's categories")
        
        let userFields = [
            "username": "ios_testuser_\(NSDate().timeIntervalSince1970)",
            "email": "\(NSDate().timeIntervalSince1970)@email.com",
            "password": "password"
        ]
        
        GrocerestAPI.postUser(userFields) { user, error in
            GrocerestAPI.getUserCategories(user["_id"].stringValue) { userCategories, error in
                XCTAssertEqual(userCategories.arrayValue.count, 0)
                
                let newUserCategories = ["56659a59f2824d206d17d8d0", "56659a59f2824d206d17d8d1"] // Category ids hand-picked from the db
                GrocerestAPI.putUserCategories(user["_id"].stringValue, categoryIds: newUserCategories) { _, error in
                    GrocerestAPI.getUserCategories(user["_id"].stringValue) { userCategories, error in
                        XCTAssertEqual(userCategories.arrayValue.count, 2)
                        
                        expectation.fulfill()
                    }
                }
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Authentication
    
    func testLoginLogout() {
        let expectation = expectationWithDescription("Login and logout")
        
        let fields = [
            "username": "ios_testuser_\(NSDate().timeIntervalSince1970)",
            "email": "\(NSDate().timeIntervalSince1970)@email.com",
            "password": "password"
        ]
        
        GrocerestAPI.postUser(fields) { data, error in
            GrocerestAPI.logout() { data, error in
                XCTAssertTrue(data.dictionaryValue.isEmpty)
                
                GrocerestAPI.postShoppingList(["name": "Lista della spesa"]) { data, error in
                    XCTAssertEqual(data["error"]["code"].stringValue, "E_UNAUTHORIZED")
                    
                    GrocerestAPI.login(["username": fields["username"]!, "password": fields["password"]!]) { data, error in
                        GrocerestAPI.postShoppingList(["name": "Lista della spesa"]) { data, error in
                            XCTAssertNil(data["error"].string)
                            
                            expectation.fulfill()
                        }
                    }
                }
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: User
    
    func testPostUser() {
        let expectation = expectationWithDescription("Create a new user")
        
        let fields = [
            "username": "ios_testuser_\(NSDate().timeIntervalSince1970)",
            "email": "email@email.com",
            "password": "password"
        ]
        
        GrocerestAPI.postUser(fields) { data, error in
            XCTAssertNotNil(data["_id"].string)
            XCTAssertFalse(data["_id"].stringValue.isEmpty)
            
            XCTAssertNotNil(data["bearerToken"].string)
            XCTAssertFalse(data["bearerToken"].stringValue.isEmpty)
            
            XCTAssertNotNil(data["username"].string)
            XCTAssertFalse(data["username"].stringValue.isEmpty)
            
            XCTAssertNotNil(data["email"].string)
            XCTAssertFalse(data["email"].stringValue.isEmpty)
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetAndDeleteUser() {
        let expectation = expectationWithDescription("Deletes and Get a user")
        
        let user1Fields = [
            "username": "ios_testuser_\(NSDate().timeIntervalSince1970)",
            "email": "email@email.com",
            "password": "password"
        ]
        
        GrocerestAPI.postUser(user1Fields) { data, error in
            let id = data["_id"].stringValue
            
            GrocerestAPI.getUser(id) { data, error in
                XCTAssertNil(data["error"].string)
                
                XCTAssertNotNil(data["_id"].string)
                XCTAssertFalse(data["_id"].stringValue.isEmpty)
                
                XCTAssertNotNil(data["bearerToken"].string)
                XCTAssertFalse(data["bearerToken"].stringValue.isEmpty)
                
                XCTAssertNotNil(data["username"].string)
                XCTAssertFalse(data["username"].stringValue.isEmpty)
                
                XCTAssertNotNil(data["email"].string)
                XCTAssertFalse(data["email"].stringValue.isEmpty)
                
                GrocerestAPI.deleteUser(id) { data, error in
                    XCTAssertNil(data["error"].string)
                    
                    let user2Fields = [
                        "username": "ios_testuser_\(NSDate().timeIntervalSince1970)",
                        "email": "email@email.com",
                        "password": "password"
                    ]
                    
                    GrocerestAPI.postUser(user2Fields) { data, error in
                        GrocerestAPI.getUser(id) { data, error in
                            XCTAssertNotNil(data["error"])
                            XCTAssertEqual(data["error"]["code"].stringValue, "E_NOT_FOUND")
                            
                            expectation.fulfill()
                        }
                    }
                }
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testUpdateUser() {
        let expectation = expectationWithDescription("Updates an user")
        
        let fields = [
            "username": "ios_testuser_\(NSDate().timeIntervalSince1970)",
            "email": "email@email.com",
            "password": "password"
        ]
        
        GrocerestAPI.postUser(fields) { data, error in
            let id = data["_id"].stringValue
            let fields = [
                "firstname": "Pimpi",
                "lastname": "Ripettennusa",
                "gender": "F"
            ]
            
            GrocerestAPI.updateUser(id, fields: fields) { data, error in
                XCTAssertEqual(data["_id"].stringValue, id)
                XCTAssertEqual(data["firstname"].stringValue, "Pimpi")
                XCTAssertEqual(data["lastname"].stringValue, "Ripettennusa")
                XCTAssertEqual(data["gender"].stringValue, "F")
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: User's shopping lists
    
    func testGetUserShoppingLists() {
        let expectation = expectationWithDescription("Gets an user's shopping lists")
        
        let fields = [
            "username": "ios_testuser_\(NSDate().timeIntervalSince1970)",
            "email": "email@email.com",
            "password": "password"
        ]
        
        GrocerestAPI.postUser(fields) { json, error in
            let user = json
            
            GrocerestAPI.postShoppingList(["name": "Lista della spesa"]) { data, error in
                let list = data
                
                GrocerestAPI.getUserShoppingLists(user["_id"].stringValue) { data, error in
                    let shoppingLists = data.arrayValue
                    
                    XCTAssertEqual(shoppingLists.count, 1)
                    XCTAssertEqual(shoppingLists[0]["_id"].stringValue, list["_id"].stringValue)
                    
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Shopping List
    
    func testPostShoppingList() {
        let expectation = expectationWithDescription("Create a new shopping list")
        
        let fields = [
            "username": "ios_testuser_\(NSDate().timeIntervalSince1970)",
            "email": "email@email.com",
            "password": "password"
        ]
        
        GrocerestAPI.postUser(fields) { json, error in
            GrocerestAPI.postShoppingList(["name": "Lista della spesa"]) { data, error in
                let list = data
                XCTAssertNotNil(list["_id"].string)
                XCTAssertFalse(list["_id"].stringValue.isEmpty)
                
                XCTAssertNotNil(list["name"].string)
                XCTAssertEqual(list["name"].stringValue, "Lista della spesa")
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetAndDeleteShoppingList() {
        let expectation = expectationWithDescription("Deletes and Get a shopping list")
        
        let fields = [
            "username": "ios_testuser_\(NSDate().timeIntervalSince1970)",
            "email": "email@email.com",
            "password": "password"
        ]
        
        GrocerestAPI.postUser(fields) { data, error in
            let userId = data["_id"].stringValue
            
            GrocerestAPI.postShoppingList(["name": "Lista della spesa"]) { data, error in
                XCTAssertNil(data["error"].string)
                
                XCTAssertNotNil(data["_id"].string)
                XCTAssertFalse(data["_id"].stringValue.isEmpty)
                
                XCTAssertEqual(data["name"].stringValue, "Lista della spesa")
                XCTAssertEqual(data["owner"]["_id"].stringValue, userId)
                
                XCTAssertEqual(data["collaborators"].arrayValue.count, 0)
                XCTAssertEqual(data["items"].arrayValue.count, 0)
                
                let listId = data["_id"].stringValue
                
                GrocerestAPI.deleteShoppingList(listId) { data, error in
                    XCTAssertNil(data["error"].string)
                    
                    GrocerestAPI.getShoppingList(listId) { data, error in
                        XCTAssertNotNil(data["error"])
                        XCTAssertEqual(data["error"]["code"].stringValue, "E_NOT_FOUND")
                        
                        expectation.fulfill()
                    }
                    
                }
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testUpdateShoppingList() {
        let expectation = expectationWithDescription("Updates a shopping list")
        
        let fields = [
            "username": "ios_testuser_\(NSDate().timeIntervalSince1970)",
            "email": "email@email.com",
            "password": "password"
        ]
        
        GrocerestAPI.postUser(fields) { data, error in
            GrocerestAPI.postShoppingList(["name": "Lista della spesa"]) { data, error in
                let id = data["_id"].stringValue
                let fields = [
                    "name": "Pranzo di Natale"
                ]
                
                GrocerestAPI.updateShoppingList(id, fields: fields) { data, error in
                    print(data)
                    XCTAssertEqual(data["_id"].stringValue, id)
                    XCTAssertEqual(data["name"].stringValue, "Pranzo di Natale")
                    
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Shopping List's push updates
    
    func testShoppingListUpdates() {
        let expectation = expectationWithDescription("Shopping list's push updates")
        
        let fields = [
            "username": "ios_testuser_\(NSDate().timeIntervalSince1970)",
            "email": "email@email.com",
            "password": "password"
        ]
        
        GrocerestAPI.postUser(fields) { data, error in
            GrocerestAPI.postShoppingList(["name": "Lista della spesa"]) { data, error in
                let list = data
                var updates: [JSON] = [JSON]()
                
                GrocerestAPI.listenForShoppingListUpdates(list["_id"].stringValue) { update in
                    XCTAssertNil(update["error"].string)
                    
                    updates.append(update)
                    
                    if updates.count == 2 {
                        updates.sortInPlace { $0 > $1 }
                        
                        XCTAssertEqual(updates[0]["_id"].stringValue, list["_id"].stringValue)
                        XCTAssertEqual(updates[0]["name"].stringValue, "Lista della spesa")
                        
                        XCTAssertEqual(updates[1]["_id"].stringValue, list["_id"].stringValue)
                        XCTAssertEqual(updates[1]["name"].stringValue, "Pranzo di Natale")
                        
                        GrocerestAPI.stopListeningForShoppingListUpdates()
                        
                        expectation.fulfill()
                    }
                }
                
                self.delay(3) {
                    GrocerestAPI.updateShoppingList(data["_id"].stringValue, fields: ["name": "Pranzo di Natale"])
                }
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Test utilities
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}