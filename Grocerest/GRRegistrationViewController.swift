//
//  GRRegistrationViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 31/10/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftLoader
import RealmSwift
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON
import Tune


class GRRegistrationViewController: UIViewController, UITextFieldDelegate, GRCheckboxProtocol, GRRegistrationViewProtocol, GREmailNotVerifiedErrorViewProtocol, GRMessageViewProtocol {

    let checkBoxTitles = ["Accetto termini servizio e privacy policy", Constants.AppLabels.acceptNewsletter]
    fileprivate var userData : Dictionary <String, String> = [:]

    var debug = false

    var registerViewModel = GRRegisterUserViewModel()
    var registerData : [String: Any]?
    var socialUser = false
    var dataSource : JSON?
    var productsDataSource: JSON?
    var nickName = ""
    let userDefaults = UserDefaults.standard



    var dictRegister = [String: Any]()

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.isNavigationBarHidden = true

        managedView.newsletterCheckBox?.isSelected = false
        if (registerData != nil) {
            socialUserRegistration()
        }
        managedView.nicknameField?.addTarget(self, action: #selector(GRRegistrationViewController.textChanged(_:)), for: .allEditingEvents)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate var managedView: GRRegistrationView {
        return self.view as! GRRegistrationView
    }

    override func loadView() {

        view = GRRegistrationView()
        managedView.delegate = self
        managedView.nameField?.delegate = self
        managedView.lastnameField?.delegate = self
        managedView.nicknameField?.delegate = self
        managedView.emailField?.delegate = self
        managedView.passwordField?.delegate = self

    }



    func createCheckboxes() {
        let numberOfBoxes = 2
        let boxHeight: CGFloat = 20

        var lFrame = CGRect(x: 0, y: 20, width: self.managedView.frame.size.width, height: boxHeight)
        
        for counter in 1...numberOfBoxes {
            let lCheckBox = GRCheckbox(frame: lFrame, title: checkBoxTitles[counter], selected: false)
            lCheckBox.delegate = self
            lCheckBox.tag = counter
            self.managedView.addSubview(lCheckBox)
            lFrame.origin.y += lFrame.size.height
        }

    }


    // Mark: Delegate

    func backButtonPressed(_ backButton: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func termsButtonWasPressed(_ termsButton: UIButton){
        print(termsButton.state)
    }

    func newsletterButtonWasPressed(_ newsletterButton: UIButton) {
        print(newsletterButton.state)
    }

    func displayPasswordButtonWasPressed(_ displayPasswordButton: UIButton) {
        managedView.togglePasswordView()
    }

    func didSelectCheckbox(_ state: Bool, identifier: Int, title: String) {
        print("chechbox'\(title)' has state \(state)")
    }
    
    
    func isFirstCharALetter(_ input: String) -> Bool {
        var chr = "-"
        if (input.characters.count > 0) {
            chr = "\( input[input.characters.index(input.startIndex, offsetBy: 0)] )";
        }
        if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
            return false
        }
        return true
    }

    var lastPressed: Date?

