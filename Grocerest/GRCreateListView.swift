//
//  GRCreateListView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 24/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRCreateListView: UIView, UITextFieldDelegate{
    
    var viewsByName: [String: UIView]!
    var confirmButton : UIButton?
    var shareListButton : UIButton?
    var inviteLabel : UILabel?
    
    var redundantLabel: UILabel!
    
    
    var nameListTextField : UITextField?
    
    var productView = UIView()
    var reviewCategoryImageView = UIImageView()
    var productMainLabel = UILabel()
    var brandLabel = UILabel()
    
    var partecipantiLabel = UILabel()
    
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
    
    var delegate: GRCreateListProtocol?
    
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
        __scaling__.backgroundColor = UIColor.white
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        let createLabel = UILabel()
        __scaling__.addSubview(createLabel)
        createLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(215 / masterRatio)
            make.height.equalTo(42 / masterRatio)
            make.top.equalTo(72 / masterRatio)
        }
        createLabel.text = Constants.AppLabels.ToolBarLabels.createAList
        createLabel.font = Constants.BrandFonts.ubuntuLight18
        createLabel.textColor = UIColor.grocerestColor()
        
        
        let closeButton = UIButton()
        __scaling__.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(createLabel.snp.centerY)
            make.left.equalTo(2 / masterRatio)
            make.width.height.equalTo(100 / masterRatio)
        }
        closeButton.contentMode = .center
        closeButton.setImage(UIImage(named: "close_modal"), for: UIControlState())
        
        closeButton.addTarget(self, action: #selector(GRCreateListView.actionCloseButtonWasPressed(_:)), for: .touchUpInside)
        
        confirmButton = UIButton()
        __scaling__.addSubview(confirmButton!)
        confirmButton!.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(createLabel.snp.centerY)
            make.right.equalTo(-2 / masterRatio)
            make.width.height.equalTo(100 / masterRatio)
        }
        confirmButton!.contentMode = .center
        confirmButton!.setImage(UIImage(named: "ok_lampone"), for: UIControlState())
        
        confirmButton!.addTarget(self, action:#selector(GRCreateListView.actionCreateListButtonWasPressed), for: .touchUpInside)
        
        
        
        
        
        let nomeListaView = UIView()
        __scaling__.addSubview(nomeListaView)
        nomeListaView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(170 / masterRatio)
            make.left.equalTo(0)
            make.top.equalTo(createLabel.snp.bottom).offset(40 / masterRatio)
        }
        nomeListaView.backgroundColor = UIColor.white
        
        
        let iconNewList = UIImageView()
        __scaling__.addSubview(iconNewList)
        iconNewList.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(44 / masterRatio)
            make.height.equalTo(49 / masterRatio)
            make.left.equalTo(77 / masterRatio)
            make.top.equalTo(nomeListaView.snp.top).offset(61 / masterRatio)
        }
        iconNewList.image = UIImage(named: "icona_nuova_lista")
        iconNewList.contentMode = .scaleAspectFit
        
        
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        
        let year =  components.year!
        let month = components.month!
        let day = components.day!
        
        redundantLabel = UILabel()
        __scaling__.addSubview(redundantLabel)
        redundantLabel.snp.makeConstraints { (make) in
            make.top.equalTo(createLabel.snp.bottom).offset(81 / masterRatio)
            make.left.equalTo(189 / masterRatio)
        }
        redundantLabel.font = Constants.BrandFonts.avenirHeavy11
        redundantLabel.textColor = UIColor.grocerestBlue()
        redundantLabel.textAlignment = .left
        redundantLabel.text = "Nome Lista"
        
        
        nameListTextField = UITextField()
        __scaling__.addSubview(nameListTextField!)
        nameListTextField!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(494 / masterRatio)
            make.height.equalTo(88 / masterRatio)
            make.left.equalTo(iconNewList.snp.right).offset(68 / masterRatio)
            make.centerY.equalTo(iconNewList.snp.centerY).offset(8 / masterRatio)
        }
        nameListTextField!.text = "Lista del \(day)-\(month)-\(year)"
        nameListTextField!.keyboardType = .asciiCapable
        nameListTextField?.returnKeyType = .go
        nameListTextField?.autocorrectionType = .yes
        
        viewsByName["nomeListaView"] = nomeListaView
        
        
        let separator = UIView()
        __scaling__.addSubview(separator)
        separator.backgroundColor = UIColor.F1F1F1Color()
        separator.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(68 / masterRatio)
            make.top.equalTo(nomeListaView.snp.bottom).offset(-1)
            make.left.equalTo(0)
        }
        
        let inviteFriendsListaView = UIView()
        __scaling__.addSubview(inviteFriendsListaView)
        inviteFriendsListaView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(165 / masterRatio)
            make.left.equalTo(0)
            make.top.equalTo(separator.snp.bottom).offset(10)
        }
        inviteFriendsListaView.backgroundColor = UIColor.white


        
        let inviteIconNewList = UIImageView()
        __scaling__.addSubview(inviteIconNewList)
        inviteIconNewList.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100 / masterRatio)
            make.left.equalTo(44.62 / masterRatio)
            make.top.equalTo(inviteFriendsListaView.snp.top).offset(29 / masterRatio)
        }
        inviteIconNewList.contentMode = .center
        inviteIconNewList.image = UIImage(named: "people")
        
        
        inviteLabel = UILabel()
        __scaling__.addSubview(inviteLabel!)
        inviteLabel!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(440 / masterRatio)
            make.height.equalTo(38 / masterRatio)
            make.left.equalTo(inviteIconNewList.snp.right).offset(43 / masterRatio)
            make.centerY.equalTo(inviteIconNewList.snp.centerY)
            
        }
        inviteLabel!.text = "Invita partecipanti";
        inviteLabel!.font = Constants.BrandFonts.avenirBook15
        inviteLabel!.textColor = UIColor.grocerestLightGrayColor()
        
        let disclosureButton = UIButton()
        __scaling__.addSubview(disclosureButton)
        disclosureButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(16 / masterRatio)
            make.height.equalTo(30 / masterRatio)
            make.right.equalTo(self.snp.right).offset(-33 / masterRatio)
            make.centerY.equalTo(inviteIconNewList.snp.centerY)
        }
        disclosureButton.contentMode = .center
        disclosureButton.setImage(UIImage(named: "disclosure_v2"), for: UIControlState())
        disclosureButton.addTarget(self, action: #selector(GRCreateListView.actionDisclosureWasPressed(_:)), for: .touchUpInside)
        
        
        shareListButton = UIButton()
        inviteFriendsListaView.addSubview(shareListButton!)
        shareListButton?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(inviteFriendsListaView)
        })
        shareListButton?.addTarget(self, action: #selector(GRCreateListView.actionShareListWasPressed(_:)), for: .touchUpInside)
        
        
        
        
        
        let separator2 = UIView()
        __scaling__.addSubview(separator2)
        separator2.backgroundColor = UIColor.white
        separator2.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(0.5 / masterRatio)
            make.top.equalTo(inviteFriendsListaView.snp.bottom).offset(-1)
            make.left.equalTo(0)
        }
        
