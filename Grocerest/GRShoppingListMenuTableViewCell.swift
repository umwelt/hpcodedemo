//
//  GRShoppingListMenuTableViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 13/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class GRShoppingListMenuTableViewCell: UITableViewCell {
    
    
    var icon : UIImageView!
    var label: UILabel!
    

    fileprivate var iconSize = CGSize(width: 73.00 / masterRatio, height: 76.00 / masterRatio)
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120 / masterRatio))
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cell")
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
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        icon = UIImageView()
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.size.equalTo(iconSize)
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(144 / masterRatio)
        }
        
        icon.contentMode = .scaleAspectFit
        
        
        label = UILabel()
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(icon.snp.right).offset(47 / masterRatio)
        }
        label.font = Constants.BrandFonts.avenirBook15
        label.textColor = UIColor.grocerestLightGrayColor()
        label.textAlignment = .left
        
    }
    
}


extension GRShoppingListMenuTableViewCell {
    
    func setImageForCell(_ imageName: String) {
        icon.layoutIfNeeded()
        icon.image = nil
        icon.image = UIImage(named: imageName)
    }
    
    func setTextForLabel(_ title: String) {
        label.text = nil
        label.text = title
    }
    
}
