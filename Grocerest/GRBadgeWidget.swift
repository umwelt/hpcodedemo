//
//  GRBadgeWidget.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 08/09/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRBadgeWidget: UIView {
    
    fileprivate let label = UILabel()
    fileprivate let juniorBadge = GRBadge()
    fileprivate let seniorBadge = GRBadge()
    fileprivate let topBadge = GRBadge()
    
    var title: String = "" {
        didSet {
            label.text = title
        }
    }
    
    var counters: [Int] = [0, 0, 0] {
        didSet {
            if counters.count == 3 {
                juniorBadge.count = counters[0]
                seniorBadge.count = counters[1]
                topBadge.count = counters[2]
            }
        }
    }
    
    var backgrounds: [UIImage?]? { didSet { update() } }
    fileprivate let defaultBackgrounds = [
        UIImage(named: "stat-badge-default-on-junior"),
        UIImage(named: "stat-badge-default-on-senior"),
        UIImage(named: "stat-badge-default-on-top")
    ]
    fileprivate let backgroundsOff = [
        UIImage(named: "stat-badge-default-off-junior"),
        UIImage(named: "stat-badge-default-off-senior"),
        UIImage(named: "stat-badge-default-off-top")
    ]
    
    var iconOn: UIImage? { didSet { update() } }
    var iconOff: UIImage? { didSet { update() } }
    
    var level: Int = 0 { didSet { update() } }
    
    fileprivate func update() {
        let badges = [juniorBadge, seniorBadge, topBadge]
        
        for (i, badge) in badges.enumerated() {
            if i+1 <= level {
                badge.icon = iconOn
                badge.counterColor = UIColor.white
                if backgrounds != nil {
                    badge.badge = backgrounds![i]
                } else {
                    badge.badge = defaultBackgrounds[i]
                }
            } else {
                badge.icon = iconOff
                badge.counterColor = UIColor(hexString: "4A4A4A")
                badge.badge = backgroundsOff[i]
            }
        }
    }
    
    required init?(coder: NSCoder) { // called on Device
        super.init(coder: coder)
        setupHierarchy()
    }
    
    override init(frame: CGRect) { // called in InterfaceBuilder
        super.init(frame: frame)
        setupHierarchy()
    }
    
    fileprivate func setupHierarchy() {
        label.font = UIFont.avenirBook(20)
        label.textColor = UIColor(hexString: "979797")
        label.numberOfLines = 2
        label.text = ""
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.snp.makeConstraints { make in
            make.top.left.equalTo(self)
            make.width.equalTo(155 / masterRatio)
        }
        
        addSubview(juniorBadge)
        juniorBadge.translatesAutoresizingMaskIntoConstraints = false
        juniorBadge.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self.snp.left).offset(152 / masterRatio)
        }
        
        addSubview(seniorBadge)
        seniorBadge.translatesAutoresizingMaskIntoConstraints = false
        seniorBadge.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(juniorBadge.snp.right).offset(17 / masterRatio)
        }
        
        addSubview(topBadge)
        topBadge.translatesAutoresizingMaskIntoConstraints = false
        topBadge.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(seniorBadge.snp.right).offset(22 / masterRatio)
        }
        
        // VIEW ITSELF
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints { make in
            make.right.equalTo(topBadge.snp.right)
            make.height.equalTo(160 / masterRatio)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        title = "Recensioni"
        counters = [100, 200, 300]
        iconOn = UIImage(named: "stat-light-edit-icon")
        iconOff = UIImage(named: "stat-dark-edit-icon")
        level = 2
    }
    
}
