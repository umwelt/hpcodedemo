//
//  GrocerestAPI.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 23/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

//import Foundation

import SwiftyJSON
import SocketIO

import SwiftLoader
import Alamofire

/**
 Class to interact with Grocerest's backend API.

 All the methods accept the following callback: (data: JSON, error: NSError?) -> Void.
 Note that there are two kinds of error: client side and server side.

 Client side errors happen when, for example, there are connectivity problems on the iPhone.
 In this case an error contains an NSError reference and the data field contains an empty JSON.

 Server side errors happen when, for example, there are authorization problems, o internal
 server errors. In this case the error field is set to nil and the data field contains a JSON
 which holds details about the error (in the format specified by the API documentation) under
 the "error" key.

 If non errors happened then the error field is set to nil and data contains a JSON with the
 requested information.

 There is no need to pass bearerTokens around for authentication because when the user is created
 or does a login/logout then the bearerToken is cached in a class variable and used in all the
 subsequent calls to the backend.

 */

class WebService {
    
    class var grocerestURL: String {
        print(Bundle.main.object(forInfoDictionaryKey: "GrocerestBaseURL") as! String)
        return Bundle.main.object(forInfoDictionaryKey: "GrocerestBaseURL") as! String
    }
    
    class func apiVersion(_ version: String) -> String {
        return grocerestURL + "/v\(version)/"
    }
    
}


class GrocerestAPI {

    // Test backend
    //static let API_HOST = ""
    //static let API_URL = "\(API_HOST)/v1.0/"
    
    // Production backend
    static let API_HOST = WebService.grocerestURL
    static let API_URL = WebService.apiVersion("1.0")
    
    static var socket: SocketIOClient?
    static var bearerToken: String?
    static var userId : String?
    
    static let manager: SessionManager = SessionManager.`default`
    
    static func restoreUserCredentials(_ token:String, userId: String) {
        GrocerestAPI.bearerToken = token
        GrocerestAPI.userId = userId
    }




    // MARK: Configuration

    static func getCurrentConfiguration(_ callback: ((JSON, NSError?) -> Void)? = nil) {
        request(HTTPMethod.get,
            url: "configuration",
            callback: callback
        )
    }




    // MARK: User

    static func postUser(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(HTTPMethod.post,
            url: "user",
            parameters: fields,
            callback: { json, error in
                // If the user was created
                if GrocerestAPI.isRequestSuccessful(for: json, and: error) {
                    // It caches the bearerToken
                    GRUser.setUserFrom(json)
                    GRUser.saveUserDataToDisk(GRUser.sharedInstance)
                    GrocerestAPI.bearerToken = json["bearerToken"].stringValue
                    GrocerestAPI.userId = json["_id"].stringValue
                }
                // Then proceeds as normal
                if let call = callback {
                    call(json, error)
                }
        })
    }
    
    
    

