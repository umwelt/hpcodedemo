//
//  GRAddFriendsViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 31/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftLoader
import Haneke
import Alamofire


class GRAddFriendsViewController: UIViewController, GRAddFriendsProtocol, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var dataSource : JSON?
    var tableView: UITableView?
    var allFriends : [JSON]?
    var allTransientFriends : [JSON]?
    
    var usersInList: [JSON]?
    
    
    var selectedFriends : [JSON]?
    var dataDelegate : GRCreateListViewController?
    var editionDelegate: GRModifyListViewController?
    var listName: String?
    var list : JSON?
    
    
    var removeUsers = [JSON]()
    var added: [JSON]?
    
    var fromList = false
    
    var withProduct = false
    var product : JSON?
    
    var delegate : GRMoreActionsForProductProtocol?
    var listDelegate:GRUpdateHomeListProtocol?
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if fromList {
            setdataSource()
        } else {
            self.managedView.formatViewForCreateListFlow()
        }
        
        setupViews()
        selectedFriends = []
        self.managedView.searchTextField?.addTarget(self, action: #selector(GRAddFriendsViewController.actionTextWasChanged(_:)), for: .allEditingEvents)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSlideViewAnimation()
    }
    

    
    
    fileprivate var managedView: GRAddFriendsView {
        return self.view as! GRAddFriendsView
    }
    
    override func loadView() {
        super.loadView()
        view = GRAddFriendsView()
        managedView.delegate = self
        managedView.searchTextField?.delegate = self
        
    }
    
    
    
    
    func setupViews() {
        
        tableView = UITableView(frame: CGRect.zero)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.bounces = true
        tableView?.register(GRFriendsViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.backgroundColor = UIColor.clear
        tableView?.separatorStyle = .singleLine
        tableView?.isHidden = false
        tableView?.keyboardDismissMode = .onDrag
        tableView!.tableFooterView = UIView()
        
        managedView.addSubview(tableView!)
        
        tableView?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(managedView.snp.width)
            make.top.equalTo(managedView.searchTextField!.snp.bottom).offset(6)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if selectedFriends == nil {
                return 0
            }
            return (selectedFriends?.count)!
        case 1:
            if allFriends == nil {
                return 0
            }
            return (allFriends?.count)!
            
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: GRFriendsViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRFriendsViewCell
        let type = AvatarType.cells
        
        
        if (cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRFriendsViewCell
        }
        
        
        cell.selectionStyle = .none
        
        
        let index = indexPath.row
        
        switch indexPath.section {
        case 0:
            cell.userProfileImage.isHidden = true
            cell.selectedCellArrangement()
            
            if let name = self.selectedFriends?[index]["firstname"].string,
                let lastname = self.selectedFriends?[index]["lastname"].string,
                let username = self.selectedFriends?[index]["username"].string {
                cell.formatCellForSelectedUser(name, lastname: lastname, username: username)
            }
            
            cell.selectionCellStatusImageView?.image = UIImage(named: "minus_icon")
            
            return cell
        case 1:
            cell.allCellArrangement()
            cell.userProfileImage.isHidden = false
            
            let user = self.allFriends?[index]
            
            if let name = user!["firstname"].string,
                let lastname = user!["lastname"].string,
                let username = user!["username"].string{
                cell.formatCellForNoSelectedUser(name, lastname: lastname, username: username)
                cell.userProfileImage.setUserProfileAvatar(user!["picture"].stringValue, name: name, lastName: lastname, type: type)
            }
            
            cell.selectionCellStatusImageView?.image = UIImage(named: "plus_icon")
            
            return cell
        default:
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        if indexPath.section == 1 {
            addToSelectedFriends(indexPath)
        } else if indexPath.section == 0 {
            addToAllFriends(indexPath)
        }
        
        
        toggleFooter()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return  ceil(96 / masterRatio)
        } else {
            return ceil(125 / masterRatio)
        }
    }
    
//    private func animateCellHeighChangeForTableView(tableView: UITableView, withDuration duration: Double) {
//        UIView.animateWithDuration(duration) { () -> Void in
//            tableView.beginUpdates();
//            tableView.endUpdates();
//            tableView.reloadData();
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        if section == 0 {
            if selectedFriends?.count == 0 {
                return nil
            }
            return "Invitati"
        }
        
        if allFriends?.count == 0 {
            return "Utenti di Grocerest"
        }
        return "Utenti di Grocerest"
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let addAllFriendsButton = UIButton()
        
        if section == 0 {
            
            let headertop:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            headertop.textLabel!.textColor = UIColor.grocerestLightGrayColor()
            headertop.textLabel!.font = Constants.BrandFonts.avenirBook11
            headertop.textLabel!.frame = headertop.frame
            headertop.textLabel!.textAlignment = NSTextAlignment.left
            headertop.textLabel?.text = "Invitati"
            addAllFriendsButton.isHidden = true
            
        } else if section == 1 {
            
            let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            addAllFriendsButton.isHidden = false
            header.textLabel!.textColor = UIColor.grocerestLightGrayColor()
            header.textLabel!.font = Constants.BrandFonts.avenirBook11
            header.textLabel!.frame = header.frame
            header.textLabel!.textAlignment = NSTextAlignment.left
            header.textLabel?.text = "Utenti di Grocerest"
            
        }
    }
    
    
    
    
    func closeButtonWasPressed(_ sender: UIButton) {
        // self.navigationController?.popViewControllerAnimated(true)
        allFriends?.removeAll()
        selectedFriends?.removeAll()
        self.dismiss(animated: false, completion: nil)
    }
    
    /// Alert on errors
    
    fileprivate func showValidationAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func addAllFriendsWasPressed(_ sender:UIButton) {
        print("addAll")
    }
    
    
    /**
     *  Utils
     */
    
    func toggleFooter() {
        
        if (selectedFriends?.count)! > 0 || removeUsers.count > 0 {
            // Active button
            self.managedView.enableConfirmButton(true)
        } else {
            // Disable Button
            self.managedView.enableConfirmButton(false)
        }
    }
    
    func addToSelectedFriends(_ indexPath: IndexPath) {
        if (allFriends?.count)! > 0 {
            
            if self.removeUsers.count > 0 {
                for item in self.removeUsers {
                    if item["_id"].string! == self.allFriends![indexPath.row]["_id"].string! {
                        self.removeUsers.removeObject(self.allFriends![indexPath.row])
                    }
                }
            }
            
            
            selectedFriends?.append(allFriends![indexPath.row])
            allFriends?.remove(at: indexPath.row)
            
            let range = NSMakeRange(0, self.tableView!.numberOfSections)
            let sections = IndexSet(integersIn: range.toRange() ?? 0..<0)
            self.tableView!.reloadSections(sections, with: .automatic)
            
            self.tableView?.reloadData()
        }
    }
    
    
    func addToAllFriends(_ indexPath: IndexPath) {
        
        if (selectedFriends?.count)! > 0 {
            
            if self.usersInList != nil {
                for item in self.usersInList! {
                    if let containedItem = self.selectedFriends![indexPath.row]["_id"].string {
                        if item["_id"].string! == containedItem {
                            self.removeUsers.append(self.selectedFriends![indexPath.row])
                        }
                    }
                }
            }
            
            self.allFriends?.append(self.selectedFriends![indexPath.row])
            self.selectedFriends?.remove(at: indexPath.row)
            
            tableView!.reloadData()
        }
    }
    
    
    
    
    /**
     *  Delegates
     */

    func inviteFriendsToList() {
        var fields = [String: Any]()
        var collaborator = [String]()
        
        if (self.selectedFriends?.count)! > 0 {
            for item in self.selectedFriends! {
                collaborator.append("\(item["_id"].string!)")
            }
        }
        fields["user_ids"] = collaborator
        
        GrocerestAPI.inviteToShoppingList(self.list!["_id"].string!, fields: fields) { data, error in
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            self.deleteFromList()
        }
    }
    
    
    func deleteFromList() {
        var fields = [String: Any]()
        var collaborator = [String]()
        
        if self.removeUsers.count > 0 {
            for item in self.removeUsers {
                collaborator.append("\(item["_id"].string!)")
            }
        }
        fields["user_ids"] = collaborator
        
        GrocerestAPI.removeBulkUsersFromShoppingList(self.list!["_id"].stringValue, fields: fields)
        
        self.dismiss(animated: true) { 
            self.editionDelegate?.reloadData()
        }
    }
    
    var findMeUser = ""
    func actionTextWasChanged(_ sender:UITextField) {
        findMeUser = sender.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.findUserInGrocerest(findMeUser)
        return true
    }
    
    func findUserInGrocerest(_ user:String) {
        var fields = [
            "search": user
        ]
        
        GrocerestAPI.findUserByName(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                if data["error"].exists() {
                    SwiftLoader.hide()
                }
                return
            }
            
            self.allFriends?.removeAll()
            for friend in data.arrayValue {
                if GRUser.sharedInstance.id! != friend["_id"].string! {
                    self.allFriends?.append(friend)
                }
            }
            
            self.tableView?.reloadData()
            
        }
        
    }
    
    
    func setdataSource(){
        self.allFriends = []
        
        GrocerestAPI.getShoppingList(self.list!["_id"].string!) { data , error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            DispatchQueue.main.async {
                self.selectedFriends?.append(contentsOf: data["collaborators"].arrayValue)
                self.selectedFriends?.append(contentsOf: data["invited"].arrayValue)
                self.removeThoseIncluded()
            }
        }
        
    }
    
    func removeThoseIncluded() {
        for item in self.selectedFriends! {
            for user in self.allFriends! {
                if item["_id"].string! == user["_id"].string! {
                    self.allFriends?.removeObject(user)
                }
            }
            
        }
        
        self.usersInList = self.selectedFriends
        
        self.tableView?.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        managedView.searchTextField?.snp.remakeConstraints { make in
            make.left.equalTo(90 / masterRatio)
            make.width.equalTo(self.managedView.snp.width)
            make.height.equalTo(106 / masterRatio)
            make.centerY.equalTo(managedView.searchView.snp.centerY)
        }
        
        managedView.searchIcon.snp.remakeConstraints { make in
            make.width.height.equalTo(29 / masterRatio)
            make.centerY.equalTo(managedView.searchTextField!.snp.centerY)
            make.right.equalTo(managedView.searchTextField!.snp.left).offset(-15 / masterRatio)
        }
        
        managedView.searchTextField?.textAlignment = .left
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)    {
        managedView.searchTextField?.endEditing(true)
    }
    
    
    func startSlideViewAnimation () {
        UIView.animate(withDuration: 0.7, delay: 0, options:  .curveEaseOut, animations: {
            self.managedView.transform = CGAffineTransform(translationX: -500, y: 0)
            }, completion: nil)
    }
    
    func removeSlideViewAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.managedView.transform = CGAffineTransform(translationX: 500, y: 0)
        }) { (done: Bool) in
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    func bottomButtonWasPressed (_ sender:UIButton){
        if fromList {
            inviteFriendsToList()
            return
        }
        
        createListWasPressed()
    }
    
    
    func createListWasPressed() {
        SwiftLoader.show(animated: true)
        
        let trimmedString = listName!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if trimmedString.characters.count == 0 {
            showValidationAlertWithTitleAndMessage("Attenzione", message: Constants.UserMessages.noEmptyListName)
            SwiftLoader.hide()
            return
        }
        
        var fields: [String: Any] = [
            "name": listName
        ]
        
        var collaborator = [String]()
        if selectedFriends!.count > 0 {
            for item in selectedFriends! {
                collaborator.append("\(item["_id"].string!)")
            }
        }
        
        fields["invited"] = collaborator
        
        GrocerestAPI.postShoppingList(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                if error == nil {
                    SwiftLoader.hide()
                } else if data["error"]["code"].stringValue == "E_UNAUTHORIZED" {
                    self.dismiss(animated: true) {
                        self.dataDelegate?.noUserOrInvalidToken()
                    }
                }
                return
            }
            
            if self.withProduct {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    SwiftLoader.hide()
                    
                    self.dismiss(animated: true) {
                        self.dataDelegate?.postItemForNewList(data)
                    }
                }
                
                return
            }
            
            SwiftLoader.hide()
            self.dismiss(animated: true) {
                self.dataDelegate?.navigateToListWithData(data)
            }
        }
    }
    
}
