//
//  GRGRLastIdTappedCacher.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 07/02/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation

@objc
protocol GRLastIdTappedCacher {
    /**
     Keeps track of the last product/brand you clicked on in the form of its
     product id, so when you return from a review or a product profile
     only the correct table cell is updated.
     */
    var lastTappedId: String? { get set }
}
