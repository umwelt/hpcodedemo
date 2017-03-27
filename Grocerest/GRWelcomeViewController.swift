//
//  GRWelcomeViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 29/10/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftLoader
import RealmSwift
import SwiftyJSON

class GRWelcomeViewController: UIViewController, GREmailNotVerifiedErrorViewProtocol {
    
    var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    let facebookReadPermissions = ["public_profile", "email", "user_birthday"]
    var registerViewModel = GRRegisterUserViewModel()
    var currentUser : GRUserViewModel?
    var productsDataSource: JSON?
    let userDefaults = UserDefaults.standard
    
    let debug = false
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // make it so that the side menu does not show up when showing this viewcontroller
    override func viewDidAppear(_ animated: Bool) {
        let menu = self.sideMenuController()!.sideMenu!
        menu.allowSwipeToOpen = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let menu = self.sideMenuController()?.sideMenu
        if let m = menu {
            m.allowSwipeToOpen = true
        }
        // if we were hidden because of facebook performing safari based login
        // we must remove the loader.
        SwiftLoader.hide()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsOnTap = false
        navigationController?.isNavigationBarHidden = true
        automaticLogin()
    }
    
    func automaticLogin() {
         if let userId = userDefaults.object(forKey: "userId") as! String?,
            let bToken = userDefaults.object(forKey: "bearerToken") as! String? {
        
            SwiftLoader.show(title: Constants.UserMessages.loginAutomatic, animated: true)            

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                GrocerestAPI.restoreUserCredentials(bToken, userId: userId)
                GrocerestAPI.getUser(userId) { data, error in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        SwiftLoader.hide()
                        
                        if let serverError = data["error"]["code"].string {
                            if serverError == "E_UNAUTHORIZED" {
                                self.navigationController?.popToRootViewController(animated: true)
                            } else if serverError == "E_EMAILNOTVERIFIED" {
                                if !GREmailNotVerifiedErrorViewController.isAlreadyOpen {
                                    GREmailNotVerifiedErrorViewController.isAlreadyOpen = true
                                    SwiftLoader.hide()
                                    let messageView = GREmailNotVerifiedErrorViewController()
                                    messageView.delegate = self
                                    UIApplication.topViewController()?.navigationController?.pushViewController(messageView, animated: true)
                                }
                            }
                        }
                        
                        return
                    }
                    
                    self.getUserSuccess(data)
                }

            }
        } else {
            SwiftLoader.hide()
        }
        
    }
    
    func retryMessageButtonWasPressed() {
        print("Retry button was pressed")
        SwiftLoader.show(title: "Sincronizzazione…", animated: true)
        automaticLogin()
    }
    
    func getUserSuccess(_ data: JSON) {
        if let bToken =  data["bearerToken"].string,
            let uid = data["userId"].string {
            self.userDefaults.setValue(bToken, forKey: "bearerToken")
            self.userDefaults.setValue(uid, forKey: "userId")
            self.userDefaults.synchronize()
        }
        
        saveCurrentUserAfterLogin(data, login: true)
        
        getUserProductsList() {
            SwiftLoader.hide()
            let homeViewController = GRHomeViewController()
            self.navigationController?.setViewControllers([homeViewController], animated: true)
        }
        
        GREmailNotVerifiedErrorViewController.isAlreadyOpen = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private var managedView: GRWelcomeView {
        return self.view as! GRWelcomeView
    }
    
    override func loadView() {
        super.loadView()
        view = GRWelcomeView()
        managedView.delegate = self
        managedView.addGrowAnimation(nil)
    }
    
    /// This is the login action for email users
    func accessButtonWasPressed(_ accessButton: UIButton){
        let grLoginViewController = GRLoginViewController()
        navigationController?.pushViewController(grLoginViewController, animated: true)
    }
    
    
    /// Initiates registration workflow for email users
    func registrationButtonPressed(_ registrationtButton: UIButton){
        let grRegistrationViewController = GRRegistrationViewController()
        navigationController?.pushViewController(grRegistrationViewController, animated: true)
    }
    
    
    /* 1. Facebook Access workflow initiate
     After button is pressed we call FBSDKLogin Manager to gain access to Access Token
     */
    func facebookButtonPressed(_ facebookButton: UIButton) {
        SwiftLoader.show(title: "Accesso Facebook…", animated: true)
        fbLoginManager.loginBehavior = .systemAccount
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: facebookReadPermissions, from: self) { result, error in

            guard error == nil else {
                SwiftLoader.hide()
                self.showValidationAlertWithTitleAndMessage("Attenzione", message: (error?.localizedDescription)!)
                return
            }
            
            // -> Request Facebook Public Profile For User
            SwiftLoader.hide()
            self.getUserdata()
        }
    }
    
    
    // Ugly as hell
    var dict : NSDictionary!
    
    /* 2. Requesting fields to Graph
     This function is also a router to Login/Register
     Once we collect user data from Facebook we try to login the user
     With id & token -> if fails then is a new user
     
     */
    
    func getUserdata() {
        guard FBSDKAccessToken.current() != nil else { return }
        
        SwiftLoader.show(title: "Accesso Facebook…", animated: true)
     
        let requestedFields = "id, name, first_name, last_name, picture.type(large), email, birthday"
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": requestedFields])
            .start { connection, result, error in
            
            guard error == nil, let res = result else { return }
            
            let fb = JSON(res)
            let fbId = fb["id"].stringValue
            
            let facebookUser = GRFacebookUser()
            facebookUser.id = fbId
            facebookUser.name = fb["first_name"].stringValue
            facebookUser.lastname = fb["last_name"].stringValue
            facebookUser.email = fb["email"].stringValue
            facebookUser.picture = fb["picture"]["data"]["url"].stringValue
            
            let realm = try? Realm()
            try? realm?.write {
                realm?.add(facebookUser, update: true)
            }
            
            let token = FBSDKAccessToken.current().tokenString as String
            let fbDict = ["id": fbId, "accessToken": token]
            self.registerViewModel.facebookData = fbDict
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.loginUser(["facebook": fbDict])
            }
        }
    }
    
    // 2.1 if this is a login->
    
    func loginUser(_ userData: [String: Any]) {
        GrocerestAPI.login(userData) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                
                if let e = error {
                    self.showValidationAlertWithTitleAndMessage("Attenzione", message: e.localizedDescription)
                } else {
                    let errorCode = data["error"]["code"].string
                    if errorCode == "E_UNAUTHORIZED" {
                        self.showControllerForDisplayNameInput()
                    } else if errorCode == "E_EMAILNOTVERIFIED" {
                        print("EMAIL NOT VERIFIED")
                    } else {
                        self.showValidationAlertWithTitleAndMessage("Attenzione", message: data["error"]["message"].stringValue)
                    }
                }
                
                SwiftLoader.hide()
                return
            }

            if let bToken =  data["bearerToken"].string,
                let uid = data["userId"].string {
                self.userDefaults.setValue(bToken, forKey: "bearerToken")
                self.userDefaults.setValue(uid, forKey: "userId")
                self.userDefaults.synchronize()
            }
  
            self.automaticLogin()
        }
    }
    
    /**
     3. There's no username and wen need one for registration
     */
    fileprivate func showControllerForDisplayNameInput() {
        let data: [String: Any] = [
            "email": registerViewModel.email,
            "username": registerViewModel.username,
            "display_name": registerViewModel.username,
            "firstname": registerViewModel.name,
            "lastname": registerViewModel.lastname,
            "facebook": registerViewModel.facebookData
        ]
        let registrationViewController = GRRegistrationViewController()
        registrationViewController.registerData = data
        self.navigationController?.pushViewController(registrationViewController, animated: true)
        
    }
    
    
    /* 4. Ok lets create a user
     */
    
    func createUser(_ userData: [String: Any]) {
        SwiftLoader.show(title: "Sincronizzazione…", animated: true)
        
        GrocerestAPI.postUser(userData) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                
                if let e = error {
                    self.showValidationAlertWithTitleAndMessage("Attenzione", message: e.localizedDescription)
                } else if data["error"]["code"].stringValue == "E_UNAUTHORIZED" {
                    self.showControllerForDisplayNameInput()
                } else {
                    let errorMessage = data["error"]["message"].stringValue
                    self.showValidationAlertWithTitleAndMessage("Attenzione", message: errorMessage)
                }
                
                SwiftLoader.hide()
                return
            }
            
            if data["bearerToken"].isEmpty {
                SwiftLoader.hide()
                if let errorMessage = data["error"]["message"].string {
                    self.showValidationAlertWithTitleAndMessage("Attenzione", message: errorMessage)
                }
                return
            }
            
            if let bToken =  data["bearerToken"].string,
                let uid = data["userId"].string {
                self.userDefaults.setValue(bToken, forKey: "bearerToken")
                self.userDefaults.setValue(uid, forKey: "userId")
                self.userDefaults.synchronize()
            }            
            
            /*More ugly stuff to kill
             Also fix the name of properties
             */
            saveCurrentUserAfterLogin(data, login: false)
            //  self.setProductsDataSource(false)
            self.navigateToHome(false)
        }
    }
    
    
    func navigateToHome(_ login: Bool) {
        
        if login {
            getUserProductsList()
            let homeViewController = GRHomeViewController()
            self.navigationController?.setViewControllers([homeViewController], animated: true)
        } else {
            getUserProductsList()
            let categoryListViewController = GRCategoryListViewController()
            
            navigationController?.present(categoryListViewController, animated: true, completion: { () -> Void in
                let homeViewController = GRHomeViewController()
                categoryListViewController.onDismissed = {
                    homeViewController.downloadProducts(reset: true)
                }
                self.navigationController?.setViewControllers([homeViewController], animated: true)
            })
        }
        
        
    }
    
    /// Alert on errors
    
    fileprivate func showValidationAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    /// If there is input text ok button enabled = true
    func textChanged(_ sender:AnyObject) {
        let tf = sender as! UITextField
        // enable OK button only if there is text
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        alert.actions[0].isEnabled = (tf.text != "")
    }
    
}
