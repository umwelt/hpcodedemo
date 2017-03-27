//
//  GRHomeViewController+UICollectionViewDataSource.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 13/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftLoader

extension GRHomeViewController :UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard dataSource != nil else {
            return 0
        }
        return (self.dataSource?.count)!
    }
    
    
    func resetEmbededViews(_ cell:GRHomeCollectionViewCell) {
        
        cell.reviewProductImageView.image = nil
        cell.reviewScrollView.viewFrequency?.resetOriginalState()
        cell.reviewScrollView.viewComment?.restoreCommentBox()
        cell.reviewScrollView.paginatedScrollView.contentOffset = CGPoint(x: 0, y: 0)
        cell.toTryButton.isSelected = false
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let product = self.dataSource![indexPath.row]
        
        let category = product["category"].stringValue
        let sanitizedString = product["display_brand"].stringValue.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let imageName = product["images"]["large"].stringValue
        let numberOfReviews = product["reviews"]["count"].intValue
        
        
        var cell: GRHomeCollectionViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GRHomeCollectionViewCell
        
        if (indexPath.row == self.dataSource!.count - 3) {getMoreItems()}
        
        if (cell == nil) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GRHomeCollectionViewCell
        }
        
        self.resetEmbededViews(cell)
        self.configureVoteButtons(cell, indexPath: indexPath)
        
        
        // Hide To try
        if getTryableProductsFromLocal().contains(product["_id"].stringValue) {
            cell.toTryButton.isHidden = false
            cell.toTryButton.isSelected = true
        }        
        
        cell.setImageForProduct(imageName, category: category)
        cell.reviewCategoryImageView.image = UIImage(named: category)
        cell.productMainLabel.text = product["display_name"].stringValue
        cell.productsSecondaryLabel.text = sanitizedString
        cell.productButton.tag = indexPath.row
        cell.productButton.addTarget(self, action: #selector(GRHomeViewController.actionProductButtonWasPressed(_:)), for: .touchUpInside)
        
        
        cell.onToTryButtonTapped = {
            if cell.toTryButton.isSelected {
                cell.toTryButton.isSelected = false
                self.removeProductFromTryableList(product["_id"].stringValue, index: indexPath.row)
            } else {
                cell.toTryButton.isSelected = true
                self.addProductToTryableList(product["_id"].stringValue, index: indexPath.row)
            }
        }
        
        
        if numberOfReviews > 0 {
            cell.numberOfReviews = product["reviews"]["count"].intValue
            cell.averageReviewScore = product["reviews"]["average"].doubleValue
            cell.swicthFirstReviewWidget(true)
            
            
        } else {
            cell.swicthFirstReviewWidget(false)
            cell.doublePointsImage = UIImage(named: "double_points")!
            cell.toTryButton.isHidden = false
            
        }
        
        
        return cell
    }
    
    
    
    func addProductToTryableList(_ productId: String, index: Int) {
        let currentProduct = IndexPath(row: index, section: 0)
        let cell: GRHomeCollectionViewCell! = collectionView?.cellForItem(at: currentProduct) as! GRHomeCollectionViewCell
        
        removeProductFromAllLists(productId) {
            GrocerestAPI.addProductToPredefinedList(GRUser.sharedInstance.id!, listName: Constants.PredefinedUserList.totry, fields: ["product": productId]) { data, error  in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    cell.toTryButton.isSelected = false
                    return
                }
                
                cell.toTryButton.isSelected = true
                getUserProductsList()
                
            }
            
        }
        
    }
    
    func removeProductFromTryableList(_ productId: String, index: Int) {
        
        let currentProduct = IndexPath(row: index, section: 0)
        
        let cell: GRHomeCollectionViewCell! = collectionView?.cellForItem(at: currentProduct) as! GRHomeCollectionViewCell
        var fields = [String:String]()
        fields["product"] = productId
        
        
        GrocerestAPI.removeProductToPredefinedList(GRUser.sharedInstance.id!, listName: Constants.PredefinedUserList.totry, productId: productId) {data, error in
            
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                cell.toTryButton.isSelected = true
                return
            }
            
            cell.toTryButton.isSelected = false
            getUserProductsList()
            
        }
        
    }
    
    func removeProductFromAllLists(_ id:String, onComplete: @escaping () -> Void) {
        GrocerestAPI.removeProductToPredefinedList(GRUser.sharedInstance.id!, listName: Constants.PredefinedUserList.favourites, productId: id) { _,_ in
            GrocerestAPI.removeProductToPredefinedList(GRUser.sharedInstance.id!, listName: Constants.PredefinedUserList.hated, productId: id) { _,_ in
                GrocerestAPI.removeProductToPredefinedList(GRUser.sharedInstance.id!, listName: Constants.PredefinedUserList.totry, productId: id) { _,_ in
                    onComplete()
                }
            }
        }
    }
    
    /**
        @param reset If `true` it purges the already downloaded products.
     */
    func downloadProducts(reset: Bool = false)  {
        if reset {
            dataSource = []
        }
        
        SwiftLoader.show(animated: true)
        
        if let useractiveID = GRUser.sharedInstance.id {
            
            GrocerestAPI.searchProduct(useractiveID, fields: self.requestedItems) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    if error != nil {
                        DispatchQueue.main.async { SwiftLoader.hide() }
                    } else {
                        let errorCode = data["error"]["code"].stringValue
                        
                        if errorCode == "E_INTERNAL" {
                            SwiftLoader.show(animated: true)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                                DispatchQueue.main.async { SwiftLoader.hide() }
                                self.downloadProducts()
                            }
                        } else if errorCode == "E_UNAUTHORIZED" {
                            DispatchQueue.main.async {
                                SwiftLoader.show(animated: false)
                                SwiftLoader.hide()
                            }
                            
                            DispatchQueue.main.async { self.noUserOrInvalidToken() }
                        }
                    }
                    
                    return
                }
                
                self.dataSource!.append(contentsOf: data.arrayValue)
                
                DispatchQueue.main.async { SwiftLoader.hide() }
                self.collectionView!.reloadData()
                self.loadingProductsView.removeFromSuperview()
            }
        } else {
            SwiftLoader.hide()
            self.noUserOrInvalidToken()
        }
    }
    
    func getMoreItems() {
        SwiftLoader.show(title: Constants.UserMessages.moreProductsToCome, animated: true)
        
        GrocerestAPI.searchProduct(GRUser.sharedInstance.id!, fields: self.requestedItems){ data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                return
            }
            
            self.dataSource!.append(contentsOf: data.arrayValue)
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.collectionView?.reloadData()
            }
        }
    }
    
}
