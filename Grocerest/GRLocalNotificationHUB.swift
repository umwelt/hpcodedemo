//
//  GRLocalNotificationHUB.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 29/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SwiftLoader

enum NotificationTypes: String {
    case ShoppingListInvited = "shopping-list-invite"
    case ShoppingListInvitationAccepted = "shopping-list-invitation-accepted"
    case ShoppingListCompleted = "shopping-list-completed"
    case ProductProposalAccepted = "product-proposal-accepted"
    case RegistrationInvitedAccepted = "invitation-accepted"
    case LevelUp = "level-up"
    case UsefulVoteAdded = "useful-vote-added"
}

// currently messages are composed on the server-side

enum NotificationMessages: String {
    case ListInvitationMessage = "{value} ha condiviso con te una lista della spesa"
    case ListInvitationAcceptedMessage = "{value} ha accettato di condividere la tua lista della spesa"
    case ShoppingListCompletedMessage = "La lista della spesa {value} è stata completata"
    case ProductProposalAcceptedMessage = "Complimenti, il prodotto che hai proposto è stato aggiunto (+12)"
    case FriendInvitedAcceptedMessage = "Complienti, il tuo amico {value} {value_a} si è iscritto (+20)"
    case LevelUpMessage = "Congratulazioni {value} hai raggiunto il livello #{level}"
    case UsefulVoteAddedMessage = "La recensione sul prodotto '{value}' ha ricevuto un voto utile da {value}"
    case InvitationAcceptedMessage = "Complienti, il tuo amico #{firstname} #{lastname} si è iscritto (+20)"
}

// a hacky way to establish whether current top VC is modal or not.
// TODO: Better ideas ?

var isModal:Bool {
    var modal:Bool = false
    let topVC:UIViewController? = UIApplication.topViewController()
    
    if topVC?.presentingViewController?.presentedViewController == UIApplication.topViewController() {
        modal = true
    }
    if let nc = topVC?.navigationController {
        if nc.presentingViewController?.presentedViewController == topVC?.navigationController {
            modal = true
        }
    }
    if topVC?.tabBarController?.presentingViewController is UITabBarController {
        modal = true
    }
    return modal
}


class GRLocalNotificationHUB {
    
    static var pendingNotification:NSDictionary? = nil
    
    class func mayProcessPendingNotification() {
        // if there is a pending notification
        // (set by application:didfinishlaunching:withoptions:)
        // then we process it
        if let userInfo = pendingNotification {
            notificationTapped(JSON(userInfo))
        }
        pendingNotification = nil
    }
    
    // shows notifications received while app was open
    
    class func notificationShowInApp(_ userInfo: JSON) {
        print("notificationShowInApp() from Modal : \(isModal)")
        notificationShow(userInfo) { () -> Void in notificationTapped(userInfo) }
    }
    
    class func notificationShow(_ userInfo:JSON, onTap: (() -> Void)? = nil) {
        GRNotification.setDefaultViewController(UIApplication.topViewController()!)
        UIApplication.shared.isStatusBarHidden = true
        
        GRNotification.notify(
            "",
            subTitle: userInfo["aps"]["alert"].stringValue,
            image: nil,
            type: .plain,
            isDismissable: true,
            completion: nil,
            touchHandler: onTap
        )
    }
    
    // Decide what happens when a notification is tapped
    
    class func notificationTapped(_ userInfo:JSON) {
        
        var notificationType = NotificationTypes.ShoppingListInvited.rawValue
        notificationType = userInfo["type"].stringValue
        let title = "Attenzione"
        
        switch notificationType {
        case NotificationTypes.ShoppingListInvited.rawValue:
            let message:String = "\(userInfo["aps"]["alert"].stringValue) vuoi partecipare?"
            confirm("Attenzione", message:message) { () -> Void in
                shoppingListNotificationTapped(userInfo)
            }
            return
        case NotificationTypes.ShoppingListInvitationAccepted.rawValue:
            let message:String = "\(userInfo["aps"]["alert"].stringValue) vuoi aprire questa lista?"
            confirm(title, message:message) { () -> Void in
                shoppingListInvitationAcceptedTapped(userInfo)
            }
            return
        case NotificationTypes.ShoppingListCompleted.rawValue:
            let message:String = "\(userInfo["aps"]["alert"].stringValue) vuoi aprire questa lista?"
            confirm(title, message:message) {
                shoppingListCompletedTapped(userInfo)
            }
            return
        case NotificationTypes.ProductProposalAccepted.rawValue:
            let message:String = "\(userInfo["aps"]["alert"].stringValue) vuoi aprire questo prodotto?"
            confirm(title, message:message) { () -> Void in
                let vc = GRProductDetailViewController()
                vc.productId = userInfo["target"].stringValue
                vc.refresh()
                navigateToVc(vc)
            }
            return
        case NotificationTypes.RegistrationInvitedAccepted.rawValue:
            // TODO: what should happen ?
            return
        case NotificationTypes.LevelUp.rawValue:
            // TODO: what should happen ?
            return
        case NotificationTypes.UsefulVoteAdded.rawValue:
            let vc = GRReviewDetailViewController()
            vc.reviewId = userInfo["target"].stringValue
            vc.refresh()
            navigateToVc(vc)
            return
        default:
            return
        }
    }
    
