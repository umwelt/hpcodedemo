//
//  GRCreateListViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 24/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftLoader
import Haneke
import RealmSwift
import FBSDKCoreKit
import FBSDKLoginKit
import Contacts


class GRCreateListViewController: UIViewController, GRToolBarProtocol, GRCreateListProtocol, UITextFieldDelegate, GRFriendsDataProtocol{
    
    var newListName : String?
    var shoppingList : JSON?
    var friendsData = [[String:Array<String>]]()
    var emailsFriends = [String]()
    var allFriends : [JSON]?
    var selected : [JSON]?
    var product : JSON?
    
    var onMemoryProduct = ""
    var withProduct = false
    let realm = try! Realm()
    
    var delegate : GRMoreActionsForProductProtocol?
    var listDelegate:GRUpdateHomeListProtocol?
    var contactStore = CNContactStore()
   
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allFriends = []
        managedView.nameListTextField?.delegate = self
        managedView.nameListTextField?.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector:#selector(GRCreateListViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(GRCreateListViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if withProduct {
            self.managedView.productView.isHidden = false
            loadProduct()
        }
        
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate var managedView: GRCreateListView {
        return self.view as! GRCreateListView
    }
    
    override func loadView() {
        view = GRCreateListView()
        managedView.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        guard let kbSizeValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let kbDurationNumber = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        animateToKeyboardHeight(kbSizeValue.cgRectValue.height, duration: kbDurationNumber.doubleValue)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        guard let kbDurationNumber = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        animateToKeyboardHeight(0, duration: kbDurationNumber.doubleValue)
                self.managedView.productView.snp.remakeConstraints { (make) -> Void in
                    make.width.equalTo(self.managedView)
                    make.height.equalTo(75)
                    make.bottom.equalTo(0)
                    make.left.equalTo(0)
                }
        
    }
    
    func animateToKeyboardHeight(_ kbHeight: CGFloat, duration: Double) {
        
        self.managedView.productView.snp.remakeConstraints { (make) in
            make.width.equalTo(self.managedView)
            make.height.equalTo(75)
            make.bottom.equalTo(-kbHeight)
            make.left.equalTo(0)
        }
    }
    
    
    func loadProduct() {
        
        if let name = product?["display_name"].string {
            managedView.productMainLabel.text = name
        }
        
        if let brand = product?["brand"].stringValue {
            managedView.brandLabel.text = productJONSToBrand(data: product!)
        }
        
        if let category = product?["category"].string {
            self.managedView.reviewCategoryImageView.image = UIImage(named: category)
        }
        
    }
    
    
    // delegation
    func closeButtonWasPressed(_ sender: UIButton){
        
        if (self.navigationController != nil) {
            self.navigationController?.popViewController(animated: false)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
        
        
    }
    
    func disclosureButtonWasPressed(_ sender: UIButton){
        print("open disclosure")
    }
    
    // - MARK: Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func listNameReady(_ sender: UITextField) {
        /// Populate list name
        // newListName = sender.text
    }
    
    func createListWasPressed() {
        SwiftLoader.show(animated: true)
        
        let trimmedString = managedView.nameListTextField?.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if trimmedString!.characters.count == 0 {
            showValidationAlertWithTitleAndMessage("Attenzione", message: Constants.UserMessages.noEmptyListName)
            SwiftLoader.hide()
            return
        }

        
        var fields: [String: Any] = [
            "name": managedView.nameListTextField?.text
        ]
        
        var collaborator = [String]()
        if let s = selected {
            if (s.count) > 0 {
                for item in selected! {
                    collaborator.append("\(item["_id"].string!)")
                }
            }
        }
        
        fields["invited"] = collaborator
        
        GrocerestAPI.postShoppingList(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                if error != nil {
                    SwiftLoader.hide()
                } else if data["error"]["code"].stringValue == "E_UNAUTHORIZED" {
                    self.noUserOrInvalidToken()
                }
                return
            }
            
            if self.withProduct {
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.0) {
                    SwiftLoader.hide()
                    self.postItemForNewList(data)
                }
                return
            }
            
            SwiftLoader.hide()
            self.navigateToListWithData(data)
        }
    }
    
    
    func navigateToListWithData(_ data:JSON) {
        
        let presentingVC = self.presentingViewController!
        let navigationController = presentingVC is UINavigationController ? presentingVC as? UINavigationController : presentingVC.navigationController
        let shoppingListViewController = GRShoppingListViewController()
        listDelegate?.updateListProtocol()
        shoppingListViewController.shoppingList = data        
        
        self.dismiss(animated: true) { () -> Void in
            navigationController?.pushViewController(shoppingListViewController, animated: true)
            
        }
    }
    
    func postItemForNewList(_ listData:JSON) {
        let fields: [String: Any] = [
            "name": product!["display_name"].string!,
            "product": product!["_id"].string!,
            "brand": product!["brand"].string!,
            "category": product!["category"].string!,
            "generic": false,
            "custom": false
        ]
        
        GrocerestAPI.postShoppingListItem(listData["_id"].string!, fields: fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                if error != nil {
                    SwiftLoader.hide()
                } else if data["error"]["code"].stringValue == "E_UNAUTHORIZED" {
                    self.noUserOrInvalidToken()
                }
                return
            }
            
            self.dismiss(animated: true) {
                self.delegate?.dismissNestedModal(listData)
            }
        }
    }
    
    func shareListWasPressed(_ sender:UIButton) {
        findGrocerestFriends()
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
    
    
    
    func findGrocerestFriends() {
        SwiftLoader.show(animated: true)
        
        var fields = [String: Any]()
        
        requestForAccess { accessGranted in
            fields["emails"] = getUserContacts()
        }
        
        GrocerestAPI.findUserByEmail(fields) {data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                if error != nil {
                    SwiftLoader.hide()
                } else if data["error"]["code"].stringValue == "E_UNAUTHORIZED" {
                    self.noUserOrInvalidToken()
                }
                return
            }
            
            for user in data.arrayValue {
                if GRUser.sharedInstance.id! != user["_id"].string! {
                    self.allFriends?.append(user)
                }
            }
            
            SwiftLoader.hide()
            
            let addFriendsViewController = GRAddFriendsViewController()
            addFriendsViewController.allFriends = self.allFriends
            addFriendsViewController.listName = self.managedView.nameListTextField?.text
            addFriendsViewController.selectedFriends?.removeAll()
            addFriendsViewController.dataDelegate = self
            addFriendsViewController.withProduct = self.withProduct
            
            if let product = self.product {
                addFriendsViewController.product = product
            }
            
            self.allFriends = []
            addFriendsViewController.modalPresentationStyle = .overCurrentContext
            self.present(addFriendsViewController, animated: true, completion: nil)
        }
    }
    
    
    /**
     *  Data Protocol
     */
    func addThisFriendsToList(_ friends:[JSON], listName: String) {
        managedView.nameListTextField?.text = listName
        selected = friends
    }
    
        
    /**
     *  Text field
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.managedView.productView.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(self.managedView)
            make.height.equalTo(75)
            make.top.equalTo(378)
            make.left.equalTo(0)
        }
        listNameReady(textField)
        //textField.selectAll(textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        listNameReady(textField)
        createListWasPressed()
        textField.resignFirstResponder()
//           findGrocerestFriends()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.managedView.productView.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(self.managedView)
            make.height.equalTo(75)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
        }
        
        if (textField.text != "") {
            managedView.confirmButton!.isEnabled = true
            return
        }
        
        managedView.confirmButton!.isEnabled = true
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        /* TODO: figure out how to filter paste again
        if (action == #selector(NSObject.paste(_:))) {
            return false
        }
        if (action == #selector(NSObject.select(_:))) {
            return true
        }
        if (action == #selector(NSObject.selectAll(_:))) {
            return true
        }
        */
        return super.canPerformAction(action, withSender: sender)
    }
    
    
    /// Alert on errors
    func showValidationAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    

    func noUserOrInvalidToken() {
        try! self.realm.write {
            self.realm.deleteAll()
        }
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "bearerToken")
        defaults.removeObject(forKey: "userId")
        defaults.synchronize()
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
      
        self.dismiss(animated: true) { 
            let window:UIWindow? = (UIApplication.shared.delegate?.window)!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window!.rootViewController = storyboard.instantiateInitialViewController()
        }
    }
    
}
