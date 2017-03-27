//
//  GRAuthentication.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON



public typealias GRUserBearerToken = String

public typealias GRUserId = String

public typealias GRUserFacebookData = [String:AnyObject]

public typealias Credentials = (username: String, password: String)

public typealias AuthenticatedUser = (id:String, bearerToken: String)

public typealias UserMasterKeys = [String:AnyObject]

public typealias UserData = (firstName: String, lastname: String, gender: String, profession: String)

public typealias ActiveUser = (display_name: String, lastname: String, bearerToken: String, family: String, firstname: String, email:String, username: String, picture: String, education:String, gender: String, id:String, score:Int, version:Int, profession:String)

public typealias FacebookUser = (email: String, firstname: String, lastname: String, dateOfBirth: String, gender: String, profilePictureURL: String, facebookId: String, facebookAccessToken: String, countryISOCode: String, city:String)

var firstname: String?
var lastname: String?
var picture: String?
var email: String?
var username: String?
let userDefaults = UserDefaults.standard


class GrocerestConfiguration: Object {
    
    override static func primaryKey() -> String {
        return "id"
    }
    dynamic var id = ""
    dynamic var productImagesBaseUrl = ""
    dynamic var userImagesBaseUrl = ""
    dynamic var categoryImagesBaseUrl = ""
}


/**
 Intercept data from access, filters by login/registration
 In registration the body response contains all data to persist
 In login we get the userId and bearerToken to elaborate a getUser
 
 - parameter data:  response from either Registration || Login
 - parameter login: if login getUser: else pass
 */

func registerForPushNotifications() {
    let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
    UIApplication.shared.registerUserNotificationSettings(notificationSettings)
}

func saveCurrentUserAfterLogin(_ data: JSON, login: Bool) {
    
    registerForPushNotifications()
    GRUser.setUserFrom(data)
    GRUser.saveUserDataToDisk(GRUser.sharedInstance)
    
    if login {
        GrocerestAPI.getUser(GrocerestAPI.userId!) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            persistUserWithData(data)
        }
    } else {
        persistUserWithData(data)
    }
}



/**
 Persist data to Realm
 
 - parameter data: body with userinfo
 */
func persistUserWithData(_ data: JSON) {
    
    GRUser.setUserFrom(data)
    GRUser.saveUserDataToDisk(GRUser.sharedInstance)
    TuneManager.PendingRegistration.confirm(
        userId: data["_id"].stringValue, data: data
    )
    let currentUser = GRCurrentUser()
    
    
    if (data["categories"].array != nil) {
        for item in data["categories"].array! {
            let categorie = GRCategory()
            categorie.id = item.string!
            currentUser.categories.append(categorie)
        }
    }
    
    firstname = data["firstname"].stringValue
    lastname = data["lastname"].string
    
    picture = data["picture"].stringValue
    email = data["email"].stringValue
    username = data["username"].stringValue
    
    
    currentUser.username = data["username"].stringValue
    currentUser.lastname = data["lastname"].stringValue
    currentUser.bearerToken = data["bearerToken"].stringValue
    currentUser.family = data["family"].stringValue
    currentUser.firstname = data["firstname"].stringValue
    currentUser.email = data["email"].stringValue
    currentUser.memberSince = data["tsCreated"].stringValue
    currentUser.picture = data["picture"].stringValue
    currentUser.education = data["education"].stringValue
    currentUser.gender = data["gender"].stringValue
    currentUser.id = data["_id"].stringValue
    currentUser.score = data["score"].intValue
    currentUser.level = data["level"].intValue
    currentUser.version = data["__v"].intValue
    currentUser.profession = data["profession"].stringValue
    
    let realm = try! Realm()
    
    try! realm.write({ () -> Void in
        realm.add(currentUser, update: true)
    })
    
}



func getCurrentConfiguration(_ done:(()->Void)? = nil){
    
    
    GrocerestAPI.getCurrentConfiguration() { data, error in
        
        if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
            return
        }
        
        let currentConfiguration = GrocerestConfiguration()
        currentConfiguration.id = "1"
        
        if let productsURL = data["productImagesBaseUrl"].string,
            let userURL = data["userImagesBaseUrl"].string,
            let categoryURL = data["categoryImagesBaseUrl"].string {
            currentConfiguration.productImagesBaseUrl = productsURL
            currentConfiguration.userImagesBaseUrl = userURL
            currentConfiguration.categoryImagesBaseUrl = categoryURL
        }

        let realm = try! Realm()
        
        try! realm.write {
            realm.add(currentConfiguration, update: true)
            done?()
        }
    }
    
    
}

func getImagesPath() -> String {
    let realm = try! Realm()
    let configuration = realm.objects(GrocerestConfiguration.self)
    return configuration[0].productImagesBaseUrl
}

func getUserImagesPath() -> String {
    let realm = try! Realm()
    let configuration = realm.objects(GrocerestConfiguration.self)
    return configuration[0].userImagesBaseUrl
}




func formatGrocerestDate(_ timestamp:String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    let myDate = dateFormatter.string(from: convertFromTimestamp(timestamp))
    
    return myDate
    
}

func formateCarinaDate(_ timestamp:String) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    let myDate = formatter.string(from: convertFromTimestamp(timestamp))
    return myDate
}


func isDeviceOwner(_ userId: String) -> Bool {
    var isOwner = false
        if GRUser.sharedInstance.id! == userId {
            isOwner = true
            return isOwner
        }
    return isOwner
}




