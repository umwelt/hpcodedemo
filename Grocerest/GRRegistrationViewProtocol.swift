//
//  GRRegistrationViewDelegate.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 06/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

protocol GRRegistrationViewProtocol : UITextFieldDelegate {
    func backButtonPressed(_ backButton: UIButton)
    func termsButtonWasPressed(_ termsButton: UIButton)
    func newsletterButtonWasPressed(_ newsletterButton: UIButton)
    func registrationButtonWasPressed(_ registrationButton: UIButton)
    func displayPasswordButtonWasPressed(_ displayPasswordButton: UIButton)
    func showTOS(_ sender:UIButton)
    func showPrivacy(_ sender:UIButton)
    
}
