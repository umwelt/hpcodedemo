//
//  GRInviteTableViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 18/03/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftLoader
import Google
import Contacts


class GRInviteTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GRInviteProtocol, UITextFieldDelegate {
    
    var dataSource: [JSON]?
    var tableView : UITableView?
    var emailsFriends = NSMutableArray()
    var selectedEmailFriends = NSMutableArray()
    let searchController = UISearchController(searchResultsController: nil)
    let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey]
    
    var bottomButton = UIButton()
    var contactStore = CNContactStore()
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatasource()
        setupViews()
        
        self.managedView.searchTextField?.delegate = self
        createInviteButton()
        self.automaticallyAdjustsScrollViewInsets = true
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
    
    fileprivate var managedView: GRInviteView {
        return self.view as! GRInviteView
    }
    
    override func loadView() {
        super.loadView()
        view = GRInviteView()
        managedView.delegate = self
    }
    
    
    func setupViews() {
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.bounces = true
        tableView?.register(GRGenericPersonTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.backgroundColor = UIColor.clear
        tableView?.separatorStyle = .singleLine
        tableView?.isHidden = false
        tableView?.rowHeight = 120 / masterRatio
        tableView?.keyboardDismissMode = .onDrag
        tableView?.allowsMultipleSelection = true
        tableView?.contentInset = UIEdgeInsets.zero
        
        managedView.addSubview(tableView!)
        
        self.tableView?.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(self.managedView.snp.width)
            make.top.equalTo((self.managedView.searchTextField?.snp.bottom)!)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.emailsFriends.count > 0 {
            return self.emailsFriends.count
        }
        return 0
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : GRGenericPersonTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRGenericPersonTableViewCell
        
        if (cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRGenericPersonTableViewCell
        }
        
        cell.selectionStyle = .none
        let contact = self.emailsFriends.object(at: indexPath.row) as! CNContact
        
        if self.selectedEmailFriends.contains(contact.emailAddresses[0].value) {
            cell.cellWasSelected()
        } else {
            cell.cellWasdeSelected()
        }
        
        OperationQueue.main.addOperation { 
            if contact.givenName != "" {
                cell.userMainLabel?.text = "\(contact.givenName) \(contact.familyName)"
            } else {
                cell.userMainLabel?.text = "\(contact.emailAddresses[0].value)"
            }
        }
        
        
        
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: GRGenericPersonTableViewCell! = tableView.cellForRow(at: indexPath) as! GRGenericPersonTableViewCell
        let contact = self.emailsFriends.object(at: indexPath.row) as! CNContact
        cell.cellWasSelected()
        
        if selectedEmailFriends.contains(contact.emailAddresses[0].value) {
            print("existed")
        } else {
            self.selectedEmailFriends.add(contact.emailAddresses[0].value)
            self.getReadyForInvite()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: GRGenericPersonTableViewCell! = tableView.cellForRow(at: indexPath) as! GRGenericPersonTableViewCell
        let contact = self.emailsFriends.object(at: indexPath.row) as! CNContact
        cell.cellWasdeSelected()
        
        
        if selectedEmailFriends.contains(contact.emailAddresses[0].value) {
            self.selectedEmailFriends.remove(contact.emailAddresses[0].value)
            self.getReadyForInvite()
            
        } else {
            print("does not exist")
        }
        
    }
    //
    //    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    //        return index
    //    }
    
    
    
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
            SwiftLoader.hide()
            self.dismiss(animated: true, completion: nil)
        }
        
        let okAction = UIAlertAction(title: "Apri settings", style: UIAlertActionStyle.default) { (action) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            SwiftLoader.hide()
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(dismissAction)
        alertController.addAction(okAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func setDatasource() {
        SwiftLoader.show(title: "Caricando Contatti", animated: true)
        OperationQueue.main.addOperation {
            self.requestForAccess { (accessGranted) in
                self.emailsFriends.removeAllObjects()
                let request = CNContactFetchRequest(keysToFetch: self.keysToFetch as [CNKeyDescriptor])
                request.unifyResults = true
                
                try! self.contactStore.enumerateContacts(with: request) {contact, stop  in
                    if contact.emailAddresses.count > 0 {
                        self.emailsFriends.add(contact)
                    }
                }
                
                self.tableView?.reloadData()
            }
        }
        OperationQueue.main.addOperation {
            SwiftLoader.hide()
        }
        
    }
    
    
    func searchContacts(_ query:String) {
        
        OperationQueue.main.addOperation {
            self.emailsFriends.removeAllObjects()
            
            let predicate = CNContact.predicateForContacts(matchingName: query)
            
            let store = CNContactStore()
            
            self.managedView.searchTextField?.resignFirstResponder()
            
            do {
                let contacts = try store.unifiedContacts(matching: predicate,
                    keysToFetch: self.keysToFetch as [CNKeyDescriptor])
                
                for contact in contacts {
                    if contact.emailAddresses.count > 0 {
                        self.emailsFriends.add(contact)
                    }
                }
                self.tableView!.reloadData()
            } catch {
                print("Can't Search Contact Data")
            }
        }
        
        
    }
    
    
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        setDatasource()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchContacts(textField.text!)
        return true
    }
    
    
    func closeButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    func getReadyForInvite() {
        
        bottomButton.isHidden = false
        self.tableView?.bringSubview(toFront: bottomButton)
        
        if self.selectedEmailFriends.count == 1 {
            bottomButton.setTitle("Invita \(self.selectedEmailFriends.count) Amico", for: UIControlState())
        } else {
            bottomButton.setTitle("Invita \(self.selectedEmailFriends.count) Amici", for: UIControlState())
        }
        
    }
    
    func actionBottomButtonWasPressed(_ sender:UIButton) {
        
        var friends = [String]()
        for item in self.selectedEmailFriends {
            friends.append(item as! String)
        }
        
        GrocerestAPI.inviteFriendsToGrocerest(friends) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func createInviteButton() {
        bottomButton = UIButton()
        self.view!.addSubview(bottomButton)
        bottomButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(112 / masterRatio)
            make.bottom.equalTo((self.tableView?.snp.bottom)!)
        }
        bottomButton.setTitleColor(UIColor.white, for: UIControlState())
        bottomButton.backgroundColor = UIColor.grocerestBlue()
        bottomButton.addTarget(self, action: #selector(GRAddFriendsView.actionBottomButtonWasPressed(_:)), for: .touchUpInside)
        bottomButton.isHidden = true
        
    }
    
}


