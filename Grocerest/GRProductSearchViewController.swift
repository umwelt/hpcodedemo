//
//  GRProductSearchViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 21/12/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SwiftLoader

class GRProductSearchViewController: UIViewController {
    
    var onDismissed: (() -> Void)?
    
    func setQuery(to string: String) {
        query = string
        managedView.searchfieldUnfocus()
        managedView.setQuery(to: string)
        getSearchResults(for: query) { resultsData in
            let numberOfResults = resultsData["count"].intValue
            let products = resultsData["items"].arrayValue
            self.managedView.setResults(totalNumber: numberOfResults, products: products)
        }
    }
    
    // Used inside categories section to show the products of a specific
    // category.
    func setCategory(_ category: JSON) {
        self.category = category
        managedView.searchfieldUnfocus()
        getSearchResults(for: query) { resultsData in
            let numberOfResults = resultsData["count"].intValue
            let products = resultsData["items"].arrayValue
            self.managedView.setResults(totalNumber: numberOfResults, products: products, category: category)
        }
    }
    
    private var query: String = ""
    private var category: JSON?
    private var isDownloading: Bool = false
    private var filterOptions: JSON = JSON(["orderBy": "reputation"])
    
    private var managedView: GRProductSearchView {
        return view as! GRProductSearchView
    }
    
    override func loadView() {
        super.loadView()
        
        view = GRProductSearchView()
        
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
            
            if query.isEmpty {
                self.managedView.hideAutocomplete()
            } else {
                self.getSuggestedQueries(for: query) { strings in
                    self.managedView.showAutocomplete(query: query, suggestedQueries: strings)
                }
            }
        }
        
        managedView.onSearch = { query in
            self.query = query
            
            self.managedView.hideAutocomplete()
            self.getSearchResults(for: query) { resultsData in
                let numberOfResults = resultsData["count"].intValue
                let products = resultsData["items"].arrayValue
                self.managedView.setResults(totalNumber: numberOfResults, products: products)
            }
        }
        
        managedView.onRequiresMoreResults = { fromResultNumber in
            if !self.isDownloading {
                self.isDownloading = true
                // Get more reviews from the API and then reload the cell
                self.getSearchResults(for: self.query, from: fromResultNumber) { resultsData in
                    // If it's empty then it means there will be no more results 
                    // from the server because it has reached its hard limit
                    let products = resultsData["items"].arrayValue
                    if !products.isEmpty {
                        self.managedView.appendResults(products: products)
                        self.isDownloading = false
                    }
                }
            }
        }
        
        /// Called when a user taps on a product result and then returns from it
        managedView.onReturnFromResult = { lastProductTappedId in
            self.getProduct(id: lastProductTappedId!) { updatedProduct in
                self.managedView.updateResult(product: updatedProduct)
            }
        }
        
        managedView.onFilterButtonTap = {
            let productSearchFilter = GRProductSearchFilterViewController()
            if let category = self.category {
                if let parents = category["parents"].array {
                    // We come from subcategory section, so we must pass the
                    // generic category and disable category selection.
                    self.filterOptions["category"].string = parents.first?.string
                    self.filterOptions["subcategoryName"].string = categoryNameFromCategorySlug(category["slug"].stringValue)
                } else {
                    // We come from macrocategory section, so we must pass the
                    // generic category and disable category selection.
                    self.filterOptions["category"].string = category["_id"].stringValue
                }
                productSearchFilter.isCategorySelectionDisabled = true
            }
            productSearchFilter.setDefault(options: self.filterOptions)
            
            productSearchFilter.onDismissWithOptions = { options in
                print("Dismissed with options: \n", options)
                self.filterOptions = options
                
                SwiftLoader.show(animated: true)
                self.getSearchResults(for: self.query) { resultsData in
                    let numberOfResults = resultsData["count"].intValue
                    let products = resultsData["items"].arrayValue
                    self.managedView.setResults(totalNumber: numberOfResults, products: products)
                    SwiftLoader.hide()
                }
            }
            
            self.modalTransitionStyle = .coverVertical
            self.present(productSearchFilter, animated: true)
        }
        
        managedView.searchfieldFocus()
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
    
    private func getSearchResults(for query: String, from resultNumber: Int? = nil, completion: @escaping (_ resultsData: JSON) -> Void) {
        SwiftLoader.show(animated: true)
        
        var options: [String: Any] = [
            "generic": false,
            "strict": true,
            "limit": 40
        ]
        
        if !query.isEmpty {
            options["query"] = query
        }
        
        if let step = resultNumber {
            options["step"] = step
        }
        
        if let orderBy = filterOptions["orderBy"].string {
            if orderBy == "reputation" {
                managedView.isResultsRankHidden = false
            } else {
                managedView.isResultsRankHidden = true
            }
            options["order_by"] = orderBy
        }
        
        if let own = filterOptions["ownProductsOnly"].bool {
            options["own"] = own
        }
        
        if filterOptions["productsWithoutReviewsOnly"].boolValue {
            options["max_rating"] = 0
        } else if let minimumRating = filterOptions["minimumRating"].int {
            options["min_rating"] = minimumRating
        }
        
        if let category = category?["_id"].stringValue {
            options["category"] = category
        } else if let category = filterOptions["category"].string {
            options["category"] = category
        }
        
        print("OPTIONS", options)
        
        GrocerestAPI.searchProductsForList(GRUser.sharedInstance.id!, fields: options) { data, error in
            SwiftLoader.hide()
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            completion(data)
        }
    }
    
    func getProduct(id productId: String, completion: @escaping (_ productData: JSON) -> Void) {
        SwiftLoader.show(animated: true)
        
        GrocerestAPI.getProduct(productId) { data, error in
            SwiftLoader.hide()
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            completion(data)
        }
    }
    
}
