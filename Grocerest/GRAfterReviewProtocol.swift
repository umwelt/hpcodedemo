//
//  GRAfterReviewProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 07/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

@objc protocol GRAfterReviewProtocol {
    @objc optional func passProductReview(_ review:String, indexRow: Int, currentReview: String)
}
