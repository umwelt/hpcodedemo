//
//  GRAddFriendsView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 31/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRAddFriendsView: UIView {
    
    var viewsByName: [String: UIView]!
    var searchTextField: UITextField?
    var bottomButton : UIButton?
    var addFriendsLabel : UILabel?
    var searchView = UIView()
    var searchIcon = UIImageView()
    var okButton = UIButton()
    var closeButton = UIButton()
    
    var titleLabel = UILabel()
    
    // - MARK: Life Cycle
    
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
    
    var delegate : GRAddFriendsProtocol?
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupHierarchy() {
        
        self.transform = CGAffineTransform(translationX: 500, y: 0)
        
        
        var viewsByName: [String: UIView] = [:]
        let __scaling__ = UIView()
        __scaling__.backgroundColor = UIColor.white
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        

        
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(78 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        titleLabel.font = Constants.BrandFonts.ubuntuLight18
        titleLabel.textColor = UIColor.grocerestColor()
        titleLabel.textAlignment = .center
        titleLabel.text = Constants.AppLabels.manageCollaborators
        
        
        
        
        __scaling__.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(56 / masterRatio)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.left.equalTo(20 / masterRatio)
        }
        closeButton.setImage(UIImage(named: "close_modal"), for: UIControlState())
        closeButton.contentMode = .center
        closeButton.addTarget(self, action: #selector(GRAddFriendsView.actionCloseButtonWasPressed(_:)), for: .touchUpInside)
        
        
        
        __scaling__.addSubview(okButton)
        okButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(56 / masterRatio)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalTo(-40 / masterRatio)
        }
        okButton.setImage(UIImage(named: "ok_lampone"), for: UIControlState())
        okButton.contentMode = .center
        okButton.isEnabled = false
        okButton.addTarget(self, action: #selector(GRAddFriendsView.actionBottomButtonWasPressed(_:)), for: .touchUpInside)
        
        
        __scaling__.addSubview(searchView)
        searchView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(106 / masterRatio)
            make.top.equalTo(titleLabel.snp.bottom).offset(32 / masterRatio)
            make.centerX.equalTo(__scaling__.snp.centerX)
        }
        
        
        
        searchTextField = UITextField()
        searchView.addSubview(searchTextField!)
        searchTextField?.snp.makeConstraints({ (make) -> Void in
           // make.left.equalTo(searchIcon.snp.right).offset(24 / masterRatio)
            make.centerX.equalTo(searchView.snp.centerX)
            make.width.equalTo(406 / masterRatio)
            make.height.equalTo(searchView.snp.height)
            make.centerY.equalTo(searchView.snp.centerY)
        })
        searchTextField?.placeholder = "Cerca utenti su Grocerest"
        searchTextField?.font = Constants.BrandFonts.avenirBook15
        searchTextField?.textColor = UIColor.grocerestLightGrayColor()
        searchTextField?.textAlignment = .center
        searchTextField?.keyboardType = .asciiCapable
        searchTextField?.returnKeyType = .go
        searchTextField?.clearButtonMode = .always
        
        
        
        
        searchView.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(28 / masterRatio)
            make.centerY.equalTo((searchTextField?.snp.centerY)!)
            make.right.equalTo((searchTextField?.snp.left)!)
        }
        searchIcon.contentMode = .center
        searchIcon.image = UIImage(named: "blue_search")
        
        
        bottomButton = UIButton()
        __scaling__.addSubview(bottomButton!)
        bottomButton!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(112 / masterRatio)
            make.bottom.equalTo(0)
        }
        bottomButton!.backgroundColor = UIColor.grocerestBlue()
        bottomButton!.isHidden = true
        bottomButton?.addTarget(self, action: #selector(GRAddFriendsView.actionBottomButtonWasPressed(_:)), for: .touchUpInside)

        self.viewsByName = viewsByName
        
    }
    

    
    
}



extension GRAddFriendsView {
    
    func actionCloseButtonWasPressed(_ sender:UIButton) {
        delegate?.closeButtonWasPressed!(sender)
    }
    
    
    func actionBottomButtonWasPressed(_ sender: UIButton) {
        delegate?.bottomButtonWasPressed!(sender)
    }
    
    func enableConfirmButton(_ enable:Bool) {
        okButton.isEnabled = enable
    }
    
    func formatViewForCreateListFlow(){
        self.okButton.isEnabled = true
        titleLabel.text = Constants.AppLabels.addCollaborators
        closeButton.setImage(UIImage(named: "back_lampone"), for: UIControlState())
    }
    
}

