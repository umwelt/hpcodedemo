//
//  GRAutocompletionTableViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 14/04/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRAutocompletionTableViewCell: UITableViewCell {
    
    var mainLabel : UILabel?
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        setupHierarchy()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHierarchy()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    func setupHierarchy() {
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        mainLabel = UILabel()
        contentView.addSubview(mainLabel!)
        mainLabel?.lineBreakMode = .byWordWrapping
        mainLabel?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(self).offset(-120 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        })
        mainLabel?.textAlignment = .left
        mainLabel?.numberOfLines = 1
        mainLabel?.lineBreakMode = .byTruncatingTail
        mainLabel?.font = Constants.BrandFonts.avenirRoman15
        mainLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        
    }
    
    
}

