//
//  GRLoginViewDelegate.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 06/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit


protocol GRLoginViewProtocol: UITextFieldDelegate {
    
    func backButtonPressed(_ backButton: UIButton)
    func loginButtonWasPressed()
    func showPrivacy(_ sender:UIButton)
    func showTOS(_ sender:UIButton)
    func showForgottenCredentials(_ sender:UIButton)
}
