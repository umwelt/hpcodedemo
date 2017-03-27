//
//  GRCategoryLevelProgressStatisticsPanel.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 30/08/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

/**
 To be put under the categories tab in user's profile.
 */
@IBDesignable
class GRCategoryLevelProgressStatisticsPanel: UIView {
    
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
        let category = data["category"].stringValue
        let view = GRStatProgress()
        view.statIcon = UIImage(named: "stat-light-icon-\(category)") // Categories and their icons have the same name
        let categoryColor = colorForCategory(category)
        view.dotsColor = categoryColor
        view.circleColor = categoryColor
        view.name = "recensioni"
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
        
        for categoryData in data {
            let statView = createStatProgress(data: categoryData)
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
    
    override func prepareForInterfaceBuilder() {
        let data = JSON([
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
        ]).arrayValue
        self.populateWith(data)
    }
    
}
