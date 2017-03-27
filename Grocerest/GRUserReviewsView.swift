//
//  GRUserReviewsView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 26/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import Haneke


class GRUserReviewsView: UIView {
    
    var navigationToolBar = GRToolbar()
    
    var labelView = UIView()
    
    fileprivate var userTopView = UIView()
    
    lazy var profileImageView : UserImage = {
        let userImage = UserImage()
        
        return userImage
    }()
    
    var usernameLabel = UILabel()
    var reputationIcon = UIImageView()
    var reputationLabel = UILabel()
    
    var levelLabel = UILabel()
    var separator = UIView()
    
    var recensioniLabel = UILabel()
    
    var tableView = UITableView()
    
    
    
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
        backgroundColor = UIColor.white
        
        self.addSubview(navigationToolBar)
        navigationToolBar.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.equalTo(0)
            make.left.equalTo(0)
        }
        
        
        addSubview(userTopView)
        userTopView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(126 / masterRatio)
            make.left.equalTo(0)
            make.top.equalTo(navigationToolBar.snp.bottom)
        }
        userTopView.backgroundColor = UIColor.white
        
        
        userTopView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(86 / masterRatio)
            make.left.equalTo(32 / masterRatio)
            make.centerY.equalTo(userTopView.snp.centerY)
            
        }
        
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(navigationToolBar.snp.bottom).offset(28 / masterRatio)
            make.left.equalTo(150 / masterRatio)
        }
        usernameLabel.font = UIFont.ubuntuBold(28)
        usernameLabel.textColor = UIColor(hexString: "#4A4A4A")
        
        addSubview(reputationIcon)
        reputationIcon.snp.makeConstraints { (make) in
            make.left.equalTo(usernameLabel.snp.left)
            make.top.equalTo(usernameLabel.snp.bottom).offset(11 / masterRatio)
            make.width.equalTo(16.88 / masterRatio)
            make.height.equalTo(15.32 / masterRatio)
        }
        reputationIcon.contentMode = .scaleAspectFill
        reputationIcon.image = UIImage(named: "small_yellow")
        
        
        addSubview(reputationLabel)
        reputationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(reputationIcon.snp.right).offset(5.12 / masterRatio)
            make.bottom.equalTo(reputationIcon.snp.bottom)
        }
        reputationLabel.font = UIFont.ubuntuBold(22)
        reputationLabel.textColor = UIColor(hexString: "#FBC02D")
        
        addSubview(levelLabel)
        levelLabel.snp.makeConstraints { (make) in
            make.left.equalTo(reputationLabel.snp.right).offset(18 / masterRatio)
            make.bottom.equalTo(reputationLabel.snp.bottom).offset(4 / masterRatio)
        }
        levelLabel.font = UIFont.avenirMedium(20)
        levelLabel.textColor = UIColor(hexString: "#29ABE2")
        
        addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(0)
            make.left.equalTo(0)
            make.top.equalTo(userTopView.snp.bottom)
        }
        separator.backgroundColor = UIColor(hexString: "#F1F1F1")
        
        
        separator.addSubview(recensioniLabel)
        recensioniLabel.font = UIFont.avenirBook(22)
        recensioniLabel.textColor = UIColor(hexString: "#979797")
  
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.bounces = true
        tableView.register(GRUserReviewTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 372 / masterRatio
            
        labelView.frame = CGRect(x: 10, y: 0, width: 486 / masterRatio, height: 60 / masterRatio)
        
        labelView.addSubview(recensioniLabel)
        recensioniLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20 / masterRatio)
            make.width.equalTo(400 / masterRatio)
            make.height.equalTo(20 / masterRatio)
            make.left.equalTo(30 / masterRatio)
        }
        
        
        
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.top.equalTo(separator.snp.bottom).offset(-2 / masterRatio)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
    
    
    func formatUserProfile(_ author:JSON, userStats:JSON) {
        let type = AvatarType.cells
        profileImageView.setUserProfileAvatar(author["picture"].stringValue, name: author["firstname"].stringValue, lastName: author["lastname"].stringValue, type: type)
        
        usernameLabel.text = author["username"].stringValue
        
        let userReputation = author["score"].intValue
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let reputationLocalized = formatter.string(from: NSNumber(value: userReputation)) ?? userReputation.description
        
        reputationLabel.text = "\(reputationLocalized)"
        levelLabel.text = "Livello \(userStats["level"].intValue)"
        
    }
    
    func formatRecensioniLabel(_ recensioni: Int) {
        if recensioni == 1 {
            recensioniLabel.text = "\(recensioni) commento scritto"
        } else {
            recensioniLabel.text = "\(recensioni) commenti scritti"
        }
        
    }
    
}
