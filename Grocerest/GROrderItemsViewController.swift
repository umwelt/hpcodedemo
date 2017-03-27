//
//  GROrderItemsViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/04/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON



enum OrderFilters: String {
    case Categorie = "category"
    case Alfabetico = "name"
    case Inserimento = "tsUpdated"
}

enum ModeFilters: String {
    case ASC = "asc"
    case DSC = "desc"
}

class GROrderItemsViewController: UIViewController {
    
    var orderingModel = [String:String]()
    let userDefaults = UserDefaults.standard
    var orderVal = 0
    var filterVal = 0
    
    weak var sortDelegate = GRShoppingListViewController()
    
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        let outModel = userDefaults.data(forKey: "filtersModel") 
        if outModel != nil {
            let filters = NSKeyedUnarchiver.unarchiveObject(with: outModel!) as? NSDictionary
            setFilterStatus(filters! as AnyObject)
            
            setOrderModel(filters!["filter"] as! String, mode: filters!["mode"] as! String)
        } else {
            setOrderModel(OrderFilters.Categorie.rawValue, mode: "desc")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        managedView.startSlideViewAnimation()   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate var managedView: GROrderItemsView {
        return self.view as! GROrderItemsView
    }
    
    override func loadView() {
        super.loadView()
        view = GROrderItemsView()
        managedView.delegate = self
    }
    
    func setupViews() {}
    
    func confirmAction(_ sender:UIButton) {
        managedView.removeSlideViewAnimation()
        
        let filtersModel = NSKeyedArchiver.archivedData(withRootObject: orderingModel)
        userDefaults.set(filtersModel, forKey: "filtersModel")
        userDefaults.synchronize()
        sortDelegate?.updateTable()
       // sortDelegate?.sortDataSourceWithModel(orderingModel["filter"]!, mode: orderingModel["mode"]!, reload: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelAction(_ sender:UIButton) {
        managedView.removeSlideViewAnimation()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setOrderModel(_ filter:OrderFilters.RawValue, mode:ModeFilters.RawValue) {
        orderingModel["filter"] = filter
        orderingModel["mode"] = mode
    }
    
    
    func setModeFilterWasPressed(_ sender:UIButton) {
        
        orderVal = sender.tag
        switch sender.tag {
        case 0:
            orderingModel["mode"] = ModeFilters.DSC.rawValue
            managedView.moveBackGroundImagetoSender(orderVal)
            return
        case 1:
            orderingModel["mode"] = ModeFilters.ASC.rawValue
            managedView.moveBackGroundImagetoSender(orderVal)
            return
        default:
            return
        }
    }
    
    func filterButtonWasPressed(_ sender:UIButton) {
        
        filterVal = sender.tag
        
        switch sender.tag {
        case 10:
            orderingModel["filter"] = OrderFilters.Categorie.rawValue
            managedView.moveModeSelectionButtonsToFilter(filterVal)
            return
        case 11:
            orderingModel["filter"] = OrderFilters.Alfabetico.rawValue
            managedView.moveModeSelectionButtonsToFilter(filterVal)
            return
        case 12:
            orderingModel["filter"] = OrderFilters.Inserimento.rawValue
            managedView.moveModeSelectionButtonsToFilter(filterVal)
            return
        default:
            return
        }
        
    }
    
    func setFilterStatus(_ filters:AnyObject) {
        
        if filters["filter"] as! String == OrderFilters.Categorie.rawValue {
            self.managedView.moveModeSelectionButtonsToFilter(10)
        } else if filters["filter"] as! String == OrderFilters.Alfabetico.rawValue {
            self.managedView.moveModeSelectionButtonsToFilter(11)
        } else if filters["filter"] as! String == OrderFilters.Inserimento.rawValue {
            self.managedView.moveModeSelectionButtonsToFilter(12)
        }
        
        if filters["mode"] as! String == ModeFilters.DSC.rawValue {
            self.managedView.moveBackGroundImagetoSender(0)
        } else if filters["mode"] as! String == ModeFilters.ASC.rawValue {
            self.managedView.moveBackGroundImagetoSender(1)
        }
        
        
        
    }

    
}


