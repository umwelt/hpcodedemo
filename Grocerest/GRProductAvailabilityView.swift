//
//  GRProductAvailabilityView.swift
//  Grocerest
//
//  Created by Davide Bertola on 15/03/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation

//
//  GRBadgeWidget.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 08/09/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit


class ModalBackgroundView: UIView {
    
    let closeButton = UIButton()
    
    required init?(coder: NSCoder) { // called on Device
        super.init(coder: coder)
        initialize()
    }
    
    override init(frame: CGRect) { // called in InterfaceBuilder
        super.init(frame: frame)
        initialize()
    }
    
    func initialize() {
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.closeButtonTap(_:)))
        recognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(recognizer)
        
        self.addSubview(closeButton)
        closeButton.snp.remakeConstraints { (make) -> Void in
            make.width.height.equalTo(80 / masterRatio)
            make.top.equalTo(30 / masterRatio)
            make.right.equalTo(-30 / masterRatio)
        }
        closeButton.contentMode = .center
        closeButton.setImage(
            UIImage(named: "whiteCloseButton"),
            for: UIControlState.normal
        )
        closeButton.addTarget(
            self,
            action: #selector(self.closeButtonTap(_:)),
            for: .touchUpInside
        )
    }
    
    func closeButtonTap(_ sender:UIButton) {
        print("tapped")
    }
}


class ModalCardView: UIView {
    required init?(coder: NSCoder) { // called on Device
        super.init(coder: coder)
        initialize()
    }
    
    override init(frame: CGRect) { // called in InterfaceBuilder
        super.init(frame: frame)
        initialize()
    }
    
    func initialize() {
        self.backgroundColor = UIColor.F1F1F1Color()
        self.layer.cornerRadius = 20.0 / masterRatio
        self.snp.makeConstraints { (make) in
            make.width.height.equalTo(600 / masterRatio)
        }
    }
}


@IBDesignable
class GRProductAvailabilityView: UIView {

    required init?(coder: NSCoder) { // called on Device
        super.init(coder: coder)
        initialize()
    }
    
    override init(frame: CGRect) { // called in InterfaceBuilder
        super.init(frame: frame)
        initialize()
    }
    
    func initialize() {
        let background = ModalBackgroundView()
        self.addSubview(background)
        background.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        let card = ModalCardView()
        self.addSubview(card)
        card.snp.makeConstraints { (make) in
            make.top.equalTo(self).inset(200 / masterRatio)
            make.centerX.equalTo(self)
        }
    }

    
    override func prepareForInterfaceBuilder() {
        // initialize()
    }
    
}
