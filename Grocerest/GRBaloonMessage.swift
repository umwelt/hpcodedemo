//
//  GRMessageOne.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 06/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class GRBaloonMessage: UICollectionViewCell {
    
    fileprivate let titleLabel = UILabel()
    fileprivate let descriptionLabel = UILabel()
    
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
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints { make in
            make.height.equalTo(330 / masterRatio)
            make.width.equalTo(686 / masterRatio)
        }
        
        descriptionLabel.font = UIFont.avenirLight(30)
        descriptionLabel.numberOfLines = 2
        addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(32 / masterRatio)
            make.right.equalTo(self).offset(-32 / masterRatio)
            make.bottom.equalTo(self).offset(-55 / masterRatio)
        }
        
        titleLabel.font = UIFont.ubuntuLight(40)
        titleLabel.textColor = UIColor(hexString: "E53554")
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(32 / masterRatio)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-8 / masterRatio)
        }
    }
    
}

@IBDesignable
class GRBaloonLevelMessage: GRBaloonMessage {
    
    fileprivate let userImage = UserImage()
    fileprivate let icon = UIImageView()
    fileprivate let levelLabel = UILabel()
    
    var level = 1 {
        didSet {
            if level < 1 || level > 5 {
                print(level)
                //fatalError("Level must be between 1 and 5! \(level) given.")
            }
            update()
        }
    }
    
    var scoreToNextLevel = 0 {
        didSet {
            if level < 0 {
                fatalError("ScoreToNextLevel must be positive! \(scoreToNextLevel) given.")
            }
            update()
        }
    }
    
    var onUserImageTap: (() -> Void)?
    
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
    
    override fileprivate func initialization() {
        super.initialization()
        
        addSubview(userImage)
        
        userImage.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(32 / masterRatio)
            make.width.height.equalTo(86 / masterRatio)
        }
        
        let userImageButton = UIButton(type: .custom)
        userImageButton.addTarget(self, action: #selector(self._userImageTapped(_:)), for: .touchUpInside)
        addSubview(userImageButton)
        
        userImageButton.snp.makeConstraints { make in
            make.edges.equalTo(userImage)
        }
        
        
        icon.image = UIImage(named: "home-baloon-message-1-icon-level1")
        addSubview(icon)
        
        icon.snp.makeConstraints { make in
            make.top.equalTo(self).offset(15 / masterRatio)
            make.right.equalTo(self).offset(-24 / masterRatio)
            make.width.height.equalTo(67 / masterRatio)
        }
        
        levelLabel.font = UIFont.avenirLight(22)
        levelLabel.textColor = UIColor(hexString: "686868")
        levelLabel.text = "Livello 1"
        addSubview(levelLabel)
        
        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(4 / masterRatio)
            make.centerX.equalTo(icon.snp.centerX)
        }
        
        titleLabel.text = "Sei al livello 1!"
        descriptionLabel.text = "Scrivi recensioni ed invita amici. Ti mancano n punti per arrivare al livello 2!"
    }
    
    func setUserProfileAvatar(_ url: String, name: String, lastName: String) {
        userImage.setUserProfileAvatar(url, name: name, lastName: lastName, type: .cells)
    }
    
    fileprivate func update() {
        if level == 1 {
            icon.image = UIImage(named: "home-baloon-message-1-icon-level1")
            titleLabel.text = "Sei al livello 1!"
            descriptionLabel.text = "Scrivi recensioni ed invita amici. Ti mancano \(scoreToNextLevel) punti per arrivare al livello 2!"
        } else if 1 < level && level < 5 {
            icon.image = UIImage(named: "home-baloon-message-1-icon-levelx")
            titleLabel.text = "Sei al livello \(level)!"
            descriptionLabel.text = "Continua a recensire e invitare amici, ti mancano \(scoreToNextLevel) punti per arrivare al livello \(level+1)!"
        } else {
            icon.image = UIImage(named: "home-baloon-message-1-icon-level5")
            titleLabel.text = "Sei arrivato al Top!"
            descriptionLabel.text = "Continua a scrivere recensioni e invitare amici. Ci sono novità in arrivo."
        }
        levelLabel.text = "Livello \(level)"
    }
    
    func _userImageTapped(_ sender: UIButton) {
        onUserImageTap?()
    }
    
}

@IBDesignable
class GRBaloonReputationMessage: GRBaloonMessage {
    
    fileprivate let smiley = UIImageView()
    fileprivate let reputationLabel = UILabel()
    
    var level = 1 {
        didSet {
            if level < 1 || level > 5 {
               // fatalError("Level must be between 1 and 5! \(level) given.")
            }
            update()
        }
    }
    
    var reputation = 0 {
        didSet {
            if level < 0 {
                //fatalError("Reputation must be positive! \(reputation) given.")
            }
            update()
        }
    }
    
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
    
