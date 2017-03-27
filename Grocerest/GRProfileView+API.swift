//
//  GRProfileView+API.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 16/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

extension GRProfileView {

    func menuButtonWasPressed(_ sender: UIButton){
        delegate?.menuButtonWasPressed(sender)
    }
    
    func grocerestButtonWasPressed(_ sender: UIButton){
        delegate?.grocerestButtonWasPressed(sender)
    }
    
    func profileImageWasTapped(_ sender: UIButton) {
        delegate?.settingsButtonWasPressed(sender)
    }
    
    /**
     *  filtered list
     */
    func actionPreferitiButtonWasPressed(_ sender:UIButton) {
        preferitiLabel.textColor = UIColor.grocerestDarkBoldGray()
        evitareLabel.textColor = UIColor.grocerestOffText()
        provareLabel.textColor = UIColor.grocerestOffText()
        recensitiLabel.textColor = UIColor.grocerestOffText()
        scansioniLabel.textColor = UIColor.grocerestOffText()
        
        paginatedScrollView.scrollRectToVisible(viewsByName["preferitiView"]!.frame, animated: true)
        preferitiButton.setImage(UIImage(named: "preferiti_on_dark"), for: UIControlState())
        evitareButton.setImage(UIImage(named: "evitare_off_dark"), for: UIControlState())
        provareButton.setImage(UIImage(named: "provare_off_dark"), for: UIControlState())
        recensitiButton.setImage(UIImage(named: "recensioni_off"), for: UIControlState())
        scansioniButton.setImage(UIImage(named: "scansioni_off"), for: UIControlState())
        
        delegate?.preferitiButtonWasPressed(sender)
        selectedImageView.snp.remakeConstraints { make in
            make.width.equalTo(200 / masterRatio)
            make.height.equalTo(8.5 / masterRatio)
            make.left.equalTo(viewsByName["preferitiView"]!.snp.left)
            make.bottom.equalTo(viewsByName["preferitiView"]!.snp.bottom).offset(4)
        }
    }
    
