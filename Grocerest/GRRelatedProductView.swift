//
//  GRRelatedProductView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 05/01/17.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation
import SnapKit

class GRRelatedProductView: UIView {
    
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
    
    var averageReviewsScore: Double = 0 {
        didSet {
            if averageReviewsScore < 0 || averageReviewsScore > 5 {
                fatalError("Rating must be between 0 and 5! Given \(averageReviewsScore)")
            }
            
            scoreLabel.text = String(format: "%.2f", averageReviewsScore)
            
            var remainingScore = averageReviewsScore
            
            for circle in scoreIndicators.arrangedSubviews as! [UIImageView] {
                if remainingScore >= 1 {
                    circle.image = UIImage(named: "score-full-small")
                    remainingScore -= 1
                } else if remainingScore >= 0.25 && remainingScore < 1 {
                    let imageName = remainingScore <= 0.75 ? "score-half-small" : "score-full-small"
                    circle.image = UIImage(named: imageName)
                    remainingScore = 0
                } else {
                    circle.image = UIImage(named: "score-empty-small")
                }
            }
        }
    }
    
    var numberOfReviews: Int = 0 {
        didSet {
            numberOfReviewsLabel.text = "\(numberOfReviews)"
        }
    }
    
    var onTap: (() -> Void)?
    
    private let productImageView = UIImageView()
    private let scoreIndicators = UIStackView()
    private let scoreLabel = UILabel()
    private let nameLabel = UILabel()
    private let brandLabel = UILabel()
    private let numberOfReviewsLabel = UILabel()
    
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
    
    private func initialization() {
        backgroundColor = UIColor.white
        clipsToBounds = true
        layer.cornerRadius = 10 / masterRatio
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints { make in
            make.width.equalTo(290 / masterRatio)
            make.height.equalTo(319 / masterRatio)
        }
        
        productImageView.contentMode = .scaleAspectFit
        addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.left.top.equalTo(self).offset(20 / masterRatio)
            make.width.height.equalTo(128 / masterRatio)
        }
        
        for _ in 1...5 {
            let ratingIndicator = UIImageView(image: UIImage(named: "score-empty-small"))
            scoreIndicators.addArrangedSubview(ratingIndicator)
        }
        addSubview(scoreIndicators)
        scoreIndicators.snp.makeConstraints { make in
            make.left.equalTo(self).offset(18 / masterRatio)
            make.bottom.equalTo(self).offset(-24 / masterRatio)
        }
        
        scoreLabel.font = UIFont.avenirMedium(24)
        scoreLabel.textColor = UIColor(hexString: "686868")
        addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.left.equalTo(scoreIndicators.snp.right).offset(6 / masterRatio)
            make.centerY.equalTo(scoreIndicators)
        }
        
        brandLabel.font = UIFont.avenirBook(22)
        brandLabel.textColor = UIColor(hexString: "979797")
        addSubview(brandLabel)
        brandLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20 / masterRatio)
            make.right.equalTo(self).offset(-20 / masterRatio)
            make.bottom.equalTo(scoreIndicators.snp.top).offset(-20 / masterRatio)
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
        
        numberOfReviewsLabel.font = UIFont.avenirMedium(18)
        numberOfReviewsLabel.textColor = UIColor(hexString: "686868")
        addSubview(numberOfReviewsLabel)
        numberOfReviewsLabel.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-20 / masterRatio)
            make.centerY.equalTo(scoreIndicators)
        }
        
        let editIcon = UIImageView(image: UIImage(named: "edit-small"))
        addSubview(editIcon)
        editIcon.snp.makeConstraints { make in
            make.width.height.equalTo(15 / masterRatio)
            make.right.equalTo(numberOfReviewsLabel.snp.left).offset(-5 / masterRatio)
            make.centerY.equalTo(numberOfReviewsLabel)
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

}
