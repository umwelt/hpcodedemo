//
//  GRMessageViewProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

@objc protocol GRMessageViewProtocol {
    func okMessageButtonWasPressed()
    @objc optional func forgottenMessageButtonWasPressed()
}
