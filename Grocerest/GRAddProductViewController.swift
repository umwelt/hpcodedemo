//
//  GRAddProductViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 26/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RealmSwift
import SwiftLoader

/**
 This class handles the search for products to add to a shopping list
 using local and remote source
 Table has also 2 sections,
 Section 0 holds generic products
 Section 1 holds commercial products
 */


/**
 
 There are 2 data sources in this table
 - Grocerest: Sever Data
 - Locale:    Local Data
 
 */

enum SearchSource{
    case grocerest
    case locale
}

class GRAddProductViewController: UIViewController, UITextFieldDelegate, GRAddProductProtocol, SearchCompletionProtocol {
    
    var counterProducts = 0
    var commercialItems: [JSON]?
    
    var dataDelegate : GRListsProtocol? = nil
    var dataSource : JSON = JSON.null
    var darkCover : UIView?
    var disclosureImage : UIImageView?
    
    var genericItems : [JSON]?
    
    var lastProductsLabel = UILabel()
    var lastSearchText = "";
    var localGenericItems = [[String:String]]()
    var localCommercialItems = [[String:String]]()
    
    var previousTerm : String?
    var products = [[String:String]]()
    
    let realm = try! Realm()
    
    var searchingSource = SearchSource.locale
    var searchMode = false
    var selectedProducts = NSMutableArray()
    var shoppingList : JSON?
    var shoppingListProductIds = NSMutableArray()
    
    var tableView: UITableView?
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.getLastVisualized()
        self.managedView.setProductsCounterText("\(counterProducts)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var managedView: GRAddProductView {
        return self.view as! GRAddProductView
    }
    
