//
//  GRProfileViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 15/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Haneke
import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON
import Google
import SwiftLoader

enum CategoriesProfile: String {
    case curaDeLaPersona = "Cura-della-Persona"
    case bevande = "Bevande"
    case alimentari = "Alimentari"
    case prodottiPerLaCasa = "Prodotti-per-la-Casa"
    case infanzia = "Infanzia"
    case integratori = "Integratori"
    case animali = "Animali"
    case libri = "Libri"
}

class GRProfileViewController: UIViewController, GRMenuProtocol, GRToolBarProtocol, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, GRUserCategorizedProductsProtocol, GRProfileUpdateProtocol, UIScrollViewDelegate, GRModalViewControllerDelegate, GRLastIdTappedCacher {
    
    var activeList = Constants.PredefinedUserList.favourites
    var activeListDisplayName = Constants.PredefinedUserListDisplayVersion.favourites
    var animatedMenu: GRMenuView?
    var asFavourites : [String]!
    var asHated : [String]!
    var asReviewed :[String]!
    var asScanned : [String]!
    var asTryable : [String]!
    var currentCategory = CategoriesProfile.alimentari

    var lastTappedId: String?
    
    var dataStats : JSON?

    var currentList = Constants.PredefinedUserList.favourites

    var dataSource : JSON = JSON.null

    var homeViewController : GRHomeViewController?

    var lastActiveList:String? = nil

    var menuExist = false

    var tableView : UITableView?

    var scrollMagickPoint : CGFloat =  600.00

    var dynamicScrollContentSize = 2418 / masterRatio
    

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        controllerConfig()
        formatTableView()
        getUserProductsList() {
            self.setDataSource(self.activeList)
        }
        updateUserData() {
            self.formatUserProfile()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(GRProfileViewController.didReceiveNotification(_:)), name: NSNotification.Name(rawValue: notificationIdentifierReload), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendDataToGoogle()
        getDataForUserStats()
    }
    
