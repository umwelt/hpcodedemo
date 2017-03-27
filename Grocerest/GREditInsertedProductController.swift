//
//  GREditInsertedProductController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 21/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftLoader


enum ProductType {
    case commercial
    case generic
    case custom
}

class GREditInsertedProductController: UIViewController, UITextFieldDelegate {
    
    var delegate : GRShoppingListViewController?
    var product : JSON?
    var remoteProduct : JSON?
    var shoppingList: JSON?
    var productType = ProductType.commercial
    
    var productId : String {
        get {
            if let prodId =  product!["product"].string {
                return prodId
            }
            return ""
        }
    }
    
    var listId  : String {
        get {
            if let listId =  shoppingList!["_id"].string {
                return listId
            }
            return ""
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProductData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        managedView.willShowComponentView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        managedView.quantityTextField?.becomeFirstResponder()
    }
    
    fileprivate var managedView: GREditInsertedProductView {
        return self.view as! GREditInsertedProductView
    }
    
    override func loadView() {
        super.loadView()
        view = GREditInsertedProductView()
        managedView.delegate = self
        managedView.quantityTextField?.delegate = self
        self.managedView.productImageView?.image = UIImage(named: "grocerest_gray")
        
    }
    
    func closeButtonWasPressed(_ sender:UIButton) {
        managedView.willHideComponentView()
        dismiss(animated: true, completion: nil)
    }
    
    
    func prepareViews() {
        
        self.managedView.formatViewWith(product!)
        
        self.managedView.productImageView?.layoutIfNeeded()
        
        switch defineProductType() {
        case .commercial:
            if let imageAddress = self.remoteProduct?["images"]["large"].string {
                self.managedView.productImageView?.hnk_setImageFromURL(URL(string: String.fullPathForImage(imageAddress))!)
            } else {
                if let imageSmall = self.remoteProduct?["images"]["small"].string {
                    self.managedView.productImageView?.hnk_setImageFromURL(URL(string: String.fullPathForImage(imageSmall))!)
                }
            }
        case .custom:
            self.managedView.productImageView?.image = UIImage(named: "grocerest_gray")
        case .generic:
            if let imageAddress = self.remoteProduct?["images"]["large"].string {
                self.managedView.productImageView?.hnk_setImageFromURL(URL(string: String.fullPathForImage(imageAddress))!)
                break
            }
            if let imageSmall = self.remoteProduct?["images"]["small"].string {
                self.managedView.productImageView?.hnk_setImageFromURL(URL(string: String.fullPathForImage(imageSmall))!)
                break
            }
            if let category = product!["category"].string {
                if category != "" {
                    self.managedView.productImageView?.image = UIImage(named: "products_\(category)")
                    break
                }
            }
            // if we find no image..
            self.managedView.productImageView?.image = UIImage(named: "grocerest_gray")
            break
        }
        
    }
    
    
    func getProductData() {
        if let prodId = product!["product"].string {
            GrocerestAPI.getProduct(prodId) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    DispatchQueue.main.async { SwiftLoader.hide() }
                    return
                }
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.remoteProduct = data
                    self.prepareViews()
                }
            }
        } else {
            SwiftLoader.hide()
        }
    }
    

    func updateQuantityForItem(_ quantity: String) {
        let listId = self.shoppingList!["_id"].stringValue
        let productId = self.product!["_id"].stringValue
        
        GrocerestAPI.updateShoppingListItem(listId: listId, itemId: productId, fields: ["quantity": quantity]) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                return
            }
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.managedView.willHideComponentView()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateQuantityForItem(textField.text!.trimmingCharacters(in: CharacterSet.whitespaces))
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: Utilities
    
    let custom = {(value:JSON) -> Bool
        in
        if let customVal = value["custom"].bool {
            return customVal
        }
        return false
    }
    
    func defineProductType() -> ProductType {
        
        if let generic = product!["generic"].bool {
            if generic {
                return .generic
            }
            
        }
        
        if let custom = product!["custom"].bool {
            if custom {
                return .custom
            }
        }
        
        if let largeImage = remoteProduct!["images"]["large"].string {
            if  largeImage != "" {
                return .commercial
            }
        } else {
            if let imageSmall = self.remoteProduct!["images"]["small"].string {
                if imageSmall != "" {
                    return .commercial
                }
            }
        }
 
        return productType
    }
    
}
