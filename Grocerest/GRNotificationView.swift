//
//  GRNotificationView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 30/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class GRNotificationView : UIView, UIGestureRecognizerDelegate{
    var notificationTimer: Timer!
    var title: String?
    var subTitle: String?
    var image: UIImage?
    var type: NotificationType?
    var isDismissable: Bool = false
    let constants: GRNotificationConstants = GRNotificationConstants()
    var completionHandler:(() -> Void)?
    var touchHandler:(() -> Void)?
    
    
    
    var grocerestBrand = UILabel()
    init(frame: CGRect, title: String, subTitle: String?, type: NotificationType?, isDismissable: Bool) {
        super.init(frame: frame)
        self.initVariables(title, subTitle: subTitle, image: nil, type: type, completionHandler: nil, touchHandler: nil, isDismissable: isDismissable)
        self.setupNotification()
        
    }
    
    init(frame: CGRect, title: String, subTitle: String?, image: UIImage?, type: NotificationType?, isDismissable: Bool) {
        super.init(frame: frame)
        self.initVariables(title, subTitle: subTitle, image: image, type: type, completionHandler: nil, touchHandler: nil, isDismissable: isDismissable)
        self.setupNotification()
    }
    
    init(frame: CGRect, title: String, subTitle: String?, image: UIImage?, type: NotificationType?, completionHandler: (() -> Void)?, isDismissable: Bool) {
        super.init(frame: frame)
        self.initVariables(title, subTitle: subTitle, image: image, type: type, completionHandler: completionHandler, touchHandler: nil, isDismissable: isDismissable)
        self.setupNotification()
    }
    
    init(frame: CGRect, title: String, subTitle: String?, image: UIImage?, type: NotificationType?, completionHandler: (() -> Void)?, touchHandler: (() -> Void)?, isDismissable: Bool) {
        super.init(frame: frame)
        
        self.initVariables(title, subTitle: subTitle, image: image, type: type, completionHandler: completionHandler, touchHandler: touchHandler, isDismissable: isDismissable)
        self.setupNotification()
    }
    
    fileprivate func initVariables(_ title: String, subTitle: String?, image: UIImage?, type: NotificationType?, completionHandler: (() -> Void)?, touchHandler: (() -> Void)?, isDismissable: Bool) {
        self.title = title
        self.subTitle = subTitle
        self.image = image
        self.type = type
        self.completionHandler = completionHandler
        self.touchHandler = touchHandler
        self.isDismissable = isDismissable
        
    }
    
    fileprivate func setupNotification() {
        
        self.createBackground()
        if self.isDismissable {
            constants.nvPaddingRight += constants.nvdWidth
            constants.nvPaddingRight += constants.nvdPaddingLeft
        }
        
        if self.image != nil {
            self.createImageView()
        }
        
        self.createTitleLabel()
        constants.nvPaddingTop += constants.nvtPaddingTop
        self.createSubtitleLabel()
        
        if self.isDismissable {
            constants.nvPaddingRight -= constants.nvdPaddingLeft
        }
        
        if self.touchHandler != nil {
            self.createTouchEvent()
        }
        self.addNotificationView()
    }
    
    fileprivate func createTouchEvent() {

        let tap = UITapGestureRecognizer(target: self, action: #selector(GRNotificationView.handleTap(_:)))
        self.addGestureRecognizer(tap)
        
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GRNotificationView.respondToSwipeGesture(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        swipeUp.cancelsTouchesInView = true
        self.addGestureRecognizer(swipeUp)
        
    }
    
    

    
    func handleTap(_ recognizer: UITapGestureRecognizer) {
        self.touchHandler!()
    }
    
    func respondToSwipeGesture(_ swipeGesture: UISwipeGestureRecognizer) {
        
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                close()
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                close()
            default:
                break
            }
        
    }
    

    
    
    
    fileprivate func addNotificationView() {
        GRNotificationView.animate(withDuration: constants.nvaTimer, animations: { () -> Void in
            self.frame.origin.y = self.constants.nvMarginTop
            
        }, completion: { (flag) -> Void in
            if flag {
                if self.completionHandler != nil {
                    self.completionHandler!()
                }
            }
            
        }) 
        
        self.addTimer(constants.nvaShownTimer)
        UIApplication.shared.delegate?.window??.windowLevel = UIWindowLevelStatusBar+1
        
        
    }
    
    fileprivate func createBackground() {
        if type == NotificationType.plain {

            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 160 / masterRatio)
            self.backgroundColor = UIColor(hexString: "#000000").withAlphaComponent(0.8)
            
            
            let compositeView = UIView()
            self.addSubview(compositeView)
            compositeView.snp.makeConstraints({ (make) in
                make.width.height.equalTo(45 / masterRatio)
                make.top.equalTo(20 / masterRatio)
                make.left.equalTo(40 / masterRatio)
            })
            compositeView.backgroundColor = UIColor.grocerestColor()
            compositeView.layer.borderWidth = 1.0
            compositeView.layer.masksToBounds = false
            compositeView.layer.borderColor = UIColor.grocerestColor().cgColor
            compositeView.layer.cornerRadius = 8 / masterRatio
            compositeView.clipsToBounds = true
            
            let grocerestLogo = UIImageView(image: UIImage(named: "launchLogo"))
            compositeView.addSubview(grocerestLogo)
            grocerestLogo.snp.makeConstraints({ (make) in
                make.width.height.equalTo(30 / masterRatio)
                make.center.equalTo(compositeView.snp.center)
            })
            grocerestLogo.contentMode = .scaleAspectFit
            
            
            self.addSubview(grocerestBrand)
            grocerestBrand.snp.makeConstraints { (make) in
                make.centerY.equalTo(grocerestLogo.snp.centerY).offset(-8 / masterRatio)
                make.left.equalTo(grocerestLogo.snp.right).offset(25 / masterRatio)
            }
            grocerestBrand.font = UIFont.avenirHeavy(26)
            grocerestBrand.textAlignment = .left
            grocerestBrand.textColor = UIColor.white
            grocerestBrand.text = "Grocerest"
            
            
            let dateLabel = UILabel()
            self.addSubview(dateLabel)
            dateLabel.snp.makeConstraints { (make) in
                make.left.equalTo(grocerestBrand.snp.right).offset(12 / masterRatio)
                make.bottom.equalTo(grocerestBrand.snp.bottom)
            }
            dateLabel.font = UIFont.avenirHeavy(24)
            dateLabel.textAlignment = .left
            dateLabel.textColor = UIColor.white.withAlphaComponent(0.6)
            dateLabel.text = "ora"
            
            let decoView = UIView()
            self.addSubview(decoView)
            decoView.snp.makeConstraints { (make) in
                make.width.equalTo(80 / masterRatio)
                make.bottom.equalTo(self.snp.bottom).offset(-6 / masterRatio)
                make.height.equalTo(10 / masterRatio)
                make.centerX.equalTo(self.snp.centerX)
            }
            decoView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            decoView.layer.cornerRadius = 5 / masterRatio
            
        }
    }
    
    fileprivate func createTitleLabel() {
        let label = UILabel()
        label.frame = CGRect(x: constants.nvPaddingLeft, y: constants.nvPaddingTop, width: self.frame.width - constants.nvPaddingLeft - constants.nvPaddingRight, height: constants.nvtHeight)
        label.textAlignment = NSTextAlignment.left
        label.text = self.title
        label.font = UIFont.avenirBook(24)
        label.textColor = UIColor.darkText

        self.addSubview(label)
    }
    
    fileprivate func createSubtitleLabel() {
        
        let subLabel = UILabel()
        self.addSubview(subLabel)
        subLabel.snp.makeConstraints { (make) in
            make.left.equalTo(grocerestBrand.snp.left)
            make.top.equalTo(grocerestBrand.snp.bottom)
            make.width.equalTo(600 / masterRatio)
        }

        
        subLabel.sizeToFit()
        subLabel.font = UIFont.avenirBook(24)
        subLabel.textColor = UIColor.white
        subLabel.textAlignment = .left
        subLabel.numberOfLines = 2
        subLabel.text = self.subTitle
        
        
    }
    
    fileprivate func createImageView() {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: constants.nvPaddingLeft, y: constants.nvPaddingTop, width: constants.nviHeight, height: constants.nviWidth))
        constants.nvPaddingLeft += constants.nviPaddingLeft
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.backgroundColor  = UIColor.yellow
        self.addSubview(imageView)
    }
    

    
    fileprivate func addTimer(_ time: Double) {
        self.notificationTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(GRNotificationView.close), userInfo: nil, repeats: false)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    func close() {
        self.notificationTimer.invalidate()
        
        GRNotificationView.animate(withDuration: constants.nvaTimer, animations: { () -> Void in
            self.frame.origin.y = self.constants.nvStartYPoint
        }, completion: { (Bool) -> Void in
            if GRNotification.notificationCount == 1 {
                UIApplication.shared.delegate?.window??.windowLevel = UIWindowLevelNormal
                GRNotification.removeOldNotifications()
            }
        }) 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

