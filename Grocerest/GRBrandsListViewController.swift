//
//  GRBrandsListViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 02/02/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation
import SwiftLoader

class GRBrandsListViewController: UIViewController, GRToolBarProtocol {

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var managedView: GRBrandsListView {
        return self.view as! GRBrandsListView
    }
    
    override func loadView() {
        super.loadView()
        view = GRBrandsListView()
        managedView.toolbar.delegate = self
    }
    
    override func viewDidLoad() {
        let api = GrocerestAPI.self
        let brands = self.managedView.resultsView
        
        SwiftLoader.show(animated: true)
        api.searchBrand { data, error in
            defer { SwiftLoader.hide() }
            guard api.isRequestSuccessful(for: data, and: error) else { return }
            let count = data["count"].intValue,
                results = data["items"].arrayValue
            brands.setResults(totalNumber: count, products: results)
        }
    }
    
    // Toolbar callbacks
    
    func menuButtonWasPressed(_ menuButton: UIButton) {
        toggleSideMenuView()
    }
    
    func scannerButtonWasPressed(_ sender: UIButton) {
        let scannerViewController = GRBarcodeScannerViewController()
        navigationController?.pushViewController(scannerViewController, animated: false)
    }
    
    func searchButtonWasPressed(_ searchButton: UIButton) {
        let brandsSearch = GRBrandsSearchViewController()
        navigationController?.pushViewController(brandsSearch, animated: true)
    }
    
}
