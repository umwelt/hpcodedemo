//
//  GRReviewTableViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 04/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwiftLoader

class GRReviewTableViewCell: UITableViewCell {
    
    lazy var profileImageView : UserImage = {
        let userImage = UserImage()
        return userImage
    }()
    
    fileprivate let scoreIndicators = GRReviewTableViewCell.createScoreIndicators()
    fileprivate let updateReviewButton = UIButton(type: .custom)
    fileprivate let reviewLabel = UILabel()
    fileprivate let usernameLabel = UILabel()
    fileprivate let separator = UIView()
    fileprivate let reputationIcon = UIImageView(image: UIImage(named: "product_detail_grocerest_reputation"))
    fileprivate let reputationLabel = UILabel()
    fileprivate let firstReviewBadge = UIImageView(image: UIImage(named: "first-review-badge"))
    fileprivate let dateLabel = UILabel()
    fileprivate let usefullnessIcon = UIImageView()
    fileprivate let usefullnessLabel = UILabel()
    fileprivate let writeYourReviewLabelWithUsername = UILabel()
    fileprivate let writeYourReviewLabel = UILabel()
    fileprivate let createReviewIcon = UIImageView(image: UIImage(named: "recensione_todo"))
    fileprivate let createReviewButton = UIButton(type: .custom)
    fileprivate let userProfileButton = UIButton(type: .custom)
        
