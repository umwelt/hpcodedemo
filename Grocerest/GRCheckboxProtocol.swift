//
//  CheckboxDelegate.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation

protocol GRCheckboxProtocol {
    func didSelectCheckbox(_ state: Bool, identifier: Int, title: String)
}
