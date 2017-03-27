//
//  GRUserViewModel.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 13/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation

struct GRUserViewModel {
    
    var display_name: String?
    var lastname: String?
    var bearerToken: String?
    var family: String?
    var firstname: String?
    var email: String?
    var username: String?
    var picture: String?
    var education: String?
    var gender: String?
    var id: String?
    var score: Int?
    var version: Int?
    var profession: String?
    var categories: Array<String>?
    let facebookData: [String:String]?
    
    enum InputError: Error {
        case e_NOT_FOUND
        case e_INTERNAL
    }

}
