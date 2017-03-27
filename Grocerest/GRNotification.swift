//
//  GRNotification.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 30/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

open class GRNotification : UIView {
    
    static let constant = GRNotificationConstants()
    static var rect = CGRect(x: constant.nvMarginLeft, y: constant.nvStartYPoint, width: GRNotification.viewController!.view.frame.width - constant.nvMarginLeft - constant.nvMarginRight, height: constant.nvHeight)
    static var viewController: UIViewController?
    static var notificationCount = 0
    static var rotated:Bool = false
    

    static open func notify(_ title: String, subTitle: String, type: NotificationType, isDismissable: Bool) {
        self.notify(title, subTitle: subTitle, image: nil, type: type, isDismissable: isDismissable)
    }
    

    static open func notify(_ title: String, subTitle: String, image: UIImage?, type: NotificationType, isDismissable: Bool) {
        self.notify(title, subTitle: subTitle, image: image, type: type, isDismissable: isDismissable, completion: nil, touchHandler: nil)
    }
    

    static open func notify(_ title: String, subTitle: String, image: UIImage?, type: NotificationType, isDismissable: Bool, completion: (() -> Void)?, touchHandler: (() ->Void)?) {
        let notificationView: GRNotificationView = GRNotificationView(frame: rect, title: title, subTitle: subTitle, image: image, type: type, completionHandler: completion, touchHandler: touchHandler, isDismissable: isDismissable)
        GRNotification.notificationCount += 1
        GRNotification.removeOldNotifications()
        
        if let nc = GRNotification.viewController?.navigationController {
            nc.view.addSubview(notificationView)
        } else {
            GRNotification.viewController?.view.addSubview(notificationView)
        }
    }
    

    static open func setDefaultViewController (_ viewController: UIViewController) {
        self.viewController = viewController
        NotificationCenter.default.addObserver(self, selector: #selector(GRNotification.rotateRecognizer), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    // MARK: - Helper methods
    static func removeOldNotifications() {
        if let c = viewController?.navigationController ?? viewController {
            for case (let v as GRNotificationView) in c.view.subviews {
                v.notificationTimer.invalidate()
                v.removeFromSuperview()
                GRNotification.notificationCount -= 1
            }
        }
    }
    
    // Close active notification
    static func closeNotification() {
        if let c = viewController?.navigationController ?? viewController {
            for case (let v as GRNotificationView) in c.view.subviews { v.close() }
        }
    }
    
    
    // Checking device's rotation process and remove notifications to handle UI conflicts.
    static open func rotateRecognizer() {
        removeOldNotifications()
        UIApplication.shared.delegate?.window??.windowLevel = UIWindowLevelNormal
        self.rect = CGRect(x: constant.nvMarginLeft, y: constant.nvStartYPoint, width: GRNotification.viewController!.view.frame.width - constant.nvMarginLeft - constant.nvMarginRight, height: constant.nvHeight)
    }
    
    
}

public enum NotificationType {
    case plain
}




