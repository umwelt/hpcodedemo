//
//  GREditFriendsTableViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/02/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GREditFriendsTableViewCell: UITableViewCell {
    
    var viewsByName: [String: UIView]!
    var listCellImageView : UIImageView?
    var backView : UIView?
    
    var labelsView : UIView!
    var mainLabel : UILabel!
    var usernameLabel: UILabel!
    
    
    lazy var userProfileImage : UserImage = {
        let userImage = UserImage()
        
        return userImage
    }()
    
    var selectionButton : UIButton?
    var secondaryLabel : UILabel?
    
    var ownerLabel : UILabel?
    
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
        
        var viewsByName: [String: UIView] = [:]
        let __scaling__ = UIView()
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        
        backView = UIView()
        __scaling__.addSubview(backView!)
        backView!.backgroundColor = UIColor.white
        backView!.layer.cornerRadius = 5
        backView!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(__scaling__.snp.width)
            make.centerX.equalTo(__scaling__.snp.centerX)
            make.centerY.equalTo(__scaling__.snp.centerY)
            make.height.equalTo(149 / masterRatio)
        }
        
        let userImageSize = CGSize(width: 86 / masterRatio, height: 86 / masterRatio)
        
        backView!.addSubview(userProfileImage)
        userProfileImage.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(userImageSize)
            make.left.equalTo(backView!.snp.left).offset(28 / masterRatio)
            make.centerY.equalTo(backView!.snp.centerY)
        }
        
        
        labelsView = UIView()
        backView?.addSubview(labelsView)
        labelsView.snp.makeConstraints { (make) in
            make.left.equalTo(backView!.snp.left).offset(144 / masterRatio)
            make.centerY.equalTo(backView!.snp.centerY)
            make.width.equalTo(425 / masterRatio)
            make.height.equalTo(80 / masterRatio)
        }
        
        
        mainLabel = UILabel()
        labelsView!.addSubview(mainLabel!)
        mainLabel?.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(labelsView.snp.top).offset(6 / masterRatio)
            make.left.equalTo(labelsView.snp.left)
        })
        mainLabel!.font = Constants.BrandFonts.ubuntuBold14
        mainLabel?.textColor = UIColor.grocerestDarkBoldGray()

        
        secondaryLabel = UILabel()
        labelsView?.addSubview(secondaryLabel!)
        secondaryLabel?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo((mainLabel?.snp.width)!)
            make.left.equalTo((mainLabel?.snp.left)!)
            make.top.equalTo((mainLabel?.snp.bottom)!)
        })
        secondaryLabel?.textColor = UIColor.grocerestLightGrayColor()
        secondaryLabel?.font = Constants.BrandFonts.avenirBook12
        
        
        
        ownerLabel = UILabel()
        backView?.addSubview(ownerLabel!)
        ownerLabel?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(140 / masterRatio)
            make.right.equalTo(self.snp.right).offset(-20 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
        })
        ownerLabel?.font = Constants.BrandFonts.avenirHeavy11
        ownerLabel?.textColor = UIColor.grocerestBlue()
        ownerLabel?.textAlignment = .left
        ownerLabel?.text = "CREATORE"
        ownerLabel?.isHidden = false
        
        

        
        
        selectionButton = UIButton()
        backView?.addSubview(selectionButton!)
        selectionButton?.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(64 / masterRatio)
            make.right.equalTo(self.snp.right).offset(-35)
            make.centerY.equalTo(self.snp.centerY)
        })
        selectionButton?.contentMode = .scaleAspectFit
        selectionButton?.setImage(UIImage(named: "selected_friends_icon"), for: UIControlState())
        selectionButton?.isHidden = true
        
        
        
        
        self.viewsByName = viewsByName
    }
    
}



extension GREditFriendsTableViewCell {
    
    
    func setLabelsForUserInCell(_ name:String, lastName:String, userName: String) {
        mainLabel.text =  nil
        secondaryLabel?.text = nil
        mainLabel.text = "\(name) \(lastName)"
        secondaryLabel?.text = userName
    }
    
}


