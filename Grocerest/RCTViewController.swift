//
//  RCTViewController.swift
//  Grocerest
//
//  Created by Davide Bertola on 15/03/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//


import Foundation
import UIKit
import React
import SwiftyJSON


class ReactBridge: NSObject {
    
    var providerSettings:RCTBundleURLProvider
    var jsCodeLocation:URL
    var rctBridge:RCTBridge
    
    static let sharedInstance = ReactBridge()
    
    override private init() {
    
        providerSettings = RCTBundleURLProvider.sharedSettings()!
        
        jsCodeLocation = providerSettings.jsBundleURL(
            forBundleRoot: "index.ios",
            fallbackResource: nil
        )
        
        rctBridge = RCTBridge(
            bundleURL: jsCodeLocation,
            moduleProvider: nil,
            launchOptions: nil
        )
        
        super.init()
    }
}




class RCTViewController: UIViewController {
    
    var moduleName:String = "ProductAvailabilityModal"
    var data:NSDictionary = [:]
    
    override func loadView() {
        super.loadView()
        
        // a bridge holds one jsContext and may be shared between multiple RCTViews
        
        let rctRootView = RCTRootView.init(
            bridge: ReactBridge.sharedInstance.rctBridge,
            moduleName: moduleName,
            initialProperties: data as [NSObject : AnyObject]
        )
        rctRootView?.backgroundColor = UIColor.clear
        
        view = rctRootView
        
        // listen for close notification
        
        let nc = NotificationCenter.default
        let notificationNameClose = NSNotification.Name("\(moduleName):close")
        var observer:NSObjectProtocol = NSObject()
        
        observer = nc.addObserver(
            forName: notificationNameClose,
            object: nil,
            queue: nil)
        { (notification) in // <- only once
            nc.removeObserver(observer)
            self.dismiss(animated: false, completion: nil)
        }
    }
}
