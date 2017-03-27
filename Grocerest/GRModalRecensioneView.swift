//
//  GRModalRecensioneView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 08/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON



@IBDesignable
class GRModalRecensioneView: UIView {
    
    var viewsByName: [String: UIView]!
    var mainImageView : UIImageView?
    var productLabel : UILabel?
    var brandLabel: UILabel?
    var recensioneStatutsLabel: UILabel?
    var voteSegment : GRReviewBoxVote?
    var firstVoteLabel : UILabel?
    var frequencySegment : GRReviewBoxFrequency?
    var voteLabel = UILabel()
    var statusIcon = UIImageView()
    var statusIconText = UIImageView()
    var statusIconFreq = UIImageView()
    
    var closeButton = GRShineButton()
    
    var writeLabel = UILabel()
    var commentButton = UIButton()
    var secondWriteLabel = UILabel()
    
    var copatwoImageView = UIImageView()
    var copaTwoLabel = UILabel()
    
    var copathreeImageView = UIImageView()
    var copaThreeLabel = UILabel()
    var freqIcon = UIImageView()
    
    
    var scannerIcon = UIImageView()
    var copafourImageView = UIImageView()
    var scanLabel = UILabel()
    var separator3 = UIView()
    
    
    var voteImageView = UIImageView()
    var textImageView = UIImageView()
    var frequencyImageView = UIImageView()
    var scanImageView = UIImageView()
    
    
    var voteValueLabel = UILabel()
    var textValueLabel = UILabel()
    var frequencyValueLabel = UILabel()
    var scanValueLabel = UILabel()
    
    var recensioneTextView = UITextView()
    var scannButton = UIButton()
    
    
    var actionButton = GRShineButton()
    
    var dataLabel = UILabel()
    
    
    var copaFourLabel = UILabel()
    var separator4 = UIView()
    var deleteView = UIView()
    var deleteIcon = UIImageView()
    var deleteLabel = UILabel()
    var deleteButton = UIButton(type: .custom)
    
    let trap = UIView()
    
    
    
    let separator2 = UIView()
    let freqContainerView = UIView()
    let reviewContainerView = UIView()
    let separator = UIView()
    
    var ghostArea = UIView()
    
    
    var wrapper = UIView()
    
    
    

    
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
    
