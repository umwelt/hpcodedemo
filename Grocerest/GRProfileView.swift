//
//  GRProfileView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 15/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class GRProfileView: UIView, UIToolbarDelegate, GRToolBarProtocol, UIScrollViewDelegate {
    
    var badgeImageView = UIImageView()
    
    var evitareButton = UIButton()
    
    var inviteFriendsButton = UIButton()
    var indicatorLevelbar = UIImageView()
    
    let flagIcon = UIImageView()
    var memberSinceLabel = UILabel()
    
    var ghostTableBackground = UIView()
    
    var navigationToolBar = GRProfileToolbar()
    
    var paginatedScrollView = UIScrollView()
    var preferitiButton = UIButton()
    var productsCountLabel : UILabel?
    
    lazy var profileImageView: UserImage = {
        let userImage = UserImage()
        return userImage
    }()
    
    var provareButton = UIButton()
    
    var reputationView = UIView()
    var recensitiButton = UIButton()
    
    var seeAllButton = UIButton()
    var scansioniButton = UIButton()
    var selectedImageView = UIImageView()
    var __scaling__ = UIScrollView()
    
    
    var userLabelGrade = UILabel()
    var username : String = ""
    var userReputationNumericalLabel = UILabel()
    
    var viewsByName: [String: UIView]!
    var valueLabel = UILabel()
    
   
     /**
     counter properties
     */
    
    // var statisticsPlaceHolder = UIView()
    var statisticsPanel = GRUserProfileStatisticsTabbedPanel()

    var recensioniCounter = ""
    var scansioniCounter = ""
    var amiciCounter = ""
    var aggiuntiCounter = ""
    
    var recensioniStatBox = GRUserNumericalStatView()
    var scansioniStatBox = GRUserNumericalStatView()
    var amiciStatBox = GRUserNumericalStatView()
    var aggiuntiStatBox = GRUserNumericalStatView()
    
    var alimentariStats = GRUserStatsView()
    let alimentariIndicatorView = AnimatedCircle(frame: CGRect.zero)
    
    var bevandeStats = GRUserStatsView()
    let bevandeIndicatorView = AnimatedCircle(frame: CGRect.zero)
    
    var casaStats = GRUserStatsView()
    let casaIndicatorView = AnimatedCircle(frame: CGRect.zero)
    
    var benessereStats = GRUserStatsView()
    let benessereIndicatorView = AnimatedCircle(frame: CGRect.zero)
    
    var infanziaStats = GRUserStatsView()
    let infanziaIndicatorView = AnimatedCircle(frame: CGRect.zero)
    
    var animaliStats = GRUserStatsView()
    let animaliIndicatorView = AnimatedCircle(frame: CGRect.zero)
    
    var integratoriStats = GRUserStatsView()
    let integratoriIndicatorView = AnimatedCircle(frame: CGRect.zero)
    
    var libriStats = GRUserStatsView()
    let libriIndicatorView = AnimatedCircle(frame: CGRect.zero)
    
    
    var reputationButton = UIButton()
    var preferitiView = UIView()
    
    
    fileprivate let userStatsSingleBoxSize = CGSize(width: 110 / masterRatio, height: 184 / masterRatio)
    
    
    
    var recensitiLabel = UILabel()
    var scansioniLabel = UILabel()
    var provareLabel = UILabel()
    var evitareLabel = UILabel()
    var preferitiLabel = UILabel()
    
    weak var delegate: GRProfileViewController?
    
    
    
    var memberSince: Date? {
        didSet {
            if let date = memberSince{
                let dateComponents = Calendar.current.dateComponents([.year, .day, .month], from: date)
                let stringDate = "\(dateComponents.day!).\(dateComponents.month!).\(dateComponents.year!)"
                
                if dateComponents.year! > 2016 {
                    memberSinceLabel.text = "Iscritto dal \(stringDate)"
                    flagIcon.isHidden = true
                    memberSinceLabel.snp.remakeConstraints { make in
                        make.centerY.equalTo(flagIcon.snp.centerY)
                        make.centerX.equalTo(inviteFriendsButton)
                    }
                } else {
                    memberSinceLabel.text = "Pioniere dal \(stringDate)"
                    flagIcon.isHidden = false
                    memberSinceLabel.snp.remakeConstraints { make in
                        make.centerY.equalTo(flagIcon.snp.centerY)
                        make.left.equalTo(flagIcon.snp.right).offset(8 / masterRatio)
                    }
                }
            }
        }
    }
    
    // - MARK: Life Cycle
    
    convenience init(){
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
        // current layout goes like this:
        // - scroll view called __scaling__
        //   - stackView vertical
        //     - oldWrapper
        //     - statisticsPlaceHolder
        // TODO: split oldWrapper into more children of the stack view and use show/hide
        // to automatically resize the page instead of using formatForOneRow(), formatForTwoRows(), ..
        
        var viewsByName: [String: UIView] = [:]

        navigationToolBar.delegate = self
        addSubview(navigationToolBar)
        navigationToolBar.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(70)
            make.top.equalTo(0)
            make.left.equalTo(0)
        }
        
        __scaling__ = UIScrollView()
        __scaling__.bounces = true
        __scaling__.backgroundColor = UIColor(white:0.94, alpha:1.0)
        addSubview(__scaling__)
        sendSubview(toBack: __scaling__)
        __scaling__.snp.remakeConstraints { make in
            make.top.equalTo(navigationToolBar.snp.bottom).offset(40)
            make.width.equalTo(self)
            make.height.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__

        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        __scaling__.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.left.right.width.equalTo(__scaling__)
        }
        
        
        let oldWrapper = UIView()
        oldWrapper.translatesAutoresizingMaskIntoConstraints = false
        // a wrapper for the first part of the profile wrapping views that are not using
        // stack views yet. This wrapper is resized by code depending on its content
        // see.. GRProfileView+API oneRow(), twoRows()..
        stackView.addArrangedSubview(oldWrapper)
        oldWrapper.clipsToBounds = false
        oldWrapper.snp.remakeConstraints { make in
            make.width.equalTo(__scaling__)
            make.height.equalTo(2690 / masterRatio)
        }
        viewsByName["oldWrapper"] = oldWrapper
        
        let topCover = UIView()
        oldWrapper.addSubview(topCover)
        topCover.backgroundColor = UIColor.grocerestColor()
        topCover.snp.makeConstraints { make in
            make.top.equalTo(-900 / masterRatio)
            make.width.equalTo(self)
            make.left.equalTo(0)
            make.height.equalTo(1340 / masterRatio)
        }

           
        let topProfileView = UIView()
        oldWrapper.addSubview(topProfileView)
        topProfileView.backgroundColor = UIColor.grocerestColor()
        topProfileView.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.top.equalTo(oldWrapper.snp.top).offset(90 / masterRatio)
            make.height.equalTo(340 / masterRatio)
        }
        
        
        topProfileView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.largeProfileAvatar)
            make.left.equalTo(oldWrapper.snp.left).offset(63 / masterRatio)
            make.centerY.equalTo(topProfileView.snp.centerY)            
        }

        viewsByName["profileImageView"] = profileImageView
        
        let profileImageButton = UIButton(type: .custom)
        profileImageButton.addTarget(self, action: #selector(self.profileImageWasTapped(_:)), for: .touchUpInside)
        topProfileView.addSubview(profileImageButton)
        profileImageButton.snp.makeConstraints { make in
            make.edges.equalTo(topProfileView)
        }
        
        
        let pionerCenterView = UIView()
        topProfileView.addSubview(pionerCenterView)
        pionerCenterView.snp.makeConstraints { make in
            make.width.equalTo(348 / masterRatio)
            make.height.equalTo(73 / masterRatio)
            make.left.equalTo(profileImageView.snp.right).offset(30 / masterRatio)
            make.top.equalTo(topProfileView.snp.top).offset(90 / masterRatio)
        }
        
        flagIcon.contentMode = .scaleAspectFit
        flagIcon.image = UIImage(named: "Flag")
        pionerCenterView.addSubview(flagIcon)
        flagIcon.snp.makeConstraints { make in
            make.width.equalTo(36 / masterRatio)
            make.height.equalTo(46 / masterRatio)
            make.left.equalTo(pionerCenterView.snp.left).offset(25 / masterRatio)
            make.centerY.equalTo(pionerCenterView.snp.centerY)
        }
        
        memberSinceLabel = UILabel()
        memberSinceLabel.text = "Pioniere dal "
        memberSinceLabel.textColor = UIColor.white
        memberSinceLabel.font = Constants.BrandFonts.avenirRoman12
        memberSinceLabel.textAlignment = .left
        pionerCenterView.addSubview(memberSinceLabel)
        memberSinceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(flagIcon.snp.centerY)
            make.left.equalTo(flagIcon.snp.right).offset(8)
        }
        
        
        let inviteFriendsView = UIImageView()
        inviteFriendsView.contentMode = .scaleAspectFit
        inviteFriendsView.image = UIImage(named: "invite_button_border")
        topProfileView.addSubview(inviteFriendsView)
        inviteFriendsView.snp.makeConstraints { make in
            make.width.equalTo(348 / masterRatio)
            make.height.equalTo(73 / masterRatio)
            make.left.equalTo(pionerCenterView.snp.left)
            make.top.equalTo(flagIcon.snp.bottom).offset(28 / masterRatio)
        }
        
        
        let inviteFriendsIcon = UIImageView()
        inviteFriendsIcon.contentMode = .scaleAspectFit
        inviteFriendsIcon.image = UIImage(named: "invite_friends_icon")
        inviteFriendsView.addSubview(inviteFriendsIcon)
        inviteFriendsIcon.snp.makeConstraints { make in
            make.width.equalTo(55 / masterRatio)
            make.height.equalTo(40 / masterRatio)
            make.left.equalTo(inviteFriendsView.snp.left).offset(71 / masterRatio)
            make.centerY.equalTo(inviteFriendsView.snp.centerY)
        }
        
        let inviteFriendsLabel = UILabel()
        inviteFriendsLabel.text = "INVITA AMICI"
        inviteFriendsLabel.textColor = UIColor.white
        inviteFriendsLabel.font = Constants.BrandFonts.avenirBook12
        inviteFriendsLabel.textAlignment = .left
        inviteFriendsView.addSubview(inviteFriendsLabel)
        inviteFriendsLabel.snp.makeConstraints { make in
            make.left.equalTo(inviteFriendsIcon.snp.right).offset(4)
            make.centerY.equalTo(inviteFriendsIcon.snp.centerY)
        }
        
        inviteFriendsButton = UIButton(type: .custom)
        inviteFriendsButton.addTarget(self, action: #selector(self.actionInviteFriendsButtonWasPressed(_:)), for: .touchUpInside)
        topProfileView.addSubview(inviteFriendsButton)
        inviteFriendsButton.snp.makeConstraints { make in
            make.edges.equalTo(inviteFriendsView)
        }
        
        
        reputationView = UIView()
        oldWrapper.addSubview(reputationView)
        reputationView.backgroundColor = UIColor.grocerestDarkBoldGray()
        reputationView.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.left.equalTo(0)
            make.top.equalTo(topProfileView.snp.bottom)
            make.height.equalTo(148 / masterRatio)
        }
        viewsByName["reputationView"] = reputationView
        
        
        let labelLevel = UILabel()
        labelLevel.text = Constants.AppLabels.grocerestLevel
        labelLevel.font = Constants.BrandFonts.avenirBook11
        labelLevel.textColor = UIColor.grocerestLightGrayColor()
        labelLevel.textAlignment = .left
        oldWrapper.addSubview(labelLevel)
        labelLevel.snp.makeConstraints { make in
            make.width.equalTo(200 / masterRatio)
            make.left.equalTo(reputationView.snp.left).offset(35 / masterRatio)
            make.top.equalTo(reputationView.snp.top).offset(33 / masterRatio)
        }
        
        
        valueLabel = UILabel()
        valueLabel.text = "1/5"
        valueLabel.textColor = UIColor.grocerestBlue()
        valueLabel.textAlignment = .center
        valueLabel.font = Constants.BrandFonts.avenirHeavy11
        oldWrapper.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.width.equalTo(126 / masterRatio)
            make.height.equalTo(30 / masterRatio)
            make.left.equalTo(reputationView.snp.left).offset(200 / masterRatio)
            make.top.equalTo(reputationView.snp.top).offset(33 / masterRatio)
        }
        
        
        let verticalSpread = UIView()
        verticalSpread.backgroundColor = UIColor(white:0.4, alpha:1.0)
        oldWrapper.addSubview(verticalSpread)
        verticalSpread.snp.makeConstraints { make in
            make.width.equalTo(1.0)
            make.height.equalTo(80 / masterRatio)
            make.centerY.equalTo(reputationView.snp.centerY)
            make.left.equalTo(reputationView.snp.left).offset(545 / masterRatio)
        }
        
        
        let reputationRightLabel = UILabel()
        reputationRightLabel.text = Constants.AppLabels.reputation
        reputationRightLabel.font = Constants.BrandFonts.avenirBook11
        reputationRightLabel.textColor = UIColor.grocerestLightGrayColor()
        reputationRightLabel.textAlignment = .left
        oldWrapper.addSubview(reputationRightLabel)
        reputationRightLabel.snp.makeConstraints { make in
            make.width.equalTo(126 / masterRatio)
            make.height.equalTo(30 / masterRatio)
            make.left.equalTo(verticalSpread.snp.right).offset(52 /  masterRatio)
            make.top.equalTo(labelLevel.snp.top)
        }
        
        
        badgeImageView = UIImageView()
        oldWrapper.addSubview(badgeImageView)
        badgeImageView.contentMode = .scaleAspectFit
        badgeImageView.snp.makeConstraints { make in
            make.left.equalTo(reputationView.snp.left).offset(34 / masterRatio)
            make.top.equalTo(labelLevel.snp.bottom).offset(16 / masterRatio)
            make.width.equalTo(27 / masterRatio)
            make.height.equalTo(35 / masterRatio)
        }
        
        
        userLabelGrade = UILabel()
        userLabelGrade.text = "Livello 1"
        userLabelGrade.font = Constants.BrandFonts.ubuntuBold14
        userLabelGrade.textColor = UIColor.white
        userLabelGrade.textAlignment = .left
        oldWrapper.addSubview(userLabelGrade)
        userLabelGrade.snp.makeConstraints { make in
            make.height.equalTo(35 / masterRatio)
            make.left.equalTo(badgeImageView.snp.right).offset(12 / masterRatio)
            make.top.equalTo(badgeImageView.snp.top)
        }
        
        
        indicatorLevelbar = UIImageView()
        indicatorLevelbar.contentMode = .scaleAspectFit
        indicatorLevelbar.image = UIImage(named: "level_one")
        oldWrapper.addSubview(indicatorLevelbar)
        indicatorLevelbar.snp.makeConstraints { make in
            make.width.equalTo(252 / masterRatio)
            make.height.equalTo(25 / masterRatio)
            make.left.equalTo(userLabelGrade.snp.right).offset(52 / masterRatio)
            make.bottom.equalTo(userLabelGrade.snp.bottom)
        }
        
        
        let reputationBadge = UIImageView()
        reputationBadge.contentMode = .scaleAspectFit
        reputationBadge.image = UIImage(named: "grocerest_reputation")
        oldWrapper.addSubview(reputationBadge)
        reputationBadge.snp.makeConstraints { make in
            make.width.height.equalTo(32 / masterRatio)
            make.left.equalTo(verticalSpread.snp.right).offset(52 / masterRatio)
            make.top.equalTo(badgeImageView.snp.top)
        }
        
        
        userReputationNumericalLabel = UILabel()
        userReputationNumericalLabel.text = "0"
        userReputationNumericalLabel.font = Constants.BrandFonts.ubuntuBold14
        userReputationNumericalLabel.textAlignment  = .left
        userReputationNumericalLabel.textColor = UIColor.white
        userReputationNumericalLabel.adjustsFontSizeToFitWidth = true
        oldWrapper.addSubview(userReputationNumericalLabel)
        userReputationNumericalLabel.snp.makeConstraints { make in
            make.width.equalTo(65 / masterRatio)
            make.height.equalTo(35 / masterRatio)
            make.top.equalTo(badgeImageView.snp.top)
            make.left.equalTo(reputationBadge.snp.right).offset(13 / masterRatio)
        }
        
        
        let profileCategoriesView = UIView()
        profileCategoriesView.layer.borderWidth = 0.5
        profileCategoriesView.layer.borderColor = UIColor.lightGray.cgColor
        oldWrapper.addSubview(profileCategoriesView)
        profileCategoriesView.snp.makeConstraints { make in
            make.height.equalTo(210 / masterRatio)
            make.width.equalTo(self)
            make.left.equalTo(0)
            make.top.equalTo(reputationView.snp.bottom)
        }
        
        
        paginatedScrollView = UIScrollView()
        paginatedScrollView.showsHorizontalScrollIndicator = false
        paginatedScrollView.bounces = true
        paginatedScrollView.delegate = self
        paginatedScrollView.contentSize = CGSize(width: 1200 / masterRatio, height: 205 / masterRatio)
        paginatedScrollView.backgroundColor = UIColor(white:0.94, alpha:1.0)
        paginatedScrollView.autoresizesSubviews = false
        profileCategoriesView.addSubview(paginatedScrollView)
        paginatedScrollView.snp.makeConstraints { make in
            make.left.top.equalTo(0)
            make.width.equalTo(self)
            make.height.equalTo(profileCategoriesView.snp.height)
        }
        
        paginatedScrollView.addSubview(preferitiView)
        preferitiView.snp.makeConstraints { make in
            make.height.width.equalTo(200 / masterRatio)
            make.top.equalTo(paginatedScrollView.snp.top)
            make.left.equalTo(0)
        }
        
        selectedImageView = UIImageView()
        selectedImageView.contentMode = .scaleAspectFit
        selectedImageView.image = UIImage(named: "selectedView")
        paginatedScrollView.addSubview(selectedImageView)
        topProfileView.bringSubview(toFront: selectedImageView)
        selectedImageView.snp.makeConstraints { make in
            make.width.equalTo(preferitiView.snp.width)
            make.height.equalTo(8.5 / masterRatio)
            make.left.equalTo(preferitiView.snp.left)
            make.bottom.equalTo(preferitiView.snp.bottom).offset(4)
        }

        
        preferitiButton = UIButton(type: .custom)
        preferitiButton.tag = 0
        preferitiButton.contentMode = .scaleAspectFit
        preferitiButton.setImage(UIImage(named: "preferiti_on_dark"), for: UIControlState())
        preferitiButton.setImage(UIImage(named: "preferiti_on_dark"), for: .selected)
        preferitiButton.addTarget(self, action: #selector(self.actionPreferitiButtonWasPressed(_:)), for: .touchUpInside)
        preferitiView.addSubview(preferitiButton)
        preferitiButton.snp.makeConstraints { make in
            make.edges.equalTo(preferitiView)
        }
        
        
        preferitiLabel.text = "PREFERITI"
        preferitiLabel.font = Constants.BrandFonts.avenirHeavy11
        preferitiLabel.textColor = UIColor.grocerestDarkBoldGray()
        preferitiLabel.textAlignment = .center
        preferitiView.addSubview(preferitiLabel)
        preferitiLabel.snp.makeConstraints { make in
            make.width.equalTo(106 / masterRatio)
            make.height.equalTo(24 / masterRatio)
            make.top.equalTo(preferitiButton.snp.bottom).offset(-45 / masterRatio)
            make.centerX.equalTo(preferitiButton.snp.centerX)
        }
        
        viewsByName["preferitiView"] = preferitiView

        
        let evitareView = UIView()
        paginatedScrollView.addSubview(evitareView)
        evitareView.snp.makeConstraints { make in
            make.height.width.equalTo(200 / masterRatio)
            make.top.equalTo(paginatedScrollView.snp.top)
            make.left.equalTo(preferitiView.snp.right)
        }
        
        
        evitareButton = UIButton(type: .custom)
        evitareButton.tag = 1
        evitareButton.setImage(UIImage(named: "evitare_off_dark"), for: UIControlState())
        evitareButton.setImage(UIImage(named: "evitare_on_dark"), for: .selected)
        evitareButton.addTarget(self, action: #selector(self.actionEvitareButtonWasPressed(_:)), for: .touchUpInside)
        evitareView.addSubview(evitareButton)
        evitareButton.snp.makeConstraints { make in
            make.edges.equalTo(evitareView)
        }
        
        
        evitareLabel.text = "DA EVITARE"
        evitareLabel.font = Constants.BrandFonts.avenirHeavy11
        evitareLabel.textColor = UIColor.grocerestOffText()
        evitareLabel.textAlignment = .center
        evitareView.addSubview(evitareLabel)
        evitareLabel.snp.makeConstraints { make in
            make.width.equalTo(145 / masterRatio)
            make.height.equalTo(24 / masterRatio)
            make.top.equalTo(evitareButton.snp.bottom).offset(-45 / masterRatio)
            make.centerX.equalTo(evitareButton.snp.centerX)
        }
    
        viewsByName["evitareView"] = evitareView
        
        
        let provareView = UIView()
        paginatedScrollView.addSubview(provareView)
        provareView.snp.makeConstraints { make in
            make.height.width.equalTo(200 / masterRatio)
            make.top.equalTo(paginatedScrollView.snp.top)
            make.left.equalTo(evitareView.snp.right)
        }
        
        provareButton = UIButton(type: .custom)
        provareButton.tag = 2
        provareButton.setImage(UIImage(named: "provare_off_dark"), for: UIControlState())
        provareButton.setImage(UIImage(named: "provare_on_dark"), for: .selected)
        provareButton.addTarget(self, action: #selector(self.actionProvareButtonWasPressed(_:)), for: .touchUpInside)
        provareView.addSubview(provareButton)
        provareButton.snp.makeConstraints { make in
            make.edges.equalTo(provareView)
        }
        
        
        provareLabel.text = "DA PROVARE"
        provareLabel.font = Constants.BrandFonts.avenirHeavy11
        provareLabel.textColor = UIColor.grocerestOffText()
        provareLabel.textAlignment = .center
        provareView.addSubview(provareLabel)
        provareLabel.snp.makeConstraints { make in
            make.width.equalTo(145 / masterRatio)
            make.height.equalTo(24 / masterRatio)
            make.top.equalTo(provareButton.snp.bottom).offset(-45 / masterRatio)
            make.centerX.equalTo(provareView.snp.centerX)
        }
        
        
        viewsByName["provareView"] = provareView
        
        /**
        Recensiti
        */
        
        let recensitiView = UIView()
        paginatedScrollView.addSubview(recensitiView)
        recensitiView.snp.makeConstraints { make in
            make.height.width.equalTo(200 / masterRatio)
            make.top.equalTo(paginatedScrollView.snp.top)
            make.left.equalTo(provareView.snp.right)
        }
  
        recensitiButton = UIButton(type: .custom)
        recensitiButton.tag = 3
        recensitiButton.setImage(UIImage(named: "recensioni_off"), for: UIControlState())
        recensitiButton.setImage(UIImage(named: "recensioni_on"), for: .selected)
        recensitiButton.addTarget(self, action: #selector(self.actionRecensitiButtonWasPressed(_:)), for: .touchUpInside)
        recensitiView.addSubview(recensitiButton)
        recensitiButton.snp.makeConstraints { make in
            make.edges.equalTo(recensitiView)
        }
        
        
        recensitiLabel.text = "RECENSITI"
        recensitiLabel.font = Constants.BrandFonts.avenirHeavy11
        recensitiLabel.textColor = UIColor.grocerestOffText()
        recensitiLabel.textAlignment = .center
        recensitiView.addSubview(recensitiLabel)
        recensitiLabel.snp.makeConstraints { make in
            make.width.equalTo(145 / masterRatio)
            make.height.equalTo(24 / masterRatio)
            make.top.equalTo(recensitiButton.snp.bottom).offset(-45 / masterRatio)
            make.centerX.equalTo(recensitiButton.snp.centerX)
        }
        
        viewsByName["recensitiView"] = recensitiView
        
        
        let scansioniView = UIView()
        paginatedScrollView.addSubview(scansioniView)
        scansioniView.snp.makeConstraints { make in
            make.height.width.equalTo(200 / masterRatio)
            make.top.equalTo(paginatedScrollView.snp.top)
            make.left.equalTo(recensitiView.snp.right)
        }
        
        
        scansioniButton = UIButton(type: .custom)
        scansioniButton.tag = 4
        scansioniButton.setImage(UIImage(named: "scansioni_off"), for: UIControlState())
        scansioniButton.setImage(UIImage(named: "scansioni_on"), for: .selected)
        scansioniButton.addTarget(self, action: #selector(self.actionScansioneButtonWasPressed(_:)), for: .touchUpInside)
        scansioniView.addSubview(scansioniButton)
        scansioniButton.snp.makeConstraints { make in
            make.edges.equalTo(scansioniView)
        }
        
        
        scansioniLabel.text = "SCANSIONI"
        scansioniLabel.font = Constants.BrandFonts.avenirHeavy11
        scansioniLabel.textColor = UIColor.grocerestOffText()
        scansioniLabel.textAlignment = .center
        scansioniView.addSubview(scansioniLabel)
        scansioniLabel.snp.makeConstraints { make in
            make.width.equalTo(145 / masterRatio)
            make.height.equalTo(24 / masterRatio)
            make.top.equalTo(scansioniButton.snp.bottom).offset(-45 / masterRatio)
            make.centerX.equalTo(scansioniButton.snp.centerX)
        }
        
        viewsByName["scansioniView"] = scansioniView
        
 
        productsCountLabel = UILabel()
        productsCountLabel!.textColor = UIColor.grocerestLightGrayColor()
        productsCountLabel!.font = Constants.BrandFonts.avenirBook11
        productsCountLabel!.textAlignment = .left
        oldWrapper.addSubview(productsCountLabel!)
        productsCountLabel!.snp.makeConstraints { make in
            make.width.equalTo(426 / masterRatio)
            make.height.equalTo(30 / masterRatio)
            make.left.equalTo(oldWrapper.snp.left).offset(34 / masterRatio)
            make.top.equalTo(paginatedScrollView.snp.bottom).offset(23 / masterRatio)
        }
        
        
        oldWrapper.addSubview(ghostTableBackground)
        ghostTableBackground.snp.makeConstraints { make in
            make.width.equalTo(687 / masterRatio)
            make.top.equalTo(productsCountLabel!.snp.bottom).offset(39 / masterRatio)
            make.centerX.equalTo(oldWrapper.snp.centerX)
            // set dinamic height > 3 elements from datasource
            make.height.equalTo(850 / masterRatio)
        }
        
        seeAllButton.contentMode = .scaleAspectFit
        seeAllButton.setBackgroundImage(UIImage(named: "outlinedButton"), for: UIControlState())
        seeAllButton.setTitle(NSLocalizedString("VEDI TUTTI", comment: "see all elements button at the footer of profile view"), for: UIControlState())
        seeAllButton.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        seeAllButton.titleLabel?.font = Constants.BrandFonts.avenirHeavy11
        seeAllButton.addTarget(self, action: #selector(self.actionSeeAllWasPressed), for: .touchUpInside)
        oldWrapper.addSubview(seeAllButton)
        seeAllButton.snp.makeConstraints { make in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(80 / masterRatio)
            make.top.equalTo(ghostTableBackground.snp.bottom).offset(8 /  masterRatio)
            make.centerX.equalTo(oldWrapper.snp.centerX)
        }
        
        reputationButton.addTarget(self, action: #selector(self.reputationButtonWasPressed(_:)), for: .touchUpInside)
        reputationView.addSubview(reputationButton)
        reputationButton.snp.makeConstraints { make in
            make.edges.equalTo(reputationView.snp.edges)
        }
        
        let spacing = UIView()
        stackView.addArrangedSubview(spacing)
        spacing.snp.makeConstraints { make in
            make.height.equalTo(32 / masterRatio)
        }
        
        statisticsPanel.backgroundColor = UIColor.grocerestDarkBoldGray()
        statisticsPanel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(statisticsPanel)
        statisticsPanel.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
        }
        
        self.viewsByName = viewsByName
    }
    
}

extension GRProfileView {
    func reputationButtonWasPressed(_ sender:UIButton){
        delegate!.showUserReputation(sender)
    }
}