    class func shoppingListNotificationTapped(_ userInfo:JSON) {
        let shoppingListId = userInfo["target"].stringValue
        
        GrocerestAPI.acceptOrDenyInvitationToShoppingList(shoppingListId, fields: ["accept": true]) { data, error in
            
            if shoppingListErrorCheck(error, data: data) { return }
            
            let shoppingListViewController = GRShoppingListViewController()
            shoppingListViewController.shoppingList = data
            DispatchQueue.main.async {
                SwiftLoader.hide()
                
                if isModal {
                    UIApplication.topViewController()?.dismiss(animated: true, completion: {
                        UIApplication.topViewController()!.navigationController?.pushViewController(shoppingListViewController, animated: true)
                    })
                }
                
                UIApplication.topViewController()!.navigationController?.pushViewController(shoppingListViewController, animated: true)
            }
        }
    }
    
    class func shoppingListInvitationAcceptedTapped(_ userInfo:JSON) {
        let shoppingListId:String = userInfo["target"].stringValue
        SwiftLoader.show(animated: true)
        
        GrocerestAPI.getShoppingList(shoppingListId) { data, error in
            
            if shoppingListErrorCheck(error, data: data) { return }
            
            let shoppingListViewController = GRShoppingListViewController()
            shoppingListViewController.shoppingList = data
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                
                if isModal {
                    UIApplication.topViewController()?.dismiss(animated: true, completion: {
                        UIApplication.topViewController()!.navigationController?.pushViewController(shoppingListViewController, animated: true)
                    })
                }
                
                UIApplication.topViewController()!.navigationController?.pushViewController(shoppingListViewController, animated: true)
            }
        }
    }
    
    class func shoppingListCompletedTapped(_ userInfo:JSON) {
        let shoppingListId:String = userInfo["target"].stringValue
        SwiftLoader.show(animated: true)
        
        GrocerestAPI.getShoppingList(shoppingListId) { data, error in
            
            if shoppingListErrorCheck(error, data: data) { return }
            
            let shoppingListViewController = GRShoppingListViewController()
            shoppingListViewController.shoppingList = data
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                
                if isModal {
                    UIApplication.topViewController()?.dismiss(animated: true, completion: {
                        UIApplication.topViewController()!.navigationController?.pushViewController(shoppingListViewController, animated: true)
                    })
                }
                
                UIApplication.topViewController()!.navigationController?.pushViewController(shoppingListViewController, animated: true)
                
            }
        }
    }
    
    class func shoppingListErrorCheck(_ error:NSError?, data:JSON) -> Bool {
        // On any error we assume the list no longer exists. Is this right ?
        if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.notificationErrorShow(Constants.UserMessages.listNoLongerExist)
            }
            return true
        }
        return false
    }
    
    class func notificationErrorShow(_ message:String) {
        let alertController = UIAlertController(title: "Attenzione", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Si", style: .default)
        alertController.addAction(OKAction)
        
        UIApplication.topViewController()!.present(alertController, animated: true, completion: {
            GRNotification.closeNotification()
        })
    }
    
    // Executes continuation() on user confirmation (just like js window.confirm)
    // note: this function could be moved to Utils or something like that
    
    class func confirm(_ title:String, message:String, continuation:(() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Si", style: .default) { (action) in
            continuation?()
        }
        alertController.addAction(OKAction)
        
        UIApplication.topViewController()!.present(alertController, animated: true, completion: {
            GRNotification.closeNotification()
        })
    }
    
    // handle navigation to other vcs
    
    class func navigateToVc(_ vc:UIViewController) {
        SwiftLoader.show(animated: true)
        if isModal {
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                UIApplication.topViewController()!.navigationController?.pushViewController(vc, animated: true)
            })
        }
        UIApplication.topViewController()!.navigationController?.pushViewController(vc, animated: true)
        SwiftLoader.hide()
    }
}
