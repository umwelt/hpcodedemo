//
//  GRReviewBoxComented.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit



@IBDesignable
class GRReviewBoxComented: UIView {
    
    var viewsByName: [String: UIView]!
    var commentTextField : UITextView?
    
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
        
        
        let commentedIcon = UIImageView()
        __scaling__.addSubview(commentedIcon)
        commentedIcon.contentMode = .scaleAspectFit
        commentedIcon.image = UIImage(named: "commented_icon")
        commentedIcon.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.commentedIconSize)
            make.left.equalTo(18.5)
            make.top.equalTo(33)
        }
        
        commentTextField = UITextView()
        __scaling__.addSubview(commentTextField!)
        commentTextField!.textColor = UIColor.commentProductText()
        commentTextField!.font = Constants.BrandFonts.avenirBook11
        commentTextField!.isEditable = false
        commentTextField!.isUserInteractionEnabled = false
        commentTextField!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.reviewCommentBox)
            make.left.equalTo(commentedIcon.snp.right).offset(14)
            make.top.equalTo(28)
        }
        
        
        
        
        self.viewsByName = viewsByName
        
    }
    
}

