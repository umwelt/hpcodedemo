//
//  GRPasswordChangeAlert.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRPasswordChangeAlertViewController: UIViewController {
    
    fileprivate var completionCallback: ((String?) -> Void)?
    
    var managedView: GRPasswordChangeAlertView {
        get {
            return self.view as! GRPasswordChangeAlertView
        }
    }
    
    override func loadView() {
        view = GRPasswordChangeAlertView()
        managedView.cancelCallback = {
            self.dismiss()
        }
        managedView.confirmCallback = {
            self.managedView.outlineEmptyFields = false
            self.managedView.errorMessage = nil
            let password = self.managedView.password
            let confirmation = self.managedView.confirmationPassword
            if password == nil || password!.isEmpty ||
               confirmation == nil || confirmation!.isEmpty {
                self.managedView.outlineEmptyFields = true
                self.managedView.errorMessage = "Riempi i campi mancanti"
            } else if password!.characters.count < 8 {
                self.managedView.errorMessage = "La password deve essere composta\nda almeno 8 caratteri"
            } else if password != confirmation {
                self.managedView.errorMessage = "Le password non coincidono"
            } else {
                self.dismiss(withPassword: password!)
            }
        }
    }
    
    static func show(_ completion: @escaping (String?) -> Void) {
        let viewController = GRPasswordChangeAlertViewController()
        viewController.completionCallback = completion
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        UIApplication.topViewController()!.present(viewController, animated: true, completion: {
            viewController.managedView.showBoxView()
        })
    }
    
    fileprivate func dismiss(withPassword: String? = nil) {
        self.managedView.hideBoxView(completion: {
            self.dismiss(animated: true, completion: {
                if let password = withPassword {
                    self.completionCallback?(password)
                } else {
                    self.completionCallback?(nil)
                }
            })
        })
    }
    
}
