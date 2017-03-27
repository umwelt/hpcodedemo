//
//  GRNewProductSearchResultsView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 21/12/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

fileprivate class ReturnFromResultController: UIViewController, GRLastIdTappedCacher, GRModalViewControllerDelegate {
    
    var onReturnFromResult: ((_ lastProductTappedId: String?) -> Void)?
    
    /// WARNING: do not set/get directly. Use `onReturnFromResult` callback instead
    var lastTappedId: String?
    
    /// WARNING: do not call directly. Use `onReturnFromResult` callback instead
    func modalWasDismissed(_ modal: UIViewController) {
        onReturnFromResult?(lastTappedId)
    }
    
}

@IBDesignable
class GRProductSearchResultsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var category: JSON?
    
    /// Called when a user taps on a product result and then returns from it
    var onReturnFromResult: ((_ lastProductTappedId: String?) -> Void)? {
        didSet {
            returnFromResultController.onReturnFromResult = onReturnFromResult
        }
    }
    
    var isRankHidden = true
    
    /// Called when the user scrolls down and is about to finish all downloaded products
    var onRequiresMoreResults: ((_ fromResultNumber: Int) -> Void)?
    
    private var totalNumberOfResults = 0
    private var results: [JSON] = []
    private let returnFromResultController = ReturnFromResultController()
    
    private let resultsLabel = UILabel()
    private let tableView = UITableView(frame: CGRect.zero)
    
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
        resultsLabel.text = "0 risultati"
        resultsLabel.font = .avenirBook(22)
        resultsLabel.textColor = UIColor(hexString: "979797")
        
        tableView.bounces = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "header")
        tableView.register(GRProductsResultTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalTo(self) }
    }
    
    // ** View's public methods **
    
    func setResults(totalNumber: Int, products: [JSON], category: JSON? = nil) {
        self.category = category
        totalNumberOfResults = totalNumber
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let counterLocalized = formatter.string(from: NSNumber(value: totalNumber)) ?? totalNumber.description
        
        resultsLabel.text = totalNumber == 1 ? "1 risultato" : "\(counterLocalized) risultati"
        if let categorySlug = category?["slug"].stringValue {
            resultsLabel.text?.append(" in \(categoryNameFromCategorySlug(categorySlug))")
        }
        
        results = products
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    func appendResults(products: [JSON]) {
        results.append(contentsOf: products)
        tableView.reloadData()
    }
    
    func updateResult(product: JSON) {
        if let i = results.index(where: { $0["_id"].stringValue == product["_id"].stringValue }) {
            results[i] = product
            tableView.reloadData()
        }
    }
    
    // ** Table view **
    
    // Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0 ? 80 : 332+20) / masterRatio
    }
    
    // Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Header
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath)
            cell.backgroundColor = .clear
            if cell.contentView.subviews.isEmpty {
                cell.contentView.addSubview(resultsLabel)
                resultsLabel.snp.makeConstraints { make in
                    make.left.equalTo(cell.contentView).offset(30 / masterRatio)
                    make.bottom.equalTo(cell.contentView).offset(-10 / masterRatio)
                }
            }
            return cell
        } else {
            // Result
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRProductsResultTableViewCell
            let product = results[indexPath.row]
            // Doesn't show ranking for products without reviews
            if product["reviews"]["count"].intValue != 0 {
                cell.isRankHidden = self.isRankHidden
                cell.rank = indexPath.row + 1
            } else {
                cell.isRankHidden = true
            }
            cell.populateWith(product: product, from: returnFromResultController)
            if results.count < totalNumberOfResults && results.count - indexPath.row <= 15 {
                onRequiresMoreResults?(results.count)
            }
            return cell
        }
    }
    
}
