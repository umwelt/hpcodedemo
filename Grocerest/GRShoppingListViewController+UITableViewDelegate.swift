//
//  GRShoppingListViewController+UITableViewDelegate.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 16/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftLoader

extension GRShoppingListViewController: UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 92.0 / masterRatio
        default:
            return 145.0 / masterRatio
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 45 / masterRatio
    }
    
    
        
    
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        
        switch section {
        case 0:
            return
        case 1:
            
            let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            header.backgroundView!.backgroundColor = UIColor.clear
            
            myCustomView.backgroundColor = UIColor.grocerestDarkGrayText()
            header.addSubview(myCustomView)
            
        default:
            break
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            let editInsertedProduct  = GREditInsertedProductController()
            editInsertedProduct.product = uncheckedProducts![indexPath.row]
            editInsertedProduct.shoppingList = shoppingList
            editInsertedProduct.delegate = self
            editInsertedProduct.modalTransitionStyle = .crossDissolve
            editInsertedProduct.modalPresentationStyle = .overCurrentContext
            SwiftLoader.show(animated: true)
            present(editInsertedProduct, animated: true, completion: nil)
        case 1:
            return
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        switch indexPath.section {
        case 0:

            deviceTitle = "       "
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: deviceTitle , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
                
                SwiftLoader.show(animated: true)
                
                if let shopId = self.shoppingList?["_id"].string,
                   let prodId =  self.uncheckedProducts?[indexPath.row]["_id"].string {
                    
                    GrocerestAPI.deleteShoppingListItem(listId: shopId, itemId: prodId) { data, error in
                        
                        if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                            return
                        }
                        
                        DispatchQueue.main.async { SwiftLoader.hide() }
                        
                        if let count = self.uncheckedProducts?.count, count > 0,
                           let objectId = self.uncheckedProducts?[indexPath.row]["_id"].string {
                            if self.shoppingListProductIds.contains(objectId){
                                self.shoppingListProductIds.remove(objectId)
                            }
                        }
                    }
                }
                
            })
            
            deleteAction.backgroundColor = UIColor(patternImage: UIImage(named:"trash")!)
            
            return [deleteAction]
        case 1:
            
            deviceTitle = "   "
            
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: deviceTitle , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
                
                SwiftLoader.show(animated: true)
                GrocerestAPI.deleteShoppingListItem(listId: self.shoppingList!["_id"].string!, itemId: self.checkedProducts![indexPath.row]["_id"].string!) {data, error in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        return
                    }
                    
                    DispatchQueue.main.async { SwiftLoader.hide() }
                    
                    if let count = self.uncheckedProducts?.count, count > 0,
                       let objectId = self.checkedProducts?[indexPath.row]["_id"].string {
                        if self.shoppingListProductIds.contains(objectId) {
                            self.shoppingListProductIds.remove(objectId)
                        }
                    }
                }
            })
            
            if DeviceType.IS_IPHONE_6P {
                deleteAction.backgroundColor = UIColor(patternImage: UIImage(named:"trash_plus")!)
            } else if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_5 {
                deleteAction.backgroundColor = UIColor(patternImage: UIImage(named:"small_trash")!)
            }
            
            
            
            return [deleteAction]
        default:
            return nil
        }
        
    }

    

}
