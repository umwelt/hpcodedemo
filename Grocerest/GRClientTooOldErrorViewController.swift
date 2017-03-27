//
//  GRClientTooOldErrorViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRClientTooOldErrorViewController : UIViewController, GRClientTooOldErrorViewProtocol, UIGestureRecognizerDelegate {
    
    static var isAlreadyOpen = false
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.setNavigationBarHidden(false, animated: true)
        navigationController?.isNavigationBarHidden = true
        // To disable iOS swipe back functionality
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate var managedView: GRClientTooOldErrorView {
        return self.view as! GRClientTooOldErrorView
    }
    
    override func loadView() {
        view = GRClientTooOldErrorView()
        managedView.delegate = self
    }
    
    // To disable iOS swipe back functionality
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func downloadButtonWasPressed() {
        UIApplication.shared.openURL(URL(string: "itms://itunes.apple.com/us/app/grocerest/id1026692456?mt=8")!)
        GRClientTooOldErrorViewController.isAlreadyOpen = false
    }
    
}
