//
//  Helper.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 18/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

class Helper {

    static func fromArrayString(_ array: [JSON]) -> String{
        let sentence = "\(array)"
        let left = sentence.replacingOccurrences(of: "[", with: "")
        let clean = left.replacingOccurrences(of: "]", with: "")
        return clean
    }
    
    static func ratingRetroCompatibility(_ data:JSON) -> AnyObject {
        if let intValue = data["rating"].int {
            return(intValue as AnyObject)
        } else {
            if let rating = data["rating"].string {
                return Int(rating)! as AnyObject
            }
            return 0 as AnyObject
        }
    }
    
    static func removeNotificationsToken() {
        let userDefaults = UserDefaults.standard
        if let deviceToken = userDefaults.string(forKey: "deviceToken") {
            GrocerestAPI.deleteSpecificToken(GRUser.sharedInstance.id!, token: deviceToken) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }
                
                userDefaults.removeObject(forKey: "deviceToken")
            }
        }
    }
    
}
