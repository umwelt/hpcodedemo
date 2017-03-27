//
//  GRGenericPersonTableViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 18/03/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRGenericPersonTableViewCell: UITableViewCell {
    
    var userMainLabel : UILabel?
    var userSecondaryLabel : UILabel?
    var selectionCellView = UIImageView()
    var checked = false
    let iconSize = CGSize(width: 64 / masterRatio, height: 64 / masterRatio)
    
    
    
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
        
        userMainLabel = UILabel()
        contentView.addSubview(userMainLabel!)
        userMainLabel?.lineBreakMode = .byWordWrapping
        userMainLabel?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(450 / masterRatio)
            make.left.equalTo(28 / masterRatio)
            make.centerY.equalTo(contentView.snp.centerY)
        })
        userMainLabel?.textAlignment = .left
        userMainLabel?.numberOfLines = 1
        userMainLabel?.font = Constants.BrandFonts.ubuntuMedium14
        userMainLabel?.textColor = UIColor.grocerestDarkBoldGray()
        
        
        userSecondaryLabel = UILabel()
        contentView.addSubview(userSecondaryLabel!)
        userSecondaryLabel?.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(userMainLabel!.snp.left)
            make.top.equalTo(userMainLabel!.snp.bottom)
        })
        userSecondaryLabel!.textAlignment = .left
        userSecondaryLabel!.font = Constants.BrandFonts.avenirBook11
        userSecondaryLabel!.textColor = UIColor.grocerestLightGrayColor()
        
        
        
        
        selectionCellView = UIImageView()
        selectionCellView.contentMode = .scaleAspectFit
        selectionCellView.image = UIImage(named: "add_to_list")
        contentView.addSubview(selectionCellView)
        selectionCellView.snp.makeConstraints({ (make) -> Void in
            make.right.equalTo(contentView.snp.right).offset(-61 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(iconSize)
        })

    }
    
    
    func cellWasSelected() {
        selectionCellView.image = UIImage(named: "selected_friends_icon")
        selectionCellView.snp.remakeConstraints({ (make) -> Void in
            make.right.equalTo(contentView.snp.right).offset(-61 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(iconSize)
        })
    }
    
    func cellWasdeSelected() {
        selectionCellView.image = UIImage(named: "add_to_list")
        selectionCellView.snp.remakeConstraints({ (make) -> Void in
            make.right.equalTo(contentView.snp.right).offset(-61 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(iconSize)
        })
    }
    
    
}
