//
//  GRProductsResultTableViewself.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 07/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Haneke

class GRProductsResultTableViewCell: UITableViewCell {
    
    var data: JSON?
    
    // MARK: Private properties
    
    private let cellImageView = UIImageView()
    private let cellImageButton = UIButton()
    private let mainLabel = UILabel()
    private let brandLabel = UILabel()
    private let recensioneButton = RecensioneButton(type: .custom)
    private let moreButton = MoreButton(type:.custom)
    private let productButton = UIButton()
    private let footer = UIView()
    private let listIcon = UIImageView()
    private let scannedIcon = UIImageView()
    private let reviewsIcon = UIImageView(image: UIImage(named: "edit-small"))
    private let reviewsCounter = UILabel()
    private let reviewsText = UILabel()
    private let noReviewsMessage = UILabel()
    private var scoreIndicators = UIStackView()
    private let scoreCounter = UILabel()
    private let noScoreLabel = UILabel()
    private let flagImage = UIImageView(image: UIImage(named: "flag"))
    private let rankLabel = UILabel()
    
    // MARK: Custom controls
    
    // Custom button with an enlarged hit frame
    private class RecensioneButton : UIButton {
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let relativeFrame = self.bounds
            let hitTestEdgeInsets = UIEdgeInsetsMake(0, -40/masterRatio, -30/masterRatio, 0)
            let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
            return hitFrame.contains(point)
        }
    }
    
    // Custom button with an enlarged hit frame
    private class MoreButton : UIButton {
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let relativeFrame = self.bounds
            let hitTestEdgeInsets = UIEdgeInsetsMake(0, 0, -30/masterRatio, -40/masterRatio)
            let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
            return hitFrame.contains(point)
        }
    }
    
    // MARK: Public properties
    
    enum ReviewStatus {
        case none
        case incomplete
        case complete
    }
    
    var reviewStatus: ReviewStatus = .none {
        didSet {
            if reviewStatus == oldValue { return }
            switch reviewStatus {
            case .none:
                recensioneButton.setBackgroundImage(UIImage(named: "v2_scrivi_recensione"), for: UIControlState())
            case .incomplete:
                recensioneButton.setBackgroundImage(UIImage(named: "v2_recensione_nocompleta"), for: UIControlState())
            case .complete:
                recensioneButton.setBackgroundImage(UIImage(named: "v2_recensione_completa"), for: UIControlState())
            }
        }
    }
    
    enum ListType {
        case favourite
        case hated
        case toTry
        case none
    }
    
    var listType: ListType = .none {
        didSet {
            if listType == oldValue { return }
            if oldValue == .none {
                listIcon.isHidden = false
                scannedIcon.snp.remakeConstraints { make in
                    make.width.height.equalTo(42 / masterRatio)
                    make.right.equalTo(listIcon.snp.left).offset(-13 / masterRatio)
                    make.centerY.equalTo(footer.snp.centerY)
                    //make.right.equalTo(listIcon.snp.left).offset(-13 / masterRatio)
                }
                
            }
            
            switch listType {
            case .favourite:
                listIcon.image = UIImage(named: "icon_status_xsmall_preferiti")
            case .hated:
                listIcon.image = UIImage(named: "icon_status_xsmall_evitare")
            case .toTry:
                listIcon.image = UIImage(named: "icon_status_xsmall_provare")
            case .none:
                listIcon.image = nil
                listIcon.isHidden = true
                scannedIcon.snp.remakeConstraints { make in
                    make.width.height.equalTo(42 / masterRatio)
                    make.right.equalTo(listIcon.snp.right)
                    make.centerY.equalTo(footer.snp.centerY)
                }
            }
        }
    }
    
    var isProductScanned: Bool = false {
        didSet {
            scannedIcon.isHidden = !isProductScanned
        }
    }
    
    var title: String {
        get { return (mainLabel.text != nil) ? mainLabel.text! : "" }
        set (newTitle) {
            if newTitle.characters.count <= 25 {
                mainLabel.text = "\n\(newTitle)"
            } else {
                mainLabel.text = newTitle
            }
        }
    }
    
    var brand: String {
        get { return (brandLabel.text != nil) ? brandLabel.text! : "" }
        set (newBrand) {
            brandLabel.text = newBrand
        }
    }
    
    var thumbnail: UIImage? {
        get { return cellImageView.image }
        set (image) {
            cellImageView.image = image
            cellImageView.layoutIfNeeded()
        }
    }
    
    var numberOfReviews: Int = 0 {
        didSet {
            if numberOfReviews < 0 {
                // Cannot set a negative number of reviews
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                    action: "ProductsResultTableViewCell: negative numberOfReviews",
                    label: "\(title)",
                    value: nil
                )
                tracker?.send(event?.build() as [NSObject: AnyObject]?)
                numberOfReviews = 0
                return
            }
            
            if numberOfReviews == 0 {
                reviewsIcon.isHidden = true
                reviewsCounter.isHidden = true
                reviewsText.text = "voti"
                reviewsText.isHidden = true
                noReviewsMessage.isHidden = false
            } else {
                reviewsCounter.text = "\(numberOfReviews)"
                reviewsIcon.isHidden = false
                reviewsCounter.isHidden = false
                reviewsText.text = (numberOfReviews == 1 ? "voto" : "voti")
                reviewsText.isHidden = false
                noReviewsMessage.isHidden = true
            }
        }
    }
    
    var averageReviewScore: Double = 0 {
        didSet {
            if averageReviewScore < 0 || averageReviewScore > 5 {
                // Score must be between 0 and 5, extremes included
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                    action: "ProductsResultTableViewCell: negative averageReviewsScore",
                    label: "\(title)",
                    value: nil
                )
                tracker?.send(event?.build() as [NSObject: AnyObject]?)
                averageReviewScore = 0
                return
            }
            for indicator in scoreIndicators.arrangedSubviews {
                let circle = indicator as! UIImageView
                circle.image = UIImage(named: "score-empty-small")
            }
            if averageReviewScore == 0 {
                scoreCounter.isHidden = true
                noScoreLabel.isHidden = false
            } else {
                noScoreLabel.isHidden = true
                scoreCounter.text = String(format: "%.2f", averageReviewScore)
                scoreCounter.isHidden = false
                
                var score = averageReviewScore
                var i = 0
                repeat {
                    let circle = scoreIndicators.arrangedSubviews[i] as! UIImageView
                    circle.image = UIImage(named: "score-full-small")
                    score -= 1
                    i += 1
                } while score >= 1
                if score >= 0.25 && score <= 0.75 {
                    let circle = scoreIndicators.arrangedSubviews[i] as! UIImageView
                    circle.image = UIImage(named: "score-half-small")
                } else if score > 0.75 && score < 1 {
                    let circle = scoreIndicators.arrangedSubviews[i] as! UIImageView
                    circle.image = UIImage(named: "score-full-small")
                }
            }
        }
    }
    
    var isRankHidden = true {
        didSet {
            flagImage.isHidden = isRankHidden
            rankLabel.isHidden = isRankHidden
        }
    }
    
    var rank: Int = 0 {
        didSet {
            if rank > 99 {
                rankLabel.text = "+99"
            } else {
                rankLabel.text = "#\(rank)"
            }
        }
    }
    
    // MARK: Callbacks
    var onThumbnailTapped: (() -> Void)?
    var onTitleOrBrandTapped: (() -> Void)?
    var onBottomTapped: (() -> Void)?
    var onReviewButtonTapped: (() -> Void)?
    var onMoreButtonTapped: (() -> Void)?

    // MARK: Initializers and configuration methods
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 158 / masterRatio))
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        setupHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHierarchy()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupHierarchy() {
        self.backgroundColor = UIColor.F1F1F1Color()
        
        let wrapper = UIView()
        contentView.addSubview(wrapper)
        wrapper.backgroundColor = UIColor.white
        wrapper.layer.cornerRadius = 4
        wrapper.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(686 / masterRatio).priority(1000)
            make.center.equalTo(contentView)
            make.height.equalTo(332 / masterRatio).priority(1000)
        }
        
        wrapper.addSubview(cellImageView)
        cellImageView.snp.makeConstraints { make in
            make.width.height.equalTo(218 / masterRatio)
            make.left.equalTo(18 / masterRatio)
            make.top.equalTo(20 / masterRatio)
        }
        cellImageView.contentMode = .scaleAspectFit
        
        wrapper.addSubview(cellImageButton)
        cellImageButton.snp.makeConstraints { (make) in
            make.edges.equalTo(cellImageView)
        }
        cellImageButton.addTarget(
            self,
            action: #selector(self.productButtonTapped(_:)),
            for: .touchUpInside
        )
        
        
        wrapper.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(wrapper.snp.top).offset(40 / masterRatio)
            make.left.equalTo(cellImageView.snp.right).offset(32 / masterRatio)
            make.right.equalTo(wrapper.snp.right).offset(-18 / masterRatio)
        }
        mainLabel.font = Constants.BrandFonts.ubuntuMedium14
        mainLabel.textColor = UIColor.grocerestDarkBoldGray()
        mainLabel.textAlignment = .left
        mainLabel.numberOfLines =  2
        
        wrapper.addSubview(brandLabel)
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(4 / masterRatio)
            make.left.equalTo(cellImageView.snp.right).offset(32 / masterRatio)
            make.right.equalTo(wrapper.snp.right).offset(-18 / masterRatio)
        }
        brandLabel.font = Constants.BrandFonts.avenirBook11
        brandLabel.textColor = UIColor.grocerestLightGrayColor()
        brandLabel.textAlignment = .left
        brandLabel.numberOfLines = 1
        brandLabel.lineBreakMode = .byTruncatingTail
        
        wrapper.addSubview(recensioneButton)
        recensioneButton.snp.makeConstraints { make in
            make.width.height.equalTo(50 / masterRatio)
            make.top.equalTo(brandLabel.snp.bottom).offset(20 / masterRatio)
            make.left.equalTo(cellImageView.snp.right).offset(32 / masterRatio)
        }
        recensioneButton.contentMode = .scaleAspectFit
        recensioneButton.setBackgroundImage(UIImage(named: "recensione_todo"), for: UIControlState())
        recensioneButton.addTarget(self, action: #selector(self.recensioneButtonTapped(_:)), for: .touchUpInside)
        
        wrapper.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.width.height.top.equalTo(recensioneButton)
            make.left.equalTo(recensioneButton.snp.right).offset(16 / masterRatio)
        }
        moreButton.contentMode = .scaleAspectFit
        moreButton.setBackgroundImage(UIImage(named: "product_details"), for: UIControlState())
        moreButton.addTarget(self, action: #selector(self.moreButtonTapped(_:)), for: .touchUpInside)
        
        wrapper.addSubview(productButton)
        productButton.snp.makeConstraints { make in
            make.top.left.right.equalTo(mainLabel)
            make.bottom.equalTo(brandLabel)
        }
        productButton.addTarget(self, action: #selector(self.productButtonTapped(_:)), for: .touchUpInside)
        
        // Lateral flag
        flagImage.isHidden = true
        wrapper.addSubview(flagImage)
        flagImage.snp.makeConstraints { make in
            make.top.equalTo(wrapper).offset(171 / masterRatio)
            make.right.equalTo(wrapper).offset(6 / masterRatio)
        }
        
        rankLabel.isHidden = true
        rankLabel.font = .ubuntuMedium(24)
        rankLabel.textColor = .white
        rankLabel.textAlignment = .right
        wrapper.addSubview(rankLabel)
        rankLabel.snp.makeConstraints { make in
            make.top.equalTo(flagImage).offset(8 / masterRatio)
            make.right.equalTo(flagImage).offset(-19 / masterRatio)
        }
        
        // Footer
        // TODO: rounded bottom border and correct background color
        wrapper.addSubview(footer)
        footer.backgroundColor = UIColor.lightBackgroundGrey()
        footer.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(wrapper)
            make.top.equalTo(wrapper.snp.bottom).offset(-74 / masterRatio)
        }
        
        footer.addSubview(listIcon)
        listIcon.contentMode = .scaleAspectFit
        listIcon.isHidden = true
        listIcon.snp.makeConstraints { make in
            make.width.height.equalTo(42 / masterRatio)
            make.right.equalTo(footer.snp.right).offset(-20 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        footer.addSubview(scannedIcon)
        scannedIcon.image = UIImage(named: "greeen_scann")
        scannedIcon.contentMode = .scaleAspectFit
        scannedIcon.isHidden = true
        scannedIcon.snp.makeConstraints { make in
            make.width.height.equalTo(42 / masterRatio)
            make.right.equalTo(listIcon.snp.right)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        scoreIndicators.axis  = UILayoutConstraintAxis.horizontal
        scoreIndicators.distribution  = UIStackViewDistribution.equalSpacing
        scoreIndicators.alignment = UIStackViewAlignment.center
        for _ in 1...5 {
            let img = UIImageView(image: UIImage(named: "score-empty-small"))
            scoreIndicators.addArrangedSubview(img)
        }
        
        footer.addSubview(scoreIndicators)
        scoreIndicators.snp.makeConstraints { make in
            make.left.equalTo(footer.snp.left).offset(18 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        scoreCounter.font = Constants.BrandFonts.avenirMedium13
        scoreCounter.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        scoreCounter.isHidden = true
        footer.addSubview(scoreCounter)
        scoreCounter.snp.makeConstraints { make in
            make.left.equalTo(scoreIndicators.snp.right).offset(5 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        noScoreLabel.font = Constants.BrandFonts.avenirMedium13
        noScoreLabel.textColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        noScoreLabel.text = "n.d."
        footer.addSubview(noScoreLabel)
        noScoreLabel.snp.makeConstraints { make in
            make.left.equalTo(scoreIndicators.snp.right).offset(5 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        let separator = UIView()
        separator.backgroundColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        footer.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(42 / masterRatio)
            make.width.equalTo(2 / masterRatio)
            make.left.equalTo(noScoreLabel.snp.right).offset(23 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        reviewsIcon.contentMode = .scaleAspectFit
        footer.addSubview(reviewsIcon)
        reviewsIcon.snp.makeConstraints { make in
            make.width.height.equalTo(26 / masterRatio)
            make.left.equalTo(separator.snp.right).offset(31 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        reviewsCounter.font = Constants.BrandFonts.avenirMedium13
        reviewsCounter.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        footer.addSubview(reviewsCounter)
        reviewsCounter.snp.makeConstraints { make in
            make.left.equalTo(reviewsIcon.snp.right).offset(5 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        reviewsText.font = Constants.BrandFonts.avenirMedium13
        reviewsText.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        reviewsText.text = "voti"
        footer.addSubview(reviewsText)
        reviewsText.snp.makeConstraints { make in
            make.left.equalTo(reviewsCounter.snp.right).offset(5 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        reviewsIcon.isHidden = true
        reviewsCounter.isHidden = true
        reviewsText.isHidden = true
        
        noReviewsMessage.font = Constants.BrandFonts.avenirMedium10
        noReviewsMessage.textColor = UIColor.grocerestBlue()
        noReviewsMessage.text = "RECENSISCI PER PRIMO\nE RADDOPPIA I PUNTI!"
        noReviewsMessage.numberOfLines = 2
        footer.addSubview(noReviewsMessage)
        noReviewsMessage.snp.makeConstraints { make in
            make.left.equalTo(separator.snp.right).offset(27 / masterRatio)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        /*
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.recensioneButtonTapped(_:)))
        noReviewsMessage.addGestureRecognizer(tapGesture)
        noReviewsMessage.userInteractionEnabled = true
        */
        
        let bottomButton = UIButton(type: .custom)
        footer.addSubview(bottomButton)
        bottomButton.snp.makeConstraints { make in
            make.left.bottom.top.equalTo(scoreIndicators)
            make.right.equalTo(reviewsText)
            make.right.equalTo(noReviewsMessage)
        }
        bottomButton.addTarget(self, action: #selector(self.bottomButtonTapped(_:)), for: .touchUpInside)
        
    }
    
    func recensioneButtonTapped(_ sender: UIButton) {
        onReviewButtonTapped?()
    }
    
    func moreButtonTapped(_ sender: UIButton) {
        onMoreButtonTapped?()
    }
    
    func productButtonTapped(_ sender: UIButton) {
        onTitleOrBrandTapped?()
    }
    
    func bottomButtonTapped(_ sender: UIButton) {
        onBottomTapped?()
    }
    
    // MARK: Public interest methods
    
    func setThumbnailFromUrl(_ url: URL) {
        cellImageView.hnk_setImageFromURL(url, format: Haneke.Format<UIImage>(name: "original"))
    }
    
    /**
        Resets and populates the cell with product's data. The controller
        which is using this cell is needed to setup callbacks.
     */
    func populateWith<T: UIViewController>(product: JSON, from controller: T) where T: GRLastIdTappedCacher, T: GRModalViewControllerDelegate {
        
        data = product
        thumbnail = nil
        selectionStyle = .none
        
        title = product["display_name"].stringValue
        
        self.brand = productJONSToBrand(data: product)
        
        if let productImage = product["images"]["medium"].string {
            setThumbnailFromUrl(URL(string: String.fullPathForImage(productImage))!)
        } else {
            if let category = product["category"].string  {
                thumbnail = UIImage(named: "products_" + category)?.imageWithInsets(15)
            }
        }
        
        let thisProduct = product["_id"].stringValue
        
        if getFavouritedProductsFromLocal().contains(thisProduct) {
            listType = .favourite
        } else if getHatedProductsFromLocal().contains(thisProduct) {
            listType = .hated
        } else if getTryableProductsFromLocal().contains(thisProduct) {
            listType = .toTry
        } else {
            listType = .none
        }
        
        if getFullyReviewdProductsFromLocal().contains(thisProduct) {
            reviewStatus = .complete
        } else if getReviewedProductsFromLocal().contains(thisProduct) {
            reviewStatus = .incomplete
        } else {
            reviewStatus = .none
        }
        
        averageReviewScore = product["reviews"]["average"].doubleValue
        numberOfReviews = product["reviews"]["count"].intValue
        
        isProductScanned = getScannedProductsFromLocal().contains(product["_id"].stringValue)

        // Callbacks
        
        onMoreButtonTapped = {
            let moreActionsForProduct = GRSingleProductMoreActionsModalViewController()
            controller.lastTappedId = product["_id"].stringValue
            moreActionsForProduct.modalDelegate = controller
            moreActionsForProduct.modalTransitionStyle = .crossDissolve
            moreActionsForProduct.modalPresentationStyle = .overCurrentContext
            moreActionsForProduct.product = product
            UIApplication.topViewController()?.present(moreActionsForProduct, animated: true, completion: nil)
        }
        
        onReviewButtonTapped = {
            let recensioneViewController = GRModalRecensioneViewController()
            controller.lastTappedId = product["_id"].stringValue
            recensioneViewController.modalDelegate = controller
            recensioneViewController.product = product
            recensioneViewController.modalPresentationStyle = .overCurrentContext
            UIApplication.topViewController()?.present(recensioneViewController, animated: true, completion: nil)
        }
        
        onTitleOrBrandTapped = {
            let productDetail = GRProductDetailViewController()
            controller.lastTappedId = product["_id"].stringValue
            productDetail.modalDelegate = controller
            DispatchQueue.main.async {
                productDetail.prepopulateWith(product: product)
            }
            
            productDetail.productId = product["_id"].stringValue
            UIApplication.topViewController()?.navigationController?.pushViewController(productDetail, animated: true)
        }
        
        onThumbnailTapped = {
            let productDetail = GRProductDetailViewController()
            controller.lastTappedId = product["_id"].stringValue
            productDetail.modalDelegate = controller
            productDetail.prepopulateWith(product: product)
            productDetail.productId = product["_id"].stringValue
            UIApplication.topViewController()?.navigationController?.pushViewController(productDetail, animated: true)
        }
        
        if numberOfReviews == 0 {
            onBottomTapped = onReviewButtonTapped
        } else {
            onBottomTapped = onTitleOrBrandTapped
        }
    }

}
