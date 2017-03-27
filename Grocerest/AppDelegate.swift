
//
//  AppDelegate.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 29/10/15.
//  Copyright © 2015 grocerest. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import Fabric
import Crashlytics
import RealmSwift
import GoogleMaps
import Google
import Haneke

import Tune
import AdSupport
import CoreTelephony
import iAd
import MobileCoreServices
import Security
import StoreKit
import SystemConfiguration
import Branch

let Tune_Advertiser_Id   = "191627"
let Tune_Conversion_Key  = "3f9547df93f8f79e934042437db3072d"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TuneDelegate {
    
    var window: UIWindow?
    var viewController : GRHomeViewController?
    var shortcutItem: UIApplicationShortcutItem?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UISegmentedControl.appearance().setTitleTextAttributes(NSDictionary(objects: [UIFont.systemFont(ofSize: 14.0)], forKeys: [NSFontAttributeName as NSCopying]) as! [AnyHashable: Any], for: UIControlState())
        
        // Cleans Haneke's image cache
        Shared.imageCache.removeAll()
        
        // [Configure Realm]
        configureRealm()
        
        // [Configure fabric]
        configureFabric()
        
        // [Configure Google]
        configureGoogle()
        
        // [Configure Tune]
        TuneManager.configure()
        
        // push notifications
        //registerForPushNotifications(application)
        
        // Check if launched from notification
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
            GRLocalNotificationHUB.pendingNotification = userInfo
        }
        
        // Handle old plain deeplinks i.e. grocerest://product/id
        if let url = launchOptions?[UIApplicationLaunchOptionsKey.url] as? URL {
            // set url to be handled once the app is ready
            DeepLinksManager.handle(url: url.absoluteString)
        }
        
        // Branch.io deeplink/Universal link handler
        let branch: Branch = Branch.getInstance()
        branch.initSession(
            launchOptions: launchOptions,
            andRegisterDeepLinkHandler: DeepLinksManager.branchioDeeplinkHandler
        )
        
        // used to simulate remote notifications during develoment
        // GRLocalNotificationHUB.pendingNotification = ["type":"product-proposal-accepted","target":"AVIb7QJnbOBzYtecqHJ0"]
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Respond to Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
        Branch.getInstance().continue(userActivity)
        return true
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            print("Requesting push notification device token")
            application.registerForRemoteNotifications()
        } else {
            print("Push notifications are not enabled")
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        registerUserForPushNotifications(tokenString)
    }

    func registerUserForPushNotifications(_ token: String) {
        let userDefaults = UserDefaults.standard
        var parameters = [String:String]()
        parameters["type"] = "apn"
        parameters["value"] = token
        
        GrocerestAPI.registerTokenForNotifications(GRUser.sharedInstance.id!, token: token, parameters: parameters) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                print("DeviceToken could not be sent to server")
                return
            }
            
            print("Sent deviceToken to server: ", token)
            
            if let registeredToken = data["value"].string {
                userDefaults.setValue(registeredToken, forKey: "deviceToken")
                userDefaults.synchronize()
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        DeepLinksManager.handle(url: url.absoluteString)
        TuneManager.applicationDidOpenURL(
            url: url, sourceApplication: sourceApplication
        )
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
    }
    
    // This method is also called when application is in the background only under the following conditions
    // - background mode "remote-notification" is active in Info.plist
    // - the notification payload contains 'content-available' = 1
    // Since iOS 10 (i suppose) this is also called when the app is completely closed and it gets opened
    // because of the user tapping a notification. We receive the same notification that's received in
    // didFinishLaunchingWithOptions.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if GRLocalNotificationHUB.pendingNotification != nil { return }
        
        if application.applicationState == .inactive {
            // NOTE: *unintuitively* this happens if the notification was *clicked* while
            // the app was already open (either in background or foreground)
            print("Remote notification was clicked while app was open (bg or fg)")
            GRLocalNotificationHUB.notificationTapped(JSON(userInfo))
        } else if application.applicationState == .background {
            print("Remote notification received while app in background")
        } else {
            print("Remote notification received while app in foreground")
            GRLocalNotificationHUB.notificationShowInApp(JSON(userInfo))
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        if application.applicationState == .inactive {
            // NOTE: *unintuitively* this happens if the notification was *clicked* while
            // the app was already open (either in background or foreground)
            print("Local notification was clicked while app was open (bg or fg)")
            GRLocalNotificationHUB.notificationTapped(JSON(notification.userInfo!))
        } else if application.applicationState == .background {
            print("Local notification received while app in background")
        } else {
            print("Local notification received while app in foreground")
        }
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        FBSDKAppEvents.activateApp()
        TuneManager.measureSession()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func configureRealm() {
        let config = Realm.Configuration(
            schemaVersion: 7,
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    
    func configureFabric() {
        Fabric.sharedSDK().debug = false
        Fabric.with([Crashlytics.self()])
    }
    
    func configureGoogle() {
        // [START tracker_swift]
        GMSServices.provideAPIKey("AIzaSyCfJlTLiBiHYecHdXPnOndipcLNecGEzPQ")
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        
        gai?.trackUncaughtExceptions = true  // report uncaught exceptions
        gai?.logger.logLevel = GAILogLevel.none  // remove before app release
        // [END tracker_swift]
    }
}

