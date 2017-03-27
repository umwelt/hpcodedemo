//
//  GRRegistrationView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 31/10/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import UIKit
import SnapKit


@IBDesignable
class GRRegistrationView: UIView {
    
    var viewsByName: [String: UIView]!
    var termsValue = false
    var termsButton = UIButton()
    var newsletterButton = UIButton()
    var displayPasswordButton : UIButton?
    var termsCheckBox : GRCheckbox?
    var newsletterCheckBox : GRCheckbox?
    
    var nameField : UITextField?
    var lastnameField : UITextField?
    var nicknameField : UITextField?
    var emailField : UITextField?
    var passwordField : UITextField?
    
    var passwordBackground : UIImageView?
    var passwordIcon : UIImageView?
    // - MARK Life Cycle
    var terminiStringButton = UIButton(type: .custom)
    var privacyStringButton = UIButton(type: .custom)
    

    
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
    
    var delegate : GRRegistrationViewProtocol?
    
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
            scalingView.center = CGPoint(x:self.bounds.midX, y: self.bounds.midY)
        }
    }
    
    
    class TextFieldWithExtendedTappableArea: UITextField {
        override internal func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let relativeFrame = self.bounds
            let hitTestEdgeInsets = UIEdgeInsetsMake(-30 / masterRatio, -20 / masterRatio, -20 / masterRatio, -20 / masterRatio)
            let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
            return hitFrame.contains(point)
        }
    }
    
    /// Set views hierarchy
    
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
            make.height.equalTo(50 / masterRatio)
            make.left.equalTo(self.snp.left).offset(16 / masterRatio)
            make.top.equalTo(self.snp.top).offset(69 / masterRatio)
        }
        backButton.addTarget(self, action: #selector(GRRegistrationView.actionBackButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["backButton"] = backButton
        
        
        let logo = UIImageView()
        __scaling__.addSubview(logo)
        logo.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(backButton.snp.bottom).offset(100 / masterRatio)
            make.width.equalTo(450.00 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        logo.image = UIImage(named: "grocerest_logo")
        logo.contentMode = .scaleAspectFit
        viewsByName["logo"] = logo
        
        let nameBackground = UIImageView()
        __scaling__.addSubview(nameBackground)
        nameBackground.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(logo.snp.bottom).offset(50 / masterRatio)
            make.left.equalTo(150 / masterRatio)
        }
        nameBackground.image = UIImage(named: "white_button")
        nameBackground.contentMode = .scaleAspectFit
        
        let nameIcon = UIImageView()
        nameBackground.addSubview(nameIcon)
        nameIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(32 / masterRatio)
            make.left.equalTo(nameBackground.snp.left).offset(34 / masterRatio)
            make.top.equalTo(nameBackground.snp.top).offset(25 / masterRatio)
        }
        
        nameIcon.contentMode = .scaleAspectFit
        nameIcon.image = UIImage(named: "icon_registration")
        viewsByName["nomeBackground"] = nameBackground
        
        nameField = TextFieldWithExtendedTappableArea()
        __scaling__.addSubview(nameField!)
        nameField!.placeholder = Constants.AppLabels.namePlaceHolder
        nameField!.keyboardAppearance = .dark
        nameField!.keyboardType = .asciiCapable
        nameField!.autocapitalizationType = .words
        nameField!.autocorrectionType = .no
        nameField!.font = Constants.BrandFonts.avenirRoman12
        nameField!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.uitextFieldSize)
            make.left.equalTo(nameIcon.snp.right).offset(21 / masterRatio)
            make.top.equalTo(nameBackground.snp.top).offset(25 / masterRatio)
            
        }
        viewsByName["nameField"] = nameField
        
        let lastnameBackground = UIImageView()
        __scaling__.addSubview(lastnameBackground)
        lastnameBackground.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(nameBackground.snp.bottom).offset(16 / masterRatio)
            make.left.equalTo(nameBackground.snp.left)
        }
        lastnameBackground.image = UIImage(named: "white_button")
        lastnameBackground.contentMode = .scaleAspectFit
        
        let lastnameIcon = UIImageView()
        lastnameBackground.addSubview(lastnameIcon)
        
        lastnameIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(32 / masterRatio)
            make.left.equalTo(lastnameBackground.snp.left).offset(34 / masterRatio)
            make.top.equalTo(lastnameBackground.snp.top).offset(25 / masterRatio)
        }
        lastnameIcon.contentMode = .scaleAspectFit
        lastnameIcon.image = UIImage(named: "icon_registration")
        
        viewsByName["lastnameBackground"] = lastnameBackground
        
        
        lastnameField = TextFieldWithExtendedTappableArea()
        __scaling__.addSubview(lastnameField!)
        lastnameField!.placeholder = Constants.AppLabels.lastNamePlaceHolder
        lastnameField!.keyboardAppearance = .dark
        lastnameField!.keyboardType = .asciiCapable
        lastnameField!.autocapitalizationType = .words
        lastnameField!.autocorrectionType = .no
        lastnameField!.font = Constants.BrandFonts.avenirRoman12
        lastnameField!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.uitextFieldSize)
            make.left.equalTo(lastnameIcon.snp.right).offset(21 / masterRatio)
            make.top.equalTo(lastnameBackground.snp.top).offset(25 / masterRatio)
            
        }
        viewsByName["lastnameField"] = lastnameField
        
        
        let nicknameBackground = UIImageView()
        __scaling__.addSubview(nicknameBackground)
        nicknameBackground.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(lastnameBackground.snp.bottom).offset(8)
            make.centerX.equalTo(self.snp.centerX)
        }
        nicknameBackground.image = UIImage(named: "white_button")
        nicknameBackground.contentMode = .scaleAspectFit
        
        let nicknameIcon = UIImageView()
        nicknameBackground.addSubview(nicknameIcon)
       
        nicknameIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(32 / masterRatio)
            make.left.equalTo(nicknameBackground.snp.left).offset(34 / masterRatio)
            make.top.equalTo(nicknameBackground.snp.top).offset(25 / masterRatio)
        }
        nicknameIcon.contentMode = .scaleAspectFit
        nicknameIcon.image = UIImage(named: "icon_registration")
        
        viewsByName["nicknameBackground"] = nicknameBackground
        
        
        nicknameField = TextFieldWithExtendedTappableArea()
        __scaling__.addSubview(nicknameField!)
        nicknameField!.placeholder = Constants.AppLabels.nicknamePlaceHolder
        nicknameField!.keyboardAppearance = .dark
        nicknameField!.keyboardType = .asciiCapable
        nicknameField!.autocapitalizationType = .none
        nicknameField!.autocorrectionType = .no
        nicknameField!.font = Constants.BrandFonts.avenirRoman12
        nicknameField!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.uitextFieldSize)
            make.left.equalTo(nicknameIcon.snp.right).offset(21 / masterRatio)
            make.top.equalTo(nicknameBackground.snp.top).offset(25 / masterRatio)
            
        }
        viewsByName["nicknameField"] = nicknameField
        
        
        let emailBackground = UIImageView()
        __scaling__.addSubview(emailBackground)
        emailBackground.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(nicknameBackground.snp.bottom).offset(36 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        emailBackground.image = UIImage(named: "white_button")
        emailBackground.contentMode = .scaleAspectFit
        
        let emailIcon = UIImageView()
        emailBackground.addSubview(emailIcon)
        emailIcon.image = UIImage(named: "icon_email")
        emailIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(32 / masterRatio)
            make.left.equalTo(emailBackground.snp.left).offset(34 / masterRatio)
            make.top.equalTo(emailBackground.snp.top).offset(25 / masterRatio)
        }
        
        viewsByName["emailBackground"] = emailBackground
        
        /// Fix cursor position when editing text
        
        emailField = TextFieldWithExtendedTappableArea()
        __scaling__.addSubview(emailField!)
        emailField!.placeholder = Constants.AppLabels.emailPlaceHolder
        emailField!.keyboardAppearance = .dark
        emailField!.keyboardType = .emailAddress
        emailField!.autocapitalizationType = .none
        emailField!.autocorrectionType = .no
        emailField!.font = Constants.BrandFonts.avenirRoman12
        emailField!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.uitextFieldSize)
            make.left.equalTo(emailIcon.snp.right).offset(21 / masterRatio)
            make.top.equalTo(emailBackground.snp.top).offset(25 / masterRatio)
            
        }
        emailField!.adjustsFontSizeToFitWidth = true
        viewsByName["emailField"] = emailField
        
        
        //
        
        
        passwordBackground = UIImageView()
        __scaling__.addSubview(passwordBackground!)
        passwordBackground!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(emailBackground.snp.bottom).offset(16 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        passwordBackground!.image = UIImage(named: "white_button")
        passwordBackground!.contentMode = .scaleAspectFit
        
        passwordIcon = UIImageView()
        passwordBackground!.addSubview(passwordIcon!)
        
        passwordIcon!.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(32 / masterRatio)
            make.left.equalTo(passwordBackground!.snp.left).offset(34 / masterRatio)
            make.top.equalTo(passwordBackground!.snp.top).offset(25 / masterRatio)
        }
        passwordIcon?.contentMode = .scaleAspectFit
        passwordIcon!.image = UIImage(named: "icon_password")

        viewsByName["passwordBackground"] = passwordBackground
        
        
        passwordField = TextFieldWithExtendedTappableArea()
        __scaling__.addSubview(passwordField!)
        passwordField!.placeholder = Constants.AppLabels.passwordPlaceHolder
        passwordField!.keyboardAppearance = .dark
        passwordField!.keyboardType = .asciiCapable
        passwordField!.autocapitalizationType = .none
        passwordField!.autocorrectionType = .no
        passwordField!.font = Constants.BrandFonts.avenirRoman12
        passwordField!.isSecureTextEntry = true
        passwordField!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width:280 / masterRatio, height:38 / masterRatio))
            make.left.equalTo(passwordIcon!.snp.right).offset(21 / masterRatio)
            make.top.equalTo(passwordBackground!.snp.top).offset(25 / masterRatio)
            
        }
        viewsByName["passwordField"] = passwordField
        
        
        displayPasswordButton = UIButton(type: .custom)
        __scaling__.addSubview(displayPasswordButton!)
        displayPasswordButton!.setBackgroundImage(UIImage(named: "discover_password"), for: UIControlState())
        displayPasswordButton!.contentMode = .center
        displayPasswordButton!.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(48 / masterRatio)
            make.right.equalTo(passwordBackground!.snp.right).offset(-16 / masterRatio)
            make.top.equalTo(passwordBackground!.snp.top).offset(18 / masterRatio)
        }
        displayPasswordButton!.addTarget(self, action: #selector(GRRegistrationView.actionDisplayButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["displayPasswordButton"] = displayPasswordButton
        
        
        let boxHeight: CGFloat = 40 / masterRatio
        let lFrame = CGRect(x: 0, y: 40 / masterRatio, width: 60 / masterRatio, height: boxHeight)
        
        
        termsCheckBox = GRCheckbox(frame: lFrame, title: "Accetto termini servizio e privacy policy" , selected: false)
        //lCheckBox.delegate = self
        __scaling__.addSubview(termsCheckBox!)
        termsCheckBox!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(60 / masterRatio)
            make.height.equalTo(40 / masterRatio)
            make.left.equalTo(nameBackground.snp.left)
            make.top.equalTo(passwordBackground!.snp.bottom).offset(32 / masterRatio)
        }
        termsCheckBox!.addTarget(self, action: #selector(GRRegistrationView.actionNewsletterButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["termsCheckBox"] = termsCheckBox
        
        
        let termsLabel = UILabel()
        
        termsLabel.font = Constants.BrandFonts.verySmallLabelFontA
        termsLabel.textColor = UIColor.white
        termsLabel.textAlignment = .center
        __scaling__.addSubview(termsLabel)
        termsLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(termsCheckBox!.snp.right).offset(20 / masterRatio)
            make.top.equalTo(passwordBackground!.snp.bottom).offset(34 / masterRatio)
            make.height.equalTo(26 / masterRatio)
            
        }

        
        let underlinetermsLabel = NSAttributedString(string:"Accetto termini servizio ", attributes:
            [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        
       termsLabel.attributedText = underlinetermsLabel
        
        
        let eLabel = UILabel()
        eLabel.text = "e"
        eLabel.font = Constants.BrandFonts.verySmallLabelFontA
        eLabel.textColor = UIColor.white
        eLabel.textAlignment = .center
        __scaling__.addSubview(eLabel)
        eLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(termsLabel.snp.right).offset(2 / masterRatio)
            make.top.equalTo(passwordBackground!.snp.bottom).offset(34 / masterRatio)
            make.height.equalTo(26 / masterRatio)
            
        }
        
        
        
        __scaling__.addSubview(terminiStringButton)
        terminiStringButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(termsLabel)
        }
        terminiStringButton.addTarget(self, action: #selector(GRRegistrationView.actionShowTOS(_:)), for: .touchUpInside)
        
        viewsByName["termsLabel"] = termsLabel
        
        let pvyLabel = UILabel()
        pvyLabel.font = Constants.BrandFonts.verySmallLabelFontA
        pvyLabel.textColor = UIColor.white
        pvyLabel.textAlignment = .center
        __scaling__.addSubview(pvyLabel)
        pvyLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(eLabel.snp.right).offset(2 / masterRatio)
            make.centerY.equalTo(termsLabel.snp.centerY)
            make.height.equalTo(26 / masterRatio)
        }
        
        let underlinepvyLabel = NSAttributedString(string:" privacy policy", attributes:
            [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        
        pvyLabel.attributedText = underlinepvyLabel
        
        
        __scaling__.addSubview(privacyStringButton)
        privacyStringButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(pvyLabel)
        }
        privacyStringButton.addTarget(self, action: #selector(GRRegistrationView.actionShowPrivacy(_:)), for: .touchUpInside)
        
        

        
        newsletterCheckBox = GRCheckbox(frame: lFrame, title: Constants.AppLabels.acceptNewsletter, selected: false)
        //lCheckBox.delegate = self
        __scaling__.addSubview(newsletterCheckBox!)
        newsletterCheckBox!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(60 / masterRatio)
            make.height.equalTo(40 / masterRatio)
            make.left.equalTo(nameBackground.snp.left)
            make.top.equalTo(termsCheckBox!.snp.bottom).offset(16 / masterRatio)
        }
        newsletterCheckBox!.addTarget(self, action: #selector(GRRegistrationView.actionNewsletterButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["lCheckBox"] = newsletterCheckBox
        
        let newsletterLabel = UILabel()
        newsletterLabel.numberOfLines = 2
        newsletterLabel.text = Constants.AppLabels.acceptNewsletter
        newsletterLabel.font = Constants.BrandFonts.verySmallLabelFontA
        newsletterLabel.textColor = UIColor.white
        newsletterLabel.textAlignment = .left
        __scaling__.addSubview(newsletterLabel)
        newsletterLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(newsletterCheckBox!.snp.right).offset(20 / masterRatio)
            make.top.equalTo(termsLabel.snp.bottom).offset(34 / masterRatio)
            
        }
        
        viewsByName["termsLabel"] = termsLabel
        
        
        let registrationButton = UIButton(type: .custom)
        __scaling__.addSubview(registrationButton)
        var imgTrasparentButton: UIImage!
        imgTrasparentButton = UIImage(named: "trasparent_button")
        registrationButton.setBackgroundImage(imgTrasparentButton, for:UIControlState())
        registrationButton.contentMode = .center;
        registrationButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(newsletterLabel.snp.bottom).offset(37 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        registrationButton.addTarget(self, action:#selector(GRRegistrationView.actionRegistrationButtonPressed(_:)), for: .touchUpInside)
        
        viewsByName["registrationButton"] = registrationButton
        
        
        let registrationLabel = UILabel()
        registrationLabel.text = Constants.AppLabels.registrationLabel
        registrationLabel.font = Constants.BrandFonts.smallLabelFontA
        registrationLabel.textColor = UIColor.white
        registrationLabel.textAlignment = .center
        registrationButton.addSubview(registrationLabel)
        registrationLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(registrationButton)
        }
        
        
        
        self.viewsByName = viewsByName
        
    }
    
    
    
    func actionBackButtonWasPressed(_ backButton: UIButton) {
        delegate?.backButtonPressed(backButton)
    }
    
    func actionTermButtonWasPressed(_ termsButton: UIButton) {
   
        delegate?.termsButtonWasPressed(termsButton)
    }
    
    func actionNewsletterButtonWasPressed(_ newsletterButton: UIButton) {

        delegate?.newsletterButtonWasPressed(newsletterButton)
    }
    
    func actionRegistrationButtonPressed(_ registrationButton: UIButton) {
        delegate?.registrationButtonWasPressed(registrationButton)
    }
    
    func actionDisplayButtonWasPressed(_ displayPasswordButton: UIButton) {
        delegate?.displayPasswordButtonWasPressed(displayPasswordButton)
    }
    
    func togglePasswordView() {
        if passwordField!.isSecureTextEntry == true {
            passwordField!.isSecureTextEntry = false
        } else {
            passwordField!.isSecureTextEntry = true
        }
        
    }
    
    
    func actionShowTOS(_ sender:UIButton){
        delegate?.showTOS(sender)
    }
    
    func actionShowPrivacy(_ sender:UIButton){
        delegate?.showPrivacy(sender)
    }
    
    
    
    
}
