//
//  GRLastReview.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRLastReview: UIView {
    
    fileprivate let productImageView = UIImageView()
    fileprivate let productTitleLabel = UILabel()
    fileprivate let productButton = UIButton(type: .custom)
    fileprivate let productBrandLabel = UILabel()
    fileprivate let scoreIndicators = UIStackView()
    fileprivate let firstReviewBadge = UIImageView(image: UIImage(named: "first-review-badge"))
    fileprivate let dateLabel = UILabel()
    fileprivate let reviewTextLabel = UILabel()
    let profileImageView = UserImage()
    fileprivate let usernameLabel = UILabel()
    fileprivate let userReputationLabel = UILabel()
    fileprivate let userButton = UIButton(type: .custom)
    
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
    
    var reviewScore: Int = 0 {
        didSet {
            var i = reviewScore
            for indicator in scoreIndicators.arrangedSubviews as! [UIImageView] {
                if i > 0 {
                    indicator.image = UIImage(named: "score-full-small")
                } else {
                    indicator.image = UIImage(named: "score-empty-small")
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
    
    var isFirstReview: Bool = false { didSet { firstReviewBadge.isHidden = !isFirstReview } }
    
    var productId : String?
    var author: JSON?
    var reviewId: String?
    
    var onProductThumbnailTapped,
        onProductTapped,
        onReviewTapped,
        onUserTapped: (() -> Void)?
    
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
        translatesAutoresizingMaskIntoConstraints = false
        
        snp.makeConstraints { make in
            make.width.equalTo(750 / masterRatio)
            make.height.equalTo(390 / masterRatio)
        }
        
        productImageView.contentMode = .scaleAspectFit
        addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(128 / masterRatio)
            make.top.equalTo(self).offset(20 / masterRatio)
            make.left.equalTo(self).offset(32 / masterRatio)
        }
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self._productThumbnailTapped(_:)))
        productImageView.addGestureRecognizer(tapRecognizer)
        productImageView.isUserInteractionEnabled = true
        
        productBrandLabel.font = UIFont.avenirBook(22)
        productBrandLabel.textColor = UIColor(hexString: "979797")
        addSubview(productBrandLabel)
        productBrandLabel.snp.makeConstraints { make in
            make.bottom.equalTo(productImageView.snp.bottom).offset(-10 / masterRatio)
            make.left.equalTo(productImageView.snp.right).offset(20 / masterRatio)
            make.right.equalTo(self).offset(-32 / masterRatio)
        }
        
        productTitleLabel.numberOfLines = 2
        productTitleLabel.font = UIFont.ubuntuMedium(32)
        productTitleLabel.textColor = UIColor.grocerestDarkBoldGray()
        addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(productBrandLabel.snp.top).offset(-5 / masterRatio)
            make.left.equalTo(productImageView.snp.right).offset(20 / masterRatio)
            make.right.equalTo(self).offset(-32 / masterRatio)
        }
        
        productButton.addTarget(self, action: #selector(self._productTitleOrBrandButtonTapped(_:)), for: .touchUpInside)
        addSubview(productButton)
        productButton.snp.makeConstraints { make in
            make.left.top.right.equalTo(productTitleLabel)
            make.bottom.equalTo(productBrandLabel)
        }
        
        let topSeparator = UIView()
        topSeparator.backgroundColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        addSubview(topSeparator)
        topSeparator.snp.makeConstraints { make in
            make.height.equalTo(1 / masterRatio)
            make.top.equalTo(productImageView.snp.bottom).offset(20 / masterRatio)
            make.left.equalTo(self).offset(32 / masterRatio)
            make.right.equalTo(self).offset(-32 / masterRatio)
        }
        
        scoreIndicators.axis  = UILayoutConstraintAxis.horizontal
        scoreIndicators.distribution  = UIStackViewDistribution.equalSpacing
        scoreIndicators.alignment = UIStackViewAlignment.center
        for _ in 1...5 {
            let img = UIImageView(image: UIImage(named: "score-empty-small"))
            scoreIndicators.addArrangedSubview(img)
        }
        addSubview(scoreIndicators)
        scoreIndicators.snp.makeConstraints { make in
            make.top.equalTo(topSeparator).offset(18 / masterRatio)
            make.left.equalTo(self).offset(30 / masterRatio)
        }
        
        dateLabel.font = Constants.BrandFonts.avenirMedium10
        dateLabel.textColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        dateLabel.textAlignment = .right
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(scoreIndicators)
            make.right.equalTo(self).offset(-32 / masterRatio)
        }
        
        firstReviewBadge.isHidden = true
        addSubview(firstReviewBadge)
        firstReviewBadge.snp.makeConstraints { make in
            make.centerY.equalTo(scoreIndicators)
            make.right.equalTo(dateLabel.snp.left).offset(-14 / masterRatio)
        }
        
        reviewTextLabel.font = UIFont.avenirBook(30)
        reviewTextLabel.textColor = UIColor.grayTextFieldColor()
        reviewTextLabel.numberOfLines = 2
        addSubview(reviewTextLabel)
        reviewTextLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreIndicators.snp.bottom).offset(8 / masterRatio)
            make.left.equalTo(self).offset(32 / masterRatio)
            make.right.equalTo(self).offset(-32 / masterRatio)
        }
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(44 / masterRatio)
            make.top.equalTo(reviewTextLabel.snp.bottom).offset(18 / masterRatio)
            make.left.equalTo(self).offset(32 / masterRatio)
        }
        
        let reviewButton = UIButton(type: .custom)
        reviewButton.addTarget(self, action: #selector(self._reviewButtonTapped(_:)), for: .touchUpInside)
        addSubview(reviewButton)
        reviewButton.snp.makeConstraints { make in
            make.left.top.equalTo(scoreIndicators)
            make.bottom.right.equalTo(reviewTextLabel)
        }
        
        usernameLabel.font = UIFont.ubuntuBold(22)
        usernameLabel.textColor = UIColor.grocerestDarkBoldGray()
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(18 / masterRatio)
        }
        
        let separator = UIView()
        separator.backgroundColor = UIColor(hexString: "BDBDBD")
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.width.equalTo(1 / masterRatio)
            make.height.equalTo(24 / masterRatio)
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(usernameLabel.snp.right).offset(16 / masterRatio)
        }
        
        let reputationIcon = UIImageView(image: UIImage(named: "product_detail_grocerest_reputation"))
        addSubview(reputationIcon)
        reputationIcon.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(separator.snp.right).offset(16 / masterRatio)
        }
        
        userReputationLabel.font = UIFont.ubuntuBold(22)
        userReputationLabel.textColor = UIColor(hexString: "FBC02D")
        addSubview(userReputationLabel)
        userReputationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(reputationIcon).offset(-2 / masterRatio)
            make.left.equalTo(reputationIcon.snp.right).offset(3 / masterRatio)
        }
        
        userButton.addTarget(self, action: #selector(self._userButtonTapped(_:)), for: .touchUpInside)
        addSubview(userButton)
        userButton.snp.makeConstraints { make in
            make.bottom.left.top.equalTo(profileImageView)
            make.right.equalTo(userReputationLabel)
        }
    }
    
    /**
     Loads and set the product's image from an URL
     */
    func setProductImageFrom(_ url: URL) {
        self.productImageView.layoutIfNeeded()
        self.productImageView.hnk_setImageFromURL(url)
    }
    
    func _productThumbnailTapped(_: UIButton) {
        onProductThumbnailTapped?()
    }
    
    func _productTitleOrBrandButtonTapped(_: UIButton) {
        onProductTapped?()
    }
    
    func _reviewButtonTapped(_: UIButton) {
        onReviewTapped?()
    }
    
    func _userButtonTapped(_: UIButton) {
        onUserTapped?()
    }
    
    override func prepareForInterfaceBuilder() {
        productImage = UIImage(named: "Alimentari")
        productTitle = "Marmellata Scorpacci"
        productBrand = "Scorpacci"
        onProductThumbnailTapped = {
            print("Thumbnail tapped")
        }
        onProductTapped = {
            print("Product's name or brand tapped")
        }
        
        reviewScore = 3
        reviewCreationDate = Date()
        reviewText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
        onReviewTapped = {
            print("Review tapped")
        }
        
        profileImageView.setUserProfileAvatar("", name: "Ugo", lastName: "Manzi", type: .small)
        username = "manziugo"
        userReputation = 1890
        isFirstReview = true
        onUserTapped = {
            print("User tapped")
        }
    }
    
    func populateWith(_ review: JSON) {
        if let imgUrl = review["product"]["images"]["small"].string {
            setProductImageFrom(URL(string: String.fullPathForImage(imgUrl))!)
        } else {
            productImage = UIImage(named: review["product"]["category"].stringValue)
        }
        productTitle = review["product"]["display_name"].stringValue
        productBrand = review["product"]["display_brand"].stringValue
        
        reviewScore = review["rating"].intValue
        reviewCreationDate = Date(timeIntervalSince1970: review["tsCreated"].doubleValue / 1000)
        reviewText = review["review"].stringValue
        
        profileImageView.setUserProfileAvatar(review["author"]["picture"].stringValue, name: review["author"]["firstname"].stringValue, lastName: review["author"]["lastname"].stringValue, type: .small)
        
        username = review["author"]["username"].stringValue
        userReputation = review["author"]["score"].intValue
        isFirstReview = review["first"].boolValue
        
        productId = review["product"]["_id"].stringValue
        author = review["author"]
        reviewId = review["_id"].stringValue
    }
    
}
