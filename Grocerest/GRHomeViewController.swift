//
//  GRHomeViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 02/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftLoader
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Google
import Contacts


class GRHomeViewController: UIViewController, GRToolBarProtocol, GRReviewBoxWriteCommentProtocol, ENSideMenuDelegate, GRPostReviewProtocol, GRAfterReviewProtocol, GRUpdateHomeListProtocol, UIScrollViewDelegate {

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden : Bool {
        return false
    }

    let loadingProductsView = GRHomeCollectionLoadingViewCell()
    let loadingTopListView = GRLoadingTopListView()

    var dataSource : [JSON]? = []
    var userListsDataSource: JSON?
    var listDataSource : JSON?
    var reviewData = [JSON]()

    var latestReviews = [JSON]()

    var menuDataDelegate = GRMenuViewController()
    var collectionView : UICollectionView?
    var currentProduct = IndexPath(row: 0, section: 0)


    var launchTutorial = true
    let userDefaults = UserDefaults.standard

    var shoppingListId = ""
    var currentReview = ""

    var idFromSlug:[String: String] = [:]

    fileprivate var pointNow : CGPoint?

    var requestedItems = ["limit": 20]

    fileprivate var inviteFriendsHeight = 550 / masterRatio

    var productId: String {
        get {
            if let productId =  self.dataSource![currentProduct.row]["_id"].string {
                return productId
            }
            return ""
        }
    }

    var rating = {(productId: String, rate: Int) -> [String: Any] in
        return [
            "product": productId,
            "rating": rate
        ]
    }


    var frequency = {(productId:String, value:Int) -> [String: Any] in
        var fields = [
            "product": productId
        ]

        switch value {
        case 1:
            fields["frequency"] = Constants.FrequencyLabels.first
        case 2:
            fields["frequency"] = Constants.FrequencyLabels.rarely
        case 3:
            fields["frequency"] = Constants.FrequencyLabels.once
        case 4:
            fields["frequency"] = Constants.FrequencyLabels.weekly
        case 5:
            fields["frequency"] = Constants.FrequencyLabels.every
        default:
            fields["frequency"] = ""
        }

        return fields
    }


    var tableView : UITableView!

    override func viewDidLoad() {
        getCurrentConfiguration()
        configureNavigationController()
        isUserValid()
        downloadProducts()
        prepareViews()

        // MARK: DOING
        self.managedView.reviewsToCompleteView.onTap =  { review in
            let recensioneViewController = GRModalRecensioneViewController()
            recensioneViewController.product = review["product"]
            //recensioneViewController.onDismissed = { _ in self.refresh() }
            recensioneViewController.modalTransitionStyle = .coverVertical
            self.present(recensioneViewController, animated: true, completion: nil)
        }


        self.managedView.categoriesView.onTap = { categorySlug in
            let productsListViewController = GRProductsListViewController()
            productsListViewController.pageTitle = categorySlug
            productsListViewController.categoryId = self.idFromSlug[categorySlug]!
            self.navigationController?.pushViewController(productsListViewController, animated: true)
        }

        super.viewDidLoad()
    }

    func formatLatestReviews() {
        self.managedView.latestReviewsPlaceHolder.isHidden = true
        self.managedView.lastReview.reviews = latestReviews
        
        for review in self.managedView.lastReview.lastReviews {
            review.onReviewTapped = {
                let reviewDetail = GRReviewDetailViewController()
                reviewDetail.reviewId = review.reviewId!
                self.navigationController?.pushViewController(reviewDetail, animated: true)
            }
            
            review.onUserTapped = {
                let userProfile = GRUserProfileViewController()
                userProfile.author = review.author
                self.navigationController?.pushViewController(userProfile, animated: true)
            }

            let productTitleOrThumbnailTappedCallback = {
                let productDetail = GRProductDetailViewController()
                productDetail.productId = review.productId!
                self.navigationController?.pushViewController(productDetail, animated: true)
            }
            
            review.onProductThumbnailTapped = productTitleOrThumbnailTappedCallback
            review.onProductTapped = productTitleOrThumbnailTappedCallback
        }
    }

