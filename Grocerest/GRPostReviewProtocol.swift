//
//  GRPostReviewProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@objc protocol GRPostReviewProtocol {
    
    @objc optional func postVoteForItem(_ sender:UIButton)
    @objc optional func postFrequencyForItem(_ sender:UIButton)
    @objc optional func postCommentForItem(_ sender:UIButton)
    
    
}
