//
//  CustomActivitySource.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/11/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit
import Alamofire
import SwiftLoader

let ExcludedActivitySources:[UIActivityType] = [
    UIActivityType.print,
    UIActivityType.copyToPasteboard,
    UIActivityType.assignToContact,
    UIActivityType.saveToCameraRoll,
    UIActivityType.addToReadingList,
    UIActivityType.airDrop,
    // ref. http://stackoverflow.com/questions/31792506/how-to-exclude-notes-and-reminders-apps-from-the-uiactivityviewcontroller
    UIActivityType("com.apple.mobilenotes.SharingExtension"),
    UIActivityType("com.apple.mobilenotes.SharingExtension"),
    UIActivityType("com.apple.reminders.RemindersEditorExtension"),
    // the following ones are not actually excluded for some reason..
    UIActivityType("com.google.Drive.ShareExtension"),
    UIActivityType("com.apple.mobileslideshow.StreamShareService"),
    UIActivityType("com.codality.NotationalFlow.Share"),
    UIActivityType("com.apple.CloudDocsUI.AddToiCloudDrive"),
    UIActivityType("com.linkedin.LinkedIn.ShareExtension"),
    UIActivityType("com.getdropbox.Dropbox.ActionExtension")
]

class CustomActivitySource: NSObject, UIActivityItemSource {
    
    var message = ""
    var html = ""
    var url = "https://www.grocerest.com/promo/promo.html"
    var userCode = ""
    
    func prepare(done: @escaping () -> Void) {
        URLCache.shared.removeAllCachedResponses()
        
        self.getCode { code in
            self.url = "https://www.grocerest.com/promo/promo.html?code=\(code)"
            self.message = "Unisciti a Grocerest, la prima Community della spesa! \(self.url)"
            self.userCode = code
            
            self.getHTML { html in
                self.html = self.html
                    .replacingOccurrences(of: "<%= code %>", with: self.userCode)
                    .replacingOccurrences(of: "<%= username %>", with: GRUser.sharedInstance.username!)
            
                done()
            }
        }
    }
    
    func getCode(done: @escaping (_ code: String) -> Void) {
        GrocerestAPI.getReferalCodeManual() { data, error in
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                print("Could not fetch referral code")
                SwiftLoader.hide()
                return
            }
            done(data["code"].stringValue)
        }
    }
    
    func getHTML(done:@escaping (_ html:String) -> Void) {
        let htmlTemplateURL = "https://grocerest.com/transact/invitation.html"
        Alamofire.request(htmlTemplateURL).responseString(encoding: String.Encoding.utf8) { (response) in
                switch response.result {
                case .success:
                    if let htmlString = response.result.value {
                        done(htmlString)
                    }
                case .failure(let error):
                    print("Error loading HTML: \(error.localizedDescription)")
                    SwiftLoader.hide()
                }
        }
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return URL(string:self.url)!
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        return "Ti aspetto su Grocerest!"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        print("Sharing to activity", activityType)
        
        switch activityType {
            case UIActivityType.mail:
                return html
            case UIActivityType.postToFacebook:
                return message
            case UIActivityType.postToTwitter:
                return message
            default:
                return message
        }
        
    }
}

