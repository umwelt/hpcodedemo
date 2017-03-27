//
//  GREditInsertedProductView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 21/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GREditInsertedProductView: UIView {
    
    var backgroundCover = UIView()
    
    var viewsByName: [String: UIView]!
    var delegate: GREditInsertedProductController?
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var productImageView : UIImageView?
    var productName : UILabel?
    var brandLabel : UILabel?
    var productOwner: UILabel?
    var quantityTextField : UITextField?
    
    var statusIcon = UIImageView()
    
    // - MARK: Life Cycle
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }
    
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let scalingView = self.viewsByName["__scaling__"] {
            var xScale = self.bounds.size.width / scalingView.bounds.size.width
            var yScale = self.bounds.size.height / scalingView.bounds.size.height
            switch contentMode {
            case .scaleToFill:
                break
            case .scaleAspectFill:
                let scale = max(xScale, yScale)
                xScale = scale
                yScale = scale
            default:
                let scale = min(xScale, yScale)
                xScale = scale
                yScale = scale
            }
            scalingView.transform = CGAffineTransform(scaleX: xScale, y: yScale)
            scalingView.center = CGPoint(x:self.bounds.midX, y:self.bounds.midY)
        }
    }
    
    func setupHierarchy() {
        
        var viewsByName: [String: UIView] = [:]
        let __scaling__ = UIView()
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        __scaling__.addSubview(backgroundCover)
        backgroundCover.snp.makeConstraints { (make) in
            make.edges.equalTo(__scaling__)
        }
        backgroundCover.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.backgroundCover.alpha = 0
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.backgroundCover.addSubview(blurEffectView)

        
        
        let closeButton = UIButton()
        __scaling__.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100 / masterRatio)
            make.top.equalTo(38 / masterRatio)
            make.right.equalTo(-58 / masterRatio)
        }
        closeButton.contentMode = .center
        closeButton.setImage(UIImage(named: "whiteCloseButton"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(GREditInsertedProductView.actionCloseButtonWasPressed(_:)), for: .touchUpInside)
        
        
        
        let backgroundView = UIView()
        addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.cornerRadius = 5
        backgroundView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(687 / masterRatio)
            make.height.equalTo(620 / masterRatio)
            make.centerX.equalTo(__scaling__.snp.centerX)
            make.top.equalTo(-450)
        }

        
        
        
        productImageView = UIImageView()
        backgroundView.addSubview(productImageView!)
        productImageView!.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(160 / masterRatio)
            make.top.equalTo(backgroundView.snp.top).offset(40 / masterRatio)
            make.centerX.equalTo(backgroundView.snp.centerX)
        }
        productImageView?.contentMode = .scaleAspectFit
        //productImageView?.image = UIImage(named: "logoRed")
        
        productName = UILabel()
        backgroundView.addSubview(productName!)
        productName!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(600 / masterRatio)
            make.top.equalTo((productImageView?.snp.bottom)!).offset(24 / masterRatio)
            make.centerX.equalTo(backgroundView.snp.centerX)
            
        }
        productName?.textColor = UIColor.grocerestDarkBoldGray()
        productName?.font = Constants.BrandFonts.ubuntuMedium16
        productName?.numberOfLines = 2
        productName?.textAlignment = .center
        
        
        
        brandLabel = UILabel()
        backgroundView.addSubview(brandLabel!)
        brandLabel?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo((productName?.snp.width)!)
            make.height.equalTo(30 / masterRatio)
            make.top.equalTo((productName?.snp.bottom)!).offset(6 / masterRatio)
            make.centerX.equalTo(__scaling__.snp.centerX)
        })
        brandLabel?.font = Constants.BrandFonts.avenirBook11
        brandLabel?.textColor = UIColor.grocerestLightGrayColor()
        brandLabel?.textAlignment = .center
        

        statusIcon = UIImageView()
        backgroundView.addSubview(statusIcon)
        statusIcon.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(30 / masterRatio)
            make.top.equalTo((brandLabel?.snp.bottom)!).offset(8 / masterRatio)
            make.centerX.equalTo(backgroundView.snp.centerX)
        }
        statusIcon.contentMode = .scaleAspectFit
        
        productOwner = UILabel()
        backgroundView.addSubview(productOwner!)
        productOwner?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(350 / masterRatio)
            make.height.equalTo(30 / masterRatio)
            make.centerX.equalTo(backgroundView.snp.centerX)
            make.top.equalTo(statusIcon.snp.bottom).offset(16 / masterRatio)
        })
        productOwner?.font = Constants.BrandFonts.avenirBook11
        productOwner?.textColor = UIColor.grocerestLightGrayColor()
        productOwner?.textAlignment = .center
        
        let separator = UIView()
        backgroundView.addSubview(separator)
        separator.backgroundColor = UIColor.lightGray
        separator.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(580 / masterRatio)
            make.height.equalTo(0.5)
            make.top.equalTo(productOwner!.snp.bottom).offset(40 / masterRatio)
            make.centerX.equalTo(backgroundView.snp.centerX)
        }
        
        
        quantityTextField = UITextField()
        backgroundView.addSubview(quantityTextField!)
        quantityTextField!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(500 / masterRatio)
            make.height.equalTo(70 / masterRatio)
            make.centerX.equalTo(backgroundView.snp.centerX)
            make.top.equalTo(separator.snp.bottom).offset(27 / masterRatio)
        }
        quantityTextField?.placeholder = "Quantità da comprare"
        quantityTextField?.keyboardType = .default
        quantityTextField?.returnKeyType = .go
        quantityTextField?.textAlignment = .center
        quantityTextField?.delegate = delegate
        
        
        viewsByName["backgroundView"] = backgroundView
        
        self.viewsByName = viewsByName
    }
    
    func actionCloseButtonWasPressed(_ sender: UIButton){
        delegate!.closeButtonWasPressed(sender)
        
    }    
    
}


extension GREditInsertedProductView {
    
    func formatViewWith(_ product:JSON) {
        
        if product["quantity"].string != "0"{
            quantityTextField?.text = product["quantity"].string
        }
        
        if let creator = product["creator"]["username"].string {
            productOwner?.text = "Aggiunto da \(creator)"
        }
        
        if let prodName = product["name"].string {
            productName!.text = prodName
        }
        
        brandLabel?.text = productJONSToBrand(data: product)        
        
        if let productId = product["product"].string {
            
            if getFavouritedProductsFromLocal().contains(productId) {
                statusIcon.image = UIImage(named: "icon_status_xsmall_preferiti")
            }
            
            if getHatedProductsFromLocal().contains(productId) {
                statusIcon.image = UIImage(named: "icon_status_xsmall_evitare")
            }
            
            if getTryableProductsFromLocal().contains(productId) {
                statusIcon.image = UIImage(named: "icon_status_xsmall_provare")
            }
        }
        
        productName?.setNeedsDisplay()
    }
}

extension GREditInsertedProductView {
    func willShowComponentView() {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.backgroundCover.alpha = 0.95
        }) { (complete: Bool) in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: UIViewAnimationOptions(), animations: {
                self.viewsByName["backgroundView"]!.transform = CGAffineTransform(translationX: 0, y: 1050 / masterRatio)
                }, completion: {
                    (value: Bool) in
                    print("its over?: \(value)")
            })
        }
    }
    
    func willHideComponentView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.viewsByName["backgroundView"]!.transform = CGAffineTransform(translationX: 0, y: -450 / masterRatio)
        }) { (value: Bool) in
             print("its over?: \(value)")
            
        }
    }
}
