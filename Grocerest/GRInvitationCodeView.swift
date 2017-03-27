//
//  GRInvitationCodeView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 08/11/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

class GRInvitationCodeView: UIView {
    
    fileprivate lazy var backgroundImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "mall"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var alpha_cover : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(colorLiteralRed: 0.898, green: 0.204, blue: 0.325, alpha: 0.9)
        return imageView
    }()
    
    
    fileprivate lazy var backButton: GRShineButton = {
        let button = GRShineButton()
        let imageBackButton = UIImage(named: "bigBackButton")
        button.setBackgroundImage(imageBackButton, for: UIControlState())
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    fileprivate lazy var logo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "grocerest_logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.text = "Hai un codice invito?"
        label.font = UIFont.ubuntuRegular(42.00)
        label.textColor = UIColor(hexString: "#ffffff")
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.text = "Inseriscilo nel campo sottostante per guadagnare più punti Reputation!"
        label.font = UIFont.avenirBook(32.00)
        label.textColor = UIColor(hexString: "#ffffff")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    fileprivate lazy var complexView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10 / masterRatio
        view.layer.borderColor = UIColor.white.cgColor
        
        return view
    }()
    
    fileprivate lazy var iconImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "inviteCodeIcon"))
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    
    lazy var codeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Codice invito"
        return textField
    }()
  
    fileprivate lazy var inviteButton: GRShineButton = {
        let button = GRShineButton()
        button.setTitle("Usa il codice", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.avenirRoman(26)
        button.isEnabled = false
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10 / masterRatio
        return button
    }()
    
    
    fileprivate lazy var continueButton: GRShineButton = {
        let button = GRShineButton()
        button.setTitle("Continua senza codice", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.avenirRoman(26)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10 / masterRatio
        return button
    }()
    
    fileprivate lazy var warningIcon : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "warning"))
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    fileprivate lazy var attentionLabel: UILabel = {
        let label = UILabel()
        label.text = "ATTENZIONE!"
        label.font = UIFont.avenirRoman(32)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Il codice invito non appartiene ad alcun utente o è scaduto."
        label.numberOfLines = 0
        label.font = UIFont.avenirRoman(32)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var okButton: GRShineButton = {
        let button = GRShineButton()
        button.setTitle("Ok", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10 / masterRatio
        return button
    }()
    
    
    var errorLabelText: String {
        get {
            return errorLabel.text!
        }
        set(newText) {
            errorLabel.text = newText
        }
    }
    
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
    
    var delegate = GRInvitationCodeViewController()
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupHierarchy() {
        
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
        
        backgroundImageView.addSubview(alpha_cover)
        alpha_cover.snp.makeConstraints { (make) in
            make.edges.equalTo(backgroundImageView.snp.edges)
        }
        
        
        addSubview(backButton)
        backButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(95 / masterRatio)
            make.height.equalTo(50 / masterRatio)
            make.left.equalTo(self.snp.left).offset(16 / masterRatio)
            make.top.equalTo(self.snp.top).offset(69 / masterRatio)
        }
        backButton.addTarget(delegate, action: Selector("backButtonWasPressed:"), for: .touchUpInside)
        // it makes no sense to go back to registration because the user is already registered and this can't be un-done
        backButton.isHidden = true
        
        addSubview(logo)
        logo.snp.makeConstraints { (make) in
            make.width.equalTo(451 / masterRatio)
            make.height.equalTo(88  / masterRatio)
            make.left.equalTo(150 / masterRatio)
            make.top.equalTo(228 / masterRatio)
        }
        
        
        addSubview(firstLabel)
        firstLabel.snp.makeConstraints { (make) in
            make.width.equalTo(481 / masterRatio)
            make.height.equalTo(39 / masterRatio)
            make.top.equalTo(logo.snp.bottom).offset(173 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        addSubview(secondLabel)
        secondLabel.snp.makeConstraints { (make) in
            make.width.equalTo(481 / masterRatio)
            make.height.equalTo(70 / masterRatio)
            make.top.equalTo(firstLabel.snp.bottom).offset(25 / masterRatio)
            make.centerX.equalTo(firstLabel.snp.centerX)
        }
        
        addSubview(complexView)
        complexView.snp.makeConstraints { (make) in
            make.width.equalTo(450 / masterRatio)
            make.height.equalTo(83 / masterRatio)
            make.top.equalTo(secondLabel.snp.bottom).offset(61 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        complexView.addSubview(iconImage)
        iconImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(60 / masterRatio)
            make.left.equalTo(complexView.snp.left).offset(21 / masterRatio)
            make.centerY.equalTo(complexView.snp.centerY)
        }
        
        complexView.addSubview(codeTextField)
        codeTextField.snp.makeConstraints { (make) in
            make.width.equalTo(335 / masterRatio)
            make.height.equalTo(45 / masterRatio)
            make.left.equalTo(iconImage.snp.right).offset(19 / masterRatio)
            make.centerY.equalTo(complexView.snp.centerY)
        }
        
        addSubview(inviteButton)
        inviteButton.snp.makeConstraints { (make) in
            make.size.equalTo(complexView.snp.size)
            make.centerX.equalTo(complexView.snp.centerX)
            make.top.equalTo(complexView.snp.bottom).offset(33 / masterRatio)
        }
        inviteButton.addTarget(delegate, action: #selector(GRInvitationCodeViewController.postInvitationCode), for: .touchUpInside)
        
        addSubview(continueButton)
        continueButton.snp.makeConstraints { (make) in
            make.size.equalTo(complexView.snp.size)
            make.centerX.equalTo(complexView.snp.centerX)
            make.top.equalTo(inviteButton.snp.bottom).offset(170 / masterRatio)
        }
        continueButton.addTarget(delegate, action: #selector(GRInvitationCodeViewController.continueButtonWasPressed(_:)), for: .touchUpInside)
    
    }
    
    
    
    func hideViewsOnError(_ errorMessage: String) {
        firstLabel.removeFromSuperview()
        secondLabel.removeFromSuperview()
        complexView.removeFromSuperview()
        inviteButton.removeFromSuperview()
        continueButton.removeFromSuperview()
        
        addSubview(warningIcon)
        warningIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(76)
            make.top.equalTo(logo.snp.bottom).offset(174 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        addSubview(attentionLabel)
        attentionLabel.snp.makeConstraints { (make) in
            make.width.equalTo(577 / masterRatio)
            make.height.equalTo(80 / masterRatio)
            make.top.equalTo(warningIcon.snp.bottom).offset(7.5)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints { (make) in
            make.width.equalTo(473 / masterRatio)
            make.height.equalTo(86 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(attentionLabel.snp.bottom).offset(14.75)
        }
        errorLabelText = errorMessage
        
        addSubview(okButton)
        okButton.snp.makeConstraints { (make) in
            make.width.equalTo(454 / masterRatio)
            make.height.equalTo(84 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(errorLabel.snp.bottom).offset(94 / masterRatio)
        }
        okButton.addTarget(delegate, action: #selector(GRInvitationCodeViewController.continueButtonWasPressed(_:)), for: .touchUpInside)
    }
    
    func enableInviteButton()  {
        inviteButton.isEnabled = true
    }
    
}

