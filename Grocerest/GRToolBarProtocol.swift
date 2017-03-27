//
//  GRToolBarDelegate.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 06/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

@objc protocol GRToolBarProtocol {
    
    @objc optional func menuButtonWasPressed(_ menuButton: UIButton)
    @objc optional func grocerestButtonWasPressed(_ grocerestButton: UIButton)
    @objc optional func scannerButtonWasPressed(_ scannerButton: UIButton)
    @objc optional func searchButtonWasPressed(_ searchButton: UIButton)
    @objc optional func newlistButtonWasPressed(_ sender: UIButton)
    @objc optional func backButtonWasPressed(_ sender: UIButton)
    @objc optional func addProductButtonWasPressed(_ sender: UIButton)
    @objc optional func moreActionsForListWasPressed(_ sender:UIButton)
    @objc optional func settingsButtonWasPressed(_ sender:UIButton)
    
    @objc optional func inviteFriendsWasPressed(_ sender:UIButton)
    
    
    @objc optional func contactsWasPressed(_ sender:UIButton)
    @objc optional func fbcontactsWasPressed(_ sender:UIButton)

}

