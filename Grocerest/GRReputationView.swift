//
//  GRReputationView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRReputationView: UIView {
    
    var scrollView: UIScrollView!
    let blurEffect = UIBlurEffect(style: .dark)
    var wrapper: UIView!
    
    // Labels
    
    var reputationWithDate: UILabel!
    var pointsCounter: UILabel!
    
    var pointsToLevelTop: UILabel!
    var pointsTo: UILabel!
    var pointsToLevelBottom: UILabel!
    var pointsAfterLastLevel: UILabel!
    
    var badgeFrom: UIImageView!
    var badgeTo: UIImageView!
    
    var progressBar: UIProgressView!
    var levelBar: UIImageView!
    
    var labelFrom: UILabel!
    var labelTo: UILabel!
    
    var pointsDetailHeaderLabel: UILabel!
    
    var iscrizioniLabel: UILabel!
    var iscrizionePunti: UILabel!
    var registrazioneSuInvitoLabel: UILabel!
    var registrazioneSuInvitoPunti: UILabel!
    
    var separatorFirst: UIView!
    
    var genderLabel: UILabel!
    var genderPunti: UILabel!
    
    var nucleoFamilyLabel: UILabel!
    var nucleoFamilyPunti: UILabel!
    
    
    var birthdayLabel: UILabel!
    var birthdayPunti: UILabel!
    
    var facebookLabel: UILabel!
    var facebookPunti: UILabel!
    
    var separatorSecond: UIView!
    
    
    var votiLabel: UILabel!
    var votiNumber: UILabel!
    var votiPunti: UILabel!
    
    var frequencyLabel: UILabel!
    var frequencyNumber: UILabel!
    var frequencyPunt: UILabel!
    
    var commentiLabel: UILabel!
    var commentiNumber: UILabel!
    var commentiPunti: UILabel!
    
    var scannedLabel: UILabel!
    var scannedNumber: UILabel!
    var scannedPunti: UILabel!
    
    var separatorThird: UIView!
    
    var iscrittiLabel: UILabel!
    var iscrittiNumber: UILabel!
    var iscrittiPunti: UILabel!
    
    var votiUtiliLabel: UILabel!
    var votiUtiliNumber: UILabel!
    var votiUtiliPunti: UILabel!
    
    var prodottiAddLabel: UILabel!
    var prodottiAddNumber: UILabel!
    var prodottiAddPunti: UILabel!
    
    var sharedLists: UILabel!
    var sharedListsNumber: UILabel!
    var sharedListsPunti: UILabel!
    
    var progressView = UIProgressView()
    
    var delegate : GRReputationViewController!
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHierarchy()
    }
    
    // - MARK: Scaling
    
    func setupHierarchy() {
        scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        scrollView.addSubview(blurredEffectView)
        blurredEffectView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        wrapper = UIView()
        scrollView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        scrollView.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(self)
            make.height.equalTo(2100 / masterRatio)
        }
        
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "black_close"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(self.closeViewWasPressed(_:)), for: .touchUpInside)
        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(64 / masterRatio)
            make.right.equalTo(-40 / masterRatio)
            make.top.equalTo(40 / masterRatio)
        }
        
        reputationWithDate = UILabel()
        reputationWithDate.font = .avenirMedium(24)
        reputationWithDate.textColor = .white
        reputationWithDate.textAlignment = .center
        wrapper.addSubview(reputationWithDate)
        reputationWithDate.snp.makeConstraints { make in
            make.top.equalTo(wrapper.snp.top).offset(157 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.height.equalTo(33 / masterRatio)
        }
        
        pointsCounter = UILabel()
        pointsCounter.font = .ubuntuMedium(128)
        pointsCounter.textColor = .white
        pointsCounter.textAlignment = .left
        pointsCounter.text = "    "
        wrapper.addSubview(pointsCounter)
        pointsCounter.snp.makeConstraints { make in
            make.left.equalTo(184 / masterRatio)
            make.top.equalTo(reputationWithDate.snp.bottom).offset(31 / masterRatio)
            make.height.equalTo(147 / masterRatio)
        }
        
        let decorationView = UIView()
        wrapper.addSubview(decorationView)
        decorationView.snp.makeConstraints { make in
            make.width.equalTo(78 / masterRatio)
            make.height.equalTo(97 / masterRatio)
            make.left.equalTo(pointsCounter.snp.right).offset(14 / masterRatio)
            make.centerY.equalTo(pointsCounter.snp.centerY)
        }
        
        let iconGrocerest = UIImageView()
        iconGrocerest.contentMode = .scaleAspectFit
        iconGrocerest.image = UIImage(named: "yellow_hearth")
        decorationView.addSubview(iconGrocerest)
        iconGrocerest.snp.makeConstraints { make in
            make.width.equalTo(55 / masterRatio)
            make.height.equalTo(51 / masterRatio)
            make.top.equalTo(decorationView.snp.top)
            make.centerX.equalTo(decorationView.snp.centerX)
        }
        
        let staticPuntiLabel = UILabel()
        staticPuntiLabel.font = .avenirMedium(24)
        staticPuntiLabel.textAlignment = .center
        staticPuntiLabel.textColor = .white
        staticPuntiLabel.text = "PUNTI"
        decorationView.addSubview(staticPuntiLabel)
        staticPuntiLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconGrocerest.snp.centerX)
            make.top.equalTo(iconGrocerest.snp.bottom).offset(13 / masterRatio)
        }
        
        let pointsHolder = UIView()
        wrapper.addSubview(pointsHolder)
        pointsHolder.snp.makeConstraints { make in
            make.width.equalTo(371 / masterRatio)
            make.height.equalTo(74 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(decorationView.snp.bottom).offset(65 / masterRatio)
        }
        
        pointsAfterLastLevel = UILabel()
        pointsAfterLastLevel.font = .avenirLight(24)
        pointsAfterLastLevel.textColor = .white
        pointsAfterLastLevel.textAlignment = .center
        pointsAfterLastLevel.text = "Complimenti \(GRUser.sharedInstance.username!)!\nHai raggiunto il massimo\nlivello di Grocerest, per ora.."
        pointsAfterLastLevel.numberOfLines = 3
        pointsAfterLastLevel.isHidden = true
        pointsHolder.addSubview(pointsAfterLastLevel)
        pointsAfterLastLevel.snp.makeConstraints { make in
            make.top.left.right.equalTo(pointsHolder)
        }
        
        pointsToLevelTop = UILabel()
        pointsToLevelTop.font = .avenirLight(24)
        pointsToLevelTop.textColor = .white
        pointsToLevelTop.textAlignment = .left
        pointsToLevelTop.text = "Ti mancano"
        pointsToLevelTop.isHidden = false
        pointsHolder.addSubview(pointsToLevelTop)
        pointsToLevelTop.snp.makeConstraints { make in
            make.left.equalTo(pointsHolder.snp.left).offset(38 / masterRatio)
            make.top.equalTo(pointsHolder.snp.top)
        }
        
        pointsTo = UILabel()
        pointsTo.font = .ubuntuMedium(32)
        pointsTo.textColor = .white
        pointsTo.textAlignment = .right
        pointsTo.isHidden = false
        pointsHolder.addSubview(pointsTo)
        pointsTo.snp.makeConstraints { make in
            make.left.equalTo(pointsToLevelTop.snp.right).offset(19 / masterRatio)
            make.bottom.equalTo(pointsToLevelTop.snp.bottom).offset(-2 / masterRatio)
        }
        
        pointsToLevelBottom = UILabel()
        pointsToLevelBottom.font = .avenirLight(24)
        pointsToLevelBottom.textColor = .white
        pointsToLevelBottom.textAlignment = .left
        pointsToLevelBottom.isHidden = false
        pointsHolder.addSubview(pointsToLevelBottom)
        pointsToLevelBottom.snp.makeConstraints { make in
            make.top.equalTo(pointsToLevelTop.snp.bottom).offset(8 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
        }
        
        badgeFrom = UIImageView()
        badgeFrom.contentMode = .scaleAspectFit
        wrapper.addSubview(badgeFrom)
        badgeFrom.snp.makeConstraints { make in
            make.width.height.equalTo(80 / masterRatio)
            make.left.equalTo(86 / masterRatio)
            make.top.equalTo(reputationWithDate.snp.bottom).offset(250 / masterRatio)
        }
        
        badgeTo = UIImageView()
        badgeTo.contentMode = .scaleAspectFit
        wrapper.addSubview(badgeTo)
        badgeTo.snp.makeConstraints { make in
            make.width.height.equalTo(80 / masterRatio)
            make.right.equalTo(-86 / masterRatio)
            make.top.equalTo(badgeFrom.snp.top)
        }
        
        levelBar = UIImageView()
        levelBar.contentMode = .scaleAspectFit
        levelBar.image = UIImage(named: "level_progress_bar")
        wrapper.addSubview(levelBar)
        levelBar.snp.makeConstraints { make in
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(badgeFrom.snp.bottom).offset(12 / masterRatio)
            make.width.equalTo(526 / masterRatio)
            make.height.equalTo(26 / masterRatio)
        }
        
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        progressView.tintColor = .grocerestBlue()
        progressView.trackTintColor = .clear
        wrapper.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(badgeFrom.snp.bottom).offset(23 / masterRatio)
            make.width.equalTo(474 / masterRatio)
            make.height.equalTo(5 / masterRatio)
        }
        
        labelFrom = UILabel()
        labelFrom.font = .ubuntuMedium(26)
        labelFrom.textColor = .white
        labelFrom.textAlignment = .left
        wrapper.addSubview(labelFrom)
        labelFrom.snp.makeConstraints { make in
            make.left.equalTo(64 / masterRatio)
            make.top.equalTo(levelBar.snp.bottom).offset(16 / masterRatio)
        }
        
        labelTo = UILabel()
        labelTo.font = .ubuntuMedium(26)
        labelTo.textColor = .grocerestDarkBoldGray()
        labelTo.textAlignment = .left
        wrapper.addSubview(labelTo)
        labelTo.snp.makeConstraints { make in
            make.right.equalTo(-64 / masterRatio)
            make.top.equalTo(labelFrom.snp.top)
        }
        
        pointsDetailHeaderLabel = UILabel()
        pointsDetailHeaderLabel.font = .ubuntuLight(36)
        pointsDetailHeaderLabel.textAlignment = .center
        pointsDetailHeaderLabel.textColor = .lightBlurredGray()
        pointsDetailHeaderLabel.text = "DETTAGLIO PUNTEGGIO"
        wrapper.addSubview(pointsDetailHeaderLabel)
        pointsDetailHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(labelTo.snp.bottom).offset(92 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
        }
        
        let leftMargin = 59 / masterRatio
        let rightMargin = -59 / masterRatio
        
        iscrizioniLabel = UILabel.statsStaticLabel()
        iscrizioniLabel.text = "Iscrizione"
        wrapper.addSubview(iscrizioniLabel)
        iscrizioniLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(pointsDetailHeaderLabel.snp.bottom).offset(51 / masterRatio)
        }
        
        iscrizionePunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(iscrizionePunti)
        iscrizionePunti.snp.makeConstraints { make in
            make.right.equalTo(rightMargin)
            make.top.equalTo(iscrizioniLabel.snp.top)
        }
        
        registrazioneSuInvitoLabel = UILabel.statsStaticLabel()
        registrazioneSuInvitoLabel.text = "Registrazione su invito"
        wrapper.addSubview(registrazioneSuInvitoLabel)
        registrazioneSuInvitoLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(iscrizioniLabel.snp.bottom).offset(32 / masterRatio)
        }
        
        registrazioneSuInvitoPunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(registrazioneSuInvitoPunti)
        registrazioneSuInvitoPunti.snp.makeConstraints { make in
            make.right.equalTo(rightMargin)
            make.top.equalTo(registrazioneSuInvitoLabel.snp.top)
        }
        
        separatorFirst = UIView()
        separatorFirst.backgroundColor = .lightBlurredGray()
        wrapper.addSubview(separatorFirst)
        separatorFirst.snp.makeConstraints { make in
            make.height.equalTo(1 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.width.equalTo(630 / masterRatio)
            make.top.equalTo(registrazioneSuInvitoLabel.snp.bottom).offset(41 / masterRatio)
        }
        
        genderLabel = UILabel.statsStaticLabel()
        genderLabel.text = "Sesso"
        wrapper.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(separatorFirst.snp.bottom).offset(34 / masterRatio)
        }
        
        birthdayLabel = UILabel.statsStaticLabel()
        birthdayLabel.text = "Data di nascita"
        wrapper.addSubview(birthdayLabel)
        birthdayLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(genderLabel.snp.bottom).offset(32 / masterRatio)
        }
        
        nucleoFamilyLabel = UILabel.statsStaticLabel()
        nucleoFamilyLabel.text = "Nucleo Familiare"
        wrapper.addSubview(nucleoFamilyLabel)
        nucleoFamilyLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(birthdayLabel.snp.bottom).offset(32 / masterRatio)
        }
        
        nucleoFamilyPunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(nucleoFamilyPunti)
        nucleoFamilyPunti.snp.makeConstraints { make in
            make.right.equalTo(rightMargin)
            make.top.equalTo(nucleoFamilyLabel.snp.top)
        }
        
        facebookLabel = UILabel.statsStaticLabel()
        facebookLabel.text = "Collegamento Facebook"
        wrapper.addSubview(facebookLabel)
        facebookLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(nucleoFamilyLabel.snp.bottom).offset(32 / masterRatio)
        }
        
        genderPunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(genderPunti)
        genderPunti.snp.makeConstraints { make in
            make.right.equalTo(rightMargin)
            make.top.equalTo(genderLabel.snp.top)
        }
        
        birthdayPunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(birthdayPunti)
        birthdayPunti.snp.makeConstraints { make in
            make.right.equalTo(rightMargin)
            make.top.equalTo(birthdayLabel.snp.top)
        }
        
        facebookPunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(facebookPunti)
        facebookPunti.snp.makeConstraints { make in
            make.right.equalTo(rightMargin)
            make.top.equalTo(facebookLabel.snp.top)
        }
        
        separatorSecond = UIView()
        separatorSecond.backgroundColor = .lightBlurredGray()
        wrapper.addSubview(separatorSecond)
        separatorSecond.snp.makeConstraints { make in
            make.height.equalTo(1 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.width.equalTo(630 / masterRatio)
            make.top.equalTo(facebookPunti.snp.bottom).offset(41 / masterRatio)
        }
        
        votiLabel = UILabel.statsStaticLabel()
        votiLabel.text = "Voti"
        wrapper.addSubview(votiLabel)
        votiLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(separatorSecond.snp.bottom).offset(36 / masterRatio)
            
        }
        
        votiNumber = UILabel.statsStaticLabel()
        wrapper.addSubview(votiNumber)
        votiNumber.snp.makeConstraints { make in
            make.top.equalTo(votiLabel.snp.top)
            make.centerX.equalTo(wrapper.snp.centerX)
        }
        
        votiPunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(votiPunti)
        votiPunti.snp.makeConstraints { make in
            make.top.equalTo(votiLabel.snp.top)
            make.right.equalTo(rightMargin)
        }
        
        frequencyLabel = UILabel.statsStaticLabel()
        frequencyLabel.text = "Frequenza d’uso"
        wrapper.addSubview(frequencyLabel)
        frequencyLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(votiLabel.snp.bottom).offset(36 / masterRatio)
        }
        
        frequencyNumber = UILabel.statsStaticLabel()
        wrapper.addSubview(frequencyNumber)
        frequencyNumber.snp.makeConstraints { make in
            make.top.equalTo(frequencyLabel.snp.top)
            make.centerX.equalTo(wrapper.snp.centerX)
        }
        
        frequencyPunt = UILabel.statsDinamycLabel()
        wrapper.addSubview(frequencyPunt)
        frequencyPunt.snp.makeConstraints { make in
            make.top.equalTo(frequencyLabel.snp.top)
            make.right.equalTo(rightMargin)
        }
        
        commentiLabel = UILabel.statsStaticLabel()
        commentiLabel.text = "Commenti"
        wrapper.addSubview(commentiLabel)
        commentiLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(frequencyLabel.snp.bottom).offset(36 / masterRatio)
            
        }
        
        commentiNumber = UILabel.statsStaticLabel()
        wrapper.addSubview(commentiNumber)
        commentiNumber.snp.makeConstraints { make in
            make.top.equalTo(commentiLabel.snp.top)
            make.centerX.equalTo(wrapper.snp.centerX)
        }
        
        commentiPunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(commentiPunti)
        commentiPunti.snp.makeConstraints { make in
            make.top.equalTo(commentiLabel.snp.top)
            make.right.equalTo(rightMargin)
        }
        
        scannedLabel = UILabel.statsStaticLabel()
        scannedLabel.text = "Scansioni"
        wrapper.addSubview(scannedLabel)
        scannedLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(commentiLabel.snp.bottom).offset(36 / masterRatio)
            
        }
        
        scannedNumber = UILabel.statsStaticLabel()
        wrapper.addSubview(scannedNumber)
        scannedNumber.snp.makeConstraints { make in
            make.top.equalTo(scannedLabel.snp.top)
            make.centerX.equalTo(wrapper.snp.centerX)
        }
        
        scannedPunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(scannedPunti)
        scannedPunti.snp.makeConstraints { make in
            make.top.equalTo(scannedLabel.snp.top)
            make.right.equalTo(rightMargin)
        }
        
        separatorThird =  UIView()
        separatorThird.backgroundColor = .lightBlurredGray()
        wrapper.addSubview(separatorThird)
        separatorThird.snp.makeConstraints { make in
            make.height.equalTo(1 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.width.equalTo(630 / masterRatio)
            make.top.equalTo(scannedPunti.snp.bottom).offset(41 / masterRatio)
        }
        
        iscrittiLabel = UILabel.statsStaticLabel()
        iscrittiLabel.text = "Amici iscritti su invito"
        wrapper.addSubview(iscrittiLabel)
        iscrittiLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(separatorThird.snp.bottom).offset(38 / masterRatio)
        }
        
        iscrittiNumber = UILabel.statsStaticLabel()
        wrapper.addSubview(iscrittiNumber)
        iscrittiNumber.snp.makeConstraints { make in
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(iscrittiLabel.snp.top)
        }
        
        iscrittiPunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(iscrittiPunti)
        iscrittiPunti.snp.makeConstraints { make in
            make.right.equalTo(rightMargin)
            make.top.equalTo(iscrittiLabel.snp.top)
        }
        
        votiUtiliLabel = UILabel.statsStaticLabel()
        votiUtiliLabel.text = "Voti utili ricevuti"
        wrapper.addSubview(votiUtiliLabel)
        votiUtiliLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(iscrittiLabel.snp.bottom).offset(31 / masterRatio)
        }
        
        votiUtiliNumber = UILabel.statsStaticLabel()
        wrapper.addSubview(votiUtiliNumber)
        votiUtiliNumber.snp.makeConstraints { make in
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(votiUtiliLabel.snp.top)
        }
        
        votiUtiliPunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(votiUtiliPunti)
        votiUtiliPunti.snp.makeConstraints { make in
            make.right.equalTo(rightMargin)
            make.top.equalTo(votiUtiliLabel.snp.top)
        }
        
        prodottiAddLabel = UILabel.statsStaticLabel()
        prodottiAddLabel.text = "Prodotti aggiunti"
        wrapper.addSubview(prodottiAddLabel)
        prodottiAddLabel.snp.makeConstraints { make in
            make.left.equalTo(leftMargin)
            make.top.equalTo(votiUtiliLabel.snp.bottom).offset(31 / masterRatio)
        }
        
        prodottiAddNumber = UILabel.statsStaticLabel()
        wrapper.addSubview(prodottiAddNumber)
        prodottiAddNumber.snp.makeConstraints { make in
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(prodottiAddLabel.snp.top)
        }
        
        prodottiAddPunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(prodottiAddPunti)
        prodottiAddPunti.snp.makeConstraints { make in
            make.right.equalTo(rightMargin)
            make.top.equalTo(prodottiAddLabel.snp.top)
        }
        
        sharedLists = UILabel.statsStaticLabel()
        sharedLists.text = "Liste condivise"
        wrapper.addSubview(sharedLists)
        sharedLists.snp.makeConstraints { (make) in
            make.left.equalTo(leftMargin)
            make.top.equalTo(prodottiAddLabel.snp.bottom).offset(31 / masterRatio)
        }
        
        sharedListsNumber = UILabel.statsStaticLabel()
        wrapper.addSubview(sharedListsNumber)
        sharedListsNumber.snp.makeConstraints { make in
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(sharedLists.snp.top)
        }
        
        sharedListsPunti = UILabel.statsDinamycLabel()
        wrapper.addSubview(sharedListsPunti)
        sharedListsPunti.snp.makeConstraints { make in
            make.right.equalTo(rightMargin)
            make.top.equalTo(sharedLists.snp.top)
        }
        
        let grocerestLevelsHeader = UILabel()
        grocerestLevelsHeader.font = .ubuntuLight(36)
        grocerestLevelsHeader.textColor = .lightText
        grocerestLevelsHeader.textAlignment = .center
        grocerestLevelsHeader.text = "I LIVELLI GROCEREST"
        wrapper.addSubview(grocerestLevelsHeader)
        grocerestLevelsHeader.snp.makeConstraints { make in
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(sharedLists.snp.bottom).offset(72 / masterRatio)
        }
        
        let allLevels = UIImageView()
        allLevels.contentMode = .scaleAspectFit
        allLevels.image = UIImage(named: "levels_all")
        wrapper.addSubview(allLevels)
        allLevels.snp.makeConstraints { make in
            make.width.equalTo(620 / masterRatio)
            make.height.equalTo(113 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(grocerestLevelsHeader.snp.bottom).offset(51 / masterRatio)
        }
        
        let tempSeparator = UIView()
        tempSeparator.backgroundColor = .clear
        wrapper.addSubview(tempSeparator)
        tempSeparator.snp.makeConstraints { make in
            make.width.equalTo(630 / masterRatio)
            make.height.equalTo(101 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.bottom.equalTo(wrapper.snp.bottom)
        }
    }
    
}



