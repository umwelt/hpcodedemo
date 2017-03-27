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
class GRBadge: UIView {
    
    fileprivate let badgeImageView = UIImageView()
    fileprivate let iconImageView = UIImageView()
    fileprivate let counterLabel = UILabel()
    
    var count: Int = 0 {
        didSet {
            counterLabel.text = "\(count)"
        }
    }
    
    var counterColor: UIColor? {
        didSet {
            counterLabel.textColor = counterColor
        }
    }
    
    var badge: UIImage? {
        didSet {
            badgeImageView.image = badge
        }
    }
    
    var icon: UIImage? {
        didSet {
            iconImageView.image = icon
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
        badgeImageView.image = UIImage(named: "stat-badge-default-off-junior-disabled")
        addSubview(badgeImageView)
        badgeImageView.translatesAutoresizingMaskIntoConstraints = false
        badgeImageView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        counterLabel.font = UIFont.ubuntuMedium(20)
        counterLabel.textColor = UIColor(hexString: "4A4A4A")
        counterLabel.text = "0"
        addSubview(counterLabel)
        
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(13 / masterRatio)
        }
        
        // VIEW ITSELF
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints { make in
            make.width.equalTo(164 / masterRatio)
            make.height.equalTo(160 / masterRatio)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        self.icon = UIImage(named: "stat-dark-icon-Alimentari")
    }

}
