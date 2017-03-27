//
//  GRModifyListViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/02/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftLoader
import Haneke
import Contacts

class GRModifyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var listId = ""
    var tableView : UITableView?
    var dataSource : JSON?
    var newListName = ""
    var emailsFriends = [String]()
    var allFriends : [JSON]?
    var list : JSON?
    var contactStore = CNContactStore()
    var listDelegate:GRUpdateHomeListProtocol?
    
    var owner:Bool = false
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
        setupViews()
        managedView.listNameTextField.delegate = self
        SwiftLoader.hide()
        
        if !owner {
            self.managedView.formatForCollaborator()
            tableView?.snp.remakeConstraints({ (make) -> Void in
                make.width.equalTo(managedView.snp.width)
                make.top.equalTo(managedView.partecipantiLabel.snp.bottom)
                make.left.equalTo(0)
                make.bottom.equalTo(0)
            })
        }
  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate var managedView: GRModifyListView {
        return self.view as! GRModifyListView
    }
    
    override func loadView() {
        super.loadView()
        view = GRModifyListView()
        managedView.delegate = self
        
    }
    
    func setupViews() {
        
        tableView = UITableView(frame: CGRect.zero)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.bounces = true
        tableView?.register(GREditFriendsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.backgroundColor = UIColor.white
        tableView?.tableFooterView = UIView(frame: CGRect.zero)
        tableView?.separatorStyle = .singleLine
        tableView?.isHidden = false
        tableView?.rowHeight = 126 / masterRatio
        managedView.addSubview(tableView!)
        
        tableView?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(managedView.snp.width)
            make.top.equalTo(managedView.partecipantiLabel.snp.bottom)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        managedView.listNameTextField.addTarget(self, action: #selector(GRModifyListViewController.textChanged(_:)), for: .allEditingEvents)
        
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if self.dataSource != nil {
                return 1
            }
            return 0
        case 1:
            if self.dataSource != nil {
                return dataSource!["collaborators"].count
            }
            return 0
        case 2:
            if self.dataSource != nil{
                return dataSource!["invited"].count
            }
            return 0
        default:
            return 0
        }
        
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: GREditFriendsTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GREditFriendsTableViewCell
        
        cell.selectionStyle = .none
        
        if (cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GREditFriendsTableViewCell
        }
        
        let row = indexPath.row
        let type = AvatarType.cells
        
        switch indexPath.section {
        // Owner section
        case 0:
            cell.ownerLabel?.isHidden = false
            cell.selectionButton?.isHidden = true
            let owner = self.dataSource!["owner"]
            
            
            if let name = owner["firstname"].string,
            let lastname = owner["lastname"].string,
            let username = owner["username"].string {
                cell.setLabelsForUserInCell(name, lastName: lastname, userName: username)
                cell.userProfileImage.setUserProfileAvatar(owner["picture"].stringValue, name: name, lastName: lastname, type: type)
            }
            
            return cell
            
            // Collaborators
        case 1:
            cell.ownerLabel?.isHidden = true
            cell.selectionButton?.isHidden = true
            
            let collaborator = self.dataSource!["collaborators"][row]
            
            if let name = collaborator["firstname"].string,
                let lastname = collaborator["lastname"].string,
                let username = collaborator["username"].string{
                cell.setLabelsForUserInCell(name, lastName: lastname, userName: username)
                cell.userProfileImage.setUserProfileAvatar(collaborator["picture"].stringValue, name: name, lastName: lastname, type: type)
            }
            
            return cell
            
            // Invited
        case 2:
            cell.ownerLabel?.isHidden = true
            cell.selectionButton?.isHidden = true
            
            let invited = self.dataSource!["invited"][row]
            
            if let name = invited["firstname"].string,
                let lastname = invited["lastname"].string,
                let username = invited["username"].string{
                cell.setLabelsForUserInCell(name, lastName: lastname, userName: username)
                cell.userProfileImage.setUserProfileAvatar(invited["picture"].stringValue, name: name, lastName: lastname, type: type)
            }
            
            return cell
        default:
            return cell
        }
        
        
    }
    

    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let view = UIView(frame: CGRect.zero)
            
            return view
        case 1:
            let view = UIView(frame: CGRect.zero)
            
            return view
        case 2:
            if dataSource?["invited"].count == 0 {
                let view = UIView(frame: CGRect.zero)
                return view
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
            let label = UILabel(frame: CGRect(x: 23, y: 8, width: tableView.frame.size.width, height: 18))
            label.font = Constants.BrandFonts.avenirBook12
            label.textColor = UIColor.grocerestLightGrayColor()
            label.text = "Invitati in attesa di conferma"
            view.addSubview(label)
            view.backgroundColor = UIColor.F1F1F1Color()
            
            return view
        default:
            let view = UIView(frame: CGRect.zero)
            view.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
            
            return view
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0.00
        case 1:
            return 0.00
        case 2:
            return 65.00 / masterRatio
        default:
            return 65.00 / masterRatio
        }
        
        
    }
    
    
    
    func setDataSource() {
        
        if let shoppingListId = list!["_id"].string {
            
            GrocerestAPI.getShoppingList(shoppingListId) {data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }
                
                self.dataSource = data
                self.popolateEditionView()
                self.tableView?.reloadData()
            }
        }
        

    }
    
    
    func popolateEditionView(){
        
        if let name = self.dataSource!["name"].string {
            managedView.listNameTextField.text = name
        }
        
        
    }
    
    
    
    func closeButtonWasPressed(_ sender:UIButton) {
        
        listDelegate?.updateListProtocol()
        
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
        self.dismiss(animated: false, completion: nil)
        }
    }
    
    //Local UI
    
    func addDeleteButton()-> UIButton {
        
        let backView = UIView()
        self.tableView!.addSubview(backView)
        backView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.managedView.snp.width)
            make.height.equalTo(151 / masterRatio)
            make.left.equalTo(0)
            make.top.equalTo((self.tableView?.snp.bottom)!).offset(64 / masterRatio)
        }
        
        let button = UIButton()
        backView.addSubview(button)
        button.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(684 / masterRatio)
            make.height.equalTo(68 / masterRatio)
            make.center.equalTo(backView.snp.center)
        }
        button.setBackgroundImage(UIImage(named: "delete_border"), for: UIControlState())
        button.setTitle("ELIMINA LISTA", for: UIControlState())
        button.setTitleColor(UIColor.grocerestColor(), for: UIControlState())
        button.addTarget(self, action: #selector(GRModifyListViewController.deleteButtonWasPressed(_:)), for: .touchUpInside)
        
        return button
        
    }
    
    func deleteButtonWasPressed(_ sender:UIButton) {
        print("delete List ")
    }
    
    func textChanged(_ sender:UITextField){
        newListName = sender.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let trimmedString = newListName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if trimmedString.characters.count == 0 {
            showValidationAlertWithTitleAndMessage("Attenzione", message: Constants.UserMessages.noEmptyListName)
            SwiftLoader.hide()
            
            return false
        } else {
            
            var fields = [String:String]()
            fields["name"] = trimmedString
            
            GrocerestAPI.updateShoppingList(self.dataSource!["_id"].string!, fields: fields) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }
                
                self.showValidationAlertWithTitleAndMessage("Nome lista modificato correttamente", message: "")
            }
            return true
        }
        
    }

    func shareListWasPressed(_ sender:UIButton) {
        SwiftLoader.show(animated: true)
        findGrocerestFriends()
    }
    
    /// Alert on errors
    
    fileprivate func showValidationAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
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
        
        allFriends = []
        
        var fields = [String: Any]()
        
        requestForAccess { accessGranted in
            fields["emails"] = getUserContacts()
        }
        
        GrocerestAPI.findUserByEmail(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                SwiftLoader.hide()
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
            addFriendsViewController.listName = self.list!["name"].string!
            addFriendsViewController.selectedFriends?.removeAll()
            addFriendsViewController.fromList = true
            addFriendsViewController.list = self.list
            addFriendsViewController.editionDelegate = self
            
            addFriendsViewController.modalPresentationStyle = .overCurrentContext
            
            self.present(addFriendsViewController, animated: true, completion: nil)
            
        }
        
    }
    
    
    func reloadData() {
        setDataSource()
        setupViews()
    }
    


    
}


