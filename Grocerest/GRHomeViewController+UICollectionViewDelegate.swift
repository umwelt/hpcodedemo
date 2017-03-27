//
//  GRHomeViewController+UICollectionViewDelegate.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 13/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

extension GRHomeViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func cellTitleClicked(_ sender: UITapGestureRecognizer) {
     //   return
//        let product = dataSource![sender.view!.tag]
//        let productDetail = GRProductDetailViewController()
//        productDetail.prepopulateWith(product: product)
//        productDetail.productId = product["_id"].stringValue
//        navigationController?.pushViewController(productDetail, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
}