    override func loadView() {
        super.loadView()
        view = GRAddProductView()
        managedView.delegate = self
        managedView.backgroundColor = UIColor.white
        managedView.searchProduct?.delegate = self
        managedView.searchProduct?.addTarget(self, action: #selector(GRAddProductViewController.textChanged(_:)), for: UIControlEvents.allEditingEvents)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    func setupViews() {
        
        tableView = UITableView(frame: CGRect.zero)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.bounces = true
        tableView?.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        tableView?.register(GROneLineProductViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.backgroundColor = UIColor.clear
        tableView?.separatorStyle = .none
        tableView?.isHidden = false
        tableView?.rowHeight = 100
        tableView?.allowsMultipleSelection = true
        managedView.addSubview(tableView!)
        
        tableView?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(managedView.snp.width)
            make.top.equalTo((managedView.addProductView?.snp.bottom)!)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        
    }
    
    
    
    func postItemToShoopingList(_ fields: [String: String], indexPath: IndexPath) {
        
        SwiftLoader.show(animated: true)
        
        if let listId = shoppingList!["_id"].string {
            GrocerestAPI.postShoppingListItem(listId, fields: fields) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    DispatchQueue.main.async { SwiftLoader.hide() }
                    
                    if data["error"]["code"].stringValue == "E_FORBIDDEN" {
                        self.willRemoveShoppingItemFromList(
                            self.shoppingList!["_id"].stringValue,
                            itemId: data["data"]["_id"].stringValue,
                            productId: data["data"]["product"].stringValue,
                            indexPath: indexPath)
                        
                        DispatchQueue.main.async {
                            if self.counterProducts > 0 {
                                self.updateCounterLabel(false)
                            }
                        }
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.managedView.hideEmptyImage()
                    self.updateCounterLabel(true)
                }
                
                
                switch self.searchingSource {
                case .locale:
                    
                    switch indexPath.section {
                    case 0:
                        self.saveToLocalStorage(self.formatProductToSaveInLocal(self.localGenericItems[indexPath.row], generic: "true"), data: data)
                    case 1:
                        self.saveToLocalStorage(self.formatProductToSaveInLocal(self.localCommercialItems[indexPath.row], generic: "false"), data: data)
                    default:
                        return
                    }
                    
                case .grocerest:
                    
                    switch indexPath.section {
                    case 0:
                        self.dimBackground(indexPath)
                        self.saveToLocalStorage(self.formatProductToSaveInLocalFromSwiftyJSON(data["product"].string!, product: self.genericItems![indexPath.row], generic: "true"), data: data)
                    case 1:
                        self.dimBackground(indexPath)
                        self.saveToLocalStorage(self.formatProductToSaveInLocalFromSwiftyJSON(data["product"].string!, product: self.commercialItems![indexPath.row], generic: "false"), data: data)
                    default:
                        return
                    }
                    
                }
                
            }
        }
        
    }
    
    
    func saveToLocalStorage(_ selectedProduct: GRLastProductVisualized, data: JSON) {
        
        var productLocalId = ""
        
        if let prId = data["product"].string {
            productLocalId = prId
        }
        
        print("saving: \(productLocalId)")
        let predicate = NSPredicate(format: "product == '\(productLocalId)'")
        let savedProduct = self.realm.objects(GRLastProductVisualized.self).filter(predicate)
        
        selectedProduct.name = data["name"].string!
        
        func tsFix(_ data: JSON) -> String {
            if (data["tsUpdated"].int != nil) {
                // TODO: new version of the server uses correct timestmaps (intergers)
                // as soon as transition is complete we need to
                // change app structure to hold timestamps as integers (number of milliseconds since epoch)
                // and avoid this bad hack to convert them back to string
                let date:Date = Date(timeIntervalSince1970: Double(data["tsUpdated"].int!) / 1000.0)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                return formatter.string(from: date)
            } else {
                return data["tsUpdated"].string!
            }
            
        }
        
        selectedProduct.tsUpdated = tsFix(data)
        
        
        if savedProduct.isEmpty || savedProduct[0].counter < 0 {
            selectedProduct.counter = 1
        } else if savedProduct[0].counter > 0  {
            selectedProduct.counter = savedProduct[0].counter + 1
        }
        
        try! self.realm.write({ () -> Void in
            self.realm.add(selectedProduct, update: true)
        })
        
    }
    
    
    func willRemoveShoppingItemFromList(_ listId:String, itemId:String, productId:String, indexPath:IndexPath) {
        SwiftLoader.show(animated: true)
        
        let cell: GROneLineProductViewCell! = tableView!.cellForRow(at: indexPath) as! GROneLineProductViewCell
        
        GrocerestAPI.deleteShoppingListItem(listId: listId, itemId: itemId) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                return
            }
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                if self.shoppingListProductIds.contains(productId) {
                    self.shoppingListProductIds.remove(productId)
                    cell.removeSelectedBackgroundColorForCell()
                    cell.isSelected = false
                }
            }
        }
    }
    
    var limit: Int {
        get {
            return 60
        }
        
    }
    
    var step: Int {
        get {
            return 0
        }
    }
    
    func formatSearchFields(_ query:String) -> [String: Any] {
        return [
            "query": query,
            "generic": true,
            "limit": limit,
            "strict": true,
            "step": step
        ]
    }
    
    
    func starSearch(_ query: String)  {
        
        SwiftLoader.show(animated: true)
        
        if query == "" {
            return
        } else {
            GrocerestAPI.searchProductsForList(GRUser.sharedInstance.id!, fields: self.formatSearchFields(query)) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    DispatchQueue.main.async { SwiftLoader.hide() }
                    return
                }
                
                DispatchQueue.main.async {
                    self.genericItems = []
                    self.commercialItems = []
                    
                    for item in data["items"].arrayValue {
                        if item["generic"].bool == true {
                            self.genericItems?.append(item)
                        } else {
                            self.commercialItems?.append(item)
                        }
                    }
                    
                    if data["items"].count == 0 {
                        self.managedView.showEmptyImage()
                    }
                    
                    SwiftLoader.hide()
                    self.tableView?.reloadData()
                    UIView.animate(withDuration: 0, animations: { self.tableView!.setContentOffset(CGPoint.zero,animated: true) })
                }
            }
        }
    }
    
    
    func getLastVisualized() {
        
        searchingSource = .locale
        let lastProducts = realm.objects(GRLastProductVisualized.self).sorted(byProperty: "counter")
        
        for item in lastProducts {
            
            var product = [String: String]()
            
            if item.generic == "true" {
                product = [:]
                product["name"] = item.name
                product["product"] = item.product
                product["tsUpdated"] = item.tsUpdated
                product["counter"] = "\(item.counter)"
                product["image"] = item.image
                product["category"] = item.category
                product["generic"] = item.generic
                product["brand"] = item.brand
                product["custom"] = item.custom
                product["customImage"] = item.customImage
                
                localGenericItems.append(product)
            } else {
                product = [:]
                product["name"] = item.name
                product["product"] = item.product
                product["tsUpdated"] = item.tsUpdated
                product["counter"] = "\(item.counter)"
                product["image"] = item.image
                product["category"] = item.category
                product["generic"] = item.generic
                product["brand"] = item.brand
                product["custom"] = item.custom
                product["customImage"] = item.customImage
                
                localCommercialItems.append(product)
            }
        }
        tableView?.reloadData()
    }
    
    var fieldsForCustom = { (customName:String, fakeId: String) -> [String: Any] in
        return [
            "name": customName,
            "product": fakeId,
            "generic": false,
            "custom": true
        ]
    }
    
    
    func saveCustomProductToLocal(_ customName:String, fakeId:String) {
        let selectedProduct = GRLastProductVisualized()
        
        selectedProduct.name = customName
        selectedProduct.product = "\(fakeId)"
        selectedProduct.counter = 0
        selectedProduct.generic = "true"
        selectedProduct.custom = "true"
        
        try! self.realm.write({ () -> Void in
            self.realm.add(selectedProduct, update: true)
        })
    }
    
    func addCustomProductWasPressed(_ sender: UIButton) {
        
        let indexPath = IndexPath(row: 1, section: 0)
        
        if previousTerm!.characters.count < 2 {
            showValidationAlertWithTitleAndMessage(Constants.UserMessages.warning, message: Constants.UserMessages.noEmptyProductName)
            return
        }
        
        
        
        let manualId = String.random()
        saveCustomProductToLocal(previousTerm!, fakeId: manualId)
    
        SwiftLoader.show(animated: true)
        
        if let shopListId = shoppingList!["_id"].string {
            GrocerestAPI.postShoppingListItem(shopListId, fields: self.fieldsForCustom(self.previousTerm!, manualId)) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    DispatchQueue.main.async { SwiftLoader.hide() }
                    return
                }
                
                DispatchQueue.main.async {
                    //self.updateCounterLabel(true)
                    SwiftLoader.hide()
                    self.dimBackground(indexPath)
                    self.managedView.hideEmptyImage()
                }
            }
        }
        
    }
    
    
    /**
     Navigation
     */
    
    func backButtonWasPressed(_ sender: UIButton) {
        shoppingListProductIds = []
        self.dismiss(animated: true, completion: nil)
    }
    
    func closeButtonWasPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addProductsWasPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func closeSearchWasPressed () {
        getLastVisualized()
    }
    
    /**
     BackgroundView For Cell
     
     - returns:
     */
    func selectedCellBackgroundView() -> UIView {
        let colorView = UIView()
        colorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        return colorView
    }
    
    
    /**
     Will show custom product button
     */
    func showCustomProductView() {
        
        managedView.customProductView?.isHidden = false
        
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.managedView.customProductView?.snp.remakeConstraints({ (make) -> Void in
                make.top.equalTo((self.managedView.addProductView?.snp.bottom)!)
                make.left.equalTo(0)
                make.width.equalTo(UIScreen.main.bounds.width)
                make.height.equalTo(60)
            })
            
            self.tableView?.snp.remakeConstraints({ (make) -> Void in
                make.width.equalTo(self.managedView.snp.width)
                make.top.equalTo((self.managedView.customProductView?.snp.bottom)!)
                make.left.equalTo(0)
                make.height.equalTo(UIScreen.main.bounds.height - 148)
            })
        }) { (value:Bool) in
            // TODO: better animation
            print("finished")
            
        }
        

    }
    
    
    /**
     Will hide custom product button
     */
    func hideCustomProductView () {
        managedView.customProductView?.isHidden = true
        
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions(), animations: { 
            self.managedView.customProductView?.snp.remakeConstraints({ (make) -> Void in
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.width.equalTo(UIScreen.main.bounds.width)
                make.height.equalTo(60)
            })
            
            
            self.tableView?.snp.remakeConstraints({ (make) -> Void in
                make.width.equalTo(self.managedView.snp.width)
                make.top.equalTo((self.managedView.addProductView?.snp.bottom)!).offset(5)
                make.left.equalTo(0)
                make.height.equalTo(UIScreen.main.bounds.height)
            })

        }) { (value:Bool) in
            // TODO: better animation
            print("finished")
        }

    }
    
    
    /**
     Increases value of counter in top button
     */
    fileprivate func updateCounterLabel(_ increment:Bool) {
        
        if increment {
            self.managedView.animateCounter()
            counterProducts = counterProducts + 1
            self.managedView.productsCounter?.isHidden = false
            self.managedView.setProductsCounterText("\(counterProducts)")
        } else {
            self.managedView.animateCounter()
            counterProducts = counterProducts - 1
            self.managedView.setProductsCounterText("\(counterProducts)")
            if counterProducts <= 0 {
                self.managedView.productsCounter?.isHidden = true
                
            }
        }
    }
    
    /**
     Dims background color while adding new product from search
     */
    fileprivate func dimBackground(_ indexPath:IndexPath) {

        let searchViewController = GRAutocompleteViewController()
        searchViewController.counterProducts = counterProducts + 1
        searchViewController.modalPresentationStyle = .overCurrentContext
        searchViewController.modalTransitionStyle = .crossDissolve
        if let prevTerm = previousTerm {
            searchViewController.lastTerm = prevTerm
        }
        searchViewController.delegate = self
        searchViewController.transitioned = true
        searchViewController.searchFromList = true
        self.resetSearchTextFiels()
        self.hideCustomProductView()
        self.present(searchViewController, animated: false) {
            
        }
        
    }
    
    /**
     Reset textfield.text to 0
     */
    fileprivate func resetSearchTextFiels() {
        self.lastSearchText = self.managedView.searchProduct!.text!;
        self.managedView.searchProduct?.text = nil
        self.managedView.customProductText!.text = nil
        // self.managedView.searchProduct?.becomeFirstResponder();
    }
    
    
    /**
     Shows alert with message
     
     - parameter title:   Title
     - parameter message: Message in alert
     */
    fileprivate func showValidationAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    

    func textChanged(_ sender:UITextField) {
        self.previousTerm = sender.text!
        darkCover?.removeFromSuperview()
        let searchViewController = GRAutocompleteViewController()
        searchViewController.counterProducts = counterProducts
        searchViewController.modalPresentationStyle = .overCurrentContext
        searchViewController.modalTransitionStyle = .crossDissolve
        searchViewController.delegate = self
        searchViewController.queryString = sender.text!
        searchViewController.lastTerm = sender.text!
        searchViewController.searchFromList = true
        self.present(searchViewController, animated: true) {
            
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        starSearch(textField.text!)
        searchingSource = .grocerest
        darkCover?.removeFromSuperview()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        hideCustomProductView()
        textField.text = ""
        textField.becomeFirstResponder()
        managedView.customProductText!.text = ""
        return false
    }
    
    func navigateToShoppingList(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //Delegate func for search
    func startSearchWithQuery(_ query:String, categoryId:String, lastTerm: String) {
        
        if query != "" {
            
            self.managedView.searchProduct?.text = query
            self.previousTerm = query
            self.showCustomProductView()
            self.managedView.customProductText!.text = "'\(query)'"
            self.starSearch(query)
            searchingSource = .grocerest
        } else {

            self.managedView.searchProduct?.text = lastTerm
            self.previousTerm = lastTerm
            //self.starSearch(query)
        }
        
        darkCover?.removeFromSuperview()
    }
    
    /// Cell utilities
    
    
    
    
    func setCellBorderIfSelected(_ productId: String, cell: GROneLineProductViewCell) {
        
        if shoppingListProductIds.contains(productId) {
            cell.setSelectedBackgroundColorForCell()
        } else {
            cell.removeSelectedBackgroundColorForCell()
        }
    }
    
    
    func formatShoppingListItemArray(_ preItem: [String:String], generic: String) -> [String:String] {
        
        
        // This is local storaged Item, the "name" property == "display_name"
        
        var fields = [String:String]()
        fields["quantity"] = ""
        
        if let displayName = preItem["display_name"] {
            fields["name"] = displayName
        } else {
            fields["name"] = preItem["name"]
        }

        fields["product"] = preItem["product"]
        fields["category"] = preItem["category"]
        fields["brand"] = preItem["brand"]
        fields["generic"] = generic
        fields["custom"] = preItem["custom"]
        
        return fields
        
    }
    
    func formatShoppingListItemFromSwiftyJSON(_ preItem: JSON, generic: String) -> [String:String] {
        
        var fields = [String:String]()
        
        // This is a net item, propert should always be display_name
        
        if let name = preItem["display_name"].string {
            fields["name"] = name
        }
        
        if let product = preItem["_id"].string {
            fields["product"] = product
        }
        
        if let category = preItem["category"].string {
            fields["category"] = category
        }
        
        fields["brand"] = productJONSToBrand(data: preItem)
        
        fields["generic"] = "true"
        
        return fields
        
    }
    
    func prepareItemDataListData(_ indexPath:IndexPath) {
        var fields = [String:String]()
        fields["quantity"] = ""
        
        switch searchingSource {
        case .locale:
            switch indexPath.section {
            case 0:
                postItemToShoopingList(formatShoppingListItemArray(localGenericItems[indexPath.row], generic: "false"), indexPath: indexPath)
                return
                
            case 1:
                postItemToShoopingList(formatShoppingListItemArray(localCommercialItems[indexPath.row], generic: "false"), indexPath: indexPath)
                return
                
            default:
                return
            }
        case .grocerest:
            //dimBackground(indexPath)
            switch indexPath.section {
            case 0:
                postItemToShoopingList(formatShoppingListItemFromSwiftyJSON(genericItems![indexPath.row], generic: "true"), indexPath: indexPath)
                return
            case 1:
                postItemToShoopingList(formatShoppingListItemFromSwiftyJSON(commercialItems![indexPath.row], generic: "false"), indexPath: indexPath)
                return
            default:
                return
            }
        }
    }
    
    func formatProductToSaveInLocal(_ product:[String:String], generic: String) -> GRLastProductVisualized {
        
        let selectedProduct = GRLastProductVisualized()
        let defaultValue = ""
        
        
        
        selectedProduct.product = product["product"]!
        selectedProduct.category = product["category"] ?? defaultValue
        selectedProduct.brand = product["brand"] ?? defaultValue
        
        
        
        if  product["customImage"]! != "" {
            selectedProduct.customImage = product["customImage"]!
        }
        
        if product["image"]! != "" {
            selectedProduct.image = product["image"]!
        }
        
        
        if product["custom"] == "true" {
            selectedProduct["custom"] = "true"
        } else  {
            selectedProduct["custom"] = "false"
        }
        
        selectedProduct.generic = generic
        
        return selectedProduct
        
    }
    
    
    func formatProductToSaveInLocalFromSwiftyJSON(_ productId: String, product:JSON, generic: String) -> GRLastProductVisualized {
        
        let selectedProduct = GRLastProductVisualized()
        selectedProduct.product = productId
        
        if generic == "true" {
            if let image = product["images"]["small"].string {
                selectedProduct.customImage = image
            } else if let images = product["category"].string {
                selectedProduct.image = images
            }
        } else {
            if let images = product["images"]["medium"].string {
                selectedProduct.image = String.fullPathForImage(images)
            }
            
        }
        
        if let category = product["category"].string {
            selectedProduct.category = category
        }
        
        selectedProduct.brand = productJONSToBrand(data: product)
        
        selectedProduct.generic = generic
        
        return selectedProduct
        
    }
    
    
    
    
}
