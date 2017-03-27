//
//  GRUserStatsView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 21/04/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRUserStatsView: UIView {
    
    
    var iconImage = UIImageView()
    var percentageLabel = UILabel()
    var counterLabel = UILabel()

    
    let iconSize = CGSize(width: 110 / masterRatio, height: 110 / masterRatio)
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 110 / masterRatio, height: 184 / masterRatio))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }
    

    
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupHierarchy() {
        
        addSubview(iconImage)
        iconImage.snp.makeConstraints { (make) in
            make.size.equalTo(iconSize)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(0)
        }
        iconImage.contentMode = .center
        iconImage.image = UIImage(named: "icon-libri")
        
        
        addSubview(percentageLabel)
        percentageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImage.snp.bottom).offset(4 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        percentageLabel.font = Constants.BrandFonts.ubuntuMedium15
        percentageLabel.textColor = UIColor.white
        percentageLabel.text = "0%"
        
        addSubview(counterLabel)
        counterLabel.snp.makeConstraints { (make) in
            make.top.equalTo(percentageLabel.snp.bottom).offset(4 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        counterLabel.font = Constants.BrandFonts.avenirBook11
        counterLabel.textColor = UIColor.grayText()
        counterLabel.text = "0/0"
        
        iconImage.layer.borderWidth = 1
        iconImage.layer.borderColor = UIColor.white.cgColor
        iconImage.layer.cornerRadius = (110 / masterRatio) / 2
        iconImage.clipsToBounds = true
        
    }
    
    func setDataForLabels(_ imageName: String, percentile:String, numerator:String, denominator:String){
        iconImage.image = UIImage(named: imageName)
         percentageLabel.text = "\(percentile)%"
         counterLabel.text = "\(numerator)/\(denominator)"
    }
    
}


