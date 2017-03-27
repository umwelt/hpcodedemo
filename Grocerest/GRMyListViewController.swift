 //
//  GRMyListViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 14/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RealmSwift
import SwiftLoader
import Google
import FBSDKCoreKit
import FBSDKLoginKit

class GRMyListViewController: UIViewController, GRToolBarProtocol, UIGestureRecognizerDelegate, GRMenuProtocol, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, ENSideMenuDelegate  {
    
    var animatedMenu: GRMenuView?
    var tableView : UITableView?
    
    var dataSource : JSON?
    var homeData : JSON?
    
    var menuExist = false
    var shoppingListId = ""
    let realm = try! Realm()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        formatTableView()
        setDataToGoogle()
        
        setDataSource(true, indexPath: IndexPath(row: 0, section: 0))
        
        NotificationCenter.default.addObserver(self, selector: #selector(GRMyListViewController.didReceiveNotification(_:)), name: NSNotification.Name(rawValue: notificationIdentifierReload), object: nil)
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataSource(true, indexPath: IndexPath(row: 0, section: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.sideMenuController()?.sideMenu?.delegate = self
        super.viewDidAppear(animated)
    }
    
    fileprivate var managedView: GRMyListView {
        return self.view as! GRMyListView
    }
    
    override func loadView() {
        super.loadView()
        view = GRMyListView()
        managedView.delegate = self
    }
    
    func formatTableView() {
        tableView = UITableView()
        managedView.addSubview(tableView!)
        tableView!.snp.makeConstraints { (make) -> Void in
            make.top.equalTo((managedView.newListView?.snp.bottom)!)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.managedView.snp.width)
        }
        tableView!.tableFooterView = UIView(frame: CGRect.zero)
        tableView!.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.bounces = true
        tableView!.rowHeight = Constants.UISizes.grocerestStandardHeightCell
        tableView!.register(GRMyListViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if self.dataSource != nil {
            return self.dataSource!.array!.count
        }
        
        return 0
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: GRMyListViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRMyListViewCell
        var numberItems = 0
        var owner = ""
        var ownerId: String?
        
        if (cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRMyListViewCell
        }
        
        
        cell.completedImageView?.image = nil
        cell.contentView.backgroundColor = UIColor.white
        cell.titleLabel?.textColor = UIColor.grocerestDarkBoldGray()
        cell.badgeIcon?.image = nil
        
        let row = indexPath.row
        cell.selectionStyle = .none
        
        if let owId = self.dataSource![indexPath.row]["owner"]["_id"].string {
            ownerId = owId
        }
        
        if self.dataSource![indexPath.row]["completed"].bool == true {
            cell.completedImageView?.image = UIImage(named: "green_arrow")
        }
        
        if let listTitleLabel = self.dataSource!.array![row]["name"].string {
            cell.titleLabel?.text = listTitleLabel
        }
        
        if let items = dataSource![indexPath.row]["items"].int {
            numberItems = items
        }
        
        if let ownerList = dataSource![indexPath.row]["owner"]["username"].string {
            owner = ownerList
        }
        
        
        if ownerId != GRUser.sharedInstance.id! {
            
            cell.layoutMargins = UIEdgeInsets.zero
            cell.contentView.backgroundColor = UIColor.white
            cell.listCellImageView?.image = UIImage(named: "shared_list")
            cell.detailLabel?.text = "\(numberItems) Elementi - Creato da \(owner)"
            cell.titleLabel?.textColor = UIColor.grocerestDarkBoldGray()
            cell.badgeLabel?.isHidden = false
            cell.badgeIcon?.isHidden = false
            
            
            for uinvited in self.dataSource!.array![row]["invited"].array! {
                if uinvited["_id"].string! == GRUser.sharedInstance.id! {
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.contentView.backgroundColor = UIColor.F1F1F1Color()
                    cell.listCellImageView?.image = UIImage(named: "shared_blue_list")
                    cell.detailLabel?.text = "\(numberItems) Elementi - Creato da \(owner)"
                    cell.titleLabel?.textColor = UIColor.grocerestBlue()
                    cell.badgeLabel?.isHidden = true
                    cell.badgeIcon?.isHidden = true
                }
            }
            
            
        
            
        } else {
            cell.listCellImageView?.image = UIImage(named: "user_list")
            cell.detailLabel?.text = "\(numberItems) Elementi"
            cell.badgeLabel?.isHidden = true
            cell.badgeIcon?.isHidden = true
        }

        
        for _ in  self.dataSource!.array![row]["invited"].array! {
            
            if (dataSource![indexPath.row]["owner"]["_id"].string! != GRUser.sharedInstance.id!) {
                cell.detailLabel?.text = "Invitato da \(owner)"
            } else {
                cell.detailLabel?.text = "\(numberItems) Elementi - Creato da \(owner)"
            }
            
        }
        
        if (self.dataSource!.array![row]["collaborators"].count > 0) {
            cell.badgeLabel?.isHidden = false
            cell.badgeIcon?.isHidden = false
            cell.badgeIcon?.image = UIImage(named: "collaborators")
            cell.badgeLabel?.text = "\(self.dataSource!.array![row]["collaborators"].count + 1)"
            cell.badgeLabel?.backgroundColor = UIColor.grocerestBlue()
            cell.detailLabel?.text = "\(numberItems) Elementi - Creato da \(owner)"
        } else {
            cell.badgeLabel?.isHidden = true
            cell.badgeIcon?.isHidden = true
        }
        
        if (self.dataSource!.array![row]["isDone"] == true) {
            cell.completedImageView?.image = UIImage(named: "completed")
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let shoppListId = dataSource![indexPath.row]["_id"].string {
        shoppingListId = shoppListId
            
            if let ownerId =  dataSource![indexPath.row]["owner"]["_id"].string {
                if (ownerId == GRUser.sharedInstance.id!) {
                    let shoppingListViewController = GRShoppingListViewController()
                    shoppingListViewController.shoppingList = self.dataSource!.array![indexPath.row]
                    self.navigationController?.pushViewController(shoppingListViewController, animated: true)
                }
            }
            
            if (dataSource![indexPath.row]["collaborators"].array?.count)! > 0 {
                
                for user in dataSource![indexPath.row]["collaborators"].array! {
                    
                    if let userId = user["_id"].string {
                        if userId == "\(GRUser.sharedInstance.id!)" {
                            let shoppingListViewController = GRShoppingListViewController()
                            shoppingListViewController.shoppingList = self.dataSource!.array![indexPath.row]
                            self.navigationController?.pushViewController(shoppingListViewController, animated: true)
                        }
                    }
                }
            }
            
  
            
            
            if (dataSource![indexPath.row]["invited"].array?.count)! > 0 {
                for user in dataSource![indexPath.row]["invited"].array! {
                    
                    if let userId = user["_id"].string {
                        if userId == "\(GRUser.sharedInstance.id!)" {
                            
                            if let ownerList = dataSource![indexPath.row]["owner"]["username"].string {
                                    actionForShoppingListInvitation("\(ownerList)", message: " ti ha invitato a una shopping list", indexPath: indexPath)
                            }
                        }
                    }
                }
                
            }
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let invited = dataSource![indexPath.row]["invited"].array ?? []
        let listId = self.dataSource!.array![indexPath.row]["_id"].string!
        
        let isOwner = GrocerestAPI.userId == self.dataSource!.array![indexPath.row]["owner"]["_id"].string!
        let isInvited = invited.contains(where: { $0["_id"].string! == GRUser.sharedInstance.id! })
        let isCollaborator = !isOwner && !isInvited
        
        
        if isInvited {
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: getImagePadding(true) , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in

                GrocerestAPI.acceptOrDenyInvitationToShoppingList(listId, fields: ["accept": false]) { data, error in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        return
                    }
                    
                    self.setDataSource(true, indexPath: indexPath)
                }
            })
            
            deleteAction.backgroundColor = UIColor(patternImage: getImageWithName("elimina"))
            return [deleteAction]

            
        }
        
        
        if isCollaborator {
        
            let duplicateAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: getImagePadding(false), handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
                var fields = [String:String]()
                fields["name"] = "Copia di \(self.dataSource!.array![indexPath.row]["name"].string!)"
                
                
                GrocerestAPI.cloneShoppingList(listId, fields: fields) { data, error in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        return
                    }
                    
                    self.setDataSource(true, indexPath: indexPath)
                }
            })
            
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: getImagePadding(true) , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
                
