//
//  GRStatProgress.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 24/08/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRStatProgress: UIView {
    
    fileprivate let circle = GRProgressCircle()
    fileprivate let icon = UIImageView()
    fileprivate let dots = UIStackView()
    fileprivate let currentScoreLabel = UILabel()
    fileprivate let totalScoreLabel = UILabel()
    fileprivate let nameLabel = UILabel()
    
    /**
        Progress circle color
     */
    @IBInspectable var circleColor: UIColor! {
        didSet {
            circle.circleColor = circleColor
        }
    }
    
    /**
        Must be between 0 and 100
     */
    @IBInspectable var progress: Int = 0 {
        didSet {
            if progress < 0 { circle.progress = 0 }
            else if progress > 100 { circle.progress = 100 }
            else { circle.progress = CGFloat(progress) / 100 }
        }
    }
    
    /**
        Changes the icon in the center of the circle
     */
    @IBInspectable var statIcon: UIImage? {
        didSet {
            icon.image = statIcon
        }
    }
    
    @IBInspectable var dotsColor: UIColor = UIColor(hexString: "E53554") {
        didSet {
            updateLevelDots()
        }
    }
    
    fileprivate func updateLevelDots() {
        for (index, dot) in dots.arrangedSubviews.enumerated() {
            if level >= index+1 {
                dot.backgroundColor = dotsColor
            } else {
                dot.backgroundColor = UIColor(hexString: "686868")
            }
        }
    }
    
    /**
        Must be between 0 and 3
     */
    @IBInspectable var level: Int = 0 {
        didSet {
            updateLevelDots()
        }
    }
    
    /**
        Stat's name
     */
    @IBInspectable var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    
    @IBInspectable var currentScore: Int = 0 {
        didSet {
            currentScoreLabel.text = "\(currentScore)"
        }
    }
    
    @IBInspectable var totalScore: Int = 0 {
        didSet {
            totalScoreLabel.text = "/\(totalScore)"
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
    
    func setupHierarchy() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints { make in
            make.height.equalTo(210 / masterRatio)
            make.width.equalTo(200 / masterRatio)
        }
        
        // CIRCLE
        
        circle.bgCircleColor = UIColor(hexString: "686868")
        circle.bgCircleLineWidth = 2 / masterRatio
        circle.circleColor = UIColor(hexString: "E53554")
        circle.circleLineWidth = 6 / masterRatio
        addSubview(circle)
        
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.snp.makeConstraints { make in
            make.width.height.equalTo(110 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top)
        }
        
        // ICON
        
        icon.contentMode = .scaleAspectFit
        addSubview(icon)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(74 / masterRatio)
            make.center.equalTo(circle.snp.center)
        }
        
        // DOTS
        
        dots.spacing = 10 / masterRatio
        addSubview(dots)
        
        dots.translatesAutoresizingMaskIntoConstraints = false
        dots.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(circle.snp.bottom).offset(11 / masterRatio)
        }
        
        for _ in 1...3 {
            let dot = UIView()
            dot.backgroundColor = UIColor(hexString: "686868")
            dot.layer.cornerRadius = 6 / masterRatio
            dots.addArrangedSubview(dot)
            
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.snp.makeConstraints { make in
                make.width.height.equalTo(12 / masterRatio)
            }
        }
        
        // SCORE
        
        let scoreLabels = UIStackView()
        scoreLabels.alignment = .firstBaseline
        addSubview(scoreLabels)
        
        scoreLabels.translatesAutoresizingMaskIntoConstraints = false
        scoreLabels.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(dots.snp.bottom).offset(10 / masterRatio)
        }
        
        currentScoreLabel.textColor = UIColor.white
        currentScoreLabel.font = Constants.BrandFonts.ubuntuMedium20
        
        totalScoreLabel.textColor = UIColor.white
        totalScoreLabel.font = Constants.BrandFonts.avenirMedium10
        
        scoreLabels.addArrangedSubview(currentScoreLabel)
        scoreLabels.addArrangedSubview(totalScoreLabel)
        
        // NAME
        
        nameLabel.textColor = UIColor.white
        nameLabel.font = Constants.BrandFonts.avenirBook11
        addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(scoreLabels.snp.bottom).offset(-6 / masterRatio)
        }
    }
    
    func replayAnimation() {
        self.circle.animateCircle()
    }
    
}
