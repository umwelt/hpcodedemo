//
//  GRUserReviewTableViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 25/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit


class GRUserReviewTableViewCell: UITableViewCell {
    
    lazy var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    
    fileprivate lazy var productLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ubuntuMedium(32)
        label.numberOfLines = 2
        label.textColor = UIColor(hexString: "#4A4A4A")
        label.textAlignment = .left
        
       
        return label
    }()
    
    
    var productBrandLabel: UILabel!
    fileprivate let scoreIndicators = GRUserReviewTableViewCell.createScoreIndicators()
    var dateLabel: UILabel!
    
    
    
    fileprivate lazy var productReview: UILabel = {
        let label = UILabel()
        label.font = UIFont.avenirBook(30)
        label.textColor = UIColor(hexString: "#686868")
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    fileprivate let usefullnessLabel = UILabel()
    fileprivate let usefullnessIcon = UIImageView()
    var usefullnessButton = UIButton(type: .custom)
    
    fileprivate var productDetailButton = UIButton()
    fileprivate var productImageButton = UIButton()
    fileprivate var productReviewButton = UIButton()

    var score: Int = 0 {
        didSet {
            if score < 0 {
                // Score cannot be negative
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                                                                         action: "UserReviewTableViewCell: negative score",
                                                                         label: productLabel.text,
                                                                         value: nil
                )
                tracker?.send(event?.build() as [NSObject: AnyObject]?)
                score = 0
                return
            }
            var counter = score
            for indicator in scoreIndicators.arrangedSubviews {
                if counter > 0 {
                    indicator.isHidden = false
                } else {
                    indicator.isHidden = true
                }
                counter -= 1
            }
        }
    }
    
    
    var creationDate: Date? {
        didSet {
            if let date = creationDate{
                let calendar = Calendar.current
                if calendar.isDateInToday(date) {
                    dateLabel.text = "Oggi"
                } else if calendar.isDateInYesterday(date) {
                    dateLabel.text = "Ieri"
                } else {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    dateLabel.text = formatter.string(from: date)
                }
            } else {
                dateLabel.text = ""
            }
        }
    }
    
    enum UsefullnessCheckerStatus {
        case active
        case inactive
    }
    
    var usefullnessCheckerStatus: UsefullnessCheckerStatus = .active {
        didSet { updateUsefullness() }
    }
    
    var isUseful: Bool = false {
        didSet { updateUsefullness() }
    }
    
    var numberOfUseful: Int = 0 {
        didSet {
            if numberOfUseful < 0 {
                // Cannot set a negative number of useful
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                                                                         action: "UserReviewTableViewCell: negative numberOfUseful",
                                                                         label: productLabel.text,
                                                                         value: nil
                )
                tracker?.send(event?.build() as [NSObject: AnyObject]?)
                numberOfUseful = 0
                return
            }
            updateUsefullness()
        }
    }
    
    
    
    var averageReviewScore: Double = 0 {
        didSet {
            if averageReviewScore < 0 || averageReviewScore > 5 {
                // Score must be between 0 and 5, extremes included
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                                                                         action: "UserReviewTableViewCell: negative averageReviewsScore",
                                                                         label: "\(productLabel.text)",
                                                                         value: nil
                )
                tracker?.send(event?.build() as [NSObject: AnyObject]?)
            }
            for indicator in scoreIndicators.arrangedSubviews {
                let circle = indicator as! UIImageView
                circle.image = UIImage(named: "score-empty-small")
            }
            if averageReviewScore == 0 {
//                scoreCounter.hidden = true
//                noScoreLabel.hidden = false
            } else {
//                noScoreLabel.hidden = true
//                scoreCounter.text = String(format: "%.2f", averageReviewScore)
//                scoreCounter.hidden = false
//                
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
    
    
    var onUsefullnessButtonTapped: (() -> Void)?
    var onProductDetailButtonTapped: (() -> Void)?
    var onProductReviewButtonTapped: (() -> Void)?
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cell")
        sharedInitializer()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitializer()
    }
    
    
    
}


extension GRUserReviewTableViewCell {
    
    var productText: String? {
        get{
            return productLabel.text
        }
        set(newText){
            if newText!.characters.count <= 39 {
                productLabel.text = "\n\(newText!)"
            } else {
                productLabel.text = newText!
            }
        }
    }
    
    var reviewText: String? {
        get{
            return productReview.text
        }
        set(newText){
            productReview.text = newText
        }
    }
    
    
    

}


