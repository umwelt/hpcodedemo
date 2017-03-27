//
//  GRShoppingListViewController+UITableViewDataSource.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 16/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftLoader

extension GRShoppingListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch section {
        case 0:
            if (uncheckedProducts != nil) {
                return uncheckedProducts!.count
            }
            return 0
        case 1:
            if checkedProducts!.count > 0 {
                return checkedProducts!.count
            }
            return 0
        default:
            return 0
        }
        
    }
    
    fileprivate func categoryString(_ name:String) -> String {
        return "select_\(name)"
    }
    
    func configureCell (_ cell:GRShoppingItemViewCell, indexPath: IndexPath, skipImage:Bool) ->  GRShoppingItemViewCell {
        
        cell.selectionStyle = .none
        cell.quantityLabelText = nil
        cell.secondaryLabelText = nil
        
        if !skipImage {
            cell.imageCategory = nil
        }
        
        switch indexPath.section {
        case 0:
            
            let product = self.uncheckedProducts![indexPath.row]
            
            cell.onCheckProductButtonTapped = {
                self.checkProductButtonWasPressed(cell)
            }
            
            if !skipImage {
                cell.arrangeSectionZero()
                
                if let categoryName = product["category"].string {
                    cell.imageCategory = UIImage(named: categoryString(categoryName))
                }
                
                if let isGeneric = product["custom"].bool {
                    if isGeneric {
                        if let categoryName = product["category"].string {
                            if categoryName != "" {
                                cell.imageCategory = UIImage(named: categoryString(categoryName))
                            } else {
                                cell.imageCategory = UIImage(named: "generic")
                            }
                        }
                    }
                }
                
                if product["custom"].boolValue  {
                    cell.imageCategory = UIImage(named: "generic")
                }
            }
            
            cell.mainLabelText = product["name"].stringValue
            cell.secondaryLabelText = "Aggiunto da \(product["creator"]["username"].stringValue)"
            
            if product["quantity"].stringValue != "0" {
                cell.quantityLabelText = product["quantity"].stringValue
            }
            
            
            return cell
        case 1:
            
            let product = self.checkedProducts![indexPath.row]
            
            cell.mainLabelText = product["name"].stringValue
            cell.secondaryLabelText = product["checker"]["username"].stringValue
            
            cell.onUncheckProductButton = {
                self.unCheckProductButtonWasPressed(cell)
            }
            
            if !skipImage {
                cell.imageCategory = UIImage(named: "checked_product")
            }
            
            cell.arrangeSectionOne()

            
            return cell
            
        default:
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell :GRShoppingItemViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRShoppingItemViewCell
        
        if (cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRShoppingItemViewCell
        }
        
        return self.configureCell(cell, indexPath: indexPath, skipImage: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func animateTablerows(_ data:[JSON]) {
        let table = self.tableView!
        
        var oldUncheckedProducts = self.uncheckedProducts!
        var oldCheckedProducts = self.checkedProducts!
        self.populateItemsOnListBasedOnStatus(data)
        
        table.beginUpdates()
        
        var indexPathsToRemove:[IndexPath] = []
        var indexPathsToAdd:[IndexPath] = []
        var indexPathsToMove:[(from:IndexPath, to:IndexPath)] = []
        
        // utility fns
        
        
        
        func differencePaths(_ section:Int, collection1:[JSON], collection2:[JSON]) -> [IndexPath] {
            // look for items in collection 1 that are not in collection 2
            // and return their indexpath
            var indexPaths:[IndexPath] = []
            for (index, item) in collection1.enumerated() {
                let path = IndexPath.init(row: index, section: section)
                let matches = collection2.filter({ (other) -> Bool in
                    return other["_id"].string! == item["_id"].string! // object specific
                })
                if matches.count == 0 {
                    indexPaths.append(path)
                }
            }
            return indexPaths
        }
        
        func intersectPaths(_ section:Int, collection1:[JSON], collection2:[JSON]) -> [(from:IndexPath, to:IndexPath)] {
            // look for items in collection 1 that are present in collection 2
            // and return both old and new index paths
            var result:[(from:IndexPath, to:IndexPath)] = []
            for (index, item) in collection1.enumerated() {
                let pathOld = IndexPath.init(row: index, section: section)
                let matches = collection2.filter({ (other) -> Bool in
                    return other["_id"].string! == item["_id"].string! // object specific
                })
                if matches.count != 0 {
                    let pathNew = IndexPath.init(row: collection2.index(of: matches[0])!, section: section)
                    result.append((from: pathOld, to: pathNew))
                }
            }
            return result
        }
        
        // remove / add / move rows for section 0
        
        indexPathsToRemove = differencePaths(
            0,
            collection1: oldUncheckedProducts,
            collection2: self.uncheckedProducts!
        )
        indexPathsToAdd = differencePaths(
            0,
            collection1: self.uncheckedProducts!,
            collection2: oldUncheckedProducts
        )
        indexPathsToMove = intersectPaths(
            0,
            collection1: oldUncheckedProducts,
            collection2: self.uncheckedProducts!
        )
        table.insertRows(at: indexPathsToAdd, with: .right)
        table.deleteRows(at: indexPathsToRemove, with: .right)
        
        
        // move rows that changed position
        for item in indexPathsToMove {
            table.moveRow(at: item.from, to: item.to)
        }
        // TODO: update row detail (like quantity) if they changed
        
        // remove / add / move rows for section 1
        
        indexPathsToRemove = differencePaths(
            1,
            collection1: oldCheckedProducts,
            collection2: self.checkedProducts!
        )
        indexPathsToAdd = differencePaths(
            1,
            collection1: self.checkedProducts!,
            collection2: oldCheckedProducts
        )
        indexPathsToMove = intersectPaths(
            1,
            collection1: oldCheckedProducts,
            collection2: self.checkedProducts!
        )
        table.insertRows(at: indexPathsToAdd, with: .right)
        table.deleteRows(at: indexPathsToRemove, with: .right)
        // again, more rows
        for item in indexPathsToMove {
            table.moveRow(at: item.from, to: item.to)
        }
        
        table.endUpdates()
        
        for cell in (self.tableView?.visibleCells)! {
            let cell = cell as! GRShoppingItemViewCell
            let path = table.indexPath(for: cell)
            self.configureCell(cell, indexPath: path!, skipImage: true)
        }
        
        oldUncheckedProducts = []
        oldCheckedProducts = []
        
    }
    
    
    
    
    func setDataSource() {
        SwiftLoader.hide()
        
        if let shoppingListId = self.shoppingList!["_id"].string {
            
            GrocerestAPI.getShoppingList(shoppingListId){ data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    DispatchQueue.main.async { SwiftLoader.hide() }
                    return
                }
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.applyDataSource(data)
                }
                
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func applyDataSource(_ data:JSON) {
        // given an update coming from the network, we apply it
        if let v = data["__v"].int {
            if v < self.version {
                // if we got an update for a version that is older than ours we can skip it
                return
            }
            self.version = v
            
            self.netDataSource = []
            self.formatShoppingListLabels(data)
            
            for (_, subJson) in data["items"] {
                self.netDataSource?.append(subJson)
            }
            
            self.populateItemsForShoppingListCheck(self.netDataSource!)
            self.updateListname(data["name"].stringValue)
            self.animateTablerows(self.netDataSource!)
        }
    }
    
    /// Data Source utilities
    
    fileprivate func populateItemsForShoppingListCheck(_ data:[JSON]) {
    
        self.shoppingListProductIds.removeAllObjects()
        
        DispatchQueue.global().async {
            for subJson in data {
                if let product = subJson["product"].string {
                    self.shoppingListProductIds.add(product)
                }
            }
        }
    }
    
    
    fileprivate func populateItemsOnListBasedOnStatus(_ data:[JSON]) {
        
        self.uncheckedProducts?.removeAll()
        self.checkedProducts?.removeAll()
        
        for subJson in data.reversed() {
            if subJson["checked"].bool == true {
                self.checkedProducts?.append(subJson)
            } else {
                self.uncheckedProducts?.append(subJson)
            }
        }
        
        let outModel = self.userDefaults.data(forKey: "filtersModel")
        if outModel != nil {
            let filters = NSKeyedUnarchiver.unarchiveObject(with: outModel!) as! Dictionary<String, String>?
            // print("filters: \(filters!["filter"] as! String)")
            // print("mode: \(filters!["mode"] as! String)")
            self.sortDataSourceWithModel(filters!["filter"]! as String, mode: filters!["mode"]! as String, reload: reloadTable)
        }
        
    }
    
    
    
}
