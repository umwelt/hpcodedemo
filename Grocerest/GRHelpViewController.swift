//
//  GRHelpViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 01/03/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Google

class GRHelpViewController: UIViewController, UIScrollViewDelegate, ENSideMenuDelegate {
    
    var menuDataDelegate = GRMenuViewController()
    
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        self.managedView
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Simboli View"
        let name = "Pattern~\(self.title!)"
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as [NSObject: AnyObject]?)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate var managedView: GRHelpView {
        return self.view as! GRHelpView
    }
    
    override func loadView() {
        super.loadView()
        view = GRHelpView()
        managedView.delegate = self
    }
    
    func setupViews() {
        
    }
    
    func menuButtonWasPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchButtonWasPressed(_ sender:UIButton) {
        let productSearch = GRProductSearchViewController()
        navigationController?.pushViewController(productSearch, animated: true)
    }
    
    func scannerButtonWasPressed(_ sender: UIButton) {
        let scannerViewController = GRBarcodeScannerViewController()
        self.navigationController?.pushViewController(scannerViewController, animated: false)
    }
    
    
    func closeButtonWasPressed(_ sender:UIButton) {
    }

    
}


