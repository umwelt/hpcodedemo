//
//  GRUserSectionCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 19/10/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRUserView: UIView {
    
    fileprivate let userImage = UserImage()
    fileprivate let usernameLabel = UILabel()
    fileprivate let completeNameLabel = UILabel()
    fileprivate let reputationLabel = UILabel()
    fileprivate let levelLabel = UILabel()
    fileprivate let reviewsLabel = UILabel()
    
    var imageUrl: String = "" {
        didSet {
            updateCompleteName()
        }
    }
    
    var username: String? {
        didSet {
            usernameLabel.text = username
        }
    }
    
    var firstname: String? {
        didSet {
            updateCompleteName()
        }
    }
    
    var lastname: String? {
        didSet {
            updateCompleteName()
        }
    }
    
    var reputation: Int = 0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let reputationLocalized = formatter.string(from: NSNumber(value: reputation)) ?? reputation.description
            
            reputationLabel.text = "\(reputationLocalized)"
        }
    }
    
    var level: Int = 0 {
        didSet {
            levelLabel.text = "Livello \(level)"
        }
    }
    
    var reviews: Int = 0 {
        didSet {
            reviewsLabel.text = "\(reviews) recensioni"
        }
    }
    
    var onTap: (() -> Void)?
    
    fileprivate func updateCompleteName() {
        if let f = firstname, let l = lastname, f.characters.count > 0 && l.characters.count > 0 {
            userImage.setUserProfileAvatar(imageUrl, name: f, lastName: l, type: .cells)
            completeNameLabel.text = "\(f) \(l)"
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    fileprivate func initialize() {
        backgroundColor = UIColor.white
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints { make in
            make.width.equalTo(750 / masterRatio)
            make.height.equalTo(150 / masterRatio)
        }
        
        addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.width.height.equalTo(86 / masterRatio)
            make.top.equalTo(self).offset(20 / masterRatio)
            make.left.equalTo(self).offset(32 / masterRatio)
        }
        
        completeNameLabel.textColor = UIColor.black
        usernameLabel.font = UIFont.ubuntuBold(28)
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(27 / masterRatio)
            make.left.equalTo(userImage.snp.right).offset(26 / masterRatio)
        }
        
        completeNameLabel.textColor = UIColor(hexString: "979797")
        completeNameLabel.font = UIFont.avenirBook(24)
        addSubview(completeNameLabel)
        completeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(1 / masterRatio)
            make.left.equalTo(usernameLabel)
        }
        
        let reputationIcon = UIImageView(image: UIImage(named: "grocerest_reputation"))
        addSubview(reputationIcon)
        reputationIcon.snp.makeConstraints { make in
            make.width.equalTo(16.88 / masterRatio)
            make.height.equalTo(15.32 / masterRatio)
            make.top.equalTo(completeNameLabel.snp.bottom).offset(19 / masterRatio)
            make.left.equalTo(usernameLabel)
        }
        
        reputationLabel.textColor = UIColor(hexString: "FBC02D")
        reputationLabel.font = UIFont.ubuntuBold(22)
        addSubview(reputationLabel)
        reputationLabel.snp.makeConstraints { make in
            make.left.equalTo(reputationIcon.snp.right).offset(5 / masterRatio)
            make.centerY.equalTo(reputationIcon)
        }
        
        levelLabel.textColor = UIColor(hexString: "29ABE2")
        levelLabel.font = UIFont.avenirMedium(20)
        addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.left.equalTo(reputationLabel.snp.right).offset(18 / masterRatio)
            make.centerY.equalTo(reputationIcon)
        }
        
        let reviewsIcon = UIImageView(image: UIImage(named: "write_icon"))
        addSubview(reviewsIcon)
        reviewsIcon.snp.makeConstraints { make in
            make.width.height.equalTo(18 / masterRatio)
            make.left.equalTo(levelLabel.snp.right).offset(18 / masterRatio)
            make.centerY.equalTo(reputationIcon)
        }
        
        reviewsLabel.textColor = UIColor(hexString: "979797")
        reviewsLabel.font = UIFont.avenirMedium(20)
        addSubview(reviewsLabel)
        reviewsLabel.snp.makeConstraints { make in
            make.left.equalTo(reviewsIcon.snp.right).offset(9 / masterRatio)
            make.centerY.equalTo(reviewsIcon)
        }
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(self._onButtonTapped(_:)), for: .touchUpInside)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func _onButtonTapped(_: UIButton) {
        onTap?()
    }
    
    func populateWith(_ userData: JSON) {
        imageUrl = userData["picture"].stringValue
        username = userData["username"].stringValue
        firstname = userData["firstname"].stringValue
        lastname = userData["lastname"].stringValue
        reputation = userData["score"].intValue
        level = userData["level"].intValue
        reviews = userData["reviewsCount"].intValue
    }
    
    override func prepareForInterfaceBuilder() {
        username = "Francy"
        firstname = "Francesca"
        lastname = "Fortunato"
        reputation = 658
        level = 3
        reviews = 45
        onTap = {
            print("Tapped!")
        }
    }
    
}
