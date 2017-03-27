//
//  DeepLinksManager.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 13/09/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import Bolts
import FBSDKCoreKit


enum DeepLinkSection: String {
    case product = "product"
    case productSearch = "product-search"
    case review = "review"
}


class DeepLinksManager : NSObject {
    
    // When we receive and url but the app is not ready yet (has been just opened)
    // We save it and then try to handle it later.
    
    static var pendingURL: String? = nil;
    static var applicationReady:Bool = false
    
    class func applicationReadySet() {
        let firstTime = !self.applicationReady
        self.applicationReady = true
        if firstTime, let url = pendingURL{
            self.handle(url: url)
        }
    }
    
    class func handle(url: String) {
        pendingURL = url
        print("DeeplinkManager: trying to handle url \(url)")
        
        if !applicationReady {
            print("DeeplinkManager: application is not ready yet")
            return
        }
        
        let components = url.components(separatedBy: "/")
        let section = components[2]
        
        if section == DeepLinkSection.product.rawValue {
            openProductDetail(id: components[3])
        } else if section == DeepLinkSection.productSearch.rawValue {
            if let queryString = components[3].removingPercentEncoding,
                queryString.hasPrefix("q=") {
                let query = String(queryString.characters.dropFirst(2))
                openProductSearch(with: query)
            }
            if let queryString = components[3].removingPercentEncoding,
                queryString.hasPrefix("?q=") {
                let query = String(queryString.characters.dropFirst(3))
                openProductSearch(with: query)
            }
        } else if section == DeepLinkSection.review.rawValue {
            openReviewDetail(id: components[3])
        }
    }
    
    // Branch.io callback
    
    class func branchioDeeplinkHandler(params: [AnyHashable : Any], error: Error?) -> Swift.Void {
        if error == nil {
            print(params.debugDescription)
            
            if let deeplinkPath = params[AnyHashable("$deeplink_path")] as? String {
                var url = deeplinkPath
                if !deeplinkPath.hasPrefix("grocerest://") {
                    url = "grocerest://\(deeplinkPath)"
                }
                handle(url: url)
            }
        }
    }

    // actions
    
    class func openProductDetail(id: String) {
        let productDetail = GRProductDetailViewController()
        productDetail.fromDeepLink = true
        productDetail.productId = id
        productDetail.populateFromDeepLink(id)
        navigateToViewController(productDetail)
    }
    
    class func openProductSearch(with query: String) {
        let productSearch = GRProductSearchViewController()
        productSearch.setQuery(to: query)
        navigateToViewController(productSearch)
    }
    
    class func openReviewDetail(id: String) {
        let reviewDetail = GRReviewDetailViewController()
        reviewDetail.reviewId = id
        navigateToViewController(reviewDetail)
    }
    
    class func navigateToViewController(_ controller: UIViewController) {
        if isModal {
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                UIApplication.topViewController()!.navigationController?.pushViewController(controller, animated: true)
            })
        }
        UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
    }
    
}
