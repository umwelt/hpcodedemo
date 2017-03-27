//
//  GRAPIErrorMessage.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import RealmSwift
import FBSDKLoginKit


class GREmailNotVerifiedErrorViewController : UIViewController, GREmailNotVerifiedErrorViewProtocol, UIGestureRecognizerDelegate {

    var email: String?
    static var isAlreadyOpen = false
    
    let realm = try! Realm()
    var delegate: GREmailNotVerifiedErrorViewProtocol?
    
    convenience init(email: String) {
        self.init()
        self.email = email
    }
    
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
    
    fileprivate var managedView: GREmailNotVerifiedErrorView {
        return self.view as! GREmailNotVerifiedErrorView
    }
    
    override func loadView() {
        view = GREmailNotVerifiedErrorView(email: self.email)
        managedView.delegate = self
    }
    
    // To disable iOS swipe back functionality
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func logoutMessageButtonWasPressed() {
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
        sideMenuController()!.sideMenu!.hideSideMenu()
        
        GREmailNotVerifiedErrorViewController.isAlreadyOpen = false
    }
    
    func retryMessageButtonWasPressed() {
        self.delegate?.retryMessageButtonWasPressed()
    }
    
}
