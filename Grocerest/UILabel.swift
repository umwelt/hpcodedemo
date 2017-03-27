//
//  UILabel.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

extension UILabel {
    
    class func statsStaticLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.avenirRoman(26)
        label.textColor = UIColor.lightBlurredGray()
        label.textAlignment = .left
        return label
    }
    
    class func statsDinamycLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.ubuntuBold(28)
        label.textColor = UIColor.lightBlurredGray()
        label.textAlignment = .right
        return label
        
    }

}


