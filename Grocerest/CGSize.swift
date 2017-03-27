//
//  CGSize.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 18/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

extension CGSize{
    static var screenWidth : CGFloat{
        return (UIScreen.main.bounds.size.width)
    }
    
    static var screenHeight : CGFloat{
        return (UIScreen.main.bounds.size.height)
    }
    
    static var screenWidthRatioWith320 : CGFloat {
        return CGSize.screenWidth/320
    }
    
    static var largeProfileAvatar: CGSize {
        return CGSize(width: 230 / masterRatio, height: 230 / masterRatio)
    }
    
    static var cellProfileAvatar: CGSize {
        return CGSize(width: 86 / masterRatio, height: 86 / masterRatio)
    
    }
    static var menuProfileAvatar: CGSize {
        return CGSize(width: 100 / masterRatio, height: 100 / masterRatio)
    }
    static var smallProfileAvatar: CGSize {
        return CGSize(width: 44 / masterRatio, height: 44 / masterRatio)
    }
    

}
