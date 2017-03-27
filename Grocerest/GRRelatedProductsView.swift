//
//  GRRelatedProductsView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 05/01/17.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation
import SnapKit

class GRRelatedProductsView: UIView, UICollectionViewDataSource {

    var onTap: ((_ product: JSON) -> Void)?
    
    /* Downloaded products */
    private var products = [JSON]()
    
    private var productsCollectionView: UICollectionView!
    
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
    
    private func initialization() {
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        snp.makeConstraints { make in
            make.width.equalTo(750 / masterRatio)
            make.height.equalTo(320 / masterRatio)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20 / masterRatio
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: 284 / masterRatio, height: 320 / masterRatio)
        layout.scrollDirection = .horizontal
        
        productsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        productsCollectionView.contentInset = UIEdgeInsetsMake(0, 32 / masterRatio, 0, 32 / masterRatio)
        productsCollectionView.backgroundColor = UIColor.clear
        productsCollectionView.bounces = false
        productsCollectionView.showsHorizontalScrollIndicator = false
        productsCollectionView.isPagingEnabled = false
        productsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        productsCollectionView.dataSource = self
        addSubview(productsCollectionView)
        productsCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    // MARK: Categories Configuration
    
    
    // Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        var product: GRRelatedProductView!
        
        // If the category widget has already been added to this cell simply reuse it
        if cell.contentView.subviews.count > 0 {
            product = cell.contentView.subviews.first as! GRRelatedProductView
            // Else create a new category widget and add it to the cell's contentView
        } else {
            product = GRRelatedProductView()
            cell.contentView.addSubview(product)
            product.snp.makeConstraints { make in
                make.left.top.equalTo(cell)
            }
        }
        
        var productData = products[indexPath.row]
        if let imgUrl = productData["images"]["small"].string {
            product.setImageFromURL(URL(string: String.fullPathForImage(imgUrl))!)
        } else {
            product.productImage = UIImage(named: "products_" + productData["category"].stringValue)
        }
        product.productName = productData["display_name"].stringValue
        product.productBrand = productData["display_brand"].stringValue
        product.averageReviewsScore = productData["reviews"]["average"].doubleValue
        product.numberOfReviews = productData["reviews"]["count"].intValue
        product.onTap = {
            self.onTap?(productData)
        }
        
        return cell
    }
    
    func populate(with products: [JSON]) {
        self.products = products
        productsCollectionView.reloadData()
    }
    
}
