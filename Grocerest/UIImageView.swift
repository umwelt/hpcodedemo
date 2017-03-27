//
//  UIImageView.swift
//  Grocerest
//
//  Created by Davide Bertola on 10/11/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation


extension UIImageView {
    func setImageCrossdissolved(_ image:UIImage?) {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: nil)
    }
}
