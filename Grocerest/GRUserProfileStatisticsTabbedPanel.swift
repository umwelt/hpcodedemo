//
//  UserProfileStatisticsTabbedPanel.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/09/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

@IBDesignable
class GRUserProfileStatisticsTabbedPanel: UIView {
    
    fileprivate let activitiesLabel = UILabel()
    fileprivate let categoriesLabel = UILabel()
    fileprivate let badgesLabel = UILabel()
    
    fileprivate let activitiesTab = GRActivitiesTab()
    fileprivate let categoriesTab = GRCategoriesTab()
    fileprivate let badgesTab = GRBadgesTab()
    
    required init?(coder: NSCoder) { // called on Device
        super.init(coder: coder)
        setupHierarchy()
        prepareForInterfaceBuilder()
    }
    
    override init(frame: CGRect) { // called in InterfaceBuilder
        super.init(frame: frame)
        setupHierarchy()
    }
    
    fileprivate func setupHierarchy() {
        // BUTTONS
        
        let activityGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.activitiesButtonTapped))
        let categoriesGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.categoriesButtonTapped))
        let badgesGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.badgesButtonTapped))
        
        activitiesLabel.isUserInteractionEnabled = true
        activitiesLabel.addGestureRecognizer(activityGestureRecognizer)
        activitiesLabel.backgroundColor = UIColor.white
        activitiesLabel.textAlignment = .center
        activitiesLabel.font = UIFont.avenirHeavy(22)
        activitiesLabel.textColor = UIColor(hexString: "4A4A4A")
        activitiesLabel.text = "ATTIVITÀ"
        
        categoriesLabel.isUserInteractionEnabled = true
        categoriesLabel.addGestureRecognizer(categoriesGestureRecognizer)
        categoriesLabel.backgroundColor = UIColor.white
        categoriesLabel.textAlignment = .center
        categoriesLabel.font = UIFont.avenirHeavy(22)
        categoriesLabel.textColor = UIColor(hexString: "BDBDBD")
        categoriesLabel.text = "CATEGORIE"
        
        badgesLabel.isUserInteractionEnabled = true
        badgesLabel.addGestureRecognizer(badgesGestureRecognizer)
        badgesLabel.backgroundColor = UIColor.white
        badgesLabel.textAlignment = .center
        badgesLabel.font = UIFont.avenirHeavy(22)
        badgesLabel.textColor = UIColor(hexString: "BDBDBD")
        badgesLabel.text = "BADGE"
        
        let tabButtonsBackground = UIView()
        tabButtonsBackground.backgroundColor = UIColor(hexString: "BDBDBD")
        addSubview(tabButtonsBackground)
        
        let tabButtons = UIStackView()
        tabButtons.distribution = .fillEqually
        tabButtons.spacing = 1 / masterRatio
        tabButtons.addArrangedSubview(activitiesLabel)
        tabButtons.addArrangedSubview(categoriesLabel)
        tabButtons.addArrangedSubview(badgesLabel)
        addSubview(tabButtons)
        
        tabButtons.translatesAutoresizingMaskIntoConstraints = false
        tabButtons.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(64 / masterRatio)
        }
        
        tabButtonsBackground.translatesAutoresizingMaskIntoConstraints = false
        tabButtonsBackground.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(tabButtons)
        }
        
        // TABS
        
        let tabs = UIStackView()
        tabs.distribution = .fill
        tabs.alignment = .center
        addSubview(tabs)
        
        tabs.translatesAutoresizingMaskIntoConstraints = false
        tabs.snp.makeConstraints { make in
            make.top.equalTo(tabButtons.snp.bottom)
            make.left.right.equalTo(self)
        }
        
        tabs.addArrangedSubview(activitiesTab)
        tabs.addArrangedSubview(categoriesTab)
        tabs.addArrangedSubview(badgesTab)
        
        categoriesTab.isHidden = true
        badgesTab.isHidden = true
        
        // VIEW ITSELF
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints { make in
            make.bottom.equalTo(tabs.snp.bottom).offset(80 / masterRatio)
            make.width.greaterThanOrEqualTo(tabButtons.snp.width)
        }
    }
    
    func activitiesButtonTapped() {
        if activitiesTab.isHidden {
            activitiesTab.replayVoteDistributionAnimation()
        }
        activitiesLabel.textColor = UIColor(hexString: "4A4A4A")
        categoriesLabel.textColor = UIColor(hexString: "BDBDBD")
        badgesLabel.textColor = UIColor(hexString: "BDBDBD")
        activitiesTab.isHidden = false
        categoriesTab.isHidden = true
        badgesTab.isHidden = true
    }
    
    func categoriesButtonTapped() {
        activitiesLabel.textColor = UIColor(hexString: "BDBDBD")
        categoriesLabel.textColor = UIColor(hexString: "4A4A4A")
        badgesLabel.textColor = UIColor(hexString: "BDBDBD")
        activitiesTab.isHidden = true
        categoriesTab.isHidden = false
        badgesTab.isHidden = true
    }
    
    func badgesButtonTapped() {
        activitiesLabel.textColor = UIColor(hexString: "BDBDBD")
        categoriesLabel.textColor = UIColor(hexString: "BDBDBD")
        badgesLabel.textColor = UIColor(hexString: "4A4A4A")
        activitiesTab.isHidden = true
        categoriesTab.isHidden = true
        badgesTab.isHidden = false
    }
    
    /**
     Populates the widget and its subviews with JSON data from Grocerest
     API user's statistics.
     */
    func populateWith(_ data: JSON) {
        // quickly populate first tab
        activitiesTab.populateWith(data)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { // Or 0.1 seconds
            // and populate the rest after scroll
            self.categoriesTab.populateWith(data)
            self.badgesTab.populateWith(data)
        }
    }
    
    let exampleData: [String: Any] = [
        "categories" : [
            [
                "category" : "Alimentari",
                "levels" : [0,50,100,200],
                "order" : 1,
                "count" : 4,
                "level" : 1,
                "levelProgress" : 8,
                "percent" : 100
            ],
            [
                "category" : "Bevande",
                "levels" : [0,50,100,200],
                "order" : 2,
                "count" : 0,
                "level" : 1,
                "levelProgress" : 0,
                "percent" : 0
            ],
            [
                "category" : "Cura-della-Persona",
                "levels" : [0,50,100,200],
                "order" : 3,
                "count" : 0,
                "level" : 1,
                "levelProgress" : 0,
                "percent" : 0
            ],
            [
                "category" : "Prodotti-per-la-Casa",
                "levels" : [0,50,100,200],
                "order" : 4,
                "count" : 0,
                "level" : 1,
                "levelProgress" : 0,
                "percent" : 0
            ],
            [
                "category" : "Infanzia",
                "levels" : [0,50,100,200],
                "order" : 5,
                "count" : 0,
                "level" : 1,
                "levelProgress" : 0,
                "percent" : 0
            ],
            [
                "category" : "Integratori",
                "levels" : [0,50,100,200],
                "order" : 6,
                "count" : 0,
                "level" : 1,
                "levelProgress" : 0,
                "percent" : 0
            ],
            [
                "category" : "Animali",
                "levels" : [0,50,100,200],
                "order" : 7,
                "count" : 0,
                "level" : 1,
                "levelProgress" : 0,
                "percent" : 0
            ],
            [
                "category" : "Libri",
                "levels" : [0,50,100,200],
                "order" : 8,
                "count" : 0,
                "level" : 1,
                "levelProgress" : 0,
                "percent" : 0
            ]
        ],
        "productProposals" : 0,
        "activities" : [
            [
                "levelProgress" : 4,
                "order" : 1,
                "levels" : [0,100,200,500],
                "name" : "Reviews",
                "count" : 4,
                "level" : 1
            ],
            [
                "levelProgress" : 40,
                "order" : 2,
                "levels" : [0,10,20,50],
                "name" : "First-Reviews",
                "count" : 4,
                "level" : 1
            ],
            [
                "levelProgress" : 6,
                "order" : 3,
                "levels" : [0,50,100,200],
                "name" : "Reviews-Text",
                "count" : 3,
                "level" : 1
            ],
            [
                "levels" : [0,50,100,200],
                "order" : 4,
                "count" : 0,
                "level" : 1,
                "levelProgress" : 0,
                "private" : true,
                "name" : "Scanned"
            ],
            [
                "levelProgress" : 0,
                "order" : 5,
                "levels" : [0,10,50,100],
                "name" : "Product-Proposals",
                "count" : 0,
                "level" : 1
            ],
            [
                "levelProgress" : 0,
                "order" : 6,
                "levels" : [0,10,50,100],
                "name" : "Useful-Votes",
                "count" : 0,
                "level" : 1
            ],
            [
                "levels" : [0,10,20,50],
                "order" : 7,
                "count" : 0,
                "level" : 1,
                "levelProgress" : 0,
                "private" : true,
                "name" : "Friends"
            ]
        ],
        "level" : 1,
        "successfulInvitations" : 0,
        "scanned" : 0,
        "levelStart" : 0,
        "levelEnd" : 100,
        "reviewsHistogram" : [0,2,2,0,0],
        "completeReviews" : 0,
        "eanAssociations" : 0,
        "score" : 39,
        "scores" : [
            "invitations" : [
                "count" : 0,
                "score" : 0
            ],
            "proposals" : [
                "count" : 0,
                "score" : 0
            ],
            "shareLists" : [
                "count" : 0,
                "score" : 0
            ],
            "votes" : [
                "count" : 4,
                "score" : 5
            ],
            "scans" : [
                "count" : 0,
                "score" : 0
            ],
            "frequencies" : [
                "count" : 0,
                "score" : 0
            ],
            "texts" : [
                "count" : 3,
                "score" : 16
            ],
            "profile" : [
                "score" : 18,
                "registration" : 10,
                "fields" : [
                    "location" : 0,
                    "website" : 0,
                    "gender" : 0,
                    "family" : 0,
                    "profession" : 0,
                    "facebook" : 0,
                    "education" : 0,
                    "birthdate" : 3
                ]
            ],
            "registeredByInvitation" : [
                "count" : 0,
                "score" : 0
            ],
            "successfulInvitations" : [
                "count" : 0,
                "score" : 0
            ]
        ],
        "reviews" : 4
    ]
    
    override func prepareForInterfaceBuilder() {
        let jsonData = JSON(exampleData)
        populateWith(jsonData)
    }
    
}