//        
//        
//        partecipantiLabel = UILabel()
//        __scaling__.addSubview(partecipantiLabel)
//        partecipantiLabel.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(separator2.snp.top).offset(19 / masterRatio)
//            make.left.equalTo(45 / masterRatio)
//        }
//        partecipantiLabel.font = Constants.BrandFonts.avenirBook11
//        partecipantiLabel.textColor = UIColor.grocerestLightGrayColor()
//        partecipantiLabel.textAlignment = .Left
//        partecipantiLabel.text = "Partecipanti"
        
        
        
        
        __scaling__.addSubview(productView)
        productView.backgroundColor = UIColor.F1F1F1Color()
        productView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(75)
            make.top.equalTo(378)
            make.left.equalTo(0)
        }
        productView.isHidden = true

        
        
        let backView = UIView()
        productView.addSubview(backView)
        backView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100 / masterRatio)
            make.left.equalTo(productView.snp.left).offset(25)
            make.top.equalTo(productView.snp.top).offset(13.5)
        }
        backView.layer.borderWidth = 1.0
        backView.layer.masksToBounds = false
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.cornerRadius = 50 / masterRatio
        backView.clipsToBounds = true
        
        
        
        productView.addSubview(reviewCategoryImageView)
        reviewCategoryImageView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(76 / masterRatio)
            make.center.equalTo(backView.snp.center)
        }
        reviewCategoryImageView.contentMode = .scaleAspectFit
        
        
        
        productView.addSubview(productMainLabel)
        productMainLabel.font = Constants.BrandFonts.ubuntuBold14
        productMainLabel.textColor = UIColor.grocerestDarkBoldGray()
        productMainLabel.textAlignment = .left
        productMainLabel.numberOfLines = 2
        productMainLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(reviewCategoryImageView.snp.right).offset(14.5)
            make.top.equalTo(productView.snp.top).offset(13.5)
            make.width.equalTo(500 / masterRatio)
        }
        
        
        
        
        productView.addSubview(brandLabel)
        brandLabel.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo((productMainLabel.snp.width))
            make.top.equalTo(productMainLabel.snp.bottom).offset(6 / masterRatio)
            make.left.equalTo(reviewCategoryImageView.snp.right).offset(14.5)
        })
        brandLabel.font = Constants.BrandFonts.avenirBook11
        brandLabel.textColor = UIColor.grocerestLightGrayColor()
        brandLabel.textAlignment = .left
        
        
        
        
        
//        createListButton = UIButton()
//        __scaling__.addSubview(createListButton!)
//        createListButton!.snp.makeConstraints { (make) -> Void in
//            make.width.equalTo(self)
//            make.height.equalTo(120 / masterRatio)
//            make.bottom.equalTo(self.snp.bottom)
//        }
//        createListButton!.setTitle("Crea Lista", forState: .Normal)
//        createListButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//        createListButton!.titleLabel?.font = Constants.BrandFonts.ubuntuLight18
//        createListButton!.titleLabel?.textAlignment = .Center
//        createListButton!.backgroundColor = UIColor.grocerestBlue()
//        createListButton?.hidden = true
//        createListButton?.addTarget(delegate, action: Selector("createListWasPressed"), forControlEvents: .TouchUpInside)

        
        
        self.viewsByName = viewsByName
        
    }
    
    func actionCloseButtonWasPressed(_ sender: UIButton) {
        delegate?.closeButtonWasPressed(sender)
        
    }
    
    
    
    func actionDisclosureWasPressed(_ sender: UIButton) {
        delegate?.disclosureButtonWasPressed(sender)
    }
    

    
    func actionCreateListButtonWasPressed() {
        delegate?.createListWasPressed()
    }
    
    func actionShareListWasPressed(_ sender:UIButton) {
        delegate?.shareListWasPressed(sender)
    }
    
    
}
