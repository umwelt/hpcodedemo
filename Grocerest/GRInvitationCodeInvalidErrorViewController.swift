//
//  GRAPIErrorMessage.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import FBSDKLoginKit


class GRInvitationCodeInvalidErrorViewController : UIViewController, UIGestureRecognizerDelegate {
    
    var email: String?
    static var isAlreadyOpen = false
    
    convenience init(email: String) {
        self.init()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.isNavigationBarHidden = true
        // To disable iOS swipe back functionality
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate var managedView: GRInvitationCodeInvalidErrorView {
        return self.view as! GRInvitationCodeInvalidErrorView
    }
    
    override func loadView() {
        view = GRInvitationCodeInvalidErrorView(email: self.email)
        managedView.delegate = self
    }
    
    // To disable iOS swipe back functionality
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    func actionButtonWasPressed() {
        GRInvitationCodeInvalidErrorViewController.isAlreadyOpen = false
        self.navigationController?.popViewController(animated: true)
    }
    
}
