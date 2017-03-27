//
//  GRAutocompleteView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 10/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRAutocompleteView: UIView {
    
    var fromShoppingList = false
    var productCounter = 0
    var delegate : GRAutocompleteViewController?
    var searchBar : GRSearchBarView?
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var topback = UIView()
    var segmentedButton = UISegmentedControl()
    var viewBlurredBackground = UIVisualEffectView()
    var separator = UIView()
    
    convenience init(fromList:Bool, productCounter: Int) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
        self.fromShoppingList = fromList
        self.productCounter = productCounter
        self.setupHierarchy()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        super.layoutSubviews()
        
    }
    
    
    func setupHierarchy() {
        
        addSubview(topback)
        topback.backgroundColor = UIColor.white
        topback.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(270 / masterRatio)
            make.top.left.equalTo(0)
        }
        
        if (fromShoppingList) {
            searchBar = GRShoppingListAutocompleteBarView()
            searchBar?.productsCounter.text = "\(productCounter)"
        } else {
            searchBar = GRSearchBarView()
        }
        
        addSubview(searchBar!)
        searchBar!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(117 / masterRatio)
            make.top.equalTo(48 / masterRatio)
            make.left.equalTo(0)
        }
        
        
        let items = ["Tutti i prodotti", "I miei prodotti"]
        segmentedButton = UISegmentedControl(items: items)
        segmentedButton.selectedSegmentIndex = 0
        segmentedButton.tintColor = UIColor.grocerestColor()
        segmentedButton.layer.cornerRadius = 4
        segmentedButton.backgroundColor = UIColor.clear
        addSubview(segmentedButton)
        segmentedButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(700 / masterRatio)
            make.height.equalTo(60 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo((searchBar?.snp.bottom)!)
        }
        
        
        addSubview(separator)
        separator.backgroundColor = UIColor.lightGray
        separator.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(0.5)
            make.top.equalTo(segmentedButton.snp.bottom).offset(20)
            make.left.equalTo(0)
        }
        
        
        viewBlurredBackground = UIVisualEffectView(effect: blurEffect)
        addSubview(viewBlurredBackground)
        viewBlurredBackground.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(UIScreen.main.bounds.height)
            make.top.equalTo(separator.snp.bottom)
            make.width.equalTo(self)
        }
        
        
    }
    
    
    func actionCloseButtonWasPressed(_ sender:UIButton) {
        delegate?.closeButtonWasPressed(sender)
    }
    
    func formatViewFromSubCategory() {
        viewBlurredBackground.isHidden = true
    }
    
    func formatViewFromSearchFromList() {
        viewBlurredBackground.isHidden = true
        separator.isHidden = true
        segmentedButton.isHidden = true
        topback.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(160 / masterRatio)
            make.top.left.equalTo(0)
        }
        
        viewBlurredBackground.snp.remakeConstraints { (make) -> Void in
            make.height.equalTo(UIScreen.main.bounds.height)
            make.top.equalTo(topback.snp.bottom)
            make.width.equalTo(self)
        }
        
    }
    
    func hideBackgroundBlur(_ hide: Bool, alpha: CGFloat) {
        
        if hide {
            viewBlurredBackground.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, options:  .curveEaseOut, animations: {
                self.viewBlurredBackground.alpha = alpha
                }, completion: nil)
            
        } else {
            viewBlurredBackground.isHidden = true
            
            UIView.animate(withDuration: 0.5, delay: 0, options:  .curveEaseOut, animations: {
                self.viewBlurredBackground.alpha = 0
                }, completion: nil)
        }
        
    }
    
    
    
}