    func formatBallonController() {
        let pointsToNextLevel = GRUserStats.sharedInstance.levelEnd! - GRUserStats.sharedInstance.score!

        managedView.ballonView.username = GRUser.sharedInstance.username
        managedView.ballonView.level = (GRUserStats.sharedInstance.level?.hashValue)!
        managedView.ballonView.scoreToNextLevel = pointsToNextLevel.hashValue
        managedView.ballonView.reputation = (GRUserStats.sharedInstance.score?.hashValue)!
        managedView.ballonView.reviews = (GRUserStats.sharedInstance.reviews?.hashValue)!
        managedView.ballonView.setUserProfileAvatar(GRUser.sharedInstance.picture!, name: GRUser.sharedInstance.firstname!, lastName: GRUser.sharedInstance.lastname!)
        managedView.ballonView.onUserImageTap = {
            let userProfileViewController = GRProfileViewController()
            userProfileViewController.showBackButton()
            self.navigationController?.pushViewController(userProfileViewController, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        latestReviews.removeAll()
        addPageTracker()
        getCurrentConfiguration() {
            self.getLatestReviewsFor()
            self.getDataForUserStats()
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        formatBallonController()
        getIncompleteReviewsFor()
        formatLatestReviews()
        
        // here we know the app is ready (user is logged, bearer is valid, i guess)
        DeepLinksManager.applicationReadySet()
        GRLocalNotificationHUB.mayProcessPendingNotification()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var managedView: GRHomeView {
        return self.view as! GRHomeView
    }

    override func loadView() {
        view = GRHomeView()
        managedView.delegate = self
    }

    override func viewWillLayoutSubviews() {
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }


    /**
     Collections View

     - parameter sender:
     */
    func prepareViews() {

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 910 / masterRatio)
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        collectionView!.register(GRHomeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView!.backgroundColor = UIColor.clear

        self.managedView.pageControllerGhostView!.addSubview(collectionView!)

        collectionView!.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(920 / masterRatio)
            make.top.equalTo(0 / masterRatio)
            make.left.equalTo(0)
        })

        // Products

        self.managedView.pageControllerGhostView!.addSubview(loadingProductsView)

        loadingProductsView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(920 / masterRatio)
            make.top.left.equalTo(0)
        }

        // Top shopping lists

        self.managedView.inviteFriendsButton.snp.makeConstraints { make in
            make.left.equalTo(0)
        }
        self.managedView.latestLists?.addSubview(loadingTopListView)
    }


    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = CGPoint()
        pointNow = scrollView.contentOffset
    }


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageWidth = scrollView.frame.size.width
        let row = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        currentProduct = IndexPath(row: row, section: 0)
        self.isProductReviewed(self.productId, indexPath: currentProduct)

    }

    
    func getAverageScore(_ reviews: Int, average: Double) -> Double {
        
        let _average = average / Double(reviews)
        return Double(_average)
    }


    // 1. Rating for Product

    func postVoteForItem(_ sender:UIButton) {

        let cell: GRHomeCollectionViewCell! = collectionView?.cellForItem(at: currentProduct) as! GRHomeCollectionViewCell
        cell.reviewScrollView.chainedButtonState(sender.tag)
        
        let reviewsCount = self.dataSource![self.currentProduct.row]["reviews"]["count"].intValue
        
        let averageCount = self.dataSource![self.currentProduct.row]["reviews"]["average"].doubleValue
        
        let calculatedVote = averageCount * Double(reviewsCount)
        
        let optimisticAverage = getAverageScore(reviewsCount + 1, average: calculatedVote + Double(sender.tag))
        
        if self.currentReview == "" {

            DispatchQueue.main.async {
                cell.toTryButton.isHidden = true
                cell.numberOfReviews = Int(reviewsCount) + 1
                cell.averageReviewScore = optimisticAverage
                cell.swicthFirstReviewWidget(true)
                self.tryProductStatus(self.dataSource![self.currentProduct.row]["_id"].stringValue)
                
            }

            GrocerestAPI.postReview(self.rating(self.productId, sender.tag)) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                        cell.reviewScrollView.chainedButtonState(0)
                    }
                    
                    if data["error"]["code"].stringValue == "E_UNAUTHORIZED" {
                        DispatchQueue.main.async { self.noUserOrInvalidToken() }
                    }
                    
                    return
                }

                if let reviewId = data["_id"].string {
                    DispatchQueue.main.async {
                        self.currentReview = reviewId
                        cell.reviewScrollView.paginatedScrollView.isScrollEnabled = true
                    }

                }
            }

        } else {
            DispatchQueue.main.async {
                cell.numberOfReviews = Int(reviewsCount) + 1
                cell.averageReviewScore = optimisticAverage
                self.updateVote(self.currentReview, fields: self.rating(self.productId, sender.tag), cell: cell)
            }
        }
    }

    // 1.1 Update rating

    func updateVote(_ reviewId:String, fields: [String: Any], cell: GRHomeCollectionViewCell) {
        GrocerestAPI.updateReview(reviewId: reviewId, fields: fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async {
                    cell.reviewScrollView.chainedButtonState(0)
                    SwiftLoader.hide()
                }
                return
            }

            DispatchQueue.main.async {
                SwiftLoader.hide()
                cell.reviewScrollView.paginatedScrollView.isScrollEnabled = true
            }
        }
    }

    // 2. Vote frequency
    
    func postFrequency(_ sender:UIButton) {
        let cell = collectionView?.cellForItem(at: currentProduct) as! GRHomeCollectionViewCell
        
        GrocerestAPI.updateReview(reviewId: currentReview, fields: frequency(productId, sender.tag)) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                return
            }
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                cell.reviewScrollView.viewFrequency?.setHighlight(sender.tag)
            }
        }
    }

    // 3. Textual Review
    func commetWasPressed(_ sender: UIButton) {
        let grCommentViewController = GRCommentModalViewController()
        grCommentViewController.product = dataSource![sender.tag]
        grCommentViewController.indexRow = sender.tag
        grCommentViewController.currentReview = currentReview
        grCommentViewController.reviewDelegate = self
        present(grCommentViewController, animated: true, completion: nil)
    }

    func reopenCommentWasPressed(_ textView: UITextView) {
        let grCommentViewController = GRCommentModalViewController()
        grCommentViewController.product = dataSource![textView.tag]
        grCommentViewController.indexRow = currentProduct.row
        grCommentViewController.lastReviewText = textView.text
        grCommentViewController.currentReview = currentReview
        grCommentViewController.reviewDelegate = self
        present(grCommentViewController, animated: true, completion: nil)
    }

    func passProductReview(_ review:String, indexRow: Int, currentReview: String) {
        let indexPath = IndexPath(row: indexRow, section: 0)
        if let cell = collectionView?.cellForItem(at: indexPath) as? GRHomeCollectionViewCell {
            cell.reviewScrollView.viewComment?.commentUpdate(review, currentReview: currentReview, indexPathRow: indexRow)
            cell.reviewScrollView.viewComment?.delegate = self
        }
    }

    // MARK: Buttons

    func menuButtonWasPressed(_ menuButton: UIButton) {
        menuDataDelegate.getUserDataAndUpdateProfile()
        toggleSideMenuView()
    }

    func scannerButtonWasPressed(_ sender: UIButton){
        let scannerViewController = GRBarcodeScannerViewController()
        navigationController?.pushViewController(scannerViewController, animated: false)
    }

    func searchButtonWasPressed(_ searchButton: UIButton){
        let productSearch = GRProductSearchViewController()
        navigationController?.pushViewController(productSearch, animated: true)
    }

    func newlistButtonWasPressed(_ sender: UIButton){
        let myListViewController = GRCreateListViewController()
        myListViewController.listDelegate = self
        myListViewController.modalTransitionStyle = .coverVertical
        myListViewController.modalPresentationStyle = .overCurrentContext
        navigationController?.present(myListViewController, animated: true, completion: nil)
    }

    var mystring: String = "Invitation"
    
    var url:URL?
    
    //var textToShare:[] = []

    func inviteFriendsWasPressed(_ sender:UIButton) {
        SwiftLoader.show(title: "Generazione invito…", animated: true)
        
        let activitySource = CustomActivitySource()
        activitySource.prepare {
            SwiftLoader.hide()
            
            let activityViewController = UIActivityViewController(
                activityItems: [activitySource],
                applicationActivities: nil
            )
            activityViewController.popoverPresentationController?.sourceView = self.managedView
            activityViewController.excludedActivityTypes = ExcludedActivitySources
            self.present(activityViewController, animated: true, completion: nil)
        }
    }

    func contactsWasPressed(_ sender:UIButton) {
        let inviteFriendsController = GRInviteTableViewController()
        present(inviteFriendsController, animated: true, completion: nil)
    }

    func fbcontactsWasPressed(_ sender:UIButton) {
    }

    func profileButtonWasPressed(_ sender: UIButton) {
        let destViewController = GRProfileViewController()
        sideMenuController()?.setContentViewController(destViewController)
    }

    func actionProductButtonWasPressed(_ sender:UIButton) {
        if let product = dataSource?[sender.tag] {
            let productDetail = GRProductDetailViewController()
            productDetail.prepopulateWith(product: product)
            productDetail.productId = product["_id"].stringValue
            navigationController?.pushViewController(productDetail, animated: true)
        }
    }

    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {}

    func sideMenuWillClose() {}

    func sideMenuShouldOpenSideMenu() -> Bool { return true }

    func sideMenuDidClose() {}

    func sideMenuDidOpen() {}

    func updateListProtocol() {}

    func noUserOrInvalidToken() {
        let welcomeViewController = GRWelcomeViewController()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        navigationController?.setViewControllers([welcomeViewController], animated: false)
    }
    
    func getNumberOfReviewsAndAverageScore(_ productId: String) -> [String:String] {
        var currentValues : [String : String] = [:]
        for item in self.dataSource!{
            if item["_id"].stringValue == productId {
                currentValues["count"] = item["reviews"]["count"].stringValue
                currentValues["average"] = item["reviews"]["average"].stringValue
            }
        }
        return currentValues
    }
    
    func isProductReviewed(_ productId: String, indexPath: IndexPath) {
        self.reviewData = []
        self.currentReview = ""
        
        let fields = [
            "author": GRUser.sharedInstance.id!,
            "product": self.productId
        ]
    
        GrocerestAPI.searchForReview(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }

            if let reviewId = data["reviews"][0]["_id"].string {
                self.currentReview = reviewId
            } else {
                self.currentReview = ""
            }

            DispatchQueue.main.async {
                self.setDataForProductWithReview(data["reviews"][0], count:data["count"].doubleValue  , indexPath: indexPath)
            }
        }
    }

    func setDataForProductWithReview(_ data:JSON, count: Double, indexPath: IndexPath) {
        if collectionView?.cellForItem(at: indexPath) == nil { return }
        let prevoteReviews = Int(getNumberOfReviewsAndAverageScore(self.productId)["count"]!)!
        let prevoteAverage = Double(getNumberOfReviewsAndAverageScore(self.productId)["average"]!)!
        
        let calculatedVote = prevoteAverage * Double(prevoteReviews)
        
        let optimisticAverage = getAverageScore(prevoteReviews + 1, average: calculatedVote + data["rating"].doubleValue)

        let cell = collectionView?.cellForItem(at: indexPath) as! GRHomeCollectionViewCell

        let actualRating =  Helper.ratingRetroCompatibility(data) as! Int

        if count > 0 {
            cell.toTryButton.isHidden = true
            cell.numberOfReviews = prevoteReviews + 1
            cell.averageReviewScore = optimisticAverage
            cell.swicthFirstReviewWidget(true)
        }

        if actualRating > 0  {
            cell.reviewScrollView.simulateButtonPress(actualRating)
            cell.reviewScrollView.paginatedScrollView.isScrollEnabled = true
        } else {
            cell.reviewScrollView.paginatedScrollView.isScrollEnabled = false
        }

        if let frequency = data["frequency"].string {
            var freq = 0
            switch frequency {
            case Constants.FrequencyLabels.first:
                freq = 1
            case Constants.FrequencyLabels.rarely:
                freq = 2
            case Constants.FrequencyLabels.once:
                freq = 3
            case Constants.FrequencyLabels.weekly:
                freq = 4
            case Constants.FrequencyLabels.every:
                freq = 5
            default:
                freq = 1
            }

            cell.reviewScrollView.viewFrequency?.setHighlight(freq)
        }

        if let review = data["review"].string {
            cell.reviewScrollView.viewComment!.reviewLabel.isHidden = true
            cell.reviewScrollView.viewComment!.writeCommentButton?.isHidden = true
            cell.reviewScrollView.viewComment!.commentedIcon.isHidden = false
            cell.reviewScrollView.viewComment!.textReview.isHidden = false
            cell.reviewScrollView.viewComment!.textReview.text = review
            cell.reviewScrollView.viewComment?.delegate = self
        }
    }

    /// Cell special configuration

    func configureVoteButtons(_ cell:GRHomeCollectionViewCell, indexPath:IndexPath) {
        cell.reviewScrollView.paginatedScrollView.isScrollEnabled = false
        
        cell.reviewScrollView.voteView!.voteOne?.isSelected = false
        cell.reviewScrollView.voteView!.voteTwo?.isSelected = false
        cell.reviewScrollView.voteView!.voteThree?.isSelected = false
        cell.reviewScrollView.voteView!.voteFour?.isSelected = false
        cell.reviewScrollView.voteView!.voteFive?.isSelected = false

        cell.reviewScrollView.pageControl.currentPage = 0
        cell.reviewScrollView.pageControl.currentPageIndicatorTintColor = UIColor.grocerestLightGrayColor()

        cell.reviewScrollView.voteView?.voteOne?.tag = 1
        cell.reviewScrollView.voteView?.voteTwo?.tag = 2
        cell.reviewScrollView.voteView?.voteThree?.tag = 3
        cell.reviewScrollView.voteView?.voteFour?.tag = 4
        cell.reviewScrollView.voteView?.voteFive?.tag = 5

        cell.reviewScrollView.voteView?.voteOne?.addTarget(self, action: #selector(GRPostReviewProtocol.postVoteForItem(_:)), for: .touchUpInside)
        cell.reviewScrollView.voteView?.voteTwo?.addTarget(self, action: #selector(GRPostReviewProtocol.postVoteForItem(_:)), for: .touchUpInside)
        cell.reviewScrollView.voteView?.voteThree?.addTarget(self, action: #selector(GRPostReviewProtocol.postVoteForItem(_:)), for: .touchUpInside)
        cell.reviewScrollView.voteView?.voteFour?.addTarget(self, action: #selector(GRPostReviewProtocol.postVoteForItem(_:)), for: .touchUpInside)
        cell.reviewScrollView.voteView?.voteFive?.addTarget(self, action: #selector(GRPostReviewProtocol.postVoteForItem(_:)), for: .touchUpInside)

        cell.reviewScrollView.viewFrequency?.freqFirst!.tag = 1
        cell.reviewScrollView.viewFrequency?.freqRarely!.tag = 2
        cell.reviewScrollView.viewFrequency?.freqMontly!.tag = 3
        cell.reviewScrollView.viewFrequency?.freqWeakly!.tag = 4
        cell.reviewScrollView.viewFrequency?.freqDaily!.tag = 5

        cell.reviewScrollView.viewFrequency?.freqFirst!.addTarget(self, action: #selector(GRHomeViewController.postFrequency(_:)), for: .touchUpInside)
        cell.reviewScrollView.viewFrequency?.freqRarely!.addTarget(self, action: #selector(GRHomeViewController.postFrequency(_:)), for: .touchUpInside)
        cell.reviewScrollView.viewFrequency?.freqMontly!.addTarget(self, action: #selector(GRHomeViewController.postFrequency(_:)), for: .touchUpInside)
        cell.reviewScrollView.viewFrequency?.freqWeakly!.addTarget(self, action: #selector(GRHomeViewController.postFrequency(_:)), for: .touchUpInside)
        cell.reviewScrollView.viewFrequency?.freqDaily!.addTarget(self, action: #selector(GRHomeViewController.postFrequency(_:)), for: .touchUpInside)

        cell.reviewScrollView.viewComment?.writeCommentButton?.tag = indexPath.row
        cell.reviewScrollView.viewComment?.writeCommentButton?.addTarget(self, action: #selector(GRHomeViewController.commetWasPressed(_:)), for: .touchUpInside)
    }

    // MARK: format list utilities

    func isListCompleted(_ status:Bool?) -> Bool {
        return status!
    }

    func isListAndDeviceOwner(_ userId:String) -> Bool {
        if userId == GRUser.sharedInstance.id! {
            return true
        }
        return false
    }

    func isDeviceOwnerInvitedToTheList(_ userId:String) -> Bool{
        if userId == GRUser.sharedInstance.id! {
            return true
        }
        return false
    }

    func doesUserBelongToSegmentOfList(_ segmentArray:Array<JSON>) -> Bool {
        var result = false
        for user in segmentArray {
            if user["_id"].string == GRUser.sharedInstance.id! {
                result = true
            } else {
                result = false
            }
        }
        return result
    }

    func formatElementsString(_ numberOfItems:Int) -> String {
        var formated = ""
        if numberOfItems == 1 {
            formated = "Elemento"
        } else {
            formated = "Elementi"
        }
        return formated
    }

    func shouldHideBadge(_ numberOfItems:Int) -> Bool {
        if numberOfItems > 0 {
            return false
        }
        return true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        latestReviews.removeAll()
    }

    // MARK: Utilities

    func addPageTracker(){
        self.title = "Home View"
        let name = "Pattern~\(self.title!)"

        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)

        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as [NSObject: AnyObject]?)
    }

    // MARK: Future
    func grocerestPR() {
        let cell = collectionView?.cellForItem(at: currentProduct) as! GRHomeCollectionViewCell

        let grocerestImage = UIImageView(image: UIImage(named: "grocerest_reputation"))
        grocerestImage.contentMode = .scaleAspectFit
        grocerestImage.alpha = 0

        cell.contentView.addSubview(grocerestImage)
        grocerestImage.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.top.equalTo(cell.contentView.snp.top).offset(125)
            make.right.equalTo(cell.contentView.snp.right).offset(-25)
        }

        UIView.animate(withDuration: 0.25, animations: {
            grocerestImage.alpha = 0.8
        }, completion: { completed in
            UIView.animate(withDuration: 0.25, animations: {
                grocerestImage.alpha = 0
            }, completion: { completed in
                grocerestImage.removeFromSuperview()
            }) 
        })
    }

    // Utils

    func isUserValid() {
        if GRUser.sharedInstance.id == nil || GRUser.sharedInstance.id!.isEmpty {
            self.noUserOrInvalidToken()
            return
        }
    }

    func configureNavigationController() {
        navigationController?.hidesBarsOnTap = false
        navigationController?.isNavigationBarHidden = true
        automaticallyAdjustsScrollViewInsets = false
        sideMenuController()?.sideMenu?.delegate = self
    }

    func getDataForUserStats() {
        if let activeUserId = GrocerestAPI.userId {
            GrocerestAPI.getUserStats(activeUserId) { data, error in

                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }

                GRUserStats.setUserStatsFrom(data)
                GRUserStats.saveUserStatsDataToDisk(GRUserStats.sharedInstance)
            }
        }
    }

    /// no-complete reviews

    func getIncompleteReviewsFor() {
        let fields: [String: Any] = [
            "author": GRUser.sharedInstance.id!,
            "limit": 20,
            "withoutTextOnly": true
        ]

        GrocerestAPI.searchForReview(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            if data["count"].intValue < 3 {
                self.managedView.willShowEitherToCompleteOrCategoriesView(false)
                self.getCategories()
            } else {
                self.managedView.willShowEitherToCompleteOrCategoriesView(true)
                self.managedView.reviewsToCompleteView.prepopulate(with: data)
            }
        }
    }

    func getLatestReviewsFor() {
        GrocerestAPI.getReviewsForHome(10) { data, error in

            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            self.latestReviews.append(contentsOf: data.arrayValue)
            self.formatLatestReviews()
        }
    }

    func getCategories() {
        GrocerestAPI.getCategories() { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                if error != nil { SwiftLoader.hide() }
                return
            }
            
            var categorySlugs = [String]()
            var productsIncat = [Int]()
            for child in data["children"].arrayValue {
                self.idFromSlug[child["slug"].stringValue] = child["_id"].stringValue
                categorySlugs.append(child["slug"].stringValue)
                productsIncat.append(child["products"].intValue)
            }

            self.managedView.categoriesView.categoriesSlugs = categorySlugs
            self.managedView.categoriesView.numberOfProductsInCategories = productsIncat
        }
    }

    func tryProductStatus(_ productId: String) {
        if getTryableProductsFromLocal().contains(productId) {
            GrocerestAPI.removeProductToPredefinedList(GRUser.sharedInstance.id!, listName: Constants.PredefinedUserList.totry, productId: productId) { data, error in

                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }
            }
        }
    }
    
}
