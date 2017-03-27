//
//  GRBadgesTab.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 08/09/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRBadgesTab: UIView {
    
    fileprivate let contributionBadgeWidgetsStack = UIStackView()
    fileprivate let influenceBadgeWidgetsStack = UIStackView()
    fileprivate let categoryBadgeWidgetsStack = UIStackView()
    
    required init?(coder: NSCoder) { // called on Device
        super.init(coder: coder)
        setupHierarchy()
    }
    
    override init(frame: CGRect) { // called in InterfaceBuilder
        super.init(frame: frame)
        setupHierarchy()
    }
    
    fileprivate func setupHierarchy() {
        // CONTRIBUTION BADGES
        
        let contributionBadgesLabel = UILabel()
        contributionBadgesLabel.text = "Badge di contributo"
        contributionBadgesLabel.font = UIFont.avenirHeavy(26)
        contributionBadgesLabel.textColor = UIColor.white
        addSubview(contributionBadgesLabel)
        
        contributionBadgesLabel.translatesAutoresizingMaskIntoConstraints = false
        contributionBadgesLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(40 / masterRatio)
            make.left.equalTo(self.snp.left).offset(32 / masterRatio)
        }
        
        let contributionBadgesLineView = UIView()
        contributionBadgesLineView.backgroundColor = UIColor(hexString: "686868")
        addSubview(contributionBadgesLineView)
        
        contributionBadgesLineView.translatesAutoresizingMaskIntoConstraints = false
        contributionBadgesLineView.snp.makeConstraints { make in
            make.centerY.equalTo(contributionBadgesLabel.snp.centerY)
            make.height.equalTo(1 / masterRatio)
            make.left.equalTo(contributionBadgesLabel.snp.right).offset(13 / masterRatio)
            make.right.equalTo(self.snp.right).offset(-32 / masterRatio).priority(999)
        }
        
        contributionBadgeWidgetsStack.axis = .vertical
        contributionBadgeWidgetsStack.spacing = 32 / masterRatio
        addSubview(contributionBadgeWidgetsStack)
        contributionBadgeWidgetsStack.translatesAutoresizingMaskIntoConstraints = false
        contributionBadgeWidgetsStack.snp.makeConstraints { make in
            make.top.equalTo(contributionBadgesLabel.snp.bottom).offset(33 / masterRatio)
            make.centerX.equalTo(self)
        }
        
        // INFLUENCE BADGES
        
        let influenceBadgesLabel = UILabel()
        influenceBadgesLabel.text = "Badge di influenza"
        influenceBadgesLabel.font = UIFont.avenirHeavy(26)
        influenceBadgesLabel.textColor = UIColor.white
        addSubview(influenceBadgesLabel)
        
        influenceBadgesLabel.translatesAutoresizingMaskIntoConstraints = false
        influenceBadgesLabel.snp.makeConstraints { make in
            make.top.equalTo(contributionBadgeWidgetsStack.snp.bottom).offset(50 / masterRatio)
            make.left.equalTo(self.snp.left).offset(32 / masterRatio)
        }
        
        let influenceBadgesLineView = UIView()
        influenceBadgesLineView.backgroundColor = UIColor(hexString: "686868")
        addSubview(influenceBadgesLineView)
        
        influenceBadgesLineView.translatesAutoresizingMaskIntoConstraints = false
        influenceBadgesLineView.snp.makeConstraints { make in
            make.centerY.equalTo(influenceBadgesLabel.snp.centerY)
            make.height.equalTo(1 / masterRatio)
            make.left.equalTo(influenceBadgesLabel.snp.right).offset(13 / masterRatio)
            make.right.equalTo(self.snp.right).offset(-32 / masterRatio).priority(999)
        }
        
        influenceBadgeWidgetsStack.axis = .vertical
        influenceBadgeWidgetsStack.spacing = 32 / masterRatio
        addSubview(influenceBadgeWidgetsStack)
        influenceBadgeWidgetsStack.translatesAutoresizingMaskIntoConstraints = false
        influenceBadgeWidgetsStack.snp.makeConstraints { make in
            make.top.equalTo(influenceBadgesLabel.snp.bottom).offset(33 / masterRatio)
            make.centerX.equalTo(self)
        }
        
        // CATEGORY BADGES
        
        let categoryBadgesLabel = UILabel()
        categoryBadgesLabel.text = "Badge di categoria"
        categoryBadgesLabel.font = UIFont.avenirHeavy(26)
        categoryBadgesLabel.textColor = UIColor.white
        addSubview(categoryBadgesLabel)
        
        categoryBadgesLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryBadgesLabel.snp.makeConstraints { make in
            make.top.equalTo(influenceBadgeWidgetsStack.snp.bottom).offset(50 / masterRatio)
            make.left.equalTo(self.snp.left).offset(32 / masterRatio)
        }
        
        let categoryBadgesLineView = UIView()
        categoryBadgesLineView.backgroundColor = UIColor(hexString: "686868")
        addSubview(categoryBadgesLineView)
        
        categoryBadgesLineView.translatesAutoresizingMaskIntoConstraints = false
        categoryBadgesLineView.snp.makeConstraints { make in
            make.centerY.equalTo(categoryBadgesLabel.snp.centerY)
            make.height.equalTo(1 / masterRatio)
            make.left.equalTo(categoryBadgesLabel.snp.right).offset(13 / masterRatio)
            make.right.equalTo(self.snp.right).offset(-32 / masterRatio).priority(999)
        }
        
        categoryBadgeWidgetsStack.axis = .vertical
        categoryBadgeWidgetsStack.spacing = 32 / masterRatio
        addSubview(categoryBadgeWidgetsStack)
        
        categoryBadgeWidgetsStack.translatesAutoresizingMaskIntoConstraints = false
        categoryBadgeWidgetsStack.snp.makeConstraints { make in
            make.top.equalTo(categoryBadgesLabel.snp.bottom).offset(33 / masterRatio)
            make.centerX.equalTo(self)
        }
        
        // VIEW ITSELF
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints { make in
            make.bottom.equalTo(categoryBadgeWidgetsStack.snp.bottom).offset(80 / masterRatio)
        }
    }
    
    func addToContribution(_ badgeWidget: GRBadgeWidget) {
        contributionBadgeWidgetsStack.addArrangedSubview(badgeWidget)
    }
    
    func addToInfluence(_ badgeWidget: GRBadgeWidget) {
        influenceBadgeWidgetsStack.addArrangedSubview(badgeWidget)
    }
    
    func addToCategory(_ badgeWidget: GRBadgeWidget) {
        categoryBadgeWidgetsStack.addArrangedSubview(badgeWidget)
    }
    
    /**
     Populates the widget and its subviews with JSON data from Grocerest
     API user's statistics.
     */
    func populateWith(_ data: JSON) {
        // Contribution and Influence badges
        for activity in data["activities"].arrayValue {
            let badgeWidget = GRBadgeWidget()
            let level = activity["level"].intValue
            badgeWidget.level = level - 1
            let counters = (activity["levels"].arrayObject as! [Int]).dropFirst()
            badgeWidget.counters = Array(counters)
            
            let activityName = activity["name"].stringValue
            switch activityName {
            case "Reviews":
                badgeWidget.iconOn = UIImage(named: "stat-light-edit-icon")
                badgeWidget.iconOff = UIImage(named: "stat-dark-edit-icon")
                badgeWidget.title = "Recensioni"
                addToContribution(badgeWidget)
            case "First-Reviews":
                badgeWidget.iconOn = UIImage(named: "stat-light-prime icon")
                badgeWidget.iconOff = UIImage(named: "stat-dark-prime icon")
                badgeWidget.title = "Prime recensioni"
                addToContribution(badgeWidget)
            case "Reviews-Text":
                badgeWidget.iconOn = UIImage(named: "stat-light-Fill 77")
                badgeWidget.iconOff = UIImage(named: "stat-dark-Fill 77")
                badgeWidget.title = "Commenti scritti"
                addToContribution(badgeWidget)
            case "Scanned":
                badgeWidget.iconOn = UIImage(named: "stat-light-scan-icon")
                badgeWidget.iconOff = UIImage(named: "stat-dark-scan-icon")
                badgeWidget.title = "Scansioni"
                addToContribution(badgeWidget)
            case "Product-Proposals":
                badgeWidget.iconOn = UIImage(named: "stat-light-added-products")
                badgeWidget.iconOff = UIImage(named: "stat-dark-added-products")
                badgeWidget.title = "Prodotti aggiunti"
                addToContribution(badgeWidget)
            case "Useful-Votes":
                badgeWidget.iconOn = UIImage(named: "stat-light-Group 8")
                badgeWidget.iconOff = UIImage(named: "stat-dark-Group 8")
                badgeWidget.title = "Voti utili"
                addToInfluence(badgeWidget)
            case "Friends":
                badgeWidget.iconOn = UIImage(named: "stat-light-people icon")
                badgeWidget.iconOff = UIImage(named: "stat-dark-people icon")
                badgeWidget.title = "Amici iscritti su invito"
                addToInfluence(badgeWidget)
            default:
                print("WARNING: unexpected activity in GRBadgesTab")
            }
        }
        
        // Category badges
        for category in data["categories"].arrayValue {
            let badgeWidget = GRBadgeWidget()
            let categoryName = category["category"].stringValue
            badgeWidget.iconOn = UIImage(named: "stat-light-icon-\(categoryName)")
            badgeWidget.iconOff = UIImage(named: "stat-dark-icon-\(categoryName)")
            badgeWidget.backgrounds = [
                UIImage(named: "badge-background-\(categoryName)-junior"),
                UIImage(named: "badge-background-\(categoryName)-senior"),
                UIImage(named: "badge-background-\(categoryName)-top")
            ]
            badgeWidget.title = categoryNameFromCategorySlug(categoryName)
            let level = category["level"].intValue
            badgeWidget.level = level - 1
            let counters = (category["levels"].arrayObject as! [Int]).dropFirst()
            badgeWidget.counters = Array(counters)
            addToCategory(badgeWidget)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        var widgets = [GRBadgeWidget]()
        for _ in 1...9 { widgets.append(GRBadgeWidget()) }
        for widget in widgets { widget.prepareForInterfaceBuilder() }
        
        widgets[0].level = 3
        widgets[0].counters = [100, 200, 500]
        addToContribution(widgets[0])
        
        widgets[1].title = "Prime recensioni"
        widgets[1].level = 0
        widgets[1].counters = [10, 20, 50]
        addToContribution(widgets[1])
        
        widgets[2].title = "Commenti scritti"
        widgets[2].level = 0
        widgets[2].counters = [50, 100, 200]
        addToContribution(widgets[2])
        
        
        widgets[3].title = "Voti utili"
        widgets[3].level = 2
        widgets[3].counters = [10, 50, 100]
        addToInfluence(widgets[3])
        
        widgets[4].title = "Amici iscritti su invito"
        widgets[4].level = 0
        widgets[4].counters = [10, 20, 50]
        addToInfluence(widgets[4])
        
        widgets[5].title = "Follower"
        widgets[5].level = 0
        widgets[5].counters = [10, 100, 1000]
        addToInfluence(widgets[5])
        
        
        widgets[6].title = "Alimentari"
        widgets[6].iconOn = UIImage(named: "stat-light-icon - alimentari")
        widgets[6].iconOff = UIImage(named: "stat-dark-icon - alimentari")
        widgets[6].backgrounds = [
            UIImage(named: "badge-background-Alimentari-junior"),
            UIImage(named: "badge-background-Alimentari-senior"),
            UIImage(named: "badge-background-Alimentari-top")
        ]
        widgets[6].level = 2
        widgets[6].counters = [50, 100, 200]
        addToCategory(widgets[6])
        
        widgets[7].title = "Bevande"
        widgets[7].level = 0
        widgets[7].counters = [50, 100, 200]
        addToCategory(widgets[7])
        
        widgets[8].title = "Prodotti per la casa"
        widgets[8].level = 0
        widgets[8].counters = [50, 100, 200]
        addToCategory(widgets[8])
    }
}

