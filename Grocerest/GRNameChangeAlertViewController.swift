//
//  GRNameChangeAlertViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRNameChangeAlertViewController: UIViewController {
    
    fileprivate var completionCallback: ((String?) -> Void)?
    
    var managedView: GRNameChangeAlertView {
        get {
            return self.view as! GRNameChangeAlertView
        }
    }
    
    override func loadView() {
        view = GRNameChangeAlertView()
        managedView.cancelCallback = {
            self.dismiss()
        }
        managedView.confirmCallback = {
            self.managedView.outlineEmptyFields = false
            self.managedView.errorMessage = nil
            
            let name = self.managedView.name 
            if name == nil || name!.trimmingCharacters(in: .whitespaces).isEmpty {
                self.managedView.outlineEmptyFields = true
                self.managedView.errorMessage = "Riempi i campi mancanti"
            } else if !self.isFirstCharALetter(name!) {
                self.managedView.outlineEmptyFields = true
                self.managedView.errorMessage = "Deve iniziare con una lettera"
            } else {
                self.dismiss(withName: name!)
            }
        }
    }
    
    static func show(title: String, name: String, placeholder: String, errorMessage: String, completion: @escaping (String?) -> Void) {
        let viewController = GRNameChangeAlertViewController()
        viewController.managedView.title = title
        viewController.managedView.name = name
        viewController.managedView.placeholder = placeholder
        viewController.completionCallback = completion
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        UIApplication.topViewController()!.present(viewController, animated: true, completion: {
            viewController.managedView.showBoxView()
        })
    }
    
    fileprivate func dismiss(withName: String? = nil) {
        self.managedView.hideBoxView(completion: {
            self.dismiss(animated: true, completion: {
                if let name = withName {
                    self.completionCallback?(name)
                } else {
                    self.completionCallback?(nil)
                }
            })
        })
    }
    
    fileprivate func isFirstCharALetter(_ input: String) -> Bool {
        var chr = "-"
        if (input.characters.count > 0) {
            chr = "\( input[input.characters.index(input.startIndex, offsetBy: 0)] )";
        }
        if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
            return false
        }
        return true
    }
    
}
