//
//  GRUserNumericalStatView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 21/04/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class GRUserNumericalStatView: UIView {
    
    fileprivate var iconSize = CGSize(width: 68 / masterRatio, height: 68 / masterRatio)
    
    var statCounter = UILabel()
    var statIcon = UIImageView()
    var statLabel = UILabel()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 250 /  masterRatio, height: 69 / masterRatio))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  self.setupHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      //  self.setupHierarchy()
    }
    
    convenience init(counter:String, imageName:String, statName: String) {
        
        self.init()
        self.setupHierarchy(counter, imageName: imageName, statName:statName)
        
    }
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupHierarchy(_ counter:String, imageName:String, statName: String) {
        
        addSubview(statIcon)
        statIcon.snp.makeConstraints { (make) in
            make.size.equalTo(iconSize)
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(0)
        }
        statIcon.contentMode = .scaleAspectFit
        statIcon.image = UIImage(named: imageName)
        
        addSubview(statCounter)
        statCounter.snp.makeConstraints { (make) in
            make.left.equalTo(statIcon.snp.right).offset(14 / masterRatio)
            make.top.equalTo(0)
        }
        statCounter.font = Constants.BrandFonts.ubuntuMedium20
        statCounter.textColor = UIColor.white
        statCounter.textAlignment = .left
        statCounter.text = counter
        
        addSubview(statLabel)
        statLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statCounter.snp.bottom)
            make.left.equalTo(statCounter.snp.left)
        }
        statLabel.text = statName
        statLabel.font = Constants.BrandFonts.avenirBook11
        statLabel.textColor = UIColor.white
        statLabel.textAlignment = .left
        
        
    }
    

    
}
