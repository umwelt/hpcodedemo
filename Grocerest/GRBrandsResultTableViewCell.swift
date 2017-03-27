//
//  GRBrandsResultTableViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 02/02/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Haneke

class GRBrandsResultTableViewCell: UITableViewCell {
    
    // MARK: Private properties
    
    private let cellImageView = UIImageView()
    private let mainLabel = UILabel()
    private let productLabel = UILabel()
    private let button = UIButton()
    private let footer = UIView()
    private let listIcon = UIImageView()
    private let scannedIcon = UIImageView()
    private let reviewsIcon = UIImageView(image: UIImage(named: "edit-small"))
    private let reviewsCounter = UILabel()
    private let reviewsText = UILabel()
    private let noReviewsMessage = UILabel()
    private var scoreIndicators = UIStackView()
    private let scoreCounter = UILabel()
    private let noScoreLabel = UILabel()
    private let flagImage = UIImageView(image: UIImage(named: "flag"))
    private let rankLabel = UILabel()
    
    // MARK: Public properties
    
    var title: String {
        get { return mainLabel.text ?? "" }
        set { mainLabel.text = newValue }
    }
    
    var numberOfProducts: Int = 0 {
        didSet {
            let word = numberOfProducts == 1 ? "prodotto" : "prodotti"
            productLabel.text = "\(numberOfProducts) \(word)"
        }
    }
    
    var thumbnail: UIImage? {
        get { return cellImageView.image }
        set (image) {
            cellImageView.image = image
            cellImageView.layoutIfNeeded()
        }
    }
    
