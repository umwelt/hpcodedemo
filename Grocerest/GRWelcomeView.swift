//
//  WelcomeView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 29/10/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import UIKit
import SnapKit

protocol GRWelcomeViewDelegate: class {
    func registrationButtonPressed(_ registrationtButton: UIButton)
    func facebookButtonPressed(_ facebookButton: UIButton)
    func accessButtonWasPressed(_ accessButton: UIButton)
    
}


@IBDesignable
class GRWelcomeView: UIView, CAAnimationDelegate {
    var animationCompletions = Dictionary<CAAnimation, (Bool) -> Void>()
    var viewsByName: [String: UIView]!
    
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
    
    // TODO protect here
    weak var delegate = GRWelcomeViewController()
    
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
        var viewsByName: [String : UIView] = [:]
        let __scaling__ = UIView()
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        let mall = UIImageView()
        __scaling__.addSubview(mall)
        mall.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        var imgMall: UIImage!
        imgMall = UIImage(named: "mall")
        mall.image = imgMall
        mall.contentMode = .scaleAspectFit;
        viewsByName["mall"] = mall
        
        let alpha_cover = UIImageView()
        __scaling__.addSubview(alpha_cover)
        alpha_cover.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        alpha_cover.backgroundColor = UIColor(colorLiteralRed: 0.898, green: 0.204, blue: 0.325, alpha: 1.0)
        viewsByName["alpha_cover"] = alpha_cover
        
        let grocerestLabel = UILabel()
        grocerestLabel.text = Constants.BrandLabels.grocerestBrandLabel
        grocerestLabel.font = UIFont(name: "Ubuntu-Bold", size: 36.00)
        grocerestLabel.textColor = UIColor.white
        grocerestLabel.textAlignment = .center
        self.addSubview(grocerestLabel)
        grocerestLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(41.5)
            make.top.equalTo(self.snp.top).offset(127.5)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        let reputationLabel = UILabel()
        reputationLabel.text = Constants.BrandLabels.reputationBrandLabel
        reputationLabel.font = UIFont(name: "Avenir", size: 15)
        reputationLabel.textColor = UIColor.white
        reputationLabel.textAlignment = .center
        self.addSubview(reputationLabel)
        reputationLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(grocerestLabel.snp.bottom).offset(3)
            make.width.equalTo(self)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        
        
        let logo = UIImageView()
        __scaling__.addSubview(logo)
        
