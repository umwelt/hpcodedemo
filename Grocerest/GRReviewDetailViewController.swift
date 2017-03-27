//
//  GRReviewDetailViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 18/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SwiftLoader

class GRReviewDetailViewController: UIViewController, GRToolBarProtocol {
    
    var reviewId: String? {
        didSet {
            if reviewId != nil { refresh() }
        }
    }
    
    /*
     Pre-population functions
    */
    func setProductImage(_ img: UIImage) { self.managedView.productImage = img }
    func setProductTitle(_ title: String) { self.managedView.productTitle = title }
    func setProductBrand(_ brand: String) { self.managedView.productBrand = brand }
    func setUserLevel(_ level: Int) { self.managedView.userLevel = level }
    
    var onDismissed: (() -> Void)?
    
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
    
    fileprivate var managedView: GRReviewDetailView {
        return self.view as! GRReviewDetailView
    }
    
    override func loadView() {
        super.loadView()
        view = GRReviewDetailView()
        managedView.navigationToolBar.delegate = self
        managedView.navigationToolBar.isThisBarWithBackButtonAndGrocerestButton(true)
    }
    
    /**
     Prepopulates the view from cached data
    */
    func prepopulateWith(review data: JSON) {
        self.managedView.productIsScanned = data["barcode"].intValue > 0
        
        self.managedView.reviewScore = data["rating"].intValue
        let creationDate = Date(timeIntervalSince1970: data["tsCreated"].doubleValue / 1000)
        self.managedView.reviewCreationDate = creationDate
        self.managedView.reviewText = data["review"].stringValue

        
        self.managedView.username = data["author"]["username"].stringValue
        self.managedView.userReputation = data["author"]["score"].intValue
        
        if data["author"]["_id"].stringValue == GRUser.sharedInstance.id {
            self.managedView.myReview = true
            self.managedView.usefullnessCheckerStatus = .myReview
        } else {
            self.managedView.myReview = false
            self.managedView.usefullnessCheckerStatus = .active
            self.managedView.isUseful = data["voteMine"].boolValue
        }
        
        self.managedView.isFirstReview = data["first"].boolValue
        self.managedView.numberOfUseful = data["voteCount"].intValue
    }
    
    /**
     Populates the view by fetching data from GrocerestAPI
     */
    func refresh() {
        guard let reviewId = reviewId else {
            fatalError("Product Detail cannot populate itself without a review Id")
        }
        
        populateReview(reviewId)
    }
    
    fileprivate func populateReview(_ id: String) {
        GrocerestAPI.getReview(reviewId: id) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            if data["error"]["code"].stringValue == "E_NOT_FOUND" {
                self.dismiss()
                let alert = UIAlertController(title: "Errore", message: "Impossibile visualizzare la recensione richiesta", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let img = data["product"]["images"]["medium"].string {
                let imgUrl = NSURL(string: String.fullPathForImage(img))!
                self.managedView.setProductImageFrom(imgUrl as URL)
            } else {
                if let category = data["product"]["category"].string  {
                    self.managedView.productImage = UIImage(named: "products_" + category)
                }
            }
            
            self.managedView.productTitle = data["product"]["display_name"].stringValue
            self.managedView.productBrand = data["product"]["display_brand"].stringValue
            self.managedView.productIsScanned = data["barcode"].intValue > 0
            
            let productOrThumbnailTappedCallback = {
                let productDetail = GRProductDetailViewController()
                productDetail.productId = data["product"]["_id"].stringValue
                self.navigationController?.pushViewController(productDetail, animated: true)
            }
            self.managedView.onProductThumbnailTapped = productOrThumbnailTappedCallback
            self.managedView.onProductTapped = productOrThumbnailTappedCallback
                
            self.managedView.reviewScore = data["rating"].intValue
            let creationDate = NSDate(timeIntervalSince1970: data["tsCreated"].doubleValue / 1000)
            self.managedView.reviewCreationDate = creationDate as Date
            self.managedView.reviewText = data["review"].stringValue
            
            let type = AvatarType.cells
            self.managedView.profileImageView.setUserProfileAvatar(data["author"]["picture"].stringValue, name: data["author"]["firstname"].stringValue, lastName: data["author"]["lastname"].stringValue, type: type)

            
            self.managedView.username = data["author"]["username"].stringValue
            self.managedView.userReputation = data["author"]["score"].intValue
            self.managedView.userLevel = data["author"]["level"].intValue
            self.managedView.userReviewsCount = data["author"]["reviewsCount"].intValue
            
            if data["author"]["_id"].stringValue != GrocerestAPI.userId {
                self.managedView.onUserTapped = {
                    let userProfile = GRUserProfileViewController()
                    userProfile.author = data["author"]
                    self.navigationController?.pushViewController(userProfile, animated: true)
                }
            }
            
            if data["author"]["_id"].stringValue == GRUser.sharedInstance.id {
                self.managedView.myReview = true
                self.managedView.usefullnessCheckerStatus = .myReview
                
                self.managedView.onUpdateButtonTapped = {
                    let id = data["product"]["_id"].stringValue
                    
                    GrocerestAPI.getProduct(id) { product, err in
                        
                        if GrocerestAPI.isRequestUnsuccessful(for: product, and: err) {
                            return
                        }
                        
                        let recensioneViewController = GRModalRecensioneViewController()
                        recensioneViewController.product = product
                        recensioneViewController.onDismissed = { reviewHasBeenDeleted in
                            if reviewHasBeenDeleted {
                                self.onDismissed?()
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                self.refresh()
                            }
                        }
                        recensioneViewController.modalTransitionStyle = .coverVertical
                        self.present(recensioneViewController, animated: true, completion: nil)
                    }
                }
            } else {
                self.managedView.myReview = false
                self.managedView.usefullnessCheckerStatus = .active
                
                self.managedView.isUseful = data["voteMine"].boolValue
                
                self.managedView.onUsefullnessButtonTapped = {
                    self.managedView.numberOfUseful += self.managedView.isUseful ? -1 : 1
                    self.managedView.isUseful = !self.managedView.isUseful
                    SwiftLoader.show(animated: true)
                    GrocerestAPI.toggleUsefulnessVote(reviewId: data["_id"].stringValue) { _,_ in
                        SwiftLoader.hide()
                    }
                }
                
                self.managedView.onReportButtonTapped = {
                    let reportViewController = GRReportViewController()
                    reportViewController.currentReview = data
                    self.present(reportViewController, animated: true, completion: { 
                        
                    })
                
                
                }
            }
            
            self.managedView.onShareButtonTapped = {
                SwiftLoader.show(animated: true)
                GrocerestAPI.getReviewPermalink(for: data["_id"].stringValue) { permalink, error in
                    SwiftLoader.hide()
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: permalink, and: error) {
                        return
                    }
                    
                    let activity = UIActivityViewController(
                        activityItems: [ReviewSharingActivitySource(review: data, permalink: permalink["url"].stringValue)],
                        applicationActivities: nil
                    )
                    activity.popoverPresentationController?.sourceView = self.managedView
                    activity.excludedActivityTypes = ExcludedActivitySources
                    self.present(activity, animated: true, completion: nil)
                }
            }
            
            self.managedView.isFirstReview = data["first"].boolValue
            self.managedView.numberOfUseful = data["voteCount"].intValue
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
        dismiss()
    }
    
    fileprivate func dismiss() {
        onDismissed?()
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
