//
//  GRUserReviewsViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 26/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftLoader

class GRUserReviewsViewController: UIViewController, GRToolBarProtocol, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate {
    
    var author: JSON?
    var userStats: JSON?
    var dataReviews: JSON?
    var reviews: [JSON]?
    var menuDataDelegate = GRMenuViewController()
    var authorId: String {
        return author!["_id"].stringValue
    }
    
    var step = 0
    var reload = true
    let limit = 30
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getReviewsFor()
     //   setupViews()
        self.managedView.navigationToolBar.isThisBarForDetailViewWithBackButton(true, title: author!["username"].stringValue)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        managedView.tableView.tableHeaderView = managedView.labelView
        managedView.tableView.reloadData()
        self.managedView.formatUserProfile(author!, userStats: userStats!)
    }
    
    
    
    fileprivate var managedView: GRUserReviewsView {
        return self.view as! GRUserReviewsView
    }
    
    override func loadView() {
        super.loadView()
        view = GRUserReviewsView()
        self.managedView.navigationToolBar.delegate = self
        managedView.tableView.delegate = self
        managedView.tableView.dataSource = self
    }
    
    func backButtonWasPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviews != nil {
            return reviews!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: GRUserReviewTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRUserReviewTableViewCell
        
        let index = indexPath.row
        cell.selectionStyle = .none
        
        if (cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRUserReviewTableViewCell
        }
        
        if indexPath.row == reviews!.count - 4 && reload == true {
            self.loadMore()
        }
        
        
        cell.formatCellWith(reviews![indexPath.row])
        
        
        cell.onUsefullnessButtonTapped = {
            cell.numberOfUseful += cell.isUseful ? -1 : 1
            cell.isUseful = !cell.isUseful
            SwiftLoader.show(animated: true)
            
            // print(self.dataReviews!["reviews"][indexPath.row]["_id"].stringValue)
            
            GrocerestAPI.toggleUsefulnessVote(reviewId: self.reviews![indexPath.row]["_id"].stringValue) { _,_ in
                SwiftLoader.hide()
            }
        }
        
        cell.onProductDetailButtonTapped = {
            if self.reviews!.count == 0 { return }
            let productDetail = GRProductDetailViewController()
            productDetail.prepopulateWith(product: self.reviews![index]["product"])
            productDetail.productId = self.reviews![index]["product"]["_id"].stringValue
            self.navigationController?.pushViewController(productDetail, animated: true)
            
        }
        
        cell.onProductReviewButtonTapped = {
            if self.reviews!.count == 0 { return }
            let reviewDetail = GRReviewDetailViewController()
            //reviewDetail.onDismissed = { self.refresh() }
            reviewDetail.reviewId = self.reviews![index]["_id"].stringValue
            self.navigationController?.pushViewController(reviewDetail, animated: true)
        }
        
        if reviews![indexPath.row]["review"].stringValue.characters.count == 0 {
            cell.smallCell()
        } else {
            cell.largeCell()
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if reviews![indexPath.row]["review"].stringValue.characters.count == 0 {
            return 298 / masterRatio
        } else {
            return 386 / masterRatio
        }
    }
    
    func getReviewsFor() {
        let fields = [
            "author": authorId,
            "limit": limit,
            "step": self.step,
            "withTextOnly": true
        ] as [String: Any]
        
        self.reviews = []
        
        GrocerestAPI.searchForReview(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                return
            }
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.reviews?.append(contentsOf: data["reviews"].arrayValue)
                self.step = self.step + self.limit
                self.managedView.tableView.reloadData()
                self.managedView.formatRecensioniLabel(data["count"].intValue)
            }
        }
    }
    
    
    func loadMore() {
        let fields = [
            "author": authorId,
            "limit": limit,
            "step" :  step,
            "withTextOnly": true
        ] as [String: Any]

        GrocerestAPI.searchForReview(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                return
            }
            
            DispatchQueue.main.async {
                SwiftLoader.hide()

                self.reviews?.append(contentsOf: data["reviews"].arrayValue)

                if data["reviews"].count < self.limit {
                    self.reload = false
                }
                
                self.step = self.step + self.limit
                
                
                self.managedView.tableView.reloadData()
                self.managedView.formatRecensioniLabel(data["count"].intValue)
            }
        }
    }
    
    
    func menuButtonWasPressed(_ menuButton: UIButton) {
        menuDataDelegate.getUserDataAndUpdateProfile()
        toggleSideMenuView()
    }
    
    
    func scannerButtonWasPressed(_ sender: UIButton){
        let scannerViewController = GRBarcodeScannerViewController()
        self.navigationController?.pushViewController(scannerViewController, animated: false)
    }
    
    func searchButtonWasPressed(_ searchButton: UIButton){
        let productSearch = GRProductSearchViewController()
        navigationController?.pushViewController(productSearch, animated: true)
    }

}
