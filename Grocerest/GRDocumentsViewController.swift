//
//  GRDocumentsViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/03/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class GRDocumentsViewController: UIViewController,GRToolBarProtocol {
    
    var imageURLString = ""
    var tapGesture = UITapGestureRecognizer()
    var webView: UIWebView!
    var pageTitle = ""
    var document = ""
    override var prefersStatusBarHidden : Bool {
        return false
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
    
    fileprivate var managedView: GRDocumentsView {
        return self.view as! GRDocumentsView
    }
    
    override func loadView() {
        super.loadView()
        view = GRDocumentsView()
        managedView.delegate = self
        managedView.navigationToolBar?.isThisBarForDetailViewWithBackButton(true, title: pageTitle)
        managedView.navigationToolBar?.delegate = self
        managedView.navigationToolBar?.menuButton?.isHidden = true
        managedView.navigationToolBar?.scannerButton?.isHidden = true
        managedView.navigationToolBar?.searchButton?.isHidden = true
    }
    
    func setupViews() {
        webView = UIWebView()
        
        if document == "faq" {
            if let url = URL(string: "http://grocerest.com/static/app/faq.html") {
                webView.loadRequest(URLRequest(url: url))
            }
        } else {
            if let url = Bundle.main.url(forResource: document, withExtension: "html") {
                webView.loadRequest(URLRequest(url: url))
            }
        }
        
        self.view.addSubview(webView)
        
        
        
        webView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo((managedView.navigationToolBar?.snp.bottom)!)
            make.width.equalTo(self.managedView.snp.width)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        }
  
    
    }
    
    func backButtonWasPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    


    

    
}


