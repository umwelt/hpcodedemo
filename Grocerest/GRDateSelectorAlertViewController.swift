//
//  GRDateSelectorAlertViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 15/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

import Foundation

class GRDateSelectorAlertViewController: UIViewController {
    
    fileprivate var completionCallback: ((Date?) -> Void)?
    
    var managedView: GRDateSelectorAlertView {
        get {
            return self.view as! GRDateSelectorAlertView
        }
    }
    
    override func loadView() {
        view = GRDateSelectorAlertView()
        managedView.cancelCallback = {
            self.dismiss()
        }
        managedView.confirmCallback = {
            self.dismiss(with: self.managedView.date as Date)
        }
        managedView.unspecifiedCallback = {
            self.dismiss(with: nil)
        }
    }
    
    static func show(title: String, unspecifiedButtonText: String, initialDate: Date? = nil, completion: @escaping (Date?) -> Void) {
        let viewController = GRDateSelectorAlertViewController()
        viewController.managedView.title = title
        viewController.managedView.unspecifiedButtonText = unspecifiedButtonText
        if let date = initialDate {
            viewController.managedView.date = date
        }
        viewController.completionCallback = completion
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        UIApplication.topViewController()!.present(viewController, animated: true, completion: {
            viewController.managedView.showBoxView()
        })
    }
    
    fileprivate func dismiss() {
        self.managedView.hideBoxView(completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    fileprivate func dismiss(with: Date?) {
        self.managedView.hideBoxView(completion: {
            self.dismiss(animated: true, completion: {
                if let date = with {
                    self.completionCallback?(date)
                } else {
                    self.completionCallback?(nil)
                }
            })
        })
    }
    
}