    override fileprivate func initialization() {
        super.initialization()
        
        smiley.image = UIImage(named: "home-baloon-message-2-smiley-1")
        addSubview(smiley)
        
        smiley.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(30 / masterRatio)
            make.width.height.equalTo(90 / masterRatio)
        }
        
        reputationLabel.font = UIFont.ubuntuBold(32)
        reputationLabel.textColor = UIColor(hexString: "FBC02D")
        reputationLabel.text = "97"
        addSubview(reputationLabel)
        
        reputationLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(17 / masterRatio)
            make.right.equalTo(self).offset(-20 / masterRatio)
        }
        
        let heartIcon = UIImageView()
        heartIcon.image = UIImage(named: "home-baloon-message-2-heart")
        addSubview(heartIcon)
        
        heartIcon.snp.makeConstraints { make in
            make.centerY.equalTo(reputationLabel)
            make.right.equalTo(reputationLabel.snp.left).offset(-7 / masterRatio)
        }
        
        titleLabel.text = "Aumenta la tua Reputation!"
        descriptionLabel.text = "Più punti Reputation avrai, maggiore sarà la tua influenza nella nostra Community."
    }
    
    fileprivate func update() {
        if level == 1 {
            smiley.image = UIImage(named: "home-baloon-message-2-smiley-1")
            titleLabel.text = "Aumenta la tua Reputation!"
            descriptionLabel.text = "Più punti Reputation avrai, maggiore sarà la tua influenza nella nostra Community."
        } else if 1 < level && level < 4 {
            smiley.image = UIImage(named: "home-baloon-message-2-smiley-2")
            titleLabel.text = "Hai una bella Reputation!"
            descriptionLabel.text = "Hai fatto molta esperienza e la tua influenza nella Community aumenta sempre di più!"
        } else {
            smiley.image = UIImage(named: "home-baloon-message-2-smiley-2")
            titleLabel.text = "Hai un’ottima Reputation!"
            descriptionLabel.text = "Tanti punti Reputation ti permettono di partecipare alle nostre iniziative esclusive."
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let reputationLocalized = formatter.string(from: NSNumber(value: reputation)) ?? reputation.description
        
        reputationLabel.text = "\(reputationLocalized)"
    }
    
}

@IBDesignable
class GRBaloonReviewsMessage: GRBaloonMessage {
    
    fileprivate let dotty = UIImageView()
    fileprivate let reviewsLabel = UILabel()
    
    var reviews = 0 {
        didSet {
            if reviews < 0 {
                fatalError("Reviews must be positive! \(reviews) given.")
            }
            update()
        }
    }
    
    var username: String? {
        didSet {
            update()
        }
    }
    
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
    
    override fileprivate func initialization() {
        super.initialization()
        
        dotty.image = UIImage(named: "home-baloon-message-3-dotty-1")
        addSubview(dotty)
        
        dotty.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(30 / masterRatio)
            make.width.height.equalTo(90 / masterRatio)
        }
        
        reviewsLabel.font = UIFont.avenirMedium(32)
        reviewsLabel.textColor = UIColor(hexString: "686868")
        reviewsLabel.text = "57"
        addSubview(reviewsLabel)
        
        reviewsLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(17 / masterRatio)
            make.right.equalTo(self).offset(-20 / masterRatio)
        }
        
        let heartIcon = UIImageView()
        heartIcon.image = UIImage(named: "home-baloon-message-2-edit")
        addSubview(heartIcon)
        
        heartIcon.snp.makeConstraints { make in
            make.centerY.equalTo(reviewsLabel)
            make.right.equalTo(reviewsLabel.snp.left).offset(-7 / masterRatio)
        }
        
        titleLabel.text = "Forza username!"
        descriptionLabel.text = "Hai appena cominciato, ma sappiamo che hai tante opinioni da condividere. Inizia subito!"
    }
    
    fileprivate func update() {
        let username = self.username == nil ? "" : self.username!
        if reviews <= 10 {
            dotty.image = UIImage(named: "home-baloon-message-3-dotty-1")
            titleLabel.text = "Forza \(username)!"
            descriptionLabel.text = "Hai appena cominciato, ma sappiamo che hai tante opinioni da condividere. Inizia subito!"
        } else if 10 < reviews && reviews < 100 {
            dotty.image = UIImage(named: "home-baloon-message-3-dotty-2")
            titleLabel.text = "Grazie \(username)!"
            descriptionLabel.text = "Le tue recensioni iniziano a farsi notare. Continua così per scalare le classifiche!"
        } else {
            dotty.image = UIImage(named: "home-baloon-message-3-dotty-3")
            titleLabel.text = "Ottimo lavoro \(username)!"
            descriptionLabel.text = "Sei arrivato tra i primi 100 utenti! Ormai sei un punto di riferimento nella Community."
        }
        reviewsLabel.text = "\(reviews)"
    }
    
}
