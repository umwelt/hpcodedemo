//
//  GRBrandDetailView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 07/02/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation
import TagListView
import Google

class GRBrandDetailView: UIView {
    
    let navigationToolBar = GRToolbar()
    private let contentView = UIView()
    private let scoreDistributionView = UIView()
    private let productsView = UIStackView()
    private let footerView = UIView()
    
    // HEADER:
    // - Views
    private let headerView = UIView()
    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let scoreIndicators = UIStackView()
    private let scoreLabel = UILabel()
    private let separator = UIView()
    private let editIcon = UIImageView(image: UIImage(named: "edit-icon-medium"))
    private let numberOfProductsLabel = UILabel()
    // - Properties
    var image: UIImage? {
        get { return productImageView.image }
        set (i) { productImageView.image = i}
    }
    var title: String {
        get { return titleLabel.text! }
        set (s) {
            titleLabel.text = s
        }
    }
    var averageReviewScore: Double = 0 {
        didSet {
            if averageReviewScore < 0 || averageReviewScore > 5 {
                // Score must be between 0 and 5, extremes included
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                                                             action: "BrandDetailView: negative averageReviewsScore",
                                                             label: "\(title)",
                    value: nil
                )
                tracker?.send(event?.build() as [NSObject: AnyObject]?)
            }
            for indicator in scoreIndicators.arrangedSubviews {
                let circle = indicator as! UIImageView
                circle.image = UIImage(named: "score-empty-medium")
            }
            if averageReviewScore == 0 {
                scoreLabel.textColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
                scoreLabel.text = "n.d."
            } else {
                scoreLabel.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
                scoreLabel.text = String(format: "%.2f", averageReviewScore)
                var score = averageReviewScore
                var i = 0
                repeat {
                    let circle = scoreIndicators.arrangedSubviews[i] as! UIImageView
                    circle.image = UIImage(named: "score-full-medium")
                    score -= 1
                    i += 1
                } while score >= 1
                if score >= 0.25 && score <= 0.75 {
                    let circle = scoreIndicators.arrangedSubviews[i] as! UIImageView
                    circle.image = UIImage(named: "score-half-medium")
                } else if score > 0.75 && score < 1 {
                    let circle = scoreIndicators.arrangedSubviews[i] as! UIImageView
                    circle.image = UIImage(named: "score-full-medium")
                }
            }
        }
    }

    // SCORE DISTRIBUTION VIEW:
    // - Views
    let distributionView = GRScoreDistributionView()
    
    // REVIEWS VIEW:
    // - Views
    private let productsSectionHeader = UIView()
    private let productsCounter = UILabel()
    let productsTable = UITableView()
    private let seeAllProductsButton = UIButton()
    private let buttonWrapper = UIView()
    // - Properties
    let reviewsTableDataSource = GRBrandDetailProductsListDataSource()
    var numberOfReviews: Int = 0 {
        didSet {
            switch numberOfReviews {
            case 0:
                numberOfProductsLabel.isHidden = true
                editIcon.isHidden = true
            case 1:
                numberOfProductsLabel.isHidden = false
                editIcon.isHidden = false
                let text = NSMutableAttributedString(string: "1 voto")
                text.addAttribute(NSFontAttributeName, value: Constants.BrandFonts.avenirMedium20!, range: NSRange(location: 0, length: 1))
                text.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0), range: NSRange(location: 0, length: 1))
                numberOfProductsLabel.attributedText = text
            default:
                numberOfProductsLabel.isHidden = false
                editIcon.isHidden = false
                let text = NSMutableAttributedString(string: "\(numberOfReviews) voti")
                text.addAttribute(NSFontAttributeName, value: Constants.BrandFonts.avenirMedium20!, range: NSRange(location: 0, length: String(numberOfReviews).characters.count))
                text.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0), range: NSRange(location: 0, length: String(numberOfReviews).characters.count))
                numberOfProductsLabel.attributedText = text
            }
        }
    }
    var numberOfProducts: Int = 0 { // ( comments )
        didSet {
            if numberOfProducts == 1 {
                productsCounter.text = "1 prodotto"
            } else {
                productsCounter.text = "\(numberOfProducts) prodotti"
            }
        }
    }
    
    var hideSeeAllProductsButton = false {
        didSet {
            buttonWrapper.isHidden = hideSeeAllProductsButton
        }
    }
    // - Callbacks
    var onSeeAllProductsButtonTapped: (() -> Void)?
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }
    
    private func setupHierarchy() {
        addSubview(navigationToolBar)
        navigationToolBar.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.left.equalTo(0)
        }
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationToolBar.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(self)
        }
        
        setupHeaderView()
        setupScoreDistributionView()
        setupProductsView()
        
        let trailingBackgroundView = UIView()
        trailingBackgroundView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        contentView.addSubview(trailingBackgroundView)
        trailingBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.top.equalTo(productsView.snp.bottom)
            make.height.equalTo(2000 / masterRatio)
        }
    }
    
    private func setupHeaderView() {
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.width.equalTo(contentView)
            //make.height.equalTo(447 / masterRatio)
        }
        
        productImageView.contentMode = .scaleAspectFit
        headerView.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(300 / masterRatio)
            make.top.equalTo(headerView).offset(72 / masterRatio)
            make.centerX.equalTo(headerView)
        }
        
        titleLabel.text = ""
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 4
        titleLabel.font = Constants.BrandFonts.ubuntuMedium20
        titleLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(632 / masterRatio)
            make.centerX.equalTo(headerView)
            make.top.equalTo(productImageView.snp.bottom).offset(37 / masterRatio)
        }
        
        // Reviews widget
        
        scoreIndicators.axis  = UILayoutConstraintAxis.horizontal
        scoreIndicators.distribution  = UIStackViewDistribution.equalSpacing
        scoreIndicators.alignment = UIStackViewAlignment.center
        for _ in 1...5 {
            let img = UIImageView(image: UIImage(named: "score-empty-medium"))
            scoreIndicators.addArrangedSubview(img)
        }
        
        headerView.addSubview(scoreIndicators)
        scoreIndicators.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(44 / masterRatio)
            make.left.equalTo(contentView).offset(92 / masterRatio)
        }
        
        scoreLabel.text = "n.d."
        scoreLabel.textAlignment = .center
        scoreLabel.font = Constants.BrandFonts.avenirMedium20
        scoreLabel.textColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        headerView.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(scoreIndicators)
            make.left.equalTo(scoreIndicators.snp.right).offset(10 / masterRatio)
        }
        
        separator.backgroundColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        headerView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.width.equalTo(3 / masterRatio)
            make.height.equalTo(41 / masterRatio)
            make.centerY.equalTo(scoreIndicators)
            make.left.equalTo(scoreLabel.snp.right).offset(30 / masterRatio)
        }
        
        editIcon.isHidden = true
        headerView.addSubview(editIcon)
        editIcon.snp.makeConstraints { make in
            make.bottom.equalTo(scoreIndicators)
            make.left.equalTo(separator.snp.right).offset(32 / masterRatio)
        }
        
        numberOfProductsLabel.isHidden = true
        numberOfProductsLabel.font = Constants.BrandFonts.avenirBook11
        numberOfProductsLabel.textColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        headerView.addSubview(numberOfProductsLabel)
        numberOfProductsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(scoreLabel)
            make.left.equalTo(editIcon.snp.right).offset(12 / masterRatio)
            make.bottom.equalTo(headerView).offset(-40 / masterRatio)
        }
    }
    
    private func setupScoreDistributionView() {
        contentView.addSubview(scoreDistributionView)
        scoreDistributionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.width.equalTo(contentView)
            make.height.equalTo(387 / masterRatio)
        }
        
        let sectionHeader = UIView()
        sectionHeader.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        scoreDistributionView.addSubview(sectionHeader)
        sectionHeader.snp.makeConstraints { make in
            make.top.width.equalTo(scoreDistributionView)
            make.height.equalTo(64 / masterRatio)
        }
        
        let sectionTitle = UILabel()
        sectionTitle.text = "Distribuzione voto"
        sectionTitle.font = Constants.BrandFonts.avenirBook11
        sectionTitle.textColor = UIColor.grocerestLightGrayColor()
        sectionHeader.addSubview(sectionTitle)
        sectionTitle.snp.makeConstraints { make in
            make.centerY.equalTo(sectionHeader)
            make.left.equalTo(sectionHeader).offset(31 / masterRatio)
        }
        
        sectionHeader.addSubview(distributionView)
        distributionView.snp.makeConstraints { make in
            make.top.equalTo(sectionHeader.snp.bottom).offset(40 / masterRatio)
            make.bottom.equalTo(scoreDistributionView).offset(-40 / masterRatio)
            make.left.equalTo(contentView).offset(64 / masterRatio)
            make.right.equalTo(contentView).offset(-64 / masterRatio)
        }
    }
    
    private func setupProductsView() {
        contentView.addSubview(productsView)
        productsView.snp.makeConstraints { make in
            make.top.equalTo(scoreDistributionView.snp.bottom)
            make.bottom.equalTo(contentView)
            make.left.right.equalTo(contentView)
        }
        productsView.axis = .vertical
        productsView.distribution = .fill
        productsView.alignment = .fill
        productsView.spacing = 0
        
        productsSectionHeader.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        productsView.addSubview(productsSectionHeader)
        productsSectionHeader.snp.makeConstraints { make in
            make.height.equalTo(64 / masterRatio)
        }
        productsView.addArrangedSubview(productsSectionHeader)
        
        productsCounter.text = "0 voti"
        productsCounter.font = Constants.BrandFonts.avenirBook11
        productsCounter.textColor = UIColor.grocerestLightGrayColor()
        productsSectionHeader.addSubview(productsCounter)
        productsCounter.snp.makeConstraints { make in
            make.centerY.equalTo(productsSectionHeader)
            make.left.equalTo(productsSectionHeader).offset(31 / masterRatio)
        }
        
        
        productsTable.rowHeight = 352 / masterRatio
        productsTable.separatorStyle = .none
        productsTable.register(GRProductsResultTableViewCell.self, forCellReuseIdentifier: "cell")
        productsTable.dataSource = reviewsTableDataSource
        productsTable.isScrollEnabled = false
        productsTable.allowsSelection = false
        productsTable.separatorColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        productsView.addSubview(productsTable)
        updateProductsTableHeight()
        productsView.addArrangedSubview(productsTable)
        
        buttonWrapper.backgroundColor = UIColor(hexString: "F1F1F1")
        seeAllProductsButton.layer.borderWidth = 4 / masterRatio
        seeAllProductsButton.layer.borderColor = UIColor.grocerestBlue().cgColor
        seeAllProductsButton.layer.cornerRadius = 7 / masterRatio
        seeAllProductsButton.layer.masksToBounds = true
        seeAllProductsButton.setTitle("VEDI TUTTI I PRODOTTI", for: UIControlState())
        seeAllProductsButton.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        seeAllProductsButton.titleLabel!.font = Constants.BrandFonts.avenirHeavy11
        seeAllProductsButton.titleEdgeInsets = UIEdgeInsets(top: 20 / masterRatio, left: 47 / masterRatio, bottom: 20 / masterRatio, right: 47 / masterRatio)
        buttonWrapper.addSubview(seeAllProductsButton)
        seeAllProductsButton.snp.makeConstraints { make in
            make.top.equalTo(buttonWrapper).offset(64 / masterRatio)
            make.bottom.equalTo(buttonWrapper).offset(-64 / masterRatio)
            make.left.equalTo(buttonWrapper).offset(32 / masterRatio)
            make.right.equalTo(buttonWrapper).offset(-32 / masterRatio)
        }
        
        seeAllProductsButton.addTarget(self, action: #selector(self._seeAllProductsButtonTapped(_:)), for: .touchUpInside)
        productsView.addArrangedSubview(buttonWrapper)
    }
    
    /**
     Loads and set the product's image from an URL
     */
    func setProductImageFrom(_ url: URL) {
        self.productImageView.layoutIfNeeded()
        self.productImageView.hnk_setImageFromURL(url)
    }
    
    /**
     Updates the reviews table view height according to
     its contained elements.
     */
    func updateProductsTableHeight() {
        productsTable.snp.remakeConstraints { make in
            let height: CGFloat = 352 * CGFloat(productsTable.numberOfRows(inSection: 0))
            make.height.equalTo(height / masterRatio )
        }
    }
    
    // Callbacks calling functions
    
    func _seeAllProductsButtonTapped(_: UIButton) {
        onSeeAllProductsButtonTapped?()
    }
    
}
