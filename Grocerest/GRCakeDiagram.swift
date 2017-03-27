//
//  GRCakeDiagram.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 31/08/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

/**
 Hollow cake chart widget.
 To be put under the categories tab in user's profile.
 */
@IBDesignable
class GRCakeDiagram: UIView {
    
    /**
     The data used to populate the cake diagram. Each number has
     also an associated color used to draw its corresponding slice.
     */
    var values = [(Int, UIColor)]() { didSet { setNeedsDisplay() } }
    /**
     The name of the diagram, written under the total in the center.
     */
    var name: String = "" { didSet { setNeedsDisplay() } }
    
    fileprivate let totalLabel = UILabel()
    fileprivate let nameLabel = UILabel()

    required init?(coder: NSCoder) { // called on Device
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) { // called in InterfaceBuilder
        super.init(frame: frame)
        setup()
    }
    
    fileprivate func setup() {
        // Transparent background (can be also set by unchecking
        // "opaque" option in interface builder's attributes inspector)
        backgroundColor = UIColor.clear
        
        /*
            TODO: figure out why without adding an UIView the UIStack
            doesn't center itself.
        */
        let contentView = UIView()
        addSubview(contentView)
        
        let labelStack = UIStackView()
        labelStack.backgroundColor = UIColor.red
        labelStack.axis = .vertical
        labelStack.alignment = .center
        addSubview(labelStack)
        
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
        }
        
        totalLabel.text = "0"
        totalLabel.textColor = UIColor.white
        totalLabel.font = UIFont.ubuntuMedium(72)
        labelStack.addArrangedSubview(totalLabel)
        
        nameLabel.text = ""
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.avenirBook(28)
        labelStack.addArrangedSubview(nameLabel)
    }
    
    override var intrinsicContentSize : CGSize {
        return CGSize(width: 380 / masterRatio, height: 380 / masterRatio)
    }
    
    override func draw(_ rect: CGRect) {
        let pi =  CGFloat(M_PI)
        let total = values.reduce(0) { sum, value in
            let (number, _) = value
            return sum + number
        }
        
        let arcCenter = CGPoint(x: rect.midX, y: rect.midY)
        let arcLineWidth: CGFloat = 60 / masterRatio
        // The radius is chosen so that arcs do not overlap the frame margins
        let arcRadius = min(rect.size.height, rect.size.width) / 2 - arcLineWidth / 2
        /*
         We start drawing the arcs from the center-top and we then
         proceed clockwise.
        */
        var arcStartAngle = -pi/2
        /*
         Last endAngle used to draw the previous arc. Initially
         we haven't drawn any arcs so it's equal to the start angle.
        */
        var arcEndAngle = arcStartAngle
        
        if total > 0 {
            // Renders each slice of the cake
            for value in values {
                let (partial, color) = value
                /*
                 percentage = (value / total) * 100
                 
                 with 360 to draw only a fraction of the circle.
                 I let out the '* 100' so i can multiply it
                 */
                let arcLength = 2*pi * CGFloat(partial) / CGFloat(total)
                arcEndAngle += arcLength
                
                // Draws the arc
                let arc = UIBezierPath(arcCenter: arcCenter, radius: arcRadius, startAngle: arcStartAngle, endAngle: arcEndAngle, clockwise: true)
                color.setStroke()
                arc.lineWidth = arcLineWidth
                arc.stroke()
                
                // The next arc starts at the end of this one
                arcStartAngle = arcEndAngle
            }

        } else {
            // Draws a grey full circle
            arcEndAngle += 2*pi
            let arc = UIBezierPath(arcCenter: arcCenter, radius: arcRadius, startAngle: arcStartAngle, endAngle: arcEndAngle, clockwise: true)
            UIColor(hexString: "686868").setStroke()
            arc.lineWidth = arcLineWidth
            arc.stroke()
        }
        
        totalLabel.text = "\(total)"
        nameLabel.text = name
    }
    
    override func prepareForInterfaceBuilder() {
        self.values = [
            (2, UIColor.green),
            (4, UIColor.blue),
            (12, UIColor.magenta),
            (5, UIColor.brown)
        ]
        self.name = "recensioni"
    }
    
}
