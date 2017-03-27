//
//  GRReportView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 21/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit



class GRReportView: UIView, UITextFieldDelegate {
    
    var viewsByName: [String: UIView]!
    var commentTextView : UITextView?
    var productMainLabel = UILabel()
    
    var reviewCategoryImageView : UIImageView?
    var backView = UIView()
    var onCommentProductView = UIView()
    
    
    var confirmButton = UIButton(type: .custom)
    var reviewLabel =  UILabel()
    
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
    
    var delegate : GRReportViewController?
    
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
        __scaling__.backgroundColor = UIColor.white
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        let closeButton = UIButton(type: .custom)
        __scaling__.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(125 / masterRatio)
            make.left.equalTo(8 / masterRatio)
            make.top.equalTo(41 / masterRatio)
        }
        closeButton.contentMode = .center
        closeButton.setImage(UIImage(named: "close_modal"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(GRCommentModalView.closeButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["closeButton"] = closeButton
        
        
        __scaling__.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.right.equalTo(-8 / masterRatio)
            make.top.equalTo(closeButton.snp.top)
            make.height.equalTo(closeButton.snp.height)
            make.width.equalTo(closeButton.snp.width)
        }
        confirmButton.contentMode = .center
        confirmButton.setImage(UIImage(named: "report"), for: UIControlState())
        confirmButton.addTarget(self, action: #selector(GRCommentModalView.confirmButtonPressed(_:)), for: .touchUpInside)
        
        
        let viewTitle = UILabel()
        __scaling__.addSubview(viewTitle)
        viewTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(closeButton.snp.centerY)
            make.centerX.equalTo(__scaling__.snp.centerX)
        }
        viewTitle.font = UIFont.ubuntuLight(36)
        viewTitle.textAlignment = .center
        viewTitle.textColor = UIColor.grocerestColor()
        viewTitle.text = "Segnala"
        
        let barView = UIView()
        __scaling__.addSubview(barView)
        barView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(63 / masterRatio)
            make.centerX.equalTo(__scaling__.snp.centerX)
            make.top.equalTo(closeButton.snp.bottom)
        }
        barView.backgroundColor = UIColor.F1F1F1Color()
        
        let barViewLabel = UILabel()
        __scaling__.addSubview(barViewLabel)
        barViewLabel.text = "Scrivi una segnalazione"
        barViewLabel.textColor = UIColor(hexString: "#979797")
        barViewLabel.font = UIFont.avenirBook(22)
        barViewLabel.textAlignment = .left
        barViewLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(34 / masterRatio)
            make.centerY.equalTo(barView.snp.centerY)
        }
        

        
        
        //let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().size
        
        
        commentTextView = UITextView()
        __scaling__.addSubview(commentTextView!)
        commentTextView!.isEditable = true
        commentTextView!.isUserInteractionEnabled = true
        commentTextView!.autocorrectionType = .yes
        commentTextView!.returnKeyType = .go
        commentTextView?.font = UIFont.avenirBook(30)
        commentTextView?.textColor = UIColor(hexString: "#686868")
        // Constraints below
        
        onCommentProductView = UIView()
        __scaling__.addSubview(onCommentProductView)
        onCommentProductView.backgroundColor = UIColor.F1F1F1Color()
        onCommentProductView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(75 / masterRatio)
            make.top.equalTo(378 / masterRatio)
            make.left.equalTo(0)
        }
        
        
        viewsByName["onCommentProductView"] = onCommentProductView
        
        // Comment TextView constraints
        commentTextView!.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(__scaling__.snp.centerX)
            make.width.equalTo(670 / masterRatio)
            make.top.equalTo(barViewLabel.snp.bottom).offset(32.45 / masterRatio)
            make.bottom.equalTo(onCommentProductView.snp.top).offset(-16 / masterRatio)
        }
        
        
        backView = UIView()
        __scaling__.addSubview(backView)
        backView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100 / masterRatio)
            make.left.equalTo(onCommentProductView.snp.left).offset(25 / masterRatio)
            make.centerY.equalTo(onCommentProductView.snp.centerY)
        }
        backView.layer.borderWidth = 1.0
        backView.layer.masksToBounds = false
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.cornerRadius = 50 / masterRatio
        backView.clipsToBounds = true
        backView.layer.borderWidth = 1
        
        
        reviewCategoryImageView = UIImageView()
        backView.addSubview(reviewCategoryImageView!)
        
        reviewCategoryImageView!.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(76 / masterRatio)
            make.center.equalTo(backView.snp.center)
            
        }
        
        reviewCategoryImageView!.contentMode = .scaleAspectFit
        
        viewsByName["reviewCategoryImageView"] = reviewCategoryImageView
        
        onCommentProductView.addSubview(productMainLabel)
        
        productMainLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(reviewCategoryImageView!.snp.right).offset(31 / masterRatio)
            make.top.equalTo(onCommentProductView.snp.top).offset(36 / masterRatio)
            make.width.equalTo(551 / masterRatio)
        }
        
        productMainLabel.font = Constants.BrandFonts.ubuntuBold14
        productMainLabel.textColor = UIColor.grocerestDarkBoldGray()
        productMainLabel.textAlignment = .left
        productMainLabel.numberOfLines = 1
        productMainLabel.lineBreakMode = .byTruncatingTail
        
        viewsByName["productMainLabel"] = productMainLabel
        
        
        onCommentProductView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(productMainLabel.snp.width)
            make.top.equalTo(productMainLabel.snp.bottom).offset(6 / masterRatio)
            make.left.equalTo(productMainLabel.snp.left)
        })
        reviewLabel.font = Constants.BrandFonts.avenirBook11
        reviewLabel.textColor = UIColor.grocerestLightGrayColor()
        reviewLabel.textAlignment = .left
        
        self.viewsByName = viewsByName
    }
    
    
    func closeButtonWasPressed(_ sender: UIButton) {
        delegate?.actionCloseButtonWasPressed(sender)
    }
    
    func confirmButtonPressed(_ sender:UIButton) {
        delegate?.reportReview()
    }

    
    func formatReviewLabel(_ userName:String, data:String) {
        reviewLabel.text = "Recensione di \(userName) del \(data)"
    }
    
    func formatProductLabel(_ productName:String){
        productMainLabel.text = productName
    }
    
    
}