    // TODO protect here
    var delegate = GRModalRecensioneViewController()
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setupHierarchy() {
        
        backgroundColor = UIColor.white
        
        var viewsByName: [String : UIView] = [:]
        
        let fixView = UIView()
        addSubview(fixView)
        fixView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(420 / masterRatio)
            make.top.left.equalTo(0)
        }
        fixView.backgroundColor = UIColor.white
        
        
        let closeButton = GRShineButton()
        fixView.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(125 / masterRatio)
            make.left.equalTo(8 / masterRatio)
            make.top.equalTo(41 / masterRatio)
        }
        closeButton.setImage(UIImage(named: "close_modal"), for: UIControlState())
        closeButton.contentMode = .center
        closeButton.addTarget(self, action: #selector(GRModalRecensioneView.actionCloseButtonWasPressed(_:)), for: .touchUpInside)
        
        
        fixView.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.right.equalTo(-8 / masterRatio)
            make.top.equalTo(closeButton.snp.top)
            make.width.equalTo(closeButton.snp.width)
            make.height.equalTo(closeButton.snp.height)
        }
        actionButton.contentMode = .center
        actionButton.setImage(UIImage(named: "ok_lampone"), for: UIControlState())
        actionButton.setImage(UIImage(named: "check-disabled"), for: .disabled)
        actionButton.isEnabled = false
        actionButton.addTarget(self, action: #selector(GRModalRecensioneView.actionSaveWasPressed(_:)), for: .touchUpInside)
        
        let pageLabel = UILabel()
        fixView.addSubview(pageLabel)
        pageLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(closeButton.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
        pageLabel.text = "Recensione"
        pageLabel.textColor = UIColor.grocerestColor()
        pageLabel.font = UIFont.ubuntuLight(36)
        pageLabel.textAlignment = .center
        
        
        
        
        
        mainImageView = UIImageView()
        fixView.addSubview(mainImageView!)
        mainImageView?.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(128 / masterRatio)
            make.left.equalTo(32 / masterRatio)
            make.top.equalTo(closeButton.snp.bottom).offset(47 / masterRatio)
        })
        mainImageView?.contentMode = .scaleAspectFit
        
        productLabel = UILabel()
        fixView.addSubview(productLabel!)
        productLabel?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(538 / masterRatio)
            make.bottom.equalTo(mainImageView!.snp.centerY)
            make.left.equalTo((mainImageView?.snp.right)!).offset(20 / masterRatio)
        })
        productLabel?.numberOfLines = 2
        productLabel?.lineBreakMode = .byWordWrapping
        productLabel?.font = UIFont.ubuntuMedium(32)
        productLabel?.textColor = UIColor.grocerestDarkBoldGray()
        productLabel?.textAlignment = .left
        
        brandLabel = UILabel()
        fixView.addSubview(brandLabel!)
        brandLabel?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo((productLabel?.snp.width)!)
            make.top.equalTo((productLabel?.snp.bottom)!).offset(10 / masterRatio)
            make.left.equalTo((productLabel?.snp.left)!)
        })
        brandLabel?.font = UIFont.avenirBook(22)
        brandLabel?.textColor = UIColor.grocerestLightGrayColor()
        brandLabel?.textAlignment = .left
        
        
        let backLabelView = UIView()
        fixView.addSubview(backLabelView)
        backLabelView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(fixView.snp.width)
            make.height.equalTo(63 / masterRatio)
            make.bottom.equalTo(fixView.snp.bottom)
            make.centerX.equalTo(fixView.snp.centerX)
        }
        backLabelView.backgroundColor = UIColor.F1F1F1Color()
        
        viewsByName["backLabelView"] = backLabelView
        
        recensioneStatutsLabel = UILabel()
        backLabelView.addSubview(recensioneStatutsLabel!)
        recensioneStatutsLabel?.snp.makeConstraints({ (make) -> Void in
            make.centerY.equalTo(backLabelView.snp.centerY)
            make.left.equalTo(34 / masterRatio)
        })
        recensioneStatutsLabel?.font = UIFont.avenirBook(22)
        recensioneStatutsLabel?.textColor = UIColor.nineSevenGrayColor()
        recensioneStatutsLabel?.textAlignment = .left
        recensioneStatutsLabel?.numberOfLines = 2
        
        
        backLabelView.addSubview(dataLabel)
        dataLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo((recensioneStatutsLabel?.snp.top)!)
            make.left.equalTo((recensioneStatutsLabel?.snp.right)!)
        }
        dataLabel.font = UIFont.avenirBook(22)
        dataLabel.textColor = UIColor.nineSevenGrayColor()
        dataLabel.textAlignment = .left
        
        
        
        let __scaling__ = UIScrollView()
        
        
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(fixView.snp.width)
            make.top.equalTo(fixView.snp.bottom)
            make.height.equalTo(920 / masterRatio)
            make.left.equalTo(0)
        }
        viewsByName["__scaling__"] = __scaling__
        
        
        __scaling__.addSubview(wrapper)
        wrapper.snp.makeConstraints { (make) in
            make.edges.equalTo(__scaling__)
            make.left.equalTo(0)
            make.width.equalTo(__scaling__.snp.width)
        }
        
        wrapper.backgroundColor = UIColor.white
        
        
        let voteContainerView = UIView()
        wrapper.addSubview(voteContainerView)
        voteContainerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(wrapper.snp.width)
            make.height.equalTo(self)
            make.top.equalTo(wrapper.snp.top)
            make.centerX.equalTo(wrapper.snp.centerX)
            
        }
        
        let iconVoteOff = UIImageView()
        voteContainerView.addSubview(iconVoteOff)
        iconVoteOff.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50 / masterRatio)
            make.centerX.equalTo(voteContainerView.snp.centerX)
            make.top.equalTo(wrapper.snp.top).offset(60 / masterRatio)
        }
        iconVoteOff.contentMode = .scaleAspectFit
        iconVoteOff.image = UIImage(named: "icon_recensione")
        
        statusIcon = UIImageView()
        wrapper.addSubview(statusIcon)
        statusIcon.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(38 / masterRatio)
            make.height.equalTo(25 / masterRatio)
            make.bottom.equalTo(iconVoteOff.snp.bottom)
            make.left.equalTo(iconVoteOff.snp.centerX)
        }
        statusIcon.contentMode = .scaleAspectFit
        statusIcon.image = UIImage(named: "green_arrow")
        statusIcon.isHidden = true
        
        voteLabel = UILabel()
        voteContainerView.addSubview(voteLabel)
        voteLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(500 / masterRatio)
            make.height.equalTo(34 / masterRatio)
            make.centerX.equalTo(voteContainerView.snp.centerX)
            make.top.equalTo(statusIcon.snp.bottom).offset(14 / masterRatio)
        }
        voteLabel.text = "valuta il prodotto da 1 a 5 punti"
        voteLabel.font = Constants.BrandFonts.avenirHeavy12
        voteLabel.textColor = UIColor.grocerestDarkBoldGray()
        voteLabel.textAlignment = .center
        voteLabel.isHidden = false
        
        voteImageView = UIImageView()
        voteContainerView.addSubview(voteImageView)
        voteImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(101 / masterRatio)
            make.height.equalTo(51 / masterRatio)
            make.right.equalTo(0)
            make.centerY.equalTo(voteLabel.snp.centerY)
        }
        
        voteImageView.contentMode = .scaleAspectFit
        voteImageView.image = UIImage(named: "v2_points_unassigned")
        
        firstVoteLabel = UILabel()
        voteContainerView.addSubview(firstVoteLabel!)
        firstVoteLabel!.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(voteImageView.snp.centerY)
            make.width.height.equalTo(26)
            make.right.equalTo(voteImageView.snp.right).offset(2 / masterRatio)
        }
        
        firstVoteLabel?.textColor = UIColor.white
        firstVoteLabel?.font = Constants.BrandFonts.avenirHeavy10
        
        
        
        voteSegment = GRReviewBoxVote()
        voteContainerView.addSubview(voteSegment!)
        voteSegment?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(600 / masterRatio)
            make.height.equalTo(86 / masterRatio)
            make.centerX.equalTo(voteContainerView.snp.centerX).offset(-5 / masterRatio)
            make.top.equalTo(voteLabel.snp.bottom).offset(31 / masterRatio)
        })
        //voteSegment?.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.5)
        voteSegment?.hideLabels()
        
        
        wrapper.addSubview(separator)
        separator.backgroundColor = UIColor.lightGray
        separator.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(0.5)
            make.top.equalTo(voteSegment!.snp.bottom).offset(66 / masterRatio)
            make.left.equalTo(0)
        }
        
        
        wrapper.addSubview(reviewContainerView)
        reviewContainerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(wrapper.snp.width)
            make.height.equalTo(334 / masterRatio)
            make.top.equalTo(separator.snp.bottom)
            make.centerX.equalTo(wrapper.snp.centerX)
        }
        
        
        let pencilUImage = UIImageView()
        reviewContainerView.addSubview(pencilUImage)
        pencilUImage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(48 / masterRatio)
            make.top.equalTo(separator.snp.bottom).offset(64 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
        }
        pencilUImage.contentMode = .scaleAspectFit
        pencilUImage.image = UIImage(named: "write_icon")
        
        statusIconText = UIImageView()
        reviewContainerView.addSubview(statusIconText)
        statusIconText.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(38 / masterRatio)
            make.height.equalTo(25 / masterRatio)
            make.bottom.equalTo(pencilUImage.snp.bottom)
            make.left.equalTo(pencilUImage.snp.centerX).offset(-2)
        }
        statusIconText.contentMode = .scaleAspectFit
        statusIconText.image = UIImage(named: "green_arrow")
        statusIconText.isHidden = true
        
        copatwoImageView = UIImageView()
        reviewContainerView.addSubview(copatwoImageView)
        copatwoImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(101 / masterRatio)
            make.height.equalTo(51 / masterRatio)
            make.centerY.equalTo(pencilUImage.snp.centerY)
            make.right.equalTo(0)
        }
        copatwoImageView.contentMode = .scaleAspectFit
        copatwoImageView.image = UIImage(named: "v2_points_unassigned")
        
        copaTwoLabel = UILabel()
        reviewContainerView.addSubview(copaTwoLabel)
        copaTwoLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(copatwoImageView.snp.centerY)
            make.width.height.equalTo(26)
            make.right.equalTo(copatwoImageView.snp.right).offset(-8 / masterRatio)
        }
        
        copaTwoLabel.font = Constants.BrandFonts.avenirHeavy10
        copaTwoLabel.textColor = UIColor.white
        copaTwoLabel.textAlignment = .center
        
        writeLabel = UILabel()
        reviewContainerView.addSubview(writeLabel)
        writeLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(498 / masterRatio)
            make.height.equalTo(34 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(pencilUImage.snp.bottom).offset(16 / masterRatio)
        }
        
        writeLabel.text = Constants.AppLabels.writeAReview
        writeLabel.textColor = UIColor.grocerestDarkBoldGray()
        writeLabel.font = Constants.BrandFonts.avenirHeavy12
        writeLabel.textAlignment = .center
        
        secondWriteLabel = UILabel()
        reviewContainerView.addSubview(secondWriteLabel)
        secondWriteLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(422 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(writeLabel.snp.bottom).offset(22 / masterRatio)
        }
        secondWriteLabel.text = "cosa ne pensi del prodotto? \n perché lo consiglieresti, o no?"
        secondWriteLabel.numberOfLines = 2
        secondWriteLabel.font = Constants.BrandFonts.avenirBook15
        secondWriteLabel.textColor = UIColor.grocerestLightGrayColor()
        secondWriteLabel.textAlignment = .center
        
        
        
        recensioneTextView = UITextView()
        reviewContainerView.addSubview(recensioneTextView)
        recensioneTextView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(500 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(writeLabel.snp.bottom).offset(22 / masterRatio)
        }
        
        recensioneTextView.isHidden = true
        recensioneTextView.delegate = delegate
        recensioneTextView.font = Constants.BrandFonts.avenirBook15
        recensioneTextView.textColor = UIColor.grocerestLightGrayColor()
        recensioneTextView.isScrollEnabled = false
        
        
        
        commentButton = UIButton(type: .custom)
        reviewContainerView.addSubview(commentButton)
        commentButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(reviewContainerView)
        }
        commentButton.addTarget(self, action: #selector(GRModalRecensioneView.actionCommentButtonWasPressed(_:)), for: .touchUpInside)
        
        
        reviewContainerView.addSubview(separator2)
        
        
        separator2.backgroundColor = UIColor.lightGray
        separator2.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(0.5)
            make.top.equalTo(secondWriteLabel.snp.bottom).offset(67 / masterRatio)
            make.left.equalTo(0)
        }
        
        
        wrapper.addSubview(freqContainerView)
        freqContainerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(wrapper.snp.width)
            make.height.equalTo(343 / masterRatio)
            make.top.equalTo(separator2.snp.bottom)
            make.centerX.equalTo(wrapper.snp.centerX)
            
        }
        
        freqIcon = UIImageView()
        freqContainerView.addSubview(freqIcon)
        freqIcon.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(60 / masterRatio)
            make.height.equalTo(30 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(separator2.snp.bottom).offset(64 / masterRatio)
        }
        freqIcon.contentMode = .scaleAspectFit
        freqIcon.image = UIImage(named: "tendency_icon")
        
        
        statusIconFreq = UIImageView()
        wrapper.addSubview(statusIconFreq)
        statusIconFreq.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(38 / masterRatio)
            make.height.equalTo(25 / masterRatio)
            make.bottom.equalTo(freqIcon.snp.bottom)
            make.left.equalTo(freqIcon.snp.centerX)
        }
        statusIconFreq.contentMode = .scaleAspectFit
        statusIconFreq.image = UIImage(named: "green_arrow")
        statusIconFreq.isHidden = true
        
        
        copathreeImageView = UIImageView()
        freqContainerView.addSubview(copathreeImageView)
        copathreeImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(101 / masterRatio)
            make.height.equalTo(51 / masterRatio)
            make.top.equalTo(separator2.snp.bottom).offset(62 /  masterRatio)
            make.right.equalTo(freqIcon.snp.right).offset(351 / masterRatio)
        }
        copathreeImageView.contentMode = .scaleAspectFit
        copathreeImageView.image = UIImage(named: "v2_points_unassigned")
        
        
        copaThreeLabel = UILabel()
        freqContainerView.addSubview(copaThreeLabel)
        copaThreeLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(copathreeImageView.snp.centerY)
            make.width.height.equalTo(26)
            make.right.equalTo(copathreeImageView.snp.right).offset(-8 / masterRatio)
            
        }
        
        copaThreeLabel.font = Constants.BrandFonts.avenirHeavy10
        copaThreeLabel.textColor = UIColor.white
        copaThreeLabel.textAlignment = .center
        
        
        
        frequencySegment = GRReviewBoxFrequency()
        freqContainerView.addSubview(frequencySegment!)
        frequencySegment!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(wrapper.snp.width)
            make.height.equalTo(260 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX).offset(-20 / masterRatio)
            make.top.equalTo(copathreeImageView.snp.bottom).offset(22 / masterRatio)
        }
        
        separator3 = UIView()
        freqContainerView.addSubview(separator3)
        separator3.backgroundColor = UIColor.lightGray
        separator3.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(0.5)
            make.top.equalTo(frequencySegment!.snp.bottom).offset(40 / masterRatio)
            make.left.equalTo(0)
        }
        
        
        scannerIcon = UIImageView()
        wrapper.addSubview(scannerIcon)
        scannerIcon.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(48 / masterRatio)
            make.height.equalTo(36 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(separator3.snp.bottom).offset(64 / masterRatio)
        }
        scannerIcon.contentMode = .scaleAspectFit
        scannerIcon.image = UIImage(named: "scanner_profilev")
        
        
        copafourImageView = UIImageView()
        wrapper.addSubview(copafourImageView)
        copafourImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(101 / masterRatio)
            make.height.equalTo(51 / masterRatio)
            make.top.equalTo(separator3.snp.bottom).offset(62 /  masterRatio)
            make.right.equalTo(scannerIcon.snp.right).offset(351 / masterRatio)
        }
        copafourImageView.contentMode = .scaleAspectFit
        copafourImageView.image = UIImage(named: "v2_points_unassigned")
        
        
        wrapper.addSubview(copaFourLabel)
        copaFourLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(copafourImageView.snp.centerY)
            make.width.height.equalTo(26)
            make.right.equalTo(copafourImageView.snp.right).offset(-8 / masterRatio)
        }
        
        copaFourLabel.font = Constants.BrandFonts.avenirHeavy10
        copaFourLabel.textColor = UIColor.white
        copaFourLabel.textAlignment = .center
        
        
        scanLabel = UILabel()
        wrapper.addSubview(scanLabel)
        scanLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(500 / masterRatio)
            make.height.equalTo(34 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(scannerIcon.snp.bottom).offset(16 / masterRatio)
        }
        scanLabel.text = "scansiona il codice a barre"
        scanLabel.font = Constants.BrandFonts.avenirRoman13
        scanLabel.textColor = UIColor.grocerestDarkGrayText()
        scanLabel.textAlignment = .center
        
        scannButton = UIButton(type: .custom)
        wrapper.addSubview(scannButton)
        scannButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(448 / masterRatio)
            make.height.equalTo(80 / masterRatio)
            make.centerX.equalTo(wrapper.snp.centerX)
            make.top.equalTo(scanLabel.snp.bottom).offset(32 / masterRatio)
        }
        scannButton.contentMode = .scaleAspectFit
        scannButton.setBackgroundImage(UIImage(named: "outlinedButton"), for: UIControlState())
        scannButton.setTitle("SCANSIONA ORA", for: UIControlState())
        scannButton.titleLabel?.font = Constants.BrandFonts.avenirMedium11
        scannButton.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        scannButton.addTarget(self, action: #selector(GRModalRecensioneView.actionScanButtonWasPressed(_:)), for: .touchUpInside)
        
        separator4 = UIView()
        freqContainerView.addSubview(separator4)
        separator4.backgroundColor = UIColor.lightGray
        separator4.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(0.5)
            make.top.equalTo(scanLabel.snp.bottom).offset(200 / masterRatio)
            make.left.equalTo(0)
        }
        
        separator4.isHidden = true
        
        
        wrapper.addSubview(deleteView)
        deleteView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(wrapper.snp.width)
            make.height.equalTo(100 / masterRatio)
            make.top.equalTo(separator4.snp.bottom).offset(10 / masterRatio)
        }
        deleteView.isHidden = true
        
        let trashIconSize = CGSize(width: 28 / masterRatio, height: 36 / masterRatio)
        
        deleteView.addSubview(deleteIcon)
        deleteIcon.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(trashIconSize)
            make.centerY.equalTo(deleteView.snp.centerY)
            make.left.equalTo(250 / masterRatio)
        }
        
        deleteIcon.contentMode = .scaleAspectFit
        deleteIcon.image = UIImage(named: "trashcan")
        
        deleteView.addSubview(deleteLabel)
        deleteLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(deleteIcon.snp.right).offset(21 / masterRatio)
            make.centerY.equalTo(deleteIcon.snp.centerY)
        }
        deleteLabel.text = "Elimina recensione"
        deleteLabel.font = Constants.BrandFonts.avenirLight13
        deleteLabel.textColor = UIColor.lightGrayTextcolor()
        deleteLabel.textAlignment = .left
        
        wrapper.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(deleteView)
        }
        deleteButton.addTarget(self, action: #selector(GRModalRecensioneView.actionDeleteButtonWasPressed(_:)), for: .touchUpInside)
        
        
        
        // the scrollable content needs to
        // scroll above the action button (which is fixed at bottom)
        // so we add a ghostArea to compensate
        
        wrapper.addSubview(ghostArea)
        ghostArea.snp.makeConstraints { (make) in
            make.width.equalTo(wrapper.snp.width)
            make.top.equalTo(deleteButton.snp.bottom)
            make.height.equalTo(1 / masterRatio)
            make.bottom.equalTo(wrapper.snp.bottom)
        }
        
        self.viewsByName = viewsByName
        
    }
    
    
    func actionCloseButtonWasPressed(_ sender:UIButton) {
        delegate.closeButtonWasPressed(sender)
    }
    
    func updateViewWithData(_ product: JSON, imagesURL: String) {
        
        
        if let productName = product["display_name"].string {
            productLabel?.text = productName
        }
        
        if let brand = product["display_brand"].string {
            brandLabel?.text = brand
        }
        
        if let productImage = product["images"]["large"].string {
            mainImageView?.layoutIfNeeded()
            
            let encodedString = productImage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            mainImageView?.hnk_setImageFromURL(URL(string: "\(imagesURL)/\(encodedString!)")!)
        } else {
            if let productCategory = product["category"].string {
                mainImageView?.image = UIImage(named: "products_" + productCategory)?.imageWithInsets(10)
            }
        }
        
    }
    
    
    
    
}

