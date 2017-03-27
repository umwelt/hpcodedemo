//
//  GRUserStats.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 24/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//


import Foundation
import SwiftyJSON


private let productProposalsKey = "productProposalsKey"
private let levelKey = "levelKey"
private let successfulInvitationsKey = "successfulInvitationsKey"
private let scannedKey = "scannedKey"
private let levelStartKey = "levelStartKey"
private let levelEndKey = "levelEndKey"
private let reviewsHistogramKey = "reviewsHistogramKey"
private let completeReviewsKey = "completeReviewsKey"
private let eanAssociationsKey = "eanAssociationsKey"
private let scoreKey = "scoreKey"
private let reviewsKey = "reviewsKey"

private let userStatsPath = "userStats"


class GRUserStats: NSObject, NSCoding, NSCopying {
    
    var productProposals: Int32?
    var level: Int32?
    var successfulInvitations: Int32?
    var scanned: Int32?
    var levelStart: Int32?
    var levelEnd: Int32?
    var reviewsHistogram: String?
    var completeReviews: Int32?
    var eanAssociations: Int32?
    var score: Int32?
    var reviews: Int32?
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(productProposals!, forKey: productProposalsKey)
        aCoder.encode(level!, forKey: levelKey)
        aCoder.encode(successfulInvitations!, forKey: successfulInvitationsKey)
        aCoder.encode(scanned!, forKey: scannedKey)
        aCoder.encode(levelStart!, forKey: levelStartKey)
        aCoder.encode(levelEnd!, forKey: levelEndKey)
        aCoder.encode(reviewsHistogram, forKey: reviewsHistogramKey)
        aCoder.encode(completeReviews!, forKey: completeReviewsKey)
        aCoder.encode(eanAssociations!, forKey: eanAssociationsKey)
        aCoder.encode(score!, forKey: scoreKey)
        aCoder.encode(reviews!, forKey: reviewsKey)

    }
    
    
    override init() {
        super.init()
        productProposals = 0
        level = 0
        successfulInvitations = 0
        scanned = 0
        levelStart = 0
        levelEnd = 0
        reviewsHistogram = ""
        completeReviews = 0
        eanAssociations = 0
        score = 0
        reviews = 0
    }
    
  
    
    required init?(coder aDecoder: NSCoder) {
        productProposals = aDecoder.decodeInt32(forKey: productProposalsKey)  ?? 0
        level = aDecoder.decodeInt32(forKey: levelKey)  ?? 0
        successfulInvitations = aDecoder.decodeInt32(forKey: successfulInvitationsKey)  ?? 0
        scanned = aDecoder.decodeInt32(forKey: scannedKey)  ?? 0
        levelStart = aDecoder.decodeInt32(forKey: levelStartKey)  ?? 0
        levelEnd = aDecoder.decodeInt32(forKey: levelEndKey)  ?? 0
        reviewsHistogram = aDecoder.decodeObject(forKey: reviewsHistogramKey) as? String ?? ""
        completeReviews = aDecoder.decodeInt32(forKey: completeReviewsKey)  ?? 0
        eanAssociations = aDecoder.decodeInt32(forKey: eanAssociationsKey)  ?? 0
        score = aDecoder.decodeInt32(forKey: scoreKey)  ?? 0
        reviews = aDecoder.decodeInt32(forKey: reviewsKey)  ?? 0
        
    }
    
    
    
    func copy(with zone: NSZone?) -> Any {
        let userStats = GRUserStats()
        
        userStats.productProposals = productProposals
        userStats.level = level
        userStats.successfulInvitations = successfulInvitations
        userStats.scanned = scanned
        userStats.levelStart = levelStart
        userStats.levelEnd = levelEnd
        userStats.reviewsHistogram = reviewsHistogram
        userStats.completeReviews = completeReviews
        userStats.eanAssociations = eanAssociations
        userStats.score = score
        userStats.reviews = reviews
        
        return userStats
    }
    

    
    class func setUserStatsFrom(_ data:JSON) -> GRUserStats {
        let userStats = GRUserStats()
        
        if let productProposals =  data["productProposals"].int32 {
            userStats.productProposals = productProposals
        }
        
        if let level = data["level"].int32 {
            userStats.level = level
        }
        
        if let successfulInvitations = data["successfulInvitations"].int32 {
            userStats.successfulInvitations = successfulInvitations
        }
        
        if let scanned = data["scanned"].int32 {
            userStats.scanned = scanned
        }
        
        if let levelStart = data["levelStart"].int32 {
            userStats.levelStart = levelStart
        }
        
        if let levelEnd = data["levelEnd"].int32 {
            userStats.levelEnd = levelEnd
        }
        
        if let reviewsHistogram = data["reviewsHistogram"].string {
            userStats.reviewsHistogram = reviewsHistogram
        }
        
        if let completeReviews = data["completeReviews"].int32 {
            userStats.completeReviews = completeReviews
        }
        
        if let eanAssociations = data["eanAssociations"].int32 {
            userStats.eanAssociations = eanAssociations
        }
        
        if let score = data["score"].int32 {
            userStats.score = score
        }
        
        if let reviews = data["reviews"].int32 {
            userStats.reviews = reviews
        }
        
        
        GRUserStats.sharedInstance = userStats
        
        return userStats
        
        
    }
    
    static var sharedInstance : GRUserStats = GRUserStats.retrieveUserStatsDataFromDisk()
    
    
    class func saveUserStatsDataToDisk(_ user : GRUserStats!) {
        let data = NSMutableData()
        let archiver : NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(user, forKey: "keyValueString")
        archiver.finishEncoding()
        
        let success = data.write(toFile: GRUserStats.filePath, atomically: true)
        
        if !success {
            
        }
    }
    
    class var filePath: String! {
        return (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString).appendingPathComponent(userStatsPath)
    }
    
    class func retrieveUserStatsDataFromDisk() -> GRUserStats! {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: GRUserStats.filePath)) {
            let unarchiver : NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data)
            if let object = unarchiver.decodeObject(forKey: "keyValueString") as? GRUserStats {
                unarchiver.finishDecoding()
                return object
            }
        }
        return GRUserStats()
    }
    
    
    fileprivate class func cachesDirectoryWithPathComponent(_ component : String) -> String {
        return (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString).appendingPathComponent(component)
    }
    
    
}

