//
//  GRCheckbox.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import UIKit

@IBDesignable
class GRCheckbox: UIButton {
    
    var delegate: GRCheckboxProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, title: String, selected: Bool) {
        super.init(frame:frame)
        self.adjustEdgeInsets()
        self.applyStyle()
        self.contentMode = .scaleAspectFit
        self.setTitle(title, for: UIControlState())
        self.addTarget(self, action: #selector(GRCheckbox.onTouchUpInside(_:)), for: .touchUpInside)
    }
    
    
    func adjustEdgeInsets() {
        let lLeftInset: CGFloat = 8.0
        self.contentHorizontalAlignment = .left
        self.imageEdgeInsets  = UIEdgeInsetsMake(0.0 as CGFloat, lLeftInset, 0.0 as CGFloat, 0.0 as CGFloat)
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0 as CGFloat, (lLeftInset * 2), 0.0 as CGFloat, 0.0 as CGFloat)
    }
    
    func applyStyle() {
        self.setImage(UIImage(named: "checkbox_selected"), for: .selected)
        self.setImage(UIImage(named: "white_checkbox"), for: UIControlState())
        self.setTitleColor(UIColor.black, for: UIControlState())
    }
    
    func onTouchUpInside(_ sender: UIButton) {
        self.isSelected = !self.isSelected
        delegate?.didSelectCheckbox(self.isSelected, identifier: self.tag, title: (self.titleLabel?.text)!)
    }
    
    
    
}
