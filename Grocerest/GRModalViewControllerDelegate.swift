//
//  GRModalViewControllerDelegate.swift
//  Grocerest
//
//  Created by Davide Bertola on 10/04/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@objc protocol GRModalViewControllerDelegate {
    @objc optional func modalWasDismissed(_ modal:UIViewController)
}
