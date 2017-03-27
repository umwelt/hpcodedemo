//
//  GRProductSearchFilterViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 28/12/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRProductSearchFilterViewController: UIViewController {
    
    var onDismissWithOptions: ((_ options: JSON) -> Void)?
    
    var isCategorySelectionDisabled: Bool {
        get {
            return managedView.isCategorySelectionDisabled
        }
        set {
            managedView.isCategorySelectionDisabled = newValue
        }
    }
    
    private var defaultOptions: JSON?
    
    private var managedView: GRProductSearchFilterView {
        return view as! GRProductSearchFilterView
    }
    
    override func loadView() {
        super.loadView()
        
        view = GRProductSearchFilterView()
        
        managedView.onDismissButtonTap = {
            self.dismiss(animated: true)
        }
        
        managedView.onAcceptButtonTap = {
            let options = self.collectOptions()
            self.dismiss(animated: true)
            self.onDismissWithOptions?(options)
        }
    }
    
    func setDefault(options: JSON) {
        managedView.setDefault(options: options)
        defaultOptions = collectOptions()
        
        managedView.onOptionsChanged = {
            if let defaultOptions = self.defaultOptions {
                let currentOptions = self.collectOptions()
                self.managedView.isAcceptButtonEnabled = currentOptions != defaultOptions
            }
        }
    }
    
    func collectOptions() -> JSON {
        var options: [String: Any] = [:]
        
        if let orderBy = self.managedView.orderBy {
            options["orderBy"] = orderBy
        }
        
        options["ownProductsOnly"] = self.managedView.ownProductsOnlyFilter
        
        let productsWithoutReviewsOnlyFilter = self.managedView.productsWithoutReviewsOnlyFilter
        options["productsWithoutReviewsOnly"] = productsWithoutReviewsOnlyFilter
        
        let minimumRating = self.managedView.minimumRating
        if !productsWithoutReviewsOnlyFilter && minimumRating > 0 {
            options["minimumRating"] = minimumRating
        }
        
        if let id = self.managedView.selectedCategoryId,
            !self.managedView.isCategorySelectionDisabled {
            options["category"] = id
        }
        
        return JSON(options)
    }
    
}
