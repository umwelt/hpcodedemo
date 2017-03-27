//
//  GRProductsListViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 06/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RealmSwift

///  1st level results
class GRProductsListViewController: UIViewController, UITextFieldDelegate, GRToolBarProtocol, UITableViewDelegate, UITableViewDataSource, ENSideMenuDelegate {
    
    var homeData : JSON?
    var dataSource: JSON?
    var tableView : UITableView?
    var pageTitle : String?
    var categoryId: String?
    let realm = try! Realm()
    var imagesURL : String?
    var catURL = ""
    var navController : UINavigationController?
    private var category: JSON?
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedView.navigationToolBar?.isThisBarForDetailViewWithBackButton(true, title: pageTitle!)
        imagesURL = getCurrentConfiguration()
        catURL = getCategoriesURL()
        setupViews()
        self.sideMenuController()?.sideMenu?.delegate = self
        
        dataSource = []
        setDataSource(categoryId!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView?.setContentOffset((self.tableView?.contentOffset)!, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private var managedView: GRProductsListView {
        return self.view as! GRProductsListView
    }
    
    override func loadView() {
        super.loadView()
        view = GRProductsListView()
        managedView.delegate = self
        managedView.navigationToolBar?.delegate = self
    }
    
    func setupViews() {
        tableView = UITableView(frame: CGRect.zero)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.bounces = true
        tableView?.register(GRSubCategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.backgroundColor = UIColor.clear
        tableView?.separatorStyle = .singleLine
        tableView?.isHidden = false
        tableView?.tableFooterView = UIView(frame: CGRect.zero)
        tableView?.rowHeight = 158 / masterRatio
        managedView.addSubview(tableView!)
        
        tableView?.snp.makeConstraints { make in
            make.width.equalTo(managedView.snp.width)
            make.top.equalTo(150 / masterRatio)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource != nil {
            return (dataSource?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRSubCategoryTableViewCell
        
        cell.productImageView?.image = nil
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        if let name = self.dataSource![indexPath.row]["name"].string {
            cell.productMainLabel?.text = name
        }
        
        DispatchQueue.main.async {
            if let imageName = self.dataSource![indexPath.row]["picture"].string {
                let wholeURL = "\(self.catURL)/\(imageName)"
                cell.productImageView?.hnk_setImageFromURL(URL(string: wholeURL)!)
            }
            
        }
        
        if let prods = self.dataSource![indexPath.row]["products"].int {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let counterLocalized = formatter.string(from: NSNumber(value: prods)) ?? prods.description
            
            cell.productSecondaryLabel?.text = "   \(counterLocalized)   "
            if let categorySlug = category?["slug"].stringValue {
                cell.productSecondaryLabel!.layer.backgroundColor = colorForCategory(categorySlug).cgColor
            }
            cell.productSecondaryLabel?.layer.cornerRadius = 10
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = dataSource![indexPath.row]
        let productSearch = GRProductSearchViewController()
        productSearch.setCategory(category)
        navigationController?.pushViewController(productSearch, animated: true)
    }
    
    
    func setDataSource(_ category: String) {
        DispatchQueue.main.async {
            GrocerestAPI.getCategory(category) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }
                
                self.category = data
                self.dataSource = data["children"]
                self.tableView?.reloadData()
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
    
    func searchButtonWasPressed(_ searchButton: UIButton) {
        if let category = self.category {
            let productSearch = GRProductSearchViewController()
            productSearch.setCategory(category)
            navigationController?.pushViewController(productSearch, animated: true)
        }
    }
    
    func closeButtonWasPressed(_ sender:UIButton) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: false)
        } else {
            dismiss(animated: false, completion: nil)
        }
    }
    
    
    func backButtonWasPressed(_ sender: UIButton) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: false, completion: nil)
        }
    }
    

    /**
     Current configuration
     
     - returns: ProductImagesUrl
     */
    func getCurrentConfiguration() -> String {
        let configuration = realm.objects(GrocerestConfiguration.self)
        return configuration[0].productImagesBaseUrl
    }
    
    func getCategoriesURL() -> String {
        let configuration = realm.objects(GrocerestConfiguration.self)
        return configuration[0].categoryImagesBaseUrl
    }
    
}
