//
//  GRReviewsListView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 15/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRReviewsListView: UIView {
    
    let navigationToolBar: GRToolbar = GRToolbar()
    
    let labelView = UIView()
    
    var productTitle: String = "" { didSet { titleLabel.text = productTitle } }
    var productBrand: String = "" { didSet { brandLabel.text = productBrand } }
    var numberOfReviews: Int = 0 {
        didSet {
            if numberOfReviews < 0 {
                // Cannot set a negative number of reviews
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                                                                         action: "ReviewsListView: negative numberOfReviews",
                                                                         label: "\(productTitle)",
                                                                         value: nil
                )
                tracker?.send(event?.build() as [NSObject : AnyObject]?)
                numberOfReviews = 0
                return
            }
            let s = numberOfReviews == 1 ? "commento scritto" : "commenti scritti"
            reviewsCounter.text = "\(numberOfReviews) \(s)"
        }
    }
    
    let titleLabel = UILabel()
    let brandLabel = UILabel()
    let reviewsCounter = UILabel()
    let reviewsTable = UITableView()
    
    convenience init() {
        self.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }
    
    private func setupHierarchy() {
        backgroundColor = UIColor.white
        
        addSubview(navigationToolBar)
        navigationToolBar.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.left.equalTo(0)
        }
        
        titleLabel.font = Constants.BrandFonts.ubuntuMedium16
        titleLabel.textColor = UIColor.grocerestDarkBoldGray()
        titleLabel.numberOfLines = 2
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationToolBar.snp.bottom).offset(21 / masterRatio)
            make.left.equalTo(self).offset(32 / masterRatio)
            make.right.equalTo(self).offset(-32 / masterRatio)
        }
        
        brandLabel.font = Constants.BrandFonts.avenirBook11
        brandLabel.textColor = UIColor.grocerestLightGrayColor()
        addSubview(brandLabel)
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8 / masterRatio)
            make.left.equalTo(self).offset(32 / masterRatio)
            make.right.equalTo(self).offset(-32 / masterRatio)
        }
        
        let counterContainer = UIView()
        addSubview(counterContainer)
        counterContainer.backgroundColor = UIColor.F1F1F1Color()
        addSubview(counterContainer)
        counterContainer.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(23 / masterRatio)
            make.left.right.equalTo(self)
            make.height.equalTo(63 / masterRatio)
        }
        
//        labelView.frame = CGRectMake(10, 0, 486 / masterRatio, 60 / masterRatio)
//        labelView.backgroundColor = UIColor.F1F1F1Color()
//        
        reviewsCounter.font = Constants.BrandFonts.avenirBook11
        reviewsCounter.textColor = UIColor.grocerestLightGrayColor()
        counterContainer.addSubview(reviewsCounter)
        reviewsCounter.snp.makeConstraints { make in
            make.centerY.equalTo(counterContainer)
            make.left.equalTo(counterContainer).offset(32 / masterRatio)
        }
 
        
        
        reviewsTable.rowHeight = 234 / masterRatio
        reviewsTable.allowsSelection = false
        reviewsTable.separatorColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        reviewsTable.tableFooterView = UIView()
        addSubview(reviewsTable)
        reviewsTable.snp.makeConstraints { make in
            make.top.equalTo(counterContainer.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
    }
    
}
