//
//  ProductSharingActivitySource.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 10/01/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation
import UIKit

class ProductSharingActivitySource: NSObject, UIActivityItemSource {
    
    private var product: JSON = []
    private var url: String = ""
    
    convenience init(product: JSON, permalink url: String) {
        self.init()
        self.product = product
        self.url = url
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        URLCache.shared.removeAllCachedResponses()
        // This little fix is needed since the backend can sometimes
        // send invalid urls
        let cleanedUrl: String = url
            .replacingOccurrences(of: "\t", with: "")
            .replacingOccurrences(of: " ", with: "+")
        return URL(string: cleanedUrl) ?? URL(string: "http://www.grocerest.com")!
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        return product["display_name"].stringValue
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        switch activityType {
        case UIActivityType.message:
            return "\(product["display_name"].stringValue) - Leggi le recensioni su Grocerest \(url)"
        case UIActivityType.mail:
            return "Leggi tutte le recensioni scritte dagli utenti di Grocerest \(url)"
        default:
            return "\(url)"
        }
    }
    
}
