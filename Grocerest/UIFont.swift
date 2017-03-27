//
//  UIFont.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

extension UIFont {
    
    /// Avenir Medium
    class func avenirMedium(_ fontSize:CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Medium", size: fontSize / masterRatio)!
    }
    
    /// Avenir Light
    class func avenirLight(_ fontSize:CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Light", size: fontSize / masterRatio)!
    }
    
    /// Avenir Book
    class func avenirBook(_ fontSize:CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Book", size: fontSize / masterRatio)!
    }
    
    /// Avenir Roman
    class func avenirRoman(_ fontSize:CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Roman", size: fontSize / masterRatio)!
    }
    /// Avenir Heavy
    class func avenirHeavy(_ fontSize:CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Heavy", size: fontSize / masterRatio)!
    }
    
    /// Ubuntu Light 128
    class func ubuntuLight(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-Light", size: fontSize / masterRatio)!
    }
    
    /// Ubuntu Medium
    class func ubuntuMedium(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-Medium", size: fontSize / masterRatio)!
    }
    
    /// Ubuntu Bold
    class func ubuntuBold(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-Bold", size: fontSize / masterRatio)!
    }
    
    /// Ubuntu Regular
    class func ubuntuRegular(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-Medium", size: fontSize / masterRatio)!
    }

    class func menuAvatarFont(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-Bold", size: fontSize / masterRatio)!
    }
    
}