    func registrationButtonWasPressed(_ registrationButton: UIButton) {
        // Avoid this function is called multiple times on multiple taps too close together in time
        if let last = lastPressed {
            let now = Date()
            // Seconds elapsed since last call
            let timeInterval: Double = now.timeIntervalSince(last)
            if timeInterval < 1 {
                lastPressed = Date()
                return
            }
        }
        lastPressed = Date()

        if managedView.passwordField?.text == "" && !socialUser {
            showErrorMessage("Devi inserire una password")
            return
        } else {
            if let passwordLength = managedView.passwordField?.text?.characters.count,
                   passwordLength < 8 && !socialUser {
                showErrorMessage("La password deve essere composta\nda almeno 8 caratteri")
                return
            }
        }

        if managedView.nameField?.text == "" {
            showErrorMessage("Devi inserire il tuo Nome")
            return
        }
        
        if managedView.lastnameField?.text == "" {
            showErrorMessage("Devi inserire il tuo Cognnome")
            return
        }
        
        if !isFirstCharALetter(managedView.nameField!.text!) {
            showErrorMessage("Il nome deve iniziare con una lettera alfabetica")
            return
        }
        
        if !isFirstCharALetter(managedView.lastnameField!.text!) {
            showErrorMessage("Il cognome deve iniziare con una lettera alfabetica")
            return
        }
        
        if !isFirstCharALetter(managedView.nicknameField!.text!) {
            showErrorMessage("Username non valido")
            return
        }

        if managedView.emailField?.text == "" {
            showErrorMessage("Devi inserire un indirizzo email")
            return
        } else {
            let text = managedView.emailField!.text!
            let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            if (!String.matches(text, pattern: pattern)) {
                showErrorMessage("La e-mail inserita non è valida"
                )
                return
            }
        }

        if managedView.nicknameField?.text == "" {
            showErrorMessage("Devi scegliere un username")
            return
        } else {
            let text = managedView.nicknameField!.text!
            let pattern = "^[a-zA-Z][a-zA-Z0-9_\\.]{2,15}$"

            if (!String.matches(text, pattern: pattern)) {
                showErrorMessage("Lo username deve essere di almeno 3 caratteri,\niniziare con una lettera, e può comprendere\nsia lettere che numeri"
                )
                return
            }
        }

        if socialUser {
            if managedView.termsCheckBox!.state.rawValue.description == "0" {
                dictRegister["termsOfService"] = false
                showErrorMessage("Devi accettare i termini di servizio")
                return
            } else {
                dictRegister["termsOfService"] = true
            }

            // TODO: social user form does not have newsletter stuff
            if managedView.newsletterCheckBox!.state.rawValue.description == "4" {
                dictRegister["newsletter"] = true
            } else if managedView.newsletterCheckBox!.state.rawValue.description == "0" {
                dictRegister["newsletter"] = false
            }

            dictRegister["firstname"] = managedView.nameField!.text!
            dictRegister["lastname"] = managedView.lastnameField!.text!
            dictRegister["email"] = managedView.emailField!.text!
            
            createUser(dictRegister)
            return
        }

        registerViewModel.name = managedView.nameField?.text
        registerViewModel.lastname = managedView.lastnameField?.text
        registerViewModel.username = managedView.nicknameField?.text
        registerViewModel.email = managedView.emailField?.text
        registerViewModel.password = managedView.passwordField?.text

        if managedView.newsletterCheckBox!.state.rawValue.description == "4" {
            registerViewModel.newsletterConsent = true
        } else if managedView.newsletterCheckBox!.state.rawValue.description == "0" {
            registerViewModel.newsletterConsent = false
        }

        if managedView.termsCheckBox!.state.rawValue.description == "4" {
            registerViewModel.tosAcceptance = true
        } else if managedView.termsCheckBox!.state.rawValue.description == "0" {
            registerViewModel.tosAcceptance = false
        }

        do {
            let registeringUser = try registerViewModel.registerUser()
            dictRegister.removeAll()
            dictRegister["firstname"] = registeringUser.name
            dictRegister["lastname"] = registeringUser.lastname
            dictRegister["username"] = registeringUser.username
            dictRegister["email"] = registeringUser.email
            dictRegister["password"] = registeringUser.password
            dictRegister["newsletter"] = registeringUser.newsletterConsent
            dictRegister["termsOfService"] = registeringUser.tosAcceptance
            
            createUser(dictRegister)

        } catch GRRegisterUserViewModel.InputError.inputMissing {
            showErrorMessage("Si prega di compilare tutti i campi!")
        } catch GRRegisterUserViewModel.InputError.inputInvalid {
            showErrorMessage("Errore nel form")
        } catch GRRegisterUserViewModel.InputError.deniedTOS {
            showErrorMessage("Devi accettare i termini di servizio")
        } catch{
            showErrorMessage("Errors unknown")
        }

    }




