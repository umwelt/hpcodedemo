//
//  GRSynchUserData.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 27/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftLoader
import RealmSwift
import SwiftyJSON

func getUserProductsList(_ completion:(() -> Void)? = nil) {
    GrocerestAPI.getProductsSelectedByUser(GRUser.sharedInstance.id!) { data, error in
        
        if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
            SwiftLoader.hide()
            return
        }
        
        persistUserProducts(data)
        completion?()
    }
}

func persistUserProducts(_ data:JSON) {
    let realm = try! Realm()
    let oldProducts = try! Realm().objects(GRUserClassifiedProducts.self)
    
    try! realm.write {
        realm.delete(oldProducts)
    }
    
    let userProducts = GRUserClassifiedProducts()
    
    let sortOperationQueue = OperationQueue()
    sortOperationQueue.maxConcurrentOperationCount = 3
    
    sortOperationQueue.addOperation {
        for id in data["favourites"].arrayValue {
            let productId = GRUserProduct()
            productId.id = id.string!
            userProducts.favourites.append(productId)
        }
    }
    
    sortOperationQueue.addOperation {
        for id in data["reviewed"].arrayValue {
            let productId = GRUserProduct()
            productId.id = id.string!
            userProducts.reviewed.append(productId)
        }
    }
    
    sortOperationQueue.addOperation {
        for id in data["scanned"].arrayValue {
            let productId = GRUserProduct()
            productId.id = id.string!
            userProducts.scanned.append(productId)
        }
    }
    
    sortOperationQueue.addOperation {
        for id in data["hated"].arrayValue {
            let productId = GRUserProduct()
            productId.id = id.string!
            userProducts.hated.append(productId)
        }
    }
    
    sortOperationQueue.addOperation {
        for id in data["totry"].arrayValue {
            let productId = GRUserProduct()
            productId.id = id.string!
            userProducts.totry.append(productId)
        }
    }
    
    sortOperationQueue.addOperation {
        for id in data["completely-reviewed"].arrayValue {
            let productId = GRUserProduct()
            productId.id = id.string!
            userProducts.fullyReviewed.append(productId)
        }
    }
    
    sortOperationQueue.waitUntilAllOperationsAreFinished()
    
    try! realm.write{
        realm.add(userProducts, update: true)
    }
    
}
