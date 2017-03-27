//
//  GRCredentialsRecoveryView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 10/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class GRCredentialsRecoveryView : UIView {
    
    var viewsByName: [String: UIView]!
    
    var sendButton = UIButton()
    
    var terminiStringButton = UIButton(type: .custom)
    
    var usernameField = UITextField()
    
    // - MARK: Life Cycle
    
    convenience init(icon: UIImage?, title: String?, message: String?) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.setupHierarchy()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }
    
    
    var delegate : GRCredentialsRecoveryProtocol?
    
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
        var viewsByName: [String: UIView] = [:]
        let __scaling__ = UIView()
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        
        let backgroundImg = UIImageView()
        __scaling__.addSubview(backgroundImg)
        backgroundImg.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        var mallImg: UIImage!
        mallImg = UIImage(named: "mall")
        backgroundImg.image = mallImg
        backgroundImg.contentMode = .scaleAspectFit;
        viewsByName["backgroundImg"] = backgroundImg
        
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
        backButton.addTarget(self, action: #selector(GRCredentialsRecoveryView.actionBackButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["backButton"] = backButton
        
        
        let grocerestLogo = UIImageView()
        __scaling__.addSubview(grocerestLogo)
        grocerestLogo.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(285 / masterRatio)
            make.width.equalTo(self)
            make.centerX.equalTo(self.snp.centerX)
        }
        grocerestLogo.image = UIImage(named: "grocerest_logo")
        grocerestLogo.contentMode = .scaleAspectFit
        viewsByName["grocerestLogo"] = grocerestLogo
        
        
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 2
        messageLabel.text = "Inserisci l'username o l' email con cui ti sei\nregistrato, per resettare la tua password."
        messageLabel.font = Constants.BrandFonts.avenirRoman15
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = .center
        __scaling__.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(grocerestLogo.snp.bottom).offset(200 / masterRatio)
        }
        viewsByName["messageLabel"] = messageLabel
        
        let usernameBackground = UIImageView()
        __scaling__.addSubview(usernameBackground)
        usernameBackground.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(messageLabel.snp.bottom).offset(35 / masterRatio)
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
        
        __scaling__.addSubview(usernameField)
        usernameField.placeholder =  "Username o Email"
        usernameField.keyboardAppearance = .dark
        usernameField.keyboardType = .emailAddress
        usernameField.font = Constants.BrandFonts.avenirRoman12
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        usernameField.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(350 / masterRatio)
            make.height.equalTo(usernameBackground.snp.height)
            make.centerY.equalTo(usernameBackground.snp.centerY)
            make.left.equalTo(emailIcon.snp.right).offset(33 / masterRatio)
        }
        
        viewsByName["emailField"] = usernameField

        
        sendButton = UIButton(type: .custom)
        __scaling__.addSubview(sendButton)
        var imageSendButton: UIImage!
        imageSendButton = UIImage(named: "trasparent_button")
        sendButton.setBackgroundImage(imageSendButton, for: UIControlState())
        sendButton.contentMode = .center
        sendButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(usernameField.snp.bottom).offset(60 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        sendButton.addTarget(self, action: #selector(GRCredentialsRecoveryView.actionSendButtonWasPressed), for: .touchUpInside)
        
        
        let sendLabel = UILabel()
        sendLabel.text = "Invia"
        sendLabel.font = Constants.BrandFonts.smallLabelFontA
        sendLabel.textColor = UIColor.white
        sendLabel.textAlignment = .center
        sendButton.addSubview(sendLabel)
        sendLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(sendButton.snp.centerX)
            make.centerY.equalTo(sendButton.snp.centerY)
            
        }
        viewsByName["sendButton"] = sendButton
        
        
        self.viewsByName = viewsByName
    }
    
    // - MARK: delegated
    
    func actionSendButtonWasPressed(_ sender:UIButton) {
        delegate?.sendButtonWasPressed()
    }
    
    func actionBackButtonWasPressed(_ sender:UIButton) {
        delegate?.backButtonWasPressed()
    }
}
