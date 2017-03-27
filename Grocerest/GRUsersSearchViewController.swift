//
//  GRUsersSearchViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 24/10/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SwiftLoader

class GRUsersSearchViewController: UIViewController, UITableViewDataSource {
    
    var users = [JSON]()
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func loadView() {
        super.loadView()
        view = GRUsersSearchView()
        managedView.delegate = self
    }
    
    fileprivate var managedView: GRUsersSearchView {
        return self.view as! GRUsersSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedView.usersDatasource = self
        
        managedView.onBackButtonTap = {
            self.navigationController?.popViewController(animated: true)
        }
        
        managedView.onSearchFieldReturn = { text in
            print("Search string:", text)
            
            let parameters: [String: Any] = [
                "search": text,
                "includeMe": false
            ]
            
            SwiftLoader.show(animated: true)
            
            GrocerestAPI.findUserByName(parameters) { json, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: json, and: error) {
                    return
                }
                
                let results = json.arrayValue
                self.users = results
                self.managedView.numberOfResults = results.count
                self.managedView.refreshUsersTable()
                SwiftLoader.hide()
            }
            
        }
        
        managedView.focusOnSearchField()
    }
    
    // Users' datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user")!
        var userView: GRUserView!
        
        if cell.contentView.subviews.count > 0 {
            // Reuse cell
            userView = cell.contentView.subviews.first! as! GRUserView
        } else {
            // Creates cell
            userView = GRUserView()
            cell.contentView.addSubview(userView)
            userView.snp.makeConstraints { make in
                make.center.equalTo(cell.contentView)
            }
        }
        
        // Populates cell
        let userData = users[indexPath.row]
        userView.populateWith(userData)
        userView.onTap = {
            self.managedView.dismissKeyboard()
            // Public profile
            let userProfileViewController = GRUserProfileViewController()
            userProfileViewController.author = userData
            self.navigationController?.pushViewController(userProfileViewController, animated: true)
        }
        
        return cell
    }
    
}
