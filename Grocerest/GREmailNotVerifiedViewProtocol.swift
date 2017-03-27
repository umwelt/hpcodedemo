//
//  GRAPIErrorMessageViewProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

@objc protocol GREmailNotVerifiedErrorViewProtocol {
    @objc optional func logoutMessageButtonWasPressed()
    func retryMessageButtonWasPressed()
}
