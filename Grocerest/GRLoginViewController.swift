//
//  GRLoginViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 30/10/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftLoader
import RealmSwift


class GRLoginViewController: UIViewController, UITextFieldDelegate, GRLoginViewProtocol, GREmailNotVerifiedErrorViewProtocol {

    fileprivate var userData : Dictionary <String, String> = [:]
    let realm = try! Realm()
    var productsDataSource: JSON?
    var authViewModel = GRAuthViewModel()
    let userDefaults = UserDefaults.standard


    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.setNavigationBarHidden(false, animated: true)
        navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate var managedView: GRLoginView {
        return self.view as! GRLoginView
    }

    override func loadView() {
        view = GRLoginView()
        managedView.delegate = self
        managedView.usernameField?.delegate = self
        managedView.passwordField?.delegate = self
    }

    func backButtonPressed(_ backButton: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

    }


    func loginButtonWasPressed() {

        authViewModel.username = managedView.usernameField?.text
        authViewModel.password = managedView.passwordField?.text

        do {
            let authingUser = try authViewModel.loginUser()
            
            let dictLogin = [
                "username": authingUser.username,
                "password": authingUser.password
            ]
            loginUser(dictLogin)

        } catch GRAuthViewModel.InputError.inputMissing {
            let messageView = GRMessageViewController(icon: UIImage(named: "error_icon"), title: "ATTENZIONE!", message: "Username & Password sono richiesti!", backPops: 1)
            navigationController?.pushViewController(messageView, animated: true)
        } catch GRAuthViewModel.InputError.inputInvalid {
            let messageView = GRMessageViewController(icon: UIImage(named: "error_icon"), title: "ATTENZIONE!", message: "Input non valido", backPops: 1)
            navigationController?.pushViewController(messageView, animated: true)
        } catch{
            let messageView = GRMessageViewController(icon: UIImage(named: "error_icon"), title: "ATTENZIONE!", message: "Errore imprevisto", backPops: 1)
            navigationController?.pushViewController(messageView, animated: true)
        }

    }

    // - MARK: Keyboard

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginButtonWasPressed()
        view.endEditing(true)
        return true
    }


    // Login

    func loginUser(_ userData: [String: Any]) {

        SwiftLoader.show(title: "Sincronizzazione…", animated: true)

        GrocerestAPI.login(userData) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                SwiftLoader.hide()
                
                if data["userId"] == nil {
                    
                    let messageView = GRMessageViewController(icon: UIImage(named: "error_icon"), title: "ATTENZIONE!", message: "Nome utente o password non validi", backPops: 1, forgottenLinkVisible: true)
                    self.navigationController?.pushViewController(messageView, animated: true)
                    
                } else if data["error"]["code"].stringValue == "E_UNAUTHORIZED" {
                    
                    GrocerestAPI.userId = nil
                    GrocerestAPI.bearerToken = nil
                    self.navigationController?.popToRootViewController(animated: true)
                    
                } else {
                    
                    let messageView = GRMessageViewController(icon: UIImage(named: "error_icon"), title: "ATTENZIONE!", message: data["error"]["message"].stringValue, backPops: 1)
                    self.navigationController?.pushViewController(messageView, animated: true)
                    
                }
                
                return
            }
            
            self.userDefaults.setValue(data["bearerToken"].string!, forKey: "bearerToken")
            self.userDefaults.setValue(data["userId"].string!, forKey: "userId")
            self.userDefaults.synchronize()

            self.getUser(data["userId"].string!)
        }
    }
    
    func getUser(_ userId: String) {
        GrocerestAPI.getUser(userId) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                SwiftLoader.hide()
                
                if data["error"]["code"].stringValue == "E_EMAILNOTVERIFIED" {
                    if !GREmailNotVerifiedErrorViewController.isAlreadyOpen {
                        GREmailNotVerifiedErrorViewController.isAlreadyOpen = true
                        print("Email not verified")
                        let messageView = GREmailNotVerifiedErrorViewController()
                        messageView.delegate = self
                        UIApplication.topViewController()?.navigationController?.pushViewController(messageView, animated: true)
                    }
                }
                
                return
            }
            
            self.getUserSuccess(data)
        }
    }
    
    func retryMessageButtonWasPressed() {
        print("Retry button was pressed")
        SwiftLoader.show(title: "Sincronizzazione…", animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.getUser(self.userDefaults.value(forKey: "userId") as! String)
        }
    }
    
    func getUserSuccess(_ data: JSON) {
        
        
        saveCurrentUserAfterLogin(data, login: true)
        getUserProductsList()
        
        SwiftLoader.hide()
        let homeViewController = GRHomeViewController()
        
        self.navigationController?.setViewControllers([homeViewController], animated: true)
        GREmailNotVerifiedErrorViewController.isAlreadyOpen = false
    }


    func navigateToCategories() {

        let categoryListViewController = GRCategoryListViewController()

        navigationController?.present(categoryListViewController, animated: true, completion: { () -> Void in
            let homeViewController = GRHomeViewController()
            categoryListViewController.onDismissed = {
                homeViewController.downloadProducts(reset: true)
            }
            self.navigationController?.pushViewController(homeViewController, animated: true)
        })

    }

    // Tools

    func showPrivacy(_ sender: UIButton) {
        let documentsViewController = GRDocumentsViewController()
        documentsViewController.pageTitle = "Privacy Policy"
        documentsViewController.document = "privacy"
        self.navigationController?.pushViewController(documentsViewController, animated: true)
    }

    func showTOS(_ sender:UIButton) {
        let documentsViewController = GRDocumentsViewController()
        documentsViewController.pageTitle = "Termini di Servizio"
        documentsViewController.document = "tos"
        self.navigationController?.pushViewController(documentsViewController, animated: true)
    }

    func showForgottenCredentials(_ sender: UIButton) {
      let credentialsRecoveryViewController = GRCredentialsRecoveryViewController()
      self.navigationController?.pushViewController(credentialsRecoveryViewController, animated: true)
    }

}
