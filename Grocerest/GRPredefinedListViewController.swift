//
//  GRPredefinedListViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 19/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RealmSwift
import SwiftLoader

class GRPredefinedListViewController: UIViewController, UITextFieldDelegate, GRToolBarProtocol, UITableViewDelegate, UITableViewDataSource, ENSideMenuDelegate, GRUserCategorizedProductsProtocol, GRModalViewControllerDelegate, GRLastIdTappedCacher {
    
    var dataSource: JSON?
    var pageTitle : String?
    var listName : String?
    var listDisplayName: String?
    let realm = try! Realm()
    
    var lastTappedId: String?
    
    
    
    var productsTextLabel = {(value:Int) -> String
        in
        let textLabel = ""
        if value == 1 {
            return "\(value) Elemento"
        } else {
            return "\(value) Elementi"
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedView.navigationToolBar?.isThisBarForDetailViewWithBackButton(true, title: listDisplayName!)
        formatTableView()
        self.sideMenuController()?.sideMenu?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserProductsList() {
            self.setDataSource(self.listName!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        managedView.tableView.tableHeaderView = managedView.labelView
        managedView.tableView.reloadData()
    }
    
    func modalWasDismissed(_ modal: UIViewController) {
        if modal.modalPresentationStyle == .overCurrentContext {
            // since .OverCurrentContext does not trigger 'viewDid/WillAppear'
            // we know we have to refresh manually
            self.viewDidAppear(false)
        }
    }
    
    fileprivate var managedView: GRPredefinedListView {
        return self.view as! GRPredefinedListView
    }
    
    override func loadView() {
        super.loadView()
        view = GRPredefinedListView()
        managedView.delegate = self
        managedView.navigationToolBar?.delegate = self
    }
    
    func formatTableView() {
        
        managedView.tableView.delegate = self
        managedView.tableView.dataSource = self
        
        dataSource = []
        //setDataSource(listName!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataSource?.count)!
    }
    
    enum ProductProperties : String {
        case DisplayName = "display_name"
        case Brand = "brand"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRProductsResultTableViewCell
        cell.populateWith(product: self.dataSource![indexPath.row], from: self)
        return cell
    }
    
    func setDataSource(_ listname: String) {
        GrocerestAPI.getProductsInPredefinedList(GRUser.sharedInstance.id!, listname: listname) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                return
            }
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                
                var rowAnimation = UITableViewRowAnimation.none
                if self.dataSource?.count != data.count {
                    rowAnimation = UITableViewRowAnimation.fade
                }
                
                self.dataSource = data
                let range = NSMakeRange(0, self.managedView.tableView.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)
                
                self.managedView.tableView.reloadSections(sections as IndexSet, with: rowAnimation)
                self.managedView.productsCountLabel?.text = self.productsTextLabel(self.dataSource!.count)
            }
        }
    }
    
    /**
     Toolbar
     
     - parameter menuButton:
     */
    
    func menuButtonWasPressed(_ menuButton: UIButton) {
        toggleSideMenuView()
    }
    
    func grocerestButtonWasPressed(_ grocerestButton: UIButton){
        print("grocerest button")
    }
    
    func scannerButtonWasPressed(_ sender: UIButton){
        let scannerViewController = GRBarcodeScannerViewController()
        self.navigationController?.pushViewController(scannerViewController, animated: false)
        
    }
    
    func searchButtonWasPressed(_ searchButton: UIButton){
        let productSearch = GRProductSearchViewController()
        navigationController?.pushViewController(productSearch, animated: true)
    }
    
    /**
     Open Modal View with options to tag product
     */
    
    func backButtonWasPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func reloadDataSourceForList(_ name: String) {
        self.listDisplayName = name
        self.listName = name
        self.setDataSource(name)
        //let range = NSMakeRange(0, self.tableView!.numberOfSections)
        //let sections = NSIndexSet(indexesInRange: range)
        //self.tableView!.reloadSections(sections, withRowAnimation: .Automatic)
        //self.tableView?.reloadData()
    }
    
    
    
}
