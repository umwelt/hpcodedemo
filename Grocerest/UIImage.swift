//
//  UIImage.swift
//  Grocerest
//
//  Created by Davide Bertola on 11/11/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

extension UIImage {

    func imageWithInsets(_ insetDimen: CGFloat) -> UIImage? {
        return imageWithInset(UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }

    func imageWithInset(_ insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                       height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }

}
