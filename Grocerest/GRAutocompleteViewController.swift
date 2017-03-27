//
//  GRAutocompleteViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 10/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import SwiftyJSON
import RealmSwift


enum SearchingSource : Int {
    case allProducts
    case myProducts
}


class GRAutocompleteViewController: UIViewController, GRSearchBarProtocol, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    var counterProducts = 0

    var pageTitle : String?
    var tableView : UITableView?
    var dataSource: [String]?
    var filteredArray: [JSON]?
    let realm = try! Realm()
    var shouldShowSearchResults = false
    var searchTitle: String?
    
    var queryString = ""
    var lastTerm = ""
    var categoryId : String?
    var topLabel = UILabel()
    
    var delegate : SearchCompletionProtocol?
    
    var searchFromList = false
    var transitioned = false
    
    var searchedLabel = UILabel()
    var manualButton = UIButton(type: .custom)
    
    let tapGesture = UITapGestureRecognizer()
    
    var searchingSource = SearchingSource.allProducts
    


    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GRCommentModalViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        dataSource = []
        setupViews()
        if queryString != "" {
            managedView.searchBar?.searchField?.text = queryString
        }
        
        if searchFromList {
            managedView.formatViewFromSearchFromList()
            if transitioned {
                managedView.searchBar?.searchField?.becomeFirstResponder()
                self.managedView.hideBackgroundBlur(true, alpha: 0.75)
            }
            
        } else {
            managedView.formatViewFromSubCategory()
        }
        
        managedView.segmentedButton.selectedSegmentIndex = searchingSource.rawValue
        
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        managedView.searchBar?.searchField?.becomeFirstResponder()
    }
    
    fileprivate var managedView: GRAutocompleteView {
        return self.view as! GRAutocompleteView
    }
    
    override func loadView() {
        super.loadView()
        let autocomplete = GRAutocompleteView(fromList:searchFromList, productCounter: counterProducts)
        
        view = autocomplete
        managedView.delegate = self
        managedView.searchBar?.delegate = self
        managedView.searchBar?.searchField?.delegate = self
        managedView.searchBar?.searchField?.addTarget(self, action: #selector(GRAutocompleteViewController.textChanged(_:)), for: UIControlEvents.editingChanged)

    }
    
    func setupViews() {

        managedView.addSubview(searchedLabel)
        
        searchedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(managedView.topback.snp.bottom).offset(35 / masterRatio)
            make.left.equalTo(58 / masterRatio)
        }
        searchedLabel.font = Constants.BrandFonts.avenirRoman15
        searchedLabel.textColor = UIColor.white
        searchedLabel.textAlignment = .left
        searchedLabel.alpha = 1.0
        
        managedView.addSubview(manualButton)
        manualButton.snp.makeConstraints { (make) in
            make.height.equalTo(80 / masterRatio)
            make.width.equalTo(managedView.snp.width)
            make.left.equalTo(managedView.snp.left)
            make.centerY.equalTo(searchedLabel.snp.centerY)
        }
        manualButton.addTarget(self, action: #selector(self.startManualSearch(_:)), for: .touchUpInside)
        
        
        managedView.addSubview(topLabel)
        topLabel.text = "Ricerche suggerite"
        managedView.addSubview(topLabel)
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(searchedLabel.snp.bottom).offset(12 / masterRatio)
            make.left.equalTo(34 / masterRatio)
        }
        topLabel.font = Constants.BrandFonts.avenirBook11
        topLabel.textColor = UIColor.grocerestLightGrayColor()
        topLabel.textAlignment = .left
        topLabel.isHidden = true
        
        
        tableView = UITableView(frame: CGRect.zero)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.bounces = true
        tableView?.register(GRAutocompletionTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.backgroundColor = UIColor.clear
        tableView?.separatorStyle = .none
        tableView?.isHidden = false
        tableView?.rowHeight =  80 / masterRatio
        tableView?.keyboardDismissMode = .onDrag
        
        managedView.addSubview(tableView!)
        tableView!.tableFooterView = UIView(frame: CGRect.zero)

        tableView?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(managedView.snp.width)
            make.top.equalTo(topLabel.snp.bottom).offset(12 / masterRatio)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        
        if searchFromList {
            tableView?.snp.makeConstraints({ (make) -> Void in
                make.width.equalTo(managedView.snp.width)
                make.left.equalTo(0)
                make.bottom.equalTo(0)
            })
            
            self.tableView!.addGestureRecognizer(tapGesture)
            tapGesture.addTarget(self, action: #selector(GRAutocompleteViewController.dismissController(_:)))

            
        }
 
    }
    
    

    
    func keyboardWillHide(_ notification: Notification) {
        dismiss(animated: true, completion: nil)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource != nil {
            return (dataSource?.count)!
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : GRAutocompletionTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRAutocompletionTableViewCell
        cell.selectionStyle = .none
        
        if (cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRAutocompletionTableViewCell
        }
        cell.mainLabel?.text = self.dataSource![indexPath.row]
        

   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell! = tableView.cellForRow(at: indexPath)
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        if searchFromList {
            delegate?.startSearchWithQuery(dataSource![indexPath.row], categoryId: "", lastTerm: lastTerm)
        } else {
            delegate?.startSearchWithQuery(dataSource![indexPath.row], categoryId: categoryId!, lastTerm: lastTerm)
        }
        
        dismiss(animated: false, completion: nil)
    }
    
    func autocompletionForSearch() {
        if let title = pageTitle, title != "" {
            let fields: [String: Any] = [
                "query": title,
                "size": 50
            ]
            
            GrocerestAPI.searchProductsCompletion(fields) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }
                
                self.dataSource?.removeAll()
                
                for item in data["items"].arrayValue {
                    self.dataSource?.append(item.string!)
                }
                
                if (self.dataSource?.count)! > 0 {
                    self.tableView?.removeGestureRecognizer(self.tapGesture)
                }
                
                self.tableView?.reloadData()
            }
        }
        
    }
    
    
    func closeButtonWasPressed(_ sender:UIButton) {
        dismiss(animated: false, completion: nil)
        delegate?.startSearchWithQuery("", categoryId: "", lastTerm: lastTerm)
        let nc = self.presentingViewController as! GRNavigationController?
        nc?.popViewController(animated: true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textChanged(_ textField:UITextField) {
        pageTitle = textField.text!
        self.lastTerm = textField.text!
        // self.tableView?.reloadData()
        if textField.text?.characters.count == 0 {
            self.dataSource?.removeAll()
            self.tableView?.isHidden = true
            self.tableView?.reloadData()
            self.tableView?.addGestureRecognizer(tapGesture)
            self.managedView.hideBackgroundBlur(false, alpha: 0.97)
            topLabel.isHidden = true
            searchedLabel.isHidden = true
            self.manualButton.isHidden = true
            
        } else {
            self.tableView?.removeGestureRecognizer(tapGesture)
            autocompletionForSearch()
            self.tableView?.isHidden = false
            self.managedView.hideBackgroundBlur(true, alpha: 0.9)
            topLabel.isHidden = false
            searchedLabel.isHidden = false
            searchedLabel.text = textField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchFromList {
            delegate?.startSearchWithQuery(textField.text!, categoryId: "", lastTerm: lastTerm)
            dismiss(animated: false, completion: nil)
        } else {
            delegate?.startSearchWithQuery(textField.text!, categoryId: categoryId!, lastTerm:  lastTerm)
            dismiss(animated: false, completion: nil)

        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.managedView.hideBackgroundBlur(false, alpha: 0)
        self.manualButton.isHidden = true
        
        textField.text = ""
        self.dataSource?.removeAll()
        self.tableView?.reloadData()
        topLabel.isHidden = true
        searchedLabel.isHidden = true
        self.tableView?.addGestureRecognizer(tapGesture)
        self.view?.bringSubview(toFront: tableView!)

        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        managedView.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        managedView.endEditing(true)
    }
    
    func startManualSearch(_ sender:UIButton){
        let string = managedView.searchBar?.searchField?.text!
        delegate?.startSearchWithQuery(string!, categoryId: "", lastTerm: lastTerm)
        dismiss(animated: true, completion: nil)
    }

    func dismissController(_ sender:UITapGestureRecognizer) {
        delegate?.startSearchWithQuery("", categoryId: "", lastTerm: lastTerm)
        dismiss(animated: true, completion: nil)
    }
    
}
