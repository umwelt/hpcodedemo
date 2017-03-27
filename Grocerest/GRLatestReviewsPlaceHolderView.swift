//
//  GRLatestReviewsPlaceHolderView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 04/11/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRLatestReviewsPlaceHolderView: UIView {
    
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
    
    let cellSize = CGSize(width: 750 / masterRatio, height: 390 / masterRatio)
    
    
    
    
    func setupHierarchy() {
        
        let reviewPlaceHolder = UIImageView(image: UIImage(named: "lastReviewBack"))
        addSubview(reviewPlaceHolder)
        reviewPlaceHolder.snp.makeConstraints { (make) in
            make.size.equalTo(cellSize)
            make.left.equalTo(0)
            make.top.equalTo(0)
            
        }
        
        let reviewPlaceHolder1 = UIImageView(image: UIImage(named: "lastReviewBack"))
        addSubview(reviewPlaceHolder1)
        reviewPlaceHolder1.snp.makeConstraints { (make) in
            make.size.equalTo(cellSize)
            make.left.equalTo(0)
            make.top.equalTo(reviewPlaceHolder.snp.bottom).offset(20 / masterRatio)
            
        }
        
        let reviewPlaceHolder2 = UIImageView(image: UIImage(named: "lastReviewBack"))
        addSubview(reviewPlaceHolder2)
        reviewPlaceHolder2.snp.makeConstraints { (make) in
            make.size.equalTo(cellSize)
            make.left.equalTo(0)
            make.top.equalTo(reviewPlaceHolder1.snp.bottom).offset(20 / masterRatio)
            
        }
        
    }
}


