//
//  GRModalRecensioneViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 08/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import SwiftyJSON
import RealmSwift
import SwiftLoader
import FBSDKCoreKit
import Google

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

/// This controller launches the modal view where users complete the review for selected product

class GRModalRecensioneViewController: UIViewController, GRAfterReviewProtocol, GRReviewBoxWriteCommentProtocol, UITextViewDelegate {
    
    var originalReview:JSON?
    var pageTitle : String?
    var product : JSON?
    let realm = try! Realm()
    var currentReview = ""
    var commanderList = ""
    var recensione : JSON?
    var delegate:GRUserCategorizedProductsProtocol?
    var modalDelegate:GRModalViewControllerDelegate?
    var onDismissed: ((_ reviewHasBeenDeleted: Bool) -> Void)?
    var savingActive = false
    var replicationDelegate:GRVoteReplicationProtocol?
    
    var rating = 0
    var review = ""
    var frequency = ""
    var barcode = ""
    var ready = false
    
    var unsavedVoteValue = 0
    
    func currentProductId() ->  String {
        return product!["_id"].stringValue
    }
    
    func currentUserId() -> String {
        return GRUser.sharedInstance.id ?? ""
    }
    
    func currentRating() -> Int {
        return Int(recensione!["rating"].string!) ?? 0
    }
    
    func currentEAN() -> String {
        if let ean = self.product?["ean"].string {
            return ean
        }
        if let eans = self.product?["ean"].array {
            if (eans.count > 0) {
                return eans[0].stringValue;
            }
        }
        return ""
    }
    
    func reviewAuthor(_ author: JSON) -> String {
        return author.stringValue
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hidesBarsOnTap = false
        navigationController?.isNavigationBarHidden = true
        
        getUserProductsList()
        getReviewDataForProduct()
        productScannedNotPointsAssigned()
        voteChainedReaction()
        frequencyVote()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO Replace this with delegate
        getUserProductsList()
        analyticsProbe()
    }
    
    func prepareProductWithUnsavedVote(_ vote: Int) {
        if vote > 0 {
            ready = true
            self.setActionButtonAsReady()
            self.chainedButtonState(unsavedVoteValue)
            productWasVoted()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        var contentHeight : CGFloat = 220.0 / masterRatio
        for view in self.managedView.viewsByName["__scaling__"]!.subviews{
            contentHeight = contentHeight + view.frame.height
        }
        let scrollView = self.managedView.viewsByName["__scaling__"]! as! UIScrollView
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, contentHeight)
         */
        
        prepareProductWithUnsavedVote(unsavedVoteValue)
        
        if recensione != nil  {
            self.chainedButtonState(currentRating())
        }
        
        assingBarCodeOnVote()
    }
    
    fileprivate var managedView: GRModalRecensioneView {
        return self.view as! GRModalRecensioneView
    }
    
    override func loadView() {
        super.loadView()
        view = GRModalRecensioneView()
        managedView.delegate = self
    }
    
    func setupViews() {
        managedView.recensioneTextView.delegate = self
        
        if product != nil {
            managedView.updateViewWithData(product!, imagesURL: getImagesPath())
            self.managedView.deleteButton.isHidden = true
        }
    }
    
    func assingBarCodeOnVote() {
        getUserProductsList() { // be sure our local reviews are updated
            if getScannedProductsFromLocal().contains(self.currentProductId()) {
                self.barcode = self.currentEAN()
                self.setActionButtonAsReady()
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {}
    
    func getReviewDataForProduct() {
        SwiftLoader.show(animated: true)
        
        let fields = [
            "author": currentUserId(),
            "product": currentProductId()
        ]
    
        GrocerestAPI.searchForReview(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                return
            }
            
            if self.product!["reviews"]["count"].intValue == 0 || data["reviews"][0]["first"].boolValue {
                self.managedView.isFirstReview(true)
            } else {
                self.managedView.isFirstReview(false)
            }

            guard data["reviews"].count == 1 else {
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.changeStatusLabelusingData(false)
                }
                return
            }
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.managedView.willShowDeleteReviewButton()
                self.changeStatusLabelusingData(true)
                
                let review = data["reviews"][0]
                self.originalReview = review
                
                if self.product!["reviews"]["count"].intValue == 0 || data["reviews"][0]["first"].boolValue {
                    
                } else {
                    self.managedView.isFirstReview(false)
                }
                
                if let tsCreated = review["tsCreated"].int {
                    self.managedView.formatLabelWhenHasDate(self.fromDateToString(tsCreated))
                }
                
                if let reviewText = review["_id"].string {
                    self.currentReview = reviewText
                }
                
                if let frequency = review["frequency"].string {
                    if !frequency.isEmpty {
                        self.managedView.frequencySegment?.setHighlight(self.reverseFrequencyVote(frequency))
                        self.productWasFrequencyVoted()
                    }
                }
                
                if let ownReview = review["review"].string {
                    self.review = ownReview
                    self.managedView.formatTextViewWithAutoHeight(ownReview)
                    self.productWasReviewed()
                }
                
                if let ownBarcode = review["barcode"].string {
                    self.barcode = ownBarcode
                    self.productWasScanned()
                    
                }
                
                if self.unsavedVoteValue == 0  {
                    self.rating = (Helper.ratingRetroCompatibility(review) as! Int) ?? 0
                    if self.rating > 0 {
                        self.chainedButtonState(self.rating)
                        self.productWasVoted()
                    }
                }
            }
            
        }
    }
    
    
    // MARK: Saving || Updating reviews
    
