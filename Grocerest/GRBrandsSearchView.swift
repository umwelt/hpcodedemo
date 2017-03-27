//
//  GRBrandsSearchView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/02/17.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation

fileprivate class CustomButtonWithExtendedTouchArea: UIButton {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsetsMake(-10/masterRatio, -10/masterRatio, -10/masterRatio, -10/masterRatio)
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
    
}

@IBDesignable
class GRBrandsSearchView: UIView, UITextFieldDelegate {
    
    var onBackButtonTap,
        onFilterButtonTap: (() -> Void)?
    
    var onQueryChange,
        onSearch: ((_ query: String) -> Void)?
    
    /// Called when a user taps on a product result and then returns from it
    var onReturnFromResult: ((_ lastProductTappedId: String?) -> Void)? {
        didSet {
            searchResultsView.onReturnFromResult = onReturnFromResult
        }
    }
    
    var onRequiresMoreResults: ((_ fromResultNumber: Int) -> Void)? {
        didSet {
            searchResultsView.onRequiresMoreResults = onRequiresMoreResults
        }
    }
    
    func setQuery(to string: String) {
        searchField.text = string
    }
    
    var isResultsRankHidden = true {
        didSet {
            searchResultsView.isRankHidden = isResultsRankHidden
        }
    }
    
    private let searchField = UITextField()
    private let bottomViewContainer = UIView()
    private let autocompletionView = GRProductSearchAutocompletionView()
    private let searchResultsView = GRBrandsSearchResultsView()
    
    private var bottomView: UIView! {
        // Replaces the old bottom view with a new one
        didSet {
            for subview in bottomViewContainer.subviews {
                subview.snp.removeConstraints()
                subview.removeFromSuperview()
            }
            
            bottomViewContainer.addSubview(bottomView)
            bottomView.snp.makeConstraints { make in
                make.edges.equalTo(bottomViewContainer)
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    // Used by running iOS app
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    // Used by Inteface Builder
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    private func initialization() {
        backgroundColor = UIColor(hexString: "F2F2F2")
        
        // ** Search Bar **
        
        let searchBar = UIView()
        searchBar.backgroundColor = .white
        addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            make.height.equalTo(148 / masterRatio)
        }
        
        let backButton = CustomButtonWithExtendedTouchArea(type: .custom)
        backButton.addTarget(self, action: #selector(self._backButtonTapped(_:)), for: .touchUpInside)
        backButton.adjustsImageWhenHighlighted = true
        backButton.setImage(UIImage(named: "back_lampone"), for: UIControlState())
        searchBar.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.width.equalTo(18 / masterRatio)
            make.height.equalTo(34 / masterRatio)
            make.left.equalTo(self).offset(33 / masterRatio)
            make.bottom.equalTo(searchBar.snp.bottom).offset(-27 / masterRatio)
        }
        
        let searchIcon = UIImageView()
        searchIcon.contentMode = .center
        searchIcon.image = UIImage(named: "off-search-icon")
        searchBar.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { make in
            make.width.equalTo(29 / masterRatio)
            make.height.equalTo(28 / masterRatio)
            make.left.equalTo(backButton.snp.right).offset(42 / masterRatio)
            make.bottom.equalTo(searchBar.snp.bottom).offset(-29 / masterRatio)
        }
        
        let filterButton = CustomButtonWithExtendedTouchArea(type: .custom)
        filterButton.addTarget(self, action: #selector(self._filterButtonTapped(_:)), for: .touchUpInside)
        filterButton.adjustsImageWhenHighlighted = true
        filterButton.setImage(UIImage(named: "product-search-filter"), for: UIControlState())
        searchBar.addSubview(filterButton)
        filterButton.snp.makeConstraints { make in
            make.width.equalTo(42 / masterRatio)
            make.height.equalTo(36 / masterRatio)
            make.right.equalTo(self).offset(-30 / masterRatio)
            make.bottom.equalTo(searchBar.snp.bottom).offset(-27 / masterRatio)
        }
        
        searchField.font = .avenirBook(30)
        searchField.textColor = UIColor(hexString: "979797")
        searchField.returnKeyType = .search
        searchField.placeholder = "Cerca Brand"
        searchField.clearButtonMode = .always
        searchField.autocorrectionType = .yes
        searchField.autocapitalizationType = .none
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
        searchBar.addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.height.equalTo(80 / masterRatio)
            make.left.equalTo(searchIcon.snp.right).offset(25 / masterRatio)
            make.right.equalTo(filterButton.snp.left).offset(-25 / masterRatio)
            make.centerY.equalTo(searchIcon)
        }
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor(hexString: "C8C7CC")
        searchBar.addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(searchBar)
            make.height.equalTo(1 / masterRatio)
        }
        
        // ** Bottom view **
        
        bottomViewContainer.backgroundColor = .clear
        addSubview(bottomViewContainer)
        bottomViewContainer.snp.makeConstraints { make in
            make.top.equalTo(bottomBorder.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
        
        autocompletionView.isHidden = true
        addSubview(autocompletionView)
        autocompletionView.snp.makeConstraints { make in
            make.top.equalTo(bottomBorder.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
        
        autocompletionView.onTypedQueryTap = { query in
            self.onSearch?(query)
        }
        
        autocompletionView.onSuggestedQueryTap = { suggestedQuery in
            self.searchField.text = suggestedQuery
            self.onSearch?(suggestedQuery)
        }
        
        bottomView = GRProductSearchPlaceholder()
    }
    
    // ** View public methods **
    
    func showAutocomplete(query: String, suggestedQueries: [String]) {
        autocompletionView.typedQuery = query
        autocompletionView.suggestedQueries = suggestedQueries
        
        if autocompletionView.isHidden {
            autocompletionView.isHidden = false
            
            autocompletionView.alpha = 0
            UIView.animate(withDuration: 0.2) {
                self.autocompletionView.alpha = 1
            }
        }
    }
    
    func hideAutocomplete() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.autocompletionView.alpha = 0
        },
            completion: { _ in
                self.autocompletionView.isHidden = true
                self.autocompletionView.suggestedQueries = []
        }
        )
    }
    
    func setResults(totalNumber: Int, brands: [JSON], category: JSON? = nil) {
        searchField.resignFirstResponder()
        searchResultsView.setResults(totalNumber: totalNumber, products: brands, category: category)
        bottomView = searchResultsView
    }
    
    func appendResults(brand: [JSON]) {
        searchResultsView.appendResults(products: brand)
    }
    
    func updateResult(brand: JSON) {
        searchResultsView.updateResult(product: brand)
    }
    
    func searchfieldFocus() {
        searchField.becomeFirstResponder()
    }
    
    func searchfieldUnfocus() {
        searchField.resignFirstResponder()
    }
    
    // ** Buttons callbacks **
    
    func _backButtonTapped(_ sender: UIButton) {
        onBackButtonTap?()
    }
    
    func _filterButtonTapped(_ sender: UIButton) {
        onFilterButtonTap?()
    }
    
    // ** Search Field events **
    
    func textFieldChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text.isEmpty {
            bottomView = GRProductSearchPlaceholder()
        }
        onQueryChange?(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = textField.text, !query.isEmpty {
            onSearch?(query)
            return true
        }
        return false
    }
    
}
