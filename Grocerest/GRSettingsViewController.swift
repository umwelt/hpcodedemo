//
//  GRSettingsViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 06/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftyJSON
import Google
import MessageUI
import ZendeskSDK

class GRSettingsViewController: UIViewController, UITextFieldDelegate, GRToolBarProtocol, UITableViewDelegate, UITableViewDataSource, ENSideMenuDelegate, MFMailComposeViewControllerDelegate {

    let realm = try! Realm()
    
    var homeData : JSON?
    var dataSource: [String]?
    var tableView : UITableView?
    var pageTitle : String?
    var categoryId : String?
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    var notificationsStatus: Bool {
        if UIApplication.shared.currentUserNotificationSettings!.types.rawValue > 0 {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        ZDKConfig.instance()
                 .initialize(withAppId: "d180d197b03e0d62c59aec2d19010fbbedf310d466f08494",
                                      zendeskUrl: "https://grocerest.zendesk.com",
                                      clientId: "mobile_sdk_client_68426fd169b5c01dd8a4"
        )
        
        self.sideMenuController()?.sideMenu?.delegate = self
        managedView.navigationToolBar?.isThisBarWithTitle(true, title: "Assistenza")
        setupViews()
        dataSource = []
        setDataSource()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    func willEnterForeground() {
        self.tableView?.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        self.title = "Assistenza"
        let name = "Pattern~\(self.title!)"
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as [NSObject: AnyObject]?)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate var managedView: GRSettingsView {
        return self.view as! GRSettingsView
    }
    
    override func loadView() {
        super.loadView()
        view = GRSettingsView()
        managedView.delegate = self
        managedView.navigationToolBar?.delegate = self
    }
    
    func setupViews() {
        
        tableView = UITableView(frame: CGRect.zero)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.bounces = true
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.backgroundColor = UIColor.clear
        tableView?.separatorStyle = .singleLine
        tableView?.isHidden = false
        tableView?.rowHeight = 148 / masterRatio
        managedView.addSubview(tableView!)
        tableView!.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(managedView.snp.width)
            make.top.equalTo((managedView.navigationToolBar?.snp.bottom)!)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if (cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        
        cell.selectionStyle = .none
        
        if indexPath.row == 0  {
            let switchController = UISwitch(frame: CGRect.zero)
            cell.accessoryView = switchController
            switchController.onTintColor = UIColor.grocerestBlue()
            switchController.setOn(notificationsStatus, animated: true)
            switchController.addTarget(self, action: #selector(GRSettingsViewController.toggleNotifications(_:)), for: .valueChanged)
        } else  {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.textLabel?.text = dataSource![indexPath.row]
        cell.textLabel?.textColor = UIColor.grocerestDarkGrayText()
        cell.textLabel?.numberOfLines = 2
        
        return cell
        
    }
    
    func toggleNotifications(_ sender:UISwitch) {
        if sender.isOn {
            self.toggleNotificationsSubscription("rimuovere")
        } else {
            self.toggleNotificationsSubscription("aggiungere")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            return
        case 1:
            self.showPrivacy()
            return
        case 2:
            self.showTOS()
            return
        case 3:
            self.sendFeedback()
            return
        case 4:
            self.showHelp()
        case 5:
            self.showFAQ()
        default:
            print("empty")
            return
        }
    }
    
    
    
    func setDataSource() {
        
//        _ notificheLista = "Ricevi notifiche quando un amico interviene su una lista"
//        _ notificheGrocerest = "Ricevi notifiche da Grocerest"
       // let newsletter = "Newsletter"
//        _ = "Invita Amici"
        let notifiche = "Ricevi notifiche da Grocerest"
        let privacy = "Privacy Policy"
        let termini = "Termini e Condizioni"
        let feedback = "Supporto"
        let simboli = "Simboli"
        let faq = "FAQ"
       // let feedback = "Lascia un feedback"
       // let credits = "Credits"
        
        
        dataSource = [notifiche, privacy, termini, feedback, simboli, faq]
        self.tableView?.reloadData()

        
    }
    
    
    /**
     Toolbar
     
     - parameter menuButton:
     */
    
    func menuButtonWasPressed(_ menuButton: UIButton) {
        toggleSideMenuView()
    }
    
    func grocerestButtonWasPressed(_ grocerestButton: UIButton){
        print("grocerest button")
    }
    
    func scannerButtonWasPressed(_ sender: UIButton){
        let scannerViewController = GRBarcodeScannerViewController()
        self.navigationController?.pushViewController(scannerViewController, animated: false)
        
    }
    
    func searchButtonWasPressed(_ searchButton: UIButton){
        let productSearch = GRProductSearchViewController()
        navigationController?.pushViewController(productSearch, animated: true)
    }
    
    func toggleNotificationsSubscription(_ message:String){
        
            let alertController = UIAlertController (title: "Attenzione", message: "Per \(message) le notifiche vai a settings", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(notificationSettings)
                    UIApplication.shared.openURL(url)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
    }
    
    
    func showFAQ() {
        let documentsViewController = GRDocumentsViewController()
        documentsViewController.pageTitle = "FAQ"
        documentsViewController.document = "faq"
        self.navigationController?.pushViewController(documentsViewController, animated: true)
    }
    
    func showTOS() {
        let documentsViewController = GRDocumentsViewController()
        documentsViewController.pageTitle = "Termini di Servizio"
        documentsViewController.document = "tos"
        self.navigationController?.pushViewController(documentsViewController, animated: true)
    }
    
    
    func showPrivacy() {
        let documentsViewController = GRDocumentsViewController()
        documentsViewController.pageTitle = "Privacy Policy"
        documentsViewController.document = "privacy"
        self.navigationController?.pushViewController(documentsViewController, animated: true)
    }
    
    func sendFeedback() {
        let currentUser = realm.objects(GRCurrentUser.self)
        
        let identity = ZDKAnonymousIdentity()
        identity.name = currentUser[0]["username"] as! String
        identity.email = currentUser[0]["email"] as! String
        ZDKConfig.instance().userIdentity = identity
        
        UINavigationBar.appearance().barTintColor = UIColor.grocerestColor()
        UINavigationBar.appearance().tintColor = UIColor.white
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: Constants.BrandFonts.ubuntuMedium14!], for: UIControlState())
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: Constants.BrandFonts.ubuntuLight18!
        ]
        UINavigationBar.appearance().barStyle = .blackTranslucent
        UINavigationBar.appearance().isTranslucent = false
        
        ZDKRequests.presentRequestList(with: self)
    }
    
//    func sendFeedback() {
//        let mailComposeViewController = configuredMailComposeViewController()
//        if MFMailComposeViewController.canSendMail() {
//            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
//        } else {
//            self.showSendMailErrorAlert()
//        }
//    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["feedback@grocerest.com"])
        mailComposerVC.setSubject("iOS App Feedback")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        let alert = UIAlertController(title: "Error nel invio della mail", message: "Non è stato possibile inviare la mail", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showHelp () {
        let helpViewController = GRHelpViewController()
        self.navigationController?.pushViewController(helpViewController, animated: true)
    }
    
}
