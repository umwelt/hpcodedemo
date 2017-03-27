//
//  GRLoginView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 30/10/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import UIKit
import SnapKit


@IBDesignable
class GRLoginView: UIView {

    var viewsByName: [String: UIView]!

    var loginButton = UIButton()
    var usernameField : UITextField?
    var passwordField : UITextField?

    var terminiStringButton = UIButton(type: .custom)

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


    var delegate : GRLoginViewProtocol?

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
    
    class TextFieldWithExtendedTappableArea: UITextField {
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let relativeFrame = self.bounds
            let hitTestEdgeInsets = UIEdgeInsetsMake(-10 / masterRatio, -10 / masterRatio, -10 / masterRatio, -10 / masterRatio)
            let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
            return hitFrame.contains(point)
        }
    }

    func setupHierarchy() {
        var viewsByName: [String: UIView] = [:]
        let __scaling__ = UIView()
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__


        let mall = UIImageView()
        __scaling__.addSubview(mall)
        mall.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        var imgMall: UIImage!
        imgMall = UIImage(named: "mall")
        mall.image = imgMall
        mall.contentMode = .scaleAspectFit;
        viewsByName["mall"] = mall

        let alpha_cover = UIImageView()
        __scaling__.addSubview(alpha_cover)
        alpha_cover.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        alpha_cover.backgroundColor = UIColor(colorLiteralRed: 0.898, green: 0.204, blue: 0.325, alpha: 0.9)
        viewsByName["alpha_cover"] = alpha_cover


        let backButton = UIButton(type: .custom)
        __scaling__.addSubview(backButton)
        var imageBackButton: UIImage!
        imageBackButton = UIImage(named: "bigBackButton")
        backButton.setBackgroundImage(imageBackButton, for: UIControlState())
        backButton.contentMode = .scaleAspectFit
        backButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(95 / masterRatio)
            make.height.equalTo(51 / masterRatio)
            make.left.equalTo(self.snp.left).offset(16 / masterRatio)
            make.top.equalTo(self.snp.top).offset(69 / masterRatio)
        }
        backButton.addTarget(self, action: #selector(GRLoginView.actionBackButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["backButton"] = backButton


        let logo = UIImageView()
        __scaling__.addSubview(logo)
        logo.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(backButton.snp.bottom).offset(166 / masterRatio)
            make.width.equalTo(self)
            make.centerX.equalTo(self.snp.centerX)
        }
        logo.image = UIImage(named: "grocerest_logo")
        logo.contentMode = .scaleAspectFit
        viewsByName["logo"] = logo


        let usernameBackground = UIImageView()
        __scaling__.addSubview(usernameBackground)
        usernameBackground.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(logo.snp.bottom).offset(200 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        usernameBackground.image = UIImage(named: "white_button")
        usernameBackground.contentMode = .scaleAspectFit

        let emailIcon = UIImageView()
        usernameBackground.addSubview(emailIcon)
        emailIcon.image = UIImage(named: "icon_email")
        emailIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(16)
            make.left.equalTo(usernameBackground.snp.left).offset(34 / masterRatio)
            make.top.equalTo(usernameBackground.snp.top).offset(29 / masterRatio)
        }

        viewsByName["emailBackground"] = usernameBackground


        usernameField = TextFieldWithExtendedTappableArea()
        __scaling__.addSubview(usernameField!)
        usernameField!.placeholder =  "Username o Email"
        usernameField!.keyboardAppearance = .dark
        usernameField!.keyboardType = .emailAddress
        usernameField!.font = Constants.BrandFonts.avenirRoman12
        usernameField!.autocapitalizationType = .none
        usernameField!.autocorrectionType = .no
        usernameField!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(350 / masterRatio)
            make.height.equalTo(usernameBackground.snp.height)
            make.centerY.equalTo(usernameBackground.snp.centerY)
            make.left.equalTo(emailIcon.snp.right).offset(33 / masterRatio)
        }

        viewsByName["emailField"] = usernameField


        let passwordBackground = UIImageView()
        __scaling__.addSubview(passwordBackground)
        passwordBackground.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(usernameBackground.snp.bottom).offset(16 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        passwordBackground.image = UIImage(named: "white_button")
        passwordBackground.contentMode = .scaleAspectFit

        let passwordIcon = UIImageView()
        passwordBackground.addSubview(passwordIcon)
        passwordIcon.image = UIImage(named: "icon_password")
        passwordIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(16)
            make.left.equalTo(passwordBackground.snp.left).offset(34 / masterRatio)
            make.top.equalTo(passwordBackground.snp.top).offset(29 / masterRatio)
        }

        viewsByName["passwordBackground"] = passwordBackground

        passwordField = TextFieldWithExtendedTappableArea()
        __scaling__.addSubview(passwordField!)
        passwordField!.placeholder = "Password"
        passwordField!.isSecureTextEntry = true
        passwordField!.autocorrectionType = .no
        passwordField!.autocapitalizationType = .none
        passwordField!.keyboardType = .asciiCapable
        passwordField!.keyboardAppearance = .dark
        passwordField!.font = Constants.BrandFonts.avenirRoman12
        passwordField!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(350 / masterRatio)
            make.height.equalTo(passwordBackground.snp.height)
            make.left.equalTo(passwordIcon.snp.right).offset(33.00 / masterRatio)
            make.centerY.equalTo(passwordBackground.snp.centerY)
        }
        viewsByName["passwordField"] = passwordField

        loginButton = UIButton(type: .custom)
        __scaling__.addSubview(loginButton)
        var imageAcceddiButton: UIImage!
        imageAcceddiButton = UIImage(named: "trasparent_button")
        loginButton.setBackgroundImage(imageAcceddiButton, for: UIControlState())
        loginButton.contentMode = .center
        loginButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(passwordBackground.snp.bottom).offset(85 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        loginButton.addTarget(self, action: #selector(GRLoginView.actionLoginButtonWasPressed), for: .touchUpInside)


        let accessLabel = UILabel()
        accessLabel.text = Constants.AppLabels.accessLabel
        accessLabel.font = Constants.BrandFonts.smallLabelFontA
        accessLabel.textColor = UIColor.white
        accessLabel.textAlignment = .center
        loginButton.addSubview(accessLabel)
        accessLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(loginButton.snp.centerX)
            make.centerY.equalTo(loginButton.snp.centerY)

        }
        viewsByName["loginButton"] = loginButton


        let forgottenLabel = UILabel()
        forgottenLabel.font = Constants.BrandFonts.smallLabelFontA
        forgottenLabel.textColor = UIColor.white
        forgottenLabel.textAlignment = .center
        __scaling__.addSubview(forgottenLabel)
        forgottenLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(loginButton.snp.bottom).offset(16 / masterRatio)
        }
        let underlineForgottenlabel = NSAttributedString(string: Constants.AppLabels.accessDataForgotten, attributes:
            [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        forgottenLabel.attributedText = underlineForgottenlabel
        viewsByName["forgottenLabel"] = forgottenLabel

        let forgottenButton = UIButton(type: .custom)
        __scaling__.addSubview(forgottenButton)
        forgottenButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(forgottenLabel)
        }
        forgottenButton.addTarget(self, action: #selector(GRLoginView.actionShowForgottenCredentials(_:)), for: .touchUpInside)


        let termsLabel = UILabel()
        termsLabel.font = Constants.BrandFonts.smallLabelFontA
        termsLabel.textColor = UIColor.white
        termsLabel.textAlignment = .center
        __scaling__.addSubview(termsLabel)
        termsLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(loginButton.snp.left).offset(40 / masterRatio)
            make.bottom.equalTo(self.snp.bottom).offset(-59 / masterRatio)
        }

        let underlineTermsLabel = NSAttributedString(string:"Termini servizio ", attributes:
            [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])

        termsLabel.attributedText = underlineTermsLabel

        __scaling__.addSubview(terminiStringButton)
        terminiStringButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(termsLabel)
        }
        terminiStringButton.addTarget(self, action: #selector(GRLoginView.actionShowTOS(_:)), for: .touchUpInside)




        let privacyPolicyLabel = UILabel()
        __scaling__.addSubview(privacyPolicyLabel)
        privacyPolicyLabel.font = Constants.BrandFonts.smallLabelFontA
        privacyPolicyLabel.textColor = UIColor.white
        privacyPolicyLabel.textAlignment = .center
        privacyPolicyLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(termsLabel.snp.right).offset(10 / masterRatio)
            make.bottom.equalTo(self.snp.bottom).offset(-59 / masterRatio)
        }

        let underlineAttriString = NSAttributedString(string:Constants.AppLabels.privacyPolicy, attributes:
            [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])

        privacyPolicyLabel.attributedText = underlineAttriString

        viewsByName["privacyPolicyLabel"] = privacyPolicyLabel



        let privacyStringButton = UIButton(type: .custom)
        __scaling__.addSubview(privacyStringButton)
        privacyStringButton.snp.makeConstraints { (make) in
            make.edges.equalTo(privacyPolicyLabel)

        }

        privacyStringButton.addTarget(self, action: #selector(GRLoginView.actionShowPrivacy(_:)), for: .touchUpInside)


        self.viewsByName = viewsByName
    }

     // - MARK: delegated

    func actionBackButtonWasPressed(_ backButton: UIButton) {
        delegate?.backButtonPressed(backButton)
    }

    func actionLoginButtonWasPressed() {
        delegate?.loginButtonWasPressed()
    }


    func actionShowTOS(_ sender:UIButton){
        delegate?.showTOS(sender)
    }

    func actionShowPrivacy(_ sender:UIButton){
        delegate?.showPrivacy(sender)
    }

    func actionShowForgottenCredentials(_ sender:UIButton) {
       delegate?.showForgottenCredentials(sender)
    }

}
