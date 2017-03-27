//
//  GRAlertViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 22/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation


class GRAlertViewController: UIViewController, AlertViewProtocol  {
    
    weak var dismissDelegate: GRReportViewController!
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDismissableTap()
    }
    
    fileprivate var managedView: GRAlertView {
        return self.view as! GRAlertView
    }
    
    override func loadView() {
        super.loadView()
        view = GRAlertView()
        managedView.delegate = self
    }
    
    fileprivate func setDismissableTap() {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        self.managedView.addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(GRAlertViewController.dismissGRAlertController))
        
    }
    
    @objc fileprivate func dismissGRAlertController() {
       // self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func confirmWasPressed(_ sender:UIButton) {
        self.dismiss(animated: true) { 
            self.dismissDelegate.completedAction()
        }
        
    }
    
    func setAlertMessageText(_ textMessage:String, lines: Int) {
        managedView.formatMessage(textMessage, lines: lines)
    }

}
