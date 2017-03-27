//
//  GRShoppingListMenuViewController+UITableViewDelegate.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 13/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftLoader



extension GRShoppingListMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let action = indexPath.row
        
        print(action)
        
        if owner {
            
            switch action {
            case ActionsOwner.manage.hashValue:
                modifyWasPressed(true)
                return
            case ActionsOwner.reset.hashValue:
                self.resetListWasPressed()
                return
            case ActionsOwner.duplicate.hashValue:
                self.duplicateWasPressed()
                return
            case ActionsOwner.delete.hashValue:
                deleteWasPressed()
                return
            default:
                ActionsOwner.manage.hashValue
                modifyWasPressed(true)
            }
        } else {
            
            switch action {
            case ActionsCollaborator.info.hashValue:
                modifyWasPressed(false)
                return
            case ActionsCollaborator.duplicate.hashValue:
                self.duplicateWasPressed()
                return
            case ActionsCollaborator.abandon.hashValue:
                leaveListAsCollaborator()
                return
            default:
                ActionsCollaborator.info.hashValue
                modifyWasPressed(false)
                return
            }
            
        }
        
    }
    
    
    // MARK: 1. Modify list was pressed
    
    func modifyWasPressed(_ owner:Bool) {
        SwiftLoader.show(animated: true)
        self.dismiss(animated: true, completion: nil)
        dataDelegate.navigateToEditionView(self.shoppingList!, owner: owner)
    }
    
    
    
    // MARK: 2. Reset List
    func resetListWasPressed() {
        
        SwiftLoader.show(animated: true)
        
        let alert = UIAlertController(title: Constants.UserMessages.warning, message: Constants.UserMessages.listReset, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.UserMessages.ok, style: .destructive) { (alert: UIAlertAction) -> Void in
            
            GrocerestAPI.resetShoppingList(self.shoppingList!["_id"].stringValue) { data, error in
                
                SwiftLoader.show(animated: true)
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                        self.showErrorAlertWithTitleAndMessage(Constants.UserMessages.warning, message: Constants.UserMessages.systemError)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    
                    self.dismiss(animated: true, completion: {
                        self.dataDelegate.shoppingList = self.shoppingList
                        self.dataDelegate.listWasReset()
                    })
                }
            }
        }
        
        let cancel = UIAlertAction(title: Constants.UserMessages.anulla, style: .default) { (alert: UIAlertAction) -> Void in
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    fileprivate func showErrorAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: 3. Duplicate
    
    func duplicateWasPressed() {
        showDuplicationAlertWithTitleAndMessage(Constants.UserMessages.warning, message: Constants.UserMessages.listDuplication)
        
    }
    
    func showDuplicationAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.UserMessages.ok, style: .destructive) { (alert: UIAlertAction) -> Void in
            self.executeDuplication()
        }
        let cancel = UIAlertAction(title: Constants.UserMessages.anulla, style: .default) { (alert: UIAlertAction) -> Void in
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func executeDuplication(){
        var fields = [String:String]()
        fields["name"] = "Copia di \(shoppingList!["name"].string!)"
        
        SwiftLoader.show(animated: true)
        
        GrocerestAPI.cloneShoppingList(self.shoppingList!["_id"].stringValue, fields: fields){ data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.showErrorAlertWithTitleAndMessage(Constants.UserMessages.warning, message: Constants.UserMessages.systemError)
                }
                return
            }
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                
                self.dismiss(animated: true, completion: nil)
                self.dataDelegate.listWasDeleted()
            }
        }
    }
    
    
    // MARK: 4. Delete
    
    func deleteWasPressed() {
        showWarningAlertWithTitleAndMessage(Constants.UserMessages.warning, message: Constants.UserMessages.listDeletion)
    }
    
    func showWarningAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.UserMessages.ok, style: .destructive) { (alert: UIAlertAction) -> Void in
            self.executeDeletion()
        }
        let cancel = UIAlertAction(title: Constants.UserMessages.anulla, style: .default) { (alert: UIAlertAction) -> Void in
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func executeDeletion() {
        SwiftLoader.show(animated: true)
        
        GrocerestAPI.deleteShoppingList(self.shoppingList!["_id"].stringValue){ data, error in
            
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
                    self.dataDelegate.listWasDeleted()
                })
            }
        }
    }
    
    
    // MARK: 5 remove user from list
    
    func leaveListAsCollaborator() {
        showLeavingAlertWithTitleAndMessage("Attenzione", message: "Vuoi lasciare definitivamente questa lista?")
    }
    
    func showLeavingAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.UserMessages.ok, style: .destructive) { (alert: UIAlertAction) -> Void in
            self.executeLeave()
        }
        let cancel = UIAlertAction(title: Constants.UserMessages.anulla, style: .default) { (alert: UIAlertAction) -> Void in
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func executeLeave() {
        GrocerestAPI.removeMeUserFromShoppingList(self.shoppingList!["_id"].stringValue, userId: GRUser.sharedInstance.id!) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                return
            }
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.dismiss(animated: false, completion: { () -> Void in
                    self.dataDelegate.listWasDeleted()
                })
            }
        }
    }
    
}