    func postVoteForItem(_ fields:[String: Any]) {
        
        GrocerestAPI.postReview(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                if let errorMessage = data["error"]["message"].string {
                    self.showErrorAlertWithTitleAndMessage("Attenzione", message: "\(errorMessage)")
                }
                return
            }
            
            if let reviewId = data["_id"].string {
                self.currentReview = reviewId
            }
            
            let textWasAdded:Bool = !JSON(fields)["review"].stringValue.isEmpty
            if textWasAdded {
                FBSDKAppEvents.logEvent("comment")
            }
            
            getUserProductsList()
            self.delegate?.reloadDataSourceForList?(self.commanderList)
            self.replicationDelegate?.updateVote(self.unsavedVoteValue)
            
            self.dismiss(animated: true, completion: {
                self.modalDelegate?.modalWasDismissed?(self)
                self.onDismissed?(false)
            })
            
        }
        
    }
    
    
    
    func updateCurrentReview(_ review:String, fields: [String: Any]) {
        DispatchQueue.main.async {
            GrocerestAPI.updateReview(reviewId: self.currentReview, fields: fields) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    if let errorMessage = data["error"]["message"].string {
                        self.showErrorAlertWithTitleAndMessage("Attenzione", message: "\(errorMessage)")
                        return
                    }
                    return
                }
                
                // means we added a text to a review that did not have it before
                if let originalReview = self.originalReview?["review"].stringValue {
                    let review = JSON(fields)["review"].stringValue
                    if originalReview.isEmpty && !review.isEmpty {
                        // Text was added
                        FBSDKAppEvents.logEvent("comment")
                    }
                }
                
                getUserProductsList()
                self.delegate?.reloadDataSourceForList?(self.commanderList)
                self.replicationDelegate?.updateVote(self.unsavedVoteValue)
                self.dismiss(animated: true) {
                    self.modalDelegate?.modalWasDismissed?(self)
                    self.onDismissed?(false)
                }
            }
        }
    }
    
    func productScannedNotPointsAssigned() {
        if getScannedProductsFromLocal().contains(currentProductId()) {
            self.managedView.scannerIcon.image = UIImage(named: "v2_scanned_complete")
            self.managedView.scanLabel.text = Constants.ReviewLabels.barcodeScanned
            self.managedView.scanLabel.textColor = UIColor.greenGrocerestColor()
            self.managedView.scannButton.isHidden = true
            
            self.managedView.separator4.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(self.managedView.snp.width)
                make.height.equalTo(0.5)
                make.top.equalTo(self.managedView.scanLabel.snp.bottom).offset(100 / masterRatio)
                make.left.equalTo(0)
            }
            
            self.managedView.deleteView.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(self.managedView.snp.width)
                make.height.equalTo(79 / masterRatio)
                make.top.equalTo(self.managedView.separator4.snp.bottom).offset(10 / masterRatio)
            }
        }
    }
    
    func productScannedWithPointsAssigned() {
        managedView.copafourImageView.image = UIImage(named: "v2_points_assigned")
        managedView.scannButton.isHidden = true
        managedView.separator4.snp.remakeConstraints { make in
            make.width.equalTo(self.managedView.snp.width)
            make.height.equalTo(0.5)
            make.top.equalTo(self.managedView.scanLabel.snp.bottom).offset(100 / masterRatio)
            make.left.equalTo(0)
        }
        
        managedView.deleteView.snp.remakeConstraints { make in
            make.width.equalTo(self.managedView.snp.width)
            make.height.equalTo(79 / masterRatio)
            make.top.equalTo(self.managedView.separator4.snp.bottom).offset(10 / masterRatio)
        }
    }
    
    func barcodeDoesNotFit() {
        barcode = ""
        managedView.scannerIcon.image = UIImage(named: "scanner_profilev")
        managedView.scanLabel.text = Constants.ReviewLabels.scanBarcodeLegend
        managedView.scanLabel.textColor = UIColor.grocerestDarkGrayText()
        managedView.copafourImageView.image = UIImage(named: "v2_points_unassigned")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { // Or 0.1 seconds
            self.showErrorAlertWithTitleAndMessage("Attenzione", message: "Questo codice a barre non corrisponde al prodotto")
        }
    }
    
    func verifyStatusOfProduct() {
        
        if getScannedProductsFromLocal().contains(currentProductId()) {
            //Why this is empty
        }
        
        if getTryableProductsFromLocal().contains(currentProductId()) {
            
            GrocerestAPI.removeProductToPredefinedList(GRUser.sharedInstance.id!, listName: Constants.PredefinedUserList.totry, productId: currentProductId()) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }
                
                if self.currentReview == "" {
                    self.postVoteForItem(self.votingData(self.currentProductId(), rating: self.rating, review: self.review, frequency: self.frequency, barcode: self.barcode))
                } else {
                    self.updateCurrentReview(self.currentReview, fields: self.votingData(self.currentProductId(), rating: self.rating, review:  self.review, frequency: self.frequency, barcode: self.barcode))
                }
            }
        } else {
            if self.currentReview == "" {
                self.postVoteForItem(self.votingData(self.currentProductId(), rating: self.rating, review: self.review, frequency: self.frequency, barcode: self.barcode))
            } else {
                self.updateCurrentReview(self.currentReview, fields: self.votingData(self.currentProductId(), rating: self.rating, review:  self.review, frequency: self.frequency, barcode: self.barcode))
            }
            
        }
    }
    
    func changeStatusLabelusingData(_ reviewed: Bool) {
        var textStatus = ""
        
        if reviewed {
            if getFullyReviewdProductsFromLocal().contains(currentProductId()) {
                textStatus = Constants.ReviewLabels.updateReview
            } else {
                textStatus = Constants.ReviewLabels.completeReview
            }
            
            self.managedView.formatViewForProductWithReview(textStatus)
            ready = true
        } else {
            managedView.recensioneStatutsLabel!.text = Constants.ReviewLabels.yourOpinion
        }
    }
    
    // MARK: Delegated
    
    //Delegate Passing review from CommentModalViewController
    func passProductReview(_ review: String, indexRow: Int, currentReview: String) {
        if review.characters.count > 0 {
            managedView.formatTextViewWithAutoHeight(review)
            productWasReviewed()
            managedView.recensioneTextView.text = review
            self.review = review
            
            if ready == false {
                setActionButtonAsDisabled()
            } else {
                setActionButtonAsReady()
            }
        }
    }
    
    // When comming back from scann, will check if EAN matches
    func foundedEAN(_ ean:String) {
        // 1. does match?
        if let existingEAN = product!["ean"].string {
            if Int(existingEAN) != Int(ean) {
                self.barcodeDoesNotFit()
                return
            }
        }
        
        if let existingEANs = product!["ean"].array {
            let matchingEAN = existingEANs.filter { $0.intValue == Int(ean) }
            if matchingEAN.count == 0 {
                barcodeDoesNotFit()
                return
            }
        }
        
        barcode = ean
        
        // 2. keep it alive
        
        // 3. Save it to users list
        managedView.scannButton.isHidden = true
        addToScannedList(currentProductId())

        // 4. If another action was perfored then act on button
        if ready == false {
            setActionButtonAsDisabled()
        } else {
            setActionButtonAsReady()
        }
        
        // 5.  update view based on result
        productWasScanned()
    }
    
    // MARK: Buttons || Actions
    
    func voteWasPressed(_ sender: UIButton) {
        chainedButtonState(sender.tag)
        rating = sender.tag
        productWasVoted()
        ready = true
        setActionButtonAsReady()
    }
    
    
    func actionFrequencyWasPressed (_ sender: UIButton) {
        managedView.frequencySegment?.setHighlight(sender.tag + 1)
        productWasFrequencyVoted()
        var freq = ""
        
        switch sender.tag {
        case 0:
            freq = Constants.FrequencyLabels.first
        case 1:
            freq = Constants.FrequencyLabels.rarely
        case 2:
            freq = Constants.FrequencyLabels.once
        case 3:
            freq = Constants.FrequencyLabels.weekly
        case 4:
            freq = Constants.FrequencyLabels.every
        default:
            freq = ""
        }
        
        frequency = freq
        
        if ready == false {
            setActionButtonAsDisabled()
        } else {
            setActionButtonAsReady()
        }
    }
    
    func commentButtonWasPressed(_ sender: UIButton) {
        let grCommentViewController = GRCommentModalViewController()
        grCommentViewController.product = product
        grCommentViewController.fromProfile = true
        grCommentViewController.lastReviewText = review
        grCommentViewController.currentReview = currentReview
        grCommentViewController.reviewDelegate = self
        present(grCommentViewController, animated: true, completion: nil)
    }
    
    func scanButtonWasPressed(_ sender: UIButton) {
        let scannerViewController = GRBarcodeScannerViewController()
        scannerViewController.fromProfile = true
        scannerViewController.delegate = self
        scannerViewController.modalPresentationStyle = .fullScreen
        present(scannerViewController, animated: false, completion: nil)
    }
    
    
    func saveWasPressed(_ sender: UIButton) {
        verifyStatusOfProduct()
    }
    
    func closeButtonWasPressed(_ sender: UIButton) {
        let fullList = GRPredefinedListViewController()
        let reload = fullList.responds(to: #selector(GRUserCategorizedProductsProtocol.reloadDataSourceForList(_:)))
        delegate?.reloadDataSourceForList?(commanderList)
        modalDelegate?.modalWasDismissed?(self)
        onDismissed?(false)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Updating Views
    
    func productWasVoted() {
        managedView.formatViewForProductWasVoted()
        if getScannedProductsFromLocal().contains(currentProductId()) {
            productScannedWithPointsAssigned()
        }
    }
    
    func chainedButtonState(_ sender: Int) {
        rating = sender
        managedView.formatViewForChainedButtonState(sender)
    }
    
    func productWasReviewed() {
        managedView.formatViewForProductWasReviewed()
    }
    
    func productWasFrequencyVoted() {
        managedView.formatViewForProductWasFrequencyVoted()
    }
    
    func frequencyVote() {
        managedView.formatViewForFrequencyVote()
    }
    
    func productWasScanned() {
        managedView.formatViewForProductWasScanned()
    }
    
    func voteChainedReaction(){
        managedView.formatViewForVoteChainedReaction()
    }
    
    func setActionButtonAsDisabled() {
        managedView.formatViewForActionButtonAsDisabled()
    }
    
    func setActionButtonAsReady() {
        var changed = false
        if originalReview?["rating"].intValue != rating {
            changed = true
        }
        if originalReview?["review"].stringValue != review {
            changed = true
        }
        if self.frequency.characters.count > 0 {
            if originalReview?["frequency"].stringValue != frequency {
                changed = true
            }
        }
        if Int(self.barcode) > 0 {
            if self.originalReview?["barcode"].intValue != Int(barcode) {
                changed = true
            }
        }
        
        managedView.formatViewForActionButtonAsReady(changed)
    }
    
    func deleteButtonWasPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Attenzione", message: "Vuoi eliminare questa recensione?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Si", style: .destructive) { (alert: UIAlertAction) -> Void in
            GrocerestAPI.deleteReview(reviewId: self.currentReview) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }
                
                self.delegate?.reloadDataSourceForList?(self.commanderList)
                
                self.dismiss(animated: true) {
                    self.modalDelegate?.modalWasDismissed?(self)
                    self.onDismissed?(true)
                }
            }
            
        }
        let cancel = UIAlertAction(title: "No", style: .default)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func addToScannedList(_ productId: String, completion: (() -> Void)? = nil) {
        GrocerestAPI.addProductToPredefinedList(GRUser.sharedInstance.id!, listName: "scanned", fields: ["product": productId]) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                completion?()
                return
            }
        }
    }
    
    // MARK: Utilities
    
    func analyticsProbe() {
        title = "Create Recensione Full View"
        let name = "Pattern~\(self.title!)"
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as [NSObject: AnyObject]?)
    }
    
    func votingData(_ product: String, rating: Int, review: String, frequency: String, barcode: String) -> [String: Any] {
        
        var fields = [String: Any]()
        
        if product != "" {
            fields["product"] = product
        }
        if rating != 0 {
            fields["rating"] = rating
        }
        if review != "" {
            fields["review"] = review
        }
        
        if frequency != "" {
            fields["frequency"] = frequency
        }
        
        if barcode != "" {
            fields["barcode"] = barcode
        }
        
        return fields
    }
    
    func reverseFrequencyVote(_ vote: String) -> Int {
        switch vote {
        case Constants.FrequencyLabels.first:
            return 1
        case Constants.FrequencyLabels.rarely:
            return 2
        case Constants.FrequencyLabels.once:
            return 3
        case Constants.FrequencyLabels.weekly:
            return 4
        case Constants.FrequencyLabels.every:
            return 5
        default:
            return 0
        }
    }
    
    func fromDateToString(_ date: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let myDate = dateFormatter.string(from: convertFromTimestamp("\(date)"))
        return String(myDate)
    }
    
    // MARK: Handle net errors
    
    func showErrorAlertWithTitleAndMessage(_ title: String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.UserMessages.ok, style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
