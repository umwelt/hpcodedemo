//
//  GRMessageViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRMessageViewController : UIViewController, GRMessageViewProtocol {
    
    var icon: UIImage?
    var messageTitle: String?
    var message: String?
    var backPops: Int?
    var forgottenLinkVisible: Bool?
    
    var delegate: GRMessageViewProtocol?
    
    convenience init(icon: UIImage?, title: String?, message: String?, backPops: Int?, forgottenLinkVisible: Bool = false) {
        self.init()
        self.icon = icon
        self.messageTitle = title
        self.message = message
        self.backPops = backPops
        self.forgottenLinkVisible = forgottenLinkVisible
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
    
    fileprivate var managedView: GRMessageView {
        return self.view as! GRMessageView
    }
    
    override func loadView() {
        view = GRMessageView(icon: self.icon, title: self.messageTitle, message: self.message, forgottenLinkVisible: self.forgottenLinkVisible!)
        managedView.delegate = self
    }
    
    func okMessageButtonWasPressed() {
        let navigationController = self.navigationController
        
        if self.backPops != nil && self.backPops != 0 {
            var backJumps = self.backPops!
            while backJumps > 1 {
                navigationController?.popViewController(animated: false)
                backJumps -= 1
            }
            navigationController?.popViewController(animated: true)
        } else if self.backPops == nil {
            navigationController?.popViewController(animated: true)
        }
        
        delegate?.okMessageButtonWasPressed()
    }
    
    func forgottenMessageButtonWasPressed() {
        let credentialsRecoveryViewController = GRCredentialsRecoveryViewController()
        credentialsRecoveryViewController.backPopsForSuccess = 3
        self.navigationController?.pushViewController(credentialsRecoveryViewController, animated: true)
    }
    
}
