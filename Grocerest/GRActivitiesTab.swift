//
//  GRActivitiesTab.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 07/09/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

@IBDesignable
class GRActivitiesTab: UIView {
    
    fileprivate let scoreDistributionDiagram = GRScoreDistributionView()
    fileprivate let activitiesLevelProgressPanel = GRActivityLevelProgressStatisticsPanel()
    
    required init?(coder: NSCoder) { // called on Device
        super.init(coder: coder)
        setupHierarchy()
    }
    
    override init(frame: CGRect) { // called in InterfaceBuilder
        super.init(frame: frame)
        setupHierarchy()
    }
    
    func setupHierarchy() {
        // VOTES DISTRIBUTION
        
        let votesDistributionLabel = UILabel()
        votesDistributionLabel.text = "Distribuzione voto"
        votesDistributionLabel.font = UIFont.avenirBook(22)
        votesDistributionLabel.textColor = UIColor(hexString: "979797")
        addSubview(votesDistributionLabel)
        
        votesDistributionLabel.translatesAutoresizingMaskIntoConstraints = false
        votesDistributionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(40 / masterRatio)
            make.left.equalTo(self.snp.left).offset(32 / masterRatio)
        }
        
        scoreDistributionDiagram.labelsFont = UIFont.avenirRoman(26)
        scoreDistributionDiagram.labelsColor = UIColor.white
        scoreDistributionDiagram.countersFont = UIFont.ubuntuBold(28)
        scoreDistributionDiagram.countersColor = UIColor.white
        scoreDistributionDiagram.barsSpacing = 16 / masterRatio
        scoreDistributionDiagram.barsColor = UIColor(hexString: "E53453")
        scoreDistributionDiagram.barsBackgroundColor = UIColor(hexString: "686868")
        addSubview(scoreDistributionDiagram)
        
        scoreDistributionDiagram.translatesAutoresizingMaskIntoConstraints = false
        scoreDistributionDiagram.snp.makeConstraints { make in
            make.top.equalTo(votesDistributionLabel.snp.bottom).offset(32 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        // LEVELS PROGRESS
        
        let levelsProgressLabel = UILabel()
        levelsProgressLabel.text = "Progresso Livelli"
        levelsProgressLabel.font = UIFont.avenirBook(22)
        levelsProgressLabel.textColor = UIColor(hexString: "979797")
        addSubview(levelsProgressLabel)
        
        levelsProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        levelsProgressLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreDistributionDiagram.snp.bottom).offset(60 / masterRatio)
            make.left.equalTo(self.snp.left).offset(32 / masterRatio)
        }
        
        addSubview(activitiesLevelProgressPanel)
        activitiesLevelProgressPanel.translatesAutoresizingMaskIntoConstraints = false
        activitiesLevelProgressPanel.snp.makeConstraints { make in
            make.top.equalTo(levelsProgressLabel.snp.bottom).offset(32 / masterRatio)
            make.centerX.equalTo(self)
        }
        
        // VIEW ITSELF
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints { make in
            make.bottom.equalTo(activitiesLevelProgressPanel.snp.bottom).offset(80 / masterRatio)
            make.width.greaterThanOrEqualTo(activitiesLevelProgressPanel.snp.width)
        }
    }
    
    /**
     Populates the widget and its subviews with JSON data from Grocerest
     API user's statistics.
     */
    func populateWith(_ data: JSON) {
        let reviewsHistogram = data["reviewsHistogram"].arrayObject as! [Int]
        scoreDistributionDiagram.reviews = reviewsHistogram.reversed()
        let activities = data["activities"].arrayValue
        activitiesLevelProgressPanel.populateWith(activities)
    }
    
    override func prepareForInterfaceBuilder() {
        scoreDistributionDiagram.reviews = [34, 93, 101, 57, 4]
        activitiesLevelProgressPanel.prepareForInterfaceBuilder()
    }
    
    func replayVoteDistributionAnimation() {
        scoreDistributionDiagram.replayAnimation()
        activitiesLevelProgressPanel.replayAnimation()
    }
    
}

