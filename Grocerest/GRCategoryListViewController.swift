//
//  GRCategoryListViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 01/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwiftLoader
import RealmSwift

/*
Show list of categories after login.
TODO: there is a delay on the first touch, slow response onf the fisrt interaction
*/
class GRCategoryListViewController: UIViewController, GRToolBarProtocol, UITableViewDataSource, UITableViewDelegate, GRCategoryListProtocol, ENSideMenuDelegate {
    
    var dataSource : [Dictionary<String, String>] = []
    var selectedCategories : NSMutableArray = ["Alimentari", "Bevande", "Prodotti per la Casa", "Cura della Persona"]
    // TODO: perchè non semplicemente [Array]?
    var selectedIDS : NSMutableArray = ["564b2d0b6a107b19002b289e", "564b2d1a6a107b19002b289f", "564b39396a107b19002b28a1", "564b39826a107b19002b28a2"]
    var savedCategories = [String]()
    var tableView : UITableView?
    var currentUserViewModel : GRUserViewModel?
    var selectorEnabled = true
    
    var userCategories = [String]()
    
    //Properties
    var state = [Bool?](repeating: nil, count: 10)
    var index: Int?
    
    var onDismissed: (() -> Void)?
    
    var onEdition = false
    
    // DataSource
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.isNavigationBarHidden = false
        
        index = 100
        
        if onEdition == false {
            state = [true, true, true, true, false, false, false, false, false, false]
        }
        
        selectedCategoriesFromProfile()
        
        SwiftLoader.show(animated: true)
       
        
        self.managedView.selectedCategoriesButton.setTitle("Conferma 4 categorie", for: UIControlState())
        
        self.sideMenuController()?.sideMenu?.delegate = self
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate var managedView: GRCategoryListView {
        return self.view as! GRCategoryListView
    }
    
    override func loadView() {
        view = GRCategoryListView()
        managedView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.formatTableView()
        self.tableView?.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.tableView?.setContentOffset((self.tableView?.contentOffset)!, animated: false)
    }
    
    // Format Table
    
    func formatTableView() {
        tableView = UITableView()
        managedView.addSubview(tableView!)
        tableView?.allowsSelection = true
        tableView!.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(82.425)
            make.left.equalTo(0)
            make.height.equalTo(UIScreen.main.bounds.height - 150)
            make.width.equalTo(self.managedView.snp.width)
        }
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.bounces = true
        //tableView?.scrollEnabled = true
        tableView!.allowsMultipleSelection = true
        tableView!.rowHeight = Constants.UISizes.grocerestStandardHeightCell
        tableView!.register(GRCategoryViewCell.self, forCellReuseIdentifier: "cell")
        
        
        self.setDataSource()
        
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count > 0 {
            return dataSource.count
        }
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: GRCategoryViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRCategoryViewCell
        cell.selectionStyle = .none
        
        cell.iconCellView?.image = nil
        cell.selectionCellView?.image = nil
        
        if (cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRCategoryViewCell
        }
        
        cell.iconCellView?.image = UIImage(named: dataSource[indexPath.row]["categoryIcon"]!)
        cell.categoryLabel?.text = dataSource[indexPath.row]["categoryTitle"]!
        
        
        if selectedCategories.contains(dataSource[indexPath.row]["categoryTitle"]!) {
            cell.selectionCellView?.image = UIImage(named: dataSource[indexPath.row]["selectedIcon"]!)
        }
        else {
            cell.selectionCellView?.image = UIImage(named: dataSource[indexPath.row]["selectIcon"]!)
        }
        
