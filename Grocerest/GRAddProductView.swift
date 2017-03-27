//
//  GRAddProductView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 26/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRAddProductView: UIView {
    
    var viewsByName: [String: UIView]!
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
    var addProductView : UIView?
    var addProduct: UIButton?
    var searchProduct : UITextField?
    var delegate : GRAddProductProtocol?
    var productsCounter: UILabel?
    var customProductView : UIView?
    var addAllProductsButton : UIButton?
    var customProductText : UILabel?
    var addCustomProductButton : UIButton?
    var plusImageView : UIImageView?
    var emptyListImageView = UIImageView()
    var counterButton = UIButton()
    
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
        
        if let scalingView = self.viewsByName["__scaling__"] {
            var xScale = self.bounds.size.width / scalingView.bounds.size.width
            var yScale = self.bounds.size.height / scalingView.bounds.size.height
            switch contentMode {
            case .scaleToFill:
                break
            case .scaleAspectFill:
                let scale = max(xScale, yScale)
                xScale = scale
                yScale = scale
            default:
                let scale = min(xScale, yScale)
                xScale = scale
                yScale = scale
            }
            scalingView.transform = CGAffineTransform(scaleX: xScale, y: yScale)
            scalingView.center = CGPoint(x:self.bounds.midX, y:self.bounds.midY)
        }
    }
    
    
    
    func setupHierarchy() {
        var viewsByName: [String: UIView] = [:]
        let __scaling__ = UIView()
        __scaling__.backgroundColor = UIColor.F1F1F1Color()
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        
        
        addProductView = UIView()
        __scaling__.addSubview(addProductView!)
        addProductView!.backgroundColor = UIColor.white
        addProductView!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(161 / masterRatio)
            make.top.equalTo(0)
            make.left.equalTo(0)
        }
        
        plusImageView = UIImageView()
        addProductView!.addSubview(plusImageView!)
        plusImageView!.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(34 / masterRatio)
            make.left.equalTo(36 / masterRatio)
            make.top.equalTo(85 / masterRatio)
        }
        plusImageView!.image = UIImage(named: "back_lampone")?.withRenderingMode(.alwaysOriginal)
        plusImageView!.contentMode = .scaleAspectFit
        
        let closeButton = UIButton()
        __scaling__.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) -> Void in
            make.center.equalTo((plusImageView?.snp.center)!)
            make.height.width.equalTo(45)
        }
        
        closeButton.addTarget(self, action: #selector(GRAddProductView.actionCloseButtonWasPressed(_:)), for: .touchUpInside)

        
        
        productsCounter = UILabel()
        __scaling__.addSubview(productsCounter!)
        productsCounter?.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(30)
            make.centerY.equalTo((plusImageView?.snp.centerY)!)
            make.right.equalTo(-20)
        })
        productsCounter?.textAlignment = .center
        productsCounter?.textColor = UIColor.grocerestColor()
        productsCounter?.font = Constants.BrandFonts.avenirBook10
        productsCounter?.layer.cornerRadius = 15
        productsCounter?.layer.borderColor = UIColor.grocerestColor().cgColor
        productsCounter?.layer.borderWidth = 1
        
        
        __scaling__.addSubview(counterButton)
        counterButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(productsCounter!)
        }
        counterButton.addTarget(self, action: #selector(GRAddProductView.actionNavigateToShoppingList(_:)), for: .touchUpInside)
        
        
        
        /// convert this into a text field
        let addProductLabel = UILabel()
        addProductView!.addSubview(addProductLabel)
        addProductLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(342 / masterRatio)
            make.height.equalTo(38 / masterRatio)
            make.left.equalTo(plusImageView!.snp.right).offset(60 / masterRatio)
            make.top.equalTo(8)
        }
        addProductLabel.font = Constants.BrandFonts.avenirBook15
        addProductLabel.textAlignment = .left
        addProductLabel.textColor = UIColor.grocerestLightGrayColor()
        
        
        searchProduct = UITextField()
        addProductView?.addSubview(searchProduct!)
        searchProduct!.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo((addProductView?.snp.centerX)!)
            make.centerY.equalTo(plusImageView!.snp.centerY)
            make.width.equalTo(510 / masterRatio)
            make.height.equalTo(80 / masterRatio)
        }
        
        searchProduct?.placeholder = Constants.AppLabels.addProducts
        searchProduct?.clearButtonMode = .always
        searchProduct?.leftView? = UIImageView(image: UIImage(named: "icon_search"))
        searchProduct?.leftViewMode = .always
        searchProduct?.returnKeyType = .search
    
        
        customProductView = UIView()
        __scaling__.addSubview(customProductView!)
        customProductView!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(60)
            make.top.equalTo(0)
            make.left.equalTo(0)
        }
        customProductView?.isHidden = true
        customProductView!.backgroundColor =  UIColor.grocerestLightGrayColor()
        
        let customProductLabel = UILabel()
        customProductView!.addSubview(customProductLabel)
        customProductLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.left.equalTo(customProductView!.snp.left).offset(10)
            make.top.equalTo(customProductView!.snp.top).offset(8)
        }
        customProductLabel.text = "Aggiungi Prodotto Custom"
        customProductLabel.font = Constants.BrandFonts.avenirHeavy11
        customProductLabel.textColor = UIColor.F1F1F1Color()
        
        customProductText = UILabel()
        customProductView?.addSubview(customProductText!)
        customProductText?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(20)
            make.top.equalTo(customProductLabel.snp.bottom)
            make.left.equalTo(10)
        })
        customProductText!.textColor = UIColor.white
        customProductText!.font = Constants.BrandFonts.avenirHeavy11
        customProductText?.textAlignment = .left
        
        addCustomProductButton = UIButton()
        customProductView?.addSubview(addCustomProductButton!)
        addCustomProductButton?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(customProductView!)
        })
        addCustomProductButton?.addTarget(self, action: #selector(GRAddProductView.actionAddCustomProductWasPressed(_:)), for: .touchUpInside)
        
        
        __scaling__.addSubview(emptyListImageView)
        emptyListImageView.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(157 / masterRatio)
            make.height.equalTo(264 / masterRatio)
            make.top.equalTo(addProductView!.snp.bottom).offset(205 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        })
        
        emptyListImageView.contentMode = .scaleAspectFit
        emptyListImageView.image = UIImage(named: "empty_list")
        
        viewsByName["emptyListImageView"] = emptyListImageView
        
        
        let emptyListLabel1 = UILabel()
        emptyListImageView.addSubview(emptyListLabel1)
        emptyListLabel1.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(self)
            make.top.equalTo(emptyListImageView.snp.bottom).offset(88 / masterRatio)
            make.centerX.equalTo(emptyListImageView.snp.centerX)
        })
        emptyListLabel1.text = "Cerca e aggiungi alla tua lista un prodotto generico o specifico"
        emptyListLabel1.numberOfLines = 2
        emptyListLabel1.font = Constants.BrandFonts.ubuntuMedium16
        emptyListLabel1.textColor = UIColor.grocerestDarkBoldGray()
        emptyListLabel1.textAlignment = .center

        self.viewsByName = viewsByName
        
    }
    
    
    
    
}

