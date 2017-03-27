//
//  String.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 20/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

extension String {
    
    static func fullPathForImage(_ imageString:String) -> String {
        let encodedString = imageString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let fullPath = "\(getImagesPath())/\(encodedString!)"
        return fullPath
    }
    
    static func random(_ length: Int = 16) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.characters.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        
        return randomString
    }
    
    static func matches(_ string:String, pattern: String) -> Bool {
        // return true if the pattern matches the string entyrely
        let regexp = try! NSRegularExpression.init(pattern: pattern, options: .caseInsensitive)
        let range = NSMakeRange(0, string.characters.count)
        let matchingRange = regexp.rangeOfFirstMatch(in: string, options: .reportProgress, range: range)
        let valid = matchingRange.location == range.location && matchingRange.length == range.length
        return valid
    }
    
}
