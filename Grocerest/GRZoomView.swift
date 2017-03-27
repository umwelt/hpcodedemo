//
//  GRZoomView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 25/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRZoomView: UIView {
    var zoomedImageView = UIImageView()
    var delegate = GRZoomViewController()
    var backView = UIScrollView()
    let imageSize = CGSize(width: 450 / masterRatio, height: 450 / masterRatio)
    

    
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
        
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        backView = UIScrollView()
        addSubview(backView)
        backView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(self)
            make.center.equalTo(self.snp.center)
        }
        backView.backgroundColor = UIColor.white

        
        
        zoomedImageView = UIImageView()
        backView.addSubview(zoomedImageView)
        
        
        zoomedImageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(imageSize)
        }
        zoomedImageView.contentMode = .scaleAspectFit


    }

}

