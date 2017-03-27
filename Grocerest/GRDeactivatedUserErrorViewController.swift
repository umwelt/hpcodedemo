//
//  GRDeactivatedUserErrorViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import RealmSwift
import FBSDKLoginKit


class GRDeactivatedUserErrorViewController : UIViewController, GRDeactivatedUserErrorViewProtocol, UIGestureRecognizerDelegate {
    
    static var isAlreadyOpen = false
    
    let realm = try! Realm()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.setNavigationBarHidden(false, animated: true)
        navigationController?.isNavigationBarHidden = true
        // To disable iOS swipe back functionality
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate var managedView: GRDeactivatedUserErrorView {
        return self.view as! GRDeactivatedUserErrorView
    }
    
    override func loadView() {
        view = GRDeactivatedUserErrorView()
        managedView.delegate = self
    }
    
    // To disable iOS swipe back functionality
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func okButtonWasPressed() {
        // LOGOUT
        try! self.realm.write {
            self.realm.deleteAll()
        }
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "bearerToken")
        defaults.removeObject(forKey: "userId")
        defaults.synchronize()
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let destViewController = GRWelcomeViewController()
        
        sideMenuController()!.setContentViewController(destViewController)
        
        GRDeactivatedUserErrorViewController.isAlreadyOpen = false
    }
    
}
