//
//  GRAlertView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 22/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//


import Foundation
import UIKit

@objc public protocol AlertViewProtocol {
     @objc optional func confirmWasPressed(_ sender:UIButton)
     @objc optional func completedAction()
}

class GRAlertView: UIView {
    
    var delegate: AlertViewProtocol!
    var message = UILabel()
    
    var confirmButton: GRShineButton {
        let button = GRShineButton()
        addSubview(button)
        button.setTitle("Ok", for: UIControlState())
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        button.layer.cornerRadius = (8 / masterRatio)
        button.layer.borderWidth = 2 / masterRatio
        button.layer.borderColor = UIColor.grocerestBlue().cgColor
        button.addTarget(self, action: #selector(GRAlertView.confirmButtonWasPressed(_:)), for: .touchUpInside)
        
        return button
        
    }
        
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
    
    func setupHierarchy() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        
        let alertView = UIView()
        addSubview(alertView)
        alertView.snp.makeConstraints { (make) in
            make.width.equalTo(580 / masterRatio)
            make.height.equalTo(400 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(470.5 / masterRatio)
        }
        
        alertView.backgroundColor = UIColor(hexString: "#FFFFFF")
        alertView.layer.cornerRadius = 10 / masterRatio
        
        
        addSubview(message)
        message.snp.makeConstraints { (make) in
            make.width.equalTo(400 / masterRatio)
            make.height.equalTo(132 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(alertView.snp.top).offset(73.5 / masterRatio)
        }
        message.font = UIFont.avenirLight(32)
        message.textAlignment = .center
        message.textColor = UIColor(hexString: "#9B9B9B")
        message.numberOfLines = 3
        
        confirmButton.snp.makeConstraints { (make) in
            make.width.equalTo(400 / masterRatio)
            make.height.equalTo(80 / masterRatio)
            make.centerX.equalTo(alertView.snp.centerX)
            make.bottom.equalTo(alertView.snp.bottom).offset(-70.5 / masterRatio)
        }
        
        
        
    }
    
    func confirmButtonWasPressed(_ sender:UIButton) {
        delegate.confirmWasPressed!(sender)
    }
    
    func formatMessage(_ alertText:String, lines:Int) {
        message.numberOfLines = lines
        message.text = alertText
    }
    
    
}

