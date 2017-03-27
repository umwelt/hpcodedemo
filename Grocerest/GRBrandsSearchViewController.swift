//
//  GRBrandsSearchViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/02/17.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation
import SwiftLoader

class GRBrandsSearchViewController: UIViewController {
    
    var onDismissed: (() -> Void)?
    
    func setQuery(to string: String) {
        query = string
        managedView.searchfieldUnfocus()
        managedView.setQuery(to: string)
        getSearchResults(for: query) { resultsData in
            let numberOfResults = resultsData["count"].intValue
            let products = resultsData["items"].arrayValue
            self.managedView.setResults(totalNumber: numberOfResults, brands: products)
        }
    }
    
    private var query: String = ""
    private var category: JSON?
    private var onQueryChangeSearchTask: DispatchWorkItem?
    private var filterOptions = JSON([:])
    
    private var managedView: GRBrandsSearchView {
        return view as! GRBrandsSearchView
    }
    
    override func loadView() {
        super.loadView()
        
        view = GRBrandsSearchView()
        
        managedView.onBackButtonTap = {
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
                self.onDismissed?()
            } else {
                self.dismiss(animated: true, completion: self.onDismissed)
            }
        }
        
        managedView.onQueryChange = { query in
            self.query = query
            
            guard !query.isEmpty else {
                self.managedView.hideAutocomplete()
                return
            }
            
            self.getSuggestedQueries(for: query) { strings in
                self.managedView.showAutocomplete(query: query, suggestedQueries: strings)
            }
            
            // SEARCH ON QUERY CHANGE
            /*
            self.onQueryChangeSearchTask?.cancel()
            
            self.onQueryChangeSearchTask = DispatchWorkItem {
                self.getSearchResults(for: query) { resultsData in
                    let numberOfResults = resultsData["count"].intValue
                    let products = resultsData["items"].arrayValue
                    self.managedView.setResults(totalNumber: numberOfResults, brands: products)
                    self.managedView.searchfieldFocus()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: self.onQueryChangeSearchTask!)
            */
        }
        
        managedView.onSearch = { query in
            self.query = query
            
            self.managedView.hideAutocomplete()
            self.getSearchResults(for: query) { resultsData in
                let numberOfResults = resultsData["count"].intValue
                let products = resultsData["items"].arrayValue
                self.managedView.setResults(totalNumber: numberOfResults, brands: products)
            }
        }
        
        /// Called when a user taps on a product result and then returns from it
        managedView.onReturnFromResult = { lastBrandTappedId in
            self.getBrand(id: lastBrandTappedId!) { updatedBrand in
                self.managedView.updateResult(brand: updatedBrand)
            }
        }
        
        managedView.onFilterButtonTap = {
            let filterVC = GRBrandsSearchFilterViewController()
            filterVC.setDefault(options: self.filterOptions)
            
            filterVC.onDismissWithOptions = { options in
                print("Dismissed with options: \n", options)
                self.filterOptions = options
                
                guard !self.query.isEmpty else { return }
                
                SwiftLoader.show(animated: true)
                self.getSearchResults(for: self.query) { resultsData in
                    let numberOfResults = resultsData["count"].intValue
                    let products = resultsData["items"].arrayValue
                    self.managedView.setResults(totalNumber: numberOfResults, brands: products)
                    SwiftLoader.hide()
                }
            }
            
            self.modalTransitionStyle = .coverVertical
            self.present(filterVC, animated: true)
        }
        
        managedView.searchfieldFocus()
    }
    
    private func getSearchResults(for query: String, completion: @escaping (_ resultsData: JSON) -> Void) {
        SwiftLoader.show(animated: true)
        
        var options: [String: Any] = [
            "size": 100
        ]
        
        if !query.isEmpty {
            options["query"] = query
        }
        
        if let slug = filterOptions["categorySlug"].string {
            options["category"] = slug
        }
        
        print("OPTIONS", options)
        
        GrocerestAPI.searchBrand(fields: options) { data, error in
            SwiftLoader.hide()
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            completion(data)
        }
    }
    
    private func getSuggestedQueries(for query: String, completion: @escaping (_ queries: [String]) -> Void) {
        GrocerestAPI.searchProductsCompletion(["query": query, "size": 25]) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            var queries: [String] = []
            for item in data["items"].arrayValue {
                queries.append(item.stringValue)
            }
            completion(queries)
        }
    }
    
    func getBrand(id brandId: String, completion: @escaping (_ brandData: JSON) -> Void) {
        SwiftLoader.show(animated: true)
        
        GrocerestAPI.getBrand(brandId) { data, error in
            SwiftLoader.hide()
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            completion(data)
        }
    }
    
}
