//
//  GRReviewBoxWriteCommentProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 10/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

@objc protocol GRReviewBoxWriteCommentProtocol {
    @objc optional func writeCommentWasPressed(_ sender: UIButton)
    @objc optional func reopenCommentWasPressed(_ textView: UITextView)
}
