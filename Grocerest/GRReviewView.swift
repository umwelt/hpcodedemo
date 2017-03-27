//
//  GRReviewView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


@IBDesignable
class GRReviewView: UIView {
    
    var viewsByName: [String: UIView]!
    var productMainLabel : UILabel?
    var reviewCategoryImageView : UIImageView?
    var productsSecondaryLabel : UILabel?
    var reviewProductImageView : UIImageView?
    var reviewScrollView : GRReviewBoxView?
    
    // - MARK: Life Cycle
    
    convenience init(){
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHierarchy()
    }
    
    var delegate : GRReviewViewController?
    
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
        

        
        let topReviewLabel = UILabel()
        __scaling__.addSubview(topReviewLabel)
        topReviewLabel.text = Constants.AppLabels.topReviewLabelText
        topReviewLabel.font = Constants.BrandFonts.avenirBook11
        topReviewLabel.textColor = UIColor.grocerestLightGrayColor()
        topReviewLabel.textAlignment = .left
        topReviewLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(32 / masterRatio)
            make.left.equalTo(32 / masterRatio)
            make.height.equalTo(30 / masterRatio)
        }
        
        viewsByName["topReviewLabel"] = topReviewLabel
        
        let mainReviewContainer = UIView()
        mainReviewContainer.backgroundColor = UIColor.white
        mainReviewContainer.layer.cornerRadius = 5.00
        __scaling__.addSubview(mainReviewContainer)
        mainReviewContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(topReviewLabel.snp.bottom).offset(20 / masterRatio)
            make.left.equalTo(topReviewLabel.snp.left)
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(562 / masterRatio)
        }
        
        viewsByName["mainReviewContainer"] = mainReviewContainer
        
        
        
        let backView = UIView()
        mainReviewContainer.addSubview(backView)
        backView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100 / masterRatio)
            make.left.top.equalTo(40 / masterRatio)
        }
        backView.layer.borderWidth = 1.0
        backView.layer.masksToBounds = false
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.cornerRadius = 50 / masterRatio
        backView.clipsToBounds = true
        
        
        reviewCategoryImageView = UIImageView()
        mainReviewContainer.addSubview(reviewCategoryImageView!)
        
        reviewCategoryImageView!.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(86 / masterRatio)
            make.center.equalTo(backView.snp.center)
        }
        reviewCategoryImageView!.contentMode = .center
        
        
        viewsByName["reviewCategoryImageView"] = reviewCategoryImageView
        
        productMainLabel = UILabel()
        mainReviewContainer.addSubview(productMainLabel!)
        productMainLabel!.font = Constants.BrandFonts.ubuntuBold14
        productMainLabel!.textColor = UIColor.grocerestDarkBoldGray()
        productMainLabel!.textAlignment = .left
        productMainLabel!.lineBreakMode = .byTruncatingTail
        productMainLabel!.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(reviewCategoryImageView!.snp.right).offset(14.5)
            make.top.equalTo(47 / masterRatio)
            make.width.equalTo(220)
            
        }
        productMainLabel?.numberOfLines = 2
        
        viewsByName["productMainLabel"] = productMainLabel
        
        productsSecondaryLabel = UILabel()
        
        //TODO
        /// hardcoded
        //productsSecondaryLabel!.text = "Ajax - 500 ml"
        mainReviewContainer.addSubview(productsSecondaryLabel!)
        productsSecondaryLabel!.font = Constants.BrandFonts.avenirBook11
        productsSecondaryLabel!.textColor = UIColor.grocerestLightGrayColor()
        productsSecondaryLabel!.textAlignment = .left
        productMainLabel!.lineBreakMode = .byTruncatingTail
        productsSecondaryLabel!.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(reviewCategoryImageView!.snp.right).offset(14.5)
            make.top.equalTo(productMainLabel!.snp.bottom).offset(4)
            make.width.equalTo(200)
        }
        
        viewsByName["productsSecondaryLabel"] = productsSecondaryLabel
        

        
        reviewProductImageView = UIImageView()
        mainReviewContainer.addSubview(reviewProductImageView!)
        //reviewProductImageView!.image = UIImage(named: "sampleProduct")
        reviewProductImageView?.contentMode = .scaleAspectFit
        reviewProductImageView!.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(mainReviewContainer.snp.centerX)
            make.top.equalTo(productsSecondaryLabel!.snp.bottom).offset(16)
            make.width.equalTo(316 / masterRatio)
            make.height.equalTo(316 / masterRatio)
        }
        
        viewsByName["reviewProductImageView"] = reviewProductImageView
        
        let reviewMainComponentView = UIView()
        __scaling__.addSubview(reviewMainComponentView)
        //reviewMainComponentView.backgroundColor = UIColor.whiteColor()
        reviewMainComponentView.layer.cornerRadius = 5.0
        reviewMainComponentView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(mainReviewContainer.snp.width)
            make.left.equalTo(mainReviewContainer.snp.left)
            make.top.equalTo(mainReviewContainer.snp.bottom).offset(2)
            make.height.equalTo(220 / masterRatio)

        }
        
        viewsByName["reviewMainComponentView"] = reviewMainComponentView
        
        reviewScrollView = GRReviewBoxView()
        __scaling__.addSubview(reviewScrollView!)
        reviewScrollView!.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(reviewMainComponentView)
        }
        
        viewsByName["reviewScrollView"] = reviewScrollView
        
        self.viewsByName = viewsByName
        
        
    }
    

    
    
}