extension GRUserReviewTableViewCell {
    
    
    func sharedInitializer() {
        
        self.backgroundColor = UIColor(hexString: "#F1F1F1")
        contentView.backgroundColor = UIColor.white
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(360 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(0)
        }
        
        
        contentView.addSubview(productImage)
        productImage.snp.makeConstraints { (make) in
            make.height.width.equalTo(128 / masterRatio)
            make.left.equalTo(30 / masterRatio)
            make.top.equalTo(22 / masterRatio)
        }
        
        contentView.addSubview(productLabel)
        productLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(31 / masterRatio)
            make.left.equalTo(productImage.snp.right).offset(20 / masterRatio)
            make.right.equalTo(contentView.snp.right).offset(-30 / masterRatio)
        }
        
        
        productBrandLabel = UILabel()
        contentView.addSubview(productBrandLabel)
        productBrandLabel.snp.makeConstraints { (make) in
            make.width.equalTo(productLabel.snp.width)
            make.left.equalTo(productLabel.snp.left)
            make.top.equalTo(productLabel.snp.bottom).offset(6 / masterRatio)
        }
        productBrandLabel.font = UIFont.avenirBook(22)
        productBrandLabel.textColor = UIColor(hexString: "#979797")
        productBrandLabel.textAlignment = .left
        productBrandLabel.numberOfLines = 1
        
        
        contentView.addSubview(productDetailButton)
        productDetailButton.snp.makeConstraints { (make) in
            make.edges.equalTo(productLabel.snp.edges)
        }
        
        productDetailButton.addTarget(self, action: #selector(self._productDetailButtonTapped(_:)), for: .touchUpInside)
        
        
        contentView.addSubview(productImageButton)
        productImageButton.snp.makeConstraints { (make) in
            make.edges.equalTo(productImage)
        }
        
        productImageButton.addTarget(self, action: #selector(self._productDetailButtonTapped(_:)), for: .touchUpInside)
        
        let separator = UIView()
        contentView.addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.height.equalTo(1 / masterRatio)
            make.width.equalTo(686 /  masterRatio)
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(productImage.snp.bottom).offset(20 / masterRatio)
        }
        separator.backgroundColor = UIColor(hexString: "#F2F2F2")
        
        let backgroundScoreIndicators = GRUserReviewTableViewCell.createBackgroundScoreIndicators()
        contentView.addSubview(backgroundScoreIndicators)
        backgroundScoreIndicators.snp.makeConstraints { make in
            make.top.equalTo(separator).offset(20 / masterRatio)
            make.left.equalTo(30 / masterRatio)
        }
        
        
        scoreIndicators.axis  = UILayoutConstraintAxis.horizontal
        scoreIndicators.distribution  = UIStackViewDistribution.equalSpacing
        scoreIndicators.alignment = UIStackViewAlignment.center
        for _ in 1...5 {
            let img = UIImageView(image: UIImage(named: "s3core-empty-medium"))
            scoreIndicators.addArrangedSubview(img)
        }
        contentView.addSubview(scoreIndicators)
        scoreIndicators.snp.makeConstraints { make in
            make.top.equalTo(separator).offset(20 / masterRatio)
            make.left.equalTo(30 / masterRatio)
        }
        
        dateLabel = UILabel()
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-36 / masterRatio)
            make.top.equalTo(scoreIndicators.snp.top)
        }
        dateLabel.font = UIFont.avenirMedium(22)
        dateLabel.textColor = UIColor(hexString: "#BDBDBD")
        dateLabel.textAlignment = .left
        
        
        contentView.addSubview(productReview)
        productReview.snp.makeConstraints { (make) in
            make.top.equalTo(scoreIndicators.snp.bottom).offset(8)
            make.left.equalTo(productImage.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-30 / masterRatio)
            
        }
       
        
        
        contentView.addSubview(productReviewButton)
        productReviewButton.snp.makeConstraints { (make) in
            make.edges.equalTo(productReview.snp.edges)
        }
        productReviewButton.addTarget(self, action: #selector(self._productReviewButtonTapped(_:)), for: .touchUpInside)
        
        
        
        usefullnessIcon.image = UIImage(named: "utile-inactive-unchecked")
        usefullnessIcon.contentMode = .center
        contentView.addSubview(usefullnessIcon)
        usefullnessIcon.snp.makeConstraints { make in
            make.width.height.equalTo(34 / masterRatio)
            make.bottom.equalTo(contentView.snp.bottom).offset(-14 / masterRatio)
            make.right.equalTo(contentView).offset(-30 / masterRatio)
        }
        
        usefullnessLabel.text = "È utile?"
        usefullnessLabel.font = Constants.BrandFonts.avenirBook11
        usefullnessLabel.textColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0)
        contentView.addSubview(usefullnessLabel)
        usefullnessLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usefullnessIcon)
            make.right.equalTo(usefullnessIcon.snp.left).offset(-9 / masterRatio)
        }
        
        
        addSubview(usefullnessButton)
        usefullnessButton.snp.makeConstraints { make in
            make.left.top.equalTo(usefullnessLabel)
            make.right.bottom.equalTo(usefullnessIcon)
        }
        usefullnessButton.addTarget(self, action: #selector(self._usefullnessButtonTapped(_:)), for: .touchUpInside)
        
        contentView.bringSubview(toFront: usefullnessButton)
        
    }

    
}

