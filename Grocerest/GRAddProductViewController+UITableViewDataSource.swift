//
//  GRAddProductViewController+UITableViewDataSource.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 12/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

extension GRAddProductViewController : UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch searchingSource {
        case .locale:
            switch section {
            case 0:
                if localGenericItems.count > 0 {
                    managedView.hideEmptyImage()
                }
                return localGenericItems.count
            case 1:
                if localCommercialItems.count > 0 {
                    managedView.hideEmptyImage()
                }
                return localCommercialItems.count
            default:
                return 0
            }
        case .grocerest:
            switch section {
            case 0:
                if genericItems != nil {
                    if (genericItems?.count)! > 3 {
                        return 3
                    }
                    return (genericItems?.count)!
                }
                return 0
            case 1:
                if self.commercialItems != nil {
                    return commercialItems!.count
                }
                return 0
            default:
                return 0
            }
        }
    }
    
    
    // MARK: Cells format
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        GROneLineProductViewCell.appearance().selectedBackgroundView = selectedCellBackgroundView()
        
        var cell: GROneLineProductViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GROneLineProductViewCell
        
        cell.selectionStyle = .none
        
        if (cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GROneLineProductViewCell
        }
        
        cell.productImage?.image = nil
        cell.removeSelectedBackgroundColorForCell()
        
        switch searchingSource {
            
        case .locale:

            switch indexPath.section {
            case 0:
                
                tableView.rowHeight = 50
                
                cell.formatLocalGenericCell()
                
                if self.localGenericItems[indexPath.row]["customImage"] == "" {
                    if let category = localGenericItems[indexPath.row]["category"] {
                        cell.productImage?.image = UIImage(named: category)
                    }
                    
                } else {
                    cell.productImage?.layoutIfNeeded()
                    if let customImage = localGenericItems[indexPath.row]["customImage"] {
                        cell.productImage?.hnk_setImageFromURL(URL(string: String.fullPathForImage(customImage))!)
                    }
                }
                
                if self.localGenericItems[indexPath.row]["custom"] == "true" {
                    cell.productImage?.image = UIImage(named: "grocerest_heart_dark")
                }
                
                if let name = localGenericItems[indexPath.row]["name"] {
                    cell.cellProductLabel!.text = name
                }
                
                print("after: \(localGenericItems[indexPath.row]["product"])")
                
                if let productId = localGenericItems[indexPath.row]["product"] {
                    setCellBorderIfSelected("\(productId)", cell: cell)
                }
                
                return cell
            case 1:
                
                tableView.rowHeight = 100
                cell.formatLocalCommercialCell()
                cell.productImage?.layoutIfNeeded()
                
                let imageString = self.localCommercialItems[indexPath.row]["image"] ?? ""
                
                if imageString != "" {
                    cell.productImage?.hnk_setImageFromURL(URL(string: imageString)!)
                    cell.fixPositionForImageOnLocalCommmercialCell(20.00)
                } else {
                    if let category = self.localCommercialItems[indexPath.row]["category"] {
                        cell.productImage?.image = UIImage(named: category)
                        cell.fixPositionForImageOnLocalCommmercialCell(20.00)
                    }
                }

                
                if let name = localCommercialItems[indexPath.row]["name"] {
                    cell.cellProductLabel!.text = name
                }
                
                // LIBRI: Should add support when saving to local
                if let brandName = localCommercialItems[indexPath.row]["brand"] {
                    cell.brandLabel?.text = brandName
                }
                
                if let category = localCommercialItems[indexPath.row]["category"] {
                    cell.categoryLabel?.layer.borderColor = colorForCategory(category).cgColor
                    let categoryDisplayName = category.replacingOccurrences(of: "-", with: " ", options: NSString.CompareOptions.literal, range: nil)
                    cell.categoryLabel?.text = "  \(categoryDisplayName)  "
                    cell.categoryLabel?.textColor = colorForCategory(category)
                } else {
                    cell.categoryLabel?.layer.backgroundColor = UIColor.clear.cgColor
                }
                
                if let productId = localCommercialItems[indexPath.row]["product"] {
                    setCellBorderIfSelected("\(productId)", cell: cell)
                }
                
                return cell
            default:
                return cell
            }
            
        case .grocerest:
            
            switch indexPath.section {
            case 0:
                tableView.rowHeight = 50
                
                cell.formatGrocerestGenericCell()
                
                if let category = self.genericItems![indexPath.row]["category"].string {
                    if let smallImage =  self.genericItems![indexPath.row]["images"]["small"].string {
                        cell.productImage?.layoutIfNeeded()
                        cell.productImage?.hnk_setImageFromURL(URL(string: String.fullPathForImage(smallImage))!)
                    } else {
                        cell.productImage?.image = UIImage(named: category)
                    }
                }
                
                if let name = genericItems![indexPath.row]["name"].string {
                    cell.cellProductLabel!.text = name
                }
                
                if let productId = genericItems![indexPath.row]["_id"].string {
                    setCellBorderIfSelected(productId, cell: cell)
                }
                
                return cell
            case 1:
                
                if (cell == nil) {
                    cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GROneLineProductViewCell
                }
                
                tableView.rowHeight = 100
                
                cell.formatGrocerestCommercialCell()
                
                cell.productImage?.layoutIfNeeded()
                if let lastPathForImage = self.commercialItems![indexPath.row]["images"]["small"].string {
                    cell.productImage?.hnk_setImageFromURL(URL(string: String.fullPathForImage(lastPathForImage))!)
                } else {
                    if let category = self.commercialItems![indexPath.row]["category"].string {
                        cell.productImage?.image = UIImage(named: category)
                    }
                }
                
                if let name = self.commercialItems![indexPath.row]["display_name"].string {
                    cell.cellProductLabel!.text = name
                }
                
                cell.brandLabel?.text = productJONSToBrand(data: self.commercialItems![indexPath.row])
                
                if let category = self.commercialItems![indexPath.row]["category"].string {
                    cell.categoryLabel?.layer.borderColor = colorForCategory(category).cgColor
                    cell.categoryLabel?.layer.borderWidth = 1
                    let categoryDisplayName = category.replacingOccurrences(of:"-", with: " ", options: NSString.CompareOptions.literal, range: nil)
                    cell.categoryLabel?.text = "  \(categoryDisplayName)  "
                    cell.categoryLabel?.textColor = UIColor.grocerestLightGrayColor()
                } else {
                    cell.categoryLabel?.layer.backgroundColor = UIColor.clear.cgColor
                }
                
                if let productId = self.commercialItems![indexPath.row]["_id"].string {
                    self.setCellBorderIfSelected(productId, cell: cell)
                }
                
                return cell
            default:
                return cell
            }
        }
    }
    
    // MARK: Title for header
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        switch searchingSource {
        case .locale:
            switch section {
            case 0:
                if localGenericItems.count <= 0  {
                    return ""
                }
                return "Prodotti generici recenti"
            case 1:
                if localCommercialItems.count <= 0 {
                    return ""
                }
                return "Prodotti specifici recenti"
            default:
                return ""
            }
        case .grocerest:
            switch section {
            case 0:
                if (genericItems?.count)! <= 0 {
                    return ""
                }
                return "Prodotti Generici"
            case 1:
                if self.commercialItems!.count <= 0 {
                    return ""
                }
                return "Prodotti"
            default:
                return ""
            }
        }
    }
    
}
