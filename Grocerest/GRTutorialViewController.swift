//
//  GRTutorialViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 24/03/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RealmSwift


class GRTutorialViewController: UIViewController, UIScrollViewDelegate {
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate var managedView: GRTutorialView {
        return self.view as! GRTutorialView
    }
    
    override func loadView() {
        super.loadView()
        view = GRTutorialView()
        managedView.delegate = self
    }
    
    func setupViews() {
        self.managedView.backView.isPagingEnabled = true
        self.managedView.complimentLabel.text = "Complimenti \(GRUser.sharedInstance.username!)!"
  
    }
    
    
    func skipButtonWasPressed(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


