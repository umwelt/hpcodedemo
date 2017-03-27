//
//  GRHomeCollectionViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 29/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit
import SnapKit
import Haneke


class GRHomeCollectionViewCell: UICollectionViewCell {
    
    let productMainLabel = UILabel()
    let reviewCategoryImageView = UIImageView()
    let productsSecondaryLabel = UILabel()
    let reviewProductImageView = UIImageView()
    let reviewScrollView = GRReviewBoxView()
    let productButton = UIButton(type: .custom)
    
    var imagesURL : String?
    
    var separator = UIView()
    
    var numberOfReviews = 0
    
    private let reviewsIcon = UIImageView(image: UIImage(named: "edit-small"))
    private let reviewsCounter = UILabel()
    private let scoreCounter = UILabel()
    private let noScoreLabel = UILabel()
    private var scoreIndicators = UIStackView()
    private let doublePointsImageView = UIImageView()
    let productStatusImageView = UIImageView()
    
    var averageReviewScore: Double = 0 {
        didSet {
            if averageReviewScore < 0 || averageReviewScore > 5 {
                // Score must be between 0 and 5, extremes included
                averageReviewScore = 0
                return
            }
            for indicator in scoreIndicators.arrangedSubviews {
                let circle = indicator as! UIImageView
                circle.image = UIImage(named: "score-empty-small")
            }
            if averageReviewScore == 0 {
                scoreCounter.isHidden = true
                noScoreLabel.isHidden = false
            } else {
                noScoreLabel.isHidden = true
                scoreCounter.text = String(numberOfReviews)
                scoreCounter.isHidden = false
                
                var score = averageReviewScore
                var i = 0
                repeat {
                    let circle = scoreIndicators.arrangedSubviews[i] as! UIImageView
                    circle.image = UIImage(named: "score-full-small")
                    score -= 1
                    i += 1
                } while score >= 1
                if score >= 0.25 && score <= 0.75 {
                    let circle = scoreIndicators.arrangedSubviews[i] as! UIImageView
                    circle.image = UIImage(named: "score-half-small")
                } else if score > 0.75 && score < 1 {
                    let circle = scoreIndicators.arrangedSubviews[i] as! UIImageView
                    circle.image = UIImage(named: "score-full-small")
                }
            }
        }
    }
    
    var doublePointsImage : UIImage {
        get {
            return doublePointsImageView.image!
        }
        set (newImage) {
            doublePointsImageView.image = newImage
        }
    }
    
    var statusImage : UIImage {
        get {
            return productStatusImageView.image!
        }
        set (newImage) {
            productStatusImageView.image = newImage
        }
    }
    
    var toTryButton: UIButton = GRShineButton()
    
