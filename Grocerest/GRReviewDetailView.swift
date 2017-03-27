//
//  GRReviewDetailView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 18/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SnapKit

class GRReviewDetailView: UIView {
    
    let navigationToolBar: GRToolbar = GRToolbar()
    
    fileprivate let productImageView = UIImageView()
    fileprivate let productTitleLabel = UILabel()
    fileprivate let productButton = UIButton(type: .custom)
    fileprivate let productBrandLabel = UILabel()
    fileprivate let scoreIndicators = UIStackView()
    fileprivate let updateButton = UIButton(type: .custom)
    fileprivate let firstReviewBadge = UIImageView(image: UIImage(named: "first-review-badge"))
    fileprivate let dateLabel = UILabel()
    fileprivate let productScannedIcon = UIImageView(image: UIImage(named: "green-scanned"))
    fileprivate let reviewTextLabel = UILabel()
    
    lazy var profileImageView : UserImage = {
        let userImage = UserImage()
        return userImage
    }()
    
    fileprivate let usernameLabel = UILabel()
    fileprivate let userReputationLabel = UILabel()
    fileprivate let userLevelLabel = UILabel()
    fileprivate let userReviewsCounterLabel = UILabel()
    fileprivate let userButton = UIButton(type: .custom)
    fileprivate let reportButton = UIButton(type: .custom)
    fileprivate let usefullnessIcon = UIImageView()
    fileprivate let usefullnessLabel = UILabel()
    
    var myReview: Bool = false {
        didSet {
            reportButton.isHidden = myReview
            updateButton.isHidden = !myReview
        }
    }
    
    var productImage: UIImage? {
        get { return productImageView.image }
        set (i) { productImageView.image = i}
    }
    var productTitle: String = "" {
        didSet {
            if productTitle.characters.count <= 32 { productTitleLabel.text = "\n\(productTitle)" }
            else { productTitleLabel.text = productTitle }
        }
    }
    var productBrand: String = "" { didSet { productBrandLabel.text = productBrand } }
    
    var productIsScanned: Bool = false {
        didSet {
            if productIsScanned {
                firstReviewBadge.snp.remakeConstraints { make in
                    make.centerY.equalTo(scoreIndicators)
                    make.right.equalTo(productScannedIcon.snp.left).offset(-12 / masterRatio)
                }
            } else {
                firstReviewBadge.snp.remakeConstraints { make in
                    make.centerY.equalTo(scoreIndicators)
                    make.right.equalTo(dateLabel.snp.left).offset(-14 / masterRatio)
                }
            }
            productScannedIcon.isHidden = !productIsScanned
        }
    }
    
