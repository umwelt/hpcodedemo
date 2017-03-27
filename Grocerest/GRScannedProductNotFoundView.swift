//
//  GRProductNotFoundView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 15/12/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRScannedProductNotFoundView: UIView {
    
    var onBackgroundTap: (() -> Void)?
    var onButtonTap: (() -> Void)?
    
    convenience init(){
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    // Used by running iOS app
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialization()
    }
    
    // Used by Inteface Builder
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialization()
    }
    
    private func initialization() {
        let backgroundButton = UIButton(type: .custom)
        backgroundButton.addTarget(self, action: #selector(self.backgroundWasTapped), for: .touchUpInside)
        addSubview(backgroundButton)
        backgroundButton.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        let box = UIView()
        box.backgroundColor = UIColor.white
        box.layer.cornerRadius = 4
        addSubview(box)
        box.snp.makeConstraints { make in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(320 / masterRatio)
            make.top.equalTo(self.snp.top).offset(119 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        let label = UILabel()
        label.text = "Codice non associato ad un prodotto"
        label.numberOfLines = 2
        label.font = Constants.BrandFonts.ubuntuMedium16
        label.textColor = UIColor.grocerestDarkBoldGray()
        label.textAlignment = .left
        box.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(43 / masterRatio)
        }
        
        let subLabel = UILabel()
        subLabel.text = "Per ringraziarti del contributo ti verranno riconosciuti 12 punti reputation!"
        subLabel.numberOfLines = 2
        subLabel.font = Constants.BrandFonts.avenirBook12
        subLabel.textAlignment = .center
        subLabel.textColor = UIColor.grocerestDarkBoldGray()
        box.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(12 / masterRatio)
            make.width.equalTo(534 / masterRatio)
            make.centerX.equalTo(box.snp.centerX)
        }
        
        let button = UIButton(type: .custom)
        button.setTitle("ASSOCIA PRODOTTO", for: .normal)
        button.titleLabel?.font = Constants.BrandFonts.avenirBook11
        button.setTitleColor(UIColor.grocerestBlue(), for: .normal)
        button.setBackgroundImage(UIImage(named: "bottone_64"), for: .normal)
        button.addTarget(self, action: #selector(self.buttonWasTapped), for: .touchUpInside)
        box.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(348 / masterRatio)
            make.height.equalTo(68 / masterRatio)
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(201 / masterRatio)
        }
        
        let pointsImageView = UIImageView()
        pointsImageView.contentMode = .scaleAspectFit
        pointsImageView.image = UIImage(named: "twelve_points_off")
        box.addSubview(pointsImageView)
        pointsImageView.snp.makeConstraints { make in
            make.width.equalTo(101 / masterRatio)
            make.height.equalTo(50 / masterRatio)
            make.right.equalTo(0)
            make.centerY.equalTo(button.snp.centerY)
        }
    }
    
    func backgroundWasTapped() {
        onBackgroundTap?()
    }
    
    func buttonWasTapped() {
        onButtonTap?()
    }
    
}
