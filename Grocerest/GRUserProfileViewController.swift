//
//  GRUserProfileViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 24/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftLoader

class GRUserProfileViewController: UIViewController, GRToolBarProtocol, UIScrollViewDelegate, ENSideMenuDelegate {

    private lazy var __once: () = {
        self.managedView.statisticsPanel.populateWith(self.userStats!)
    }()

    var author: JSON?
    var publicProfile: JSON?
    var dataReviews: JSON? = JSON([])
    var userStats: JSON?
    var menuDataDelegate = GRMenuViewController()
    var animationBound = 1000 / masterRatio

    var authorId: String {
        return author!["_id"].stringValue
    }

    override var prefersStatusBarHidden : Bool {
        return false
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false
        super.viewDidLoad()
        getStatisticsForUser()
        getPublicProfile()
        getReviewsFor()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.managedView.navigationToolBar.isThisBarForDetailViewWithBackButton(true, title: author!["username"].stringValue)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.managedView.tableView.bringSubview(toFront: self.managedView.openTableButton)
    }

    var managedView: GRUserProfileView {
        return self.view as! GRUserProfileView
    }

    override func loadView() {
        super.loadView()
        
        view = GRUserProfileView()
        managedView.navigationToolBar.delegate = self
        managedView.navigationToolBar.grocerestButton?.isEnabled = false
        
        managedView.tableView.delegate = self
        managedView.tableView.dataSource = self
        managedView.tableView.isScrollEnabled = false
        managedView.scrollView.delegate = self
        managedView.scrollView.delaysContentTouches = false
        managedView.scrollView.isUserInteractionEnabled = true
        managedView.scrollView.isExclusiveTouch = true
        managedView.scrollView.translatesAutoresizingMaskIntoConstraints = false
    }

    func backButtonWasPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func getHeightForTableView(_ data:JSON)-> CGFloat {
        var tableHeight: CGFloat = 0
        let largeCell: CGFloat = 386
        let smallCell: CGFloat = 298

        for review in data["reviews"].arrayValue {
            if review["review"].stringValue.characters.count == 0 {
                tableHeight = tableHeight + smallCell
            } else {
                tableHeight = tableHeight + largeCell
            }
        }

        let count = data["count"].intValue
        
        if count >= 3 {
            animationBound = 1000 / masterRatio
            return tableHeight
        } else if count == 2 {
            animationBound = 700 / masterRatio
            return tableHeight
        } else if count == 1 {
            animationBound = 400 / masterRatio
            return tableHeight
        }
        
        return 0.00
    }

    private var enableScrollViewBeyondTableEvents = false
    var token: Int = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // If the view is still loading then it doesn't tracks scroll view events
        // right away, otherwise it could start statistics panel animations too soon
        // (because reviews' table height can change after we populate it).
        if !enableScrollViewBeyondTableEvents { return }
        
        // When the user scrolls beyond the reviews table...
        if managedView.scrollView.contentOffset.y > animationBound {
            // ... it populates the statistics panel so that the user can see the animations.
            _ = self.__once
        }

    }

    func getReviewsFor() {
        let fields : [String: Any] = [
            "author": authorId,
            "limit": 3,
            "withTextOnly": true
        ]

        setupViews(false)

        GrocerestAPI.searchForReview(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                return
            }

            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.dataReviews = data
                self.setupViews(true)
            }
            self.enableScrollViewBeyondTableEvents = true
        }
    }

    func getStatisticsForUser() {
        SwiftLoader.show(title: "Caricamento", animated: true)
        
        GrocerestAPI.getUserStats(self.authorId) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                return
            }
            
            DispatchQueue.main.async {
                self.userStats = data
                self.managedView.formaUserStatistics(self.userStats!)

                // If there are no reviews then populate immediately so you see
                // animations right away
                let tableViewHeight = self.getHeightForTableView(self.dataReviews!)
                if tableViewHeight == 0 { self.managedView.statisticsPanel.populateWith(self.userStats!) }
            }
        }
    }

    func getPublicProfile() {
        GrocerestAPI.getPublicProfile(self.authorId) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                print("Could not send deviceToken to server")
                return
            }
            
            DispatchQueue.main.async {
                self.publicProfile = data
                self.managedView.setUserMemberSince(self.publicProfile!["tsCreated"].stringValue)
                self.managedView.setUserImage(self.publicProfile!)
                self.managedView.formatReputationScoreSection(self.publicProfile!)
            }
        }
    }

    func setupViews(_ update:Bool) {
        if (!update) { // first time setup
            managedView.formatTableViewPosition(self.getHeightForTableView(self.dataReviews!))
            managedView.buttonWrapperSetHidden(self.dataReviews!["count"].intValue < 3)
        } else {
            // ensure pending layouts are done before animation
            managedView.layoutIfNeeded()
            // animate
            UIView.animate(withDuration: 0.3, animations: {
                self.managedView.formatTableViewPosition(self.getHeightForTableView(self.dataReviews!))
                self.managedView.buttonWrapperSetHidden(self.dataReviews!["count"].intValue < 3)
                self.managedView.layoutIfNeeded()
            })
        }

        managedView.formaProductsCountLabel(dataReviews!["count"].intValue, loading: !update)
        managedView.tableView.reloadData()

        managedView.onOpenTableButtonTapped = {
            let userReviewsController = GRUserReviewsViewController()
            userReviewsController.author = self.author
            userReviewsController.userStats = self.userStats
            self.navigationController?.pushViewController(userReviewsController, animated: true)
        }
    }

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

}
