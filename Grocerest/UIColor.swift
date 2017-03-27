//
//  UIColor.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 04/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red componet")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    var hexString:NSString {
        let colorRef = self.cgColor.components
        
        let r:CGFloat = colorRef![0]
        let g:CGFloat = colorRef![1]
        let b:CGFloat = colorRef![2]
        
        return NSString(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }
    
    class func alimentariCategoryColor() -> UIColor {
        return UIColor(hexString: "#E64A19")
    }
    
    class func bevandeCategoryColor() -> UIColor {
        return UIColor(hexString: "#FF9800")
    }
    
    class func prodottiPerLaCasaCategoryColor() -> UIColor {
        return UIColor(hexString: "#1976D2")
    }
    
    class func curaDellaPersonaCategoryColor() -> UIColor {
        return UIColor(hexString: "#00BCD4")
    }
    
    class func infanziaCategoryColor() -> UIColor {
        return UIColor(hexString: "#FBC9C9")
    }
    
    class func prodottiPerAnimaliCategoryColor() -> UIColor {
        return UIColor(hexString: "#62CD67")
    }
    
    class func integratoriCategoryColor() -> UIColor {
        return UIColor(hexString: "#4D7BA5")
    }
    
    class func cancelleriaCateogoryColor() -> UIColor {
        return UIColor(red:0.97, green:0.86, blue:0.22, alpha:1.0)
    }
    
    class func giocattoliCategoryColor() -> UIColor {
        return UIColor(red:0.61, green:0.92, blue:0.29, alpha:1.0)
    }
    
    class func libriCategoryColor() -> UIColor {
        return UIColor(hexString: "#AD92ED")
    }

   /// #4A4A4A
    
    class func grocerestDarkBoldGray() -> UIColor {
        return UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    }
    
    class func lightBlurredGray() -> UIColor {
        return UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0)
    }
    
    /// #979797
    
    class func nineSevenGrayColor() -> UIColor{
        return UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0)
    }
    
    // #F1F1F1
    
    class func F1F1F1Color() -> UIColor {
        return  UIColor(red: 0.945, green: 0.945, blue: 0.945, alpha: 1)
    }
    
    // Grocerest Color
    
    class func grocerestColor() -> UIColor {
        return UIColor(red: 0.863, green: 0.188, blue: 0.306, alpha: 1)
    }
    
    class func grocerestLightGrayColor()-> UIColor {
        return UIColor(red:0.592, green:0.592, blue:0.592, alpha:1)
    }
    
    class func grocerestOffText() -> UIColor{
        return UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
    }
    
    class func grocerestXDarkBoldGray() -> UIColor {
        return UIColor(red: 0.1391, green: 0.1384, blue: 0.1399, alpha: 1.0)
    }
    
    class func grocerestDarkGrayText() -> UIColor {
        return UIColor(red:0.384, green:0.384, blue:0.384, alpha:1)
    }
    
    class func buttonGrayLabels()-> UIColor {
        return UIColor(red: 0.427, green: 0.424, blue: 0.424, alpha: 1)
    }
    
    class func grocerestBlue() -> UIColor {
        return UIColor(red: 0.161, green:0.671, blue:0.886, alpha:1)
    }
    
    class func orangeBackground()-> UIColor{
        return UIColor(red: 1, green: 0.596, blue: 0, alpha: 1)
    }
    
    class func greenGrocerestColor() -> UIColor {
        return UIColor(red: 0.494, green: 0.827, blue: 0.129, alpha: 1)
    }
    
    class func grayText() -> UIColor{
        return UIColor(red:0.70, green:0.70, blue:0.70, alpha:1.0)
    }
    
    class func fullScreenGrayColor() -> UIColor {
        return UIColor(white:0.95, alpha:1.0)
    }
    
    class func grocerestClearColor() -> UIColor {
        return UIColor(red: 0.898, green: 0.204, blue: 0.325, alpha: 0.90)
    }
    
    class func veryClearGray() -> UIColor {
        return UIColor(red: 0.945, green: 0.945, blue: 0.945, alpha: 0.3)
    }
    
    /// Light background gray #FAFAFA
    class func lightBackgroundGrey() -> UIColor {
        return UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    }
    
    //UIColor.productsSeparatorcolor()
    class func productsSeparatorcolor() -> UIColor {
        return UIColor(white:0.89, alpha:1.0)
    }
    
    class func commentProductText() -> UIColor {
        return UIColor(red: 0.659, green: 0.659, blue: 0.659, alpha: 1)
    }
    /// #9B9B9B
    class func lightGrayTextcolor () -> UIColor {
        return UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
    }
    ///D6D0C9
    class func transparentGrayColor () -> UIColor {
        return UIColor(red:0.84, green:0.82, blue:0.79, alpha:1.0)
    }
    
    // #688668
    class func grayTextFieldColor() -> UIColor {
        return UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
    }
    
}
