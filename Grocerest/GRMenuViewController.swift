//
//  GRMenuViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Haneke
import Foundation
import UIKit
import RealmSwift
import SwiftyJSON
import SwiftLoader
import FBSDKCoreKit
import FBSDKLoginKit
import CoreLocation

// avoids JSON conflict (defined by both Haneke and SwiftyJSON
typealias JSON = SwiftyJSON.JSON

class GRMenuViewController: UIViewController, GRMenuProtocol, CLLocationManagerDelegate, GRMenuDataProtocol {
    
    var menuExist = false
    var productsDataSource: JSON?
    var menuNavigationController : UINavigationController?
    var locationManager:CLLocationManager!
    var myLocations: [CLLocation] = []
    var latitude : String?
    var longitude : String?
    let realm = try? Realm()
    
    var selectedMenuItem : Int = 0
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //currentFacebookProfile
        
        if (GrocerestAPI.userId == nil) {
            let welcomeViewController = GRWelcomeViewController()
            self.navigationController?.pushViewController(welcomeViewController, animated: false)
            return
        }
        getUserDataAndUpdateProfile()
        // setProductsDataSource()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    internal var managedView: GRMenuView {
        return self.view as! GRMenuView
    }
    
    override func loadView() {
        super.loadView()
        view = GRMenuView()
        managedView.delegate = self
    }
    
    // Refactor this mess
    
    func updateViewsWithUserProfile(_ social: Bool, userImage: String, userName:String, usName:String, lastname:String) {
        let type = AvatarType.menu
        managedView.profileImageView.setUserProfileAvatar(GRUser.sharedInstance.picture!, name: GRUser.sharedInstance.firstname!, lastName: GRUser.sharedInstance.lastname!, type: type)
        managedView.userNameLabel.text = "\(GRUser.sharedInstance.firstname!)  \(GRUser.sharedInstance.lastname!)"
        managedView.userUsername!.text =  GRUser.sharedInstance.username
    }
    
    /**
     1. To Profile
     */
    func profileButtonWasPressed(_ sender: UIButton) {
        navigateToDestination(GRProfileViewController())
    }
    
    /**
     2. To Home
     */
    func navigateToHome(_ sender: UIButton) {
        navigateToDestination(GRHomeViewController())
    }
    
    /**
     3. To My List
     */
    func navigateToMyList(_ sender: UIButton){
        navigateToDestination(GRMyListViewController())
    }
    
    /**
     4. To Products
     */
    func navigateToProducts(_ sender: UIButton) {
        let destViewController = GRProductsViewController()
        navigateToDestination(destViewController)
    }
    
    /**
     5. To Users
     */
    func navigateToUsers(_ sender: UIButton) {
        let destViewController = GRUsersViewController()
        navigateToDestination(destViewController)
    }
    
    /**
     6. To Brands
     */
    func navigateToBrands(_ sender: UIButton) {
        let destViewController = GRBrandsListViewController()
        navigateToDestination(destViewController)
    }
    
    /**
     7. To Settings
     */
    func navigateToSettings(_ sender:UIButton){
        let destViewController = GRSettingsViewController()
        navigateToDestination(destViewController)
    }
    
    /**
     8. To Help
     */
    func helpButtonWasPressed(_ sender:UIButton) {
        let destViewController = GRHelpViewController()
        navigateToDestination(destViewController)
    }
    
    /**
     Menu To destination
     
     - parameter destViewController:
     */
    func navigateToDestination(_ destViewController:UIViewController) {
        sideMenuController()?.setContentViewController(destViewController)
    }
    
    func logoutButtonWasPressed(_ sender: UIButton){
        Helper.removeNotificationsToken()
        GrocerestAPI.logout() { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                SwiftLoader.hide()
                self.logoutAnyWay()
                return
            }
            
            self.logoutAnyWay()
        }
    }
    
    func logoutAnyWay(){
        try? self.realm?.write {
            self.realm?.deleteAll()
        }
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "bearerToken")
        defaults.removeObject(forKey: "userId")
        
        defaults.synchronize()
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        let destViewController = GRWelcomeViewController()
        self.navigateToDestination(destViewController)
    }
    
    func getUserDataAndUpdateProfile() {
        let type = AvatarType.menu
        self.managedView.profileImageView.setUserProfileAvatar(GRUser.sharedInstance.picture!, name: GRUser.sharedInstance.firstname!, lastName: GRUser.sharedInstance.lastname!, type: type)
        managedView.userNameLabel.text = "\(GRUser.sharedInstance.firstname!) \(GRUser.sharedInstance.lastname!)"
        managedView.userUsername!.text =  GRUser.sharedInstance.username
    }
    
}
