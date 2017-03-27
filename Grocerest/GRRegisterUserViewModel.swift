//
//  GRRegisterUserViewModel.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation

struct GRRegisterUserViewModel {
    
    var username: String?
    var password: String?
    var name: String?
    var lastname: String?
    var email: String?
    var tosAcceptance: Bool?
    var newsletterConsent: Bool?
    var facebookData: [String:String]?
    
    
    enum InputError: Error {
        
        case inputMissing
        case inputInvalid
        case deniedTOS
        case facebookError
        case privateEmail
        
    }
    
    /// Registering user with email
    
    func registerUser() throws -> GRRegisterUser {
        
        guard let username = username, let password = password, let name = name, let lastname = lastname, let email = email,  username.characters.count > 0 && password.characters.count > 0 && name.characters.count > 0 &&  lastname.characters.count > 0 && email.characters.count > 0
            else {
                
                throw InputError.inputMissing
        }
        
        guard let tosAcceptance = tosAcceptance, tosAcceptance == true else {
            
            throw InputError.deniedTOS
            
        }
        

        
        return GRRegisterUser(username: username, password: password, name: name, lastname: lastname, email: email, tosAcceptance:tosAcceptance, newsletterConsent:newsletterConsent!, facebookData: facebookData)
        
    }
    
    /// Registering user via Social Network
    
    
    func registerUserWithFacebookData() throws -> GRRegisterUser {
        guard let facebookData = facebookData, facebookData["accessToken"] != nil else {
                throw InputError.facebookError
        }
        
        guard let email = email, email.characters.count > 0  else {
                throw InputError.privateEmail
        }
        
        return GRRegisterUser(username: username!, password: password!, name: name!, lastname: lastname!, email: email, tosAcceptance:tosAcceptance!, newsletterConsent:newsletterConsent!, facebookData: facebookData)
    }
    
    
    
    
    
}