extension GRAddProductView {
    
    func setProductsCounterText(_ text:String){
        productsCounter?.text = text
    }
    
    func actionAddProductsWasPressed(_ sender: UIButton){
        delegate?.addProductsWasPressed(sender)
    }
    
    
    
    func actionCloseButtonWasPressed(_ sender: UIButton) {
        delegate?.closeButtonWasPressed(sender)
    }
    
    func actionAddCustomProductWasPressed(_ sender:UIButton){
        delegate?.addCustomProductWasPressed(sender)
    }
    
    
    func actionNavigateToShoppingList(_ sender:UIButton) {
        delegate?.navigateToShoppingList(sender)
    }
    
    func animateCounter () {
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
            self.productsCounter?.textColor = UIColor.white
            self.productsCounter?.layer.backgroundColor = UIColor.grocerestColor().cgColor
            self.productsCounter?.textAlignment = .center
            self.productsCounter?.font = Constants.BrandFonts.avenirBook10
            self.productsCounter?.layer.cornerRadius = 15
            self.productsCounter?.layer.borderWidth = 1
            
            self.productsCounter?.layer.backgroundColor = UIColor.clear.cgColor
            self.productsCounter?.textColor = UIColor.grocerestColor()
            }, completion: {_ in
                self.productsCounter?.layer.borderColor = UIColor.grocerestColor().cgColor
        })
        
    }
    
    func hideEmptyImage() {
        emptyListImageView.isHidden = true
    }
    
    func showEmptyImage() {
        emptyListImageView.isHidden = true
    }
    
    

    
}


