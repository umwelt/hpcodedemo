//
//  GRReviewsStatisticsCategoryTable.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 02/09/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

/**
 To be put under the categories tab in user's profile.
 */
@IBDesignable
class GRReviewsStatisticsCategoryTable: UIView {
    
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
        column.alignment = .center
        column.distribution = .fillProportionally
        addSubview(column)
        
        column.translatesAutoresizingMaskIntoConstraints = false
        column.snp.makeConstraints { make in
            make.left.top.equalTo(self)
        }
        
        // VIEW ITSELF
        
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints { make in
            make.edges.equalTo(column)
        }
    }
    
    fileprivate func addRow(category: String, reviews: Int, percentage: Int) {
        // Adds a bottom border to the previous row
        
        if let lastRow = column.arrangedSubviews.last {
            let border = UIView()
            border.backgroundColor = UIColor(hexString: "686868")
            lastRow.addSubview(border)
            
            border.translatesAutoresizingMaskIntoConstraints = false
            border.snp.makeConstraints { make in
                make.height.equalTo(1 / masterRatio)
                make.left.bottom.right.equalTo(lastRow)
            }
        }

        // Adds the new row
        
        let row = UIView()
        column.addArrangedSubview(row)
        
        row.translatesAutoresizingMaskIntoConstraints = false
        row.snp.makeConstraints { make in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(58 / masterRatio)
        }
        
        let rowNumberLabel = UILabel()
        rowNumberLabel.text = "\(column.arrangedSubviews.count)."
        rowNumberLabel.textColor = UIColor.white
        rowNumberLabel.font = UIFont.ubuntuMedium(26)
        row.addSubview(rowNumberLabel)
        
        rowNumberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(row.snp.centerY)
            make.left.equalTo(row.snp.left).offset(12 / masterRatio)
        }
        
        let categoryLabel = UILabel()
        categoryLabel.text = categoryNameFromCategorySlug(category)
        categoryLabel.textColor = colorForCategory(category)
        categoryLabel.font = UIFont.ubuntuMedium(26)
        row.addSubview(categoryLabel)
        
        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(row.snp.centerY)
            make.left.equalTo(rowNumberLabel.snp.right).offset(28 / masterRatio)
        }
        
        let percentageLabel = UILabel()
        percentageLabel.textAlignment = .right
        percentageLabel.text = "\(percentage)%"
        percentageLabel.textColor = UIColor.white
        percentageLabel.font = UIFont.ubuntuMedium(26)
        row.addSubview(percentageLabel)
        
        percentageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(row.snp.centerY)
            make.right.equalTo(row.snp.right).offset(-2 / masterRatio)
        }
        
        let reviewsLabel = UILabel()
        reviewsLabel.textAlignment = .center
        reviewsLabel.text = "\(reviews)"
        reviewsLabel.textColor = UIColor.white
        reviewsLabel.font = UIFont.avenirBook(26)
        row.addSubview(reviewsLabel)
        
        reviewsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(row.snp.centerY)
            make.right.equalTo(row.snp.right).offset(-150 / masterRatio)
        }
        
    }
    
    /**
     Populates the table widget using the JSON response from
     the statistics web API.
     */
    func populateWith(_ data: [JSON]) {
        // Empties the widget
        for row in column.arrangedSubviews {
            // Removes the row
            row.removeFromSuperview()
            column.removeArrangedSubview(row)
        }
        
        for categoryData in data {
            addRow(
                category: categoryData["category"].stringValue,
                reviews: categoryData["count"].intValue,
                percentage: categoryData["percent"].intValue
            )
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
            ]
        ]).arrayValue
        self.populateWith(data)
    }
    
}
