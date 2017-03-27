//
//  GRReviewBoxFrequency.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//


import Foundation
import UIKit
import SnapKit

@IBDesignable

class GRReviewBoxFrequency: UIView {
    
    var viewsByName: [String: UIView]!
    var freqFirst : UIButton?
    var freqRarely : UIButton?
    var freqMontly : UIButton?
    var freqWeakly : UIButton?
    var freqDaily : UIButton?
    
    var reviewLabel = UILabel()
    let baseCornerRadius =  10.0 / masterRatio
    let baseBorderWidth = 2.0 / masterRatio
    
    
    
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
        reviewLabel.text = Constants.AppLabels.frequencyLabel
        reviewLabel.textColor = UIColor.grocerestDarkBoldGray()
        reviewLabel.font = Constants.BrandFonts.avenirHeavy12
        reviewLabel.textAlignment = .left
        reviewLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(31 / masterRatio)
        }
        
        viewsByName["reviewLabel"] = reviewLabel
        
        
        
        
        freqRarely = UIButton(type: .custom)
        __scaling__.addSubview(freqRarely!)
        freqRarely!.setTitle(Constants.AppLabels.freqRarely, for: UIControlState())
        freqRarely!.titleLabel?.font = Constants.BrandFonts.avenirBook10
        freqRarely!.setTitleColor(UIColor.buttonGrayLabels(), for: UIControlState())
        freqRarely!.setTitleShadowColor(UIColor.grocerestDarkGrayText(), for: .highlighted)
        freqRarely!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
        freqRarely!.tag = 1
        freqRarely!.layer.cornerRadius = baseCornerRadius
        freqRarely!.layer.borderWidth = baseBorderWidth
        freqRarely!.showsTouchWhenHighlighted = true
        
        freqRarely!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(160 / masterRatio)
            make.height.equalTo(48 / masterRatio)
            make.centerX.equalTo(__scaling__.snp.centerX)
            make.top.equalTo(reviewLabel.snp.bottom).offset(16 / masterRatio)
        }
        
        viewsByName["freqRarely"] = freqRarely
        
        
        
        
        
        freqFirst = UIButton(type: .custom)
        __scaling__.addSubview(freqFirst!)
        freqFirst!.setTitle(Constants.AppLabels.freqFirstTime, for: UIControlState())
        freqFirst!.titleLabel?.font = Constants.BrandFonts.avenirBook10
        freqFirst!.setTitleColor(UIColor.buttonGrayLabels(), for: UIControlState())
        freqFirst!.setTitleShadowColor(UIColor.grocerestDarkGrayText(), for: .highlighted)
        freqFirst!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
        freqFirst!.tag = 0
        freqFirst!.layer.cornerRadius = baseCornerRadius
        freqFirst!.layer.borderWidth = baseBorderWidth
        freqFirst!.showsTouchWhenHighlighted = true
        
        freqFirst!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(160 / masterRatio)
            make.height.equalTo(48 / masterRatio)
            make.right.equalTo((freqRarely?.snp.left)!).offset(-12 / masterRatio)
            make.centerY.equalTo((freqRarely?.snp.centerY)!)
        }
        
        viewsByName["freqFirst"] = freqFirst
        
        
        freqMontly = UIButton(type: .custom)
        __scaling__.addSubview(freqMontly!)
        freqMontly!.setTitle(Constants.AppLabels.freqMontly, for: UIControlState())
        freqMontly!.titleLabel?.font = Constants.BrandFonts.avenirBook10
        freqMontly!.setTitleColor(UIColor.buttonGrayLabels(), for: UIControlState())
        freqMontly!.setTitleShadowColor(UIColor.grocerestDarkGrayText(), for: .highlighted)
        freqMontly!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
        freqMontly?.tag = 2
        freqMontly!.layer.cornerRadius = baseCornerRadius
        freqMontly!.layer.borderWidth = baseBorderWidth
        freqMontly!.showsTouchWhenHighlighted = true
        freqMontly!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(198 / masterRatio)
            make.height.equalTo(48 / masterRatio)
            make.left.equalTo(freqRarely!.snp.right).offset(12 / masterRatio)
            make.centerY.equalTo((freqRarely?.snp.centerY)!)
        }
        
        viewsByName["freqMontly"] = freqMontly
        
        
        freqWeakly = UIButton(type: .custom)
        __scaling__.addSubview(freqWeakly!)
        freqWeakly!.setTitle(Constants.AppLabels.freqWeakly, for: UIControlState())
        freqWeakly!.titleLabel?.font = Constants.BrandFonts.avenirBook10
        freqWeakly!.setTitleColor(UIColor.buttonGrayLabels(), for: UIControlState())
        freqWeakly!.setTitleShadowColor(UIColor.grocerestDarkGrayText(), for: .highlighted)
        freqWeakly!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
        freqWeakly?.tag = 3
        freqWeakly!.layer.cornerRadius = baseCornerRadius
        freqWeakly!.layer.borderWidth = baseBorderWidth
        freqWeakly!.showsTouchWhenHighlighted = true
        
        freqWeakly!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(240 / masterRatio)
            make.height.equalTo(48 / masterRatio)
            make.left.equalTo(160 / masterRatio)
            make.top.equalTo(freqFirst!.snp.bottom).offset(12 / masterRatio)
        }
        
        viewsByName["freqWeakly"] = freqWeakly
        
        
        freqDaily = UIButton(type: .custom)
        __scaling__.addSubview(freqDaily!)
        freqDaily!.setTitle(Constants.AppLabels.freqDaily, for: UIControlState())
        freqDaily!.titleLabel?.font = Constants.BrandFonts.avenirBook10
        freqDaily!.setTitleColor(UIColor.buttonGrayLabels(), for: UIControlState())
        freqDaily!.setTitleShadowColor(UIColor.grocerestDarkGrayText(), for: .highlighted)
        freqDaily!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
        freqDaily?.tag = 4
        freqDaily!.layer.cornerRadius = baseCornerRadius
        freqDaily!.layer.borderWidth = baseBorderWidth
        freqDaily!.showsTouchWhenHighlighted = true
        freqDaily!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(176 / masterRatio)
            make.height.equalTo(48 / masterRatio)
            make.left.equalTo(freqWeakly!.snp.right).offset(12 / masterRatio)
            make.top.equalTo(freqFirst!.snp.bottom).offset(12 / masterRatio)
        }
        
        viewsByName["freqDaily"] = freqDaily
 
        
        self.viewsByName = viewsByName
        
    }
    
    
    func resetOriginalState() {
        freqFirst!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
        freqFirst!.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
        
        freqRarely!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
        freqRarely!.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
        
        freqMontly!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
        freqMontly!.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
        
        freqWeakly!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
        freqWeakly!.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
        
        freqDaily!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
        freqDaily!.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
    }
    

    // Maybe used later
    func setHighlight(_ senderTag:Int){
        
        switch senderTag {
        case 1:
            freqFirst!.layer.borderColor = UIColor.grocerestBlue().cgColor
            freqFirst?.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
            
            freqRarely!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqRarely?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqMontly!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqMontly?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqWeakly!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqWeakly?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqDaily!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqDaily?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
        case 2:
            freqFirst!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqFirst?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqRarely!.layer.borderColor = UIColor.grocerestBlue().cgColor
            freqRarely?.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
            
            freqMontly!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqMontly?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqWeakly!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqWeakly?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqDaily!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqDaily?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
        case 3:
            freqFirst!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqFirst?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqRarely!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqRarely?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqMontly!.layer.borderColor = UIColor.grocerestBlue().cgColor
            freqMontly?.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
            
            freqWeakly!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqWeakly?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqDaily!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqDaily?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
        case 4:
            freqFirst!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqFirst?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqRarely!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqRarely?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqMontly!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqMontly?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqWeakly!.layer.borderColor = UIColor.grocerestBlue().cgColor
            freqWeakly?.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
            
            freqDaily!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqDaily?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
        case 5:
            freqFirst!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqFirst?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqRarely!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqRarely?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqMontly!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqMontly?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqWeakly!.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
            freqWeakly?.setTitleColor(UIColor.grocerestLightGrayColor(), for: UIControlState())
            
            freqDaily!.layer.borderColor = UIColor.grocerestBlue().cgColor
            freqDaily?.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        default:
            return
        }
        
        
    }
    
}

