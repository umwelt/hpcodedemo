//
//  GRProfileToolbar.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 21/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRProfileToolbar: UIView {
    
    var delegate : GRToolBarProtocol?
    var viewsByName: [String: UIView]!
    private var backButton: CustomButtonWithExtendedTouchArea?
    private var menuButton: CustomButtonWithExtendedTouchArea?
    var grocerestButton : UIButton?
    var userProfile: Bool?
    var settingsButton: UIButton?
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
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
        backgroundColor = UIColor.grocerestColor()
        clipsToBounds = true
        
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
        __scaling__.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        viewsByName["__scaling__"] = __scaling__
        
        
        backButton = CustomButtonWithExtendedTouchArea(type: .custom)
        backButton!.contentMode = .center
        backButton!.setImage(UIImage(named: "back_button"), for: UIControlState())
        backButton!.addTarget(self, action: #selector(self.actionBackButtonWasPressed(_:)), for: .touchUpInside)
        backButton!.isHidden = true
        __scaling__.addSubview(backButton!)
        backButton?.showsTouchWhenHighlighted = false
        backButton!.snp.makeConstraints { make in
            make.left.equalTo(__scaling__.snp.left).offset(35 / masterRatio)
            make.bottom.equalTo(__scaling__.snp.bottom).offset(-40 / masterRatio)
        }
        
        viewsByName["backButton"] = backButton
        
        grocerestButton = UIButton(type: .custom)
        grocerestButton!.addTarget(self, action: #selector(self.actionGrocerestButtonWasPressed(_:)), for: .touchUpInside)
        __scaling__.addSubview(grocerestButton!)
        grocerestButton?.setTitleColor(UIColor.white, for: UIControlState())
        grocerestButton?.titleLabel?.font = Constants.BrandFonts.ubuntuLight18
        grocerestButton!.snp.makeConstraints { make in
            make.width.equalTo(536 / masterRatio)
            make.height.equalTo(22.5)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(34)
        }
        
        viewsByName["grocerestButton"] = grocerestButton
        
        
        menuButton = CustomButtonWithExtendedTouchArea(type: .custom)
        menuButton!.contentMode = .center
        menuButton!.setImage(UIImage(named: "big_menu"), for: UIControlState())
        menuButton!.addTarget(self, action: #selector(self.actionMenuButtonWasPressed(_:)), for: .touchUpInside)
        __scaling__.addSubview(menuButton!)
        menuButton?.showsTouchWhenHighlighted = false
        menuButton!.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(33 / masterRatio)
            make.centerY.equalTo(grocerestButton!.snp.centerY)
        }
        
        viewsByName["menuButton"] = menuButton
        
        
        settingsButton = UIButton(type: .custom)
        settingsButton?.contentMode = .scaleAspectFill
        settingsButton?.setImage(UIImage(named: "settings_icon"), for: UIControlState())
        settingsButton?.addTarget(self, action: #selector(self.actionSettingsButtonWasPressed(_:)), for: .touchUpInside)
        __scaling__.addSubview(settingsButton!)
        settingsButton?.snp.makeConstraints { make in
            make.width.height.equalTo(49 / masterRatio)
            make.centerY.equalTo(grocerestButton!.snp.centerY)
            make.right.equalTo(-32  / masterRatio)
        }
        
        
        self.viewsByName = viewsByName
    }
    
    func showBackButton() {
        backButton!.isHidden = false
        menuButton!.snp.remakeConstraints { make in
            make.left.equalTo(backButton!.snp.right).offset(47 / masterRatio)
            make.centerY.equalTo(backButton!)
        }
    }
    
    func actionBackButtonWasPressed(_ backButton: UIButton) {
        delegate?.backButtonWasPressed!(backButton)
    }
    
    func actionMenuButtonWasPressed(_ menuButton: UIButton) {
        delegate?.menuButtonWasPressed!(menuButton)
        //TODO: centralize menu controller
        print("menu was pressed")
    }
    
    func actionSettingsButtonWasPressed(_ sender:UIButton) {
        delegate?.settingsButtonWasPressed!(sender)
    }
    
    func actionGrocerestButtonWasPressed(_ sender:UIButton) {
        delegate?.grocerestButtonWasPressed!(sender)
    }
    
    private class CustomButtonWithExtendedTouchArea : UIButton {
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let relativeFrame = self.bounds
            let hitTestEdgeInsets = UIEdgeInsetsMake(-20/masterRatio, -20/masterRatio, -20/masterRatio, -20/masterRatio)
            let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
            return hitFrame.contains(point)
        }
    }
    
}
