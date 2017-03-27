//
//  GRReviewsToComplete.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 14/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SnapKit

class GRReviewsToComplete: UIView, UICollectionViewDataSource {
    
    fileprivate let reviewsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20 / masterRatio
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: 284 / masterRatio, height: 320 / masterRatio)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    /* The author of the reviews */
    private var userId: String?
    /* Total number of reviews */
    fileprivate var numberOfReviews = 0
    /* Downloaded reviews */
    fileprivate var reviews = [JSON]()
    
    var onTap: ((_ review: JSON) -> Void)?
    
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
        
        reviewsCollectionView.contentInset = UIEdgeInsetsMake(0, 32 / masterRatio, 0, 32 / masterRatio)
        reviewsCollectionView.backgroundColor = UIColor.clear
        reviewsCollectionView.bounces = false
        reviewsCollectionView.showsHorizontalScrollIndicator = false
        reviewsCollectionView.isPagingEnabled = false
        reviewsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        reviewsCollectionView.dataSource = self
        
        addSubview(reviewsCollectionView)
        
        reviewsCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        let review = [
            "rating": 4,
            "product": [
                "display_name": "Marmellata Scorpacciata",
                "brand": "Scorpacciata",
                "category": "Alimentari"
            ]
        ] as [String: Any]
        reviews = [JSON(review), JSON(review), JSON(review), JSON(review), JSON(review)]
    }
    
    // MARK: Categories Configuration
    
    
    // Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfReviews
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        var review: GRReviewToComplete!
        
        // If the category widget has already been added to this cell simply reuse it
        if cell.contentView.subviews.count > 0 {
            review = cell.contentView.subviews.first as! GRReviewToComplete
            // Else create a new category widget and add it to the cell's contentView
        } else {
            review = GRReviewToComplete()
            cell.contentView.addSubview(review)
            review.snp.makeConstraints { make in
                make.left.top.equalTo(cell)
            }
        }
        
        // If the review hasn't been downloaded yet then we return an empty cell
        if indexPath.row >= reviews.count {
            review.productImage = nil
            review.productName = ""
            review.productBrand = ""
            review.rating = 0
            review.onTap = nil
        } else {
            var reviewData = reviews[indexPath.row]
            if let imgUrl = reviewData["product"]["images"]["small"].string {
                review.setImageFromURL(URL(string: String.fullPathForImage(imgUrl))!)
            } else {
                review.productImage = UIImage(named: "products_" + reviewData["product"]["category"].stringValue)
            }
            review.productName = reviewData["product"]["display_name"].stringValue
            review.productBrand = reviewData["product"]["display_brand"].stringValue
            review.rating = reviewData["rating"].intValue
            review.onTap = {
                self.onTap?(reviewData)
            }
        }
        
        
        if !isDownloading && reviews.count < numberOfReviews && reviews.count - indexPath.row <= 10 {
            // Get more reviews from the API and then reload the cell
            downloadReviews()
        }
        
        
        return cell
    }
    
    fileprivate var isDownloading = false
    
    fileprivate func downloadReviews() {
        if userId == nil {
            print("ReviewsToComplete: cannot download reviews without knowing the author")
            return
        }

        if numberOfReviews > 0 && reviews.count >= numberOfReviews {
            print("No more reviews to fetch")
            return
        }
        
        isDownloading = true
        
        let fields = [
            "author": userId!,
            "step": self.reviews.count,
            "limit": 20,
            "withoutTextOnly": true
        ] as [String: Any]
        
        GrocerestAPI.searchForReview(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                self.isDownloading = false
                return
            }
            
            self.numberOfReviews = data["count"].intValue
            self.reviews.append(contentsOf: data["reviews"].arrayValue)
            self.reviewsCollectionView.reloadData()
            self.isDownloading = false
        }
    }
    
    /**
       `data` is the result of a Grocerest.searchForReview request.
     */
    func prepopulate(with data: JSON) {
        numberOfReviews = data["count"].intValue
        reviews = data["reviews"].arrayValue
        userId = reviews[0]["author"].stringValue
        reviewsCollectionView.reloadData()
    }
    
}
