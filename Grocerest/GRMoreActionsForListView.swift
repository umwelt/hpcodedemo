//
//  GRMoreActionsForListView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 10/02/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRMoreActionsForListView: UIView {
    
    var delegate = GRMoreActionsForListViewController()
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var closeButton = UIButton(type: .custom)
    var imageSize = CGSize(width: 57.0 / masterRatio, height: 57.0 / masterRatio)
    var marginLeft = 227 / masterRatio
    var buttonSize = CGSize(width: 500 / masterRatio, height: 80 / masterRatio)
    
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
        
        let viewBlurredBackground = UIVisualEffectView(effect: blurEffect)
        self.addSubview(viewBlurredBackground)
        viewBlurredBackground.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        
        let viewWithVibrancy = UIVisualEffectView(effect: blurEffect)
        viewBlurredBackground.contentView.addSubview(viewWithVibrancy)
        viewWithVibrancy.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(viewBlurredBackground)
        }
        
        viewWithVibrancy.contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100 / masterRatio)
            make.right.equalTo(-40 / masterRatio)
            make.top.equalTo(40)
        }
        closeButton.contentMode = .center
        closeButton.setImage(UIImage(named: "white_close"), for: UIControlState())
        closeButton.addTarget(delegate, action: Selector("closeButtonWasPressed:"), for: .touchUpInside)
        
        
        let separator = UIView()
        viewWithVibrancy.contentView.addSubview(separator)
        separator.backgroundColor = UIColor.lightGray
        separator.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(450 / masterRatio)
            make.height.equalTo(0.5)
            make.top.equalTo(300 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        

        
        let resetImageView = UIImageView()
        viewWithVibrancy.contentView.addSubview(resetImageView)
        resetImageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(imageSize)
            make.left.equalTo(marginLeft)
            make.top.equalTo(separator.snp.bottom).offset(100 / masterRatio)
        }
        resetImageView.contentMode = .scaleAspectFit
        resetImageView.image = UIImage(named: "reset_lista")
        
        let resetLabel = buttonLabel("Resetta Lista")
        viewWithVibrancy.contentView.addSubview(resetLabel)
        resetLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300 / masterRatio)
            make.left.equalTo(resetImageView.snp.right).offset(40 / masterRatio)
            make.centerY.equalTo(resetImageView.snp.centerY)
        }
        
        let resetButton = buttonForSection()
        viewWithVibrancy.contentView.addSubview(resetButton)
        resetButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(buttonSize)
            make.centerX.equalTo(viewWithVibrancy.snp.centerX)
            make.centerY.equalTo(resetImageView.snp.centerY)
        }
        resetButton.addTarget(self, action: #selector(GRMoreActionsForListView.actionResetWasPressed(_:)), for: .touchUpInside)
        
        
        
        let duplicateImageView = imageForButton("duplicate_lista")
        viewWithVibrancy.contentView.addSubview(duplicateImageView)
        duplicateImageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(imageSize)
            make.left.equalTo( 227 / masterRatio)
            make.top.equalTo(resetImageView.snp.bottom).offset(89 / masterRatio)
        }
        
        let duplicateLabel = buttonLabel("Duplica lista")
        viewWithVibrancy.contentView.addSubview(duplicateLabel)
        duplicateLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300 / masterRatio)
            make.left.equalTo(resetImageView.snp.right).offset(40 / masterRatio)
            make.centerY.equalTo(duplicateImageView.snp.centerY)
        }
        
        let duplicateButton = UIButton(type: .custom)
        viewWithVibrancy.contentView.addSubview(duplicateButton)
        duplicateButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(buttonSize)
            make.centerX.equalTo(viewWithVibrancy.snp.centerX)
            make.centerY.equalTo(duplicateImageView.snp.centerY)
        }
        duplicateButton.addTarget(self, action: #selector(GRMoreActionsForListView.actionDuplicateWasPressed(_:)), for: .touchUpInside)
        
        
        
        let modifyImageView = imageForButton("modify_lista")
        viewWithVibrancy.contentView.addSubview(modifyImageView)
        modifyImageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(imageSize)
            make.left.equalTo(marginLeft)
            make.top.equalTo(duplicateImageView.snp.bottom).offset(89 / masterRatio)
        }
        
        let modifyLabel = buttonLabel("Modifica")
        viewWithVibrancy.contentView.addSubview(modifyLabel)
        modifyLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300 / masterRatio)
            make.left.equalTo(resetImageView.snp.right).offset(40 / masterRatio)
            make.centerY.equalTo(modifyImageView.snp.centerY)
        }
        
        let modifyButton = buttonForSection()
        viewWithVibrancy.contentView.addSubview(modifyButton)
        modifyButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(buttonSize)
            make.centerX.equalTo(viewWithVibrancy.snp.centerX)
            make.centerY.equalTo(modifyImageView.snp.centerY)
        }
        modifyButton.addTarget(self, action: #selector(GRMoreActionsForListView.actionModifyWasPressed(_:)), for: .touchUpInside)
        
        
        
        let exportImageView = imageForButton("sharing_list")
        viewWithVibrancy.contentView.addSubview(exportImageView)
        exportImageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(imageSize)
            make.left.equalTo(marginLeft)
            make.top.equalTo(modifyImageView.snp.bottom).offset(89 / masterRatio)
        }
        
        let exportLabel = buttonLabel("Condividi")
        viewWithVibrancy.contentView.addSubview(exportLabel)
        exportLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300 / masterRatio)
            make.left.equalTo(resetImageView.snp.right).offset(40 / masterRatio)
            make.centerY.equalTo(exportImageView.snp.centerY)
        }
        
        let exportButton = buttonForSection()
        viewWithVibrancy.contentView.addSubview(exportButton)
        exportButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(buttonSize)
            make.centerX.equalTo(viewWithVibrancy.snp.centerX)
            make.centerY.equalTo(exportImageView.snp.centerY)
        }
        exportButton.addTarget(self, action: #selector(GRMoreActionsForListView.actionShareWasPressed(_:)), for: .touchUpInside)
        
        
        
        let deleteImageView = imageForButton("delete_lista")
        viewWithVibrancy.contentView.addSubview(deleteImageView)
        deleteImageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(imageSize)
            make.left.equalTo(marginLeft)
            make.top.equalTo(exportImageView.snp.bottom).offset(89 / masterRatio)
        }
        
        
        let deleteLabel = buttonLabel("Elimina")
        viewWithVibrancy.contentView.addSubview(deleteLabel)
        deleteLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300 / masterRatio)
            make.left.equalTo(resetImageView.snp.right).offset(40 / masterRatio)
            make.centerY.equalTo(deleteImageView.snp.centerY)
        }
        
        
        let deleteButton = buttonForSection()
        viewWithVibrancy.contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(buttonSize)
            make.centerX.equalTo(viewWithVibrancy.snp.centerX)
            make.centerY.equalTo(deleteImageView.snp.centerY)
        }
        deleteButton.addTarget(self, action: #selector(GRMoreActionsForListView.actionDeleteWasPressed(_:)), for: .touchUpInside)
        
        
        
        
        let separatorB = UIView()
        viewWithVibrancy.contentView.addSubview(separatorB)
        separatorB.backgroundColor = UIColor.lightGray
        separatorB.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(450 / masterRatio)
            make.height.equalTo(0.5)
            make.top.equalTo(deleteImageView.snp.bottom).offset(100 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        
    
    }
    
    func buttonLabel (_ title:String) -> UILabel{
        let label = UILabel()
        label.font = Constants.BrandFonts.avenirRoman15
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.text = title
        
        return label
    }
    
    func imageForButton(_ image:String) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: image)
        
        return imageView
    }
    
    func buttonForSection () -> UIButton {
        let button = UIButton(type: .custom)
        return button
    }
    
    
    func actionImportWasPressed(_ sender:UIButton) {
        delegate.importWasPressed(sender)
    }
    
    func actionResetWasPressed(_ sender:UIButton) {
        delegate.resetWasPressed(sender)
    }
    
    func actionDuplicateWasPressed(_ sender:UIButton) {
        delegate.duplicateWasPressed(sender)
    }
    
    func actionModifyWasPressed(_ sender:UIButton) {
        delegate.modifyWasPressed(sender)
    }
    
    func actionShareWasPressed(_ sender:UIButton) {
        delegate.exportWasPressed(sender)
    }
    
    func actionDeleteWasPressed(_ sender:UIButton) {
        delegate.deleteWasPressed(sender)
    }
    
    
    
    
}


