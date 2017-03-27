//
//  GRLoginViewDelegate.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 06/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit


protocol GRLoginViewDelegate: UITextFieldDelegate {
    
func backButtonPressed(_ backButton: UIButton)
func loginButtonWasPressed()
    
}
