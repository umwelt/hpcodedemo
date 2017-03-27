//
//  GRShoppingListAutocompleteBarView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 10/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRShoppingListAutocompleteBarView: GRSearchBarView {
    
    override func setupHierarchy() {

        let plusImageView = UIImageView()
        addSubview(plusImageView)
        plusImageView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(32 / masterRatio)
            make.top.equalTo(36 / masterRatio)
            make.left.equalTo(36 / masterRatio)
        }
        plusImageView.image = UIImage(named: "back_lampone")?.withRenderingMode(.alwaysOriginal)
        plusImageView.contentMode = .scaleAspectFit
        
        let button = UIButton()
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.edges.equalTo(plusImageView)
        }
        button.addTarget(self, action: #selector(GRShoppingListAutocompleteBarView.actionCloseButtonWasPressed(_:)), for: .touchUpInside)
        
        searchField = UITextField()
        addSubview(searchField!)
        
        searchField!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(510 / masterRatio)
            make.height.equalTo(80 / masterRatio)
            make.centerY.equalTo(self.snp.centerY).offset(-4 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        searchField?.returnKeyType = .search
        searchField?.placeholder = "Cerca Prodotto"
        searchField?.clearButtonMode = .always
        searchField?.autocorrectionType = .yes
        searchField?.autocapitalizationType = .none
        
        /*
        let closeButton = UIButton()
        addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(56 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-40 / masterRatio)
        }
        closeButton.setImage(UIImage(named: "close_modal"), forState: .Normal)
        closeButton.contentMode = .ScaleAspectFit
        closeButton.addTarget(self, action: #selector(GRShoppingListAutocompleteBarView.actionCloseButtonWasPressed(_:)), forControlEvents: .TouchUpInside)
        */
        
        addSubview(productsCounter)
        productsCounter.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(30)
            make.centerY.equalTo((plusImageView.snp.centerY))
            make.right.equalTo(-20)
        })
        productsCounter.textAlignment = .center
        productsCounter.textColor = UIColor.grocerestColor()
        productsCounter.font = Constants.BrandFonts.avenirBook10
        productsCounter.layer.cornerRadius = 15
        productsCounter.layer.borderColor = UIColor.grocerestColor().cgColor
        productsCounter.layer.borderWidth = 1
        
        let counterButton = UIButton()
        addSubview(counterButton)
        counterButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(productsCounter)
        }
        counterButton.addTarget(self, action: #selector(GRShoppingListAutocompleteBarView.actionCloseButtonWasPressed(_:)), for: .touchUpInside)

        let separator = UIView()
        addSubview(separator)
        separator.backgroundColor = UIColor.white
        separator.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(0.5)
            make.top.equalTo(self.snp.bottom)
            make.left.equalTo(0)
            
        }
        
        
    }
    
    
    override func actionCloseButtonWasPressed(_ sender:UIButton) {
        delegate?.closeButtonWasPressed(sender)
    }
    
}
