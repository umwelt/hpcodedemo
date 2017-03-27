//
//  GRProductDetailViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 28/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SwiftLoader

class GRProductDetailViewController: UIViewController, GRToolBarProtocol {
    
    var fromDeepLink = false
    var modalDelegate: GRModalViewControllerDelegate?
    
    var productId: String? {
        didSet {
            if productId != nil && !fromDeepLink {
                refresh()
            }
        }
    }
    
    /* Used to prepopulate reviews list */
    private var cachedReviews: [JSON] = [JSON]()
    private var cachedOwnReview: JSON?
    
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
    
    private var managedView: GRProductDetailView {
        return self.view as! GRProductDetailView
    }
    
    override func loadView() {
        super.loadView()
        view = GRProductDetailView()
        managedView.navigationToolBar.delegate = self
        managedView.navigationToolBar.isThisBarWithBackButtonAndGrocerestButton(true)
        
        managedView.onRelatedProductTapped = { productData in
            let productDetail = GRProductDetailViewController()
            productDetail.productId = productData["_id"].stringValue
            self.navigationController?.pushViewController(productDetail, animated: true)
        }
    }
    
    /**
     Prepopulates the view from cached data
     */
    func prepopulateWith(product data: JSON) {        
        if let img = data["images"]["medium"].string {
            let imgUrl = URL(string: String.fullPathForImage(img))!
            self.managedView.setProductImageFrom(imgUrl)
        } else {
            if let category = data["category"].string  {
                self.managedView.image = UIImage(named: "products_" + category)
            }
        }
        let categoryDisplayName = categoryNameFromCategorySlug(data["category"].stringValue)
        self.managedView.category = "  \(categoryDisplayName)  "
        self.managedView.categoryColor = colorForCategory(data["category"].stringValue)
        self.managedView.categoryLabelBackGroundColor = colorForCategory(data["category"].stringValue)
        self.managedView.title = data["display_name"].stringValue
        self.managedView.brand = productJONSToBrand(data: data)

        var histogram = [Int]()
        if data["reviews"]["histogram"].arrayObject != nil {
            histogram = data["reviews"]["histogram"].arrayObject as! [Int]
        }
        if histogram.count == 5 {
            self.managedView.distributionView.reviews = histogram.reversed()
        }
        self.managedView.averageReviewScore = data["reviews"]["average"].doubleValue
        var tags: [String] = []
        for author in data["others"]["authors"].arrayValue {
            tags.append(author.stringValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        let brand = data["display_brand"].stringValue
                                 .replacingOccurrences(of: "-", with: " ", options: NSString.CompareOptions.literal, range: nil)
                                 .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        tags.append(brand)
        
        for tag in data["display_tags"].stringValue.components(separatedBy: " ") {
            tags.append(tag.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        tags = tags.filter { $0.characters.count > 1 } // remove tags that are too short
        self.managedView.tags = tags
        self.managedView.numberOfReviews = data["reviews"]["count"].intValue
    }
    
    /**
        Populates the view by fetching data from GrocerestAPI
     */
    func refresh() {
        guard let productId = productId else {
            fatalError("Product Detail cannot populate itself without a product Id")
        }
        populateProduct(productId)
        populateUserLists(productId)
        populateReviews(productId)
        populateRelatedProducts(productId)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { 
            self.populateProductAvailability(productId)
        }
        
        
        
        self.managedView.onSeeAllReviewsButtonTapped = {
            let reviewsList = GRReviewsListViewController()
            reviewsList.setProductTitle(self.managedView.title)
            reviewsList.setProductBrand(self.managedView.brand)
            reviewsList.setProductNumberOfReviews(self.managedView.numberOfReviews)
            print("Cached reviews: \(self.cachedReviews.count)")
            reviewsList.prepopulateReviewsWith(reviews: self.cachedReviews)
            print("Cached ownReviews: \(self.cachedOwnReview != nil)")
            reviewsList.prepopulateOwnReviewWith(review: self.cachedOwnReview)
            reviewsList.productId = self.productId
            self.navigationController?.pushViewController(reviewsList, animated: true)
        }
    }
    
    func populateFromDeepLink(_ id: String) {
        self.populateProduct(id)
    }
    
    private func populateProduct(_ id: String) {
        GrocerestAPI.getProduct(id) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                if data["error"]["code"].stringValue == "E_NOT_FOUND" {
                    self.dismiss()
                    let alert = UIAlertController(title: "Errore", message: "Impossibile visualizzare il prodotto richiesto", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            if let img = data["images"]["medium"].string {
                let imgUrl = NSURL(string: String.fullPathForImage(img))!
                self.managedView.setProductImageFrom(imgUrl as URL)
            } else {
                if let category = data["category"].string  {
                    self.managedView.image = UIImage(named: "products_" + category)
                }
            }
            let categoryDisplayName = data["category"].stringValue.replacingOccurrences(of: "-", with: " ", options: NSString.CompareOptions.literal, range: nil)
            self.managedView.category = "  \(categoryDisplayName)  "
            self.managedView.categoryColor = colorForCategory(data["category"].stringValue)
            self.managedView.categoryLabelBackGroundColor = colorForCategory(data["category"].stringValue)
            self.managedView.title = data["display_name"].stringValue
            self.managedView.brand = productJONSToBrand(data: data)
            
            var histogram = [0,0,0,0,0]
            if let h =  data["reviews"]["histogram"].arrayObject as? [Int] {
                histogram = h
            } else {
                print("This product has no histogram !?!?")
            }
            
            self.managedView.distributionView.reviews = histogram.reversed()
            self.managedView.averageReviewScore = data["reviews"]["average"].doubleValue
            var tags: [String] = [String]()
            for author in data["others"]["authors"].arrayValue {
                tags.append(author.stringValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            }
            
            let brand = data["display_brand"]
                .stringValue
                .replacingOccurrences(of: "-", with: " ", options: NSString.CompareOptions.literal, range: nil)
                .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            tags.append(brand)
            for tag in data["display_tags"].stringValue.components(separatedBy: " ") {
                tags.append(tag.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            }
            tags = tags.filter({ (text) -> Bool in // remove tags that are too short
                return text.characters.count > 1
            })
            self.managedView.tags = tags
            self.managedView.numberOfReviews = data["reviews"]["count"].intValue
            
            if let largeImage = data["images"]["large"].string {
                self.managedView.onProductImageTapped = {
                    let zoomViewController = GRZoomViewController()
                    zoomViewController.fromImageView = self.managedView.productImageView
                    zoomViewController.imageURLString = String.fullPathForImage(largeImage)
                    zoomViewController.modalPresentationStyle = .overCurrentContext
                    self.present(zoomViewController, animated: false, completion: nil)
                }
            }
            
            self.managedView.onBrandButtonWasTapped = {
                let brand = data["brand"].stringValue
                let brandDetail = GRBrandDetailViewController()
                //controller.lastTappedId = brand
                //brandDetail.modalDelegate = controller
                brandDetail.prepopulateWith(brand: JSON({}))
                brandDetail.brand = brand
                UIApplication.topViewController()?.navigationController?.pushViewController(brandDetail, animated: true)
            }
            
            self.managedView.onCreateNewReviewButtonTapped = {
                GrocerestAPI.getProduct(id) { product, err in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: product, and: err) {
                        return
                    }
                    
                    let recensioneViewController = GRModalRecensioneViewController()
                    recensioneViewController.product = product
                    //recensioneViewController.onDismissed = { _ in self.refresh() }
                    recensioneViewController.modalTransitionStyle = .coverVertical
                    self.present(recensioneViewController, animated: true, completion: nil)
                }
            }
            
            self.managedView.onOtherListsButtonTapped = {
                GrocerestAPI.getProduct(id) { product, err in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: product, and: err) {
                        return
                    }
                    
                    let moreModal = GRSingleProductMoreActionsModalViewController()
                    moreModal.modalTransitionStyle = .crossDissolve
                    moreModal.modalPresentationStyle = .overCurrentContext
                    moreModal.product = product
                    moreModal.onDismissed = {
                        self.refresh()
                    }
                    self.present(moreModal, animated: true, completion: nil)
                }
            }
            
            self.managedView.onTagTapped = { tag in
                let productSearch = GRProductSearchViewController()
                productSearch.setQuery(to: tag)
                self.navigationController?.pushViewController(productSearch, animated: true)
            }
            
            self.managedView.onShareButtonTapped = {
                SwiftLoader.show(animated: true)
                GrocerestAPI.getProductPermalink(for: data["_id"].stringValue) { permalink, error in
                    SwiftLoader.hide()
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: permalink, and: error) {
                        return
                    }
                    
                    let activity = UIActivityViewController(
                        activityItems: [ProductSharingActivitySource(product: data, permalink: permalink["url"].stringValue)],
                        applicationActivities: nil
                    )
                    activity.popoverPresentationController?.sourceView = self.managedView
                    activity.excludedActivityTypes = ExcludedActivitySources
                    self.present(activity, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func populateUserLists(_ id: String) {
        GrocerestAPI.getProductsSelectedByUser(GRUser.sharedInstance.id!) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            self.managedView.list = .none
            
            let favourites = data["favourites"].arrayValue.flatMap { $0.string }
            if favourites.contains(id) { self.managedView.list = .favourite }
            
            let hated = data["hated"].arrayValue.flatMap { $0.string }
            if hated.contains(id) { self.managedView.list = .hated }
            
            let toTry = data["totry"].arrayValue.flatMap { $0.string }
            if toTry.contains(id) { self.managedView.list = .toTry }
        }
        
        func removeProductFromAllLists(_ onComplete: @escaping () -> Void) {
            GrocerestAPI.removeProductToPredefinedList(GRUser.sharedInstance.id!, listName: Constants.PredefinedUserList.favourites, productId: id) { _,_ in
                GrocerestAPI.removeProductToPredefinedList(GRUser.sharedInstance.id!, listName: Constants.PredefinedUserList.hated, productId: id) { _,_ in
                    GrocerestAPI.removeProductToPredefinedList(GRUser.sharedInstance.id!, listName: Constants.PredefinedUserList.totry, productId: id) { _,_ in
                        onComplete()
                    }
                }
            }
        }
        
        func addProductToList(_ name: String, onComplete: @escaping () -> Void) {
            GrocerestAPI.addProductToPredefinedList(GRUser.sharedInstance.id!, listName: name, fields: ["product": id]) { _,_ in
                onComplete()
            }
        }
        
        self.managedView.onFavouriteButtonTapped = {
            let list = self.managedView.list
            SwiftLoader.show(animated: true)
            removeProductFromAllLists {
                if list == .favourite {
                    self.managedView.list = .none
                    SwiftLoader.hide()
                } else {
                    self.managedView.list = .favourite
                    addProductToList(Constants.PredefinedUserList.favourites) {
                        SwiftLoader.hide()
                    }
                }
            }
        }
        
        self.managedView.onHatedButtonTapped = {
            let list = self.managedView.list
            SwiftLoader.show(animated: true)
            removeProductFromAllLists {
                if list == .hated {
                    self.managedView.list = .none
                    SwiftLoader.hide()
                } else {
                    self.managedView.list = .hated
                    addProductToList(Constants.PredefinedUserList.hated) {
                        SwiftLoader.hide()
                    }
                }
            }
        }
        
        self.managedView.onToTryButtonTapped = {
            let list = self.managedView.list
            SwiftLoader.show(animated: true)
            removeProductFromAllLists {
                if list == .toTry {
                    self.managedView.list = .none
                    SwiftLoader.hide()
                } else {
                    self.managedView.list = .toTry
                    addProductToList(Constants.PredefinedUserList.totry) {
                        SwiftLoader.hide()
                    }
                }
            }
        }
    }
    
    private func populateReviews(_ id: String) {
        let fields: [String: Any] = [
            "product": id,
            "step": 0,
            "limit": 4,
            "withTextOnly": true,
            "own": true
        ]
        GrocerestAPI.searchForReview(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            self.managedView.reviewsTableDataSource.cells.removeAll()
            self.managedView.numberOfReviewsWithText = data["count"].intValue
            let userReviewCell = GRReviewTableViewCell()
            userReviewCell.score = 0
            
            if data["own"].exists() {
                self.cachedOwnReview = data["own"]
                
                self.managedView.toTryHiddenDeactivated = true
                let review = data["own"]
                userReviewCell.username = review["author"]["username"].stringValue
                userReviewCell.userReputation = review["author"]["score"].intValue
                // TODO: REF
                
                let type = AvatarType.cells
                userReviewCell.profileImageView.setUserProfileAvatar(review["author"]["picture"].stringValue, name: review["author"]["firstname"].stringValue, lastName: review["author"]["lastname"].stringValue, type: type)
            
                let reviewText = review["review"].stringValue
                userReviewCell.reviewText = reviewText
                if !reviewText.isEmpty {
                    userReviewCell.onReviewTextTapped = {
                        let reviewDetail = GRReviewDetailViewController()
                        //reviewDetail.onDismissed = { self.refresh() }
                        if let img = self.managedView.image {
                            reviewDetail.setProductImage(img)
                        }
                        reviewDetail.setProductTitle(self.managedView.title)
                        reviewDetail.setProductBrand(self.managedView.brand)
                        
                        reviewDetail.setUserLevel(userReviewCell.userReputation)
                        reviewDetail.prepopulateWith(review: review)
                        reviewDetail.reviewId = review["_id"].stringValue
                        self.navigationController?.pushViewController(reviewDetail, animated: true)
                    }
                }
                
                userReviewCell.score = review["rating"].intValue
                let creationDate = NSDate(timeIntervalSince1970: review["tsCreated"].doubleValue / 1000)
                userReviewCell.creationDate = creationDate as Date
                
                userReviewCell.isFirstReview = review["first"].boolValue
                userReviewCell.numberOfUseful = review["voteCount"].intValue
                
            
            } else {
                self.managedView.toTryHiddenDeactivated = false
                // I take user's data from the web instead of taking it from the non-existant own review
                GrocerestAPI.getUser(GRUser.sharedInstance.id!) { user, err in
                    userReviewCell.username = user["username"].stringValue
                    userReviewCell.userReputation = user["score"].intValue
                    
                    let type = AvatarType.cells
                    userReviewCell.profileImageView.setUserProfileAvatar(user["picture"].stringValue, name: user["firstname"].stringValue, lastName: user["lastname"].stringValue, type: type)
                    
              
                }
            }
            
            let editReviewCallback = {
                GrocerestAPI.getProduct(id) { product, err in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: product, and: err) {
                        return
                    }
                    
                    let recensioneViewController = GRModalRecensioneViewController()
                    recensioneViewController.product = product
                    recensioneViewController.onDismissed = { _ in self.refresh() }
                    recensioneViewController.modalTransitionStyle = .coverVertical
                    self.present(recensioneViewController, animated: true, completion: nil)
                }
            }
            
            userReviewCell.onUpdateReviewButtonTapped = editReviewCallback
            userReviewCell.onCreateReviewButtonTapped = editReviewCallback
            userReviewCell.isYourReview = true
            userReviewCell.usefullnessCheckerStatus = .myReview
            self.managedView.reviewsTableDataSource.cells.append(userReviewCell)
            
            self.cachedReviews = data["reviews"].arrayValue
            
            for review in data["reviews"].arrayValue {
                let reviewCell = GRReviewTableViewCell()
                reviewCell.populateWith(review: review, from: self, productImage: self.managedView.image, productBrand: self.managedView.brand, productTitle: self.managedView.title)
                self.managedView.reviewsTableDataSource.cells.append(reviewCell)
            }

            if data["count"].intValue <= 4 {
                self.managedView.hideSeeAllReviewsButton = true
            } else {
                self.managedView.hideSeeAllReviewsButton = false
            }
            
            self.managedView.reviewsTable.reloadData()
            self.managedView.updateReviewsTableHeight()
        }
    }
    
    private func populateRelatedProducts(_ productId: String) {
        GrocerestAPI.getRelatedProducts(of: productId) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            self.managedView.relatedProducts = data["items"].arrayValue
        }
    }
    
    private func populateProductAvailability(_ productId: String) {
        GrocerestAPI.getProductAvailability(productId) { data, error in
            // with this call we totally ignore errors
            if (data["items"].arrayValue.count > 0) {
                UIView.animate(withDuration: 1, animations: { 
                    self.managedView.availabilityButton.layer.opacity = 1
                })
                self.managedView.onAvailabilityButtonTapped = {
                    let vc = RCTViewController()
                    vc.moduleName = "ProductAvailabilityModal"
                    vc.data = data.dictionaryObject! as NSDictionary
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: false, completion: nil)
                }
            }
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
        let productSearch = GRProductSearchViewController()
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
    
}
