//
//  GRMoreActionsForListViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 10/02/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftLoader
import Contacts

class GRMoreActionsForListViewController: UIViewController, UIScrollViewDelegate {
    
    var listId = ""
    var list : JSON?
    var delegate = GRShoppingListViewController()
    var execute = false
    
    var friendsData = [[String:Array<String>]]()
    var emailsFriends = [String]()
    var allFriends : [JSON]?
    var selected : [JSON]?
    var contactStore = CNContactStore()
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate var managedView: GRMoreActionsForListView {
        return self.view as! GRMoreActionsForListView
    }
    
    override func loadView() {
        super.loadView()
        view = GRMoreActionsForListView()
        managedView.delegate = self
    }
    

    
    func closeButtonWasPressed(_ sender:UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    // Delegation
    
    func importWasPressed(_ sender:UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func duplicateWasPressed(_ sender:UIButton) {
        showDuplicationAlertWithTitleAndMessage(Constants.UserMessages.warning, message: Constants.UserMessages.listDuplication)

    }
    
    func showDuplicationAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.UserMessages.ok, style: .destructive) { (alert: UIAlertAction) -> Void in
            self.executeDuplication()
        }
        let cancel = UIAlertAction(title: Constants.UserMessages.anulla, style: .default) { (alert: UIAlertAction) -> Void in
            DispatchQueue.main.async { SwiftLoader.hide() }
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func executeDuplication(){
        var fields = [String:String]()
        fields["name"] = "Copia di \(list!["name"].string!)"
        
        SwiftLoader.show(animated: true)

        GrocerestAPI.cloneShoppingList(self.listId, fields: fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.showErrorAlertWithTitleAndMessage(Constants.UserMessages.warning, message: Constants.UserMessages.systemError)
                }
                return
            }
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.dismiss(animated: false, completion: {
                    self.delegate.listWasDeleted()
                })
            }
            
        }
    }
    
    
    func modifyWasPressed(_ sender:UIButton) {
        let modifyViewController = GRModifyListViewController()
        modifyViewController.modalPresentationStyle = .fullScreen
        modifyViewController.listId = listId
        modifyViewController.list =  self.list
        present(modifyViewController, animated: false, completion: nil)
    }
    
    
    func requestForAccess(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async {
                            self.showMessage(Constants.AppLabels.warningToAccessContacts)
                        }
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    
    
    func showMessage(_ message: String) {
        let alertController = UIAlertController(title: "Attenzione", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "Cancella", style: UIAlertActionStyle.default) { (action) -> Void in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let okAction = UIAlertAction(title: "Apri settings", style: UIAlertActionStyle.default) { (action) -> Void in
            UIApplication.shared.openURL(URL(string:"prefs:root")!)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(dismissAction)
        alertController.addAction(okAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func exportWasPressed(_ sender:UIButton) {
        requestForAccess { accessGranted in
            SwiftLoader.show(title: "Caricamento contatti", animated: true)
            self.allFriends = []
            SwiftLoader.show(title: "Verifico contatti", animated: true)
            
            GrocerestAPI.findUserByEmail(["emails": getUserContacts()]) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                        self.showErrorAlertWithTitleAndMessage(Constants.UserMessages.warning, message: Constants.UserMessages.systemError)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    for user in data.arrayValue {
                        if GRUser.sharedInstance.id! != user["_id"].string! {
                            self.allFriends?.append(user)
                        }
                    }
                    
                    SwiftLoader.hide()
                    let addFriendsViewController = GRAddFriendsViewController()
                    addFriendsViewController.allFriends = self.allFriends
                    addFriendsViewController.listName = self.list!["name"].string!
                    addFriendsViewController.selectedFriends?.removeAll()
                    addFriendsViewController.fromList = true
                    addFriendsViewController.list = self.list
                    
                    self.present(addFriendsViewController, animated: false, completion: nil)
                }
            }
        }
    }
    
    
    // MARK: List Deletion
    func deleteWasPressed(_ sender:UIButton) {
        showWarningAlertWithTitleAndMessage(Constants.UserMessages.warning, message: Constants.UserMessages.listDeletion)
    }
    
    func showWarningAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.UserMessages.ok, style: .destructive) { (alert: UIAlertAction) -> Void in
            self.executeDeletion()
        }
        let cancel = UIAlertAction(title: Constants.UserMessages.anulla, style: .default) { (alert: UIAlertAction) -> Void in
            DispatchQueue.main.async { SwiftLoader.hide() }
            self.execute = false
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func executeDeletion() {
        SwiftLoader.show(animated: true)
        
        GrocerestAPI.deleteShoppingList(self.listId){ data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.showErrorAlertWithTitleAndMessage(Constants.UserMessages.warning, message: Constants.UserMessages.systemError)
                }
                return
            }
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.dismiss(animated: false, completion: { () -> Void in
                    self.delegate.listWasDeleted()
                })
            }
        }
    }
    
    // MARK: Reset List
    func resetWasPressed(_ sender:UIButton) {
        
        
        let alert = UIAlertController(title: Constants.UserMessages.warning, message: Constants.UserMessages.listReset, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.UserMessages.ok, style: .destructive) { (alert: UIAlertAction) -> Void in
            GrocerestAPI.resetShoppingList(self.listId) { data, error in
                SwiftLoader.show(animated: true)
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                        self.showErrorAlertWithTitleAndMessage(Constants.UserMessages.warning, message: Constants.UserMessages.systemError)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: {
                        self.delegate.listWasReset()
                    })
                }
            }
        }
        
        let cancel = UIAlertAction(title: Constants.UserMessages.anulla, style: .default) { (alert: UIAlertAction) -> Void in
            DispatchQueue.main.async { SwiftLoader.hide() }
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    
    

    // MARK: Handle net errors
    
    func showErrorAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.UserMessages.ok, style: .default) { (alert: UIAlertAction) -> Void in
            
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
