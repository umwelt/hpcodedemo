//
//  GRMenuProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 12/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

@objc protocol GRMenuProtocol {
    @objc optional func navigateToHome(_ sender: UIButton)
    @objc optional func navigateToMyList(_ sender: UIButton)
    @objc optional func navigateToProducts(_ sender: UIButton)
    @objc optional func navigateToUsers(_ sender: UIButton)
    @objc optional func navigateToBrands(_ sender: UIButton)
    @objc optional func navigateToFindShops(_ sender:UIButton)
    @objc optional func navigateToSettings(_ sender:UIButton)
    @objc optional func menuButtonWasPressed(_ sender: UIButton)
    @objc optional func helpButtonWasPressed(_ sender:UIButton)
    @objc optional func logoutButtonWasPressed(_ sender: UIButton)
    @objc optional func profileButtonWasPressed(_ sender: UIButton)
}