extension GRModalRecensioneView {
    
    func actionCommentButtonWasPressed(_ sender:UIButton) {
        delegate.commentButtonWasPressed(sender)
    }
    
    func actionScanButtonWasPressed(_ sender:UIButton){
        delegate.scanButtonWasPressed(sender)
    }
    
    func actionSaveWasPressed(_ sender:UIButton) {
        delegate.saveWasPressed(sender)
    }
    
    func actionDeleteButtonWasPressed(_ sender:UIButton) {
        delegate.deleteButtonWasPressed(sender)
    }
    
    
}


extension GRModalRecensioneView {
    
    
    func isFirstReview(_ first:Bool) {
        if first {
            firstVoteLabel?.text = "+2"
            copaTwoLabel.text = "+8"
            copaThreeLabel.text = "+2"
            copaFourLabel.text = "+8"
            
        } else {
            firstVoteLabel?.text = "+1"
            copaTwoLabel.text = "+4"
            copaThreeLabel.text = "+1"
            copaFourLabel.text = "+4"
        }
        
    }
    
    
    func formatTextViewWithAutoHeight(_ review:String) {
        
        writeLabel.text = Constants.AppLabels.modifyReview
        
        recensioneTextView.text = review
        
        recensioneTextView.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(500 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(writeLabel.snp.bottom).offset(22 / masterRatio)
        }
        
        
        commentButton.snp.remakeConstraints { (make) -> Void in
            make.edges.equalTo(reviewContainerView)
        }
        
        separator2.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(0.5)
            make.top.equalTo(recensioneTextView.snp.bottom).offset(67 / masterRatio)
            make.left.equalTo(0)
        }
        
