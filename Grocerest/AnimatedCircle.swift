//
//  AnimatedCircle.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 22/04/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

class AnimatedCircle: UIView {
    
    let circlePathLayer = CAShapeLayer()
    let circleRadius: CGFloat = 54.00 / masterRatio
    var category = ""
    var duration : TimeInterval = 1.5
    
    var progress: CGFloat {
        
        
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                animateCircle(duration, lastValue: 1)
            } else if (newValue < 0) {
                animateCircle(duration, lastValue: 0)
            } else {
                animateCircle(duration, lastValue: newValue)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        progress = 0
        circlePathLayer.frame = bounds
        
        circlePathLayer.lineWidth = 4
        circlePathLayer.fillColor = UIColor.clear.cgColor
        circlePathLayer.strokeColor = colorForCategory(category).cgColor
        layer.addSublayer(circlePathLayer)
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x = circlePathLayer.bounds.midX - circleFrame.midX
        circleFrame.origin.y = circlePathLayer.bounds.midY - circleFrame.midY
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: circleRadius, startAngle: CGFloat(-M_PI_2), endAngle:  CGFloat((M_PI * 2.0) - M_PI_2), clockwise: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.cornerRadius = 10
        circlePathLayer.path = circlePath().cgPath
    }
    
    func reveal() {
        
        backgroundColor = UIColor.clear
        progress = 1
        circlePathLayer.removeAnimation(forKey: "strokeEnd")
        circlePathLayer.removeFromSuperlayer()
        superview?.layer.mask = circlePathLayer
    }
    
    func setColorForCategorie(_ category:String) {
        circlePathLayer.strokeColor = colorForCategory(category).cgColor
        circlePathLayer.lineCap = "round"
    }
    
    
    func animateCircle(_ duration: TimeInterval, lastValue:CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = lastValue
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        
        circlePathLayer.strokeEnd = lastValue
        circlePathLayer.add(animation, forKey: "animateCircle")
    }
    
    

    
    

}