    var numberOfReviews: Int = 0 {
        didSet {
            if numberOfReviews < 0 {
                // Cannot set a negative number of reviews
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                                                             action: "ProductsResultTableViewCell: negative numberOfReviews",
                                                             label: "\(title)",
                    value: nil
                )
                tracker?.send(event?.build() as [NSObject: AnyObject]?)
                numberOfReviews = 0
                return
            }
            
            reviewsCounter.text = "\(numberOfReviews)"
            reviewsIcon.isHidden = false
            reviewsCounter.isHidden = false
            reviewsText.text = (numberOfReviews == 1 ? "voto" : "voti")
            reviewsText.isHidden = false
            noReviewsMessage.isHidden = true
        }
    }
    
    var averageReviewScore: Double = 0 {
        didSet {
            if averageReviewScore < 0 || averageReviewScore > 5 {
                // Score must be between 0 and 5, extremes included
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                                                             action: "ProductsResultTableViewCell: negative averageReviewsScore",
                                                             label: "\(title)",
                    value: nil
                )
                tracker?.send(event?.build() as [NSObject: AnyObject]?)
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
                scoreCounter.text = String(format: "%.2f", averageReviewScore)
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
    
    var isRankHidden = true {
        didSet {
            flagImage.isHidden = isRankHidden
            rankLabel.isHidden = isRankHidden
        }
    }
    
    var rank: Int = 0 {
        didSet {
            if rank > 99 {
                rankLabel.text = "+99"
            } else {
                rankLabel.text = "#\(rank)"
            }
        }
    }
    
    // MARK: Callbacks
    var onTapped: (() -> Void)?
    
    // MARK: Initializers and configuration methods
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 158 / masterRatio))
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
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
        self.backgroundColor = UIColor.F1F1F1Color()
        
        let wrapper = UIView()
        contentView.addSubview(wrapper)
        wrapper.backgroundColor = UIColor.white
        wrapper.layer.cornerRadius = 4
        wrapper.snp.remakeConstraints { make in
            make.width.equalTo(686 / masterRatio).priority(1000)
            make.center.equalTo(contentView)
            make.height.equalTo(280 / masterRatio).priority(1000)
        }
        
        wrapper.addSubview(cellImageView)
        cellImageView.snp.makeConstraints { make in
            make.width.height.equalTo(148 / masterRatio)
            make.left.equalTo(46.5 / masterRatio)
            make.top.equalTo(29 / masterRatio)
        }
        cellImageView.contentMode = .scaleAspectFit
        
        wrapper.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(wrapper.snp.top).offset(40 / masterRatio)
            make.left.equalTo(cellImageView.snp.right).offset(72 / masterRatio)
            make.right.equalTo(wrapper.snp.right).offset(-16 / masterRatio)
        }
        mainLabel.font = Constants.BrandFonts.ubuntuMedium14
        mainLabel.textColor = UIColor.grocerestDarkBoldGray()
        mainLabel.textAlignment = .left
        mainLabel.numberOfLines =  2
        
        wrapper.addSubview(productLabel)
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(12 / masterRatio)
            make.left.equalTo(cellImageView.snp.right).offset(72 / masterRatio)
            make.right.equalTo(wrapper.snp.right).offset(-16 / masterRatio)
        }
        productLabel.font = Constants.BrandFonts.avenirBook11
        productLabel.textColor = UIColor.grocerestLightGrayColor()
        productLabel.textAlignment = .left
        productLabel.numberOfLines = 1
        productLabel.lineBreakMode = .byTruncatingTail
        
        // Lateral flag
        flagImage.isHidden = true
        wrapper.addSubview(flagImage)
        flagImage.snp.makeConstraints { make in
            make.top.equalTo(wrapper).offset(130 / masterRatio)
            make.right.equalTo(wrapper).offset(6 / masterRatio)
        }
        
        rankLabel.isHidden = true
        rankLabel.font = .ubuntuMedium(24)
        rankLabel.textColor = .white
        rankLabel.textAlignment = .right
        wrapper.addSubview(rankLabel)
        rankLabel.snp.makeConstraints { make in
            make.top.equalTo(flagImage).offset(8 / masterRatio)
            make.right.equalTo(flagImage).offset(-19 / masterRatio)
        }
        
        // Footer
        // TODO: rounded bottom border and correct background color
        wrapper.addSubview(footer)
        footer.backgroundColor = UIColor.lightBackgroundGrey()
        footer.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(wrapper)
            make.top.equalTo(wrapper.snp.bottom).offset(-74 / masterRatio)
        }
        
        footer.addSubview(listIcon)
        listIcon.contentMode = .scaleAspectFit
        listIcon.isHidden = true
        listIcon.snp.makeConstraints { make in
            make.width.height.equalTo(42 / masterRatio)
            make.right.equalTo(footer.snp.right).offset(-20 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        footer.addSubview(scannedIcon)
        scannedIcon.image = UIImage(named: "greeen_scann")
        scannedIcon.contentMode = .scaleAspectFit
        scannedIcon.isHidden = true
        scannedIcon.snp.makeConstraints { make in
            make.width.height.equalTo(42 / masterRatio)
            make.right.equalTo(listIcon.snp.right)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        scoreIndicators.axis  = UILayoutConstraintAxis.horizontal
        scoreIndicators.distribution  = UIStackViewDistribution.equalSpacing
        scoreIndicators.alignment = UIStackViewAlignment.center
        for _ in 1...5 {
            let img = UIImageView(image: UIImage(named: "score-empty-small"))
            scoreIndicators.addArrangedSubview(img)
        }
        
        footer.addSubview(scoreIndicators)
        scoreIndicators.snp.makeConstraints { make in
            make.left.equalTo(footer.snp.left).offset(18 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        scoreCounter.font = Constants.BrandFonts.avenirMedium13
        scoreCounter.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        scoreCounter.isHidden = true
        footer.addSubview(scoreCounter)
        scoreCounter.snp.makeConstraints { make in
            make.left.equalTo(scoreIndicators.snp.right).offset(5 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        noScoreLabel.font = Constants.BrandFonts.avenirMedium13
        noScoreLabel.textColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        noScoreLabel.text = "n.d."
        footer.addSubview(noScoreLabel)
        noScoreLabel.snp.makeConstraints { make in
            make.left.equalTo(scoreIndicators.snp.right).offset(5 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        let separator = UIView()
        separator.backgroundColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        footer.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(42 / masterRatio)
            make.width.equalTo(2 / masterRatio)
            make.left.equalTo(noScoreLabel.snp.right).offset(23 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        reviewsIcon.contentMode = .scaleAspectFit
        footer.addSubview(reviewsIcon)
        reviewsIcon.snp.makeConstraints { make in
            make.width.height.equalTo(26 / masterRatio)
            make.left.equalTo(separator.snp.right).offset(31 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        reviewsCounter.font = Constants.BrandFonts.avenirMedium13
        reviewsCounter.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        footer.addSubview(reviewsCounter)
        reviewsCounter.snp.makeConstraints { make in
            make.left.equalTo(reviewsIcon.snp.right).offset(5 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        reviewsText.font = Constants.BrandFonts.avenirMedium13
        reviewsText.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        reviewsText.text = "voti"
        footer.addSubview(reviewsText)
        reviewsText.snp.makeConstraints { make in
            make.left.equalTo(reviewsCounter.snp.right).offset(5 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        wrapper.addSubview(button)
        button.snp.makeConstraints {
            $0.top.left.right.equalTo(wrapper)
            $0.bottom.equalTo(footer.snp.bottom)
        }
        button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        
        reviewsIcon.isHidden = true
        reviewsCounter.isHidden = true
        reviewsText.isHidden = true
    }
    
    func buttonTapped(_ sender: UIButton) {
        onTapped?()
    }
    
    // MARK: Public interest methods
    
    func setThumbnailFromUrl(_ url: URL) {
        cellImageView.hnk_setImageFromURL(url, format: Haneke.Format<UIImage>(name: "original"))
    }
    
    /**
     Resets and populates the cell with product's data. The controller
     which is using this cell is needed to setup callbacks.
     */
    func populateWith<T: UIViewController>(brand: JSON, from controller: T) where T: GRLastIdTappedCacher, T: GRModalViewControllerDelegate {
        thumbnail = UIImage(named: "no-brand-image-icon")
        selectionStyle = .none
        
        title = brand["display_name"].stringValue
        numberOfProducts = brand["products"].intValue
        
        let picUrl = brand["picture"].stringValue
        if let encodedUrl = picUrl.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
           let url = URL(string: encodedUrl) {
            setThumbnailFromUrl(url)
        }
        
        averageReviewScore = brand["average"].doubleValue
        numberOfReviews = brand["reviews"].intValue
        
        // Callbacks
        
        onTapped = {
            let brandDetail = GRBrandDetailViewController()
            controller.lastTappedId = brand["name"].stringValue
            brandDetail.modalDelegate = controller
            brandDetail.prepopulateWith(brand: brand)
            brandDetail.brand = brand["name"].stringValue
            UIApplication.topViewController()?.navigationController?.pushViewController(brandDetail, animated: true)
        }
    }
    
}
