//
//  GRDocumentsView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/03/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit
import SnapKit



@IBDesignable
class GRDocumentsView: UIView {
    var viewsByName: [String: UIView]!
    var navigationToolBar : GRToolbar?
  
    
    
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
    weak var delegate = GRDocumentsViewController()
    
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
        
        __scaling__.backgroundColor = UIColor.white
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        
        navigationToolBar = GRToolbar()
        navigationToolBar!.isThisBarWithTitle(true, title:Constants.AppLabels.ToolBarLabels.myLists)
        self.addSubview(navigationToolBar!)
        navigationToolBar!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.left.equalTo(0)
        }
        
        
        
    
        
        
        self.viewsByName = viewsByName
        
    }
}