extension GRReputationView {
    
    func isOverTheTop(_ data: JSON) -> Bool {
        // means the user has reached level 5
        return data["level"].intValue >= 5
    }
    
    func populateViewWith(_ data: JSON) {
        print("REPUTATION DATA", data)
        reputationWithDate.text = "LA TUA REPUTATION AL \(formatDate()) È"
        
        let userReputation = data["score"].intValue
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let reputationLocalized = formatter.string(from: NSNumber(value: userReputation)) ?? userReputation.description
        
        pointsCounter.text = "\(reputationLocalized)"
        
        let overTheTop = isOverTheTop(data)
        let currentLevel = data["level"].intValue
        
        if !overTheTop {
            badgeFrom.image = UIImage(named: currentBadge(currentLevel))
            badgeTo.image = UIImage(named: nextBadge(currentLevel + 1))
            labelFrom.text = "LIVELLO \(currentLevel)"
            labelTo.text = "LIVELLO \(currentLevel + 1)"
            pointsToLevelBottom.text = "Per raggiungere il livello \(currentLevel + 1)."
            pointsAfterLastLevel.isHidden = !overTheTop
            pointsToLevelTop.isHidden = overTheTop
            pointsTo.isHidden = overTheTop
            pointsToLevelBottom.isHidden = overTheTop
        } else {
            // over the top!
            badgeFrom.image = UIImage(named: currentBadge(4))
            badgeTo.image = UIImage(named: nextBadge(5))
            labelFrom.text = "LIVELLO \(4)"
            labelTo.text = "LIVELLO \(5)"
            labelTo.textColor = .white
            pointsAfterLastLevel.isHidden = false
            pointsAfterLastLevel.isHidden = !overTheTop
            pointsToLevelTop.isHidden = overTheTop
            pointsTo.isHidden = overTheTop
            pointsToLevelBottom.isHidden = overTheTop
        }
        
        iscrizionePunti.text = "\(data["scores"]["profile"]["registration"].intValue) punti"
        registrazioneSuInvitoPunti.text = "\(data["scores"]["registeredByInvitation"]["score"].intValue) punti"
        genderPunti.text = "\(data["scores"]["profile"]["fields"]["gender"].intValue) punti"
        nucleoFamilyPunti.text = "\(data["scores"]["profile"]["fields"]["family"].intValue) punti"
        birthdayPunti.text = "\(data["scores"]["profile"]["fields"]["birthdate"].intValue) punti"
        facebookPunti.text = "\(data["scores"]["profile"]["fields"]["facebook"].intValue) punti"
        
        votiNumber.text = "\(data["scores"]["votes"]["count"].intValue)"
        votiPunti.text = "\(data["scores"]["votes"]["score"].intValue) Punti"
        
        frequencyNumber.text = "\(data["scores"]["frequencies"]["count"].intValue)"
        frequencyPunt.text = "\(data["scores"]["frequencies"]["score"].intValue) Punti"
        
        commentiNumber.text = "\(data["scores"]["texts"]["count"].intValue)"
        commentiPunti.text = "\(data["scores"]["texts"]["score"].intValue) Punti"
        
        scannedNumber.text = "\(data["scores"]["scans"]["count"].intValue)"
        scannedPunti.text = "\(data["scores"]["scans"]["score"].intValue) Punti"
        
        iscrittiNumber.text = "\(data["scores"]["successfulInvitations"]["count"].intValue)"
        iscrittiPunti.text = "\(data["scores"]["successfulInvitations"]["score"].intValue) Punti"
        
        votiUtiliNumber.text = "\(data["scores"]["usefulVotes"]["count"].intValue)"
        votiUtiliPunti.text = "\(data["scores"]["usefulVotes"]["score"].intValue) Punti"
        
        prodottiAddNumber.text = "\(data["scores"]["proposals"]["count"].intValue)"
        prodottiAddPunti.text = "\(data["scores"]["proposals"]["score"].intValue) Punti"
        
        sharedListsNumber.text = "\(data["scores"]["shareLists"]["count"].intValue)"
        sharedListsPunti.text = "\(data["scores"]["shareLists"]["score"].intValue) Punti"
    }
    
