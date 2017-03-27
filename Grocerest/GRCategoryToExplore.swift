//
//  GRCategoryToExplore.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SnapKit

class GRCategoryToExplore: UIView {
    
    fileprivate let categoryIcon = UIImageView()
    fileprivate let categoryNameLabel = UILabel()
    fileprivate let numberOfProductsLabel = UILabel()
    fileprivate var paddedView: UIView!
    
    var categorySlug: String = "" {
        didSet {
            categoryIcon.image = UIImage(named: "stat-dark-icon-\(categorySlug)")
            categoryNameLabel.text = categoryNameFromCategorySlug(categorySlug)
            updatePaddedViewBackgroundColor()
        }
    }
    
    var numberOfProducts: Int = 0 {
        didSet {
            if numberOfProducts < 0 {
                fatalError("Number of products must be positive! Given \(numberOfProducts)")
            } else if numberOfProducts == 0 {
                numberOfProductsLabel.text = "in arrivo"
            } else {
                numberOfProductsLabel.text = "\(numberOfProducts)"
            }
            updatePaddedViewBackgroundColor()
        }
    }
    
    fileprivate func updatePaddedViewBackgroundColor() {
        if numberOfProducts == 0 {
            paddedView.backgroundColor = UIColor(hexString: "979797")
        } else {
            paddedView.backgroundColor = colorForCategory(categorySlug)
        }
    }
    
    var onTap: (() -> Void)?
    
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
        backgroundColor = UIColor.white
        clipsToBounds = true
        layer.cornerRadius = 10 / masterRatio
        translatesAutoresizingMaskIntoConstraints = false
        
        snp.makeConstraints { make in
            make.width.equalTo(284 / masterRatio)
            make.height.equalTo(320 / masterRatio)
        }
        
        let circle = UIView()
        circle.backgroundColor = UIColor(hexString: "F2F2F2")
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 82 / masterRatio
        addSubview(circle)
        
        circle.snp.makeConstraints { make in
            make.top.equalTo(self).offset(30 / masterRatio)
            make.centerX.equalTo(self)
            make.width.height.equalTo(164 / masterRatio)
        }
        
        circle.addSubview(categoryIcon)
        
        categoryIcon.snp.makeConstraints { make in
            make.center.equalTo(circle)
            make.width.height.equalTo(102 / masterRatio)
        }
        
        categoryNameLabel.font = UIFont.ubuntuMedium(24)
        categoryNameLabel.numberOfLines = 2
        addSubview(categoryNameLabel)
        
        categoryNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(circle.snp.bottom).offset(14 / masterRatio)
        }
        
        numberOfProductsLabel.font = UIFont.avenirMedium(22)
        numberOfProductsLabel.textColor = UIColor.white
        numberOfProductsLabel.textAlignment = .center
        
        paddedView = numberOfProductsLabel.withPadding(UIEdgeInsets(top: 4 / masterRatio, left: 20 / masterRatio, bottom: 4 / masterRatio, right: 20 / masterRatio))
        paddedView.clipsToBounds = true
        paddedView.layer.cornerRadius = 20 / masterRatio
        addSubview(paddedView)
        
        paddedView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(categoryNameLabel.snp.bottom).offset(20 / masterRatio)
        }
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(self.onTapped), for: .touchUpInside)
        addSubview(button)
        
        button.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func onTapped() {
        onTap?()
    }
    
    override func prepareForInterfaceBuilder() {
        categorySlug = "Alimentari"
        numberOfProducts = 1204
        var taps = 0
        onTap = {
            taps += 1
            print("Tapped \(taps) \(taps == 1 ? "time": "times")")
        }
    }
    
}
