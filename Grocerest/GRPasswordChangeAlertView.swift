//
//  GRPasswordChangeAlertView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class GRPasswordChangeAlertView: UIView, UITextFieldDelegate {
    
    private let scalingView = UIView()
    private let alertBox = UIView()
    private let passwordField = GRPasswordChangeAlertView.createPasswordField()
    private let confirmationField = GRPasswordChangeAlertView.createPasswordField(placeholder: "Conferma password")
    private let cancelButton = GRPasswordChangeAlertView.createButton(text: "Annulla")
    private let confirmButton = GRPasswordChangeAlertView.createButton(text: "Conferma")
    
    var password: String? {
        get {
            return passwordField.text
        }
    }
    
    var confirmationPassword: String? {
        get {
            return confirmationField.text
        }
    }
    
    private var outline = false
    var outlineEmptyFields: Bool {
        get {
            return outline
        }
        set (showOutline) {
            if showOutline {
                if passwordField.text!.isEmpty {
                    passwordField.layer.borderColor = UIColor.grocerestColor().cgColor
                    self.outline = true
                }
                if confirmationField.text!.isEmpty {
                    confirmationField.layer.borderColor = UIColor.grocerestColor().cgColor
                    self.outline = true
                }
            } else {
                passwordField.layer.borderColor = UIColor.grayText().cgColor
                confirmationField.layer.borderColor = UIColor.grayText().cgColor
                self.outline = false
            }
        }
    }
    
    private let errorMessageLabel = UILabel()
    
    var errorMessage: String? {
        get {
            return errorMessageLabel.text
        }
        set (string) {
            if string == nil {
                errorMessageLabel.snp.removeConstraints()
                errorMessageLabel.removeFromSuperview()
                
                alertBox.snp.remakeConstraints { make in
                    make.top.equalTo(-450)
                    make.centerX.equalTo(self.snp.centerX)
                    make.width.equalTo(583 / masterRatio)
                    make.height.equalTo(505 / masterRatio)
                }
                
                confirmButton.snp.remakeConstraints { make in
                    make.top.equalTo(confirmationField.snp.bottom).offset(48 / masterRatio)
                    make.right.equalTo(confirmationField.snp.right)
                    make.width.equalTo(202.25 / masterRatio)
                    make.height.equalTo(74.46 / masterRatio)
                }
                
                cancelButton.snp.remakeConstraints { make in
                    make.top.equalTo(confirmationField.snp.bottom).offset(48 / masterRatio)
                    make.left.equalTo(confirmationField.snp.left)
                    make.width.equalTo(202.25 / masterRatio)
                    make.height.equalTo(74.46 / masterRatio)
                }
            } else {
                errorMessageLabel.font = Constants.BrandFonts.avenirLight15
                errorMessageLabel.textColor = UIColor.grocerestColor()
                errorMessageLabel.text = string
                errorMessageLabel.numberOfLines = 2
                errorMessageLabel.textAlignment = .center
                alertBox.addSubview(errorMessageLabel)
                errorMessageLabel.snp.remakeConstraints { make in
                    make.centerX.equalTo(alertBox.snp.centerX)
                    make.top.equalTo(confirmationField.snp.bottom).offset(48 / masterRatio)
                }
                
                alertBox.snp.remakeConstraints { make in
                    make.top.equalTo(-450)
                    make.centerX.equalTo(self.snp.centerX)
                    make.width.equalTo(583 / masterRatio)
                    if string!.contains("\n") {
                        make.height.equalTo(649 / masterRatio)
                    } else {
                        make.height.equalTo(601 / masterRatio)
                    }
                }
                
                confirmButton.snp.remakeConstraints { make in
                    make.top.equalTo(errorMessageLabel.snp.bottom).offset(48 / masterRatio)
                    make.right.equalTo(confirmationField.snp.right)
                    make.width.equalTo(202.25 / masterRatio)
                    make.height.equalTo(74.46 / masterRatio)
                }
                
                cancelButton.snp.remakeConstraints { make in
                    make.top.equalTo(errorMessageLabel.snp.bottom).offset(48 / masterRatio)
                    make.left.equalTo(confirmationField.snp.left)
                    make.width.equalTo(202.25 / masterRatio)
                    make.height.equalTo(74.46 / masterRatio)
                }
            }
        }
    }
    
    var cancelCallback: (() -> Void)?
    var confirmCallback: (() -> Void)?
    
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
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
    
    // - MARK: Custom
    
    private static func createPasswordField(placeholder: String = "Password") -> UITextField {
        let imageContainer = UIView()
        imageContainer.snp.makeConstraints { make in
            make.width.equalTo(100 / masterRatio)
        }
        
        let imageView = UIImageView(image: UIImage(named: "icon_password"))
        imageView.contentMode = .center
        imageContainer.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(imageContainer.snp.left).offset(40 / masterRatio)
            make.right.equalTo(imageContainer.snp.right).offset(-28 / masterRatio)
            make.width.equalTo(31 / masterRatio)
            make.centerY.equalTo(imageContainer.snp.centerY)
        }
        
        let passwordField = UITextField()
        passwordField.font = Constants.BrandFonts.avenirBook15
        passwordField.textColor = UIColor.grocerestLightGrayColor()
        passwordField.placeholder = placeholder
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        passwordField.layer.borderWidth = 1
        passwordField.layer.cornerRadius = 5
        passwordField.layer.borderColor = UIColor.grayText().cgColor
        passwordField.leftView = imageContainer
        passwordField.leftViewMode = .always
        return passwordField
    }
    
    private static func createButton(text: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.grocerestBlue().cgColor
        button.contentMode = .center
        button.setTitle(text, for: .normal)
        button.setTitleColor(.grocerestBlue(), for: .normal)
        button.titleLabel?.font = Constants.BrandFonts.avenirRoman13
        return button
    }
    
    private func setupHierarchy() {
        scalingView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
        self.addSubview(scalingView)
        scalingView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        let backgroundTappableArea = UIButton(type: .custom)
        scalingView.addSubview(backgroundTappableArea)
        backgroundTappableArea.snp.makeConstraints { make in
            make.edges.equalTo(scalingView)
        }
        backgroundTappableArea.addTarget(self, action: #selector(GRPasswordChangeAlertView.cancelButtonWasPressed(_:)), for: .touchUpInside)
        
        alertBox.clipsToBounds = true
        alertBox.layer.masksToBounds = false
        alertBox.layer.cornerRadius = 5
        alertBox.backgroundColor = UIColor.white
        scalingView.addSubview(alertBox)
        alertBox.snp.makeConstraints { make in
            make.top.equalTo(-450)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(583 / masterRatio)
            make.height.equalTo(505 / masterRatio)
        }
        
        let label = UILabel()
        label.font = Constants.BrandFonts.ubuntuMedium18
        label.text = "Cambia la tua password"
        alertBox.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalTo(alertBox.snp.centerX)
            make.top.equalTo(alertBox.snp.top).offset(47 / masterRatio)
            make.height.equalTo(46 / masterRatio)
        }
        
        alertBox.addSubview(passwordField)
        passwordField.delegate = self
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(59 / masterRatio)
            make.width.equalTo(451 / masterRatio)
            make.height.equalTo(84 / masterRatio)
            make.centerX.equalTo(alertBox.snp.centerX)
        }
        
        alertBox.addSubview(confirmationField)
        confirmationField.delegate = self
        confirmationField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(15 / masterRatio)
            make.width.equalTo(451 / masterRatio)
            make.height.equalTo(84 / masterRatio)
            make.centerX.equalTo(alertBox.snp.centerX)
        }
        
        alertBox.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(confirmationField.snp.bottom).offset(48 / masterRatio)
            make.left.equalTo(confirmationField.snp.left)
            make.width.equalTo(202.25 / masterRatio)
            make.height.equalTo(74.46 / masterRatio)
        }
        cancelButton.addTarget(self, action: #selector(GRPasswordChangeAlertView.cancelButtonWasPressed(_:)), for: .touchUpInside)
        
        alertBox.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(confirmationField.snp.bottom).offset(48 / masterRatio)
            make.right.equalTo(confirmationField.snp.right)
            make.width.equalTo(202.25 / masterRatio)
            make.height.equalTo(74.46 / masterRatio)
        }
        confirmButton.addTarget(self, action: #selector(GRPasswordChangeAlertView.confirmButtonWasPressed(_:)), for: .touchUpInside)
    }
    
    func showBoxView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: UIViewAnimationOptions(), animations: {
            self.alertBox.transform = CGAffineTransform(translationX: 0, y: 1050 / masterRatio)
        }, completion: nil)
    }
    
    func hideBoxView(completion: (() -> Void)?) {
        passwordField.resignFirstResponder()
        confirmationField.resignFirstResponder()
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.alertBox.transform = CGAffineTransform(translationX: 0, y: -450 / masterRatio)
            }, completion: { _ in
                completion?()
            })
    }
    
    func cancelButtonWasPressed(_ sender: UIButton) {
        cancelCallback?()
    }
    
    func confirmButtonWasPressed(_ sender: UIButton) {
        confirmCallback?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        confirmCallback?()
        return true
    }

}
