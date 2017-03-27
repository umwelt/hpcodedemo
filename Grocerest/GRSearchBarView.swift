//
//  GRSearchBarView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 10/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class GRSearchBarView: UIView {
    
    let productsCounter = UILabel()
    var delegate : GRSearchBarProtocol?
    var searchField : UITextField?
    
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
        
        // backgroundColor = UIColor.whiteColor()
        self.clipsToBounds = true
        super.layoutSubviews()
        
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
        
        let closeButton = CustomButtonWithExtendedTouchArea(type: .custom)
        addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(44.5 / masterRatio)
            make.height.equalTo(89 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(22 / masterRatio)
        }
        
        closeButton.addTarget(self, action: #selector(GRSearchBarView.actionCloseButtonWasPressed(_:)), for: .touchUpInside)
        closeButton.adjustsImageWhenHighlighted = true
        closeButton.setImage(UIImage(named: "back_lampone"), for: UIControlState())
        
        
        let searchIcon = UIImageView()
        addSubview(searchIcon)
        searchIcon.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(44.5 / masterRatio)
            make.height.equalTo(89 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(closeButton.snp.right).offset(12 / masterRatio)
        }
        searchIcon.contentMode = .center
        searchIcon.image = UIImage(named: "off-search-icon")
        
        
        searchField = UITextField()
        addSubview(searchField!)
        searchField!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(570 / masterRatio)
            make.height.equalTo(80 / masterRatio)
            make.centerY.equalTo(searchIcon.snp.centerY)
            make.left.equalTo(searchIcon.snp.right).offset(25 / masterRatio)
        }
        searchField?.returnKeyType = .search
        searchField?.placeholder = "Cerca Prodotto"
        searchField?.clearButtonMode = .always
        searchField?.autocorrectionType = .yes
        searchField?.autocapitalizationType = .none
        
        
        let separator = UIView()
        addSubview(separator)
        separator.backgroundColor = UIColor.white
        separator.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(0.5)
            make.top.equalTo(self.snp.bottom)
            make.left.equalTo(0)
            
        }
        
    }
    
    
    func actionCloseButtonWasPressed(_ sender:UIButton) {
        delegate?.closeButtonWasPressed(sender)
    }
    
}
