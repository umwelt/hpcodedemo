//
//  GRBrandsSearchResultsView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 02/02/2017.
//  Copyright © 2017 grocerest. All rights reserved.
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
class GRBrandsSearchResultsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var category: JSON?
    
    var topMode = false // if true results label shows "Top 20 brands"
    
    /// Called when a user taps on a product result and then returns from it
    var onReturnFromResult: ((_ lastProductTappedId: String?) -> Void)? {
        didSet {
            returnFromResultController.onReturnFromResult = onReturnFromResult
        }
    }
    
    var isRankHidden = false
    
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
        if (topMode) {
            resultsLabel.text = "Top 20 brands"
        } else {
            resultsLabel.text = "Caricamento…"
        }
        resultsLabel.font = .avenirBook(22)
        resultsLabel.textColor = UIColor(hexString: "979797")
        
        tableView.bounces = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "header")
        tableView.register(GRBrandsResultTableViewCell.self, forCellReuseIdentifier: "cell")
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
        
        if topMode {
            resultsLabel.text = "Top 20 brands"
        } else {
            resultsLabel.text = totalNumber == 1 ? "1 risultato" : "\(counterLocalized) risultati"
        }
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
        if let i = results.index(where: { $0["name"].stringValue == product["name"].stringValue }) {
            results[i]["reviews"].int = product["reviews"].int
            results[i]["average"].double = product["average"].double
            tableView.reloadData()
        }
    }
    
    // ** Table view **
    
    // Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0 ? 80 : 280+20) / masterRatio
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRBrandsResultTableViewCell
            let brand = results[indexPath.row]
            // Doesn't show ranking for brands  without reviews
            if brand["reviews"].intValue != 0 {
                cell.isRankHidden = self.isRankHidden
                cell.rank = indexPath.row + 1
            } else {
                cell.isRankHidden = true
            }
            cell.populateWith(brand: brand, from: returnFromResultController)
            if results.count < totalNumberOfResults && results.count - indexPath.row <= 15 {
                onRequiresMoreResults?(results.count)
            }
            return cell
        }
    }
    
}
