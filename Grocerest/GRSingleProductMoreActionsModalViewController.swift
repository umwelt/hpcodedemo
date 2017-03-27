//
//  GRSingleProductMoreActionsModalViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftLoader

class GRSingleProductMoreActionsModalViewController: UIViewController, GRSingleProductMoreActionsProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, GRMoreActionsForProductProtocol ,GRModalViewControllerDelegate {
    
    var dataSource : JSON?
    var frame: CGRect = CGRect(x: 0, y: 0, width: 118 / masterRatio, height: 178 / masterRatio)
    var collectionView : UICollectionView?
    var pageControl = UIPageControl()
    var product : JSON?
    
    var belongsToList = ""
    var commanderList = ""
    
    var delegate:GRUserCategorizedProductsProtocol?
    var modalDelegate:GRModalViewControllerDelegate?
    var onDismissed: (() -> Void)?
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataSource()        
        managedView.willShowComponentView()
        getReviewDataForProduct()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let cv = collectionView {
            managedView.backgroundControllerView.addSubview(cv)
        }
        
        collectionView?.snp.makeConstraints { make in
            make.width.equalTo(600 /  masterRatio)
            make.height.equalTo(managedView.bottomMidContainer!.snp.height)
            make.centerY.equalTo(managedView.bottomMidContainer!.snp.centerY)
            make.centerX.equalTo(managedView.bottomMidContainer!.snp.centerX)
            
        }
        
        // dismiss action
        managedView.backgroundCover.addGestureRecognizer(
            UITapGestureRecognizer.init(
                target: self, action: #selector(GRSingleProductMoreActionsProtocol.closeButtonWasPressed(_:))
            )
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate var managedView: GRSingleProductMoreActionsModalView {
        return self.view as! GRSingleProductMoreActionsModalView
    }
    
    override func loadView() {
        super.loadView()
        view = GRSingleProductMoreActionsModalView()
        managedView.delegate = self
    }
    
    
    
    func closeButtonWasPressed(_ sender: UIButton) {
        self.managedView.willHideComponentView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) { // Or 0.2 seconds
            self.delegate?.reloadDataSourceForList?(self.commanderList)
            self.delegate?.restartScanner?()
            self.dismiss(animated: true, completion: nil)
            self.onDismissed?()
            self.modalDelegate?.modalWasDismissed?(self)
        }
    }
    
    func prepareViews() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.itemSize = CGSize(width: 132 / masterRatio, height: 178 / masterRatio)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        managedView.bottomMidContainer?.addSubview(collectionView!)
        
