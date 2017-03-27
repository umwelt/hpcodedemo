//
//  GRProfileViewController+UserProfile.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 31/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import Haneke

extension GRProfileViewController {
    
    func updateUserData(_ completion: (() -> Void)? = nil) {
        if let activeUserId = GrocerestAPI.userId {
            GrocerestAPI.getUser(activeUserId) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    if data["error"]["code"].stringValue == "E_UNAUTHORIZED" {
                        DispatchQueue.main.async { self.noUserOrInvalidToken() }
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    persistUserWithData(data)
                    completion?()
                }
            }
        } else {
            self.noUserOrInvalidToken()
        }
    }
    
    func getDataForUserStats() {
        if let activeUserId = GrocerestAPI.userId {
            GrocerestAPI.getUserStats(activeUserId) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }
                
                self.dataStats = data
                DispatchQueue.main.async { self.formatUserStats(data) }
            }
        }
    }
    
    func formatUserStats (_ data: JSON) {
        if let reviews = data["reviews"].int,
           let scanned = data["scanned"].int,
           let amici = data["successfulInvitations"].int,
           let added = data["eanAssociations"].int,
           let prodProposals = data["productProposals"].int {
            managedView.fillUserStatsData(String(reviews), scansioni: String(scanned), amici: String(amici), aggiunti: String(added + prodProposals))
        }
    }
    
    func formatUserProfile() {
        let topMargin = 49.00 / masterRatio
        
        managedView.navigationToolBar.grocerestButton?.setTitle(GRUser.sharedInstance.username, for: UIControlState())
        
        let userReputation = GRUser.sharedInstance.score!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let reputationLocalized = formatter.string(from: NSNumber(value: userReputation)) ?? userReputation.description
        
        managedView.userReputationNumericalLabel.text = "\(reputationLocalized)"
        
        managedView.userLabelGrade.text = "Livello \(GRUser.sharedInstance.level!)"
        managedView.memberSince = convertFromTimestamp(GRUser.sharedInstance.memberSince!)
        
        switch GRUser.sharedInstance.level! {
        case 1:
            managedView.indicatorLevelbar.image = UIImage(named: "level_one")
            managedView.badgeImageView.image = UIImage(named: "v2_level_one")
            managedView.valueLabel.text = "1/5"
            managedView.valueLabel.snp.remakeConstraints { make in
                make.width.equalTo(126 / masterRatio)
                make.height.equalTo(30 / masterRatio)
                make.left.equalTo(self.managedView.reputationView.snp.left).offset(185 / masterRatio)
                make.top.equalTo(self.managedView.reputationView.snp.top).offset(topMargin)
            }
        case 2:
            managedView.indicatorLevelbar.image = UIImage(named: "level_two")
            managedView.badgeImageView.image = UIImage(named: "v2_level_two")
            managedView.valueLabel.text = "2/5"
            managedView.valueLabel.snp.remakeConstraints { make in
                make.width.equalTo(126 / masterRatio)
                make.height.equalTo(30 / masterRatio)
                make.left.equalTo(self.managedView.reputationView.snp.left).offset(245 / masterRatio)
                make.top.equalTo(self.managedView.reputationView.snp.top).offset(topMargin)
            }
        case 3:
            managedView.indicatorLevelbar.image = UIImage(named: "level_three")
            managedView.badgeImageView.image = UIImage(named: "v2_level_three")
            managedView.valueLabel.text = "3/5"
            managedView.valueLabel.snp.remakeConstraints { make in
                make.width.equalTo(126 / masterRatio)
                make.height.equalTo(30 / masterRatio)
                make.left.equalTo(self.managedView.reputationView.snp.left).offset(305 / masterRatio)
                make.top.equalTo(self.managedView.reputationView.snp.top).offset(topMargin)
            }
        case 4:
            managedView.indicatorLevelbar.image = UIImage(named: "level_four")
            managedView.badgeImageView.image = UIImage(named: "v2_level_four")
            managedView.valueLabel.text = "4/5"
            managedView.valueLabel.snp.remakeConstraints { make in
                make.width.equalTo(126 / masterRatio)
                make.height.equalTo(30 / masterRatio)
                make.left.equalTo(self.managedView.reputationView.snp.left).offset(360 / masterRatio)
                make.top.equalTo(self.managedView.reputationView.snp.top).offset(topMargin)
            }
        case 5:
            managedView.indicatorLevelbar.image = UIImage(named: "level_five")
            managedView.badgeImageView.image = UIImage(named: "v2_level_five")
            managedView.valueLabel.text = "5/5"
            managedView.valueLabel.snp.remakeConstraints { make in
                make.width.equalTo(126 / masterRatio)
                make.height.equalTo(30 / masterRatio)
                make.left.equalTo(self.managedView.reputationView.snp.left).offset(416 / masterRatio)
                make.top.equalTo(self.managedView.reputationView.snp.top).offset(topMargin)
            }
        default:
            managedView.indicatorLevelbar.image = UIImage(named: "level_one")
            managedView.badgeImageView.image = UIImage(named: "v2_level_one")
            managedView.valueLabel.text = "1/5"
        }
        
        managedView.navigationToolBar.setNeedsDisplay()
        let type = AvatarType.profile
        managedView.profileImageView.setUserProfileAvatar(GRUser.sharedInstance.picture!, name: GRUser.sharedInstance.firstname!, lastName: GRUser.sharedInstance.lastname!, type: type)
    }
    
}
