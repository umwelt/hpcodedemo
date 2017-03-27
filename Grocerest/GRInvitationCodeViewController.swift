//
//  GRInvitationCodeViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 08/11/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit
import SwiftLoader



class GRInvitationCodeViewController: UIViewController, UITextFieldDelegate{
    
    var continueDelegate =  GRRegistrationViewController()
    var social = false
    var data: JSON?
    var firstTime : Bool?
    var userId = ""
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftLoader.hide()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate var managedView: GRInvitationCodeView {
        return self.view as! GRInvitationCodeView
    }
    
    override func loadView() {
        super.loadView()
        view = GRInvitationCodeView()
        managedView.delegate = self
        managedView.codeTextField.delegate = self
    }
    
    func setupViews() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GRInvitationCodeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    func postInvitationCode() {
        var fields: [String : String] = [:]
        fields["invitationCode"] = managedView.codeTextField.text
        
        GrocerestAPI.postInvitationCodeForUser(userId, fields: fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                
                if data["error"]["code"].stringValue == "E_VALIDATE" {
                    
                    if !GRInvitationCodeInvalidErrorViewController.isAlreadyOpen {
                        GRInvitationCodeInvalidErrorViewController.isAlreadyOpen = true
                        print("Invalid invitation code")
                        SwiftLoader.hide()
                        let messageView = GRInvitationCodeInvalidErrorViewController()
                        UIApplication.topViewController()?.navigationController?.pushViewController(messageView, animated: true)
                    }
                    
                    return
                }
            
            }
            
            self.continueDelegate.getUser(self.userId)

        }
    }
    
    
    func backButtonWasPressed(_ sender:GRShineButton) {
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    func continueButtonWasPressed(_ sender:GRShineButton) {
        self.continueDelegate.getUser(self.userId)
    }
    
    func dismissKeyboard() {
        self.managedView.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.managedView.enableInviteButton()
    }
    
}
