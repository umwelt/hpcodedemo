//
//  GRHomeViewController+UITableViewDelegate.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 14/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftLoader

extension GRHomeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if let shoppListId = userListsDataSource![indexPath.row]["_id"].string {
            shoppingListId = shoppListId
            
            if let ownerId =  userListsDataSource![indexPath.row]["owner"]["_id"].string {
                if (ownerId == GRUser.sharedInstance.id!) {
                    let shoppingListViewController = GRShoppingListViewController()
                    shoppingListViewController.listDelegate = self
                    shoppingListViewController.shoppingList = self.userListsDataSource!.array![indexPath.row]
                    self.navigationController?.pushViewController(shoppingListViewController, animated: true)
                }
            }
            
            if userListsDataSource![indexPath.row]["collaborators"].array?.count > 0 {
                for user in userListsDataSource![indexPath.row]["collaborators"].array! {
                    
                    if let userId = user["_id"].string {
                        if userId == "\(GRUser.sharedInstance.id!)" {
                            let shoppingListViewController = GRShoppingListViewController()
                            shoppingListViewController.listDelegate = self
                            shoppingListViewController.shoppingList = self.userListsDataSource!.array![indexPath.row]
                            self.navigationController?.pushViewController(shoppingListViewController, animated: true)
                        }
                    }
                }
            }
            
            
            
            
            if userListsDataSource![indexPath.row]["invited"].array?.count > 0 {
                for user in userListsDataSource![indexPath.row]["invited"].array! {
                    
                    if let userId = user["_id"].string {
                        if userId == "\(GRUser.sharedInstance.id!)" {
                            
                            if let ownerList = userListsDataSource![indexPath.row]["owner"]["username"].string {
                                actionForShoppingListInvitation("\(ownerList)", message: " ti ha invitato a una shopping list", indexPath: indexPath)
                            }
                        }
                    }
                }
                
            }
        }
        
    }
    
    
    /// Alert on errors
    
    private func showValidationAlertWithTitleAndMessage(title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (alert: UIAlertAction) -> Void in
        }
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    /**
     Shows alert with message
     
     - parameter title:   Title
     - parameter message: Message in alert
     */
    func actionForShoppingListInvitation(title: String, message:String, indexPath: NSIndexPath) {
        var fields = [String:AnyObject]()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let accept = UIAlertAction(title: "Accettare", style: .Default) { (alert: UIAlertAction) -> Void in
            fields["accept"] = "true"
            GrocerestAPI.acceptOrDenyInvitationToShoppingList(self.shoppingListId, fields: fields) {data, error in
                
                guard error == nil else {
                    if let errorMessage = error?.localizedDescription {
                        SwiftLoader.hide()
                        print(errorMessage)
                    }
                    return
                }
                
                let shoppingListViewController = GRShoppingListViewController()
                shoppingListViewController.shoppingList = self.userListsDataSource!.array![indexPath.row]
                self.navigationController?.pushViewController(shoppingListViewController, animated: true)
                
            }
            
        }
        let refuse = UIAlertAction(title: "Non adesso", style: .Default) { (alert: UIAlertAction) -> Void in
            fields["accept"] = "false"
            //            GrocerestAPI.acceptOrDenyInvitationToShoppingList(self.shoppingListId, fields: fields) {data, error in
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
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
}
