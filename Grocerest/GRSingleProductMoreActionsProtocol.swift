//
//  GRSingleProductMoreActionsProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

@objc protocol GRSingleProductMoreActionsProtocol {
    @objc optional func closeButtonWasPressed(_ sender: UIButton)
    @objc optional func createNewListWasPressed(_ sender:UIButton)
    @objc optional func localizeButtonWasPressed(_ sender:UIButton)
    @objc optional func preferitiButtonWasPressed(_ sender:UIButton)
    @objc optional func evitareButtonWasPressed(_ sender:UIButton)
    @objc optional func provareButtonWasPressed(_ sender:UIButton)
    @objc optional func recensioneButtonWasPressed(_ sender:UIButton)
}
