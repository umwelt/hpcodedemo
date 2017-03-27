//
//  GRUserProductsClassified.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 01/02/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


var asFavourites: [String]!
var asHated: [String]!
var asTryable: [String]!
var asReviewed: [String]!
var asScanned: [String]!
var asFullyReviewed: [String]!




//asReviewed = [String]()
//asScanned = [String]()


/**
 Get Products user has classified
 
 - returns: [productId]
 */
func getFavouritedProductsFromLocal() -> [String] {
    asFavourites = [String]()
    
    let favourites = try! Realm().objects(GRUserClassifiedProducts)
    
    if favourites[0].favourites.count < 0 {
        return asFavourites
    } else {
        for item in favourites[0].favourites {
            if let itemId = item["id"] {
                asFavourites.append(itemId as! String)
            }
        }
    }
    return asFavourites
}

func getHatedProductsFromLocal() -> [String] {
    asHated = [String]()
    let hated = try! Realm().objects(GRUserClassifiedProducts)
    
    if hated[0].hated.count < 0 {
        return asHated
    } else {
        for item in hated[0].hated {
            if let itemId = item["id"] {
                asHated.append(itemId as! String)
            }
        }
    }
    return asHated
}

func getTryableProductsFromLocal() -> [String] {
    asTryable = [String]()
    let tryable = try! Realm().objects(GRUserClassifiedProducts)
    
    if tryable[0].totry.count < 0 {
        return asTryable
    } else {
        for item in tryable[0].totry {
            if let itemId = item["id"] {
                asTryable.append(itemId as! String)
            }
        }
    }
    return asTryable
}

func getReviewedProductsFromLocal() -> [String] {
    asReviewed = [String]()
    let review = try! Realm().objects(GRUserClassifiedProducts)
    
    if review[0].reviewed.count < 0 {
        return asReviewed
    } else {
        for item in review[0].reviewed {
            if let itemId = item["id"] {
                asReviewed.append(itemId as! String)
            }
        }
    }
    
    return asReviewed
}


func getScannedProductsFromLocal() -> [String] {
    asScanned = [String]()
    let scann = try! Realm().objects(GRUserClassifiedProducts)
    
    if scann[0].scanned.count < 0 {
        return asScanned
    } else {
        for item in scann[0].scanned {
            if let itemId = item["id"] {
                asScanned.append(itemId as! String)
            }
        }
    }
    return asScanned
}


func getFullyReviewdProductsFromLocal() -> [String] {
    asFullyReviewed = [String]()
    let freviewed = try! Realm().objects(GRUserClassifiedProducts)
    
    if freviewed[0].fullyReviewed.count < 0 {
        return asFullyReviewed
    } else {
        for item in freviewed[0].fullyReviewed {
            if let itemId = item["id"] {
                asFullyReviewed.append(itemId as! String)
            }
        }
    }
    return asFullyReviewed
}


