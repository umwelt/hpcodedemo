//
//  GRAddProductViewController+UITableViewDelegate.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 12/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

extension GRAddProductViewController : UITableViewDelegate {
    
    
    // MARK: Select Item
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: GROneLineProductViewCell! = tableView.cellForRow(at: indexPath) as! GROneLineProductViewCell
        managedView.endEditing(true)
        cell.setSelectedBackgroundColorForCell()
        
        switch searchingSource {
        case .locale:
            switch indexPath.section {
            case 0:
                shoppingListProductIds.add(localGenericItems[indexPath.row]["product"]!)
                prepareItemDataListData(indexPath)
            case 1:
                shoppingListProductIds.add(localCommercialItems[indexPath.row]["product"]!)
                prepareItemDataListData(indexPath)
            default:
                return
            }
            
        case .grocerest:
            switch indexPath.section {
            case 0:
                if let objectId = genericItems?[indexPath.row]["_id"].string {
                    shoppingListProductIds.add(objectId)
                    prepareItemDataListData(indexPath)
                }
                
            case 1:
                if let objectId = commercialItems?[indexPath.row]["_id"].string {
                    shoppingListProductIds.add(objectId)
                    prepareItemDataListData(indexPath)
                }
                
            default:
                return
            }
        }
    }
    
    // MARK: Deselect Item
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: GROneLineProductViewCell! = tableView.cellForRow(at: indexPath) as! GROneLineProductViewCell
        managedView.endEditing(true)
        cell.setSelectedBackgroundColorForCell()
        
        switch searchingSource {
        case .locale:
            switch indexPath.section {
            case 0:
                shoppingListProductIds.add(localGenericItems[indexPath.row]["product"]!)
                prepareItemDataListData(indexPath)
            case 1:
                shoppingListProductIds.add(localCommercialItems[indexPath.row]["product"]!)
                prepareItemDataListData(indexPath)
            default:
                return
            }
            
        case .grocerest:
            switch indexPath.section {
            case 0:
                if let objectId = genericItems?[indexPath.row]["_id"].string {
                    shoppingListProductIds.add(objectId)
                    prepareItemDataListData(indexPath)
                }
                
            case 1:
                if let objectId = commercialItems?[indexPath.row]["_id"].string {
                    shoppingListProductIds.add(objectId)
                    prepareItemDataListData(indexPath)
                }
                
            default:
                return
            }
        }
        
    }

    
    
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        switch section {
        case 0:
            let headertop:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            headertop.textLabel!.textColor = UIColor.grocerestLightGrayColor()
            headertop.textLabel!.font = Constants.BrandFonts.avenirBook11
            headertop.textLabel!.frame = headertop.frame
            headertop.contentView.backgroundColor = UIColor(white:0.94, alpha:1.0)
            headertop.textLabel!.textAlignment = NSTextAlignment.left
        case 1:
            let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            header.textLabel!.textColor = UIColor.grocerestLightGrayColor()
            header.textLabel!.font = Constants.BrandFonts.avenirBook11
            header.textLabel!.frame = header.frame
            header.contentView.backgroundColor = UIColor(white:0.94, alpha:1.0)
            header.textLabel!.textAlignment = NSTextAlignment.left
        default:
            break
        }
    }

}
