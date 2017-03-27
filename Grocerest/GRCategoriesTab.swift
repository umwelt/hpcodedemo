//
//  GRCategoriesTab.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 05/09/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRCategoriesTab: UIView {
    
    fileprivate let reviewsStatisticsPieChart = GRCakeDiagram()
    fileprivate let reviewsStatistcsTable = GRReviewsStatisticsCategoryTable()
    fileprivate let reviewsByCategoryStatisticsPanel = GRCategoryLevelProgressStatisticsPanel()
    
    required init?(coder: NSCoder) { // called on Device
        super.init(coder: coder)
        setupHierarchy()
    }
    
    override init(frame: CGRect) { // called in InterfaceBuilder
        super.init(frame: frame)
        setupHierarchy()
    }
    
    func setupHierarchy() {
        // CATEGORIES INCIDENCE
        
        let categoriesIncidenceLabel = UILabel()
        categoriesIncidenceLabel.text = "Incidenza categorie"
        categoriesIncidenceLabel.font = UIFont.avenirBook(22)
        categoriesIncidenceLabel.textColor = UIColor(hexString: "979797")
        addSubview(categoriesIncidenceLabel)
        
        categoriesIncidenceLabel.translatesAutoresizingMaskIntoConstraints = false
        categoriesIncidenceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(40 / masterRatio)
            make.left.equalTo(self.snp.left).offset(32 / masterRatio)
        }
        
        reviewsStatisticsPieChart.name = "recensioni"
        addSubview(reviewsStatisticsPieChart)
        reviewsStatisticsPieChart.translatesAutoresizingMaskIntoConstraints = false
        reviewsStatisticsPieChart.snp.makeConstraints { make in
            make.top.equalTo(categoriesIncidenceLabel.snp.bottom).offset(27 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        addSubview(reviewsStatistcsTable)
        reviewsStatistcsTable.translatesAutoresizingMaskIntoConstraints = false
        reviewsStatistcsTable.snp.makeConstraints { make in
            make.top.equalTo(reviewsStatisticsPieChart.snp.bottom).offset(32 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        // CATEGORIES PROGRESS LEVEL
        
        let categoriesProgressLevelLabel = UILabel()
        categoriesProgressLevelLabel.text = "Progresso Livelli Categorie"
        categoriesProgressLevelLabel.font = UIFont.avenirBook(22)
        categoriesProgressLevelLabel.textColor = UIColor(hexString: "979797")
        addSubview(categoriesProgressLevelLabel)
        
        categoriesProgressLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        categoriesProgressLevelLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewsStatistcsTable.snp.bottom).offset(60 / masterRatio)
            make.left.equalTo(self.snp.left).offset(32 / masterRatio)
        }
        
        addSubview(reviewsByCategoryStatisticsPanel)
        reviewsByCategoryStatisticsPanel.translatesAutoresizingMaskIntoConstraints = false
        reviewsByCategoryStatisticsPanel.snp.makeConstraints { make in
            make.top.equalTo(categoriesProgressLevelLabel.snp.bottom).offset(32 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        // VIEW ITSELF
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints { make in
            make.bottom.equalTo(reviewsByCategoryStatisticsPanel.snp.bottom).offset(80 / masterRatio)
        }
    }

    /**
     Populates the widget and its subviews with JSON data from Grocerest
     API user's statistics.
     */
    func populateWith(_ data: JSON) {
        let categories = data["categories"].arrayValue
        var pieChartData: [(Int, UIColor)] = [(Int, UIColor)]()
        for category in categories {
            pieChartData.append((
                category["count"].intValue,
                colorForCategory(category["category"].stringValue)
            ))
        }
        
        reviewsStatisticsPieChart.values = pieChartData
        reviewsStatistcsTable.populateWith(categories)
        reviewsByCategoryStatisticsPanel.populateWith(categories)
    }
    
    override func prepareForInterfaceBuilder() {
        reviewsStatisticsPieChart.prepareForInterfaceBuilder()
        reviewsStatistcsTable.prepareForInterfaceBuilder()
        reviewsByCategoryStatisticsPanel.prepareForInterfaceBuilder()
    }
}