        reviewContainerView.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(self.snp.width)
            make.top.equalTo(separator.snp.bottom)
            make.bottom.equalTo(separator2.snp.bottom)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    func formatLabelWhenHasDate(_ stringDate:String) {        
        dataLabel.text = " del \(stringDate)"
    }
    
    
    
    func willShowDeleteReviewButton() {
        
        deleteView.isHidden = false
        deleteButton.isHidden = false
        separator4.isHidden = false
        
        separator4.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(0.5)
            make.top.equalTo(scanLabel.snp.bottom).offset(200 / masterRatio)
            make.left.equalTo(0)
        }
        
        deleteView.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(79 / masterRatio)
            make.top.equalTo(separator4.snp.bottom).offset(10 / masterRatio)
        }
        
        ghostArea.snp.remakeConstraints { (make) in
            make.width.equalTo(wrapper.snp.width)
            make.top.equalTo(deleteButton.snp.bottom)
            make.height.equalTo(72 / masterRatio)
            make.bottom.equalTo(wrapper.snp.bottom)
        }
    }
    
    
    
    func formatViewForProductWithReview(_ textForStatus: String) {
        recensioneStatutsLabel!.text = textForStatus
    }
    
    func formatViewForProductWasVoted() {
        
        // 4: Update UX accordingly
        voteLabel.isHidden = false
        voteLabel.textColor = UIColor.greenGrocerestColor()
        statusIcon.isHidden = false
        voteImageView.image = UIImage(named: "v2_points_assigned")
        
    }
    
    
    func formatViewForProductWasReviewed() {
        secondWriteLabel.isHidden = true
        commentButton.isHidden = false
        recensioneTextView.isHidden = false
        statusIconText.isHidden = false
        writeLabel.textColor = UIColor.greenGrocerestColor()
        copatwoImageView.image = UIImage(named: "v2_points_assigned")
        
    }
    
    func formatViewForProductWasFrequencyVoted() {
        statusIconFreq.isHidden = false
        frequencySegment?.reviewLabel.textColor = UIColor.greenGrocerestColor()
        copathreeImageView.image = UIImage(named: "v2_points_assigned")
    }
    
    
    
    func formatViewForProductWasScanned() {
        scannerIcon.image = UIImage(named: "v2_scanned_complete")
        scanLabel.text = Constants.ReviewLabels.barcodeScanned
        scanLabel.textColor = UIColor.greenGrocerestColor()
        copafourImageView.image = UIImage(named: "v2_points_assigned")
    }
    
    func formatViewForVoteChainedReaction(){
        voteSegment?.voteOne?.addTarget(delegate, action: #selector(GRModalRecensioneViewController.voteWasPressed(_:)), for: .touchUpInside)
        voteSegment?.voteTwo?.addTarget(delegate, action: #selector(GRModalRecensioneViewController.voteWasPressed(_:)), for: .touchUpInside)
        voteSegment?.voteThree?.addTarget(delegate, action: #selector(GRModalRecensioneViewController.voteWasPressed(_:)), for: .touchUpInside)
        voteSegment?.voteFour?.addTarget(delegate, action: #selector(GRModalRecensioneViewController.voteWasPressed(_:)), for: .touchUpInside)
        voteSegment?.voteFive?.addTarget(delegate, action: #selector(GRModalRecensioneViewController.voteWasPressed(_:)), for: .touchUpInside)
    }
    
    func formatViewForChainedButtonState(_ sender: Int) {
        
        switch sender {
        case 1:
            voteSegment?.voteOne?.isSelected = true
            voteSegment?.voteTwo?.isSelected = false
            voteSegment?.voteThree?.isSelected = false
            voteSegment?.voteFour?.isSelected = false
            voteSegment?.voteFive?.isSelected = false
            
        case 2:
            voteSegment?.voteOne?.isSelected = true
            voteSegment?.voteTwo?.isSelected = true
            voteSegment?.voteThree?.isSelected = false
            voteSegment?.voteFour?.isSelected = false
            voteSegment?.voteFive?.isSelected = false
        case 3:
            voteSegment?.voteOne?.isSelected = true
            voteSegment?.voteTwo?.isSelected = true
            voteSegment?.voteThree?.isSelected = true
            voteSegment?.voteFour?.isSelected = false
            voteSegment?.voteFive?.isSelected = false
        case 4:
            voteSegment?.voteOne?.isSelected = true
            voteSegment?.voteTwo?.isSelected = true
            voteSegment?.voteThree?.isSelected = true
            voteSegment?.voteFour?.isSelected = true
            voteSegment?.voteFive?.isSelected = false
        case 5:
            voteSegment?.voteOne?.isSelected = true
            voteSegment?.voteTwo?.isSelected = true
            voteSegment?.voteThree?.isSelected = true
            voteSegment?.voteFour?.isSelected = true
            voteSegment?.voteFive?.isSelected = true
            
            
        default:
            print("this just cant happen")
        }
        
    }
    
    func formatViewForActionButtonAsDisabled() {
        actionButton.isEnabled = false
    }
    
    func formatViewForActionButtonAsReady(_ changed:Bool) {
        actionButton.isEnabled = changed
    }
    
    func formatViewForFrequencyVote() {
        frequencySegment?.freqFirst?.addTarget(delegate, action: #selector(GRModalRecensioneViewController.actionFrequencyWasPressed(_:)), for: .touchUpInside)
        frequencySegment?.freqRarely?.addTarget(delegate, action: #selector(GRModalRecensioneViewController.actionFrequencyWasPressed(_:)), for: .touchUpInside)
        frequencySegment?.freqMontly?.addTarget(delegate, action: #selector(GRModalRecensioneViewController.actionFrequencyWasPressed(_:)), for: .touchUpInside)
        frequencySegment?.freqWeakly?.addTarget(delegate, action: #selector(GRModalRecensioneViewController.actionFrequencyWasPressed(_:)), for: .touchUpInside)
        frequencySegment?.freqDaily?.addTarget(delegate, action: #selector(GRModalRecensioneViewController.actionFrequencyWasPressed(_:)), for: .touchUpInside)
    }
    
    
    
    
}
