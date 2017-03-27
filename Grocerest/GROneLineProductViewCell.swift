//
//  GROneLineProductViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 26/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GROneLineProductViewCell: UITableViewCell {
    
    var viewsByName: [String: UIView]!
    var cellProductLabel: UILabel?
    var disclosureImage : UIButton?
    var productImage : UIImageView?
    var counterLabel : UILabel?
    var brandLabel : UILabel?
    var backView : UIView?
    var categoryLabel: UILabel?
    
    var smallVoteView: GRMiniVoteView?
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 77.5))
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
        backgroundColor = UIColor(hexString: "#F1F1F1")

        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        
        backView = UIView()
        contentView.addSubview(backView!)
        backView!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(90)
            make.centerY.equalTo(contentView.snp.centerY)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        backView!.backgroundColor = UIColor.white
        backView!.layer.cornerRadius = 10
        backView!.layer.borderColor = UIColor.white.cgColor
        backView!.layer.borderWidth = 0.8
        
        productImage = UIImageView()
        backView!.addSubview(productImage!)
        productImage?.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(55)
            make.left.equalTo(20)
            make.centerY.equalTo(contentView.snp.centerY)
        })
        productImage?.contentMode = .scaleAspectFit
        productImage?.backgroundColor = .white
        
        brandLabel = UILabel()
        backView!.addSubview(brandLabel!)
        brandLabel!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(269 / masterRatio)
            make.height.equalTo(30 / masterRatio)
            make.top.equalTo(productImage!.snp.bottom).offset(5 / masterRatio)
            make.left.equalTo((productImage?.snp.right)!).offset(30 / masterRatio)
        }
        brandLabel!.textAlignment = .left
        brandLabel!.textColor = UIColor.grocerestLightGrayColor()
        brandLabel!.font = Constants.BrandFonts.avenirBook11
        
        
        cellProductLabel = UILabel()
        backView!.addSubview(cellProductLabel!)
        
        cellProductLabel!.textColor = UIColor.grocerestDarkBoldGray()
        cellProductLabel!.font = Constants.BrandFonts.avenirRoman13
        cellProductLabel?.numberOfLines = 2
        
        cellProductLabel?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(400 / masterRatio)
            make.left.equalTo((productImage?.snp.right)!).offset(30 / masterRatio)
            make.height.equalTo(80)
            make.centerY.equalTo(backView!.snp.centerY)
        })
        
        
        
        categoryLabel = UILabel()
        backView?.addSubview(categoryLabel!)
        categoryLabel?.snp.makeConstraints({ (make) -> Void in
            make.height.equalTo(30)
            make.left.equalTo((cellProductLabel?.snp.left)!)
            make.top.equalTo((cellProductLabel?.snp.bottom)!).offset(6)
        })
        categoryLabel?.font = Constants.BrandFonts.avenirMedium11
        categoryLabel?.textColor = UIColor.white
       // categoryLabel?.textAlignment = .Center
        categoryLabel?.layer.cornerRadius = 16 / masterRatio
    }
    
    func setSelectedBackgroundColorForCell(){
        backView?.backgroundColor = UIColor.white
        self.backView!.layer.borderColor = UIColor.grocerestColor().cgColor
    }
    
    func removeSelectedBackgroundColorForCell(){
        backView?.backgroundColor = UIColor.white
        self.backView!.layer.borderColor = UIColor.white.cgColor
    }
        
    func trasparentLayerInCategoryLabel(){
        categoryLabel?.layer.backgroundColor = UIColor.clear.cgColor
        categoryLabel?.text = ""
    }
    
    
    func formatLocalGenericCell(){
        
       // trasparentLayerInCategoryLabel()
        
        categoryLabel?.isHidden = true
        brandLabel?.isHidden = true
        contentView.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(50)
            make.center.equalTo(self.snp.center)
        })
        
        backView?.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(45)
            make.centerY.equalTo(contentView.snp.centerY)
            make.centerX.equalTo(contentView.snp.centerX)
        })
        
        productImage?.snp.remakeConstraints({ (make) -> Void in
            make.width.height.equalTo(35)
            make.left.equalTo(15)
            make.centerY.equalTo(contentView.snp.centerY)
        })
        
        cellProductLabel?.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(380 / masterRatio)
            make.left.equalTo((productImage?.snp.right)!).offset(30 / masterRatio)
            make.height.equalTo(30)
            make.centerY.equalTo(backView!.snp.centerY)
        })
        
    }
    
    func formatLocalCommercialCell() {
        
        brandLabel?.isHidden = false
        categoryLabel?.isHidden = false
        categoryLabel?.layer.borderWidth = 1
        
        contentView.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(100)
            make.center.equalTo(self.snp.center)
        })
        
        backView?.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(90)
            make.centerY.equalTo(contentView.snp.centerY)
            make.centerX.equalTo(contentView.snp.centerX)
        })
        
        cellProductLabel?.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(450 / masterRatio)
            make.left.equalTo((productImage?.snp.right)!).offset(30 / masterRatio)
            make.centerY.equalTo(productImage!.snp.centerY)
        })
        
        brandLabel!.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(450 / masterRatio)
            make.bottom.equalTo(cellProductLabel!.snp.top)
            make.left.equalTo(cellProductLabel!.snp.left)
        }
        
        categoryLabel?.snp.remakeConstraints({ (make) -> Void in
            make.height.equalTo(36 / masterRatio)
            make.top.equalTo((cellProductLabel?.snp.bottom)!)
            make.left.equalTo((cellProductLabel?.snp.left)!)
        })
   
    }
    
    func fixPositionForImageOnLocalCommmercialCell(_ leftDistance: CGFloat) {
        
        productImage?.snp.remakeConstraints({ (make) -> Void in
            make.width.height.equalTo(55)
            make.left.equalTo(leftDistance)
            make.centerY.equalTo(contentView.snp.centerY)
        })
        
    }
    
    func formatGrocerestGenericCell() {
        
        categoryLabel?.isHidden = true
        brandLabel?.isHidden = true
        trasparentLayerInCategoryLabel()
        
        contentView.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(50)
            make.center.equalTo(self.snp.center)
        })
        
        backView?.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(45)
            make.centerY.equalTo(contentView.snp.centerY)
            make.centerX.equalTo(contentView.snp.centerX)
        })
        
        productImage?.snp.remakeConstraints({ (make) -> Void in
            make.width.height.equalTo(35)
            make.left.equalTo(20)
            make.centerY.equalTo(contentView.snp.centerY)
        })
        
        cellProductLabel?.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(380 / masterRatio)
            make.left.equalTo((productImage?.snp.right)!).offset(30 / masterRatio)
            make.height.equalTo(30)
            make.centerY.equalTo(backView!.snp.centerY)
        })
        
    }
    
    func formatGrocerestCommercialCell() {
        
        brandLabel?.isHidden = false
        categoryLabel?.isHidden = false
        
        contentView.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(100)
            make.center.equalTo(self.snp.center)
        })
        
        backView?.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(90)
            make.centerY.equalTo(contentView.snp.centerY)
            make.centerX.equalTo(contentView.snp.centerX)
        })
        
        productImage?.snp.remakeConstraints({ (make) -> Void in
            make.width.height.equalTo(55)
            make.left.equalTo(20)
            make.centerY.equalTo(contentView.snp.centerY)
        })
        
        cellProductLabel?.snp.remakeConstraints({ (make) -> Void in
            make.width.equalTo(450 / masterRatio)
            make.left.equalTo((productImage?.snp.right)!).offset(30 / masterRatio)
            make.centerY.equalTo(productImage!.snp.centerY)
        })
        
        brandLabel!.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(450 / masterRatio)
            make.bottom.equalTo(cellProductLabel!.snp.top)
            make.left.equalTo((productImage?.snp.right)!).offset(30 / masterRatio)
        }
        
        categoryLabel?.snp.remakeConstraints({ (make) -> Void in
            make.height.equalTo(31 / masterRatio)
            make.top.equalTo((cellProductLabel?.snp.bottom)!).offset(4)
            make.left.equalTo((cellProductLabel?.snp.left)!)
        })

        
    }
    
    
}