extension GRUserReviewTableViewCell {
    fileprivate static func createBackgroundScoreIndicators() -> UIStackView {
        let stack = UIStackView()
        stack.axis  = UILayoutConstraintAxis.horizontal
        stack.distribution  = UIStackViewDistribution.equalSpacing
        stack.alignment = UIStackViewAlignment.center
        for _ in 1...5 {
            stack.addArrangedSubview(UIImageView(image: UIImage(named: "score-empty-small")))
        }
        return stack
    }
    
    fileprivate static func createScoreIndicators() -> UIStackView {
        let stack = UIStackView()
        stack.axis  = UILayoutConstraintAxis.horizontal
        stack.distribution  = UIStackViewDistribution.equalSpacing
        stack.alignment = UIStackViewAlignment.center
        for _ in 1...5 {
            let img = UIImageView(image: UIImage(named: "score-full-small"))
            img.isHidden = true
            stack.addArrangedSubview(img)
        }
        return stack
    }
    
    func _usefullnessButtonTapped(_: UIButton) {
        if usefullnessCheckerStatus == .active { onUsefullnessButtonTapped?() }
    }
    
    func _productDetailButtonTapped(_:UIButton) {
        onProductDetailButtonTapped?()
    }
    
    func _productReviewButtonTapped(_:UIButton) {
        onProductReviewButtonTapped?()
    }
    
    
    func formatCellWith(_ review:JSON) {

        productImage.layoutIfNeeded()
        
        if let imageString = review["product"]["images"]["large"].string {
            print("image: \(imageString)")
            productImage.hnk_setImageFromURL(URL(string: String.fullPathForImage(imageString))!)
        } else {
            if let category = review["product"]["category"].string  {
                productImage.image = UIImage(named: "products_" + category)
            }
        }
        
        productText = review["product"]["display_name"].stringValue
        reviewText = review["review"].stringValue
        productBrandLabel.text = review["product"]["display_brand"].stringValue
        score = review["rating"].intValue
        numberOfUseful = review["voteCount"].intValue
        dateLabel.text = nil
        dateLabel.text = formateCarinaDate(review["tsCreated"].stringValue)
        
        if review["review"].stringValue.isEmpty {
            usefullnessCheckerStatus = .inactive
        } else {
            usefullnessCheckerStatus = .active
            isUseful = review["voteMine"].boolValue
        }
        
        averageReviewScore = review["rating"].doubleValue
    }
    
    func updateUsefullness() {
        switch usefullnessCheckerStatus {
        case .active:
            usefullnessLabel.textColor = UIColor.grocerestLightGrayColor()
            if isUseful {
                usefullnessLabel.text = "Utile (\(numberOfUseful))"
                usefullnessIcon.image = UIImage(named: "utile-active-checked")
            } else {
                usefullnessLabel.text = "È utile?"
                if numberOfUseful > 0 { usefullnessLabel.text?.append(" (\(numberOfUseful))") }
                usefullnessIcon.image = UIImage(named: "utile-active-unchecked")
            }
        case .inactive:
            usefullnessLabel.textColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0)
            usefullnessLabel.text = "È utile?"
            usefullnessIcon.image = UIImage(named: "utile-inactive-unchecked")
        }
    }
    
    func largeCell() {
        contentView.snp.remakeConstraints { (make) in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(374 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(0)
        }
        
        usefullnessIcon.snp.remakeConstraints { make in
            make.width.height.equalTo(34 / masterRatio)
            make.bottom.equalTo(contentView.snp.bottom).offset(-14 / masterRatio)
            make.right.equalTo(contentView).offset(-30 / masterRatio)
        }
        
        
        usefullnessLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(usefullnessIcon)
            make.right.equalTo(usefullnessIcon.snp.left).offset(-9 / masterRatio)
        }
        
        
        usefullnessButton.snp.remakeConstraints { make in
            make.left.top.equalTo(usefullnessLabel)
            make.right.bottom.equalTo(usefullnessIcon)
        }
    }
    
    func smallCell() {
        
        contentView.snp.remakeConstraints { (make) in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(286 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(0)
        }
        
        usefullnessIcon.snp.remakeConstraints { make in
            make.width.height.equalTo(34 / masterRatio)
            make.bottom.equalTo(contentView.snp.bottom).offset(-14 / masterRatio)
            make.right.equalTo(contentView).offset(-30 / masterRatio)
        }
        

        usefullnessLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(usefullnessIcon)
            make.right.equalTo(usefullnessIcon.snp.left).offset(-9 / masterRatio)
        }
        
        
        usefullnessButton.snp.remakeConstraints { make in
            make.left.top.equalTo(usefullnessLabel)
            make.right.bottom.equalTo(usefullnessIcon)
        }
        
    }
    
  
    
}