        if selectedCategories.count == 1 {
            self.managedView.selectedCategoriesButton.setTitle("Conferma 1 categoria", for: UIControlState())
        } else if selectedCategories.count > 1 {
            self.managedView.selectedCategoriesButton.setTitle("Conferma \(selectedCategories.count) categorie", for: UIControlState())
            if selectedCategories.count == dataSource.count {
                managedView.setButtonStatusLabelTitle("reset")
                selectorEnabled = false
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        managedView.viewsByName["footerView"]?.setNeedsDisplay()
        
        self.index = indexPath.row
        guard let index = self.index else { return }
        
        if state[index] == false {
            if !selectedCategories.contains(dataSource[indexPath.row]["categoryTitle"]!) &&  !selectedIDS.contains(dataSource[indexPath.row]["id"]!){
                if let categoryTitle = dataSource[indexPath.row]["categoryTitle"] {
                    selectedCategories.add(categoryTitle)
                }
                selectedIDS.add(dataSource[indexPath.row]["id"]!)
                state[index] = true
            }
            
            self.managedView.viewsByName["footerView"]!.backgroundColor = UIColor.grocerestBlue()
            self.managedView.selectedCategoriesButton.setTitle("Conferma \(selectedCategories.count) categorie", for: UIControlState())
        } else {
            state[index] = false
            if let categoryTitle = dataSource[indexPath.row]["categoryTitle"] {
                selectedCategories.remove(categoryTitle)
            }
            selectedIDS.remove(dataSource[indexPath.row]["id"]!)
            
            if selectedCategories.count > 0 {
                managedView.setButtonStatusLabelTitle("tutte")
                self.managedView.viewsByName["footerView"]!.backgroundColor = UIColor.grocerestBlue()
                if selectedCategories.count == 1 {
                    self.managedView.selectedCategoriesButton.setTitle("Conferma \(selectedCategories.count) categoria", for: UIControlState())
                } else {
                    if selectedCategories.count == dataSource.count {
                        managedView.setButtonStatusLabelTitle("reset")
                        selectorEnabled = false
                    }
                    self.managedView.selectedCategoriesButton.setTitle("Conferma \(selectedCategories.count) categorie", for: UIControlState())
                }
            } else {
                managedView.setButtonStatusLabelTitle("tutte")
                self.managedView.selectedCategoriesButton.setTitle("Conferma almeno 1 categoria", for: UIControlState())
                self.managedView.viewsByName["footerView"]!.backgroundColor = UIColor.grocerestLightGrayColor()
            }
        }
        
        tableView.reloadData()
    }
    
    
    func setDataSource(){
        
            GrocerestAPI.getCategories { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    if let e = error {
                        DispatchQueue.main.async {
                            SwiftLoader.hide()
                            self.showErrorAlertWithTitleAndMessage("Attenzione", message: e.localizedDescription)
                        }
                    }
                    
                    return
                }
                
                if self.onEdition {
                    self.selectedIDS.removeAllObjects()
                    self.selectedCategories.removeAllObjects()
                    self.state.removeAll()
                }
                
                
                var categoryDictionary = [String: String]()
                if (data["children"].array?.count)! > 0 {
                    for item in data["children"].array! {
                        
                        if item["products"].intValue == 0 {
                            continue
                        }
                        
                        if let name = item["name"].string {
                            categoryDictionary["id"] = item["_id"].string!
                            categoryDictionary["categoryTitle"] = name
                            categoryDictionary["categoryIcon"] = name
                            categoryDictionary["selectIcon"] = ("select_\(name)")
                            categoryDictionary["selectedIcon"] = ("selected_\(name)")
                            self.dataSource.append(categoryDictionary)
                        }
                        
                        if self.userCategories.contains(item["_id"].string!) {
                            self.selectedIDS.add(item["_id"].string!)
                            self.selectedCategories.add(item["name"].string!)
                            self.state.append(true)
                        } else {
                            self.state.append(false)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                        let range = NSMakeRange(0, self.tableView!.numberOfSections)
                        let sections = NSIndexSet(indexesIn: range)
                        self.tableView!.reloadSections(sections as IndexSet, with: .automatic)
                    }
                }
                
            }
        
        
    }
    
    func addAllButtonWasPressed(_ sender: UIButton) {
        if state.contains(where: { $0 == false }) {
            // Will reset
            selectorEnabled = true
        }
        
        if selectorEnabled {
            managedView.setButtonStatusLabelTitle("reset")
            selectedCategories = []
            selectedIDS = []
            for item in dataSource {
                if let categoryName = item["categoryTitle"],
                    let categoryId = item["id"] {
                        selectedCategories.add(categoryName)
                        selectedIDS.add(categoryId)
                }
            }
            state = [true, true, true, true, true, true, true, true, true, true]
            tableView?.reloadData()
            self.managedView.selectedCategoriesButton.setTitle("Conferma \(selectedCategories.count) categorie", for: UIControlState())
            self.managedView.footerView.backgroundColor = UIColor.grocerestBlue()
            selectorEnabled = false
        } else {
            managedView.setButtonStatusLabelTitle("tutte")
            selectedCategories.removeAllObjects()
            selectedIDS.removeAllObjects()
            state = [false, false, false, false, false, false, false, false, false, false]
            tableView?.reloadData()
            self.managedView.selectedCategoriesButton.setNeedsLayout()
            self.managedView.selectedCategoriesButton.setTitle("Conferma almeno 1 categoria", for: UIControlState())
            self.managedView.footerView.backgroundColor = UIColor.grocerestLightGrayColor()
            selectorEnabled = true
            
        }
        
    }
    
    
    func selectedCategoriesFromProfile() {
        GrocerestAPI.getUser(GRUser.sharedInstance.id!) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            for category in data["categories"].arrayValue {
                self.userCategories.append("\(category)")
            }
            
            self.tableView?.reloadData()
        }
    }
    
    
    /// Delegation
    
    func menuButtonWasPressed(_ menuButton: UIButton) {
        toggleSideMenuView()
    }
    
    func grocerestButtonWasPressed(_ grocerestButton: UIButton) {
        print("grocerest")
    }
    
    func scannerButtonWasPressed(_ scannerButton: UIButton) {
        let scannerViewController = GRBarcodeScannerViewController()
        self.navigationController?.pushViewController(scannerViewController, animated: false)
    }
    
    func searchButtonWasPressed(_ searchButton: UIButton){
        let productSearch = GRProductSearchViewController()
        navigationController?.pushViewController(productSearch, animated: true)
    }
    
    func selectButtonWasPressed(_ sender: UIButton) {
        if selectedIDS.count < 1 {
            showErrorAlertWithTitleAndMessage("Attenzione", message: "Devi confermare minimo 1 Categoria")
        } else {
                GrocerestAPI.putUserCategories(GRUser.sharedInstance.id!, categoryIds: self.selectedIDS as AnyObject as! [String]) { data, error in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        return
                    }
                    
                    self.selectedIDS.removeAllObjects()
                    self.selectedCategories.removeAllObjects()
                    self.state.removeAll()
                    
                    self.onDismissed?()
                    self.dismiss(animated: true, completion: nil)
                }
        }
    }
    
    fileprivate func showErrorAlertWithTitleAndMessage(_ title: String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
