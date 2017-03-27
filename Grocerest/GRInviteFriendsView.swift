//
//  GRInviteFriendsView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 12/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//


import Foundation
import UIKit

class GRInviteFriendsView: UIView {
    
    
    
    var inviteFriendsView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "invite_background")
        imageView.backgroundColor = UIColor.white
        
        return imageView
    }()
    
        
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
    
    
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    func setupHierarchy() {
        
        addSubview(inviteFriendsView)
        inviteFriendsView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(400 / masterRatio)
            make.left.equalTo(32 / masterRatio)
            make.top.equalTo(23 / masterRatio)
        }
    }
    
    
}


