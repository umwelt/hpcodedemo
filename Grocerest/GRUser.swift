//
//  GRUser.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import SwiftyJSON


private let display_nameKey = "display_nameKey"
private let lastnameKey = "lastnameKey"
private let bearerTokenKey = "bearerTokenKey"
private let familyKey = "familyKey"
private let firstnameKey = "firstnameKey"
private let emailKey = "emailKey"
private let usernameKey = "usernameKey"
private let pictureKey = "pictureKey"
private let educationKey = "educationKey"
private let genderKey = "genderKey"
private let idKey = "idKey"
private let scoreKey = "scoreKey"
private let versionKey = "versionKey"
private let professionKey = "professionKey"
private let categoriesKey = "categoriesKey"
private let facebookDataKey = "facebookDataKey"
private let deactivatedKey = "deactivatedKey"
private let levelKey = "levelKey"
private let memberSinceKey = "memberSinceKey"
private let userPath = "user"

class GRUser: NSObject, NSCoding, NSCopying {
    
    var display_name: String?
    var lastname: String?
    var bearerToken: String?
    var family: String?
    var firstname: String?
    var email: String?
    var username: String?
    var picture: String?
    var education: String?
    var gender: String?
    var id: String?
    var score: Int64?
    var version: Int64?
    var level: Int64?
    var profession: String?
    var categories: Array<Any>?
    var facebookData: [String: Any]?
    var deactivated: Bool?
    var memberSince: String?
    
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(display_name, forKey: display_nameKey)
        aCoder.encode(lastname, forKey: lastnameKey)
        aCoder.encode(bearerToken, forKey: bearerTokenKey)
        aCoder.encode(family, forKey: familyKey)
        aCoder.encode(firstname, forKey: firstnameKey)
        aCoder.encode(email, forKey: emailKey)
        aCoder.encode(username, forKey: usernameKey)
        aCoder.encode(picture, forKey: pictureKey)
        aCoder.encode(education, forKey: educationKey)
        aCoder.encode(gender, forKey: genderKey)
        aCoder.encode(id, forKey: idKey)
        aCoder.encode(score!, forKey: scoreKey)
        aCoder.encode(version!, forKey: versionKey)
        aCoder.encode(level!, forKey: levelKey)
        aCoder.encode(profession, forKey: professionKey)
        aCoder.encode(categories, forKey: categoriesKey)
        aCoder.encode(facebookData, forKey: facebookDataKey)
        aCoder.encode(deactivated!, forKey: deactivatedKey)
        aCoder.encode(memberSince, forKey: memberSinceKey)
    }
    
    override init() {
        super.init()
        display_name = ""
        lastname = ""
        bearerToken = ""
        family = ""
        firstname = ""
        email = ""
        username = ""
        picture = ""
        education = ""
        gender = ""
        id = ""
        score = 0
        version = 0
        profession = ""
        categories = []
        facebookData = [:]
        deactivated = false
        level = 0
        memberSince = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        display_name = aDecoder.decodeObject(forKey: display_nameKey) as? String ?? ""
        lastname = aDecoder.decodeObject(forKey: lastnameKey) as? String ?? ""
        bearerToken = aDecoder.decodeObject(forKey: bearerTokenKey) as? String ?? ""
        family = aDecoder.decodeObject(forKey: familyKey) as? String ?? ""
        firstname = aDecoder.decodeObject(forKey: firstnameKey) as? String ?? ""
        email = aDecoder.decodeObject(forKey: emailKey) as? String ?? ""
        username = aDecoder.decodeObject(forKey: usernameKey) as? String ?? ""
        picture = aDecoder.decodeObject(forKey: pictureKey) as? String ?? ""
        education = aDecoder.decodeObject(forKey: educationKey) as? String ?? ""
        gender = aDecoder.decodeObject(forKey: genderKey) as? String ?? ""
        id = aDecoder.decodeObject(forKey: idKey) as? String ?? ""
        score = aDecoder.decodeInt64(forKey: scoreKey)  ?? 0
        version = aDecoder.decodeInt64(forKey: versionKey) ?? 0
        level = aDecoder.decodeInt64(forKey: levelKey)
        profession = aDecoder.decodeObject(forKey: professionKey) as? String ?? ""
        categories = (aDecoder.decodeObject(forKey: categoriesKey) as? Array<String>)!
        facebookData = (aDecoder.decodeObject(forKey: facebookDataKey) as? [String:String])!
        deactivated = aDecoder.decodeBool(forKey: deactivatedKey)
        memberSince = aDecoder.decodeObject(forKey: memberSinceKey) as? String ?? ""
        
    }
    
    func copy(with zone: NSZone?) -> Any {
        let user = GRUser()
        
        user.display_name = display_name
        user.lastname = lastname
        user.bearerToken = bearerToken
        user.family = family
        user.firstname = firstname
        user.email = email
        user.username = username
        user.picture = picture
        user.education = education
        user.gender = gender
        user.id = id
        user.score = score
        user.version = version
        user.level = level
        user.profession = profession
        user.categories = categories
        user.facebookData = facebookData
        user.deactivated = deactivated
        user.memberSince = memberSince
        
        return user
    }
    
    class func setUserFrom(_ data:JSON) -> GRUser {
        let user = GRUser()
        
        if let displayName =  data["display_name"].string {
            user.display_name = displayName
        }
        
        if let lastname = data["lastname"].string {
            user.lastname = lastname
        }
        
        if let bearerToken = data["bearerToken"].string {
            user.bearerToken = bearerToken
        }
        
        if let family = data["family"].string {
            user.family = family
        }
        
        if let firstname = data["firstname"].string {
            user.firstname = firstname
        }
        
        if let email = data["email"].string {
            user.email = email
        }
        
        if let username = data["username"].string {
            user.username = username
        }
        
        if let picture = data["picture"].string {
            user.picture = picture
        }
        
        if let education = data["education"].string {
            user.education = education
        }
        
        if let gender = data["gender"].string {
            user.gender = gender
        }
        
        if let id = data["_id"].string {
            user.id = id
        }
        
        if let score = data["score"].int64 {
            user.score = score
        }
        
        if let version = data["__v"].int64 {
            user.version = version
        }
        
        if let level = data["level"].int64 {
            user.level = level
        }
        
        if let profession = data["profession"].string {
            user.profession = profession
        }
        
        if let deactivated = data["deactivated"].bool {
            user.deactivated = deactivated
        }
        
        if let facebookData = data["facebook"].dictionaryObject {
            user.facebookData = facebookData as [String : AnyObject]?
        }
        
        if data["categories"].arrayObject != nil {
            user.categories = data["categories"].arrayObject as Array<AnyObject>?
        }
        
        user.memberSince = data["tsCreated"].stringValue
        
        GRUser.sharedInstance = user
        
        return user
        
        
    }
    
    static var sharedInstance : GRUser = GRUser.retrieveUserDataFromDisk()
    
    
    class func saveUserDataToDisk(_ user : GRUser!) {
        let data = NSMutableData()
        let archiver : NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(user, forKey: "keyValueString")
        archiver.finishEncoding()
        
        let success = data.write(toFile: GRUser.filePath, atomically: true)
        
        if !success {
            
        }
    }
    
    class var filePath: String! {
        return (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString).appendingPathComponent(userPath)
    }
    
    class func retrieveUserDataFromDisk() -> GRUser! {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: GRUser.filePath)) {
            let unarchiver : NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data)
            if let object = unarchiver.decodeObject(forKey: "keyValueString") as? GRUser {
                unarchiver.finishDecoding()
                return object
            }
        }
        return GRUser()
    }
    
    
    fileprivate class func cachesDirectoryWithPathComponent(_ component : String) -> String {
        return (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString).appendingPathComponent(component)
    }

    
}
