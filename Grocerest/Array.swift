//
//  Array.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 07/12/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

// Swift 2 Array Extension
extension Array where Element: Equatable {
    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}
