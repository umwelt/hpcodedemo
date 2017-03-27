//
//  Various.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 07/12/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import QuartzCore

let notificationIdentifierReload: String = "Reload"

var masterRatio : CGFloat {
    get {
        let ratio = 750.00 / UIScreen.main.bounds.size.width
        return ratio
    }
}

func takeScreenshot(_ view: UIView) -> UIImageView {
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return UIImageView(image: image)
}

func takeScreenshotImage(_ view: UIView) -> UIImage {
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

func categoryNameFromCategorySlug(_ slug: String) -> String {
    return slug.replacingOccurrences(of: "-", with: " ", options: NSString.CompareOptions.literal, range: nil)
}

func colorForCategory(_ category:String) -> UIColor {
    switch category {
    case "Alimentari":
        return UIColor.alimentariCategoryColor()
    case "Bevande":
        return UIColor.bevandeCategoryColor()
    case "Prodotti-per-la-Casa":
        return UIColor.prodottiPerLaCasaCategoryColor()
    case "Cura-della-Persona":
        return UIColor.curaDellaPersonaCategoryColor()
    case "Infanzia":
        return UIColor.infanziaCategoryColor()
    case "Animali":
        return UIColor.prodottiPerAnimaliCategoryColor()
    case "Integratori":
        return UIColor.integratoriCategoryColor()
    case "Cancelleria":
        return UIColor.cancelleriaCateogoryColor()
    case "Giocattoli":
        return UIColor.giocattoliCategoryColor()
    case "Libri":
        return UIColor.libriCategoryColor()
    default:
        return UIColor.white
    }
}

func convertFromTimestamp(_ seconds: String) -> Date {
    let time = (seconds as NSString).doubleValue/1000.0
    return Date(timeIntervalSince1970: TimeInterval(time))
}

func productJONSToBrand(data:JSON) -> String {
    var brand:String = ""
    let authors = Helper.fromArrayString(data["others"]["authors"].arrayValue)
    if authors.characters.count > 0 {
        brand = "\(authors) - \(data["display_brand"].stringValue)"
    } else {
        brand = data["display_brand"].stringValue
    }
    return brand
}

// DeviceModel

enum UIUserInterfaceIdiom : Int
{
    case unspecified
    case phone
    case pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}
