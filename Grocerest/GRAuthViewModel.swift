//
//  GRAuthViewModel.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation


struct GRAuthViewModel {
    
    var username: String?
    var password: String?
    
    enum InputError: Error {
        case inputMissing
        case inputInvalid
    }
    
    func loginUser() throws -> GRAuthUser {
        guard let username = username, let password = password,
                  username.characters.count > 0 && password.characters.count > 0 else {
            throw InputError.inputMissing
        }
        
        return GRAuthUser(username: username, password: password)
    }
    
}
