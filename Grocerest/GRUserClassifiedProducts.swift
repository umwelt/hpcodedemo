//
//  GRUserClassifiedProducts.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 27/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class GRUserProduct: Object {
    override static func primaryKey() -> String {
        return "id"
    }
    
    dynamic var id = ""
}

class GRUserClassifiedProducts : Object{
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    dynamic var id = 1
    var favourites = List<GRUserProduct>()
    var hated = List<GRUserProduct>()
    var reviewed = List<GRUserProduct>()
    var scanned = List<GRUserProduct>()
    var totry = List<GRUserProduct>()
    var fullyReviewed = List<GRUserProduct>()
    
}
