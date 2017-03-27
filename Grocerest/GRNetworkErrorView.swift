//
//  GRNetworkErrorView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 30/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

class GRNetworkErrorView : UIView {
    
    var onTap: (() -> Void)?
    
    convenience init() {
        let (width, height) = (UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        backgroundColor = UIColor.white.withAlphaComponent(0.9)
        isOpaque = false
        
        let imageView = UIImageView(image: UIImage(named: "cash"))
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(364 / masterRatio)
            make.width.equalTo(272.65 / masterRatio)
            make.height.equalTo(297.22 / masterRatio)
        }
        
        let label = UILabel()
        label.text = "CONNESSIONE ASSENTE!"
        label.font = Constants.BrandFonts.ubuntuMedium20
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(imageView.snp.bottom).offset(59.79 / masterRatio)
        }
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(self._onTapped(_:)), for: .touchUpInside)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }
    }
    
    func _onTapped(_: UIButton) {
        onTap?()
    }
    
}
