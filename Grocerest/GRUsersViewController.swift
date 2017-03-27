//
//  GRUsersViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 18/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SwiftLoader

class GRUsersViewController: UIViewController, GRToolBarProtocol, ENSideMenuDelegate {
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        super.loadView()
        view = GRUsersView()
        managedView.delegate = self
        managedView.navigationToolBar?.delegate = self
    }
    
    fileprivate var managedView: GRUsersView {
        return self.view as! GRUsersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedView.navigationToolBar?.isThisBarWithTitle(true, title: "Utenti")
        managedView.navigationToolBar?.scannerButton?.isHidden = true
        self.sideMenuController()?.sideMenu?.delegate = self
        refresh()
    }
    
    func refresh() {
        SwiftLoader.show(animated: true)
        
        GrocerestAPI.getTopUsers(["max": 20]) { json, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: json, and: error) {
                return
            }
            
            var users = [GRUserView]()
            
            for userData in json.arrayValue {
                let userView = GRUserView()
                userView.populateWith(userData)
                userView.onTap = {
                    if GrocerestAPI.userId == userData["_id"].stringValue {
                        // Personal profile
                        let userProfileViewController = GRProfileViewController()
                        userProfileViewController.showBackButton()
                        self.navigationController?.pushViewController(userProfileViewController, animated: true)
                    } else {
                        // Public profile
                        let userProfileViewController = GRUserProfileViewController()
                        userProfileViewController.author = userData
                        self.navigationController?.pushViewController(userProfileViewController, animated: true)
                    }
                }
                users.append(userView)
            }
            
            self.managedView.users = users
            SwiftLoader.hide()
        }
    }
    
    /**
     *  Toolbar
     */
    
    func menuButtonWasPressed(_ menuButton: UIButton) {
        toggleSideMenuView()
    }
    
    func searchButtonWasPressed(_ searchButton: UIButton){
        let usersSearch = GRUsersSearchViewController()
        self.navigationController?.pushViewController(usersSearch, animated: true)
    }
    
}