    func createUser(_ userData: [String: Any]) {
        SwiftLoader.show(title: "Registrazione…", animated: true)
        
        var fields = userData
        if fields["username"] as! String == "" {
            fields["username"] = managedView.nicknameField?.text
        }

        getCurrentConfiguration()

        GrocerestAPI.postUser(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                SwiftLoader.hide()
                
                let serverError = data["error"]["code"].stringValue
                if serverError == "E_UNAUTHORIZED" {
                    GrocerestAPI.userId = nil
                    GrocerestAPI.bearerToken = nil
                    self.navigationController?.popToRootViewController(animated: true)
                } else if serverError == "E_FORBIDDEN" {
                    self.showErrorMessage("Username o Email già usati")
                }
                
                return
            }

            self.userDefaults.setValue(data["bearerToken"].string!, forKey: "bearerToken")
            self.userDefaults.setValue(data["_id"].string!, forKey: "userId")
            self.userDefaults.synchronize()
            
            /*
            print(data.debugDescription)
            {
                "profession" : "",
                "firstname" : "Gianpino2",
                "lastname" : "Gianpino2",
                "bearerToken" : "9d552eea06be5a9f2a73b085e56aff87",
                "emailVerified" : false,
                "hated" : [
                
                ],
                "favourites" : [
                
                ],
                "level" : 1,
                "newsletter" : true,
                "education" : "",
                "totry" : [
                
                ],
                "scanned" : [
                
                ],
                "score" : 15,
                "termsOfService" : true,
                "email" : "gianpino2@dadeb.it",
                "website" : "",
                "family" : "",
                "gender" : "",
                "tsCreated" : 1484944273640,
                "username" : "gianpino2",
                "picture" : "",
                "invitationCode" : null,
                "location" : "",
                "_id" : "AVm9k3DuyqGyggAvt4OQ",
                "categories" : [
                
                ],
                "deactivated" : false,
                "__v" : 1,
                "tsUpdated" : 1484944273640
            } 
             */
            
            TuneManager.PendingRegistration.set(userId: data["_id"].stringValue)
            
            FBSDKAppEvents.logEvent("registration")
            
            self.willSetInvitationCode(data["_id"].stringValue)
            
           // self.getUser(data["_id"].stringValue)
        }
    }

    func getUser(_ userId: String, firstTime: Bool = true) {
        GrocerestAPI.getUser(userId) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                SwiftLoader.hide()
                
                if data["error"]["code"].stringValue == "E_EMAILNOTVERIFIED" {
                    let messageView = GRMessageViewController(icon: UIImage(named: "check_icon"), title: "CONFERMA IL TUO INDIRIZZO EMAIL!", message: "Per poter accedere, conferma il tuo\nindirizzo cliccando sul link che ti\nabbiamo inviato.", backPops: 0)
                    messageView.delegate = self
                    self.navigationController?.pushViewController(messageView, animated: true)
                } else {
                    if !GREmailNotVerifiedErrorViewController.isAlreadyOpen {
                        GREmailNotVerifiedErrorViewController.isAlreadyOpen = true
                        print("Email not verified")
                        SwiftLoader.hide()
                        let messageView = GREmailNotVerifiedErrorViewController(email: self.managedView.emailField!.text!)
                        messageView.delegate = self
                        UIApplication.topViewController()?.navigationController?.pushViewController(messageView, animated: true)
                    }

                }
                
                return
            }

            self.getUserSuccess(data)
        }
    }
    
    func willSetInvitationCode(_ userId: String){
        let invitationCodeController = GRInvitationCodeViewController()
        invitationCodeController.continueDelegate = self
        invitationCodeController.userId = userId
        self.navigationController?.pushViewController(invitationCodeController, animated: true)
    }
 
    func okMessageButtonWasPressed() {
        print("Okay button was pressed")
        SwiftLoader.show(title: "Sincronizzazione…", animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.getUser(self.userDefaults.value(forKey: "userId") as! String, firstTime: false)
        }
    }
    
    func retryMessageButtonWasPressed() {
        print("Retry button was pressed")
        SwiftLoader.show(title: "Sincronizzazione…", animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.getUser(self.userDefaults.value(forKey: "userId") as! String, firstTime: false)
        }
    }
    
    func getUserSuccess(_ data: JSON) {
        saveCurrentUserAfterLogin(data, login: false)
        getUserProductsList()
        
        // Tutorial
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "viewdTutorial")
        userDefaults.synchronize()
        
        let categoryListViewController = GRCategoryListViewController()
        let homeViewController = GRHomeViewController()
        
        categoryListViewController.onDismissed = {
            homeViewController.downloadProducts(reset: true)
        }
        
        self.navigationController?.present(categoryListViewController, animated: true, completion: {
            SwiftLoader.hide()
            self.navigationController?.setViewControllers([homeViewController], animated: false)
        })
    }

    func socialUserRegistration() {
        guard let realm = try? Realm(),
              let fbUser = realm.objects(GRFacebookUser.self).first
            else { return }
        
        managedView.nameField?.text = fbUser.name
        managedView.lastnameField?.text = fbUser.lastname
        managedView.emailField?.text = fbUser.email

        managedView.passwordField?.isHidden = true
        managedView.passwordBackground?.isHidden = true
        managedView.passwordIcon?.isHidden = true
        managedView.displayPasswordButton?.isHidden = true
        managedView.setNeedsDisplay()
        
        dictRegister = [
            "firstname": fbUser.name,
            "lastname": fbUser.lastname,
            "username": managedView.nicknameField?.text ?? "",
            "email": fbUser.email,
            "facebook": ["id": fbUser.id, "accessToken": FBSDKAccessToken.current().tokenString]
        ]
        
        socialUser = true
    }


    // MARK: keyboard

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        self.view.frame.origin.y = 0
        super.touchesBegan(touches, with: event)
    }

    func keyboardWillShow(_ sender: UITextField) {

        self.view.frame.origin.y -= sender.frame.origin.y / 4
    }
    
    func keyboardWillHide(_ sender: UITextField) {
        self.view.frame.origin.y = 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //also login
        view.endEditing(true)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardWillShow(textField)
        print("start")
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        keyboardWillHide(textField)
        textField.resignFirstResponder()
        print("jump")
    }

    fileprivate func showErrorMessage(_ message:String) {
        let messageView = GRMessageViewController(icon: UIImage(named: "error_icon"), title: "ATTENZIONE!", message: message, backPops: 1)
        navigationController?.pushViewController(messageView, animated: true)
    }

    func textChanged(_ sender:UITextField) {
        managedView.nicknameField?.text = sender.text!
    }

    func reformatView() {
        managedView.termsCheckBox!.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(30)
            make.height.equalTo(20)
            make.left.equalTo(managedView.emailField!.snp.left)
            make.top.equalTo(managedView.emailField!.snp.bottom).offset(16)
        }
    }

    func showTOS(_ sender: UIButton) {
        let documentsViewController = GRDocumentsViewController()
        documentsViewController.pageTitle = "Termini di Servizio"
        documentsViewController.document = "tos"
        self.navigationController?.pushViewController(documentsViewController, animated: true)
    }

    func showPrivacy(_ sender: UIButton) {
        let documentsViewController = GRDocumentsViewController()
        documentsViewController.pageTitle = "Privacy Policy"
        documentsViewController.document = "privacy"
        self.navigationController?.pushViewController(documentsViewController, animated: true)
    }
    
    func showAlertWithMessage(_ message:String) {
        let alert = UIAlertController(title: "DeepLink", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