        var imgLogo: UIImage!
        imgLogo = UIImage(named: "launchLogo")
        logo.image = imgLogo
        logo.contentMode = .scaleAspectFit;
        logo.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.BrandAssetsSizes.logoSize)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        
        }
                
        viewsByName["logo"] = logo
        
        let facebookButton = UIButton(type: .custom)
        __scaling__.addSubview(facebookButton)
        
        var imgWhiteButton: UIImage!
        imgWhiteButton = UIImage(named: "facebook_button")
        facebookButton.setBackgroundImage(imgWhiteButton, for:UIControlState())
        facebookButton.contentMode = .center;
        facebookButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(logo.snp.bottom).offset(144 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        facebookButton.addTarget(self, action:#selector(GRWelcomeView.actionFacebookButtonPressed(_:)), for: .touchUpInside)
        viewsByName["facebook_button"] = facebookButton
        
        
        
        let facebookLabel = UILabel()
        facebookLabel.text = Constants.AppLabels.facebookLabel
        facebookLabel.font = Constants.BrandFonts.smallLabelFontA
        facebookLabel.textColor = UIColor.white
        facebookLabel.textAlignment = .center
        facebookButton.addSubview(facebookLabel)
        facebookLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(facebookButton)
        }
        
        let registrationButton = UIButton(type: .custom)
        __scaling__.addSubview(registrationButton)
        var imgTrasparentButton: UIImage!
        imgTrasparentButton = UIImage(named: "trasparent_button")
        registrationButton.setBackgroundImage(imgTrasparentButton, for:UIControlState())
        registrationButton.contentMode = .center;
        registrationButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(facebookButton.snp.bottom).offset(32 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        registrationButton.addTarget(self, action:#selector(GRWelcomeView.actionRegistrationButtonPressed(_:)), for: .touchUpInside)
        
        viewsByName["registrationButton"] = registrationButton
        
        
        let registrationLabel = UILabel()
        registrationLabel.text = Constants.AppLabels.registrationLabel
        registrationLabel.font = Constants.BrandFonts.smallLabelFontA
        registrationLabel.textColor = UIColor.white
        registrationLabel.textAlignment = .center
        registrationButton.addSubview(registrationLabel)
        registrationLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(registrationButton)
        }
        
        
        let hasAccountLabel = UILabel()
        hasAccountLabel.text = Constants.AppLabels.hasAccount
        hasAccountLabel.font = Constants.BrandFonts.smallLabelFontA
        hasAccountLabel.textColor = UIColor.white
        hasAccountLabel.textAlignment = .center
        self.addSubview(hasAccountLabel)
        hasAccountLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(272.25 / masterRatio)
            make.left.equalTo(149 / masterRatio)
            make.bottom.equalTo(self.snp.bottom).offset(-59.00 / masterRatio)
        }
        
        
        let accediButton = UIButton(type: .custom)
        __scaling__.addSubview(accediButton)
        
        var imgAccessButton: UIImage!
        imgAccessButton = UIImage(named: "access_button")
        accediButton.setBackgroundImage(imgAccessButton, for:UIControlState())
        accediButton.contentMode = .center;
        accediButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(175.25 / masterRatio)
            make.height.equalTo(57.28 / masterRatio)
            make.left.equalTo(hasAccountLabel.snp.right).offset(6 / masterRatio)
            make.bottom.equalTo(self.snp.bottom).offset(-49 / masterRatio)
        }
        accediButton.addTarget(self, action:#selector(GRWelcomeView.actionAccediButtonPressed(_:)), for: .touchUpInside)
        viewsByName["accediButton"] = accediButton
        
        
        let accediLabel = UILabel()
        accediLabel.text = Constants.AppLabels.accessLabel
        accediLabel.font = Constants.BrandFonts.smallLabelFontA
        accediLabel.textColor = UIColor.white
        accediLabel.textAlignment = .center
        accediButton.addSubview(accediLabel)
        accediLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(accediButton)
        }
        
        
        self.viewsByName = viewsByName
    }
    
    
    // - MARK: grow
    
    func addGrowAnimation() {
        addGrowAnimationWithBeginTime(0, fillMode: kCAFillModeBoth, removedOnCompletion: false, completion: nil)
    }
    
    func addGrowAnimation(_ completion: ((Bool) -> Void)?) {
        addGrowAnimationWithBeginTime(0, fillMode: kCAFillModeBoth, removedOnCompletion: false, completion: completion)
    }
    
    func addGrowAnimation(removedOnCompletion: Bool) {
        addGrowAnimationWithBeginTime(0, fillMode: removedOnCompletion ? kCAFillModeRemoved : kCAFillModeBoth, removedOnCompletion: removedOnCompletion, completion: nil)
    }
    
    func addGrowAnimation(removedOnCompletion: Bool, completion: ((Bool) -> Void)?) {
        addGrowAnimationWithBeginTime(0, fillMode: removedOnCompletion ? kCAFillModeRemoved : kCAFillModeBoth, removedOnCompletion: removedOnCompletion, completion: completion)
    }
    
    func addGrowAnimationWithBeginTime(_ beginTime: CFTimeInterval, fillMode: String, removedOnCompletion: Bool, completion: ((Bool) -> Void)?) {
        let linearTiming = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        if let complete = completion {
            let representativeAnimation = CABasicAnimation(keyPath: "not.a.real.key")
            representativeAnimation.duration = 2.000
            representativeAnimation.delegate = self
            self.layer.add(representativeAnimation, forKey: "Grow")
            self.animationCompletions[layer.animation(forKey: "Grow")!] = complete
        }
        
        let alpha_coverOpacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        alpha_coverOpacityAnimation.duration = 2.000
        alpha_coverOpacityAnimation.values = [1.000 as Float, 0.900 as Float]
        alpha_coverOpacityAnimation.keyTimes = [NSNumber(value: 0.000 as Float), NSNumber(value: 1.000 as Float)]
        alpha_coverOpacityAnimation.timingFunctions = [linearTiming, linearTiming]
        alpha_coverOpacityAnimation.beginTime = beginTime
        alpha_coverOpacityAnimation.fillMode = fillMode
        alpha_coverOpacityAnimation.isRemovedOnCompletion = removedOnCompletion
        self.viewsByName["alpha_cover"]?.layer.add(alpha_coverOpacityAnimation, forKey: "grow_Opacity")
        
        
    }
    
    func removeGrowAnimation() {
        self.layer.removeAnimation(forKey: "Grow")
        self.viewsByName["alpha_cover"]?.layer.removeAnimation(forKey: "grow_Opacity")
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let completion = self.animationCompletions[anim] {
            self.animationCompletions.removeValue(forKey: anim)
            completion(flag)
        }
    }
    
    func removeAllAnimations() {
        for subview in viewsByName.values {
            subview.layer.removeAllAnimations()
        }
        self.layer.removeAnimation(forKey: "Grow")
    }

    
    
    // - MARK: delegated
    
    func actionFacebookButtonPressed(_ facebookButton: UIButton) {
        delegate?.facebookButtonPressed(facebookButton)
    }
    
    func actionRegistrationButtonPressed(_ registrationButton: UIButton) {
        delegate?.registrationButtonPressed(registrationButton)
    }
    
    func actionAccediButtonPressed(_ accesButton: UIButton) {
        delegate?.accessButtonWasPressed(accesButton)
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
