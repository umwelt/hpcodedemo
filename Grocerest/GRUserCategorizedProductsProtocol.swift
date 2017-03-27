//
//  GRUserCategorizedProductsProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 01/03/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@objc protocol GRUserCategorizedProductsProtocol {
    @objc optional func reloadDataSourceForList(_ name: String)
    @objc optional func restartScanner()
}
