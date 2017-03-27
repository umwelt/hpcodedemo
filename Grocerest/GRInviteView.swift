//
//  GRInviteView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 18/03/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRInviteView: UIView {
    
    var viewsByName: [String: UIView]!
    var searchTextField: UITextField?
    var bottomButton : UIButton?
    var addFriendsLabel : UILabel?
    
    var delegate : GRInviteProtocol?
    
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
        __scaling__.backgroundColor = UIColor.white
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        let closeButton = UIButton()
        __scaling__.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(56 / masterRatio)
            make.top.equalTo(78 / masterRatio)
            make.right.equalTo(-40 / masterRatio)
        }
        closeButton.setImage(UIImage(named: "close_modal"), for: UIControlState())
        closeButton.contentMode = .center
        closeButton.addTarget(self, action: #selector(GRInviteView.actionCloseButtonWasPressed(_:)), for: .touchUpInside)
        
        let items = ["Invita"]
        let segmentedButton = UISegmentedControl(items: items)
        segmentedButton.selectedSegmentIndex = 0
        segmentedButton.tintColor = UIColor.grocerestColor()
        segmentedButton.layer.cornerRadius = 4
        segmentedButton.backgroundColor = UIColor.clear
        __scaling__.addSubview(segmentedButton)
        segmentedButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(368 / masterRatio)
            make.height.equalTo(48 / masterRatio)
            make.centerX.equalTo(__scaling__.snp.centerX)
            make.top.equalTo(78 / masterRatio)
        }
        
        let searchView = UIView()
        __scaling__.addSubview(searchView)
        searchView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(106 / masterRatio)
            make.top.equalTo(segmentedButton.snp.bottom).offset(32 / masterRatio)
            make.centerX.equalTo(__scaling__.snp.centerX)
        }
        
        let searchIcon = UIImageView()
        searchView.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(28 / masterRatio)
            make.left.top.equalTo(34 / masterRatio)
        }
        searchIcon.contentMode = .center
        searchIcon.image = UIImage(named: "blue_search")
        
        searchTextField = UITextField()
        searchView.addSubview(searchTextField!)
        searchTextField?.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(searchIcon.snp.right).offset(24 / masterRatio)
            make.width.equalTo(600 / masterRatio)
            make.height.equalTo(searchView.snp.height)
            make.centerY.equalTo(searchView.snp.centerY)
        })
        searchTextField?.placeholder = "Cerca amico"
        searchTextField?.font = Constants.BrandFonts.avenirBook15
        searchTextField?.textColor = UIColor.grocerestLightGrayColor()
        searchTextField?.textAlignment = .left
        searchTextField?.keyboardType = .asciiCapable
        searchTextField?.returnKeyType = .go
        searchTextField?.clearButtonMode = .always
        
        
        
        bottomButton = UIButton()
        __scaling__.addSubview(bottomButton!)
        bottomButton!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(112 / masterRatio)
            make.bottom.equalTo(0)
        }
        bottomButton!.backgroundColor = UIColor.grocerestBlue()
        bottomButton!.isHidden = true
        bottomButton?.addTarget(self, action: Selector("actionBottomButtonWasPressed:"), for: .touchUpInside)

        self.viewsByName = viewsByName
        
    }
    
    func actionCloseButtonWasPressed(_ sender:UIButton) {
        delegate?.closeButtonWasPressed(sender)
    }
    

    
    
}
