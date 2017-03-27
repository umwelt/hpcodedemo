//
//  GRHelpView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 01/03/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRHelpView: UIView {
    var delegate = GRHelpViewController()
    
    var backView = UIScrollView()
    
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
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
        
        backgroundColor = UIColor.F1F1F1Color()
        
        let header = UIView()
        addSubview(header)
        header.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.left.equalTo(0)
        }
        header.backgroundColor = UIColor.grocerestColor()
        
        let menuButton = UIButton(type: .custom)
        header.addSubview(menuButton)
        menuButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(70 / masterRatio)
            make.left.equalTo(24 / masterRatio)
            make.top.equalTo(56 / masterRatio)
        }
        menuButton.contentMode = .center
        menuButton.setImage(UIImage(named: "back_button"), for: UIControlState())
        
        menuButton.addTarget(self, action: #selector(GRHelpView.actionMenuButtonWasPressed(_:)), for: .touchUpInside)
        
        
        
        let helpLabel = UILabel()
        header.addSubview(helpLabel)
        helpLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(header.snp.centerX)
            make.centerY.equalTo(menuButton.snp.centerY)
        }
        helpLabel.font = Constants.BrandFonts.ubuntuLight18
        helpLabel.textColor = UIColor.white
        helpLabel.text = "Simboli"
        helpLabel.textAlignment = .center
        
        let searchButton = UIButton(type: .custom)
        header.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(70 / masterRatio)
            make.right.equalTo(-15 / masterRatio)
            make.centerY.equalTo(menuButton.snp.centerY)
        }
        searchButton.contentMode = .center
        searchButton.setImage(UIImage(named: "v2_search_icon"), for: UIControlState())
        searchButton.addTarget(self, action: #selector(GRHelpView.actionSearchButtonWasPressed(_:)), for: .touchUpInside)
        
        let scannerButton = UIButton(type: .custom)
        header.addSubview(scannerButton)
        scannerButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(30)
            make.height.equalTo(40.05)
            make.right.equalTo(searchButton.snp.left).offset(-7)
            make.centerY.equalTo(searchButton.snp.centerY)
        }
        scannerButton.contentMode = .center
        scannerButton.setImage(UIImage(named: "icon_scanner"), for: UIControlState())
        scannerButton.addTarget(self, action: #selector(GRHelpView.actionScannerButtonWasPressed(_:)), for: .touchUpInside)

        
        
        backView = UIScrollView()
        addSubview(backView)
        backView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(self)
            make.top.equalTo(header.snp.bottom)
        }
        backView.contentSize.height = 3067.00 / masterRatio
        
        
        let legend = UILabel()
        backView.addSubview(legend)
        legend.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(30 / masterRatio)
            make.top.equalTo(backView.snp.top).offset(34 / masterRatio)
        }
        legend.text = "Legenda"
        legend.font = Constants.BrandFonts.avenirBook11
        legend.textColor = UIColor.grocerestDarkBoldGray()
        legend.textAlignment = .left
        
        let recensioniPanel = UIImageView()
        backView.addSubview(recensioniPanel)
        recensioniPanel.backgroundColor = UIColor.white
        recensioniPanel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(690 / masterRatio)
            make.height.equalTo(390 / masterRatio)
            make.top.equalTo(legend.snp.bottom).offset(34 / masterRatio)
            make.left.equalTo(30 / masterRatio)
        }
        recensioniPanel.layer.cornerRadius = 10 / masterRatio
        recensioniPanel.image = UIImage(named: "RECENSIONI")
        
        
        
        
        
        let experiencePanel = UIImageView()
        backView.addSubview(experiencePanel)
        experiencePanel.backgroundColor = UIColor.white
        experiencePanel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(690 / masterRatio)
            make.height.equalTo(235 / masterRatio)
            make.top.equalTo(recensioniPanel.snp.bottom).offset(29 / masterRatio)
            make.left.equalTo(30 / masterRatio)
        }
        experiencePanel.layer.cornerRadius = 10 / masterRatio
        experiencePanel.image = UIImage(named: "ESPERIENZA")
        
        
        
        
        let listePanel = UIImageView()
        backView.addSubview(listePanel)
        listePanel.backgroundColor = UIColor.white
        listePanel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(690 / masterRatio)
            make.height.equalTo(1099 / masterRatio)
            make.top.equalTo(experiencePanel.snp.bottom).offset(29 / masterRatio)
            make.left.equalTo(30 / masterRatio)
        }
        listePanel.layer.cornerRadius = 10 / masterRatio
        listePanel.image = UIImage(named: "LISTE")
        
        
        let shopPanel = UIImageView()
        backView.addSubview(shopPanel)
        shopPanel.backgroundColor = UIColor.white
        shopPanel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(690 / masterRatio)
            make.height.equalTo(235 / masterRatio)
            make.top.equalTo(listePanel.snp.bottom).offset(29 / masterRatio)
            make.left.equalTo(30 / masterRatio)
        }
        shopPanel.layer.cornerRadius = 10 / masterRatio
        shopPanel.image = UIImage(named: "SHOP")
        
        
        let categoriePanel = UIImageView()
        backView.addSubview(categoriePanel)
        categoriePanel.backgroundColor = UIColor.white
        categoriePanel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(690 / masterRatio)
            make.height.equalTo(692 / masterRatio)
            make.top.equalTo(shopPanel.snp.bottom).offset(29 / masterRatio)
            make.left.equalTo(30 / masterRatio)
        }
        categoriePanel.layer.cornerRadius = 10 / masterRatio
        categoriePanel.image = UIImage(named: "CATEGORIE")
        

        
        
    }
    
    
    func panelLabel(_ name:String) -> UILabel {
        
        let label = UILabel()
        label.text = name
        label.font = Constants.BrandFonts.avenirBook11
        label.textColor = UIColor.grocerestXDarkBoldGray()
        label.textAlignment = .left
        
        return label
        
    }
    
    
    func actionMenuButtonWasPressed(_ sender:UIButton) {
        delegate.menuButtonWasPressed(sender)
    }
    
    func actionSearchButtonWasPressed(_ sender:UIButton) {
        delegate.searchButtonWasPressed(sender)
    }
    
    
    func actionScannerButtonWasPressed(_ sender:UIButton) {
        delegate.scannerButtonWasPressed(sender)
    }
    
    
}


