//
//  GRShoppingListView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 25/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import UIKit

class GRShoppingListView: UIView, GRToolBarProtocol {
    
    lazy var navigationToolBar : GRToolbar = {
        let toolBar = GRToolbar()
       
        return toolBar
    }()
    
    fileprivate lazy var emptyListImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "empty_list")
        
        return image
    }()
    
    lazy var addProductView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    fileprivate lazy var separator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        
        return view
    }()
    
    
    fileprivate lazy var plusImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plus_product")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    fileprivate lazy var addProductLabel : UILabel = {
        let label = UILabel()
        label.font = Constants.BrandFonts.avenirBook15
        label.textAlignment = .left
        label.textColor = UIColor.grocerestLightGrayColor()
        
        return label
    }()
    
    fileprivate lazy var addProductButton : UIButton = {
        let button = UIButton(type: .custom)
        
        return button
    }()
    
    fileprivate lazy var productsCounter : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.grocerestColor()
        label.font = Constants.BrandFonts.avenirBook10
        label.layer.cornerRadius = 15
        label.layer.borderColor = UIColor.grocerestColor().cgColor
        label.layer.borderWidth = 1
        
        
        return label
    }()
    
    fileprivate lazy var emptyListLabel1 : UILabel = {
        let label = UILabel()
        label.text = "Lista Vuota"
        label.font = Constants.BrandFonts.ubuntuMedium16
        label.textColor = UIColor.grocerestDarkBoldGray()
        label.textAlignment = .center
        
        return label
    }()
    
    fileprivate lazy var emptyListLabel2 : UILabel = {
        let label = UILabel()
        label.text = "inizia ad aggiungere prodotti!"
        label.font = Constants.BrandFonts.avenirBook15
        label.textColor = UIColor(hexString: "#9B9B9B")
        label.textAlignment = .center
        
        return label
    }()
    
    var delegate: GRToolBarProtocol?
    
    // - MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitialization()
    }
  
}


extension GRShoppingListView {
    
    var textViewLabel: String? {
        get {
            return addProductLabel.text
        }
        set(newText) {
             addProductLabel.text = newText
        }
    }
    
    var numberForCounter: String? {
        get {
            return productsCounter.text
        }
        set(newCounter) {
            productsCounter.text = newCounter
        }
    }
}

extension GRShoppingListView {
    
    func sharedInitialization() {
        
        backgroundColor = UIColor(hexString: "#F1F1F1")
        
        addSubview(navigationToolBar)
        navigationToolBar.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.left.equalTo(0)
        }
        
        addSubview(addProductView)
        addProductView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(120 / masterRatio)
            make.top.equalTo(navigationToolBar.snp.bottom)
            make.left.equalTo(0)
        }
        
        addProductView.addSubview(plusImageView)
        plusImageView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(29 / masterRatio)
            make.left.equalTo(36 / masterRatio)
            make.top.equalTo(44 / masterRatio)
        }
        
        addProductView.addSubview(addProductLabel)
        addProductLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(plusImageView.snp.right).offset(23 / masterRatio)
            make.centerY.equalTo(plusImageView.snp.centerY)
        }
        
        addProductView.addSubview(addProductButton)
        addProductButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(addProductView)
        }
        addProductButton.addTarget(delegate, action: #selector(GRToolBarProtocol.addProductButtonWasPressed(_:)), for: .touchUpInside)
        
        addProductView.addSubview(productsCounter)
        productsCounter.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(30)
            make.centerY.equalTo(plusImageView.snp.centerY)
            make.right.equalTo(-20)
        })
        
        
        addSubview(separator)
        separator.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(1 / masterRatio)
            make.top.equalTo(addProductButton.snp.bottom).offset(-1 / masterRatio)
            make.left.equalTo(0)
        }
        
        
        addSubview(emptyListImageView)
        emptyListImageView.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(157 / masterRatio)
            make.height.equalTo(264 / masterRatio)
            make.top.equalTo(separator.snp.bottom).offset(105 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        })
        
        emptyListImageView.addSubview(emptyListLabel1)
        emptyListLabel1.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(38 / masterRatio)
            make.top.equalTo(emptyListImageView.snp.bottom).offset(88 / masterRatio)
            make.centerX.equalTo(emptyListImageView.snp.centerX)
        })
        
        emptyListImageView.addSubview(emptyListLabel2)
        emptyListLabel2.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(38 / masterRatio)
            make.top.equalTo(emptyListLabel1.snp.bottom).offset(8 / masterRatio)
            make.centerX.equalTo(emptyListImageView.snp.centerX)
        })
        
    }
}

extension GRShoppingListView {
    
    func hideBackViews() {
        emptyListImageView.isHidden = true
        emptyListImageView.setNeedsDisplay()
    }
    
    func formatListWith(_ listName:String){
        navigationToolBar.isThisBarWithBackButton(true, title: listName)
        navigationToolBar.triangleImageView?.isHidden = false
        navigationToolBar.repositionDotsMenu()
    }
}
