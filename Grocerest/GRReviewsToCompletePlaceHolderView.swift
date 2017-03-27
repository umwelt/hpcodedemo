//
//  GRReviewsToCompletePlaceHolderView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 04/11/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRReviewsToCompletePlaceHolderView: UIView {
    
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
    }
    
    let cellSize = CGSize(width: 284 / masterRatio, height: 320 / masterRatio)
    


    
    func setupHierarchy() {
        
        let reviewPlaceHolder = UIImageView(image: UIImage(named: "homecellBack"))
        addSubview(reviewPlaceHolder)
        reviewPlaceHolder.snp.makeConstraints { (make) in
            make.size.equalTo(cellSize)
            make.left.equalTo(32 / masterRatio)
            make.top.equalTo(0)
            
        }
        
        let reviewPlaceHolder1 = UIImageView(image: UIImage(named: "homecellBack"))
        addSubview(reviewPlaceHolder1)
        reviewPlaceHolder1.snp.makeConstraints { (make) in
            make.size.equalTo(cellSize)
            make.left.equalTo(reviewPlaceHolder.snp.right).offset(20 / masterRatio)
            make.top.equalTo(0)
            
        }
        
        let reviewPlaceHolder2 = UIImageView(image: UIImage(named: "homecellBack"))
        addSubview(reviewPlaceHolder2)
        reviewPlaceHolder2.snp.makeConstraints { (make) in
            make.size.equalTo(cellSize)
            make.left.equalTo(reviewPlaceHolder1.snp.right).offset(20 / masterRatio)
            make.top.equalTo(0)
            
        }

    }
}

