//
//  GRCreateListProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 24/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

protocol GRCreateListProtocol: UITextFieldDelegate {
    func closeButtonWasPressed(_ sender: UIButton)
    func disclosureButtonWasPressed(_ sender: UIButton)
    func listNameReady(_ sender: UITextField)
    func createListWasPressed()
    func shareListWasPressed(_ sender:UIButton)
}



