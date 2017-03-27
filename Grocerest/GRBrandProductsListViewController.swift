//
//  GRBrandProductsListViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 13/02/17.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation
import SwiftLoader

class GRBrandProductsListViewController: UIViewController, GRToolBarProtocol, GRLastIdTappedCacher, GRModalViewControllerDelegate {
    
    var lastTappedId: String?
    var modalDelegate: GRModalViewControllerDelegate?
    
    var onDismissed: (() -> Void)?
    
    func setBrand(to string: String) {
        brand = string
        getSearchResults(for: brand) { resultsData in
            let numberOfResults = resultsData["count"].intValue
            let products = resultsData["items"].arrayValue
            self.managedView.setResults(totalNumber: numberOfResults, products: products)
        }
    }
    
    private var brand: String = ""
    private var isDownloading: Bool = false
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    private var managedView: GRBrandProductsListView {
        return view as! GRBrandProductsListView
    }
    
    override func loadView() {
        super.loadView()
        
        view = GRBrandProductsListView()
        
        managedView.isResultsRankHidden = false
        
        managedView.navigationToolBar.delegate = self
        managedView.navigationToolBar.isThisBarWithBackButtonAndGrocerestButton(true)
        
        managedView.onBackButtonTap = {
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
                self.onDismissed?()
            } else {
                self.dismiss(animated: true, completion: self.onDismissed)
            }
        }
        
        managedView.onRequiresMoreResults = { fromResultNumber in
            if !self.isDownloading {
                self.isDownloading = true
                // Get more reviews from the API and then reload the cell
                self.getSearchResults(for: self.brand, from: fromResultNumber) { resultsData in
                    // If it's empty then it means there will be no more results
                    // from the server because it has reached its hard limit
                    let products = resultsData["items"].arrayValue
                    if !products.isEmpty {
                        self.managedView.appendResults(products: products)
                        self.isDownloading = false
                    }
                }
            }
        }
        
        /// Called when a user taps on a product result and then returns from it
        managedView.onReturnFromResult = { lastProductTappedId in
            self.getProduct(id: lastProductTappedId!) { updatedProduct in
                self.managedView.updateResult(product: updatedProduct)
            }
        }
    }
    
    private func getSearchResults(for brand: String, from resultNumber: Int? = nil, completion: @escaping (_ resultsData: JSON) -> Void) {
        SwiftLoader.show(animated: true)
        
        var options: [String: Any] = [
            "brand": brand
        ]
        
        if let step = resultNumber {
            options["step"] = step
        }
        
        GrocerestAPI.searchProductsForList(GRUser.sharedInstance.id!, fields: options) { data, error in
            SwiftLoader.hide()
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            completion(data)
        }
    }
    
    func getProduct(id productId: String, completion: @escaping (_ productData: JSON) -> Void) {
        SwiftLoader.show(animated: true)
        
        GrocerestAPI.getProduct(productId) { data, error in
            SwiftLoader.hide()
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            completion(data)
        }
    }
    
    // MARK: Toolbar
    
    func menuButtonWasPressed(_ menuButton: UIButton) {
        toggleSideMenuView()
    }
    
    func grocerestButtonWasPressed(_ grocerestButton: UIButton){
        navigationController?.popToRootViewController(animated: false)
    }
    
    func scannerButtonWasPressed(_ sender: UIButton){
        let scannerViewController = GRBarcodeScannerViewController()
        navigationController?.pushViewController(scannerViewController, animated: false)
    }
    
    func searchButtonWasPressed(_ searchButton: UIButton){
        let productSearch = GRBrandsSearchViewController()
        navigationController?.pushViewController(productSearch, animated: true)
    }
    
    func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
