//
//  GRReviewBoxWriteComment.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//


import Foundation
import UIKit
import SnapKit
import SwiftyJSON

@IBDesignable
class GRReviewBoxWriteComment: UIView , UITextViewDelegate{
    
    var viewsByName: [String: UIView]!
    var writeCommentButton : UIButton?
    var reviewLabel = UILabel()
    var textReview = UITextView()
    var commentedIcon = UIImageView()
    var product : JSON?
    
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
    
    var delegate : GRReviewBoxWriteCommentProtocol?
    
    
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
        
        reviewLabel = UILabel()
        __scaling__.addSubview(reviewLabel)
        reviewLabel.text = Constants.AppLabels.completeReviewLabel
        reviewLabel.textColor = UIColor.grocerestDarkBoldGray()
        reviewLabel.font = Constants.BrandFonts.avenirHeavy12
        reviewLabel.textAlignment = .left
        reviewLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(15.5)
        }
        
        viewsByName["reviewLabel"] = reviewLabel
        
        writeCommentButton = UIButton(type: .custom)
        __scaling__.addSubview(writeCommentButton!)
        writeCommentButton!.setTitle(Constants.AppLabels.writeACommentButton, for: UIControlState())
        writeCommentButton!.titleLabel?.font = Constants.BrandFonts.avenirHeavy11
        writeCommentButton!.titleEdgeInsets = UIEdgeInsetsMake(7.5, 60, 7.5, 60)
        writeCommentButton!.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        writeCommentButton!.setTitleShadowColor(UIColor.grocerestDarkGrayText(), for: .highlighted)
        writeCommentButton!.layer.borderColor = UIColor.grocerestBlue().cgColor
        writeCommentButton!.layer.cornerRadius = 5.0
        writeCommentButton!.layer.borderWidth = 2.0
        writeCommentButton!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(260)
            make.height.equalTo(30)
            make.centerX.equalTo(__scaling__.snp.centerX)
            make.top.equalTo(reviewLabel.snp.bottom).offset(20.5)
        }
        
        viewsByName["writeCommentButton"] = writeCommentButton
        
        commentedIcon = UIImageView()
        __scaling__.addSubview(commentedIcon)
        commentedIcon.contentMode = .scaleAspectFit
        commentedIcon.image = UIImage(named: "commented_icon")
        commentedIcon.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.commentedIconSize)
            make.left.equalTo(18.5)
            make.top.equalTo(33)
        }
        commentedIcon.isHidden = true
        
        
        textReview = UITextView()
        __scaling__.addSubview(textReview)
        textReview.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(472 / masterRatio)
            make.height.equalTo(110 / masterRatio)
            make.top.equalTo(commentedIcon.snp.top).offset(-8)
            make.left.equalTo(commentedIcon.snp.right).offset(28 / masterRatio)
        }
        textReview.isHidden = true
        textReview.delegate = self
        
        self.viewsByName = viewsByName
        
    }

    func commentUpdate(_ review:String, currentReview: String, indexPathRow: Int) {
        
        if review.characters.count > 0 {
            reviewLabel.isHidden = true
            writeCommentButton?.isHidden = true
            commentedIcon.isHidden = false
            textReview.isHidden = false
            textReview.text = review
            textReview.tag = indexPathRow
        } else {
            reviewLabel.isHidden = false
            writeCommentButton?.isHidden = false
            commentedIcon.isHidden = true
            textReview.isHidden = true
            textReview.text = ""
            textReview.tag = 0
        }
        
    }
    
    
    func restoreCommentBox() {
        reviewLabel.isHidden = false
        writeCommentButton?.isHidden = false
        commentedIcon.isHidden = true
        textReview.isHidden = true
        textReview.text = ""
        textReview.tag = 0
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.reopenCommentWasPressed!(textView)
    }
    
}

