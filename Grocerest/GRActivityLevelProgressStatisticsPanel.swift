//
//  GRActivityLevelProgressStatisticsPanel.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 25/08/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

/**
    To be put under the activities tab in user's profile.
 */
@IBDesignable
class GRActivityLevelProgressStatisticsPanel: UIView {
    
    fileprivate let column = UIStackView()
    
    required init?(coder: NSCoder) { // called on Device
        super.init(coder: coder)
        setupHierarchy()
    }
    
    override init(frame: CGRect) { // called in InterfaceBuilder
        super.init(frame: frame)
        setupHierarchy()
    }
    
    func setupHierarchy() {
        // COLUMN
        
        column.axis = .vertical
        column.spacing = 64 / masterRatio
        addSubview(column)
        
        column.translatesAutoresizingMaskIntoConstraints = false
        column.snp.makeConstraints { make in
            make.top.centerX.equalTo(self)
        }
        
        // PANEL ITSELF
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints { make in
            make.width.height.equalTo(column)
        }
    }
    
    fileprivate func createRow() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.spacing = 46 / masterRatio
        column.addArrangedSubview(stackView)
        return stackView
    }
    
    fileprivate func createStatProgress(data: JSON) -> GRStatProgress {
        let view = GRStatProgress()
        
        let activityName = data["name"].stringValue
        if activityName == "Reviews" {
            view.name = "recensioni"
            view.statIcon = UIImage(named: "stat-light-edit-icon")
        } else if activityName == "First-Reviews" {
            view.name = "prime recensioni"
            view.statIcon = UIImage(named: "stat-light-prime icon")
        } else if activityName == "Reviews-Text" {
            view.name = "commenti scritti"
            view.statIcon = UIImage(named: "stat-light-Fill 77")
        } else if activityName == "Scanned" {
            view.name = "scansioni"
            view.statIcon = UIImage(named: "stat-light-scan-icon")
        } else if activityName == "Product-Proposals" {
            view.name = "prodotti aggiunti"
            view.statIcon = UIImage(named: "stat-light-added-products")
        } else if activityName == "Useful-Votes" {
            view.name = "voti utili"
            view.statIcon = UIImage(named: "stat-light-Group 8")
        } else if activityName == "Friends" {
            view.name = "amici iscritti"
            view.statIcon = UIImage(named: "stat-light-Group 3")
        }
        
        view.progress = data["levelProgress"].intValue
        let level = data["level"].intValue
        view.level = level - 1
        view.currentScore = data["count"].intValue
        if level < 4 {
            view.totalScore = data["levels"][level].intValue
        } else {
            view.totalScore = data["levels"][3].intValue
        }
        return view
    }
    
    fileprivate func createPlaceHolder() -> GRStatProgress {
        let placeHolder = GRStatProgress()
        placeHolder.alpha = 0
        return placeHolder
    }
    
    /**
     Populates all the StatProgress widgets using the JSON response from
     the statistics web API.
     */
    func populateWith(_ data: [JSON]) {
        // Empties the widget
        for row in column.arrangedSubviews as! [UIStackView] {
            // Removes every StatProgress item from this row
            for view in row.arrangedSubviews {
                view.removeFromSuperview()
                row.removeArrangedSubview(view)
            }
            // Removes the row
            row.removeFromSuperview()
            column.removeArrangedSubview(row)
        }
        
        var statViews = [GRStatProgress]()
        
        for activityData in data {
            let statView = createStatProgress(data: activityData)
            statViews.append(statView)
        }
        
        // To fill the remaining spaces in the last
        // row if there are any
        while statViews.count % 3 != 0 {
            let placeHolder = createPlaceHolder()
            statViews.append(placeHolder)
        }
        
        let numberOfRows = statViews.count / 3
        for _ in 1...numberOfRows {
            let row = createRow()
            for _ in 1...3 {
                let statView = statViews.removeFirst()
                row.addArrangedSubview(statView)
            }
            column.addArrangedSubview(row)
        }
        
    }
    
    func replayAnimation () {
        for rowView in column.arrangedSubviews {
            let row = rowView as! UIStackView
            for statView in row.arrangedSubviews {
                let stat = statView as! GRStatProgress
                stat.replayAnimation()
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        let data = JSON([
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
            ]
        ]).arrayValue
        self.populateWith(data)
    }
    
}
