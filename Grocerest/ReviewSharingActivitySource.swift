//
//  ReviewSharingActivitySource.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/01/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation
import UIKit

class ReviewSharingActivitySource: NSObject, UIActivityItemSource {
    
    private var review: JSON = []
    private var url: String = ""
    
    convenience init(review: JSON, permalink url: String) {
        self.init()
        self.review = review
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
        return review["product"]["display_name"].stringValue
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        switch activityType {
        case UIActivityType.message:
            return "\(review["product"]["display_name"].stringValue) - Recensione di \(review["author"]["username"].stringValue) \(url)"
        case UIActivityType.mail:
            return "Leggi la recensione di \(review["author"]["username"].stringValue) \(url)"
        default:
            return "\(url)"
        }
    }
    
}
