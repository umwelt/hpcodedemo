//
//  GRLastReviews.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRLastReviews: UIView {
    
    
    var lastReviews : [GRLastReview] = []
    fileprivate let rows = UIStackView()
    
    var reviews = [JSON]() {
        didSet {
            if reviews.isEmpty { return }
            
            for view in rows.arrangedSubviews {
                rows.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            
            for review in reviews {
                let lastReview = GRLastReview()
                lastReview.populateWith(review)
                lastReviews.append(lastReview)
                rows.addArrangedSubview(lastReview)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialization()
    }
    
    fileprivate func initialization() {
        rows.axis = .vertical
        rows.spacing = 12 / masterRatio
        addSubview(rows)
        rows.snp.makeConstraints { make in
            make.top.bottom.left.equalTo(self)
        }
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints { make in
            make.edges.equalTo(rows)
        }
        
        for _ in 1...3 {
            let placeholder = UIImageView(image: UIImage(named: "lastReviewBack"))
            rows.addArrangedSubview(placeholder)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        for _ in 1...3 {
            let lastReview = GRLastReview()
            lastReview.prepareForInterfaceBuilder()
            rows.addArrangedSubview(lastReview)
        }
    }
    
}
