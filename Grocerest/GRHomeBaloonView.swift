//
//  GRHomeBaloon.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 05/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

@IBDesignable class GRHomeBaloon: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate class TriangleView: UIView {
        override func draw(_ rect: CGRect) {
            if let ctx = UIGraphicsGetCurrentContext() {
                ctx.beginPath()
                ctx.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
                ctx.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                ctx.addLine(to: CGPoint(x: rect.minX, y: (rect.maxY/2.0)))
                ctx.closePath()
                ctx.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                ctx.fillPath()
            }
        }
    }
    
    var username: String? {
        didSet {
            pages.reloadData()
        }
    }
    
    var level = 1 {
        didSet {
            pages.reloadData()
        }
    }
    
    var scoreToNextLevel = 0 {
        didSet {
            pages.reloadData()
        }
    }
    
    var reputation = 0 {
        didSet {
            pages.reloadData()
        }
    }
    
    var reviews = 0 {
        didSet {
            pages.reloadData()
        }
    }
    
    var onUserImageTap: (() -> Void)? {
        didSet {
            levelMessage.onUserImageTap = onUserImageTap
        }
    }
    
    fileprivate var pictureUrl: String = ""
    fileprivate var userFirstName: String = ""
    fileprivate var userLastName: String = ""
    
    func setUserProfileAvatar(_ url: String, name: String, lastName: String) {
        pictureUrl = url
        userFirstName = name
        userLastName = lastName
        pages.reloadData()
    }
    
    fileprivate let levelMessage = GRBaloonLevelMessage()
    fileprivate let reputationMessage = GRBaloonReputationMessage()
    fileprivate let reviewsMessage = GRBaloonReviewsMessage()
    fileprivate let dots = UIStackView()
    
    fileprivate let pages: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 686 / masterRatio, height: 330 / masterRatio)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    
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
            make.width.equalTo(709 / masterRatio)
        }
        
        let baloon = UIView()
        baloon.backgroundColor = UIColor.white
        baloon.layer.cornerRadius = 10 / masterRatio
        baloon.clipsToBounds = true
        addSubview(baloon)
        
        baloon.translatesAutoresizingMaskIntoConstraints = false
        baloon.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(23 / masterRatio)
            make.height.equalTo(self)
            make.width.equalTo(686 / masterRatio)
        }
        
        let triangle = TriangleView()
        addSubview(triangle)
        
        triangle.translatesAutoresizingMaskIntoConstraints = false
        triangle.backgroundColor = UIColor(hexString: "F1F1F1")
        triangle.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.bottom.equalTo(self).offset(-22 / masterRatio)
            make.height.equalTo(32 / masterRatio)
            make.width.equalTo(25 / masterRatio)
        }
        
        pages.backgroundColor = UIColor.white
        pages.layer.cornerRadius = 10 / masterRatio
        pages.clipsToBounds = true
        pages.bounces = false
        pages.showsHorizontalScrollIndicator = false
        pages.isPagingEnabled = true
        pages.register(GRBaloonLevelMessage.self, forCellWithReuseIdentifier: "level")
        pages.register(GRBaloonReputationMessage.self, forCellWithReuseIdentifier: "reputation")
        pages.register(GRBaloonReviewsMessage.self, forCellWithReuseIdentifier: "reviews")
        pages.dataSource = self
        pages.delegate = self
        addSubview(pages)

        pages.snp.makeConstraints { make in
            make.edges.equalTo(baloon)
        }
        
        dots.spacing = 12 / masterRatio
        addSubview(dots)
        
        dots.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-32 / masterRatio)
            make.bottom.equalTo(self).offset(-20 / masterRatio)
        }
        
        for i in 1...3 {
            let dot = UIView()
            if i == 1 {
                dot.backgroundColor = UIColor(hexString: "979797")
            } else {
                dot.backgroundColor = UIColor(hexString: "F1F1F1")
            }
            dot.layer.cornerRadius = 7 / masterRatio
            dot.clipsToBounds = true
            dots.addArrangedSubview(dot)
            
            dot.snp.makeConstraints { make in
                make.width.height.equalTo(14 / masterRatio)
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setUserProfileAvatar("", name: "Goa", lastName: "Tzee")
        username = "kolyarut"
        level = 3
        scoreToNextLevel = 220
        reputation = 2050
        reviews = 100
    }
    
    // MARK: Pages Configuration
    
    
    // Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    fileprivate let identifiers = ["level", "reputation", "reviews"]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifiers[indexPath.row], for: indexPath)
        
        switch indexPath.row {
        case 0:
            // Level
            let levelMessage = cell as! GRBaloonLevelMessage
            levelMessage.level = level
            levelMessage.scoreToNextLevel = scoreToNextLevel
            levelMessage.setUserProfileAvatar(pictureUrl, name: userFirstName, lastName: userLastName)
            levelMessage.onUserImageTap = onUserImageTap
        case 1:
            // Reputation
            let reputationMessage = cell as! GRBaloonReputationMessage
            reputationMessage.level = level
            reputationMessage.reputation = reputation
        case 2:
            // Reviews
            let reviewsMessage = cell as! GRBaloonReviewsMessage
            reviewsMessage.reviews = reviews
            reviewsMessage.username = username
        default:
            fatalError("There must be only 3 cells in the HomeBaloon")
        }
        
        return cell
    }

    // Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    // Page dots
    
    fileprivate func updateDots(activeDotIndex index: Int) {
        // Updates the dots
        for (i, dot) in dots.arrangedSubviews.enumerated() {
            if i == index {
                // Current page
                dot.backgroundColor = UIColor(hexString: "979797")
            } else {
                dot.backgroundColor = UIColor(hexString: "F1F1F1")
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let contentSize = scrollView.contentSize.width
        let pageSize = contentSize / 3
        let pageNumber: Int = Int(round(contentOffset / pageSize))
        updateDots(activeDotIndex: pageNumber)
    }
    
}
