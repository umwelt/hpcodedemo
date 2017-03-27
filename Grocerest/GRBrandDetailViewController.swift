//
//  GRBrandDetailViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 07/02/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation
import SwiftLoader

class GRBrandDetailViewController: UIViewController, GRToolBarProtocol, GRLastIdTappedCacher, GRModalViewControllerDelegate {
    
    var lastTappedId: String?
    
    var fromDeepLink = false
    var modalDelegate: GRModalViewControllerDelegate?
    
    var brand: String? {
        didSet {
            if brand != nil && !fromDeepLink {
                refresh()
            }
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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!self.isMovingToParentViewController) {
            // means the view controller is re-appearing after another view controller popped()
            self.refresh()
        }
    }
    
    private var managedView: GRBrandDetailView {
        return self.view as! GRBrandDetailView
    }
    
    override func loadView() {
        super.loadView()
        view = GRBrandDetailView()
        managedView.navigationToolBar.delegate = self
        managedView.navigationToolBar.isThisBarWithBackButtonAndGrocerestButton(true)
    }
    
    /**
     Prepopulates the view from cached data
     */
    func prepopulateWith(brand data: JSON) {
        if let brandImage = data["images"]["medium"].string {
            managedView.setProductImageFrom(URL(string: String.fullPathForImage(brandImage))!)
        } else {
            managedView.image = UIImage(named: "no-brand-image-icon")
        }
        
        managedView.title = data["display_name"].stringValue
        managedView.numberOfReviews = data["reviews"].intValue
    }
    
    /**
     Populates the view by fetching data from GrocerestAPI
     */
    func refresh() {
        guard let brandName = brand else {
            fatalError("Product Detail cannot populate itself without a product Id")
        }
        populateBrand(brandName)
        
        if let productId = lastTappedId {
            populateProduct(productId)
        } else {
            populateProducts(brandName)
        }
        
        self.managedView.onSeeAllProductsButtonTapped = {
            let productsList = GRBrandProductsListViewController()
            productsList.setBrand(to: brandName)
            self.navigationController?.pushViewController(productsList, animated: true)
        }
    }
    
    func populateFromDeepLink(_ id: String) {
        populateBrand(id)
    }
    
    private func populateBrand(_ id: String) {

        GrocerestAPI.getBrand(id) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                if data["error"]["code"].stringValue == "E_NOT_FOUND" {
                    self.dismiss()
                    let alert = UIAlertController(title: "Errore", message: "Impossibile visualizzare il brand richiesto", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            let picUrl = data["picture"].stringValue
            if let encodedUrl = picUrl.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
               let url = URL(string: encodedUrl) {
                self.managedView.setProductImageFrom(url)
            } else {
                self.managedView.image = UIImage(named: "no-brand-image-icon")
            }
            
            self.managedView.title = data["display_name"].stringValue
            self.managedView.averageReviewScore = data["average"].doubleValue
            self.managedView.numberOfReviews = data["reviews"].intValue
            
            let histogram = data["histogram"].arrayObject as? [Int] ?? [0,0,0,0,0]
            self.managedView.distributionView.reviews = histogram.reversed()
        }
    }
    
    private func populateProducts(_ brand: String) {
        let fields: [String : Any] = ["brand": brand, "limit": 3]
        
        GrocerestAPI.searchProducts(fields: fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            self.managedView.reviewsTableDataSource.cells.removeAll()
            self.managedView.numberOfProducts = data["count"].intValue
            
            for (i, product) in data["items"].arrayValue.enumerated() {
                let cell = GRProductsResultTableViewCell()
                cell.populateWith(product: product, from: self)
                // Doesn't show ranking for products without reviews
                if product["reviews"]["count"].intValue != 0 {
                    cell.isRankHidden = false
                    cell.rank = i + 1
                } else {
                    cell.isRankHidden = true
                }
                self.managedView.reviewsTableDataSource.cells.append(cell)
            }
            
            if data["count"].intValue <= 3 {
                self.managedView.hideSeeAllProductsButton = true
            } else {
                self.managedView.hideSeeAllProductsButton = false
            }
            
            self.managedView.productsTable.reloadData()
            self.managedView.updateProductsTableHeight()
        }
    }
    
    private func populateProduct(_ id: String) {
        GrocerestAPI.getProduct(id) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            // Updates the cached review
            for cell in self.managedView.reviewsTableDataSource.cells
                where id == cell.data?["_id"].stringValue {
                    cell.populateWith(product: data, from: self)
            }
            
            self.managedView.productsTable.reloadData()
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
        NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIdentifierReload), object: nil)
        self.dismiss()
        modalDelegate?.modalWasDismissed?(self)
    }
    
    private func dismiss() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func modalWasDismissed(_ modal: UIViewController) {
        // Needed to implement GRModalViewControllerDelegate and use populateWith
        // method on cells
        refresh()
    }
    
}
