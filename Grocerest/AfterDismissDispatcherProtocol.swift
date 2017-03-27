//
//  AfterDismissDispatcherProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 07/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

@objc protocol AfterDismissDispatcherProtocol {
    @objc optional func disptachAfterDismiss(_ perform:Bool)
}
