//
//  GRMenuView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import Haneke


@IBDesignable
class GRMenuView: UIView {

    var animationCompletions = Dictionary<CAAnimation, (Bool) -> Void>()
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var profileButton = UIButton()
    var userUsername : UILabel?

    internal var viewsByName: [String: UIView]!
    internal var userNameLabel = UILabel()
    lazy var profileImageView : UserImage = {
        let userImage = UserImage()

        return userImage
    }()
    internal var genericProfileImage: UILabel?


    // - MARK: Life cycle

    // convenience init() {
    //     self.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 100, UIScreen.mainScreen().bounds.height))
    // }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupHierarchy()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }

    var delegate : GRMenuProtocol?


    //Mark: Transition IN on scalar View

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


    // - MARL: Setup

    func setupHierarchy() {
        var viewsByName: [String: UIView] = [:]

        let __scaling__ = UIView()
        __scaling__.backgroundColor = UIColor.darkGray.withAlphaComponent(0.55)
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__


        let viewBlurredBackground = UIVisualEffectView(effect: blurEffect)
        __scaling__.addSubview(viewBlurredBackground)
        viewBlurredBackground.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(__scaling__)
            make.right.top.equalTo(0)
            // we allow this view to overflow on the left of the container
            // a lot so we can cover more areas while animating
            make.width.equalTo(1000 / masterRatio)
        }
        viewsByName["viewBlurredBackground"] = viewBlurredBackground