    var score: Int = 0 {
        didSet {
            if oldValue == score { return }
            if score < 0 {
                // Score cannot be negative
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                                                                         action: "ReviewTableViewCell: negative score",
                                                                         label: username,
                                                                         value: nil
                )
                tracker?.send(event?.build() as [NSObject:AnyObject]?)
                score = 0
                return
            }
            var counter = score
            for indicator in scoreIndicators.arrangedSubviews {
                let scoreIndicator = indicator as! UIImageView
                if counter > 0 {
                    scoreIndicator.image = UIImage(named: "score-full-small")
                } else {
                    scoreIndicator.image = UIImage(named: "score-empty-small")
                }
                counter -= 1
            }
        }
    }
    
    var reviewText: String = "" {
        didSet {
            if oldValue == reviewText { return }
            if reviewText.isEmpty {
                reviewLabel.text = " "
            } else {
                reviewLabel.text = reviewText
            }
        }
    }
    
    var username: String = "" {
        didSet {
            if oldValue == username { return }
            usernameLabel.text = username
            let text = NSMutableAttributedString(string: "\(username),\nconosci questo prodotto?")
            text.addAttribute(NSFontAttributeName, value: Constants.BrandFonts.ubuntuBold15!, range: NSRange(location: 0, length: username.characters.count+1))
            writeYourReviewLabelWithUsername.attributedText = text
        }
    }
    
    var userReputation: Int = 0 {
        didSet {
            if oldValue == userReputation { return }
            if userReputation < 0 {
                // User reputation cannot be negative
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                                                                         action: "ReviewTableViewCell: negative userReputation",
                                                                         label: username,
                                                                         value: nil
                )
                tracker?.send(event?.build() as [NSObject: AnyObject]?)
                userReputation = 0
                return
            }
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let reputationLocalized = formatter.string(from: NSNumber(value: userReputation)) ?? userReputation.description
            
            reputationLabel.text = "\(reputationLocalized)"
        }
    }
    
    var creationDate: Date? {
        didSet {
            if oldValue == creationDate { return }
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
        case myReview
    }
    
    var usefullnessCheckerStatus: UsefullnessCheckerStatus = .active {
        didSet {
            if oldValue != usefullnessCheckerStatus { updateUsefullness() }
        }
    }
    
    var isUseful: Bool = false {
        didSet {
            if oldValue != isUseful { updateUsefullness() }
        }
    }
    
    var numberOfUseful: Int = 0 {
        didSet {
            if oldValue == numberOfUseful { return }
            if numberOfUseful < 0 {
                // Cannot set a negative number of useful
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                                                                         action: "ReviewTableViewCell: negative numberOfUseful",
                                                                         label: username,
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
    
    var isYourReview: Bool = false {
        didSet {
            if oldValue == isYourReview { return }
            if isYourReview {
                if score != 0 /* && !reviewText.isEmpty */ {
                    updateReviewButton.isHidden = false
                    usefullnessCheckerStatus = .inactive
                    usefullnessIcon.isHidden = false
                    usefullnessLabel.isHidden = false
                    
                    reviewLabel.isHidden = false
                    usernameLabel.isHidden = false
                    separator.isHidden = false
                    reputationIcon.isHidden = false
                    reputationLabel.isHidden = false
                    dateLabel.isHidden = false
                    
                    writeYourReviewLabelWithUsername.isHidden = true
                    writeYourReviewLabel.isHidden = true
                    createReviewIcon.isHidden = true
                    createReviewButton.isHidden = true
                } else {
                    updateReviewButton.isHidden = true
                    usefullnessCheckerStatus = .inactive
                    usefullnessIcon.isHidden = true
                    usefullnessLabel.isHidden = true
                    
                    reviewLabel.isHidden = true
                    usernameLabel.isHidden = true
                    separator.isHidden = true
                    reputationIcon.isHidden = true
                    reputationLabel.isHidden = true
                    dateLabel.isHidden = true
                    
                    writeYourReviewLabelWithUsername.isHidden = false
                    writeYourReviewLabel.isHidden = false
                    createReviewIcon.isHidden = false
                    createReviewButton.isHidden = false
                }
            } else {
                updateReviewButton.isHidden = true
                usefullnessCheckerStatus = .active
                usefullnessIcon.isHidden = false
                usefullnessLabel.isHidden = false
                
                reviewLabel.isHidden = false
                usernameLabel.isHidden = false
                separator.isHidden = false
                reputationIcon.isHidden = false
                reputationLabel.isHidden = false
                dateLabel.isHidden = false
                
                writeYourReviewLabelWithUsername.isHidden = true
                writeYourReviewLabel.isHidden = true
                createReviewIcon.isHidden = true
                createReviewButton.isHidden = true
            }
        }
    }
    
    var isFirstReview: Bool = false {
        didSet {
            if oldValue == isFirstReview { return }
            firstReviewBadge.isHidden = !isFirstReview
        }
    }
    
    var onReviewTextTapped: (() -> Void)?
    var onUsefullnessButtonTapped: (() -> Void)?
    var onUpdateReviewButtonTapped: (() -> Void)?
    var onCreateReviewButtonTapped: (() -> Void)?
    var onUserProfileButtonTapped: (() -> Void)?
    
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
        backgroundColor = UIColor.white
        
        contentView.backgroundColor = UIColor.white
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.left.top.equalTo(contentView).offset(32 / masterRatio)
            make.width.height.equalTo(86 / masterRatio)
        }
        
        
        addSubview(userProfileButton)
        userProfileButton.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView).offset(32 / masterRatio)
            make.width.height.equalTo(86 / masterRatio)
        }
        userProfileButton.addTarget(self, action: #selector(self._userProfileButtonTapped(_:)), for: .touchUpInside)
        
        contentView.addSubview(scoreIndicators)
        scoreIndicators.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(32 / masterRatio)
            make.left.equalTo(profileImageView.snp.right).offset(32 / masterRatio)
        }
        
        updateReviewButton.isHidden = true
        updateReviewButton.setTitle("Modifica", for: UIControlState())
        updateReviewButton.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        updateReviewButton.titleLabel!.font = Constants.BrandFonts.avenirHeavy11
        contentView.addSubview(updateReviewButton)
        updateReviewButton.snp.makeConstraints { make in
            make.centerY.equalTo(scoreIndicators)
            make.left.equalTo(scoreIndicators.snp.right).offset(16 / masterRatio)
        }
        updateReviewButton.addTarget(self, action: #selector(self._updateReviewButtonTapped(_:)), for: .touchUpInside)
        
        reviewLabel.text = " "
        reviewLabel.font = Constants.BrandFonts.avenirBook15
        reviewLabel.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        reviewLabel.numberOfLines = 2
        contentView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreIndicators.snp.bottom).offset(7 / masterRatio)
            make.left.equalTo(profileImageView.snp.right).offset(32 / masterRatio)
            make.width.equalTo(510 / masterRatio)
        }
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self._reviewTextTapped(_:)))
        reviewLabel.addGestureRecognizer(tapRecognizer)
        reviewLabel.isUserInteractionEnabled = true
        
        usernameLabel.text = ""
        usernameLabel.font = Constants.BrandFonts.ubuntuBold11
        usernameLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        contentView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(10 / masterRatio)
            make.left.equalTo(profileImageView.snp.right).offset(32 / masterRatio)
        }
        
        separator.backgroundColor = UIColor.grocerestOffText()
        contentView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(24.02 / masterRatio)
            make.width.equalTo(1 / masterRatio)
            make.left.equalTo(usernameLabel.snp.right).offset(22 / masterRatio)
            make.bottom.equalTo(usernameLabel)
        }
        
        reputationLabel.text = ""
        reputationLabel.font = Constants.BrandFonts.ubuntuBold11
        reputationLabel.textColor = UIColor(red:0.98, green:0.75, blue:0.18, alpha:1.0)
        contentView.addSubview(reputationLabel)
        reputationLabel.snp.makeConstraints { make in
            make.bottom.equalTo(usernameLabel.snp.bottom)
            make.left.equalTo(separator.snp.right).offset(36 / masterRatio)
        }
        
        contentView.addSubview(reputationIcon)
        reputationIcon.snp.makeConstraints { make in
            make.right.equalTo(reputationLabel.snp.left).offset(-4 / masterRatio)
            make.bottom.equalTo(reputationLabel).offset(-2 / masterRatio)
        }
        
        dateLabel.text = ""
        dateLabel.font = Constants.BrandFonts.avenirMedium10
        dateLabel.textColor = UIColor.grocerestOffText()
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(scoreIndicators)
            make.right.equalTo(contentView).offset(-25 / masterRatio)
        }
        
        firstReviewBadge.isHidden = true
        contentView.addSubview(firstReviewBadge)
        firstReviewBadge.snp.makeConstraints { make in
            make.centerY.equalTo(scoreIndicators)
            make.right.equalTo(dateLabel.snp.left).offset(-14 / masterRatio)
        }
        
        usefullnessIcon.image = UIImage(named: "utile-inactive-unchecked")
        usefullnessIcon.contentMode = .center
        contentView.addSubview(usefullnessIcon)
        usefullnessIcon.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-14 / masterRatio)
            make.right.equalTo(contentView).offset(-30 / masterRatio)
            make.width.height.equalTo(34 / masterRatio)
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
        
        writeYourReviewLabelWithUsername.isHidden = true
        writeYourReviewLabelWithUsername.font = Constants.BrandFonts.avenirBook15
        writeYourReviewLabelWithUsername.textColor = UIColor.grocerestDarkBoldGray()
        writeYourReviewLabelWithUsername.text = ",\nconosci questo prodotto?"
        writeYourReviewLabelWithUsername.numberOfLines = 2
        contentView.addSubview(writeYourReviewLabelWithUsername)
        writeYourReviewLabelWithUsername.snp.makeConstraints { make in
            make.top.equalTo(scoreIndicators.snp.bottom).offset(10 / masterRatio)
            make.left.equalTo(profileImageView.snp.right).offset(32 / masterRatio)
            make.width.equalTo(510 / masterRatio)
        }
        
        writeYourReviewLabel.isHidden = true
        writeYourReviewLabel.font = Constants.BrandFonts.avenirHeavy15
        writeYourReviewLabel.textColor = UIColor.grocerestBlue()
        writeYourReviewLabel.text = "SCRIVI LA TUA RECENSIONE!"
        contentView.addSubview(writeYourReviewLabel)
        writeYourReviewLabel.snp.makeConstraints { make in
            make.top.equalTo(writeYourReviewLabelWithUsername.snp.bottom).offset(22 / masterRatio)
            make.left.equalTo(writeYourReviewLabelWithUsername)
            make.width.equalTo(510 / masterRatio)
        }
        
        contentView.addSubview(createReviewIcon)
        createReviewIcon.isHidden = true
        createReviewIcon.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-33 / masterRatio)
            make.bottom.equalTo(contentView).offset(-20 / masterRatio)
        }
        
        contentView.addSubview(createReviewButton)
        createReviewButton.isHidden = true
        createReviewButton.snp.makeConstraints { make in
            make.top.bottom.right.equalTo(contentView)
            make.left.equalTo(scoreIndicators.snp.left)
        }
        createReviewButton.addTarget(self, action: #selector(self._createReviewButtonTapped(_:)), for: .touchUpInside)
    }
    
    fileprivate static func createScoreIndicators() -> UIStackView {
        let stack = UIStackView()
        stack.axis  = UILayoutConstraintAxis.horizontal
        stack.distribution  = UIStackViewDistribution.equalSpacing
        stack.alignment = UIStackViewAlignment.center 
        for _ in 1...5 {
            let img = UIImageView(image: UIImage(named: "score-empty-small"))
            stack.addArrangedSubview(img)
        }
        return stack
    }
    
    
    func _reviewTextTapped(_: UIGestureRecognizer) {
        onReviewTextTapped?()
    }
    
    func _usefullnessButtonTapped(_: UIButton) {
        if usefullnessCheckerStatus == .active { onUsefullnessButtonTapped?() }
    }
    
    func _updateReviewButtonTapped(_: UIButton) {
        onUpdateReviewButtonTapped?()
    }
    
    func _createReviewButtonTapped(_: UIButton) {
        onCreateReviewButtonTapped?()
    }
    
    func _userProfileButtonTapped(_: UIButton) {
        onUserProfileButtonTapped?()
    }
    
    /**
     Resets and populates the cell with product's data. The controller
     which is using this cell is needed to setup callbacks.
     */
    func populateWith(review data: JSON, from controller: UIViewController, productImage: UIImage?, productBrand: String, productTitle: String) {
        reviewText = data["review"].stringValue
        score = data["rating"].intValue
        let creationDate = Date(timeIntervalSince1970: data["tsCreated"].doubleValue / 1000)
        self.creationDate = creationDate
        
        username = data["author"]["username"].stringValue
        let type = AvatarType.cells
        profileImageView.setUserProfileAvatar(data["author"]["picture"].stringValue, name: data["author"]["firstname"].stringValue, lastName: data["author"]["lastname"].stringValue, type: type)
        
        userReputation = data["author"]["score"].intValue
        
        
        // To User Profile
        
        let navigateToUserProfile = {
            let userProfileViewController = GRUserProfileViewController()
            userProfileViewController.author = data["author"]
            controller.navigationController?.pushViewController(userProfileViewController, animated: true)
        }
        
        onUserProfileButtonTapped = navigateToUserProfile
        
        if data["review"].stringValue.isEmpty {
            usefullnessCheckerStatus = .inactive
        } else {
            usefullnessCheckerStatus = .active
            isUseful = data["voteMine"].boolValue
            updateUsefullness()
            
            onReviewTextTapped = {
                
                if data["review"].stringValue.isEmpty {return}
                
                let reviewDetail = GRReviewDetailViewController()
                if let img = productImage {
                    reviewDetail.setProductImage(img)
                }
                reviewDetail.setProductTitle(productTitle)
                reviewDetail.setProductBrand(productBrand)
                
                reviewDetail.setUserLevel(self.userReputation)
                reviewDetail.prepopulateWith(review: data)
                reviewDetail.reviewId = data["_id"].stringValue
                controller.navigationController?.pushViewController(reviewDetail, animated: true)
            }
            
            onUsefullnessButtonTapped = {
                self.numberOfUseful += self.isUseful ? -1 : 1
                self.isUseful = !self.isUseful
                SwiftLoader.show(animated: true)
                GrocerestAPI.toggleUsefulnessVote(reviewId: data["_id"].stringValue) { _,_ in
                    SwiftLoader.hide()
                }
            }
            
            
        }
        
        isFirstReview = data["first"].boolValue
        numberOfUseful = data["voteCount"].intValue
    }

    
}