    func actionEvitareButtonWasPressed(_ sender:UIButton){
        preferitiLabel.textColor = UIColor.grocerestOffText()
        evitareLabel.textColor = UIColor.grocerestDarkBoldGray()
        provareLabel.textColor = UIColor.grocerestOffText()
        recensitiLabel.textColor = UIColor.grocerestOffText()
        scansioniLabel.textColor = UIColor.grocerestOffText()
        
        paginatedScrollView.scrollRectToVisible(viewsByName["preferitiView"]!.frame, animated: true)
        preferitiButton.setImage(UIImage(named: "preferiti_off_dark"), for: UIControlState())
        evitareButton.setImage(UIImage(named: "evitare_on_dark"), for: UIControlState())
        provareButton.setImage(UIImage(named: "provare_off_dark"), for: UIControlState())
        recensitiButton.setImage(UIImage(named: "recensioni_off"), for: UIControlState())
        scansioniButton.setImage(UIImage(named: "scansioni_off"), for: UIControlState())
        delegate?.evitareButtonWasPressed(sender)
        selectedImageView.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(200 / masterRatio)
            make.height.equalTo(8.5 / masterRatio)
            make.left.equalTo(viewsByName["evitareView"]!.snp.left)
            make.bottom.equalTo(viewsByName["preferitiView"]!.snp.bottom).offset(4)
        }
    }
    
    func actionProvareButtonWasPressed(_ sender:UIButton) {
        preferitiLabel.textColor = UIColor.grocerestOffText()
        evitareLabel.textColor = UIColor.grocerestOffText()
        provareLabel.textColor = UIColor.grocerestDarkBoldGray()
        recensitiLabel.textColor = UIColor.grocerestOffText()
        scansioniLabel.textColor = UIColor.grocerestOffText()
        
        paginatedScrollView.scrollRectToVisible(viewsByName["preferitiView"]!.frame, animated: true)
        preferitiButton.setImage(UIImage(named: "preferiti_off_dark"), for: UIControlState())
        evitareButton.setImage(UIImage(named: "evitare_off_dark"), for: UIControlState())
        provareButton.setImage(UIImage(named: "provare_on_dark"), for: UIControlState())
        recensitiButton.setImage(UIImage(named: "recensioni_off"), for: UIControlState())
        scansioniButton.setImage(UIImage(named: "scansioni_off"), for: UIControlState())
        delegate?.provareButtonWasPressed(sender)
        selectedImageView.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(200 / masterRatio)
            make.height.equalTo(8.5 / masterRatio)
            make.left.equalTo(viewsByName["provareView"]!.snp.left)
            make.bottom.equalTo(viewsByName["preferitiView"]!.snp.bottom).offset(4)
        }
    }
    
    func actionRecensitiButtonWasPressed(_ sender: UIButton) {
        preferitiLabel.textColor = UIColor.grocerestOffText()
        evitareLabel.textColor = UIColor.grocerestOffText()
        provareLabel.textColor = UIColor.grocerestOffText()
        recensitiLabel.textColor = UIColor.grocerestDarkBoldGray()
        scansioniLabel.textColor = UIColor.grocerestOffText()
        
        paginatedScrollView.scrollRectToVisible(viewsByName["scansioniView"]!.frame, animated: true)
        preferitiButton.setImage(UIImage(named: "preferiti_off_dark"), for: UIControlState())
        evitareButton.setImage(UIImage(named: "evitare_off_dark"), for: UIControlState())
        provareButton.setImage(UIImage(named: "provare_off_dark"), for: UIControlState())
        recensitiButton.setImage(UIImage(named: "recensioni_on"), for: UIControlState())
        scansioniButton.setImage(UIImage(named: "scansioni_off"), for: UIControlState())
        delegate?.recensitiButtonWasPressed(sender)
        selectedImageView.snp.remakeConstraints { make in
            make.width.equalTo(200 / masterRatio)
            make.height.equalTo(8.5 / masterRatio)
            make.left.equalTo(viewsByName["recensitiView"]!.snp.left)
            make.bottom.equalTo(viewsByName["preferitiView"]!.snp.bottom).offset(4)
        }
    }
    
    func actionScansioneButtonWasPressed(_ sender: UIButton) {
        preferitiLabel.textColor = UIColor.grocerestOffText()
        evitareLabel.textColor = UIColor.grocerestOffText()
        provareLabel.textColor = UIColor.grocerestOffText()
        recensitiLabel.textColor = UIColor.grocerestOffText()
        scansioniLabel.textColor = UIColor.grocerestDarkBoldGray()
        
        scansioniButton.setImage(UIImage(named: "scansioni_on"), for: UIControlState())
        paginatedScrollView.scrollRectToVisible(viewsByName["scansioniView"]!.frame, animated: true)
        preferitiButton.setImage(UIImage(named: "preferiti_off_dark"), for: UIControlState())
        evitareButton.setImage(UIImage(named: "evitare_off_dark"), for: UIControlState())
        provareButton.setImage(UIImage(named: "provare_off_dark"), for: UIControlState())
        recensitiButton.setImage(UIImage(named: "recensioni_off"), for: UIControlState())
        scansioniButton.setImage(UIImage(named: "scansioni_on"), for: UIControlState())
        delegate?.scansioneButtonWasPressed(sender)
        selectedImageView.snp.remakeConstraints { make in
            make.width.equalTo(200 / masterRatio)
            make.height.equalTo(8.5 / masterRatio)
            make.left.equalTo(viewsByName["scansioniView"]!.snp.left)
            make.bottom.equalTo(viewsByName["preferitiView"]!.snp.bottom).offset(4)
        }
    }
    
    func actionSeeAllWasPressed() {
        delegate?.presentFullConstentsForList()
    }
    
    func actionInviteFriendsButtonWasPressed(_ sender:UIButton){
        delegate!.inviteFriendsButtonWasPressed(sender)
    }
    
    func fillUserStatsData(_ recensioni:String, scansioni:String, amici: String, aggiunti:String) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.recensioniStatBox.statCounter.text = recensioni
            self.scansioniStatBox.statCounter.text = scansioni
            self.amiciStatBox.statCounter.text = amici
            self.aggiuntiStatBox.statCounter.text = aggiunti
            
            self.recensioniStatBox.alpha = 1
            self.scansioniStatBox.alpha = 1
            self.amiciStatBox.alpha = 1
            self.aggiuntiStatBox.alpha = 1
            }, completion: nil)
    }
    
    func formatViewForNoRows() {
        seeAllButton.isHidden = true
        ghostTableBackground.isHidden = true
        viewsByName["oldWrapper"]?.snp.remakeConstraints { make in
            make.width.equalTo(__scaling__)
            make.height.equalTo((1960 - 885) / masterRatio)
        }
    }
    
    func formatViewForOneRow() {
        seeAllButton.isHidden = true
        ghostTableBackground.isHidden = false
        viewsByName["oldWrapper"]?.snp.remakeConstraints { make in
            make.width.equalTo(__scaling__)
            make.height.equalTo((2120 - 885) / masterRatio)
        }
    }
    
    func formatViewForTwoRows() {
        seeAllButton.isHidden = true
        ghostTableBackground.isHidden = false
        viewsByName["oldWrapper"]?.snp.remakeConstraints { make in
            make.width.equalTo(__scaling__)
            make.height.equalTo((2480 - 885) / masterRatio)
        }
    }
    
    func formatViewForThreeRows() {
        seeAllButton.isHidden = true
        ghostTableBackground.isHidden = false
        viewsByName["oldWrapper"]?.snp.remakeConstraints { make in
            make.width.equalTo(__scaling__)
            make.height.equalTo((2890 - (885 + 50)) / masterRatio)
        }
    }
    
    func formatViewForFullSize() {
        seeAllButton.isHidden = false
        ghostTableBackground.isHidden = false
        viewsByName["oldWrapper"]?.snp.remakeConstraints { make in
            make.width.equalTo(__scaling__)
            make.height.equalTo((2890 - (885 - 30)) / masterRatio)
        }
    }
    
}
