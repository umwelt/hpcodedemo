//
//  GRCustomButtons.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 22/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation


class GRShineButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            if newValue {
                self.alpha = 0.5
            } else {
                UIView.animate(withDuration: 0.3, animations: { 
                    self.alpha = 1.0
                })
            }
        }
        get {
            return super.isHighlighted
        }
        
    }
    
    
}
