//
//  GRAddProductProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 27/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

protocol GRAddProductProtocol {
    func closeButtonWasPressed(_ sender: UIButton)
    func addProductsWasPressed(_ sender: UIButton)
    func addCustomProductWasPressed(_ sender:UIButton)
    func navigateToShoppingList(_ sender:UIButton)

}
