//
//  GRAddFriendsProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 31/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

@objc protocol GRAddFriendsProtocol: UITextFieldDelegate {
    
    @objc optional func closeButtonWasPressed(_ sender: UIButton)
    @objc optional func addAllFriendsWasPressed(_ sender:UIButton)
    @objc optional func bottomButtonWasPressed(_ sender:UIButton)
    
 
}
