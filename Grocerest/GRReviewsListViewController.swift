//
//  GRReviewsListViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 15/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SwiftLoader
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class GRReviewsListViewController: UIViewController, GRToolBarProtocol, UITableViewDataSource {
    
    var productId: String? {
        didSet {
            if productId != nil { refresh() }
        }
    }
    
    /*
     Pre-population functions
     */
    func setProductTitle(_ title: String) { self.managedView.productTitle = title }
    func setProductBrand(_ brand: String) { self.managedView.productBrand = brand }
    func setProductNumberOfReviews(_ number: Int) { self.managedView.numberOfReviews = number }
    func prepopulateReviewsWith(reviews data: [JSON]) {
        self.reviews = data
        print("Prepopulated with \(reviews.count) reviews")
    }
    func prepopulateOwnReviewWith(review data: JSON?) {
        self.ownReview = data
        print("Prepopulated ownReview")
    }
    
    // total number of reviews according to the server
    fileprivate var reviewsTotal: Int?
    
    fileprivate var reviews: [JSON] = [JSON]()
    fileprivate var ownReview: JSON?
    fileprivate var isDownloading = false
    
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
    
    fileprivate var managedView: GRReviewsListView {
        return self.view as! GRReviewsListView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //managedView.reviewsTable.tableHeaderView = managedView.labelView
        managedView.reviewsTable.reloadData()

    }
    
    override func loadView() {
        super.loadView()
        
        view = GRReviewsListView()
        managedView.navigationToolBar.delegate = self
        managedView.navigationToolBar.isThisBarWithBackButtonAndGrocerestButton(true)
        
        managedView.reviewsTable.register(GRReviewTableViewCell.self, forCellReuseIdentifier: "cell")
        managedView.reviewsTable.dataSource = self
        managedView.reviewsTable.reloadData()
    }
    
    func refresh() {
        guard let productId = productId else {
            fatalError("Cannot get product's reviews without a product Id")
        }
        
        SwiftLoader.show(animated: true)
        
        populateProduct(productId)
        managedView.reviewsTable.reloadData()

        getReviews() {
            self.managedView.reviewsTable.reloadData()
            SwiftLoader.hide()
        }
    }
    
    fileprivate func populateProduct(_ id: String) {
        GrocerestAPI.getProduct(id) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            self.managedView.productTitle = data["display_name"].stringValue
            self.managedView.productBrand = productJONSToBrand(data: data)
            
            // self.managedView.numberOfReviews = data["reviews"]["count"].intValue
        }
    }
    
    
    fileprivate func getReviews(_ doneCallback: @escaping () -> Void) { // Tries to get more reviews from server
        if isDownloading { return }
        if self.reviewsTotal > 0 && self.reviewsCount() >= self.reviewsTotal {
            print("No more reviews to fetch")
            return
        }
        
        isDownloading = true
        let from = self.reviews.count
        let limit = 20
        
        guard let id = productId else {
            fatalError("Cannot get product's reviews without a product Id")
        }
        
        let fields: [String: Any] = [
            "product": id,
            "step": from,
            "limit": limit,
            "withTextOnly": true,
            "own": true
        ]
        
        // print("Getting reviews [\(from), \(from + limit)[")
        
       GrocerestAPI.searchForReview(fields) { data, error in
        
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
        
            self.ownReview = !data["own"].isEmpty ? data["own"] : nil
            self.managedView.numberOfReviews = data["count"].intValue
        
//            let reviewsNewCount = data["reviews"].arrayValue.count
//            let reviewOwnCount = self.reviewOwnCount()
//            let reviewsOldCount = self.reviews.count
        
            self.reviewsTotal = data["count"].intValue
            self.reviews.append(contentsOf: data["reviews"].arrayValue)
            self.isDownloading = false
        
            // print("Actually got", data["reviews"].arrayValue.count)
        
            doneCallback()
        }
    }
    
    func getReview(_ reviewId: String, own: Bool, doneCallback: @escaping () -> Void) { // Tries to update a single self.reviews by id from server
        GrocerestAPI.getReview(reviewId: reviewId) { data, error in
            if own {
                self.ownReview = data
            } else {
                for (index, review) in self.reviews.enumerated() {
                    if review["_id"] == data["_id"] {
                        self.reviews[index] = data
                    }
                }
            }
            doneCallback()
        }
    }
    
    func reviewsCount() -> Int {
        // counts the review we have already downloaded 
        // (the ones we can draw or have already drawn)
        print(self.reviews.count, self.reviewOwnCount(), self.reviewsTotal)
        return self.reviews.count + self.reviewOwnCount()
    }
    
    func reviewOwnCount() -> Int {
        if self.ownReview == nil {
            return 0
        } else {
            return 1
        }
    }
    
    // MARK: Datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return reviews.count
            //return reviewsTotal != nil ? reviewsTotal! : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GRReviewTableViewCell
        
        // TODO: This function is very difficult to read.
        // When reusing a cell we should first re-set it to default values
        // and then just set the ones that matter according to the data.
        // This would make things more clear.
        
        // Own review
        if indexPath.section == 0 {
            
            if let review = ownReview, !review.isEmpty {
                cell.username = review["author"]["username"].stringValue
                cell.userReputation = review["author"]["score"].intValue
                let type = AvatarType.cells
                cell.profileImageView.setUserProfileAvatar(review["author"]["picture"].stringValue, name: review["author"]["firstname"].stringValue, lastName: review["author"]["lastname"].stringValue, type: type)
                
           
                let reviewText = review["review"].stringValue
                cell.reviewText = reviewText
                if !reviewText.isEmpty {
                    cell.onReviewTextTapped = {
                        let reviewDetail = GRReviewDetailViewController()
                        
                        // Prepopulation START
                        reviewDetail.setProductTitle(self.managedView.productTitle)
                        reviewDetail.setProductBrand(self.managedView.productBrand)
                      
                        reviewDetail.setUserLevel(cell.userReputation)
                        reviewDetail.prepopulateWith(review: review)
                        // Prepopulation END
                        
                        let reviewId = review["_id"].stringValue
                        reviewDetail.onDismissed = {
                            self.getReview(reviewId, own: true) {
                                self.managedView.reviewsTable.reloadData()
                            }
                        }
                        reviewDetail.reviewId = reviewId
                        self.navigationController?.pushViewController(reviewDetail, animated: true)
                    }
                }
                
                cell.score = review["rating"].intValue
                let creationDate = Date(timeIntervalSince1970: review["tsCreated"].doubleValue / 1000)
                cell.creationDate = creationDate
                
                cell.isFirstReview = review["first"].boolValue
                cell.numberOfUseful = review["voteCount"].intValue
            } else {
                // I take user's data from the web instead of taking it from the non-existant own review
                let user = GRUser.sharedInstance
                cell.username = user.username!
                cell.userReputation = Int(truncatingBitPattern: user.score!)
                
                let type = AvatarType.cells
                cell.profileImageView.setUserProfileAvatar(user.picture!, name: user.firstname!, lastName: user.lastname!, type: type)
                cell.isFirstReview = false
                cell.score = 0
                
                GrocerestAPI.getUser(GRUser.sharedInstance.id!) { user, err in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: user, and: err) {
                        return
                    }
                    
                    cell.username = user["username"].stringValue
                    cell.userReputation = user["score"].intValue
                    let type = AvatarType.cells
                    cell.profileImageView.setUserProfileAvatar(user["picture"].stringValue, name: user["firstname"].stringValue, lastName: user["lastname"].stringValue, type: type)
                   
                }
                
            }
            cell.isYourReview = false
            cell.isYourReview = true
            
            let editReviewCallback = {
                GrocerestAPI.getProduct(self.productId!) { product, err in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: product, and: err) {
                        return
                    }
                    
                    let recensioneViewController = GRModalRecensioneViewController()
                    recensioneViewController.product = product
                    recensioneViewController.onDismissed = { deleted in
                        if deleted {
                            self.ownReview = nil
                            self.managedView.reviewsTable.reloadData()
                        } else {
                            self.getReview(recensioneViewController.currentReview, own: true) {
                                self.managedView.reviewsTable.reloadData()
                            }
                        }
                    }
                    recensioneViewController.modalTransitionStyle = .coverVertical
                    self.present(recensioneViewController, animated: true, completion: nil)
                }
            }
            cell.onUpdateReviewButtonTapped = editReviewCallback
            cell.onUsefullnessButtonTapped = nil
            cell.onCreateReviewButtonTapped = editReviewCallback
            cell.isYourReview = true
            cell.usefullnessCheckerStatus = .myReview
            
            return cell
        }
        
        cell.isYourReview = false
        
        if !isDownloading && reviews.count < reviewsTotal && reviews.count - indexPath.row <= 5 {
            // Get more reviews from the API and then reload the cell
            getReviews() { tableView.reloadData() }
        }
        
        // Use the already downloaded data to populate the cell
        let review = reviews[indexPath.row]
        cell.populateWith(review: review, from: self, productImage: nil, productBrand: self.managedView.productBrand, productTitle: self.managedView.productTitle)
        
        
        return cell
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
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}