    func currentBadge(_ level: Int) -> String {
        switch level {
        case 1:
            return "one_on"
        case 2:
            return "two_on"
        case 3:
            return "three_on"
        case 4:
            return "four_on"
        case 5:
            return "five_on"
        default:
            return "one_on"
        }
    }
    
    func nextBadge(_ level: Int) -> String {
        switch level {
        case 1:
            return "one_off"
        case 2:
            return "two_off"
        case 3:
            return "three_off"
        case 4:
            return "four_off"
        case 5:
            return "five_off"
        default:
            return "one_off"
        }
    }
    
    func formatDate() -> String {
        let timestamp = Date().timeIntervalSince1970 * 1000
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let myDate = dateFormatter.string(from: convertFromTimestamp("\(timestamp)"))
        return myDate
    }
    
    func animateProgressBarWith(_ data:JSON) {
        if !isOverTheTop(data) {
            let score = data["score"].floatValue
            let end = data["levelEnd"].floatValue
            let start = data["levelStart"].floatValue
            updateProgress((score - start) / end)
        } else {
            updateProgress(1)
        }
    }
    
    func updateProgress(_ progress: Float) {
        progressView.setProgress(0, animated: false)
        
        UIView.animate(withDuration: 2, delay: 1, options: .curveLinear, animations: {
            self.progressView.layoutIfNeeded()
            self.progressView.setProgress(progress, animated: true)
            }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            // completion block does not work correctly for this kind of animation
            // mabybe because we're calling updateProgress when the view is not even visible yet
            // and then some other animation start simoultaneously. This is a workaround
            if self.progressView.progress == 1 {
                self.badgeTo.setImageCrossdissolved(UIImage(named: self.currentBadge(5)))
                self.levelBar.setImageCrossdissolved(UIImage(named: "level_progress_bar_full"))
            }
        }
    }
    
    func closeViewWasPressed(_ sender: UIButton) {
        delegate.closeView(sender)
    }
    
}
