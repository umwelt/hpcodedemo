//
//  GRSearchCompletionProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 18/04/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation


protocol SearchCompletionProtocol {
    func startSearchWithQuery(_ query:String, categoryId:String, lastTerm:String)
}

