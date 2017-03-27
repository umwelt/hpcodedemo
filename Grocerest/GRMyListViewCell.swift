//
//  GRMyListViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 14/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRMyListViewCell: UITableViewCell {
    
    var viewsByName: [String: UIView]!
    var listCellImageView : UIImageView?
    var badgeIcon : UIImageView?
    var badgeLabel : UILabel?
    var rightContainer : UIView?
    var titleLabel : UILabel?
    var detailLabel : UILabel?
    var completedImageView: UIImageView?
    
    
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
        

        
        if let scalingView = self.viewsByName["__scaling__"] {
            var xScale = self.bounds.size.width / scalingView.bounds.size.width
            var yScale = self.bounds.size.height / scalingView.bounds.size.height
            switch contentMode {
            case .scaleToFill:
                break
            case .scaleAspectFill:
                let scale = max(xScale, yScale)
                xScale = scale
                yScale = scale
            default:
                let scale = min(xScale, yScale)
                xScale = scale
                yScale = scale
            }
            scalingView.transform = CGAffineTransform(scaleX: xScale, y: yScale)
            scalingView.center = CGPoint(x:self.bounds.midX, y:self.bounds.midY)
        }
    }
    
    func setupHierarchy() {
        
        self.backgroundColor = UIColor.clear
        
        var viewsByName: [String: UIView] = [:]
        let __scaling__ = UIView()
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(0)
            make.width.equalTo(self)
            make.height.equalTo(Constants.UISizes.grocerestStandardHeightCell)
        }
        
        
        __scaling__.backgroundColor = UIColor.white
        viewsByName["__scaling__"] = __scaling__
        
        listCellImageView = UIImageView()
        __scaling__.addSubview(listCellImageView!)
        listCellImageView!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.listIconSize)
            make.left.equalTo(self.snp.left).offset(34/2)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        
        
        badgeLabel = UILabel()
        __scaling__.addSubview(badgeLabel!)
        badgeLabel?.snp.makeConstraints({ (make) -> Void in
            make.size.equalTo(Constants.UISizes.badgeIcon)
            make.top.equalTo(30 / masterRatio)
            make.right.equalTo(-21 / masterRatio)
        })
        //badgeLabel?.baselineAdjustment = .AlignBaselines
        badgeLabel?.backgroundColor = UIColor.red
        badgeLabel?.textColor = UIColor.white
        badgeLabel?.textAlignment = .center
        badgeLabel?.text = "0"
        badgeLabel?.font = Constants.BrandFonts.avenirHeavy10
        badgeLabel?.layer.cornerRadius = 7.5
        badgeLabel?.layer.masksToBounds = true
        
        
        badgeIcon = UIImageView()
        __scaling__.addSubview(badgeIcon!)
        badgeIcon?.snp.makeConstraints({ (make) in
            make.width.equalTo(23 / masterRatio)
            make.height.equalTo(21 / masterRatio)
            make.centerY.equalTo((badgeLabel?.snp.centerY)!)
            make.right.equalTo((badgeLabel?.snp.left)!).offset(-4 / masterRatio)
            
        })
        badgeIcon?.contentMode = .scaleAspectFit
        badgeIcon?.image = UIImage(named: "collaborators")
        
        
        // right container is used to vertically center titleLabel and detailLabel
        rightContainer = UIView()
        __scaling__.addSubview(rightContainer!)
        rightContainer!.snp.makeConstraints { (make) in
            make.width.equalTo(500 / masterRatio)
            make.left.equalTo(listCellImageView!.snp.right).offset(29/2)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        titleLabel = UILabel()
        rightContainer!.addSubview(titleLabel!)
        titleLabel!.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(rightContainer!)
            make.left.equalTo(rightContainer!.snp.left)
            make.top.equalTo(rightContainer!.snp.top)
        })
        titleLabel?.lineBreakMode = .byTruncatingTail
        titleLabel!.textColor = UIColor.grocerestDarkBoldGray()
        titleLabel!.font = Constants.BrandFonts.ubuntuBold14
        
        
        detailLabel = UILabel()
        rightContainer!.addSubview(detailLabel!)
        detailLabel!.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(titleLabel!.snp.bottom).offset(4)
            make.left.equalTo(titleLabel!.snp.left)
            make.height.equalTo(15)
            make.width.equalTo(rightContainer!)
        })
        detailLabel!.textColor = UIColor.grocerestLightGrayColor()
        detailLabel!.font = Constants.BrandFonts.avenirBook11
        
        rightContainer!.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel!.snp.top)
            make.bottom.equalTo(detailLabel!.snp.bottom)
        }
        
        completedImageView = UIImageView()
        __scaling__.addSubview(completedImageView!)
        completedImageView?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(38/2)
            make.height.equalTo(25/2)
            make.right.equalTo(self.snp.right).offset(-24/2)
            make.bottom.equalTo(self.snp.bottom).offset(-24/2)
        })
        
        

        
        self.viewsByName = viewsByName
    }
    
}



