//
//  GRAutocompletionView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 14/04/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation


class AutoCompletionView: UIView {
    
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
        super.layoutSubviews()
    }
    
    
    
    func setupHierarchy() {
    }
}
