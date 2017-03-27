//
//  GRUserProfileViewController+UITableViewDataSource.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 26/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftLoader

extension GRUserProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataReviews != nil {
            if dataReviews!["reviews"].count > 3 {
                return 3
            }
            return dataReviews!["reviews"].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: GRUserReviewTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRUserReviewTableViewCell
        
        let index = indexPath.row
        
        cell.selectionStyle = .none
        if (cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRUserReviewTableViewCell
        }
        
        cell.formatCellWith(dataReviews!["reviews"][indexPath.row])
        
        cell.onUsefullnessButtonTapped = {
            cell.numberOfUseful += cell.isUseful ? -1 : 1
            cell.isUseful = !cell.isUseful
            SwiftLoader.show(animated: true)
            
            //  print(self.dataReviews!["reviews"][indexPath.row]["_id"].stringValue)
            
            GrocerestAPI.toggleUsefulnessVote(reviewId: self.dataReviews!["reviews"][indexPath.row]["_id"].stringValue) { _,_ in
                SwiftLoader.hide()
            }
        }
        
        cell.onProductDetailButtonTapped = {
            if self.dataReviews!["reviews"].count == 0 { return }
            let productDetail = GRProductDetailViewController()
            DispatchQueue.main.async {
                productDetail.prepopulateWith(product: self.dataReviews!["reviews"][index]["product"])
            }
            productDetail.productId = self.dataReviews!["reviews"][index]["product"]["_id"].stringValue
            self.navigationController?.pushViewController(productDetail, animated: true)
            
        }
        
        cell.onProductReviewButtonTapped = {
            if self.dataReviews!["reviews"].count == 0  { return }
            let reviewDetail = GRReviewDetailViewController()
            //reviewDetail.onDismissed = { self.refresh() }
            reviewDetail.reviewId = self.dataReviews!["reviews"][index]["_id"].stringValue
            self.navigationController?.pushViewController(reviewDetail, animated: true)
        }
        
        
        if dataReviews!["reviews"][indexPath.row]["review"].stringValue.characters.count == 0 {
            cell.smallCell()
        } else {
            cell.largeCell()
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if dataReviews!["reviews"][indexPath.row]["review"].stringValue.characters.count == 0 {
            return 298 / masterRatio
        } else {
            return 386 / masterRatio
        }
    }
    
}