                GrocerestAPI.removeMeUserFromShoppingList(listId, userId: GRUser.sharedInstance.id!) { data, error in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        return
                    }
                    
                    self.setDataSource(true, indexPath: indexPath)
                }
            })
            
            duplicateAction.backgroundColor = UIColor(patternImage: getImageWithName("duplica"))
            deleteAction.backgroundColor = UIColor(patternImage: getImageWithName("elimina"))
            return [deleteAction, duplicateAction]

        }
        
        
        if isOwner {
            
            let duplicateAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: getImagePadding(false) , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
                var fields = [String:String]()
                fields["name"] = "Copia di \(self.dataSource!.array![indexPath.row]["name"].string!)"
                
                
                GrocerestAPI.cloneShoppingList(listId, fields: fields) { data, error in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        return
                    }
                    
                    self.setDataSource(true, indexPath: indexPath)
                }
            })
            
            let resettaAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: getImagePadding(false) , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
            
                GrocerestAPI.resetShoppingList(listId) { data, error in
                    guard error == nil else {
                        if let errorMessage = error?.debugDescription {
                            print(errorMessage)
                        }
                        return
                    }
                    self.setDataSource(true, indexPath: indexPath)
                }
            })
            
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: getImagePadding(true) , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
                
                GrocerestAPI.deleteShoppingList(listId) { data, error in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        return
                    }
                    
                    self.setDataSource(true, indexPath: indexPath)
                }
            })
            
            duplicateAction.backgroundColor = UIColor(patternImage: getImageWithName("duplica"))
            resettaAction.backgroundColor = UIColor(patternImage: getImageWithName("resetta"))
            deleteAction.backgroundColor = UIColor(patternImage: getImageWithName("elimina"))
            
            return [deleteAction, resettaAction, duplicateAction]
        }
        
        return [] // this should never happen, but if it does we don't crash.
    }
    
    
    // some bad hacks used to resize action button images depending on current running device
    
    func getImagePadding (_ last:Bool) -> String {
        // we need to use spaces to make rum for the background image without adding text
        var padding = "       " // 7
        
        if (last) {
            // last icon needs to be padded more
            
            if getDeviceClass() == "5" {
                padding += "  " // + 2
            }
            
            if getDeviceClass() == "6" {
                // larger screen needs slightly more
                padding += "   " // + 3
            }
            
            if getDeviceClass() == "6plus" {
                // and plus needs even more..
                padding += "    " // + 4
            }
        }
        
        return padding
    }
    
    func getImageWithName (_ name: String) -> UIImage {
        // the background images need to be explicitly scaled to fit well
        // the default one is sized for iphone 6
        let image = UIImage(named: name)!
        
        if getDeviceClass() == "5" {
            let scale:CGFloat = 2.2
            let image = UIImage(named: name)!
            let scaled = UIImage.init(data: image.asData(), scale: scale)!
            return scaled
        } else if getDeviceClass() == "6plus" {
            let scale:CGFloat = 2.8
            let image = UIImage(named: name)!
            let scaled = UIImage.init(data: image.asData(), scale: scale)!
            return scaled
        } else { // it's a "6"
            return image
        }
    }
    
    
    func getDeviceClass () -> String {
        if 414.0 == UIScreen.main.bounds.width {
            return "6plus" // same metrics as 6s plus
        } else if UIScreen.main.bounds.width < 375.0 {
            return "5" // same metrics as 6 and 6s with zoom
        } else {
            return "6" // normal metrics (same as sketch)
        }
    }
    
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func deleteAllItemsInList(_ items:[String], listId:String) {
        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                GrocerestAPI.deleteShoppingListItem(listId: listId, itemId: item) { data, error in
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        return
                    }
                }
            }
        }
        
        self.tableView?.reloadData()
    }
    
    
    
    func setDataSource(_ reload: Bool, indexPath: IndexPath) {
        /* Needed. Else, if the error message is already open, the
           SwiftLoader will show indefinitely. */
        if !GRDeactivatedUserErrorViewController.isAlreadyOpen {
            SwiftLoader.show(title: "Loading", animated: true)
        }
     
        GrocerestAPI.getUserShoppingLists(GRUser.sharedInstance.id!) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                if data["error"]["code"].stringValue == "E_UNAUTHORIZED" {
                    self.noUserOrInvalidToken()
                }
                return
            }
            
            DispatchQueue.main.async {
                if reload {
                    if indexPath.section > 0 {
                        self.prepareTableViewCATransaction(indexPath)
                    }
                }
                
                let sorted = data.array!.sorted(by: { (a, b) -> Bool in
                    return a["tsUpdated"] > b["tsUpdated"]
                })
                
                self.dataSource = JSON.init(sorted)
                self.tableView?.reloadData()
                SwiftLoader.hide()
            }
        }
    }
    
    
    
    
    
    
    /**
     Navigation
     */
    
    
    
    func menuButtonWasPressed(_ menuButton: UIButton) {
        toggleSideMenuView()
    }
    
    func newlistButtonWasPressed(_ sender: UIButton){
        let newListViewController = GRCreateListViewController()
        newListViewController.modalTransitionStyle = .coverVertical
        self.present(newListViewController, animated: true, completion: nil)
    }
    
    
    func grocerestButtonWasPressed(_ grocerestButton: UIButton){
        //self.navigationController?.popViewControllerAnimated(false)
    }
    
    func scannerButtonWasPressed(_ sender: UIButton){
        let scannerViewController = GRBarcodeScannerViewController()
        self.navigationController?.pushViewController(scannerViewController, animated: false)
    }
    
    func searchButtonWasPressed(_ searchButton: UIButton){
        let productSearch = GRProductSearchViewController()
        navigationController?.pushViewController(productSearch, animated: true)
    }
    
    
    /**
     *  Utils
     */
    
    func prepareTableViewCATransaction(_ indexPath: IndexPath) {
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({ () -> Void in
            self.tableView?.beginUpdates()
            self.tableView?.deleteRows(at: [indexPath], with: .fade)
            self.tableView?.endUpdates()
        })
        
        CATransaction.commit()
    }
    
    
    /// Alert on errors
    
    fileprivate func showValidationAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    /**
     Shows alert with message
     
     - parameter title:   Title
     - parameter message: Message in alert
     */
    func actionForShoppingListInvitation(_ title: String, message:String, indexPath: IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let accept = UIAlertAction(title: "Accettare", style: .default) { (alert: UIAlertAction) -> Void in
            GrocerestAPI.acceptOrDenyInvitationToShoppingList(self.shoppingListId, fields: ["accept": true]) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    SwiftLoader.hide()
                    return
                }
                
                let shoppingListViewController = GRShoppingListViewController()
                shoppingListViewController.shoppingList = self.dataSource!.array![indexPath.row]
                self.navigationController?.pushViewController(shoppingListViewController, animated: true)
                
            }
            
        }
        let refuse = UIAlertAction(title: "Non adesso", style: .default) { (alert: UIAlertAction) -> Void in
//            GrocerestAPI.acceptOrDenyInvitationToShoppingList(self.shoppingListId, fields: ["accept": false]) {data, error in
//                
//                guard error == nil else {
//                    if let errorMessage = error?.localizedDescription {
//                        SwiftLoader.hide()
//                        print(errorMessage)
//                    }
//                    return
//                }
//                
//                
//            }
        }
        alert.addAction(refuse)
        alert.addAction(accept)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // Menu Delegate
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func profileButtonWasPressed(_ sender: UIButton) {
        let destViewController = GRProfileViewController()
        sideMenuController()?.setContentViewController(destViewController)
    }
    
    func noUserOrInvalidToken() {
        let welcomeViewController = GRWelcomeViewController()
        // self.navigationController?.pushViewController(welcomeViewController, animated: false)
        try! self.realm.write {
            self.realm.deleteAll()
        }
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "bearerToken")
        defaults.removeObject(forKey: "userId")
        defaults.synchronize()
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()

        self.navigationController?.setViewControllers([welcomeViewController], animated: true)
    }
    
    func didReceiveNotification(_ notification: Notification){
        setDataSource(true, indexPath: IndexPath(row: 0, section: 0))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setDataToGoogle() {
        self.title = "All Lists View"
        let name = "Pattern~\(self.title!)"
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as [NSObject: AnyObject]?)
        
    }
    
    
    
}