        let viewWithVibrancy = UIVisualEffectView(effect: blurEffect)
        viewBlurredBackground.contentView.addSubview(viewWithVibrancy)
        viewWithVibrancy.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(viewBlurredBackground)
        }

        viewWithVibrancy.contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize.menuProfileAvatar)
            make.left.equalTo(self.snp.left).offset(67 / masterRatio)
            make.top.equalTo(self.snp.top).offset(110 / masterRatio)

        }

        genericProfileImage = UILabel()
        viewWithVibrancy.contentView.addSubview(genericProfileImage!)
        genericProfileImage?.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(100 / masterRatio)
            make.left.equalTo(self.snp.left).offset(67 / masterRatio)
            make.top.equalTo(self.snp.top).offset(110 / masterRatio)
        })
        genericProfileImage!.layer.borderWidth = 1.0
        genericProfileImage!.layer.masksToBounds = false
        genericProfileImage!.layer.borderColor = UIColor.clear.cgColor
        genericProfileImage!.layer.cornerRadius = 48 / masterRatio
        genericProfileImage!.clipsToBounds = true

        genericProfileImage?.font = Constants.BrandFonts.ubuntuBold18
        genericProfileImage?.textAlignment = .center
        genericProfileImage?.textColor = UIColor.white
        genericProfileImage?.isHidden = true


        userNameLabel = UILabel()
        viewWithVibrancy.contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(profileImageView.snp.right).offset(37 / masterRatio)
            make.top.equalTo(self.snp.top).offset(121 / masterRatio)
        }
        userNameLabel.textColor = UIColor.F1F1F1Color()
        userNameLabel.font = Constants.BrandFonts.avenirRoman15
        userNameLabel.textAlignment = .left

        userUsername = UILabel()
        viewWithVibrancy.contentView.addSubview(userUsername!)
        userUsername!.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(userNameLabel.snp.left)
            make.top.equalTo(userNameLabel.snp.bottom).offset(8)
        }
        userUsername!.textColor = UIColor.white
        userUsername!.font = Constants.BrandFonts.avenirRoman13
        userUsername!.textAlignment = .left

        profileButton = UIButton(type: .custom)
        __scaling__.addSubview(profileButton)
        profileButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(400 / masterRatio)
            make.height.equalTo(profileImageView.snp.height)
            make.left.equalTo(profileImageView.snp.left)
            make.top.equalTo(profileImageView.snp.top)
        }
        profileButton.addTarget(self, action: #selector(GRMenuView.actionProfileButtonWasPressed(_:)), for: .touchUpInside)


        let separatorView = UIImageView()
        viewWithVibrancy.contentView.addSubview(separatorView)
        separatorView.contentMode = .scaleAspectFit
        separatorView.image = UIImage(named: "separator")
        separatorView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(467 / masterRatio)
            make.height.equalTo(2)
            make.left.equalTo(self.snp.left).offset(32 / masterRatio)
            make.top.equalTo(profileImageView.snp.bottom).offset(72 / masterRatio)
        }

        //Home Button

        let homeButton = UIImageView()
        viewWithVibrancy.contentView.addSubview(homeButton)
        homeButton.image = UIImage(named: "menu_home")
        homeButton.contentMode = .scaleAspectFit
        homeButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.menuIconSize)
            make.left.equalTo(self.snp.left).offset(72 / masterRatio)
            make.top.equalTo(separatorView.snp.bottom).offset(63 / masterRatio)
        }

        let homeButtonLabel = UILabel()
        viewWithVibrancy.contentView.addSubview(homeButtonLabel)
        homeButtonLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(separatorView.snp.bottom).offset(74 / masterRatio)
            make.left.equalTo(homeButton.snp.right).offset(73 / masterRatio)
        }
        homeButtonLabel.text = Constants.AppLabels.MenuLabels.menuHome
        homeButtonLabel.textColor = UIColor.white
        homeButtonLabel.font = Constants.BrandFonts.avenirRoman15
        homeButtonLabel.textAlignment = .left

        let homeActionButton = UIButton()
        viewWithVibrancy.contentView.addSubview(homeActionButton)
        homeActionButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(120 / masterRatio)
            make.width.equalTo(550 / masterRatio)
            make.right.equalTo(0)
            make.centerY.equalTo(homeButton.snp.centerY)
        }
        homeActionButton.addTarget(self, action: #selector(GRMenuView.actionHomeButtonWasTapped(_:)), for: .touchUpInside)


        //List Menu

        let listeButton = UIImageView()
        viewWithVibrancy.contentView.addSubview(listeButton)
        listeButton.image = UIImage(named: "menu_lista")
        listeButton.contentMode = .scaleAspectFit
        listeButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.menuIconSize)
            make.left.equalTo(self.snp.left).offset(72 / masterRatio)
            make.top.equalTo(homeButton.snp.bottom).offset(80 / masterRatio)
        }

        let listeButtonLabel = UILabel()
        viewWithVibrancy.contentView.addSubview(listeButtonLabel)
        listeButtonLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(listeButton.snp.centerY)
            make.left.equalTo(listeButton.snp.right).offset(73 / masterRatio)
        }
        listeButtonLabel.text = Constants.AppLabels.MenuLabels.menuLists
        listeButtonLabel.textColor = UIColor.white
        listeButtonLabel.font = Constants.BrandFonts.avenirRoman15
        listeButtonLabel.textAlignment = .left


        let listeActionButton = UIButton()
        viewWithVibrancy.contentView.addSubview(listeActionButton)
        listeActionButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(120 / masterRatio)
            make.width.equalTo(550 / masterRatio)
            make.right.equalTo(0)
            make.centerY.equalTo(listeButton.snp.centerY)
        }
        listeActionButton.addTarget(self, action: #selector(GRMenuView.actionListeButtonWasTapped(_:)), for: .touchUpInside)


        //Products Menu

        let productsButton = UIImageView()
        viewWithVibrancy.contentView.addSubview(productsButton)
        productsButton.image = UIImage(named: "menu_prodotti")
        productsButton.contentMode = .scaleAspectFit
        productsButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.menuIconSize)
            make.left.equalTo(self.snp.left).offset(72 / masterRatio)
            make.top.equalTo(listeButton.snp.bottom).offset(80 / masterRatio)
        }

        let productsButtonLabel = UILabel()
        viewWithVibrancy.contentView.addSubview(productsButtonLabel)
        productsButtonLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(productsButton.snp.centerY)
            make.left.equalTo(productsButton.snp.right).offset(73 / masterRatio)
        }
        productsButtonLabel.text = Constants.AppLabels.MenuLabels.menuProducts
        productsButtonLabel.textColor = UIColor.white
        productsButtonLabel.font = Constants.BrandFonts.avenirRoman15
        productsButtonLabel.textAlignment = .left


        let productsActionButton = UIButton()
        viewWithVibrancy.contentView.addSubview(productsActionButton)
        productsActionButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(120 / masterRatio)
            make.width.equalTo(550 / masterRatio)
            make.right.equalTo(0)
            make.centerY.equalTo(productsButton.snp.centerY)
        }
        productsActionButton.addTarget(self, action: #selector(GRMenuView.actionProductsButtonWasTapped(_:)), for: .touchUpInside)


        //Users Menu

        let usersButton = UIImageView()
        viewWithVibrancy.contentView.addSubview(usersButton)
        usersButton.image = UIImage(named: "users")
        usersButton.contentMode = .scaleAspectFit
        usersButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.menuIconSize)
            make.left.equalTo(self.snp.left).offset(72 / masterRatio)
            make.top.equalTo(productsButton.snp.bottom).offset(80 / masterRatio)
        }

        let usersButtonLabel = UILabel()
        viewWithVibrancy.contentView.addSubview(usersButtonLabel)
        usersButtonLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(usersButton.snp.centerY)
            make.left.equalTo(usersButton.snp.right).offset(73 / masterRatio)
        }
        usersButtonLabel.text = Constants.AppLabels.MenuLabels.menuUsers
        usersButtonLabel.textColor = UIColor.white
        usersButtonLabel.font = Constants.BrandFonts.avenirRoman15
        usersButtonLabel.textAlignment = .left


        let usersActionButton = UIButton()
        viewWithVibrancy.contentView.addSubview(usersActionButton)
        usersActionButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(120 / masterRatio)
            make.width.equalTo(550 / masterRatio)
            make.right.equalTo(0)
            make.centerY.equalTo(usersButton.snp.centerY)
        }
        usersActionButton.addTarget(self, action: #selector(GRMenuView.actionUsersButtonWasTapped(_:)), for: .touchUpInside)

        // Brands Menu
        
        let brandsButton = UIImageView()
        viewWithVibrancy.contentView.addSubview(brandsButton)
        brandsButton.image = UIImage(named: "brand-icon")
        brandsButton.contentMode = .scaleAspectFit
        brandsButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.UISizes.menuIconSize)
            make.left.equalTo(self.snp.left).offset(72 / masterRatio)
            make.top.equalTo(usersButton.snp.bottom).offset(80 / masterRatio)
        }
        
        let brandsButtonLabel = UILabel()
        viewWithVibrancy.contentView.addSubview(brandsButtonLabel)
        brandsButtonLabel.snp.makeConstraints { make in
            make.centerY.equalTo(brandsButton.snp.centerY)
            make.left.equalTo(brandsButton.snp.right).offset(73 / masterRatio)
        }
        brandsButtonLabel.text = "Brand"
        brandsButtonLabel.textColor = UIColor.white
        brandsButtonLabel.font = Constants.BrandFonts.avenirRoman15
        brandsButtonLabel.textAlignment = .left
        
        
        let brandsActionButton = UIButton()
        viewWithVibrancy.contentView.addSubview(brandsActionButton)
        brandsActionButton.snp.makeConstraints { make in
            make.height.equalTo(120 / masterRatio)
            make.width.equalTo(550 / masterRatio)
            make.right.equalTo(0)
            make.centerY.equalTo(brandsButton.snp.centerY)
        }
        brandsActionButton.addTarget(self, action: #selector(GRMenuView.actionBrandsButtonWasTapped(_:)), for: .touchUpInside)

        //Settings Menu

        let settingsButton = UIImageView()
        viewWithVibrancy.contentView.addSubview(settingsButton)
        settingsButton.image = UIImage(named: "menu_help")
        settingsButton.contentMode = .scaleAspectFit
        settingsButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.menuIconSize)
            make.left.equalTo(self.snp.left).offset(72 / masterRatio)
            make.top.equalTo(brandsButton.snp.bottom).offset(80 / masterRatio)
        }

        let settingsButtonLabel = UILabel()
        viewWithVibrancy.contentView.addSubview(settingsButtonLabel)
        settingsButtonLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(settingsButton.snp.centerY)
            make.left.equalTo(settingsButton.snp.right).offset(73 / masterRatio)
        }
        settingsButtonLabel.text = Constants.AppLabels.MenuLabels.menuSettings
        settingsButtonLabel.textColor = UIColor.white
        settingsButtonLabel.font = Constants.BrandFonts.avenirRoman15
        settingsButtonLabel.textAlignment = .left

        let settingsActionButton = UIButton()
        viewWithVibrancy.contentView.addSubview(settingsActionButton)
        settingsActionButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(120 / masterRatio)
            make.width.equalTo(550 / masterRatio)
            make.right.equalTo(0)
            make.centerY.equalTo(settingsButton.snp.centerY)
        }
        settingsActionButton.addTarget(self, action: #selector(GRMenuView.actionSettingsButtonWasTapped(_:)), for: .touchUpInside)

        // Help Menu

        let helpButton = UIImageView()
        viewWithVibrancy.contentView.addSubview(helpButton)
        helpButton.image = UIImage(named: "menu_help")
        helpButton.contentMode = .scaleAspectFit
        helpButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.menuIconSize)
            make.left.equalTo(self.snp.left).offset(72 / masterRatio)
            make.top.equalTo(settingsButton.snp.bottom).offset(80 / masterRatio)
        }
        helpButton.isHidden = true

        let helpButtonLabel = UILabel()
        viewWithVibrancy.contentView.addSubview(helpButtonLabel)
        helpButtonLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(helpButton.snp.centerY)
            make.left.equalTo(helpButton.snp.right).offset(73 / masterRatio)
        }
        helpButtonLabel.text = Constants.AppLabels.MenuLabels.menuHelp
        helpButtonLabel.textColor = UIColor.white
        helpButtonLabel.font = Constants.BrandFonts.avenirRoman15
        helpButtonLabel.textAlignment = .left
        helpButtonLabel.isHidden = true

        let helpActionButton = UIButton()
        viewWithVibrancy.contentView.addSubview(helpActionButton)
        helpActionButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(120 / masterRatio)
            make.width.equalTo(550 / masterRatio)
            make.right.equalTo(0)
            make.centerY.equalTo(helpButton.snp.centerY)
        }
        helpActionButton.addTarget(self, action: #selector(GRMenuView.actionHelpButtonWasTapped(_:)), for: .touchUpInside)

        helpActionButton.isEnabled = false
        helpActionButton.isHidden = true


        let logoutButton = UIButton(type: .custom)
        viewWithVibrancy.contentView.addSubview(logoutButton)
        var imageAcceddiButton: UIImage!
        imageAcceddiButton = UIImage(named: "trasparent_button")
        logoutButton.setBackgroundImage(imageAcceddiButton, for: UIControlState())
        logoutButton.contentMode = .scaleAspectFit
        
        logoutButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 300 / masterRatio, height: 68 / masterRatio))
            make.bottom.equalTo(viewWithVibrancy.contentView.snp.bottom).offset(-70 / masterRatio)
            make.centerX.equalTo(__scaling__.snp.centerX)
        }

        logoutButton.addTarget(self, action: #selector(GRMenuView.actionLogoutButtonWasPressed(_:)), for: .touchUpInside)


        let accessLabel = UILabel()
        accessLabel.text = Constants.AppLabels.MenuLabels.menuLogout
        accessLabel.font = Constants.BrandFonts.avenirHeavy12
        accessLabel.textColor = UIColor.white
        accessLabel.textAlignment = .center
        logoutButton.addSubview(accessLabel)
        accessLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(logoutButton.snp.centerX)
            make.centerY.equalTo(logoutButton.snp.centerY)
        }

        // Separator

        let separatorViewb = UIImageView()
        viewWithVibrancy.contentView.addSubview(separatorViewb)
        separatorViewb.contentMode = .scaleAspectFit
        separatorViewb.image = UIImage(named: "separator")
        separatorViewb.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(467 / masterRatio)
            make.height.equalTo(2)
            make.left.equalTo(self.snp.left).offset(32 / masterRatio)
            make.bottom.equalTo(logoutButton.snp.top).offset(-70 / masterRatio)
        }

        self.viewsByName = viewsByName
    }

    // Load Profile

    func setNameAndPhotoForUser(_ name: String) {
        userNameLabel.text = name
        userNameLabel.setNeedsDisplay()
    }

    // Delegates

    /**
    Logout Button

    - parameter sender: Logout Button
    */
    func actionLogoutButtonWasPressed(_ sender: UIButton) {
        delegate?.logoutButtonWasPressed!(sender)
    }


    /**
     Will Show Home View Controller

     - parameter sender: 1st View in menu
     */
    func actionHomeButtonWasTapped(_ sender:UIButton) {
        print("home")
       // addTransitionOutAnimation()
        delegate?.navigateToHome!(sender)

    }


    func actionProfileButtonWasPressed(_ sender:UIButton) {
        delegate?.profileButtonWasPressed!(sender)
    }

    func actionListeButtonWasTapped(_ sender: UIButton) {
        delegate?.navigateToMyList!(sender)
    }

    func actionProductsButtonWasTapped(_ sender:UIButton) {
        delegate?.navigateToProducts!(sender)
    }

    func actionUsersButtonWasTapped(_ sender:UIButton) {
        delegate?.navigateToUsers!(sender)
    }

    func actionBrandsButtonWasTapped(_ sender:UIButton) {
        delegate?.navigateToBrands!(sender)
    }
    
    func actionShopButtonWasTapped(_ sender: UIButton) {
        delegate?.navigateToFindShops!(sender)
    }

    func actionSettingsButtonWasTapped(_ sender: UIButton) {
        delegate?.navigateToSettings!(sender)
    }

    func actionHelpButtonWasTapped(_ sender: UIButton) {
        delegate?.helpButtonWasPressed!(sender)
    }

}
