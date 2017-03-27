//
//  GRModifyListView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/02/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit


class GRModifyListView: UIView {
    
    var delegate = GRModifyListViewController()
    var closeButton = UIButton(type: .custom)
    var iconSize = CGSize(width: 48 / masterRatio, height: 48 / masterRatio)
    
    var listNameTextField = UITextField()
    var separator = UIView()
    var partecipantiLabel = UILabel()
    var topView = UIView()
    var inviteFriendsListaView = UIView()
    
    var nameListView = UIView()

    
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
        
        self.backgroundColor = UIColor(white:0.95, alpha:1.0)
        
        
        topView.backgroundColor = UIColor.white
        addSubview(topView)
        topView.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(0)
            make.height.equalTo(149 / masterRatio)
            make.width.equalTo(self)
        }
        
        let titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(72 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        titleLabel.font = Constants.BrandFonts.ubuntuLight18
        titleLabel.textColor = UIColor.grocerestColor()
        titleLabel.textAlignment = .center
        titleLabel.text = Constants.AppLabels.manageList
        
        closeButton = UIButton(type: .custom)
        self.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100 / masterRatio)
            make.left.equalTo(0)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        closeButton.contentMode = .center
        closeButton.setImage(UIImage(named: "back_lampone"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(GRModifyListView.InCloseButtonWasPressed(_:)), for: .touchUpInside)
        
        
        nameListView.backgroundColor = UIColor.white
        addSubview(nameListView)
        nameListView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(165 / masterRatio)
            make.left.equalTo(0)
            make.top.equalTo(149 / masterRatio)
        }
        
        
        
        let iconList = UIImageView()
        addSubview(iconList)
        iconList.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(42.47 / masterRatio)
            make.height.equalTo(48.56 / masterRatio)
            make.left.equalTo(76.82 / masterRatio)
            make.centerY.equalTo(nameListView.snp.centerY)
        }
        
        iconList.contentMode = .center
        iconList.image = UIImage(named: "icona_nuova_lista")
        
        
        let modificaListLabel = UILabel()
        addSubview(modificaListLabel)
        modificaListLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200 / masterRatio)
            make.left.equalTo(iconList.snp.right).offset(69 / masterRatio)
            make.top.equalTo(titleLabel.snp.bottom).offset(71.5 / masterRatio)
        }
        modificaListLabel.font = Constants.BrandFonts.avenirHeavy11
        modificaListLabel.textColor = UIColor.grocerestBlue()
        modificaListLabel.textAlignment = .left
        modificaListLabel.text = "Nome Lista"
        
        
        listNameTextField = UITextField()
        addSubview(listNameTextField)
        listNameTextField.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(450 / masterRatio)
            make.height.equalTo(50 / masterRatio)
            make.top.equalTo(modificaListLabel.snp.bottom)
            make.left.equalTo(modificaListLabel.snp.left)
        }
        listNameTextField.font = Constants.BrandFonts.avenirBook15
        listNameTextField.textColor = UIColor.grocerestLightGrayColor()
        listNameTextField.returnKeyType = .go
        
        
        
        
        
        inviteFriendsListaView.backgroundColor = UIColor.white
        addSubview(inviteFriendsListaView)
        inviteFriendsListaView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(165 / masterRatio)
            make.left.equalTo(0)
            make.top.equalTo(nameListView.snp.bottom).offset(69 / masterRatio)
        }
        
        
        let inviteIconNewList = UIImageView()
        inviteFriendsListaView.addSubview(inviteIconNewList)
        inviteIconNewList.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100 / masterRatio)
            make.left.equalTo(44.62 / masterRatio)
            make.centerY.equalTo(inviteFriendsListaView.snp.centerY)
        }
        inviteIconNewList.contentMode = .center
        inviteIconNewList.image = UIImage(named: "people")
        
        
        let inviteLabel = UILabel()
        inviteFriendsListaView.addSubview(inviteLabel)
        inviteLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(450 / masterRatio)
            make.centerY.equalTo(inviteFriendsListaView.snp.centerY)
            make.left.equalTo(inviteIconNewList.snp.right).offset(69 / masterRatio)
            
        }
        inviteLabel.text = "Invita partecipanti";
        inviteLabel.font = Constants.BrandFonts.avenirBook15
        inviteLabel.textColor = UIColor.grocerestLightGrayColor()
        
        
        let disclosureImage = UIImageView()
        inviteFriendsListaView.addSubview(disclosureImage)
        disclosureImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(16 / masterRatio)
            make.height.equalTo(30 / masterRatio)
            make.right.equalTo(-33 / masterRatio)
            make.centerY.equalTo(inviteFriendsListaView.snp.centerY)
        }
        disclosureImage.contentMode = .scaleAspectFit
        disclosureImage.image = UIImage(named: "disclosure_v2")
        
        
        let inviteFriendsButton = UIButton(type: .custom)
        inviteFriendsListaView.addSubview(inviteFriendsButton)
        inviteFriendsButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(inviteFriendsListaView)
        }
        inviteFriendsButton.addTarget(self, action: #selector(GRModifyListView.shareListButtonWasPressed(_:)), for: .touchUpInside)
        
        
        
//        separator = UIView()
//        addSubview(separator)
//        separator.backgroundColor = UIColor.lightGrayColor()
//        separator.snp.makeConstraints { (make) -> Void in
//            make.width.equalTo(self.snp.width)
//            make.height.equalTo(0.5)
//            make.top.equalTo(inviteFriendsListaView.snp.bottom)
//            make.centerX.equalTo(self.snp.centerX)
//        }
//        
        partecipantiLabel = UILabel()
        addSubview(partecipantiLabel)
        partecipantiLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(inviteFriendsButton.snp.bottom)
            make.left.equalTo(45 / masterRatio)
            make.height.equalTo(65 / masterRatio)
        }
        partecipantiLabel.font = Constants.BrandFonts.avenirBook11
        partecipantiLabel.textColor = UIColor.grocerestLightGrayColor()
        partecipantiLabel.textAlignment = .left
        partecipantiLabel.text = "Partecipanti"
        
        
    }
}


extension GRModifyListView {
    
    func shareListButtonWasPressed(_ sender:UIButton){
        delegate.shareListWasPressed(sender)
    }
    
    func InCloseButtonWasPressed(_ sender:UIButton) {
        delegate.closeButtonWasPressed(sender)
    }
    
    func formatForCollaborator(){
        inviteFriendsListaView.isHidden = true
        listNameTextField.isUserInteractionEnabled = false
        
        partecipantiLabel.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(self.snp.width)
            make.left.equalTo(45 / masterRatio)
            make.height.equalTo(65 / masterRatio)
            make.top.equalTo(nameListView.snp.bottom)
        }
        
    }
    
    
}
