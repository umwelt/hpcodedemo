//
//  GRToolbar.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 31/10/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class GRToolbar: UIView {
    var delegate : GRToolBarProtocol?
    var viewsByName: [String: UIView]!
    var menuButton : UIButton?
    var backButton: UIButton?
    var scannerButton : UIButton?
    var grocerestButton : UIButton?
    var triangleImageView : UIImageView?
    var dotsMenu: UIButton?
    var hasTitle : Bool?
    var hasBackButton : Bool?
    var userProfile: Bool?
    var settingsButton: UIButton?
    var searchButton : UIButton?
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140 / masterRatio))
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
        
       // self.translucent = false
        backgroundColor = UIColor.grocerestColor()
        self.clipsToBounds = true
        
        
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
    
    fileprivate class CustomButtonWithExtendedTouchArea : UIButton {
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let relativeFrame = self.bounds
            let hitTestEdgeInsets = UIEdgeInsetsMake(-10/masterRatio, -10/masterRatio, -10/masterRatio, -10/masterRatio)
            let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
            return hitFrame.contains(point)
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
        
        
        backButton = UIButton(type: .custom)
        __scaling__.addSubview(backButton!)
        backButton!.isHidden = true
        backButton!.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(100 / masterRatio)
            make.left.equalTo(0 / masterRatio)
            make.bottom.equalTo(__scaling__.snp.bottom)
        })
        backButton?.isExclusiveTouch = true
        backButton?.contentMode = .center
        backButton?.setImage(UIImage(named: "back_button"), for: UIControlState())
        backButton?.addTarget(self, action: #selector(GRToolbar.actionBackButtonWasPressed(_:)), for: .touchUpInside)
        
        
        
        menuButton = UIButton(type: .custom)
        __scaling__.addSubview(menuButton!)
     
        menuButton?.showsTouchWhenHighlighted = false
        menuButton!.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100 / masterRatio)
            make.left.equalTo(self.snp.left).offset(21 / masterRatio)
            make.bottom.equalTo(__scaling__.snp.bottom)
        }
        
        menuButton!.contentMode = .center
        
        menuButton!.setImage(UIImage(named: "big_menu"), for: UIControlState())
        menuButton!.addTarget(self, action: #selector(GRToolbar.actionMenuButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["menuButton"] = menuButton
        
        
        grocerestButton = UIButton(type: .custom)
        __scaling__.addSubview(grocerestButton!)
        var imageGrocerestButton: UIImage!
        imageGrocerestButton = UIImage(named: "icon_grocerest")
        grocerestButton!.setBackgroundImage(imageGrocerestButton, for: UIControlState())
        grocerestButton!.contentMode = .scaleAspectFit
        grocerestButton?.setTitleColor(UIColor.white, for: UIControlState())
        grocerestButton?.titleLabel?.font = Constants.BrandFonts.ubuntuLight18
        grocerestButton!.isUserInteractionEnabled = false
        grocerestButton!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(50 / masterRatio)
            make.height.equalTo(45 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo((menuButton?.snp.centerY)!)
        }
        grocerestButton!.addTarget(self, action: #selector(GRToolbar.actionGrocerestButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["grocerestButton"] = grocerestButton
        
        triangleImageView = UIImageView()
        __scaling__.addSubview(triangleImageView!)
        triangleImageView?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(26 / masterRatio)
            make.height.equalTo(12 / masterRatio)
            make.centerY.equalTo((grocerestButton?.snp.centerY)!)
            make.right.equalTo((grocerestButton?.snp.right)!).offset(15 / masterRatio)
        })
        triangleImageView?.image = UIImage(named: "triangle")
        triangleImageView?.contentMode = .center
        triangleImageView?.isHidden = true
        
        let triangleButton = UIButton()
        __scaling__.addSubview(triangleButton)
        triangleButton.snp.makeConstraints { (make) in
            make.edges.equalTo((triangleImageView?.snp.edges)!)
        }
        triangleButton.addTarget(self, action: #selector(GRToolbar.actionGrocerestButtonWasPressed(_:)), for: .touchUpInside)
        

        
        
        searchButton = CustomButtonWithExtendedTouchArea(type: .custom)
        __scaling__.addSubview(searchButton!)
        searchButton!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(60 / masterRatio)
            make.height.equalTo(81 / masterRatio)
            make.right.equalTo(-20 / masterRatio)
            make.centerY.equalTo(menuButton!.snp.centerY)
        }
        searchButton!.contentMode = .center
        searchButton!.setImage(UIImage(named: "icon_search"), for: UIControlState())
        searchButton!.addTarget(self, action: #selector(GRToolbar.actionSearchButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["searchButton"] = searchButton
        
        
        scannerButton = CustomButtonWithExtendedTouchArea(type: .custom)
        __scaling__.addSubview(scannerButton!)
        scannerButton!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(60 / masterRatio)
            make.height.equalTo(81 / masterRatio)
            make.right.equalTo(searchButton!.snp.left).offset(-7)
            make.centerY.equalTo(menuButton!.snp.centerY)
        }
        scannerButton!.contentMode = .center
        scannerButton!.setImage(UIImage(named: "icon_scanner"), for: UIControlState())
        scannerButton!.addTarget(self, action: #selector(GRToolbar.actionScannerButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["scannerButton"] = scannerButton
        
        dotsMenu = UIButton(type: .custom)
        __scaling__.addSubview(dotsMenu!)
        dotsMenu?.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(90 / masterRatio)
            make.right.equalTo(searchButton!.snp.left).offset(-7)
            make.centerY.equalTo((menuButton?.snp.centerY)!)
        })
        dotsMenu?.contentMode = .center
        dotsMenu?.setImage(UIImage(named: "dots_menu"), for: UIControlState())
        dotsMenu?.isHidden = true
        dotsMenu?.addTarget(self, action: #selector(GRToolbar.actionDotsMenuWasPressed(_:)), for: .touchUpInside)
        
        
        settingsButton = UIButton(type: .custom)
        __scaling__.addSubview(settingsButton!)
        settingsButton?.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(40 / masterRatio)
            make.top.equalTo(34 / masterRatio)
            make.right.equalTo(31 / masterRatio)
        })
        
        settingsButton?.contentMode = .center
        settingsButton?.setImage(UIImage(named: "settings_button"), for: UIControlState())
        settingsButton?.addTarget(self, action: #selector(GRToolbar.actionSettingsButtonWasPressed(_:)), for: .touchUpInside)
        settingsButton?.isHidden = true
        
        
        self.viewsByName = viewsByName
        
    }

    
    func actionMenuButtonWasPressed(_ menuButton: UIButton) {
        delegate?.menuButtonWasPressed!(menuButton)
        //TODO: centralize menu controller
        print("menu was pressed")
        
    }
    
    func actionGrocerestButtonWasPressed(_ grocerestButton: UIButton) {
        print("grocerest was pressed")
        delegate?.grocerestButtonWasPressed?(grocerestButton)
    }
    
    
    func actionScannerButtonWasPressed(_ scannerButton: UIButton) {
        delegate?.scannerButtonWasPressed!(scannerButton)
    }
    
    func actionSearchButtonWasPressed(_ searchButton: UIButton) {
        delegate?.searchButtonWasPressed!(searchButton)
    }
    
    
    func actionBackButtonWasPressed(_ sender: UIButton) {
        delegate?.backButtonWasPressed!(sender)
    }
    
    func isThisBarWithTitle(_ hasTitle: Bool, title: String) {
        
        settingsButton?.isHidden = true
        grocerestButton!.isUserInteractionEnabled = true
        
        if hasTitle == true {
            grocerestButton?.setBackgroundImage(nil, for: UIControlState())
            grocerestButton?.setTitle(title, for: UIControlState())
            grocerestButton!.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(131)
                make.height.equalTo(22.5)
                make.centerX.equalTo(self.snp.centerX)
                make.centerY.equalTo((menuButton?.snp.centerY)!)
            }
            
            
            viewsByName["searchButton"]!.snp.remakeConstraints { (make) -> Void in
                make.height.equalTo(40.05)
                make.right.equalTo(-10)
                make.centerY.equalTo(grocerestButton!.snp.centerY)
            }
            
            
            viewsByName["scannerButton"]!.snp.remakeConstraints{ (make) -> Void in
                make.height.equalTo(40.05)
                make.right.equalTo(viewsByName["searchButton"]!.snp.left).offset(-10)
                make.centerY.equalTo(grocerestButton!.snp.centerY)
            }
            
        }
    }
    
    func isThisBarWithBackButton(_ hasBackButton: Bool, title: String) {
        
        grocerestButton!.isUserInteractionEnabled = true
        
        if hasBackButton == true {
            
            backButton!.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(0 / masterRatio)
                make.top.equalTo(self.snp.top).offset(9 / masterRatio)
                make.width.equalTo(80 / masterRatio)
                make.height.equalTo(150 / masterRatio)
            })
            backButton?.contentMode = .center
            
            
            viewsByName["menuButton"]!.snp.remakeConstraints{ (make) -> Void in
                make.width.equalTo(80 / masterRatio)
                make.height.equalTo(100 / masterRatio)
                make.left.equalTo(backButton!.snp.right).offset(6 / masterRatio)
                make.centerY.equalTo((backButton?.snp.centerY)!)
                
            }

            
            grocerestButton?.setBackgroundImage(nil, for: UIControlState())
            grocerestButton?.setTitle(title, for: UIControlState())
            grocerestButton?.titleLabel?.lineBreakMode = .byTruncatingTail
            
            grocerestButton!.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(415 / masterRatio)
                make.centerX.equalTo(self.snp.centerX)
                make.centerY.equalTo((backButton?.snp.centerY)!)
            }
            
            
            dotsMenu?.snp.remakeConstraints({ (make) -> Void in
                make.width.height.equalTo(90 / masterRatio)
                make.right.equalTo(-7)
                make.centerY.equalTo((backButton?.snp.centerY)!)
            })
            
            /// Make backButton Visible
            
            backButton?.isHidden = false
            triangleImageView?.isHidden = false
            dotsMenu?.isHidden = false
            scannerButton?.isHidden = true
        }
    }
    
    
    
    func isThisBarWithBackButtonAndGrocerestButton(_ hasBackButton: Bool) {
        
        grocerestButton!.isUserInteractionEnabled = false
        
        if hasBackButton == true {
            
            backButton!.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(0 / masterRatio)
                make.top.equalTo(self.snp.top).offset(9 / masterRatio)
                make.width.equalTo(80 / masterRatio)
                make.height.equalTo(150 / masterRatio)
            })
            backButton?.contentMode = .center
            
            
            viewsByName["menuButton"]!.snp.remakeConstraints{ (make) -> Void in
                make.width.equalTo(55 / masterRatio)
                make.height.equalTo(100 / masterRatio)
                make.left.equalTo(backButton!.snp.right).offset(6 / masterRatio)
                make.centerY.equalTo(backButton!.snp.centerY)
                
            }
         
            
            /// Make backButton Visible
            
            backButton?.isHidden = false
            triangleImageView?.isHidden = true
            dotsMenu?.isHidden = true
            scannerButton?.isHidden = false
        }
    }
    
    
    
    func isThisBarForDetailViewWithBackButton(_ hasBackButton: Bool, title: String) {
        
        grocerestButton!.isUserInteractionEnabled = true
        
        if hasBackButton == true {
            
          
            
            grocerestButton?.setBackgroundImage(nil, for: UIControlState())
            grocerestButton?.setTitle(title, for: UIControlState())
            grocerestButton?.titleLabel?.lineBreakMode = .byTruncatingTail
            
            grocerestButton!.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(415 / masterRatio)
                make.height.equalTo(31 / masterRatio)
                make.centerX.equalTo(self.snp.centerX)
                make.top.equalTo(self.snp.top).offset(78 / masterRatio)
            }
            
            backButton!.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(0 / masterRatio)
                make.centerY.equalTo(grocerestButton!.snp.centerY)
                make.width.equalTo(80 / masterRatio)
                make.height.equalTo(150 / masterRatio)
            })
            backButton?.contentMode = .center
            
            
            viewsByName["menuButton"]!.snp.remakeConstraints{ (make) -> Void in
                make.width.equalTo(80 / masterRatio)
                make.height.equalTo(100 / masterRatio)
                make.left.equalTo(backButton!.snp.right).offset(6 / masterRatio)
                make.centerY.equalTo(grocerestButton!.snp.centerY)
                
            }
            
            
            scannerButton?.snp.remakeConstraints({ (make) -> Void in
                make.height.equalTo(40.05)
                make.left.equalTo(grocerestButton!.snp.right).offset(10)
                make.centerY.equalTo(grocerestButton!.snp.centerY)
            })
            
            searchButton?.snp.remakeConstraints({ (make) -> Void in
                make.width.equalTo(30)
                make.height.equalTo(40.05)
                make.left.equalTo(scannerButton!.snp.right).offset(10)
                make.centerY.equalTo(grocerestButton!.snp.centerY)
            })
            
            /// Make backButton Visible
            
            backButton?.isHidden = false
            triangleImageView?.isHidden = true
            dotsMenu?.isHidden = true
            scannerButton?.isHidden = false
            searchButton?.isHidden = false
        }
    }
    
    

    
    func actionDotsMenuWasPressed(_ sender: UIButton) {
        delegate?.moreActionsForListWasPressed!(sender)
    }
    
    func actionSettingsButtonWasPressed(_ sender:UIButton) {
        delegate?.settingsButtonWasPressed!(sender)
    }
    
   
    
    func repositionDotsMenu(){
        self.searchButton?.isHidden = true
        self.dotsMenu?.snp.remakeConstraints({ (make) -> Void in
            make.width.height.equalTo(90 / masterRatio)
            make.right.equalTo(-14 / masterRatio)
            make.centerY.equalTo((self.menuButton?.snp.centerY)!)
        })
        
    }
    
    
}
