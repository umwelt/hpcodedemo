//
//  GRUserProfileView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 24/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import Haneke

class GRUserProfileView: UIView {
    
    var navigationToolBar = GRToolbar()
    
    lazy var profileImageView : UserImage = {
        let userImage = UserImage()
        return userImage
    }()
    
    private let flagIcon = UIImageView()
    var memberSinceLabel = UILabel()
    var reputationView = UIView()
    
    var tableView: UITableView!
    
    var openTableButton: GRShineButton!
    
    private let pionerCenterView = UIView()
    private var userReputationNumericalLabel = UILabel()
    private var userLabelGrade = UILabel()
    private var indicatorLevelbar = UIImageView()
    private var badgeImageView = UIImageView()
    private var valueLabel = UILabel()
    private var productsCountLabel = UILabel()
    private var buttonWrapper = UIView()
    var scrollView = UIScrollView()
    
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
    
    
    fileprivate let userStatsSingleBoxSize = CGSize(width: 110 / masterRatio, height: 184 / masterRatio)
    
    
    
    var recensitiLabel = UILabel()
    var scansioniLabel = UILabel()
    var provareLabel = UILabel()
    var evitareLabel = UILabel()
    var preferitiLabel = UILabel()

    
    
    var onOpenTableButtonTapped: (() -> Void)?
    
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
        self.addSubview(navigationToolBar)
        navigationToolBar.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.equalTo(0)
            make.left.equalTo(0)
        }
        
        scrollView.bounces = true
        scrollView.backgroundColor = UIColor(white:0.94, alpha:1.0)
        self.addSubview(scrollView)
        
        scrollView.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(navigationToolBar.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.left.right.width.equalTo(scrollView)
        }
        
        let topProfileView = UIView()
        stackView.addArrangedSubview(topProfileView)
        topProfileView.backgroundColor = UIColor.grocerestColor()
        topProfileView.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(355 / masterRatio)
        }
        topProfileView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(230 / masterRatio)
            make.left.equalTo(topProfileView.snp.left).offset(63 / masterRatio)
            make.centerY.equalTo(topProfileView.snp.centerY)
        }

        topProfileView.addSubview(pionerCenterView)
        pionerCenterView.snp.makeConstraints { make in
            make.width.equalTo(348 / masterRatio)
            make.height.equalTo(73 / masterRatio)
            make.right.equalTo(-74 / masterRatio)
            make.top.equalTo(topProfileView.snp.top).offset(90 / masterRatio)
        }

        topProfileView.addSubview(flagIcon)
        flagIcon.snp.makeConstraints { make in
            make.width.equalTo(36 / masterRatio)
            make.height.equalTo(46 / masterRatio)
            make.left.equalTo(pionerCenterView.snp.left).offset(30 / masterRatio)
            make.centerY.equalTo(topProfileView.snp.centerY)
        }
        flagIcon.contentMode = .scaleAspectFit
        flagIcon.image = UIImage(named: "Flag")
        topProfileView.addSubview(memberSinceLabel)
        memberSinceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(flagIcon.snp.centerY)
            make.left.equalTo(flagIcon.snp.right).offset(8)
        }
        memberSinceLabel.text = "Pioniere dal "
        memberSinceLabel.textColor = UIColor.white
        memberSinceLabel.font = Constants.BrandFonts.avenirRoman12
        memberSinceLabel.textAlignment = .left
        
        let topCover = UIView()
        self.addSubview(topCover)
        topCover.backgroundColor = UIColor.grocerestColor()
        topCover.snp.makeConstraints { make in
            make.bottom.equalTo(topProfileView.snp.top)
            make.width.centerX.equalTo(self)
            make.height.equalTo(1000)
        }
    
        stackView.addArrangedSubview(reputationView)
        reputationView.backgroundColor = UIColor.grocerestDarkBoldGray()
        reputationView.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.left.equalTo(0)
            make.top.equalTo(topProfileView.snp.bottom)
            make.height.equalTo(148 / masterRatio)
        }
        let labelLevel = UILabel()
        reputationView.addSubview(labelLevel)
        labelLevel.snp.makeConstraints { make in
            make.width.equalTo(200 / masterRatio)
            make.left.equalTo(reputationView.snp.left).offset(35 / masterRatio)
            make.top.equalTo(reputationView.snp.top).offset(33 / masterRatio)
        }
        labelLevel.text = Constants.AppLabels.grocerestLevel
        labelLevel.font = Constants.BrandFonts.avenirBook11
        labelLevel.textColor = UIColor.grocerestLightGrayColor()
        labelLevel.textAlignment = .left
        reputationView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.width.equalTo(126 / masterRatio)
            make.height.equalTo(30 / masterRatio)
            make.left.equalTo(reputationView.snp.left).offset(200 / masterRatio)
            make.top.equalTo(reputationView.snp.top).offset(33 / masterRatio)
        }
        //valueLabel.text = "1/5"
        valueLabel.textColor = UIColor.grocerestBlue()
        valueLabel.textAlignment = .center
        valueLabel.font = Constants.BrandFonts.avenirHeavy11
        let verticalSpread = UIView()
        reputationView.addSubview(verticalSpread)
        verticalSpread.snp.makeConstraints { make in
            make.width.equalTo(1.0)
            make.height.equalTo(80 / masterRatio)
            make.centerY.equalTo(reputationView.snp.centerY)
            make.left.equalTo(reputationView.snp.left).offset(545 / masterRatio)
        }
        verticalSpread.backgroundColor = UIColor(white:0.4, alpha:1.0)
        
        let reputationRightLabel = UILabel()
        reputationView.addSubview(reputationRightLabel)
        reputationRightLabel.snp.makeConstraints { make in
            make.width.equalTo(126 / masterRatio)
            make.height.equalTo(30 / masterRatio)
            make.left.equalTo(verticalSpread.snp.right).offset(52 /  masterRatio)
            make.top.equalTo(labelLevel.snp.top)
        }
        reputationRightLabel.text = Constants.AppLabels.reputation
        reputationRightLabel.font = Constants.BrandFonts.avenirBook11
        reputationRightLabel.textColor = UIColor.grocerestLightGrayColor()
        reputationRightLabel.textAlignment = .left
        reputationView.addSubview(badgeImageView)
        badgeImageView.contentMode = .scaleAspectFit
        badgeImageView.snp.makeConstraints { make in
            make.left.equalTo(reputationView.snp.left).offset(34 / masterRatio)
            make.top.equalTo(labelLevel.snp.bottom).offset(16 / masterRatio)
            make.width.equalTo(27 / masterRatio)
            make.height.equalTo(35 / masterRatio)
        }
        badgeImageView.image = UIImage(named: "v2_level_one")
        reputationView.addSubview(userLabelGrade)
        userLabelGrade.snp.makeConstraints { make in
            make.height.equalTo(35 / masterRatio)
            make.left.equalTo(badgeImageView.snp.right).offset(12 / masterRatio)
            make.top.equalTo(badgeImageView.snp.top)
        }
        userLabelGrade.text = "Livello 1"
        userLabelGrade.font = Constants.BrandFonts.ubuntuBold14
        userLabelGrade.textColor = UIColor.white
        userLabelGrade.textAlignment = .left
        reputationView.addSubview(indicatorLevelbar)
        indicatorLevelbar.snp.makeConstraints { make in
            make.width.equalTo(252 / masterRatio)
            make.height.equalTo(25 / masterRatio)
            make.left.equalTo(userLabelGrade.snp.right).offset(52 / masterRatio)
            make.bottom.equalTo(userLabelGrade.snp.bottom)
        }
        indicatorLevelbar.contentMode = .scaleAspectFit
        indicatorLevelbar.image = UIImage(named: "level_one")
        let reputationBadge = UIImageView()
        reputationView.addSubview(reputationBadge)
        reputationBadge.snp.makeConstraints { make in
            make.width.height.equalTo(32 / masterRatio)
            make.left.equalTo(verticalSpread.snp.right).offset(52 / masterRatio)
            make.top.equalTo(badgeImageView.snp.top)
        }
        reputationBadge.contentMode = .scaleAspectFit
        reputationBadge.image = UIImage(named: "grocerest_reputation")
        reputationView.addSubview(userReputationNumericalLabel)
        userReputationNumericalLabel.snp.makeConstraints { make in
            make.width.equalTo(65 / masterRatio)
            make.height.equalTo(35 / masterRatio)
            make.top.equalTo(badgeImageView.snp.top)
            make.left.equalTo(reputationBadge.snp.right).offset(13 / masterRatio)
        }
        userReputationNumericalLabel.text = "0"
        userReputationNumericalLabel.font = Constants.BrandFonts.ubuntuBold14
        userReputationNumericalLabel.textAlignment  = .left
        userReputationNumericalLabel.textColor = UIColor.white
        userReputationNumericalLabel.adjustsFontSizeToFitWidth = true
        
        
        let productsCountLabelWrapper = UIView()
        stackView.addArrangedSubview(productsCountLabelWrapper)
        productsCountLabelWrapper.snp.makeConstraints { make in
            make.width.equalTo(426 / masterRatio)
            make.height.equalTo((60) / masterRatio)
            make.left.equalTo(reputationView.snp.left).offset(34 / masterRatio)
        }
        let subWrapper = UIView()
        productsCountLabelWrapper.addSubview(subWrapper)
        subWrapper.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(productsCountLabelWrapper)
            make.top.equalTo(productsCountLabelWrapper.snp.top).offset(13/2)
        }
        subWrapper.addSubview(productsCountLabel)
        productsCountLabel.snp.makeConstraints { make in
            make.width.left.equalTo(subWrapper)
            make.centerY.equalTo(subWrapper.snp.centerY)
        }
        productsCountLabel.textColor = UIColor.grocerestLightGrayColor()
        productsCountLabel.font = Constants.BrandFonts.avenirBook11
        productsCountLabel.textAlignment = .left
        productsCountLabel.text = "225 products"
        
        tableView = UITableView()
        stackView.addArrangedSubview(tableView)
        tableView.bounces = true
        tableView.register(GRUserReviewTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 372 / masterRatio
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.tableFooterView?.isHidden = true
        tableView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        
        buttonWrapper = UIView()
        stackView.addArrangedSubview(buttonWrapper)
        buttonWrapper.clipsToBounds = true
        buttonWrapper.snp.makeConstraints { make in
            make.width.left.equalTo(self)
            make.height.equalTo((70+50+50) / masterRatio)
        }
        openTableButton = GRShineButton()
        buttonWrapper.addSubview(openTableButton)
        openTableButton.setTitle("LEGGI TUTTE", for: UIControlState())
        openTableButton.setTitleColor(UIColor(hexString: "#29ABE2"), for: UIControlState())
        openTableButton.titleLabel?.font = UIFont.avenirHeavy(22)
        openTableButton.layer.borderColor = UIColor(hexString: "#29ABE2").cgColor
        openTableButton.layer.borderWidth = 4 / masterRatio
        openTableButton.layer.cornerRadius = 10 / masterRatio
        openTableButton.snp.makeConstraints { make in
            make.width.equalTo(687 / masterRatio)
            make.height.equalTo(70 / masterRatio)
            make.center.equalTo(buttonWrapper.snp.center)
        }
        
        openTableButton.addTarget(self, action:#selector(GRUserProfileView.navigateToUserReviewsWasPressed(_:)), for: .touchUpInside)
        
        
        let spacing = UIView()
        stackView.addArrangedSubview(spacing)
        spacing.snp.makeConstraints { make in
            make.height.equalTo(32 / masterRatio)
        }
        
        statisticsPanel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(statisticsPanel)
        statisticsPanel.snp.makeConstraints { make in
            make.left.width.equalTo(self)
        }
        statisticsPanel.backgroundColor = UIColor.grocerestDarkBoldGray()
        
        self.bringSubview(toFront: navigationToolBar)
        scrollView.bringSubview(toFront: openTableButton)
        
    }
    
    
    func navigateToUserReviewsWasPressed(_ sender:UIButton) {
        onOpenTableButtonTapped?()
    }
    
    func setUserImage(_ author:JSON) {
        let type = AvatarType.profile
        profileImageView.setUserProfileAvatar(author["picture"].stringValue, name: author["firstname"].stringValue, lastName: author["lastname"].stringValue, type: type)
    }
    
    
    func setUserMemberSince(_ timestamp: String) {
        let date = convertFromTimestamp(timestamp)
        let dateComponents = Calendar.current.dateComponents([.year, .day, .month], from: date)
        let stringDate = "\(dateComponents.day!).\(dateComponents.month!).\(dateComponents.year!)"
        
        if dateComponents.year! > 2016 {
            memberSinceLabel.text = "Iscritto dal \(stringDate)"
            flagIcon.isHidden = true
            memberSinceLabel.snp.remakeConstraints { make in
                make.centerY.equalTo(flagIcon.snp.centerY)
                make.left.equalTo(pionerCenterView.snp.left).offset(30 / masterRatio)
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
    
    func formatReputationScoreSection(_ data:JSON) {
        let topMargin = 49.00 / masterRatio
        
        userReputationNumericalLabel.text = "\(data["score"].intValue)"
        
        if let level = data["level"].int {
            userLabelGrade.text = "Livello \(level)"
            
            switch level {
            case 1:
                indicatorLevelbar.image = UIImage(named: "level_one")
                badgeImageView.image = UIImage(named: "v2_level_one")
                valueLabel.text = "1/5"
                valueLabel.snp.remakeConstraints { make in
                    make.width.equalTo(126 / masterRatio)
                    make.height.equalTo(30 / masterRatio)
                    make.left.equalTo(reputationView.snp.left).offset(185 / masterRatio)
                    make.top.equalTo(reputationView.snp.top).offset(topMargin)
                }
            case 2:
                indicatorLevelbar.image = UIImage(named: "level_two")
                badgeImageView.image = UIImage(named: "v2_level_two")
                valueLabel.text  = "2/5"
                valueLabel.snp.remakeConstraints { make in
                    make.width.equalTo(126 / masterRatio)
                    make.height.equalTo(30 / masterRatio)
                    make.left.equalTo(reputationView.snp.left).offset(243 / masterRatio)
                    make.top.equalTo(reputationView.snp.top).offset(topMargin)
                }
            case 3:
                indicatorLevelbar.image = UIImage(named: "level_three")
                badgeImageView.image = UIImage(named: "v2_level_three")
                valueLabel.text = "3/5"
                valueLabel.snp.remakeConstraints { make in
                    make.width.equalTo(126 / masterRatio)
                    make.height.equalTo(30 / masterRatio)
                    make.left.equalTo(reputationView.snp.left).offset(302 / masterRatio)
                    make.top.equalTo(reputationView.snp.top).offset(topMargin)
                }
            case 4:
                indicatorLevelbar.image = UIImage(named: "level_four")
                badgeImageView.image = UIImage(named: "v2_level_four")
                valueLabel.text = "4/5"
                valueLabel.snp.remakeConstraints { make in
                    make.width.equalTo(126 / masterRatio)
                    make.height.equalTo(30 / masterRatio)
                    make.left.equalTo(reputationView.snp.left).offset(360 / masterRatio)
                    make.top.equalTo(reputationView.snp.top).offset(topMargin)
                }
            case 5:
                indicatorLevelbar.image = UIImage(named: "level_five")
                badgeImageView.image = UIImage(named: "v2_level_five")
                valueLabel.text = "5/5"
                valueLabel.snp.remakeConstraints { make in
                    make.width.equalTo(126 / masterRatio)
                    make.height.equalTo(30 / masterRatio)
                    make.left.equalTo(reputationView.snp.left).offset(417 / masterRatio)
                    make.top.equalTo(reputationView.snp.top).offset(topMargin)
                }
            default:
                indicatorLevelbar.image = UIImage(named: "level_one")
                badgeImageView.image = UIImage(named: "v2_level_one")
                valueLabel.text = "1/5"
            }
        }
    }
    
    func formaProductsCountLabel(_ reviews:Int, loading:Bool = false) {
        if loading {
            productsCountLabel.text = "Caricamento…"
            return
        }
        if reviews == 1 {
            productsCountLabel.text = "\(String(reviews)) commento scritto"
        } else {
            productsCountLabel.text = "\(String(reviews)) commenti scritti"
        }
    }
    
    func buttonWrapperSetHidden(_ value:Bool) {
        self.buttonWrapper.isHidden = value;
    }
    
    
    func formatTableViewPosition(_ height: CGFloat) {
        tableView.snp.remakeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(height / masterRatio)
        }
    }
    
    
    func formaUserStatistics(_ userStats: JSON) {
        self.recensioniStatBox.statCounter.text = userStats["reviews"].stringValue
        self.scansioniStatBox.statCounter.text = userStats["eanAssociations"].stringValue
        self.amiciStatBox.statCounter.text = userStats["successfulInvitations"].stringValue
        self.aggiuntiStatBox.statCounter.text = userStats["productProposals"].stringValue
        
        self.recensioniStatBox.alpha = 1
        self.scansioniStatBox.alpha = 1
        self.amiciStatBox.alpha = 1
        self.aggiuntiStatBox.alpha = 1
   
    }

}

