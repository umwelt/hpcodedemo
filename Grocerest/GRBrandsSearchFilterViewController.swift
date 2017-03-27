//
//  GRBrandsSearchFilterViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/02/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation

class GRBrandsSearchFilterViewController: UIViewController {
    
    var onDismissWithOptions: ((_ options: JSON) -> Void)?
    
    private var defaultOptions: JSON?
    
    private var managedView: GRBrandsSearchFilterView {
        return view as! GRBrandsSearchFilterView
    }
    
    override func loadView() {
        super.loadView()
        
        view = GRBrandsSearchFilterView()
        
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
        
        if let id = self.managedView.selectedCategoryId {
            options["categoryId"] = id
        }
        
        if let slug = self.managedView.selectedCategorySlug {
            options["categorySlug"] = slug
        }
        
        return JSON(options)
    }
    
}
