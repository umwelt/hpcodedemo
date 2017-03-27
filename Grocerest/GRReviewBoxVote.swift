//
//  GRReviewBoxVote.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

@IBDesignable
class GRReviewBoxVote: UIView {
    
    var viewsByName: [String: UIView]!
    
    var voteOne : UIButton?
    var voteTwo : UIButton?
    var voteThree : UIButton?
    var voteFour : UIButton?
    var voteFive : UIButton?
    
    
    var reviewLabel = UILabel()
    var reviewSubLabel = UILabel()
    
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
    
    var delegate : GRReviewBoxVoteProtocol?
    
    
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
        
        
        reviewLabel = UILabel()
        __scaling__.addSubview(reviewLabel)
        reviewLabel.text = Constants.AppLabels.voteLabel1
        reviewLabel.textColor = UIColor.grocerestDarkBoldGray()
        reviewLabel.font = Constants.BrandFonts.avenirHeavy12
        reviewLabel.textAlignment = .left
        reviewLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp.left).offset(160 / masterRatio)
            make.top.equalTo(self.snp.top).offset(31 / masterRatio)
        }
        
        viewsByName["reviewLabel"] = reviewLabel
        
        reviewSubLabel = UILabel()
        __scaling__.addSubview(reviewSubLabel)
        reviewSubLabel.text = Constants.AppLabels.voteLabel2
        reviewSubLabel.textColor = UIColor.grocerestLightGrayColor()
        reviewSubLabel.font = Constants.BrandFonts.avenirBook12
        reviewSubLabel.textAlignment = .left
        reviewSubLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(reviewLabel.snp.right).offset(4 / masterRatio)
            make.top.equalTo(self.snp.top).offset(31 / masterRatio)
        }
        
        viewsByName["reviewSubLabel"] = reviewSubLabel
        
        voteOne = UIButton(type: .custom)
        __scaling__.addSubview(voteOne!)
        var imagevoteOneButton: UIImage!
        imagevoteOneButton = UIImage(named: "neutral_vote")
        voteOne!.setImage(imagevoteOneButton, for: UIControlState())
        voteOne!.setImage(UIImage(named: "positive_vote"), for: .selected)
        voteOne!.contentMode = .scaleAspectFit
        voteOne!.tag = 1
        voteOne!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.voteButtonSize)
            make.left.equalTo(self.snp.left).offset(66 / masterRatio)
            make.top.equalTo(reviewLabel.snp.bottom).offset(30 / masterRatio)
        }
        
        viewsByName["voteOne"] = voteOne
        
        
        voteTwo = UIButton(type: .custom)
        __scaling__.addSubview(voteTwo!)
        var imagevotetwoButton: UIImage!
        imagevotetwoButton = UIImage(named: "neutral_vote")
        voteTwo!.setImage(imagevotetwoButton, for: UIControlState())
        voteTwo!.setImage(UIImage(named: "positive_vote"), for: .selected)
        voteTwo!.contentMode = .scaleAspectFit
        voteTwo!.tag = 2
        voteTwo!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.voteButtonSize)
            make.left.equalTo(voteOne!.snp.right).offset(30 / masterRatio)
            make.top.equalTo(reviewLabel.snp.bottom).offset(30 / masterRatio)
        }
        viewsByName["voteTwo"] = voteTwo
        
        voteThree = UIButton(type: .custom)
        __scaling__.addSubview(voteThree!)
        var imagevoteThreeButton: UIImage!
        imagevoteThreeButton = UIImage(named: "neutral_vote")
        voteThree!.setImage(imagevoteThreeButton, for: UIControlState())
        voteThree!.setImage(UIImage(named: "positive_vote"), for: .selected)
        voteThree!.contentMode = .scaleAspectFit
        voteThree!.tag = 3
        voteThree!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.voteButtonSize)
            make.left.equalTo(voteTwo!.snp.right).offset(30 / masterRatio)
            make.top.equalTo(reviewLabel.snp.bottom).offset(30 / masterRatio)
        }
        viewsByName["voteThree"] = voteThree
        
        voteFour = UIButton(type: .custom)
        __scaling__.addSubview(voteFour!)
        var imagevoteFourButton: UIImage!
        imagevoteFourButton = UIImage(named: "neutral_vote")
        voteFour!.setImage(imagevoteFourButton, for: UIControlState())
        voteFour!.setImage(UIImage(named: "positive_vote"), for: .selected)
        voteFour!.contentMode = .scaleAspectFit
        voteFour!.tag = 4
        voteFour!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.voteButtonSize)
            make.left.equalTo(voteThree!.snp.right).offset(30 / masterRatio)
            make.top.equalTo(reviewLabel.snp.bottom).offset(30 / masterRatio)
        }
        viewsByName["voteFour"] = voteFour
        
        voteFive = UIButton(type: .custom)
        __scaling__.addSubview(voteFive!)
        var imagevoteFiveButton: UIImage!
        imagevoteFiveButton = UIImage(named: "neutral_vote")
        voteFive!.setImage(imagevoteFiveButton, for: UIControlState())
        voteFive!.setImage(UIImage(named: "positive_vote"), for: .selected)
        voteFive!.contentMode = .scaleAspectFit
        voteFive!.tag = 5
        voteFive!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.voteButtonSize)
            make.left.equalTo(voteFour!.snp.right).offset(30 / masterRatio)
            make.top.equalTo(reviewLabel.snp.bottom).offset(30 / masterRatio)
        }
        viewsByName["voteFive"] = voteFive
        
        
        self.viewsByName = viewsByName
        
    }
    
    func hideLabels() {
        
        viewsByName["reviewSubLabel"]?.isHidden = true
        viewsByName["reviewLabel"]?.isHidden = true

        
        voteOne!.snp.remakeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.voteButtonSize)
            make.left.equalTo(self.snp.left).offset(30 / masterRatio)
            make.top.equalTo(self.snp.top)
        }
        
        voteTwo!.snp.remakeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.voteButtonSize)
            make.left.equalTo(voteOne!.snp.right).offset(30 / masterRatio)
            make.top.equalTo(self.snp.top)
        }
        
        voteThree!.snp.remakeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.voteButtonSize)
            make.left.equalTo(voteTwo!.snp.right).offset(30 / masterRatio)
            make.top.equalTo(self.snp.top)
        }
        
        voteFour!.snp.remakeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.voteButtonSize)
            make.left.equalTo(voteThree!.snp.right).offset(30 / masterRatio)
            make.top.equalTo(self.snp.top)
        }
        
        voteFive!.snp.remakeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.voteButtonSize)
            make.left.equalTo(voteFour!.snp.right).offset(30 / masterRatio)
            make.top.equalTo(self.snp.top)
        }
    }
    

    
    
}
