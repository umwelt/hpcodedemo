//
//  TuneManager.swift
//  Grocerest
//
//  Created by Davide Bertola on 20/01/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation
import Tune
import SwiftyJSON


class TuneManagerDelegate : NSObject, TuneDelegate {
    public func tuneEnqueuedAction(withReferenceId referenceId: String!) {
        print("TuneManagerDelegate.tuneEnqueuedAction \(referenceId)")
    }
    
    public func tuneEnqueuedRequest(_ url: String!, postData post: String!) {
        print("TuneManagerDelegate.tuneEnqueuedRequest")
    }
    
    public func tuneDidSucceed(with data: Data!) {
        print("TuneManagerDelegate.tuneDidSucceed")
    }
    
    public func tuneDidFailWithError(_ error: Error!) {
        print("TuneManagerDelegate.tuneDidFailWithError \(error.localizedDescription)")
    }
    
    public func tuneDidReceiveDeeplink(_ deeplink: String!) {
        print("TuneManagerDelegate.tuneDidReceiveDeeplink \(deeplink)")
    }
    
    public func tuneDidFailDeeplinkWithError(_ error: Error!) {
        print("TuneManagerDelegate.tuneDidFailDeeplinkWithError \(error.localizedDescription)")
    }
}


class TuneManager : NSObject {
    static let delegate = TuneManagerDelegate()
    static let Tune_Advertiser_Id   = "191627"
    static let Tune_Conversion_Key  = "3f9547df93f8f79e934042437db3072d"

    class func configure() {
        print("TuneManager.configure")
        Tune.setDelegate(delegate)
        Tune.initialize(
            withTuneAdvertiserId: Tune_Advertiser_Id,
            tuneConversionKey: Tune_Conversion_Key
        )
    }
    
    class func trackRegistration(data:JSON) {
        print("TuneManager.trackRegistration \(data.debugDescription)")
        Tune.setUserEmail(data["email"].stringValue)
        Tune.setUserName(data["username"].stringValue)
        Tune.setUserId(data["_id"].stringValue)
        Tune.setFacebookUserId(data["facebook"]["id"].stringValue)
        Tune.measureEventName(TUNE_EVENT_REGISTRATION)
    }
    
    class func measureSession() {
        print("TuneManager.measureSession")
        Tune.measureSession()
    }
    
    class func applicationDidOpenURL(url: URL, sourceApplication: String?) {
        print("TuneManager.applicationDidOpenURL \(url.absoluteString)")
        Tune.applicationDidOpenURL(
            url.absoluteString,
            sourceApplication: sourceApplication
        )
    }
    
    // track registration after email verification..
    
    class PendingRegistration: NSObject {
        
        static let userDefaults = UserDefaults.standard
        static let key = "pendingRegistrationForUserId"
        
        class func set(userId:String) {
            // save the userId as pending
            userDefaults.setValue(userId, forKey: key)
            userDefaults.synchronize()
        }
        
        class func confirm(userId: String, data: JSON) {
            if
                let pendingUserId = userDefaults.value(forKey: key) as? String,
                pendingUserId == userId
            {
                TuneManager.trackRegistration(data: data)
                userDefaults.setValue("", forKey: key)
                userDefaults.synchronize()
            }
            
        }
    }
}
