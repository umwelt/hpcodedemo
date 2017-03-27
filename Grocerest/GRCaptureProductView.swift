//
//  GRCaptureProductView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 05/02/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRCaptureProductView: UIView {
    var delegate = GRCaptureProductViewController()
    var backView = UIScrollView()
    
    
    
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
    }
    
    func setupHierarchy() {
        self.backgroundColor = UIColor.clear
    }
    
    func actionCaptureButtonWasPressed(_ sender:UIButton) {
        delegate.saveToCamera(sender)
    }
    
}