        collectionView?.backgroundColor = UIColor.F1F1F1Color()
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView?.isPagingEnabled = true
        collectionView?.clipsToBounds = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView!.register(GRListButtonAsIconViewCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        let thisProduct = product!["_id"].stringValue
        
        if getFavouritedProductsFromLocal().contains(thisProduct) {
            managedView.listType = .favourite
        } else if getHatedProductsFromLocal().contains(thisProduct) {
            managedView.listType = .hated
        } else if getTryableProductsFromLocal().contains(thisProduct) {
            managedView.listType = .toTry
        } else {
            managedView.listType = .none
        }
        
        if getFullyReviewdProductsFromLocal().contains(thisProduct) {
            // Full
            managedView.reviewStatus = .complete
        } else if getReviewedProductsFromLocal().contains(thisProduct) {
            // Incomplete
            managedView.reviewStatus = .incomplete
        } else {
            // None
            managedView.reviewStatus = .none
        }

        managedView.averageReviewScore = product!["reviews"]["average"].doubleValue
        managedView.numberOfReviews = product!["reviews"]["count"].intValue
        
        if let productName = product!["display_name"].string {
            managedView.productMainLabel?.text = productName
        }
        
        if let category = self.product!["category"].string {
            self.managedView.productImageView?.image = UIImage(named: "products_" + category)?.imageWithInsets(10)
        }
        
        if let imagePath = product!["images"]["medium"].string {
            managedView.productImageView?.layoutIfNeeded()
            DispatchQueue.main.async {
                self.managedView.productImageView?.hnk_setImageFromURL(URL(string: String.fullPathForImage(imagePath))!)
            }
        }
        
        if let brand = product!["display_brand"].string {
            managedView.productSecondaryLabel?.text = brand
        }
        
        getUserProductsList {
            self.setStatusForActions()
        }
        
        managedView.toProductButton.addTarget(self, action: #selector(GRSingleProductMoreActionsModalViewController.actionToDetailProduct(_:)), for: .touchUpInside)
        
        managedView.onReviewButtonTapped = {
            let recensioneViewController = GRModalRecensioneViewController()
            recensioneViewController.product = self.product!
            recensioneViewController.modalPresentationStyle = .overCurrentContext
            self.present(recensioneViewController, animated: true, completion: nil)
        }
        
        managedView.onTitleOrBrandTapped = {
            self.openProductDetail()
        }
        
        if managedView.numberOfReviews == 0 {
            managedView.onBottomTapped = managedView.onReviewButtonTapped
        } else {
            managedView.onBottomTapped = managedView.onTitleOrBrandTapped
        }
    }
    
    func configurePageControl() {
        let items = self.dataSource?.count
        
        if items! == 1 || items! <= 4 {
            pageControl.numberOfPages = 1
        } else if items! == 5 || items! <= 8 {
            pageControl.numberOfPages = 2
        } else if items! == 9 || items! <= 12 {
            pageControl.numberOfPages = 3
        } else if items! == 13 || items! <= 16 {
            pageControl.numberOfPages = 4
        } else if items! == 17 || items! <= 20 {
            pageControl.numberOfPages = 5
        } else if items! == 21 || items! <= 24 {
            pageControl.numberOfPages = 6
        } else if items! == 25 || items! <= 28 {
            pageControl.numberOfPages = 7
        } else if items! == 29 || items! <= 32 {
            pageControl.numberOfPages = 8
        } else if items! == 33 || items! <= 36 {
            pageControl.numberOfPages = 9
        } else if items! == 37 || items! <= 40 {
            pageControl.numberOfPages = 10
        }
        
        if self.dataSource!.count > 4 {
            pageControl.isEnabled = true
            pageControl.pageIndicatorTintColor = UIColor.white
            pageControl.currentPageIndicatorTintColor = UIColor.grocerestBlue()
        } else {
            pageControl.isEnabled = false
            pageControl.pageIndicatorTintColor = UIColor.grocerestLightGrayColor()
            pageControl.currentPageIndicatorTintColor = UIColor.white
        }
        
        self.managedView.backgroundControllerView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(20)
            make.top.equalTo(managedView.bottomMidContainer!.snp.bottom)
            make.centerX.equalTo((managedView.bottomMidContainer?.snp.centerX)!)
        }
        
        pageControl.tintColor = UIColor.red
        self.managedView.backgroundControllerView.bringSubview(toFront: pageControl)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = dataSource?.count {
            return count > 40 ? 40 : count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GRListButtonAsIconViewCollectionViewCell
        
        let source = self.dataSource![indexPath.row]
        
        if source["owner"]["_id"].stringValue != GRUser.sharedInstance.id! {
            cell.iconImageView?.image = UIImage(named: "shared_blue_list")
        } else {
            cell.iconImageView?.image = UIImage(named: "user_list_blue")
        }
        
        if let name = source["name"].string {
            cell.listLabel?.text = name
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var fields = [String: Any]()
        
        if let name = product!["display_name"].string {
            fields["name"] = name
        }
        
        if let productId = product!["_id"].string {
            fields["product"] = productId
        }
        
        if let brand = product!["brand"].string {
            fields["brand"] = brand
        }
        
        if let category = product!["category"].string {
            fields["category"] = category
        }
        
        fields["generic"] = false
        fields["custom"] = false
        
        if let itemId = self.dataSource![indexPath.row]["_id"].string {
            GrocerestAPI.postShoppingListItem(itemId, fields: fields) {data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }
                
                let presentingVC = self.presentingViewController!
                let navigationController = presentingVC is UINavigationController ? presentingVC as? UINavigationController : presentingVC.navigationController
                let shoppingListViewController = GRShoppingListViewController()
                shoppingListViewController.shoppingList = self.dataSource![indexPath.row]
                
                self.dismiss(animated: true) {
                    navigationController?.pushViewController(shoppingListViewController, animated: false)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 14 / masterRatio, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 18 / masterRatio
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return  0
    }
    
    func actionToDetailProduct(_ sender:UIButton) {
        openProductDetail()
    }
    
    
    func openProductDetail() {
        let presentingVC = self.presentingViewController!
        let navigationController = presentingVC is UINavigationController ? presentingVC as? UINavigationController : presentingVC.navigationController
        let productDetail = GRProductDetailViewController()
        productDetail.prepopulateWith(product: product!)
        productDetail.productId = product!["_id"].stringValue
        navigationController?.pushViewController(productDetail, animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var currentIndex = (self.collectionView?.contentOffset.x)! / (self.collectionView?.frame.size.width)!
        let mod = (self.collectionView?.contentOffset.x)!.truncatingRemainder(dividingBy: (self.collectionView?.frame.size.width)!)
        if (mod > 0) {
            currentIndex += 1
        }
        pageControl.currentPage = Int(currentIndex)
    }
    
    /**
     DataSource
     */
    func setDataSource() {
        GrocerestAPI.getUserShoppingLists(GRUser.sharedInstance.id!) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            let sorted = data.array!.sorted(by: { (a, b) -> Bool in
                return a["tsUpdated"] > b["tsUpdated"]
            })
            
            let filtered = sorted.filter { shoppingList in
                let invitedUsers = shoppingList["invited"].array!
                for user in invitedUsers {
                    if user["_id"].stringValue == GRUser.sharedInstance.id! {
                        return false
                    }
                }
                return true
            }
            
            self.dataSource = JSON(filtered)
            
            DispatchQueue.main.async {
                self.configurePageControl()
                self.collectionView?.reloadData()
            }
        }
    }
    
    func createNewListWasPressed(_ sender: UIButton) {
        let addToListProductViewController = GRCreateListViewController()
        addToListProductViewController.withProduct = true
        addToListProductViewController.delegate = self
        addToListProductViewController.product = product
        present(addToListProductViewController, animated: false)
    }
    
    func postItemForNewList(_ listData:JSON) {
        var fields = [String: Any]()
        
        if let name = self.product!["name"].string,
            let productId = self.product!["_id"].string,
            let brand = self.product!["brand"].string,
            let category = self.product!["category"].string {
            
            fields["name"] = name
            fields["product"] = productId
            fields["brand"] = brand
            fields["category"] = category
        }
        
        fields["generic"] = false
        fields["custom"] = false
        
        GrocerestAPI.postShoppingListItem(listData["_id"].string!, fields: fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            let presentingVC = self.presentingViewController!
            let navigationController = presentingVC is UINavigationController ? presentingVC as? UINavigationController : presentingVC.navigationController
            let shoppingListViewController = GRShoppingListViewController()
            shoppingListViewController.shoppingList = listData
            
            self.dismiss(animated: true) { () -> Void in
                navigationController?.pushViewController(shoppingListViewController, animated: true)
                
            }
        }
    }
    
    // MARK: Grocerest.API
    
    func addProductToList(_ listname: String, fields: [String: String], completion: @escaping (_ success: Bool) -> Void) {
        SwiftLoader.show(animated: true)
        GrocerestAPI.addProductToPredefinedList(GRUser.sharedInstance.id!, listName: listname, fields: fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                completion(false)
                SwiftLoader.hide()
                return
            }
            
            SwiftLoader.hide()
            completion(true)
            getUserProductsList()
        }
    }
    
    func removeProductToList(_ listname: String, productId: String, completion: @escaping (_ success: Bool) -> Void) {
        SwiftLoader.show(animated: true)
        GrocerestAPI.removeProductToPredefinedList(GRUser.sharedInstance.id!, listName: listname, productId: productId) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                completion(false)
                SwiftLoader.hide()
                return
            }
            
            SwiftLoader.hide()
            completion(true)
            getUserProductsList()
        }
    }
    
    func preferitiButtonWasPressed(_ sender:UIButton) {
        managedView.listType = .favourite
        
        // 1: Check if product belong to list owned by button
        if belongsToList == Constants.PredefinedUserList.favourites {
            managedView.listType = .none
            
            // 2: If so, remove it
            managedView.preferitiButton!.isSelected = false
            
            removeProductToList(Constants.PredefinedUserList.favourites, productId: product!["_id"].stringValue) { success in
                if success {
                    // 3: Removed from list where button is owner, leaves stateless button
                    self.belongsToList = ""
                }
            }
        } else if belongsToList == Constants.PredefinedUserList.hated {
            // 4: Product Belongs to owner which is not button, so remove it from remote owner
            managedView.evitareButton!.isSelected = false
            
            removeProductToList(Constants.PredefinedUserList.hated, productId: product!["_id"].stringValue) { success in
                if success {
                    // 5. Add product to owner
                    self.addProductToList(Constants.PredefinedUserList.favourites, fields: self.provideProductId(self.product!)) { success in
                        if success {
                            self.belongsToList = Constants.PredefinedUserList.favourites
                            self.managedView.preferitiButton?.isSelected = true
                        }
                    }
                }
            }
        } else if belongsToList == Constants.PredefinedUserList.totry {
            managedView.provareButton?.isSelected = false
            
            removeProductToList(Constants.PredefinedUserList.totry, productId: product!["_id"].stringValue) { success in
                if success {
                    self.addProductToList(Constants.PredefinedUserList.favourites, fields: self.provideProductId(self.product!)) { success in
                        if success {
                            self.belongsToList = Constants.PredefinedUserList.favourites
                            self.managedView.preferitiButton?.isSelected = true
                        }
                    }
                }
            }
        } else {
            managedView.preferitiButton?.isSelected = true
            
            addProductToList(Constants.PredefinedUserList.favourites, fields: self.provideProductId(self.product!)) { success in
                if success {
                    self.belongsToList = Constants.PredefinedUserList.favourites
                }
            }
        }
        
        
    }
    
    func evitareButtonWasPressed(_ sender:UIButton) {
        managedView.listType = .hated
        
        if belongsToList == Constants.PredefinedUserList.hated {
            managedView.listType = .none
            managedView.evitareButton?.isSelected = false
            
            removeProductToList(Constants.PredefinedUserList.hated, productId: product!["_id"].stringValue) { success in
                if success {
                    self.belongsToList = ""
                }
            }
            
        } else if belongsToList == Constants.PredefinedUserList.favourites {
            managedView.preferitiButton?.isSelected = false
            
            removeProductToList(Constants.PredefinedUserList.favourites, productId: product!["_id"].stringValue) { success in
                if success {
                    self.addProductToList(Constants.PredefinedUserList.hated, fields: self.provideProductId(self.product!)) { success in
                        if success {
                            self.belongsToList = Constants.PredefinedUserList.hated
                            self.managedView.evitareButton?.isSelected = true
                        }
                    }
                }
            }
        } else if belongsToList == Constants.PredefinedUserList.totry {
            managedView.provareButton?.isSelected = false
            
            removeProductToList(Constants.PredefinedUserList.totry, productId: product!["_id"].stringValue) { success in
                if success {
                    self.addProductToList(Constants.PredefinedUserList.hated, fields: self.provideProductId(self.product!)) { success in
                        if success {
                            self.belongsToList = Constants.PredefinedUserList.hated
                            self.managedView.evitareButton?.isSelected = true
                        }
                    }
                }
            }
        } else {
            managedView.evitareButton?.isSelected = true
            
            self.addProductToList(Constants.PredefinedUserList.hated, fields: self.provideProductId(self.product!)) { success in
                if success {
                    self.belongsToList = Constants.PredefinedUserList.hated
                }
            }
        }
    }
    
    func provareButtonWasPressed(_ sender:UIButton) {
         managedView.listType = .toTry
        
        if belongsToList == Constants.PredefinedUserList.totry {
            managedView.listType = .none
            managedView.provareButton?.isSelected = false
            
            removeProductToList(Constants.PredefinedUserList.totry, productId: product!["_id"].stringValue) { success in
                if success {
                    self.belongsToList = ""
                }
            }
        } else if belongsToList == Constants.PredefinedUserList.favourites {
            managedView.preferitiButton?.isSelected = false
            
            removeProductToList(Constants.PredefinedUserList.favourites, productId: product!["_id"].stringValue) { success in
                if success {
                    self.addProductToList(Constants.PredefinedUserList.totry, fields: self.provideProductId(self.product!)) { success in
                        if success {
                            self.belongsToList = Constants.PredefinedUserList.totry
                            self.managedView.provareButton?.isSelected = true
                        }
                    }
                }
            }
        } else if belongsToList == Constants.PredefinedUserList.hated {
            managedView.evitareButton?.isSelected = false
            
            removeProductToList(Constants.PredefinedUserList.hated, productId: product!["_id"].stringValue) { success in
                if success {
                    self.addProductToList(Constants.PredefinedUserList.totry, fields: self.provideProductId(self.product!)) { success in
                        if success {
                            self.belongsToList = Constants.PredefinedUserList.totry
                            self.managedView.provareButton?.isSelected = true
                        }
                    }
                }
            }
        } else {
            managedView.provareButton?.isSelected = true
            
            addProductToList(Constants.PredefinedUserList.totry, fields: self.provideProductId(self.product!)) { success in
                if success {
                    self.belongsToList = Constants.PredefinedUserList.totry
                }
            }
        }
        
    }
    
    // MARK : UTILS
    
    func provideProductId(_ product:JSON) -> [String:String] {
        if let id = product["_id"].string {
            return ["product": id]
        }
        return [:]
    }
    
    /**
     Changes UI
     */
    func setStatusForActions() {
        if let productId = product!["_id"].string {
            if getFavouritedProductsFromLocal().contains(productId) {
                managedView.preferitiButton?.isSelected = true
                belongsToList = Constants.PredefinedUserList.favourites
            }
            
            if getHatedProductsFromLocal().contains(productId) {
                managedView.evitareButton?.isSelected = true
                belongsToList = Constants.PredefinedUserList.hated
            }
            
            if getTryableProductsFromLocal().contains(productId) {
                managedView.provareButton?.isSelected = true
                belongsToList = Constants.PredefinedUserList.totry
            }
        }
    }
    
    
    func recensioneButtonWasPressed(_ sender:UIButton) {
        let recensioneViewController = GRModalRecensioneViewController()
        recensioneViewController.product = self.product
        recensioneViewController.modalDelegate = self
        recensioneViewController.modalTransitionStyle = .coverVertical
        present(recensioneViewController, animated: true, completion: nil)
    }
    
    
    func getReviewDataForProduct() {
        let fields = [
            "author": GRUser.sharedInstance.id!,
            "product": product!["_id"].string!
        ]
        GrocerestAPI.searchForReview(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            if data["reviews"].count == 1 {
                self.managedView.provareButton?.isEnabled = false
            }
            
            getUserProductsList {
                 self.prepareViews()
            }
        }
    }
    
    func dismissNestedModal(_ data:JSON) {
        let presentingVC = presentingViewController!
        let navigationController = presentingVC is UINavigationController ? presentingVC as? UINavigationController : presentingVC.navigationController
        
        let shoppingListViewController = GRShoppingListViewController()
        shoppingListViewController.shoppingList = data
        
        navigationController?.popViewController(animated: false)
        navigationController?.pushViewController(shoppingListViewController, animated: false)
        self.dismiss(animated: true)
    }
    
}