    func modalWasDismissed(_ modal: UIViewController) {
        getDataForUserStats()
        self.reloadDataSourceForList(self.activeList)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    var managedView: GRProfileView {
        return self.view as! GRProfileView
    }

    override func loadView() {
        view = GRProfileView()
        managedView.delegate = self
        managedView.navigationToolBar.delegate = self
        managedView.__scaling__.delegate = self
    }

    func controllerConfig() {
        self.navigationController?.hidesBarsOnTap = false
        navigationController?.isNavigationBarHidden = true
        SwiftLoader.show(animated: true)
        self.sideMenuController()?.sideMenu?.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func showBackButton() {
        managedView.navigationToolBar.showBackButton()
    }

    func formatTableView() {
        tableView = UITableView(frame: CGRect.zero)
        tableView?.backgroundColor = UIColor(white:0.94, alpha:1.0)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.bounces = true
        tableView?.isScrollEnabled = false
        tableView?.rowHeight = (332+20) / masterRatio
        tableView?.register(GRProductsResultTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.separatorStyle = .none
        tableView?.isHidden = false
        tableView?.showsVerticalScrollIndicator = false

        let ghostView = UIView()
        managedView.viewsByName["oldWrapper"]?.addSubview(ghostView)
        ghostView.snp.makeConstraints { make in
            make.width.equalTo(managedView.snp.width)
            make.top.equalTo(managedView.paginatedScrollView.snp.bottom)
            make.centerX.equalTo(self.managedView.snp.centerX)
            // set dinamic height > 3 elements from datasource
            make.height.equalTo(1200 / masterRatio)
        }
        ghostView.backgroundColor = UIColor(white:0.94, alpha:1.0)

        managedView.viewsByName["oldWrapper"]?.addSubview(tableView!)
        managedView.viewsByName["oldWrapper"]?.sendSubview(toBack: ghostView)

        tableView?.snp.makeConstraints { make in
            make.width.equalTo(687 / masterRatio)
            make.top.equalTo(managedView.productsCountLabel!.snp.bottom).offset(20 / masterRatio)
            make.centerX.equalTo(self.managedView.snp.centerX)
            // set dinamic height > 3 elements from datasource
            make.height.equalTo(Int(tableView!.rowHeight) * 3)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count > 3 {
            //managedView.seeAllButton.hidden = false
            return 3
        }
        //managedView.seeAllButton.hidden = true
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRProductsResultTableViewCell
        cell.populateWith(product: self.dataSource[indexPath.row], from: self)
        return cell
    }

    func setDataSource(_ listname: String) {
        if let lastActiveList = self.lastActiveList,
           lastActiveList != listname {
            dataSource = nil
            let range = NSMakeRange(0, self.tableView!.numberOfSections)
            let sections = IndexSet(integersIn: range.toRange() ?? 0..<0)
            tableView!.reloadSections(sections, with: .automatic)
        }
        lastActiveList = listname
        dataSource = JSON.null
        managedView.productsCountLabel?.text = "Caricamento..."
        
        GrocerestAPI.getProductsInPredefinedList(GRUser.sharedInstance.id!, listname: listname) { data, error in
            if (self.currentList != listname) {
                print("Discarding data because it's not for the list the user has selected", self.currentList, listname);
                return;
            }
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                DispatchQueue.main.async { SwiftLoader.hide() }
                if data["error"]["code"].stringValue == "E_UNAUTHORIZED" {
                    self.noUserOrInvalidToken()
                }
                return
            }

            self.dataSource = data
            DispatchQueue.main.async {
                func lessOrThreeRows() {
                    self.tableView?.snp.remakeConstraints { make in
                        make.width.equalTo(687 / masterRatio)
                        make.top.equalTo(self.managedView.productsCountLabel!.snp.bottom).offset(20 / masterRatio)
                        make.centerX.equalTo(self.managedView.snp.centerX)
                        make.height.equalTo(Int(self.tableView!.rowHeight) * self.dataSource.count)
                    }

                    self.managedView.seeAllButton.snp.remakeConstraints { make in
                        make.width.equalTo(686 / masterRatio)
                        make.height.equalTo(80 / masterRatio)
                        make.top.equalTo(self.tableView!.snp.bottom).offset(10)
                        make.centerX.equalTo(self.managedView.snp.centerX)
                    }
                }

                func zeroRows(){
                    self.tableView?.isHidden = true
                    self.managedView.formatViewForNoRows()
                    self.scrollMagickPoint = 220.00 / masterRatio
                }

                func oneRow(){
                    self.tableView?.isHidden = false
                    self.scrollMagickPoint = 300.00 / masterRatio
                    lessOrThreeRows()
                    self.managedView.formatViewForOneRow()
                }

                func twoRows(){
                    self.tableView?.isHidden = false
                    self.scrollMagickPoint = 700.00 / masterRatio
                    lessOrThreeRows()
                    self.managedView.formatViewForTwoRows()
                }

                func threeRows() {
                    self.tableView?.isHidden = false
                    self.scrollMagickPoint = 1040.00 / masterRatio
                    lessOrThreeRows()
                    self.managedView.formatViewForThreeRows()

                }

                func moreRows() {
                    self.tableView?.isHidden = false
                    self.scrollMagickPoint = 920.00 / masterRatio

                    self.tableView?.snp.remakeConstraints { make in
                        make.width.equalTo(687 / masterRatio)
                        make.top.equalTo(self.managedView.productsCountLabel!.snp.bottom).offset(20 / masterRatio)
                        make.centerX.equalTo(self.managedView.snp.centerX)
                        make.height.equalTo(Int(self.tableView!.rowHeight) * 3)
                    }

                    self.managedView.seeAllButton.snp.remakeConstraints { make in
                        make.width.equalTo(686 / masterRatio)
                        make.height.equalTo(80 / masterRatio)
                        make.top.equalTo(self.tableView!.snp.bottom).offset(10)
                        make.centerX.equalTo(self.managedView.snp.centerX)
                    }
                    self.managedView.formatViewForFullSize()
                }

                let range = NSMakeRange(0, self.tableView!.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)

                SwiftLoader.hide()

                switch self.dataSource.count {
                case 0:
                    self.managedView.productsCountLabel?.text = "Nessun elemento aggiunto a questa lista"
                    zeroRows()
                    self.tableView?.reloadSections(sections as IndexSet, with: .none)
                    return
                case 1:
                    oneRow()
                    self.managedView.productsCountLabel?.text = "\(self.dataSource.count) Elemento"
                    self.tableView?.reloadSections(sections as IndexSet, with: .none)
                    return
                case 2:
                    twoRows()
                    self.managedView.productsCountLabel?.text = "\(self.dataSource.count) Elementi"
                    self.tableView?.reloadSections(sections as IndexSet, with: .none)
                    return
                case 3:
                    threeRows()
                    self.managedView.productsCountLabel?.text = "\(self.dataSource.count) Elementi"
                    self.tableView?.reloadSections(sections as IndexSet, with: .none)
                    return
                default:
                    self.managedView.productsCountLabel?.text = "\(self.dataSource.count) Elementi"
                    moreRows()
                    self.tableView?.reloadSections(sections as IndexSet, with: .none)
                    return
                }
            }
        }
    }

    private var statisticsAlreadyInitialized = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollMagickPoint && !statisticsAlreadyInitialized {
            statisticsAlreadyInitialized = true
            if let dataStats = self.dataStats {
                managedView.statisticsPanel.populateWith(dataStats)
            }
        }
    }

    /**
     filtering buttons

     - parameter menuButton:
     */
    func preferitiButtonWasPressed(_ sender:UIButton) {
        GrocerestAPI.cancellAllRequest()
        activeList = Constants.PredefinedUserList.favourites
        activeListDisplayName = Constants.PredefinedUserListDisplayVersion.favourites
        if currentList == activeList { return }
        setDataSource(Constants.PredefinedUserList.favourites)
        currentList = Constants.PredefinedUserList.favourites
    }


    func evitareButtonWasPressed(_ sender:UIButton){
        GrocerestAPI.cancellAllRequest()
        activeList = Constants.PredefinedUserList.hated
        activeListDisplayName = Constants.PredefinedUserListDisplayVersion.hated
        if currentList == activeList { return }
        setDataSource(Constants.PredefinedUserList.hated)
        currentList = Constants.PredefinedUserList.hated
    }

    func provareButtonWasPressed(_ sender:UIButton) {
        GrocerestAPI.cancellAllRequest()
        activeList = Constants.PredefinedUserList.totry
        activeListDisplayName = Constants.PredefinedUserListDisplayVersion.totry
        if currentList == activeList { return }
        setDataSource(Constants.PredefinedUserList.totry)
        currentList = Constants.PredefinedUserList.totry
    }

    func recensitiButtonWasPressed(_ sender: UIButton) {
        GrocerestAPI.cancellAllRequest()
        activeList = Constants.PredefinedUserList.reviewed
        activeListDisplayName = Constants.PredefinedUserListDisplayVersion.reviewed
        if currentList == activeList { return }
        setDataSource(Constants.PredefinedUserList.reviewed)
        currentList = Constants.PredefinedUserList.reviewed
    }

    func scansioneButtonWasPressed(_ sender:UIButton) {
        GrocerestAPI.cancellAllRequest()
        activeList = Constants.PredefinedUserList.scanned
        activeListDisplayName = Constants.PredefinedUserListDisplayVersion.scanned
        if currentList == activeList { return }
        setDataSource(Constants.PredefinedUserList.scanned)
        currentList = Constants.PredefinedUserList.scanned
    }

    /**
     Menu manager

     - parameter menuButton:
     */
    func menuButtonWasPressed(_ menuButton: UIButton) {
        toggleSideMenuView()
    }

    func grocerestButtonWasPressed(_ grocerestButton: UIButton){
        // Noop
    }

    func scannerButtonWasPressed(_ sender: UIButton){
        let scannerViewController = GRBarcodeScannerViewController()
        self.navigationController?.pushViewController(scannerViewController, animated: false)

    }

    func searchButtonWasPressed(_ searchButton: UIButton){
        let productSearch = GRProductSearchViewController()
        navigationController?.pushViewController(productSearch, animated: true)
    }
    

    /**
     * Open Modal View with options to tag product
     */
    func presentFullConstentsForList() {
        SwiftLoader.show(title: "Caricamento in corso", animated: true)
        let predefinedListController = GRPredefinedListViewController()
        predefinedListController.listName = activeList
        predefinedListController.listDisplayName = activeListDisplayName
        self.navigationController?.pushViewController(predefinedListController, animated: true)
    }

    /**
     * Toolbar
     */
    func backButtonWasPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
    }

    func profileButtonWasPressed(_ sender: UIButton) {
        let destViewController = GRProfileViewController()
        sideMenuController()?.setContentViewController(destViewController)
    }

    func inviteFriendsButtonWasPressed(_ sender:UIButton) {
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


    func settingsButtonWasPressed(_ sender: UIButton) {
        let editUserProfileViewController = GREditProfileViewController()
        editUserProfileViewController.delegate = self
        editUserProfileViewController.modalPresentationStyle = .overCurrentContext
        editUserProfileViewController.modalTransitionStyle = .coverVertical
        present(editUserProfileViewController, animated: true, completion: nil)
    }

    func noUserOrInvalidToken() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "bearerToken")
        defaults.removeObject(forKey: "userId")
        defaults.synchronize()

        let loginManager = FBSDKLoginManager()
        loginManager.logOut()

        let window:UIWindow? = (UIApplication.shared.delegate?.window)!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window!.rootViewController = storyboard.instantiateInitialViewController()
    }

    func reloadDataSourceForList(_ name: String) {
        updateUserData() {
            self.formatUserProfile()
        }
        getUserProductsList() {
            self.setDataSource(name)
        }
    }


    // MARK: Utils

    func sendDataToGoogle() {
        self.title = "Profile View"
        let name = "Pattern~\(self.title!)"

        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)

        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as [NSObject: AnyObject]?)
    }
    
    func showUserReputation(_ sender:UIButton) {
        let userReputationViewController = GRReputationViewController()
        userReputationViewController.data = dataStats
        userReputationViewController.modalPresentationStyle = .overCurrentContext
        userReputationViewController.modalTransitionStyle = .coverVertical
        present(userReputationViewController, animated: true)
    }
    
    func didReceiveNotification(_ notification: Notification){
        reloadDataSourceForList(activeList)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
