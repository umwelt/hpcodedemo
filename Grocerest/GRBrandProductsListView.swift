//
//  GRBrandProductsListView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 13/02/17.
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
class GRBrandProductsListView: UIView {
    
    var onBackButtonTap: (() -> Void)?
    
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
    
    var isResultsRankHidden = true {
        didSet {
            searchResultsView.isRankHidden = isResultsRankHidden
        }
    }
    
    let navigationToolBar = GRToolbar()
    private let searchResultsView = GRProductSearchResultsView()
    
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
        
        // ** Navigation bar **
        
        addSubview(navigationToolBar)
        navigationToolBar.snp.makeConstraints { make in
            make.top.left.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
        }
        
        // ** Bottom view **
        
        addSubview(searchResultsView)
        searchResultsView.snp.makeConstraints { make in
            make.top.equalTo(navigationToolBar.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
    }
    
    // ** View public methods **
    
    func setResults(totalNumber: Int, products: [JSON], category: JSON? = nil) {
        searchResultsView.setResults(totalNumber: totalNumber, products: products, category: category)
    }
    
    func appendResults(products: [JSON]) {
        searchResultsView.appendResults(products: products)
    }
    
    func updateResult(product: JSON) {
        searchResultsView.updateResult(product: product)
    }
    
    // ** Buttons callbacks **
    
    func _backButtonTapped(_ sender: UIButton) {
        onBackButtonTap?()
    }
}