   // Callback
    var onToTryButtonTapped: (() -> Void)?
    
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
            make.top.equalTo(0)
            make.left.equalTo(32 / masterRatio)
            make.height.equalTo(30 / masterRatio)
        }
        
        let mainReviewContainer = UIView()
        mainReviewContainer.backgroundColor = UIColor.white
        mainReviewContainer.layer.cornerRadius = 5.00
        contentView.addSubview(mainReviewContainer)
        mainReviewContainer.snp.makeConstraints { make in
            make.top.equalTo(topReviewLabel.snp.bottom).offset(12.5)
            make.left.equalTo(topReviewLabel.snp.left)
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(570 / masterRatio)
        }
        
        let backView = UIView()
        backView.layer.borderWidth = 1.0
        backView.layer.masksToBounds = false
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.cornerRadius = 50 / masterRatio
        backView.clipsToBounds = true
        mainReviewContainer.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.width.height.equalTo(100 / masterRatio)
            make.left.equalTo(40 / masterRatio)
            make.top.equalTo(30 / masterRatio)
        }
        
        reviewCategoryImageView.contentMode = .center
        mainReviewContainer.addSubview(reviewCategoryImageView)
        reviewCategoryImageView.snp.makeConstraints { make in
            make.width.height.equalTo(86 / masterRatio)
            make.center.equalTo(backView.snp.center)
        }
        
        productMainLabel.numberOfLines = 2
        productMainLabel.font = Constants.BrandFonts.ubuntuBold14
        productMainLabel.textColor = UIColor.grocerestDarkBoldGray()
        productMainLabel.textAlignment = .left
        productMainLabel.lineBreakMode = .byTruncatingTail
        mainReviewContainer.addSubview(productMainLabel)
        productMainLabel.snp.makeConstraints { make in
            make.left.equalTo(reviewCategoryImageView.snp.right).offset(14.5)
            make.top.equalTo(37 / masterRatio)
            make.width.equalTo(220)
        }
        
        productsSecondaryLabel.font = Constants.BrandFonts.avenirBook11
        productsSecondaryLabel.textColor = UIColor.grocerestLightGrayColor()
        productsSecondaryLabel.textAlignment = .left
        productMainLabel.lineBreakMode = .byTruncatingTail
        mainReviewContainer.addSubview(productsSecondaryLabel)
        productsSecondaryLabel.snp.makeConstraints { make in
            make.left.equalTo(reviewCategoryImageView.snp.right).offset(14.5)
            make.top.equalTo(productMainLabel.snp.bottom).offset(4)
            make.width.equalTo(200)
        }
        
        mainReviewContainer.addSubview(reviewProductImageView)
        reviewProductImageView.snp.makeConstraints { make in
            make.centerX.equalTo(mainReviewContainer.snp.centerX)
            make.top.equalTo(productsSecondaryLabel.snp.bottom).offset(16)
            make.width.equalTo(316 / masterRatio)
            make.height.equalTo(316 / masterRatio)
        }
        
        doublePointsImageView.contentMode = .scaleAspectFit
        mainReviewContainer.addSubview(doublePointsImageView)
        doublePointsImageView.snp.makeConstraints { make in
            make.width.height.equalTo(92 / masterRatio)
            make.left.equalTo(mainReviewContainer.snp.left).offset(28 / masterRatio)
            make.bottom.equalTo(mainReviewContainer.snp.bottom).offset(-20 / masterRatio)
        }
        
        scoreIndicators.axis  = UILayoutConstraintAxis.horizontal
        scoreIndicators.distribution  = UIStackViewDistribution.equalSpacing
        scoreIndicators.alignment = UIStackViewAlignment.center
        for _ in 1...5 {
            let img = UIImageView(image: UIImage(named: "score-empty-small"))
            scoreIndicators.addArrangedSubview(img)
        }
        
        mainReviewContainer.addSubview(scoreIndicators)
        scoreIndicators.snp.makeConstraints { make in
            make.width.equalTo(140 / masterRatio)
            make.left.equalTo(mainReviewContainer.snp.left).offset(28 / masterRatio)
            make.top.equalTo(mainReviewContainer.snp.top).offset(509 / masterRatio)
        }
        
        separator.backgroundColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        mainReviewContainer.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(26 / masterRatio)
            make.width.equalTo(2 / masterRatio)
            make.left.equalTo(scoreIndicators.snp.right).offset(14 / masterRatio)
            make.bottom.equalTo(scoreIndicators.snp.bottom)
        }
        
        reviewsIcon.contentMode = .scaleAspectFit
        mainReviewContainer.addSubview(reviewsIcon)
        reviewsIcon.snp.makeConstraints { make in
            make.width.height.equalTo(26 / masterRatio)
            make.left.equalTo(separator.snp.right).offset(19.5 / masterRatio)
            make.bottom.equalTo(separator.snp.bottom)
        }
        
        scoreCounter.font = UIFont.avenirMedium(28.0)
        scoreCounter.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        scoreCounter.isHidden = true
        mainReviewContainer.addSubview(scoreCounter)
        scoreCounter.snp.makeConstraints { make in
            make.left.equalTo(reviewsIcon.snp.right).offset(8 / masterRatio)
            make.bottom.equalTo(separator.snp.bottom).offset(8 / masterRatio)
        }
        
        noScoreLabel.font = UIFont.avenirMedium(28.0)
        noScoreLabel.textColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        noScoreLabel.text = "n.d."
        mainReviewContainer.addSubview(noScoreLabel)
        noScoreLabel.snp.makeConstraints { make in
            make.left.equalTo(reviewsIcon.snp.right).offset(8 / masterRatio)
            make.bottom.equalTo(reviewsIcon.snp.bottom)
        }
        
        reviewsCounter.font = UIFont.avenirMedium(28.0)
        reviewsCounter.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        mainReviewContainer.addSubview(reviewsCounter)
        reviewsCounter.snp.makeConstraints { make in
            make.left.equalTo(reviewsIcon.snp.right).offset(5 / masterRatio)
            make.bottom.equalTo(scoreIndicators.snp.bottom)
        }

        productStatusImageView.contentMode = .scaleAspectFit
        mainReviewContainer.addSubview(productStatusImageView)
        productStatusImageView.snp.makeConstraints { make in
            make.height.width.equalTo(64 / masterRatio)
            make.right.equalTo(mainReviewContainer.snp.right).offset(-20 / masterRatio)
            make.bottom.equalTo(mainReviewContainer.snp.bottom).offset(-20 / masterRatio)
        }
        
        toTryButton.setBackgroundImage(UIImage(named:"provare_detail_off"), for: UIControlState())
        toTryButton.setBackgroundImage(UIImage(named: "provare_detail_on"), for: .selected)
        toTryButton.addTarget(self, action: #selector(GRHomeCollectionViewCell._toTryButtonTapped(_:)), for: .touchUpInside)
        mainReviewContainer.addSubview(toTryButton)
        toTryButton.snp.makeConstraints { make in
            make.edges.equalTo(productStatusImageView)
        }
        
        mainReviewContainer.addSubview(productButton)
        productButton.snp.makeConstraints { make in
            make.left.right.top.equalTo(mainReviewContainer)
            make.bottom.equalTo(reviewProductImageView.snp.bottom)
        }
        
        let reviewMainComponentView = UIView()
        reviewMainComponentView.layer.cornerRadius = 5.0
        contentView.addSubview(reviewMainComponentView)
        reviewMainComponentView.snp.makeConstraints { make in
            make.width.equalTo(mainReviewContainer.snp.width)
            make.left.equalTo(mainReviewContainer.snp.left)
            make.top.equalTo(mainReviewContainer.snp.bottom).offset(2)
            make.height.equalTo(240 / masterRatio)
        }
        
        contentView.addSubview(reviewScrollView)
        reviewScrollView.snp.makeConstraints { make in
            make.edges.equalTo(reviewMainComponentView)
        }
    }

    func swicthFirstReviewWidget (_ score: Bool) {
        if score {
            doublePointsImageView.isHidden = true
            scoreIndicators.isHidden = false
            separator.isHidden = false
            reviewsIcon.isHidden = false
        } else  {
            doublePointsImageView.isHidden = false
            scoreIndicators.isHidden = true
            separator.isHidden = true
            reviewsIcon.isHidden = true
            scoreCounter.isHidden = true
            noScoreLabel.isHidden = true
        }
    }
    
    func _toTryButtonTapped(_: UIButton) {
        onToTryButtonTapped?()
    }
    
    func setImageForProduct(_ imageName: String, category: String) {
        if imageName != "" {
            reviewProductImageView.layoutIfNeeded()
            reviewProductImageView.contentMode = .scaleAspectFit
            reviewProductImageView.hnk_setImageFromURL(URL(string: String.fullPathForImage(imageName))!, placeholder: UIImage(named: "products_" + category), format: Haneke.Format(name: "original"), failure: nil, success: nil)
        } else {
            reviewProductImageView.image = UIImage(named: "products_" + category)
        }
    }

}
