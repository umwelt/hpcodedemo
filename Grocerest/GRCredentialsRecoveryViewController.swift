//
//  GRCredentialsRecoveryViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 10/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import SwiftLoader

class GRCredentialsRecoveryViewController : UIViewController, GRCredentialsRecoveryProtocol, UITextFieldDelegate {
    
    var icon: UIImage?
    var messageTitle: String?
    var message: String?
    var backPopsForSuccess = 2
    
    convenience init(icon: UIImage?, title: String?, message: String?) {
        self.init()
        self.icon = icon
        self.messageTitle = title
        self.message = message
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.setNavigationBarHidden(false, animated: true)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate var managedView: GRCredentialsRecoveryView {
        return self.view as! GRCredentialsRecoveryView
    }
    
    override func loadView() {
        view = GRCredentialsRecoveryView(icon: self.icon, title: self.messageTitle, message: self.message)
        managedView.delegate = self
        managedView.usernameField.delegate = self
    }
    
    func backButtonWasPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func sendButtonWasPressed() {
        
        guard managedView.usernameField.text != nil && managedView.usernameField.text!.characters.count > 0 else {
            let messageView = GRMessageViewController(icon: UIImage(named: "error_icon"), title: "ATTENZIONE!", message: "E' necessario inserire un indirizzo\nemail valido.", backPops: 1)
            self.navigationController?.pushViewController(messageView, animated: true)
            return
        }
        
        SwiftLoader.show(title: "Recupero password…", animated: true)
        
        var fields: [String: String]
        
        if managedView.usernameField.text!.range(of: "@") != nil {
            fields = ["email": managedView.usernameField.text!]
        } else {
            fields = ["username": managedView.usernameField.text!]
        }
        
        GrocerestAPI.resetPassword(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                if let e = error {
                    let messageView = GRMessageViewController(icon: UIImage(named: "error_icon"), title: "ATTENZIONE!", message: e.localizedDescription, backPops: 1)
                    self.navigationController?.pushViewController(messageView, animated: true)
                } else {
                    let message = (data["error"]["code"].stringValue == "E_NOT_FOUND") ?
                                  "L’indirizzo inserito non è associato\nad un account di Grocerest.":
                                  data["error"]["message"].stringValue
                    let messageView = GRMessageViewController(icon: UIImage(named: "error_icon"), title: "ATTENZIONE!", message: message, backPops: 1)
                    self.navigationController?.pushViewController(messageView, animated: true)
                }
                
                SwiftLoader.hide()
                return
            }
            
            let messageView = GRMessageViewController(icon: UIImage(named: "check_icon"), title: "CONTROLLA LA TUA MAIL!", message: "Ti abbiamo inviato un link\nper resettare la tua password.", backPops: self.backPopsForSuccess)
            self.navigationController?.pushViewController(messageView, animated: true)
            SwiftLoader.hide()
        }
    }
    
    // - MARK: Keyboard
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonWasPressed()
        view.endEditing(true)
        return true
    }

}
