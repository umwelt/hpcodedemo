//
//  GRListsProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


protocol GRListsProtocol {
    func addData(_ tableData: Array<JSON>)
}
