//
//  GRRegisterUser.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation


struct GRRegisterUser {
    let username: String
    let password: String
    let name: String
    let lastname: String
    let email: String
    let tosAcceptance: Bool
    let newsletterConsent: Bool
    let facebookData: [String:String]?
}