//
//  GRNetworkErrorViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 30/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SwiftLoader

class GRNetworkErrorViewController : UIViewController {
    
    static private var instance = GRNetworkErrorViewController()
    
    static var isVisible: Bool {
        get {
            let top = UIApplication.topViewController() as? GRNetworkErrorViewController
            return top != nil
        }
    }
    
    private var managedView: GRNetworkErrorView {
        return self.view as! GRNetworkErrorView
    }
    
    override func loadView() {
        super.loadView()
        view = GRNetworkErrorView()
        managedView.onTap = {
            self.dismiss(animated: true)
        }
    }
    
    class func show() {
        SwiftLoader.hide() // We close any loader that might be open
        if isVisible { return }
        
        let errorView = GRNetworkErrorViewController()
        errorView.modalPresentationStyle = .overCurrentContext
        errorView.modalTransitionStyle = .crossDissolve
        UIApplication.topViewController()?.present(errorView, animated: true)
    }
    
}
