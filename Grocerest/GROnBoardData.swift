//
//  GROnBoardData.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 28/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON



var userLat = 0.0
var userLng = 0.0


class GRFacebookUser: Object {
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    dynamic var id = ""
    dynamic var accessToken = ""
    dynamic var picture = ""
    dynamic var email = ""
    dynamic var name = ""
    dynamic var lastname = ""
}

/// Storing Categories

class GRCategory: Object {
    dynamic var id = ""
}


class GRCurrentUser: Object {

    
    override static func primaryKey() -> String {
        return "id"
    }
    
    dynamic var lastname = ""
    dynamic var bearerToken = ""
    dynamic var family = ""
    dynamic var firstname = ""
    dynamic var email = ""
    dynamic var username = ""
    dynamic var picture = ""
    dynamic var education = ""
    dynamic var gender = ""
    dynamic var memberSince = ""
    dynamic var id = ""
    dynamic var score = 0
    dynamic var level = 0
    dynamic var version = 0
    dynamic var profession = ""
    var categories =  List<GRCategory>()
    dynamic var facebookData:GRFacebookUser?
    
}

class GRAuthenticatingUser: Object {
    
}

class GRLastProductVisualized: Object {
    
    override static func primaryKey() -> String {
        return "product"
    }
    
    dynamic var product = ""
    dynamic var name = ""
    dynamic var tsUpdated = ""
    dynamic var image = ""
    dynamic var customImage = ""
    dynamic var counter = 0
    dynamic var category = ""
    dynamic var generic = ""
    dynamic var custom = ""
    dynamic var brand = ""
    
}
