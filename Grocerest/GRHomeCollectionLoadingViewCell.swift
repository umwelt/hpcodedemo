//
//  GRHomeCollectionLoadingViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 06/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SnapKit

@IBDesignable
class GRHomeCollectionLoadingViewCell: UICollectionViewCell {
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupHierarchy() {
        backgroundColor = UIColor.F1F1F1Color()
        contentView.snp.makeConstraints { make in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(784 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        let topReviewLabel = UILabel()
        contentView.addSubview(topReviewLabel)
        topReviewLabel.text = Constants.AppLabels.topReviewLabelText
        topReviewLabel.font = Constants.BrandFonts.avenirBook11
        topReviewLabel.textColor = UIColor.grocerestLightGrayColor()
        topReviewLabel.textAlignment = .left
        topReviewLabel.snp.makeConstraints { make in
            make.top.equalTo(41 / masterRatio)
            make.left.equalTo(32 / masterRatio)
            make.height.equalTo(30 / masterRatio)
        }
        
        let mainReviewContainer = UIView()
        mainReviewContainer.backgroundColor = UIColor.white
        mainReviewContainer.layer.cornerRadius = 5.00
        contentView.addSubview(mainReviewContainer)
        mainReviewContainer.snp.makeConstraints { make in
            make.top.equalTo(topReviewLabel.snp.bottom).offset(25 / masterRatio)
            make.left.equalTo(topReviewLabel.snp.left)
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(562 / masterRatio)
        }
        
        let categoryImageView = UIView()
        categoryImageView.backgroundColor = UIColor.F1F1F1Color()
        mainReviewContainer.addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100 / masterRatio)
            make.left.top.equalTo(40 / masterRatio)
        }
        categoryImageView.layer.masksToBounds = false
        categoryImageView.layer.cornerRadius = 50 / masterRatio
        categoryImageView.clipsToBounds = true
        
        let productMainLabel = UIView()
        productMainLabel.backgroundColor = UIColor.F1F1F1Color()
        mainReviewContainer.addSubview(productMainLabel)
        productMainLabel.snp.makeConstraints { make in
            make.left.equalTo(categoryImageView.snp.right).offset(30.95 / masterRatio)
            make.top.equalTo(47 / masterRatio)
            make.width.equalTo(260 / masterRatio)
            make.height.equalTo(30 / masterRatio)
        }

        let productsSecondaryLabel = UIView()
        productsSecondaryLabel.backgroundColor = UIColor.F1F1F1Color()
        mainReviewContainer.addSubview(productsSecondaryLabel)
        productsSecondaryLabel.snp.makeConstraints { make in
            make.left.equalTo(categoryImageView.snp.right).offset(30.95 / masterRatio)
            make.top.equalTo(productMainLabel.snp.bottom).offset(13 / masterRatio)
            make.width.equalTo(160 / masterRatio)
            make.height.equalTo(20 / masterRatio)
        }

        let reviewProductImageView = UIView()
        reviewProductImageView.backgroundColor = UIColor.F1F1F1Color()
        mainReviewContainer.addSubview(reviewProductImageView)
        reviewProductImageView.snp.makeConstraints { make in
            make.centerX.equalTo(mainReviewContainer.snp.centerX)
            make.top.equalTo(productsSecondaryLabel.snp.bottom).offset(43 / masterRatio)
            make.width.equalTo(290 / masterRatio)
            make.height.equalTo(360 / masterRatio)
        }

        let reviewMainComponentView = UIView()
        reviewMainComponentView.backgroundColor = UIColor.white
        contentView.addSubview(reviewMainComponentView)
        reviewMainComponentView.layer.cornerRadius = 5.0
        reviewMainComponentView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(mainReviewContainer.snp.width)
            make.left.equalTo(mainReviewContainer.snp.left)
            make.top.equalTo(mainReviewContainer.snp.bottom).offset(4 / masterRatio)
            make.height.equalTo(240 / masterRatio)
            
        }
        
        let reviewLabel = UIView()
        reviewLabel.backgroundColor = UIColor.F1F1F1Color()
        reviewMainComponentView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewMainComponentView.snp.top).offset(27 / masterRatio)
            make.width.equalTo(330 / masterRatio)
            make.height.equalTo(30 / masterRatio)
            make.centerX.equalTo(reviewMainComponentView.snp.centerX)
        }
        
        for i in 0...4 {
            let reviewButtonOuterCircle = UIView()
            reviewButtonOuterCircle.backgroundColor = UIColor.F1F1F1Color()
            reviewMainComponentView.addSubview(reviewButtonOuterCircle)
            reviewButtonOuterCircle.snp.makeConstraints { make in
                make.width.height.equalTo(86 / masterRatio)
                make.top.equalTo(reviewLabel.snp.bottom).offset(33.5 / masterRatio)
                make.left.equalTo(reviewMainComponentView.snp.left).offset(CGFloat(66 + (86 + 30) * i) / masterRatio)
            }
            reviewButtonOuterCircle.layer.masksToBounds = false
            reviewButtonOuterCircle.layer.cornerRadius = 43 / masterRatio
            reviewButtonOuterCircle.clipsToBounds = true
            
            let reviewButtonInnerCircle = UIView()
            reviewButtonInnerCircle.backgroundColor = UIColor.white
            reviewButtonOuterCircle.addSubview(reviewButtonInnerCircle)
            reviewButtonInnerCircle.snp.makeConstraints { make in
                make.width.height.equalTo(32 / masterRatio)
                make.centerX.centerY.equalTo(reviewButtonOuterCircle)
            }
            reviewButtonInnerCircle.layer.masksToBounds = false
            reviewButtonInnerCircle.layer.cornerRadius = 16 / masterRatio
            reviewButtonInnerCircle.clipsToBounds = true
        }
    }
}
