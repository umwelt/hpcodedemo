//
//  GRCategoriesToExplore.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 12/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SnapKit

class GRCategoriesToExplore: UIView, UICollectionViewDataSource {
    
    fileprivate let categories: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20 / masterRatio
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: 284 / masterRatio, height: 320 / masterRatio)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    var categoriesSlugs = [String]() {
        didSet {
            categories.reloadData()
        }
    }
    
    var numberOfProductsInCategories = [Int]() {
        didSet {
            categories.reloadData()
        }
    }
    
    var onTap: ((_ categorySlug: String) -> Void)?
    
    // Used by running iOS app
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialization()
    }
    
    // Used by Inteface Builder
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialization()
    }
    
    fileprivate func initialization() {
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        snp.makeConstraints { make in
            make.width.equalTo(750 / masterRatio)
            make.height.equalTo(320 / masterRatio)
        }
        
        categories.contentInset = UIEdgeInsetsMake(0, 32 / masterRatio, 0, 32 / masterRatio)
        categories.backgroundColor = UIColor.clear
        categories.bounces = false
        categories.showsHorizontalScrollIndicator = false
        categories.isPagingEnabled = false
        categories.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        categories.dataSource = self
        
        addSubview(categories)
        
        categories.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        categoriesSlugs = ["Alimentari", "Bevande", "Alimentari", "Bevande", "Alimentari", "Bevande"]
        numberOfProductsInCategories = [12, 1204, 323, 0, 56, 2304]
        onTap = { categorySlug in
            print("CATEGORY: \(categorySlug)")
        }
    }
    
    // MARK: Categories Configuration
    
    
    // Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesSlugs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        var category: GRCategoryToExplore!
        
        // If the category widget has already been added to this cell simply reuse it
        if cell.contentView.subviews.count > 0 {
            category = cell.contentView.subviews.first as! GRCategoryToExplore
        // Else create a new category widget and add it to the cell's contentView
        } else {
            category = GRCategoryToExplore()
            cell.contentView.addSubview(category)
            category.snp.makeConstraints { make in
                make.left.top.equalTo(cell)
            }
        }
        
        let categorySlug = categoriesSlugs[indexPath.row]
        category.categorySlug = categorySlug
        
        let numberOfProducts = numberOfProductsInCategories[indexPath.row]
        category.numberOfProducts = numberOfProducts
        
        if numberOfProducts == 0 {
            category.onTap = nil
        } else {
            category.onTap = {
                self.onTap?(categorySlug)
            }
        }
        
        return cell
    }
    
}
