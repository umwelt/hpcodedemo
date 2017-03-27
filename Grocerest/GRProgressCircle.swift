//
//  LayerCircle.swift
//  StatWidget
//
//  Created by Hugo Adolfo Perez Solorzano on 22/08/16.
//  Copyright © 2016 Grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRProgressCircle: UIView {
    
    @IBInspectable var bgCircleColor: UIColor = UIColor.black
    @IBInspectable var bgCircleLineWidth: CGFloat = 1.0
    @IBInspectable var circleColor: UIColor = UIColor.green {
        didSet {
            circleLayer.strokeColor = circleColor.cgColor
        }
    }
    @IBInspectable var circleLineWidth: CGFloat = 5.0
    /**
     Must be between 0 and 1
     */
    @IBInspectable var progress: CGFloat = 0 { didSet { animateCircle() } }
    
    fileprivate var bgCircleLayer: CAShapeLayer! = CAShapeLayer()
    fileprivate var circleLayer: CAShapeLayer! = CAShapeLayer()
    
    required init?(coder: NSCoder) { // called on Device
        super.init(coder: coder)
        setupHierarchy()
    }
    
    override init(frame: CGRect) { // called in InterfaceBuilder
        super.init(frame: frame)
        setupHierarchy()
    }
    
    func setupHierarchy() {
        layer.addSublayer(bgCircleLayer)
        layer.addSublayer(circleLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutUpdate()
        animateCircle()
    }
    
    func layoutUpdate() {
        let center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let radius = min(frame.size.width / 2, frame.size.height / 2) - circleLineWidth / 2
        
        func degreesToRadians(_ angle: Int) -> CGFloat {
            return CGFloat(angle) * CGFloat(M_PI) / 180
        }
        
        let bgCircle = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -degreesToRadians(90),
            endAngle: degreesToRadians(270),
            clockwise: true
        )
        
        bgCircleLayer.path = bgCircle.cgPath
        bgCircleLayer.fillColor = UIColor.clear.cgColor
        bgCircleLayer.strokeColor = bgCircleColor.cgColor
        bgCircleLayer.lineWidth = bgCircleLineWidth;
        bgCircleLayer.strokeEnd = 1.0
        
        let circle = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -degreesToRadians(90),
            endAngle: degreesToRadians(270),
            clockwise: true
        )
        
        circleLayer.path = circle.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = circleColor.cgColor
        circleLayer.lineWidth = circleLineWidth
        circleLayer.lineCap = "round"
        circleLayer.strokeEnd = 0.0
    }
    
    func animateCircle() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.fromValue = 0
        animation.toValue = progress
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        circleLayer.strokeEnd = progress
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
}