    static func getUser(_ id: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "user/\(id)",
            callback: callback
        )
    }
    
    
    ///user/{id}/publicprofile
    static func getPublicProfile(_ id: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
                url: "user/\(id)/publicprofile",
                callback:callback)
    }


    static func getUserStats(_ id:String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
                url: "user/\(id)/stats",
                callback: callback
        )
    }

    static func updateUser(_ id: String, fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.put,
            url: "user/\(id)",
            parameters: fields,
            callback: callback
        )
    }

    static func deleteUser(_ id: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.delete,
            url: "user/\(id)",
            callback: callback
        )
    }


    static func changePassword(_ id:String, fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.put,
            url: "user/\(id)/password",
            parameters: fields,
            callback: callback
        )
    }

    static func resetPassword(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "password-reset",
                parameters: fields,
                callback: callback
        )
    }


    // MARK: Authentication

    static func login(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
            url: "authentication",
            parameters: fields,
            callback: { json, error in
                // If the user was authenticated
                if GrocerestAPI.isRequestSuccessful(for: json, and: error) {
                    // It caches the bearerToken + some useful stuff
                    GrocerestAPI.bearerToken = json["bearerToken"].stringValue
                    GrocerestAPI.userId = json["userId"].stringValue
                }
                
                // Then proceeds as normal
                if let call = callback {
                    call(json, error)
                }
        })
    }

    static func logout(_ callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.delete,
            url: "authentication",
            callback: { json, error in
                // If the user was authenticated
                
                if GrocerestAPI.isRequestSuccessful(for: json, and: error) {
                    // It caches the bearerToken
                    GrocerestAPI.bearerToken = nil
                }
                
                // Then proceeds as normal
                if let call = callback {
                    call(json, error)
                }
        })
    }

    // MARK: Users's friends


    static func findUserByEmail(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(
            .post,
            url: "users-search",
            parameters:fields,
            callback: callback)
    }

    static func findUserByName(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(
            .post,
            url: "users-search",
            parameters:fields,
            callback: callback)
    }


    //    static func findUserByEmail(fields: [String], callback: ((JSON, NSError?) -> Void)? = nil) {
    //        requestWithArray(
    //            "POST",
    //            url: "users-search",
    //            array: fields,
    //            callback: callback
    //        )
    //    }




    // MARK: User's shopping lists

    static func getUserShoppingLists(_ userId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "user/\(userId)/shopping-lists",
            callback: callback
        )
    }


    static func inviteUserToShoppingList(_ listId: String, collaborator: [String: Any],callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
            url: "shopping-list/\(listId)/collaborator",
            parameters: collaborator,
            callback: callback
        )
    }






    // MARK: User's predefined lists

    static func getProductsInPredefinedList(_ userId: String, listname: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "user/\(userId)/products-lists/\(listname)",
            callback: callback
        )
    }


    // MARK: GET Id's of products user has marked

    static func getProductsSelectedByUser(_ userId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
        url: "user/\(userId)/products-lists",
        callback: callback
        )
    }
    
    static func getProductPermalink(for productId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "product/\(productId)/permalink",
            callback: callback
        )
    }
    
    static func getReviewPermalink(for reviewId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "review/\(reviewId)/permalink",
            callback: callback
        )
    }

    /**
    Adding Items to predefined list

    - parameter userId:   userId
    - parameter listName: listName
    - parameter fields:   ProductId
    - parameter callback: responseBody
    */
    static func addProductToPredefinedList(_ userId: String, listName: String, fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.put,
            url: "user/\(userId)/products-lists/\(listName)",
            parameters: fields,
            callback: callback
        )
    }


    /**
     Removing Items to predefined list

     - parameter userId:   userId
     - parameter listName: listName
     - parameter fields:   ProductId
     - parameter callback: responseBody
     */
    static func removeProductToPredefinedList(_ userId: String, listName: String, productId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.delete,
            url: "user/\(userId)/products-lists/\(listName)/\(productId)",
            callback: callback
        )
    }

    // MARK: Top users
    
    static func getTopUsers(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "users-top",
                parameters: fields,
                callback: callback
        )
    }


    // MARK: User's categories

    static func getUserCategories(_ userId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "user/\(userId)/categories",
            callback: callback
        )
    }

    static func putUserCategories(_ userId: String, categoryIds: [String], callback: ((JSON, NSError?) -> Void)? = nil) {
        requestWithArray("PUT",
            url: "user/\(userId)/categories",
            array: categoryIds,
            callback: callback
        )
    }

    // MARK: Categories

    static func getCategories(_ callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "category",
            callback: callback
        )
    }

    static func getCategory(_ categoryId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "category/\(categoryId)",
            callback: callback
        )
    }

    // MARK: Shopping list

    static func postShoppingList(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {

        request(.post,
            url: "shopping-list",
            parameters: fields,
            callback: callback)
    }



    static func getShoppingList(_ id: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "shopping-list/\(id)",
            callback: callback
        )
    }

    static func updateShoppingList(_ id: String, fields: [String: String], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.put,
            url: "shopping-list/\(id)",
            parameters: fields,
            callback: callback
        )
    }

    static func deleteShoppingList(_ id: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.delete,
            url: "shopping-list/\(id)",
            callback: callback
        )
    }


    static func acceptOrDenyInvitationToShoppingList(_ listId: String, fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
        url: "shopping-list/\(listId)/collaborator/accept",
        parameters: fields,
        callback: callback
        )
    }

    static func inviteToShoppingList(_ listId: String, fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
            url: "shopping-list/\(listId)/collaborator",
            parameters: fields,
            callback: callback
        )
    }



    static func removeMeUserFromShoppingList(_ listId:String, userId:String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.delete,
            url: "shopping-list/\(listId)/collaborator/\(userId)",
            callback: callback
        )
    }

    static func removeBulkUsersFromShoppingList(_ listId:String, fields:[String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "shopping-list/\(listId)/collaborator/remove",
                parameters: fields,
                callback: callback
        )
    }


    /**
     Will cancell all items in shopping list

     - parameter listId:
     - parameter callback:
     */
    static func resetShoppingList(_ listId:String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
        url: "shopping-list/\(listId)/reset",
        callback: callback)
    }


    /**
     Will clone contents in list, creating a new one, all item list are owned bt creator

     - parameter listId:
     - parameter callback:
     */
    static func cloneShoppingList(_ listId:String, fields:[String:String], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
        url: "shopping-list/\(listId)/clone",
        parameters: fields,
        callback: callback)
    }


    // MARK: Shopping List's push updates

    /**
    Be wary that the JSON passed to the callback can contain either a shopping list or
    an error from the backend. An error is simply a JSON with an "error" key which contains
    a code, a message and sometimes a stacktrace.
    */
    
    static func listenForShoppingListUpdates(_ id: String, callback: ((JSON) -> Void)? ) {
        let url = URL(string:API_HOST)!
        self.socket = SocketIOClient(socketURL: url, config: [
        
            .nsp("/v1.0/shopping-list-updates"),
            .path("/socket.io"),
            // .Log(true),
            .reconnectWait(2),
            .reconnects(true),
            .log(false),
            .connectParams([
                "bearer": self.bearerToken!,
                "id": id
                ])
            ])


        self.socket!.on("connect") { data, _ in
            print("websocket: connect")
        }

        self.socket!.on("disconnect") { data, _ in
            print("websocket: disconnect")
        }

        self.socket!.on("err") { data, _ in
            print("websocket: error")
            callback?(JSON(data[0]))
        }

        self.socket!.on("update") { data, _ in
            print("websocket: update")
            callback?(JSON(data[0]))
        }

        var tries = 1

        func connect() {
            self.socket!.connect(timeoutAfter: 3) {
                tries += 1
                if tries <= 2 {
                    print("websocket: retrying to connect (\(tries))")
                    connect()
                } else {
                    GRNetworkErrorViewController.show()
                }
            }
        }

        print("websocket: trying to connect (\(tries))")
        connect()
        
    }

    static func stopListeningForShoppingListUpdates() {
        if (self.socket == nil) { return }
        self.socket?.disconnect()
        print("websocket: disconnect requested")
        self.socket = nil
    }

    // MARK: Shopping List's item

    static func postShoppingListItem(_ listId: String, fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
            url: "shopping-list/\(listId)/item",
            parameters: fields,
            callback: callback)
    }

    static func getShoppingListItem(listId: String, itemId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "shopping-list/\(listId)/item/\(itemId)",
            callback: callback
        )
    }

    static func updateShoppingListItem(listId: String, itemId: String, fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.put,
            url: "shopping-list/\(listId)/item/\(itemId)",
            parameters: fields,
            callback: callback
        )
    }

    static func deleteShoppingListItem(listId: String, itemId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.delete,
            url: "shopping-list/\(listId)/item/\(itemId)",
            callback: callback
        )
    }

    // MARK: Product's Review

    static func postReview(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
            url: "review",
            parameters: fields,
            callback: callback)
    }
    
    

    static func getReview(reviewId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "review/\(reviewId)",
            callback: callback
        )
    }

    static func updateReview(reviewId: String, fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.put,
            url: "review/\(reviewId)",
            parameters: fields,
            callback: callback
        )
    }


    static func deleteReview(reviewId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.delete,
            url: "review/\(reviewId)",
            callback: callback
        )
    }

    static func  searchForReview(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
        url: "reviews-search",
        parameters: fields,
        callback: callback)
    }
    
    static func  getReviewsForHome(_ maximumNumberOfReviews: Int, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "reviews-home",
                parameters: ["size": maximumNumberOfReviews],
                callback: callback)
    }
    
    static func postInvitationCodeForUser(_ userId: String, fields: [String:String], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "user/\(userId)/invitation-code",
                parameters: fields,
                callback: callback)
    }
    
    
    static func  getRelatedProducts(of productId: String, size: Int = 15, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "product/\(productId)/related",
                parameters: ["size": size],
                callback: callback)
    }
    

    static func toggleUsefulnessVote(reviewId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "review/\(reviewId)/vote",
                callback: callback)
    }
    
    
   // /v1.0/review/{id}/report
    
    
    static func willReportReview(_ reviewId: String, fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "review/\(reviewId)/report",
                parameters: fields,
                callback: callback)
    }
    
    static func getBrand(_ id: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(
            .post,
            url: "brand",
            parameters: ["brand": id],
            callback: callback
        )
    }
    
    static func searchBrand(fields: [String: Any]? = nil, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(
            .post,
            url: "brand-search",
            parameters: fields,
            callback: callback
        )
    }
    
    
    /**
     Search Products

     - parameter query:    if query key is empty, wil return 30 products
     - parameter callback: body response
     */
    static func searchProduct(_ userId: String, fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {

        request(.post,
            url: "user/\(userId)/products",
            parameters: fields,
            callback:callback)
    }

    static func searchProducts(fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
            url: "products-search",
            parameters: fields,
            callback:callback)
    }
    
    static func searchProductsForList(_ userId: String, fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {

        request(.post,
            url: "products-search",
            parameters: fields,
            callback:callback)
    }


    static func getProduct(_ productId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "product/\(productId)",
            callback: callback
        )
    }
    
    static func getProductAvailability( _ productId: String, callback: ((JSON, NSError?) -> Void)?  = nil) {
        request(
            .get,
            url: "product-availability/\(productId)",
            callback: callback
        )
    }


    static func searchProductsCompletion(_ fields:[String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "products-search/completion",
                parameters: fields,
                callback: callback
        )

    }



    /// Product Placement


    static func createProductPlacement(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "product-placement",
                parameters: fields,
                callback: callback
        )
    }




    static func searchProductPlacements(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
            url: "product-placement/search",
            parameters: fields,
            callback: callback
        )
    }



    //amendment

    static func eanAssociationProposal(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
        url: "amendment/ean-association-proposal",
        parameters: fields,
        callback: callback)
    }


    static func productProposal(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
            url: "amendment/product-proposal",
            parameters: fields,
            callback: callback)
    }



    // MARK: Store

    static func getStore(storeId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "store/\(storeId)",
            callback: callback
        )
    }

    static func postStore(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
            url: "store",
            parameters: fields,
            callback: callback)
    }

    // MARK: Store's search

    static func getStores(_ fields: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
            url: "store/search",
            parameters: fields,
            callback: callback
        )
    }


    // INVITATION TO GROCEREST

    static func inviteFriendsToGrocerest(_ fields: [String], callback: ((JSON, NSError?) -> Void)? = nil) {
        requestWithArray("POST",
                         url: "invitations",
                         array: fields,
                         callback:callback)
    }

    static func userAgent() -> String {
            //First get the nsObject by defining as an optional anyObject
            let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
            let nsBuildObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleVersion"] as AnyObject?

            //Then just cast the object as a String, but be careful, you may want to double check for nil
            let version = nsObject as! String
            let build = nsBuildObject as! String

            return  "Grocerest/\(version) (iOS; OS Version \(ProcessInfo().operatingSystemVersion.majorVersion).\(ProcessInfo().operatingSystemVersion.minorVersion).\(ProcessInfo().operatingSystemVersion.patchVersion) Build(\(build)))"
    }

    static func cancellAllRequest() {
        SessionManager.default.session.getAllTasks { tasks in
            tasks.forEach({ $0.cancel() })
        }
    }
    
    
    // Get referal code for Facebook Invite
    
    
    static func getReferalCode(_ callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "promocode/facebook",
                callback: callback
        )
    }
    
    // Get referal code for Manual/Explicit/code-based Invite
    // ref. http://buildmachine.grocerest.com:3001/blueprints/v1.0/blueprint.md#promocode-registration-invitation-code-type-post
    static func getReferalCodeManual(_ callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "promocode/registration-invite",
                callback: callback
        )
    }
    
    
    // Push notifications
    
    // Get list of active device token entries
    static func getActiveDeviceTokens(_ userId: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
                url: "user/\(userId)/push-tokens")
    }
    
    // Register Token
    static func registerTokenForNotifications(_ userId: String, token: String, parameters: [String: Any], callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.post,
                url: "user/\(userId)/push-tokens/\(token)",
                parameters: parameters,
                callback: callback)
    }
    
    // Get one specific push token entry
    static func getSpecificTokenWith(_ userId: String, token:String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.get,
                url: "user/\(userId)/push-tokens/\(token)",
                callback:callback)
    }
    
    
    //  DELETE/v1.0/user/{id}/push-tokens/{value}
    static func deleteSpecificToken(_ userId:String, token: String, callback: ((JSON, NSError?) -> Void)? = nil) {
        request(.delete,
                url: "user/\(userId)/push-tokens/\(token)",
                callback:callback)
    }
    

    // MARK: Utilities
    
    
    static func request(_ method: Alamofire.HTTPMethod, url: String, parameters: [String: Any]? = nil, callback: ((JSON, NSError?) -> Void)? = nil) {
        var headers: [String: String]?
        headers = ["user-agent" : userAgent()]
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            headers!["Device-UUID"] = uuid
        }
        
        if let token = bearerToken {
            headers!["Authorization"] = "Bearer \(token)"
        }
        
        manager.session.configuration.timeoutIntervalForRequest = 10
        
        // Asynchronous request in the highest priority background thread
        // WARNING: if you want to update the UI inside the callback of a
        //          GrocerestAPI request then you must ensure it's done in
        //          the main thread by using `DistpatchQueue.main.async`.
        DispatchQueue.global(qos: .background).async {

            manager
                .request(
                    "\(API_URL)\(url)",
                    method: method,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: headers
                )
                .responseJSON() { response in
                    
                    switch response.result {
                    case .success(let data):
                        print("<- \(method) \(API_URL)\(url) [\(Int(round(response.timeline.totalDuration * 1000))) ms]")
                        
                        // TODO: check for http errors that may arise
                        if let success = callback {
                            let json = JSON(data)
                            let errorCode = json["error"]["code"].stringValue
                            
                            switch errorCode {
                            case "E_CLIENT_TOO_OLD":
                                if !GRClientTooOldErrorViewController.isAlreadyOpen {
                                    GRClientTooOldErrorViewController.isAlreadyOpen = true
                                    print("Client too old")
                                    SwiftLoader.hide()
                                    let messageView = GRClientTooOldErrorViewController()
                                    UIApplication.topViewController()?.navigationController?.pushViewController(messageView, animated: true)
                                }
                            case "E_DEACTIVATED":
                                if !GRDeactivatedUserErrorViewController.isAlreadyOpen {
                                    GRDeactivatedUserErrorViewController.isAlreadyOpen = true
                                    print("Deactivated user")
                                    SwiftLoader.hide()
                                    let messageView = GRDeactivatedUserErrorViewController()
                                    UIApplication.topViewController()?.navigationController?.pushViewController(messageView, animated: true)
                                }
                            default:
                                success(json, nil)
                            }
                        }
                    case .failure(let error):
                        print("XX \(method) \(API_URL)\(url) [\(Int(round(response.timeline.totalDuration * 1000))) ms]")
                        if error._code == -6006 || error._code == 4 {
                            // JSON not serializable error. Alamofire issues this error if response's body
                            // is empty, because an empty response cannot be interpreted as a JSON object.
                            // So we just pass the success callback an empty JSON and an empty error, because
                            // all went fine.
                            print("Empty response \(error.localizedDescription)")
                            if let success = callback {
                                success(JSON("{}"), nil)
                            }
                        } else if error._code == -1009 {
                            GRNetworkErrorViewController.show()
                            if let fail = callback {
                                fail(JSON("{}"), error as NSError)
                            }
                        } else if error._code == -1001 {
                            GRNetworkErrorViewController.show()
                            if let fail = callback {
                                fail(JSON("{}"), error as NSError)
                            }
                        } else {
                            print("Request failed with error: \(error)")
                            if let fail = callback {
                                fail(JSON("{}"), error as NSError?)
                            }
                        }
                    }
            }
            
        }
    }

    // WARNING: I haven't tested this method, it could mess up
    static func requestWithArray(_ method: String, url: String, array: [String], callback: ((JSON, NSError?) -> Void)? = nil) {
        var request = URLRequest(url: URL(string: "\(API_URL)\(url)")!)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(userAgent(), forHTTPHeaderField: "user-agent")
        request.timeoutInterval = 10

        if let token = bearerToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            request.setValue(uuid, forHTTPHeaderField: "Device-UUID")
        }


        request.httpBody = try! JSONSerialization.data(withJSONObject: array, options: [])
        
        // Asynchronous request in the highest priority background thread
        // WARNING: if you want to update the UI inside the callback of a
        //          GrocerestAPI request then you must ensure it's done in
        //          the main thread by using `DistpatchQueue.main.async`.
        let q = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        
        q.async {
            
            manager
                .request(request)
                .responseJSON() { response in
                    switch response.result {
                    case .success(let data):
                        if let success = callback {
                            let json = JSON(data)
                            let errorCode = json["error"]["code"].stringValue
                            
                            switch errorCode {
                            case "E_CLIENT_TOO_OLD":
                                print("Client too old")
                                if UIApplication.topViewController() is GRClientTooOldErrorViewController {
                                    return
                                }
                                SwiftLoader.hide()
                                let messageView = GRClientTooOldErrorViewController()
                                UIApplication.topViewController()?.navigationController?.pushViewController(messageView, animated: true)
                            case "E_DEACTIVATED":
                                print("Deactivated user")
                                if UIApplication.topViewController() is GRDeactivatedUserErrorViewController {
                                    return
                                }
                                SwiftLoader.hide()
                                let messageView = GRDeactivatedUserErrorViewController()
                                UIApplication.topViewController()?.navigationController?.pushViewController(messageView, animated: true)
                            default:
                                success(json, nil)
                            }
                        }
                    case .failure(let error):
                        
                        if error._code == -6006 || error._code == 4 {
                            // JSON not serializable error. Alamofire issues this error if response's body
                            // is empty, because an empty response cannot be interpreted as a JSON object.
                            // So we just pass the success callback an empty JSON and an empty error, because
                            // all went fine.
                            if let success = callback {
                                success(JSON("{}"), nil)
                            }
                        } else if error._code == -1009 {
                            GRNetworkErrorViewController.show()
                            if let fail = callback {
                                fail(JSON("{}"), error as NSError?)
                            }
                        } else if error._code == -1001 {
                            GRNetworkErrorViewController.show()
                            if let fail = callback {
                                fail(JSON("{}"), error as NSError?)
                            }
                        } else {
                            print("Request failed with error: \(error)")
                            if let fail = callback {
                                fail(JSON("{}"), error as NSError?)
                            }
                        }
                    }
            }
            
        }
        
    }

    /**
        Does a default check for errors on the API request's results and prints them.
        Returns true if there were no errors, otherwise false.
     */
    static func isRequestSuccessful(for data: JSON, and error: NSError?) -> Bool {
        if let e = error {
            print("GROCEREST API - CLIENT ERROR")
            print(e.localizedDescription)
            return false
        }
        
        if data["error"].exists() {
            print("GROCEREST API - SERVER ERROR")
            print(data)
            return false
        }
        
        return true
    }
    
    /**
     Does a default check for errors on the API request's results and prints them.
     Returns true if there were errors, otherwise true.
     */
    static func isRequestUnsuccessful(for data: JSON, and error: NSError?) -> Bool {
        return !isRequestSuccessful(for: data, and: error)
    }
    
}
