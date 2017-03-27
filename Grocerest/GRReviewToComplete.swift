//
//  ReviewToComplete.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 10/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SnapKit

class GRReviewToComplete: UIView {
    
    fileprivate let productImageView = UIImageView()
    fileprivate let ratingIndicators = UIStackView()
    fileprivate let nameLabel = UILabel()
    fileprivate let brandLabel = UILabel()
    
    var productImage: UIImage? {
        didSet {
            productImageView.image = productImage
        }
    }
    
    func setImageFromURL(_ url: URL) {
        productImageView.layoutIfNeeded()
        productImageView.hnk_setImageFromURL(url.absoluteURL)
    }
    
    var productName: String = "" {
        didSet {
            nameLabel.text = productName
        }
    }
    
    var productBrand: String = "" {
        didSet {
            brandLabel.text = productBrand
        }
    }
    
    var rating: Int = 0 {
        didSet {
            if rating < 0 || rating > 5 {
                fatalError("Rating must be between 0 and 5! Given \(rating)")
            }
            for (i, view) in ratingIndicators.arrangedSubviews.enumerated() {
                let ratingIndicator = view as! UIImageView
                if i < rating {
                    ratingIndicator.image = UIImage(named: "score-full-small")
                } else {
                    ratingIndicator.image = UIImage(named: "score-empty-small")
                }
            }
        }
    }
    
    var onTap: (() -> Void)?
    
    // Used by running iOS app
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialization()
    }
    
    // Used by Inteface Builder
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialization()
    }
    
    fileprivate func initialization() {
        backgroundColor = UIColor.white
        clipsToBounds = true
        layer.cornerRadius = 10 / masterRatio
        translatesAutoresizingMaskIntoConstraints = false
        
        snp.makeConstraints { make in
            make.width.equalTo(284 / masterRatio)
            make.height.equalTo(320 / masterRatio)
        }
        
        productImageView.contentMode = .scaleAspectFit
        addSubview(productImageView)
        
        productImageView.snp.makeConstraints { make in
            make.left.top.equalTo(self).offset(20 / masterRatio)
            make.width.height.equalTo(128 / masterRatio)
        }
        
        
        for _ in 1...5 {
            let ratingIndicator = UIImageView(image: UIImage(named: "score-empty-small"))
            ratingIndicators.addArrangedSubview(ratingIndicator)
        }
        addSubview(ratingIndicators)
  
        ratingIndicators.snp.makeConstraints { make in
            make.left.equalTo(self).offset(18 / masterRatio)
            make.bottom.equalTo(self).offset(-26 / masterRatio)
        }
        
        brandLabel.font = UIFont.avenirBook(22)
        brandLabel.textColor = UIColor(hexString: "979797")
        addSubview(brandLabel)
        
        brandLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20 / masterRatio)
            make.right.equalTo(self).offset(-20 / masterRatio)
            make.bottom.equalTo(ratingIndicators.snp.top).offset(-20 / masterRatio)
        }
        
        nameLabel.font = UIFont.ubuntuBold(24)
        nameLabel.textColor = UIColor(hexString: "4A4A4A")
        nameLabel.numberOfLines = 2
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20 / masterRatio)
            make.right.equalTo(self).offset(-20 / masterRatio)
            make.bottom.equalTo(brandLabel.snp.top).offset(-6 / masterRatio)
        }
        
        let addReviewIcon = UIImageView(image: UIImage(named: "review-to-complete-add-review-icon"))
        addSubview(addReviewIcon)
        
        addReviewIcon.snp.makeConstraints { make in
            make.bottom.right.equalTo(self).offset(-15 / masterRatio)
        }
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(self.onTapped), for: .touchUpInside)
        addSubview(button)
        
        button.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func onTapped() {
        onTap?()
    }
    
    override func prepareForInterfaceBuilder() {
        productImage = UIImage(named: "product-small")
        productName = "Kellogg’s Cereali e frutta"
        productBrand = "Kellogg’s"
        rating = 4
        var taps = 0
        onTap = {
            taps += 1
            print("Tapped \(taps) \(taps == 1 ? "time": "times")")
        }
    }
    
}
