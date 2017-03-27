//
//  GRSelectorAlertViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 14/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRSelectorAlertViewController: UIViewController {
    
    fileprivate var completionCallback: ((String?) -> Void)?
    
    var managedView: GRSelectorAlertView {
        get {
            return self.view as! GRSelectorAlertView
        }
    }
    
    override func loadView() {
        view = GRSelectorAlertView()
        managedView.cancelCallback = {
            self.dismiss()
        }
        managedView.confirmCallback = {
            self.dismiss(with: self.managedView.pickerValue)
        }
        managedView.unspecifiedCallback = {
            self.dismiss(with: nil)
        }
    }
    
    static func show(title: String, unspecifiedButtonText: String, data: [String], selected: String? = nil, completion: @escaping (String?) -> Void) {
        let viewController = GRSelectorAlertViewController()
        viewController.managedView.title = title
        viewController.managedView.unspecifiedButtonText = unspecifiedButtonText
        viewController.managedView.data = data
        if selected != nil {
            viewController.managedView.selectItem(selected!)
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
    
    fileprivate func dismiss(with: String?) {
        self.managedView.hideBoxView(completion: {
            self.dismiss(animated: true, completion: {
                if let string = with {
                    self.completionCallback?(string)
                } else {
                    self.completionCallback?(nil)
                }
            })
        })
    }
    
}
