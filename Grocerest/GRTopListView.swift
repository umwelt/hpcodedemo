//
//  GRTopListView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 12/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

/// Top List view is the embeded list view in home page

import Foundation
import UIKit

class GRTopListView: UIView {
    
    var viewsByName: [String: UIView]!
    
    var toplistViewOne : UIView?
    var topOneListIcon : UIImageView?
    var badgeLabelOne = UILabel()
    var topOneLabel : UILabel?
    var topOneElementsLabel : UILabel?
    var topOneButton : UIButton?
    
    var toplistViewTwo : UIView?
    var topTwoListIcon : UIImageView?
    var badgeLabelTwo = UILabel()
    var topTwoLabel : UILabel?
    var topTwoElementsLabel : UILabel?
    var topTwoButton : UIButton?
    
    var completedImageViewA = UIImageView()
    var completedImageViewB = UIImageView()
    
    
    var oneCompletedImageView = UIImageView()
    var twoCompletedImageView = UIImageView()
    
    
    
        // - MARK: Life Cycle
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }
    
    var delegate : GRToolBarProtocol?
    
    // - MARK: Scaling
    
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
        
        
        
        toplistViewOne = UIView()
        __scaling__.addSubview(toplistViewOne!)
        toplistViewOne!.layer.cornerRadius = 5
        toplistViewOne!.backgroundColor = UIColor.white
        toplistViewOne!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(155 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(16 / masterRatio)
        }
        
        
        topOneListIcon = UIImageView()
        toplistViewOne!.addSubview(topOneListIcon!)
        topOneListIcon!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.listIconSize)
            make.left.equalTo(toplistViewOne!.snp.left).offset(40 / masterRatio)
            make.top.equalTo(toplistViewOne!.snp.top).offset(35 / masterRatio)
        }
        
        toplistViewOne!.addSubview(badgeLabelOne)
        badgeLabelOne.snp.makeConstraints({ (make) -> Void in
            make.size.equalTo(Constants.UISizes.badgeIcon)
            make.top.equalTo((topOneListIcon?.snp.top)!)
            make.right.equalTo((topOneListIcon?.snp.right)!)
        })
        badgeLabelOne.backgroundColor = UIColor.grocerestBlue()
        badgeLabelOne.textColor = UIColor.white
        badgeLabelOne.textAlignment = .center
        badgeLabelOne.text = "0"
        badgeLabelOne.font = Constants.BrandFonts.avenirHeavy10
        badgeLabelOne.layer.cornerRadius = 7.5
        badgeLabelOne.layer.masksToBounds = true
        
        topOneLabel = UILabel()
        toplistViewOne!.addSubview(topOneLabel!)
        topOneLabel!.textColor = UIColor.grocerestDarkGrayText()
        topOneLabel!.font = Constants.BrandFonts.ubuntuBold14
        topOneLabel!.textAlignment = .left
        topOneLabel!.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(topOneListIcon!.snp.right).offset(28 / masterRatio)
            make.top.equalTo(toplistViewOne!.snp.top).offset(44 / masterRatio)
            make.width.equalTo(450 / masterRatio)
            make.height.equalTo(34 / masterRatio)
        }
        
        
        topOneElementsLabel = UILabel()
        toplistViewOne!.addSubview(topOneElementsLabel!)
        topOneElementsLabel!.textColor = UIColor.grocerestDarkGrayText()
        topOneElementsLabel!.font = Constants.BrandFonts.avenirBook11
        topOneElementsLabel!.textAlignment = .left
        topOneElementsLabel!.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(topOneListIcon!.snp.right).offset(28 / masterRatio)
            make.top.equalTo(topOneLabel!.snp.bottom).offset(8 / masterRatio)
            make.width.equalTo(450 / masterRatio)
            make.height.equalTo(34 / masterRatio)
        }
        
        topOneButton = UIButton()
        toplistViewOne?.addSubview(topOneButton!)
        topOneButton?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(toplistViewOne!)
        })
        

        
        let disclosureIcon = UIImageView()
        toplistViewOne!.addSubview(disclosureIcon)
        disclosureIcon.image = UIImage(named: "disclosure")
        disclosureIcon.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.disclosureIcon)
            make.right.equalTo(toplistViewOne!.snp.right).offset(-41 / masterRatio)
            make.top.equalTo(toplistViewOne!.snp.top).offset(63 / masterRatio)
        }
        
        toplistViewOne!.addSubview(completedImageViewA)
        completedImageViewA.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(38/2)
            make.height.equalTo(25/2)
            make.right.equalTo(disclosureIcon.snp.left).offset(-24/2)
            make.bottom.equalTo(self.snp.bottom).offset(-24/2)
        })
        
        
        
        toplistViewOne!.addSubview(oneCompletedImageView)
        oneCompletedImageView.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(38/2)
            make.height.equalTo(25/2)
            make.right.equalTo(toplistViewOne!.snp.right).offset(-24/2)
            make.bottom.equalTo(toplistViewOne!.snp.bottom).offset(-24/2)
        })
        __scaling__.bringSubview(toFront: oneCompletedImageView)
        oneCompletedImageView.image = UIImage(named: "completed")
        oneCompletedImageView.isHidden = true
        
        
        
        
        viewsByName["toplistViewOne"] = toplistViewOne
        
        // Top List 2
        
        toplistViewTwo = UIView()
        __scaling__.addSubview(toplistViewTwo!)
        toplistViewTwo!.layer.cornerRadius = 5
        toplistViewTwo!.backgroundColor = UIColor.white
        toplistViewTwo!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(toplistViewOne!.snp.size)
            make.left.equalTo(toplistViewOne!.snp.left)
            make.top.equalTo(toplistViewOne!.snp.bottom).offset(16 / masterRatio)
        }
        
        topTwoListIcon = UIImageView()
        toplistViewTwo!.addSubview(topTwoListIcon!)
        topTwoListIcon!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.listIconSize)
            make.left.equalTo(toplistViewTwo!.snp.left).offset(40 / masterRatio)
            make.top.equalTo(toplistViewTwo!.snp.top).offset(35 / masterRatio)
        }
        
        
        
        toplistViewTwo!.addSubview(badgeLabelTwo)
        badgeLabelTwo.snp.makeConstraints({ (make) -> Void in
            make.size.equalTo(Constants.UISizes.badgeIcon)
            make.top.equalTo((topTwoListIcon?.snp.top)!)
            make.right.equalTo((topTwoListIcon?.snp.right)!)
        })
        badgeLabelTwo.backgroundColor = UIColor.grocerestBlue()
        badgeLabelTwo.textColor = UIColor.white
        badgeLabelTwo.textAlignment = .center
        badgeLabelTwo.text = "0"
        badgeLabelTwo.font = Constants.BrandFonts.avenirHeavy10
        badgeLabelTwo.layer.cornerRadius = 7.5
        badgeLabelTwo.layer.masksToBounds = true
        
        
        topTwoLabel = UILabel()
        toplistViewTwo!.addSubview(topTwoLabel!)
        topTwoLabel!.textColor = UIColor.grocerestDarkGrayText()
        topTwoLabel!.font = Constants.BrandFonts.ubuntuBold14
        topTwoLabel!.textAlignment = .left
        topTwoLabel!.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(topTwoListIcon!.snp.right).offset(28 / masterRatio)
            make.top.equalTo(toplistViewTwo!.snp.top).offset(44 / masterRatio)
            make.width.equalTo(450 / masterRatio)
            make.height.equalTo(34 / masterRatio)
        }
        
        
        topTwoElementsLabel = UILabel()
        toplistViewTwo!.addSubview(topTwoElementsLabel!)
        topTwoElementsLabel!.textColor = UIColor.grocerestDarkGrayText()
        topTwoElementsLabel!.font = Constants.BrandFonts.avenirBook11
        topTwoElementsLabel!.textAlignment = .left
        topTwoElementsLabel!.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(topTwoListIcon!.snp.right).offset(28 / masterRatio)
            make.top.equalTo(topTwoLabel!.snp.bottom).offset(8 / masterRatio)
            make.width.equalTo(self)
            make.height.equalTo(34 / masterRatio)
        }
        
        topTwoButton = UIButton()
        toplistViewTwo?.addSubview(topTwoButton!)
        topTwoButton?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(toplistViewTwo!)
        })
        
        
        let disclosureIconB = UIImageView()
        toplistViewTwo!.addSubview(disclosureIconB)
        disclosureIconB.image = UIImage(named: "disclosure")
        disclosureIconB.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.disclosureIcon)
            make.right.equalTo(toplistViewTwo!.snp.right).offset(-41 / masterRatio)
            make.top.equalTo(toplistViewTwo!.snp.top).offset(63 / masterRatio)
        }
        
        
        toplistViewTwo!.addSubview(completedImageViewB)
        completedImageViewB.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(38/2)
            make.height.equalTo(25/2)
            make.right.equalTo(self.snp.right).offset(-24/2)
            make.bottom.equalTo(self.snp.bottom).offset(-24/2)
        })
        
        
        toplistViewTwo!.addSubview(twoCompletedImageView)
        twoCompletedImageView.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(38/2)
            make.height.equalTo(25/2)
            make.right.equalTo(self.snp.right).offset(-24/2)
            make.bottom.equalTo(self.snp.bottom).offset(-24/2)
        })
        twoCompletedImageView.isHidden = true

        
        viewsByName["toplistViewTwo"] = toplistViewTwo
        self.viewsByName = viewsByName

        
    }
    
    
    
}
