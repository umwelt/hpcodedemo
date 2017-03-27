//
//  GRSubCategoryTableViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 16/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRSubCategoryTableViewCell: UITableViewCell {
    
    var productMainLabel : UILabel?
    var productSecondaryLabel : UILabel?
    var productImageView: UIImageView?
    var selectionCellView: UIImageView?
    var checked = false
    

    
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
        
            contentView.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(self)
        }
        
        productImageView = UIImageView()
        contentView.addSubview(productImageView!)
        productImageView?.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(135 / masterRatio)
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(32 / masterRatio)
        })
        productImageView?.clipsToBounds = true
        productImageView?.contentMode = .scaleAspectFit
        
        productMainLabel = UILabel()
        contentView.addSubview(productMainLabel!)
        productMainLabel?.lineBreakMode = .byWordWrapping
        productMainLabel?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(380 / masterRatio)
            make.left.equalTo(productImageView!.snp.right).offset(28 / masterRatio)
            make.top.equalTo(30 / masterRatio)
        })
        productMainLabel?.textAlignment = .left
        productMainLabel?.numberOfLines = 2
        productMainLabel?.font = Constants.BrandFonts.ubuntuMedium16
        productMainLabel?.textColor = UIColor.grocerestDarkBoldGray()
        
        
        productSecondaryLabel = UILabel()
        contentView.addSubview(productSecondaryLabel!)
        productSecondaryLabel?.snp.makeConstraints({ (make) -> Void in
            make.height.equalTo(36 / masterRatio)
            make.left.equalTo(productMainLabel!.snp.left)
            make.top.equalTo(productMainLabel!.snp.bottom).offset(11 / masterRatio)
        })
        productSecondaryLabel!.textAlignment = .left
        productSecondaryLabel!.font = Constants.BrandFonts.avenirBook11
        productSecondaryLabel!.textColor = UIColor.white
        
    
        
        
    }
}