    var reviewScore: Int = 0 {
        didSet {
            var i = reviewScore
            for indicator in scoreIndicators.arrangedSubviews as! [UIImageView] {
                if i > 0 {
                    indicator.image = UIImage(named: "score-full-medium")
                } else {
                    indicator.image = UIImage(named: "score-empty-medium")
                }
                i -= 1
            }
        }
    }
    var reviewCreationDate: Date? {
        didSet {
            if let date = reviewCreationDate{
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
    var reviewText: String = "" { didSet { reviewTextLabel.text = "“\(reviewText)”" } }
    

    var username: String = "" { didSet { usernameLabel.text = username } }
    
    var userReputation: Int = 0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let reputationLocalized = formatter.string(from: NSNumber(value: userReputation)) ?? userReputation.description
            
            userReputationLabel.text = reputationLocalized
        }
    }
    
    var userLevel: Int = 0 { didSet { userLevelLabel.text = "Livello \(userLevel)" } }
    var userReviewsCount: Int = 0 {
        didSet {
            if userReviewsCount == 1 {
                userReviewsCounterLabel.text = "1 recensione"
            } else {
                userReviewsCounterLabel.text = "\(userReviewsCount) recensioni"
            }
        }
    }
    
    enum UsefullnessCheckerStatus {
        case active
        case inactive
        case myReview
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
                                                                         action: "ReviewDetailView: negative numberOfUseful",
                                                                         label: "\(productTitle)",
                                                                         value: nil
                )
                tracker?.send(event?.build() as [NSObject: AnyObject]?)
                numberOfUseful = 0
                return
            }
            updateUsefullness()
        }
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
        case .myReview:
            usefullnessLabel.textColor = UIColor.grocerestLightGrayColor()
            usefullnessLabel.text = "Utile (\(numberOfUseful))"
            usefullnessIcon.image = UIImage(named: "utile-inactive-checked")
        }
    }
    
    var isFirstReview: Bool = false { didSet { firstReviewBadge.isHidden = !isFirstReview } }

    var onUpdateButtonTapped,
        onReportButtonTapped,
        onUsefullnessButtonTapped,
        onProductThumbnailTapped,
        onProductTapped,
        onUserTapped,
        onShareButtonTapped: (() -> Void)?
    
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
    
    fileprivate func setupHierarchy() {
        backgroundColor = UIColor.white
        
        addSubview(navigationToolBar)
        navigationToolBar.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.left.equalTo(0)
        }
        
        let contentView = UIView()
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(navigationToolBar.snp.bottom)
            make.right.left.bottom.equalTo(self)
        }
        
        productImageView.contentMode = .scaleAspectFit
        contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(128 / masterRatio)
            make.top.equalTo(contentView).offset(26 / masterRatio)
            make.left.equalTo(contentView).offset(32 / masterRatio)
        }
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self._productThumbnailTapped(_:)))
        productImageView.addGestureRecognizer(tapRecognizer)
        productImageView.isUserInteractionEnabled = true
        
        productBrandLabel.font = Constants.BrandFonts.avenirBook11
        productBrandLabel.textColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0)
        contentView.addSubview(productBrandLabel)
        productBrandLabel.snp.makeConstraints { make in
            make.bottom.equalTo(productImageView.snp.bottom).offset(-10 / masterRatio)
            make.left.equalTo(productImageView.snp.right).offset(20 / masterRatio)
            make.right.equalTo(contentView).offset(-32 / masterRatio)
        }
        
        productTitleLabel.numberOfLines = 2
        productTitleLabel.font = Constants.BrandFonts.ubuntuMedium16
        productTitleLabel.textColor = UIColor.grocerestDarkBoldGray()
        contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(productBrandLabel.snp.top).offset(-5 / masterRatio)
            make.left.equalTo(productImageView.snp.right).offset(20 / masterRatio)
            make.right.equalTo(contentView).offset(-32 / masterRatio)
        }
        
        productButton.addTarget(self, action: #selector(self._productTitleOrBrandButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(productButton)
        productButton.snp.makeConstraints { make in
            make.left.top.right.equalTo(productTitleLabel)
            make.bottom.equalTo(productBrandLabel)
        }
        
        let topSeparator = UIView()
        topSeparator.backgroundColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        contentView.addSubview(topSeparator)
        topSeparator.snp.makeConstraints { make in
            make.height.equalTo(1 / masterRatio)
            make.top.equalTo(productImageView.snp.bottom).offset(26 / masterRatio)
            make.left.equalTo(contentView).offset(32 / masterRatio)
            make.right.equalTo(contentView).offset(-32 / masterRatio)
        }
        
        scoreIndicators.axis  = UILayoutConstraintAxis.horizontal
        scoreIndicators.distribution  = UIStackViewDistribution.equalSpacing
        scoreIndicators.alignment = UIStackViewAlignment.center
        for _ in 1...5 {
            let img = UIImageView(image: UIImage(named: "score-empty-medium"))
            scoreIndicators.addArrangedSubview(img)
        }
        contentView.addSubview(scoreIndicators)
        scoreIndicators.snp.makeConstraints { make in
            make.top.equalTo(topSeparator).offset(24 / masterRatio)
            make.left.equalTo(contentView).offset(30 / masterRatio)
        }
        
        updateButton.setTitle("Modifica", for: UIControlState())
        updateButton.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        updateButton.titleLabel?.font = Constants.BrandFonts.avenirHeavy11
        updateButton.isHidden = true
        contentView.addSubview(updateButton)
        updateButton.snp.makeConstraints { make in
            make.centerY.equalTo(scoreIndicators)
            make.left.equalTo(scoreIndicators.snp.right).offset(12 / masterRatio)
        }
        updateButton.addTarget(self, action: #selector(self._updateButtonTapped(_:)), for: .touchUpInside)
        
        dateLabel.font = Constants.BrandFonts.avenirMedium10
        dateLabel.textColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        dateLabel.textAlignment = .right
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(scoreIndicators)
            make.right.equalTo(contentView).offset(-32 / masterRatio)
        }
        
        productScannedIcon.isHidden = true
        contentView.addSubview(productScannedIcon)
        productScannedIcon.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.right.equalTo(dateLabel.snp.left).offset(-16 / masterRatio)
        }
        
        firstReviewBadge.isHidden = true
        contentView.addSubview(firstReviewBadge)
        firstReviewBadge.snp.makeConstraints { make in
            make.centerY.equalTo(scoreIndicators)
            make.right.equalTo(dateLabel.snp.left).offset(-14 / masterRatio)
        }
        
        reviewTextLabel.font = Constants.BrandFonts.avenirBook15
        reviewTextLabel.textColor = UIColor.grayTextFieldColor()
        reviewTextLabel.numberOfLines = 15
        contentView.addSubview(reviewTextLabel)
        reviewTextLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreIndicators.snp.bottom).offset(32 / masterRatio)
            make.left.equalTo(contentView).offset(32 / masterRatio)
            make.right.equalTo(contentView).offset(-32 / masterRatio)
        }
        
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(86 / masterRatio)
            make.top.equalTo(reviewTextLabel.snp.bottom).offset(20 / masterRatio)
            make.left.equalTo(contentView).offset(32 / masterRatio)
        }
        

        
        usernameLabel.font = Constants.BrandFonts.ubuntuBold14
        usernameLabel.textColor = UIColor.grocerestDarkBoldGray()
        contentView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewTextLabel.snp.bottom).offset(26 / masterRatio)
            make.left.equalTo(profileImageView.snp.right).offset(34 / masterRatio)
        }
        
        let reputationIcon = UIImageView(image: UIImage(named: "product_detail_grocerest_reputation"))
        contentView.addSubview(reputationIcon)
        reputationIcon.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(12 / masterRatio)
            make.left.equalTo(usernameLabel)
        }

        userReputationLabel.font = Constants.BrandFonts.ubuntuBold11
        userReputationLabel.textColor = UIColor(red:0.98, green:0.75, blue:0.18, alpha:1.0)
        contentView.addSubview(userReputationLabel)
        userReputationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(reputationIcon).offset(-2 / masterRatio)
            make.left.equalTo(reputationIcon.snp.right).offset(3 / masterRatio)
        }
        
        userLevelLabel.font = Constants.BrandFonts.avenirMedium10
        userLevelLabel.textColor = UIColor.grocerestBlue()
        contentView.addSubview(userLevelLabel)
        userLevelLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(8 / masterRatio)
            make.left.equalTo(userReputationLabel.snp.right).offset(19 / masterRatio)
        }
        
        let editIcon = UIImageView(image: UIImage(named: "edit-small"))
        contentView.addSubview(editIcon)
        editIcon.snp.makeConstraints { make in
            make.width.height.equalTo(18 / masterRatio)
            make.top.equalTo(usernameLabel.snp.bottom).offset(12 / masterRatio)
            make.left.equalTo(userLevelLabel.snp.right).offset(17 / masterRatio)
        }
        
        userReviewsCounterLabel.font = Constants.BrandFonts.avenirMedium10
        userReviewsCounterLabel.textColor = UIColor.nineSevenGrayColor()
        contentView.addSubview(userReviewsCounterLabel)
        userReviewsCounterLabel.snp.makeConstraints { make in
            make.centerY.equalTo(editIcon)
            make.left.equalTo(editIcon.snp.right).offset(6 / masterRatio)
        }
        
        userButton.addTarget(self, action: #selector(self._userButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(userButton)
        userButton.snp.makeConstraints { make in
            make.bottom.left.top.equalTo(profileImageView)
            make.right.equalTo(userReviewsCounterLabel)
        }
        
        let bottomSeparator = UIView()
        bottomSeparator.backgroundColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        contentView.addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints { make in
            make.height.equalTo(1 / masterRatio)
            make.top.equalTo(profileImageView.snp.bottom).offset(26 / masterRatio)
            make.left.equalTo(contentView).offset(32 / masterRatio)
            make.right.equalTo(contentView).offset(-32 / masterRatio)
        }
        
        usefullnessIcon.image = UIImage(named: "utile-inactive-unchecked")
        usefullnessIcon.contentMode = .center
        contentView.addSubview(usefullnessIcon)
        usefullnessIcon.snp.makeConstraints { make in
            make.width.height.equalTo(34 / masterRatio)
            make.top.equalTo(bottomSeparator).offset(21 / masterRatio)
            make.right.equalTo(contentView).offset(-32 / masterRatio)
        }
        
        usefullnessLabel.text = "È utile?"
        usefullnessLabel.font = Constants.BrandFonts.avenirBook11
        usefullnessLabel.textColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0)
        contentView.addSubview(usefullnessLabel)
        usefullnessLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usefullnessIcon)
            make.right.equalTo(usefullnessIcon.snp.left).offset(-9 / masterRatio)
        }
        
        let usefullnessButton = UIButton(type: .custom)
        contentView.addSubview(usefullnessButton)
        usefullnessButton.snp.makeConstraints { make in
            make.left.top.equalTo(usefullnessLabel)
            make.right.bottom.equalTo(usefullnessIcon)
        }
        usefullnessButton.addTarget(self, action: #selector(self._usefullnessButtonTapped(_:)), for: .touchUpInside)
        
        reportButton.setTitle("Segnala", for: UIControlState())
        reportButton.setTitleColor(UIColor.nineSevenGrayColor(), for: UIControlState())
        reportButton.titleLabel?.font = Constants.BrandFonts.avenirBook11
        reportButton.setImage(UIImage(named: "segnala-grey"), for: UIControlState())
        let padding: CGFloat = 12
        reportButton.titleEdgeInsets = UIEdgeInsetsMake(0, padding / masterRatio, 0, -padding / masterRatio)
        reportButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, padding / masterRatio)
        contentView.addSubview(reportButton)
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(bottomSeparator).offset(20 / masterRatio)
            make.left.equalTo(contentView).offset(32 / masterRatio)
        }
        reportButton.addTarget(self, action: #selector(self._reportButtonTapped(_:)), for: .touchUpInside)
        
        let verticalSeparator = UIView()
        verticalSeparator.backgroundColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        contentView.addSubview(verticalSeparator)
        verticalSeparator.snp.makeConstraints { make in
            make.height.equalTo(30 / masterRatio)
            make.width.equalTo(1.5 / masterRatio)
            make.right.equalTo(usefullnessLabel.snp.left).offset(-16 / masterRatio)
            make.centerY.equalTo(usefullnessLabel)
        }
        
        let shareLabel = UILabel()
        shareLabel.text = "Condividi"
        shareLabel.font = .avenirBook(22)
        shareLabel.textColor = UIColor(hexString: "979797")
        contentView.addSubview(shareLabel)
        shareLabel.snp.makeConstraints { make in
            make.right.equalTo(verticalSeparator.snp.left).offset(-16 / masterRatio)
            make.centerY.equalTo(verticalSeparator)
        }
        
        let shareIcon = UIImageView(image: UIImage(named: "share"))
        contentView.addSubview(shareIcon)
        shareIcon.snp.makeConstraints { make in
            make.width.equalTo(27 / masterRatio)
            make.height.equalTo(36 / masterRatio)
            make.right.equalTo(shareLabel.snp.left).offset(-16 / masterRatio)
            make.bottom.equalTo(shareLabel).offset(-2 / masterRatio)
        }
        
        let shareButton = UIButton(type: .custom)
        shareButton.addTarget(self, action: #selector(self._shareButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.left.equalTo(shareIcon)
            make.bottom.right.equalTo(shareLabel)
        }
    }
    
    /**
     Loads and set the product's image from an URL
     */
    func setProductImageFrom(_ url: URL) {
        self.productImageView.layoutIfNeeded()
        self.productImageView.hnk_setImageFromURL(url)
    }
    
    
    func _usefullnessButtonTapped(_: UIButton) {
        if usefullnessCheckerStatus == .active { onUsefullnessButtonTapped?() }
    }
    
    func _reportButtonTapped(_: UIButton) {
        onReportButtonTapped?()
    }
    
    func _updateButtonTapped(_: UIButton) {
        onUpdateButtonTapped?()
    }
    
    func _productThumbnailTapped(_: UIButton) {
        onProductThumbnailTapped?()
    }
    
    func _productTitleOrBrandButtonTapped(_: UIButton) {
        onProductTapped?()
    }

    func _userButtonTapped(_: UIButton) {
        onUserTapped?()
    }
    
    func _shareButtonTapped(_: UIButton) {
        onShareButtonTapped?()
    }

}
