//
//  GRProductsViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 05/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftLoader
import Google
import FBSDKCoreKit
import FBSDKLoginKit
import RealmSwift

// Collection view
class GRProductsViewController: UIViewController, UITextFieldDelegate, GRToolBarProtocol, UICollectionViewDelegate, UICollectionViewDataSource, ENSideMenuDelegate {
    
    var homeData : JSON?
    var dataSource: JSON?
    var collectionView : UICollectionView?
    let realm = try! Realm()

    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedView.navigationToolBar?.isThisBarWithTitle(true, title: "Prodotti")
        self.sideMenuController()?.sideMenu?.delegate = self
        prepareViews()
        dataSource = []
        setDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Macro Categories View"
        let name = "Pattern~\(self.title!)"
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as [NSObject: AnyObject]?)
    }
    
    private var managedView: GRProductsView {
        return self.view as! GRProductsView
    }
    
    override func loadView() {
        super.loadView()
        view = GRProductsView()
        managedView.delegate = self
        managedView.navigationToolBar?.delegate = self
    }
    
    func prepareViews() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let splitW = (UIScreen.main.bounds.width - 0.3) / 2
        let maxH = (UIScreen.main.bounds.height) - 150 / masterRatio
        layout.itemSize = CGSize(width: splitW, height: 471 / masterRatio)
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.register(GRProductCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView!.backgroundColor = UIColor.white
        view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { make in
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(maxH)
            make.top.equalTo((self.managedView.navigationToolBar?.snp.bottom)!)
            make.left.equalTo(0)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = dataSource?["children"].array?.count {
            return count + 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GRProductCollectionViewCell
        
        cell.layer.borderWidth = 1 / masterRatio
        cell.layer.borderColor = UIColor(hexString: "BBBBBB").cgColor
        
        /* Last cell must be empty so we have borders with the same weight of
           the others */
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {
            cell.mainLabel?.text = nil
            cell.categoryImageView?.image = nil
            cell.counterLabel?.text = nil
            cell.counterLabel?.layer.backgroundColor = UIColor.clear.cgColor
            return cell
        }
        
        DispatchQueue.main.async {
            if let categoryName = self.dataSource!["children"].array![indexPath.row]["name"].string,
               let slug = self.dataSource!["children"].array![indexPath.row]["slug"].string{
                    cell.mainLabel?.text = categoryName
                    cell.categoryImageView?.image = UIImage(named: "products_\(slug)")
            }
            
            if let counter = self.dataSource!["children"].array![indexPath.row]["products"].int {
                if counter == 0 {
                    cell.counterLabel?.text = "  In arrivo  "
                    cell.counterLabel?.layer.backgroundColor = UIColor.lightGray.cgColor
                    cell.counterLabel?.layer.cornerRadius = 18 / masterRatio
                } else {
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    let counterLocalized = formatter.string(from: NSNumber(value: counter)) ?? counter.description
                    
                    cell.counterLabel?.text = "  \(counterLocalized)  "
                    cell.counterLabel?.layer.backgroundColor = colorForCategory(self.dataSource!["children"].array![indexPath.row]["slug"].string!).cgColor
                    cell.counterLabel?.layer.cornerRadius = 18 / masterRatio
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Last cell is always empty so we do nothing
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {
            return
        }
        
        if dataSource!["children"].array![indexPath.row]["products"].int == 0 {
            return
        }
        
        let productsListViewController = GRProductsListViewController()
        
        if let name = dataSource!["children"].array![indexPath.row]["name"].string,
           let categoryId = dataSource!["children"].array![indexPath.row]["_id"].string {
            productsListViewController.pageTitle = name
            productsListViewController.categoryId = categoryId
        }
        
        navigationController?.pushViewController(productsListViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.15, 0.15, 0.15, 0.15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    /**
     DataSource
     */
    func setDataSource() {
        SwiftLoader.show(animated: true)
        
        GrocerestAPI.getCategories() { data, error in
            SwiftLoader.hide()
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {    
                if data["error"]["code"].stringValue == "E_UNAUTHORIZED" {
                    DispatchQueue.main.async { self.noUserOrInvalidToken() }
                }
                return
            }
            
            self.dataSource = data
            self.collectionView?.reloadData()
        }
    }
    
    
    /**
     *  Toolbar
     */
    
    func menuButtonWasPressed(_ menuButton: UIButton) {
        toggleSideMenuView()
    }
    
    func grocerestButtonWasPressed(_ grocerestButton: UIButton){
        print("grocerest button")
    }
    
    func scannerButtonWasPressed(_ sender: UIButton){
        let scannerViewController = GRBarcodeScannerViewController()
        navigationController?.pushViewController(scannerViewController, animated: false)
    }
    
    func searchButtonWasPressed(_ searchButton: UIButton){
        let productSearch = GRProductSearchViewController()
        navigationController?.pushViewController(productSearch, animated: true)
    }
    
    func noUserOrInvalidToken() {
        let welcomeViewController = GRWelcomeViewController()
        // self.navigationController?.pushViewController(welcomeViewController, animated: false)
        try! self.realm.write {
            self.realm.deleteAll()
        }
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "bearerToken")
        defaults.removeObject(forKey: "userId")
        defaults.synchronize()
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()

        navigationController!.setViewControllers([welcomeViewController], animated: true)
    }
    
}
