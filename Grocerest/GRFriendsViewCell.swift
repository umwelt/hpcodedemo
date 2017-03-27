//
//  GRFriendsViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 31/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRFriendsViewCell: UITableViewCell {
    
    var viewsByName: [String: UIView]!
    var listCellImageView : UIImageView?
    var backView : UIView?
    var mainLabel : UILabel!
    var secondaryLabel: UILabel!
    
    lazy var userProfileImage : UserImage = {
        let userImage = UserImage()
        
        return userImage
    }()
    
    var selectionCellStatusImageView : UIImageView?
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 96 / masterRatio))
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
        
        guard let superview = contentView.superview else {
            return
        }
        for subview in superview.subviews {
            if String(describing: type(of: subview)).hasSuffix("SeparatorView") {
                subview.isHidden = false
                self.bringSubview(toFront: subview)
            }
        }
        
    }
    
    func setupHierarchy() {
        
      
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        
        contentView.backgroundColor = UIColor.clear
        
        backView = UIView()
        contentView.addSubview(backView!)
        backView!.backgroundColor = UIColor.clear
        backView!.layer.cornerRadius = 5
        backView!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(contentView.snp.width)
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
            make.height.equalTo(149 / masterRatio)
        }
        
        let photoSize = CGSize(width: 86 / masterRatio, height: 86 / masterRatio)
        
        backView!.addSubview(userProfileImage)
        userProfileImage.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(photoSize)
            make.left.equalTo(backView!.snp.left).offset(28 / masterRatio)
            make.centerY.equalTo(backView!.snp.centerY)
        }

        
        mainLabel = UILabel()
        backView!.addSubview(mainLabel!)
        mainLabel?.snp.makeConstraints({ (make) -> Void in
            make.height.equalTo(35 / masterRatio)
            make.left.equalTo(backView!.snp.left).offset(121 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(425 / masterRatio)
        })
        mainLabel!.font = Constants.BrandFonts.ubuntuBold14
        mainLabel?.textColor = UIColor.grocerestDarkBoldGray()
        
        
        secondaryLabel = UILabel()
        backView?.addSubview(secondaryLabel)
        secondaryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainLabel.snp.bottom)
            make.left.equalTo(mainLabel.snp.left)
        }
        
        
        selectionCellStatusImageView = UIImageView()
        backView?.addSubview(selectionCellStatusImageView!)
        selectionCellStatusImageView?.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(46 / masterRatio)
            make.right.equalTo(self.snp.right).offset(-35)
            make.centerY.equalTo(self.snp.centerY)
        })
        selectionCellStatusImageView?.contentMode = .scaleAspectFit
        

        
    }
    
    
    func selectedCellArrangement () {
        mainLabel?.snp.remakeConstraints({ (make) -> Void in
            make.height.equalTo(35 / masterRatio)
            make.left.equalTo(backView!.snp.left).offset(73 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(425 / masterRatio)
        })
    }
    
    
    func allCellArrangement () {
        mainLabel?.snp.remakeConstraints({ (make) -> Void in
            make.height.equalTo(35 / masterRatio)
            make.left.equalTo(backView!.snp.left).offset(121 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(425 / masterRatio)
        })
    }
}


extension GRFriendsViewCell {
    
    func formatCellForSelectedUser(_ name:String, lastname:String, username:String) {
        
        backView!.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(self.snp.width)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(96 / masterRatio)
        }
        
        selectionCellStatusImageView?.snp.remakeConstraints({ (make) -> Void in
            make.width.height.equalTo(46 / masterRatio)
            make.right.equalTo(self.snp.right).offset(-35)
            make.centerY.equalTo(self.snp.centerY)
        })
        
        
        mainLabel?.textColor = UIColor.grocerestBlue()
        mainLabel?.font = Constants.BrandFonts.ubuntuBold14
        mainLabel.text = "\(name) \(lastname)"
        
        mainLabel.snp.remakeConstraints { (make) in
            make.top.equalTo((backView?.snp.top)!).offset(11 / masterRatio)
            make.left.equalTo(42 / masterRatio)
        }
        
        secondaryLabel.textColor = UIColor.grocerestLightGrayColor()
        secondaryLabel.font = Constants.BrandFonts.avenirBook12
        secondaryLabel.text = username
        
        secondaryLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(mainLabel.snp.left)
            make.top.equalTo(mainLabel.snp.bottom)
        }
        
    }
    
    
    func formatCellForNoSelectedUser(_ name: String, lastname: String, username:String) {
        
        backView!.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(self.snp.width)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(128 / masterRatio)
        }
        
        selectionCellStatusImageView?.snp.remakeConstraints({ (make) -> Void in
            make.width.height.equalTo(46 / masterRatio)
            make.right.equalTo(self.snp.right).offset(-35)
            make.centerY.equalTo(self.snp.centerY)
        })
        
        
        mainLabel?.textColor = UIColor.grocerestDarkBoldGray()
        mainLabel?.font = Constants.BrandFonts.ubuntuBold14
        mainLabel.text = "\(name) \(lastname)"
        
        mainLabel.snp.remakeConstraints { (make) in
            make.top.equalTo((backView?.snp.top)!).offset(29 / masterRatio)
            make.left.equalTo(145 / masterRatio)
        }
        
        secondaryLabel.textColor = UIColor.grocerestLightGrayColor()
        secondaryLabel.font = Constants.BrandFonts.avenirBook12
        secondaryLabel.text = username
        
        secondaryLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(mainLabel.snp.left)
            make.top.equalTo(mainLabel.snp.bottom)
        }
    }
    
}
