//
//  GRShoppingListViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 25/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RealmSwift
import SwiftLoader
import Google

/// This Controller handles the actions that user emits when creating, editing, adding/removing elements to a shopping list
class GRShoppingListViewController: UIViewController, GRToolBarProtocol, UIGestureRecognizerDelegate, ENSideMenuDelegate, GRUpdateHomeListProtocol {

    var tableView: UITableView?
    
    var shoppingList : JSON?
    
    var uncheckedProducts : [JSON]?
    var checkedProducts : [JSON]?
    var netDataSource : [JSON]?
    
    var version: Int = 0
    
    var counterProducts = 0
    
    var shoppingListProductIds = NSMutableArray()
    var listDelegate:GRUpdateHomeListProtocol?
    
    var isTransitioning:Bool = false
    var pendingReload:Bool = false
    
    let userDefaults = UserDefaults.standard
    
    var reloadTable = false
    
    var deviceTitle = ""
    
    var myCustomView : UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 10 / masterRatio)
        return imageView
    }()
    
    deinit {
        self.checkedProducts?.removeAll()
        self.uncheckedProducts?.removeAll()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uncheckedProducts = []
        self.checkedProducts = []
        setupViews()
        SwiftLoader.show(animated: true)
        myCustomView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        GrocerestAPI.stopListeningForShoppingListUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateListname(_ name:String) {
        managedView.formatListWith(name)
    }
    
    func updateTable() {
        self.setDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GrocerestAPI.stopListeningForShoppingListUpdates()
        self.sendDataToGoogle()
        
        // start listening for shopping list updates
        if let shoppingListId = self.shoppingList!["_id"].string {
            version = 0
            GrocerestAPI.listenForShoppingListUpdates(shoppingListId) { data in
                SwiftLoader.hide()
                self.applyDataSource(data)
            }
        }
    }
    
    private func sendDataToGoogle () {
        self.title = "A Shopping List"
        let name = "Pattern~\(self.title!)"
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as [NSObject : AnyObject]?)
    }
    
    private lazy var managedView: GRShoppingListView = {
        return self.view as! GRShoppingListView
    }()
    
    override func loadView() {
        view = GRShoppingListView()
        managedView.delegate = self
        managedView.navigationToolBar.delegate = self
    }
    
    func setupViews() {
        managedView.textViewLabel = Constants.AppLabels.aggiungiProdotto
        managedView.formatListWith(shoppingList!["name"].stringValue)
        managedView.numberForCounter = shoppingList!["items"].stringValue
        
        self.sideMenuController()?.sideMenu?.delegate = self
        
        tableView = UITableView(frame: CGRect.zero)
        tableView?.backgroundColor = UIColor.clear
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.bounces = true
        tableView?.register(GRShoppingItemViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.separatorStyle = .none
        managedView.addSubview(tableView!)
        
        // when header scrolls we want to eat up its top paddin
        // so that it does not look broken (http://stackoverflow.com/a/4295687)
        let headerTopPadding:CGFloat = 25.0 / masterRatio
        let dummyView = UIView.init(frame:
            CGRect(
                x: 0, y: 0,
                width: (tableView?.bounds.size.width)!,
                height: headerTopPadding + (10 / masterRatio)
            )
        )
        tableView?.tableHeaderView = dummyView
        tableView?.contentInset = UIEdgeInsetsMake(-headerTopPadding, 0, 0, 0)
        
        tableView?.snp.makeConstraints { make in
            make.width.equalTo(managedView.snp.width)
            make.top.equalTo(managedView.addProductView.snp.bottom)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    func formatShoppingListLabels(_ data:JSON) {
        counterProducts = data["items"].count
        
        //TODO: check that works on shared list
        //managedView.formatListWith(data["name"].stringValue)
        managedView.numberForCounter = String(counterProducts)
        
        if counterProducts > 0 {
            managedView.hideBackViews()
            myCustomView.isHidden = false
        }
    }
    
    // MARK: Buttons
    
    func backButtonWasPressed(_ sender: UIButton) {
        tableView?.isUserInteractionEnabled = false
        listDelegate?.updateListProtocol()
        checkedProducts?.removeAll()
        uncheckedProducts?.removeAll()
        tableView?.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func addProductButtonWasPressed(_ sender: UIButton) {
        let addProductViewController = GRAddProductViewController()
        addProductViewController.shoppingList = shoppingList
        addProductViewController.counterProducts = counterProducts
        addProductViewController.shoppingListProductIds = shoppingListProductIds
        self.navigationController?.pushViewController(addProductViewController, animated: true)
    }
    
    func menuButtonWasPressed(_ menuButton: UIButton) {
        toggleSideMenuView()
    }
    
    func grocerestButtonWasPressed(_ grocerestButton: UIButton) {
        let orderingModalController = GROrderItemsViewController()
        orderingModalController.sortDelegate = self
        orderingModalController.modalTransitionStyle = .crossDissolve
        orderingModalController.modalPresentationStyle = .overCurrentContext
        present(orderingModalController, animated: false, completion: nil)
    }
    
    func optimisticCheckProduct(_ item: JSON, indexPath: IndexPath) {
        for subJson in netDataSource ?? [] {
            //Do something you want
            var preJson = subJson
            if subJson["_id"].string == item["_id"].string {
                preJson["checked"] = true
                preJson["tsUpdated"].intValue = Int(NSDate().timeIntervalSince1970 * 1000)
                self.netDataSource?.removeObject(subJson)
                self.netDataSource?.append(preJson)
            }
        }
        
        animateTablerows(netDataSource!)
    }
    
    func optimisticUnCheckProduct(_ item: JSON, indexPath: IndexPath) {
        for subJson in netDataSource ?? [] {
            //Do something you want
            var preJson = subJson
            if subJson["_id"].string == item["_id"].string {
                preJson["checked"] = false
                preJson["tsUpdated"].intValue = Int(NSDate().timeIntervalSince1970 * 1000)
                self.netDataSource?.removeObject(subJson)
                self.netDataSource?.append(preJson)
            }
        }
        
        animateTablerows(netDataSource!)
    }
    
    /**
     *  GRShoppingItemProtocol
     */
    func checkProductButtonWasPressed(_ sender: UITableViewCell) {
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        
        let indexPath = tableView!.indexPath(for: sender)!
        var product = uncheckedProducts![indexPath.row]
        
        optimisticCheckProduct(uncheckedProducts![indexPath.row], indexPath: indexPath)
        SwiftLoader.show(animated: true)
        
        queue.addOperation {
            if let shopListId = self.shoppingList!["_id"].string {
                GrocerestAPI.updateShoppingListItem(listId: shopListId, itemId: product["_id"].string! , fields: ["checked": true]) { data, error in
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        return
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        SwiftLoader.hide()
    }
    
    func unCheckProductButtonWasPressed(_ sender: UITableViewCell) {
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        
        let indexPath = tableView!.indexPath(for: sender)!
        var product = checkedProducts![indexPath.row]
        
        optimisticUnCheckProduct(checkedProducts![indexPath.row], indexPath: indexPath)
        SwiftLoader.show(animated: true)
        
        queue.addOperation {
            if let shopListId = self.shoppingList!["_id"].string {
                GrocerestAPI.updateShoppingListItem(listId: shopListId, itemId: product["_id"].string!, fields: ["checked": false]) { data, error in
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        return
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        SwiftLoader.hide()
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
    }
    
    func profileButtonWasPressed(_ sender: UIButton) {
        let destViewController = GRProfileViewController()
        sideMenuController()?.setContentViewController(destViewController)
    }
    
    //CURRENT SPRINT
    func moreActionsForListWasPressed(_ sender: UIButton) {
        let menuViewController = GRShoppingListMenuViewController()
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.modalTransitionStyle = .crossDissolve
        
        if let ownerId = self.shoppingList?["owner"]["_id"].string {
            if isDeviceOwner(ownerId) {
                menuViewController.owner = true
            }
        }
        menuViewController.dataDelegate = self
        menuViewController.shoppingList = shoppingList
        self.navigationController?.present(menuViewController, animated: true, completion: nil)
       // presentViewController(menuViewController, animated: true, completion: nil)
    }
    
    func listWasDeleted() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func navigateToEditionView(_ shoppingList:JSON, owner:Bool) {
        let modifyViewController = GRModifyListViewController()
        modifyViewController.modalPresentationStyle = .overCurrentContext
        modifyViewController.list =  shoppingList
        modifyViewController.owner = owner
        self.navigationController?.pushViewController(modifyViewController, animated: true)
    }
    
    func listWasReset() {
        setDataSource()
    }
    
    func sortingOperation(_ filter: String, mode: String, data: [JSON]) -> [JSON] {
        if filter == "tsUpdated" {
            let compare: (Int, Int) -> Bool = (mode == "desc") ? (>) : (<)
            // Filters by insertion order
            return data.sorted { compare($0["tsUpdated"].intValue, $1["tsUpdated"].intValue) }
        } else {
            let compare: (String, String) -> Bool = (mode == "desc") ? (>) : (<)
            if filter == "category" {
                return data.sorted {
                    let ( a, b ) = ( $0[filter].stringValue, $1[filter].stringValue )
                    // Custom products lack of category, so when it's missing or
                    // equal to the empty string we put a default value which
                    // will guarantee that they will be at the bottom/top and
                    // grouped together.
                    return compare(( a.isEmpty ? "1custom" : a ), ( b.isEmpty ? "1custom" : b ))
                }
            } else if filter == "name" {
                return data.sorted { compare($0["name"].stringValue, $1["name"].stringValue) }
            }
        }
        
        print("Couldn't sort shopping list items with unknown filter and/or mode")
        return data // So we return them unchanged
    }
    
    func sortDataSourceWithModel(_ filter: String, mode: String, reload: Bool) {
        let newCheched = sortingOperation(filter, mode: mode, data: checkedProducts!)
        checkedProducts?.removeAll()
        checkedProducts = newCheched
        
        let newUnchecked = sortingOperation(filter, mode: mode, data: uncheckedProducts!)
        uncheckedProducts?.removeAll()
        uncheckedProducts = newUnchecked
    }
    
    // MARK: Alert on errors
    
    private func showValidationAlertWithTitleAndMessage(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func updateListProtocol() {
        updateTable()
    }

}
