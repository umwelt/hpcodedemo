//
//  GRShoppingItemViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 02/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRShoppingItemViewCell: UITableViewCell {
    
    fileprivate lazy var backView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    fileprivate lazy var categoryImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    fileprivate lazy var mainLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Constants.BrandFonts.ubuntuBold14
        label.textColor = UIColor.grocerestDarkBoldGray()
        
        return label
    }()
    
    fileprivate lazy var secondaryLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.grocerestLightGrayColor()
        label.font = Constants.BrandFonts.avenirBook11
        
        return label
    }()
    
    fileprivate lazy var cellProductQuantity: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Constants.BrandFonts.avenirBook12
        label.textColor = UIColor.lightGrayTextcolor()
        
        return label
    }()
    
    fileprivate lazy var checkProductButton : UIButton = {
        let button = UIButton()
        button.isExclusiveTouch = true
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    fileprivate lazy var unCheckProductButton : UIButton = {
        let button = UIButton()
        button.isExclusiveTouch = true
        
        return button
    }()
    
    var checkerLabel : UILabel?
    
    
    
    var onCheckProductButtonTapped: (() -> Void)?
    var onUncheckProductButton: (() -> Void)?
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cell")
        sharedInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitialization()
    }
    
}


extension GRShoppingItemViewCell {
    
    //: Public API
    
    var imageCategory : UIImage? {
        get {
            return categoryImageView.image
        }
        set(newImage) {
            categoryImageView.image = newImage
        }
    }
    
    var mainLabelText: String? {
        get {
            return mainLabel.text
        }
        set(newText) {
            mainLabel.text = newText
        }
    }
    
    var secondaryLabelText: String? {
        get {
            return secondaryLabel.text
        }
        set(newText) {
            secondaryLabel.text = newText
        }
    }
    
    var quantityLabelText: String? {
        get {
            return cellProductQuantity.text
        }
        set(newText) {
            cellProductQuantity.text = newText
        }
    }
}

extension GRShoppingItemViewCell {
    
    func sharedInitialization() {
        
        backgroundView?.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        addSubview(backView)
        backView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(686 / masterRatio )
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(125 / masterRatio)
        }
        
        categoryImageView = UIImageView()
        backView.addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(64 / masterRatio)
            make.left.equalTo(backView.snp.left).offset(28 / masterRatio)
            make.centerY.equalTo(backView.snp.centerY)
        }
        
        
        backView.addSubview(checkProductButton)
        checkProductButton.snp.makeConstraints { (make) -> Void in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(100 / masterRatio)
        }
        checkProductButton.addTarget(self, action: #selector(GRShoppingItemViewCell.checkProductWasTapped(_:)), for: .touchUpInside)
        
        
        backView.addSubview(unCheckProductButton)
        unCheckProductButton.snp.makeConstraints { (make) -> Void in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(100 / masterRatio)
        }
        unCheckProductButton.addTarget(self, action: #selector(GRShoppingItemViewCell.uncheckProductWasTapped(_:)), for: .touchUpInside)
        
        
        
        backView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints({ (make) -> Void in
            make.height.equalTo(35 / masterRatio)
            make.left.equalTo(backView.snp.left).offset(121 / masterRatio)
            make.top.equalTo(backView.snp.top).offset(26 / masterRatio)
            make.width.equalTo(425 / masterRatio)
        })
        
        
        backView.addSubview(secondaryLabel)
        secondaryLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(mainLabel.snp.width)
            make.height.equalTo(30 / masterRatio)
            make.left.equalTo(mainLabel.snp.left)
            make.top.equalTo(mainLabel.snp.bottom).offset(2)
        }
        
        
        backView.addSubview(cellProductQuantity)
        cellProductQuantity.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(90 / masterRatio)
            make.height.equalTo(28 / masterRatio)
            make.right.equalTo(backView.snp.right).offset(-10)
            make.centerY.equalTo(backView.snp.centerY)
            
        })
        
        
        
    }
}


extension GRShoppingItemViewCell {
    func checkProductWasTapped(_: UIButton) {
        onCheckProductButtonTapped!()
    }
    
    func uncheckProductWasTapped(_: UIButton) {
        onUncheckProductButton!()
    }
}


extension GRShoppingItemViewCell {
    
    func arrangeSectionZero () {
        
        backView.backgroundColor = UIColor.white
        
        unCheckProductButton.isHidden = true
        checkProductButton.isHidden = false
        secondaryLabel.isHidden = false
        
        mainLabel.font = Constants.BrandFonts.ubuntuBold14
        mainLabel.textColor = UIColor.grocerestDarkBoldGray()
        
        backView.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(686 / masterRatio )
            make.center.equalTo(self.snp.center)
            make.height.equalTo(125 / masterRatio)
        }
        
        categoryImageView.snp.remakeConstraints { (make) -> Void in
            make.width.height.equalTo(64 / masterRatio)
            make.left.equalTo(backView.snp.left).offset(28 / masterRatio)
            make.centerY.equalTo(backView.snp.centerY)
        }
        
        
        
        mainLabel.snp.remakeConstraints({ (make) -> Void in
            make.height.equalTo(35 / masterRatio)
            make.left.equalTo(backView.snp.left).offset(121 / masterRatio)
            make.top.equalTo(backView.snp.top).offset(26 / masterRatio)
            make.width.equalTo(425 / masterRatio)
        })
        
        secondaryLabel.textAlignment = .left
        secondaryLabel.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(mainLabel.snp.width)
            make.height.equalTo(30 / masterRatio)
            make.left.equalTo(mainLabel.snp.left)
            make.top.equalTo(mainLabel.snp.bottom).offset(2)
        }
        
    }
    
    func arrangeSectionOne() {
        
        backView.backgroundColor = UIColor.clear
        
        secondaryLabel.isHidden = false
        checkProductButton.isHidden = true
        unCheckProductButton.isHidden = false
        
        mainLabel.font = Constants.BrandFonts.avenirBook15
        mainLabel.textColor = UIColor.grocerestLightGrayColor()
        
        backView.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(686 / masterRatio )
            make.center.equalTo(self.snp.center)
            make.height.equalTo(80 / masterRatio)
        }
        
        categoryImageView.snp.remakeConstraints { (make) -> Void in
            make.width.height.equalTo(44 / masterRatio)
            make.left.equalTo(backView.snp.left).offset(28 / masterRatio)
            make.centerY.equalTo(backView.snp.centerY)
        }
        
        mainLabel.snp.remakeConstraints({ (make) -> Void in
            make.left.equalTo(backView.snp.left).offset(121 / masterRatio)
            make.centerY.equalTo(categoryImageView.snp.centerY)
            make.width.equalTo(425 / masterRatio)
        })
        
        secondaryLabel.textAlignment = .right
        secondaryLabel.snp.remakeConstraints({ (make) -> Void in
            make.left.equalTo(mainLabel.snp.right).offset(4 / masterRatio)
            make.centerY.equalTo(mainLabel.snp.centerY)
        })
        
    }
    

}
