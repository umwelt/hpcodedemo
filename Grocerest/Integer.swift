//
//  Integer.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 07/12/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

extension Integer {
    
    var stringFormattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: hashValue)) ?? ""
    }
    
}
