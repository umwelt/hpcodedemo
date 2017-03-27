//
//  GRProductDetailView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 28/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import TagListView
import Google

class GRProductDetailView: UIView {

    let navigationToolBar: GRToolbar = GRToolbar()
    private let contentView = UIView()
    private let scoreDistributionView = UIView()
    private let reviewsView = UIView()
    private let footerView = UIView()
    
    // HEADER:
    // - Views
    private let headerView = UIView()
    public let productImageView = UIImageView()
    private let productCategoryView = UIView()
    private let categoryLabel = UILabel()
    private let titleLabel = UILabel()
    private let brandLabel = UILabel()
    private let brandButton = UIButton()
    private let scoreIndicators = UIStackView()
    private let scoreLabel = UILabel()
    private let separator = UIView()
    private let editIcon = UIImageView(image: UIImage(named: "edit-icon-medium"))
    private let numberOfReviewsLabel = UILabel()
    private let createReviewLabel = UILabel()
    private let favouriteButton = UIButton(type: .custom)
    private let hatedButton = UIButton(type: .custom)
    private let toTryButton = UIButton(type: .custom)
    private let otherListsButton = UIButton(type: .custom)
    let availabilityButton = UIButton(type: .custom)
    // - Properties
    var image: UIImage? {
        get { return productImageView.image }
        set (i) { productImageView.image = i}
    }
    var category: String {
        get { return categoryLabel.text! }
        set (s) { categoryLabel.text = s }
    }
    var categoryColor: UIColor? {
        didSet {
            productCategoryView.backgroundColor = UIColor.clear
        }
    }
    
    var categoryLabelBackGroundColor : UIColor? {
        didSet {
            categoryLabel.backgroundColor = categoryColor
            categoryLabel.layer.borderColor = categoryColor?.cgColor
        }
    }
    
    var title: String {
        get { return titleLabel.text! }
        set (s) {
            titleLabel.text = s
            tagsTitle.text = "Tag relativi al prodotto"
        }
    }
    var brand: String {
        get { return brandLabel.text! }
        set (s) { brandLabel.text = s }
    }
    var averageReviewScore: Double = 0 {
        didSet {
            if averageReviewScore < 0 || averageReviewScore > 5 {
                // Score must be between 0 and 5, extremes included
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(
                    withCategory: "Soft errors",
                    action: "ProductDetailView: negative averageReviewsScore",
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
    // See REVIEWS VIEW below
    enum ListType {
        case none
        case favourite
        case hated
        case toTry
    }
    private var _list: ListType = .none
    var list: ListType {
        get { return _list }
        set (t) {
            if t == _list { return }
            _list = t
            switch t {
            case .none:
                favouriteButton.setBackgroundImage(UIImage(named: "preferiti_detail_off")!, for: UIControlState())
                hatedButton.setBackgroundImage(UIImage(named: "evitare_detail_off")!, for: UIControlState())
                toTryButton.setBackgroundImage(UIImage(named: "provare_detail_off")!, for: UIControlState())
            case .favourite:
                favouriteButton.setBackgroundImage(UIImage(named: "preferiti_detail_on")!, for: UIControlState())
                hatedButton.setBackgroundImage(UIImage(named: "evitare_detail_off")!, for: UIControlState())
                toTryButton.setBackgroundImage(UIImage(named: "provare_detail_off")!, for: UIControlState())
            case .hated:
                favouriteButton.setBackgroundImage(UIImage(named: "preferiti_detail_off")!, for: UIControlState())
                hatedButton.setBackgroundImage(UIImage(named: "evitare_detail_on")!, for: UIControlState())
                toTryButton.setBackgroundImage(UIImage(named: "provare_detail_off")!, for: UIControlState())
            case .toTry:
                favouriteButton.setBackgroundImage(UIImage(named: "preferiti_detail_off")!, for: UIControlState())
                hatedButton.setBackgroundImage(UIImage(named: "evitare_detail_off")!, for: UIControlState())
                toTryButton.setBackgroundImage(UIImage(named: "provare_detail_on")!, for: UIControlState())
            }
        }
    }
    var toTryHiddenDeactivated: Bool = false {
        didSet {
            if toTryHiddenDeactivated {
                if _list == .toTry { list = .none }
                toTryButton.isEnabled = false
            } else {
                toTryButton.isEnabled = true
                list = _list
            }
        }
    }
    // - Callbacks
    var onShareButtonTapped: (() -> Void)?
    var onAvailabilityButtonTapped: (() -> Void)?
    var onProductImageTapped: (() -> Void)?
    var onFavouriteButtonTapped: (() -> Void)?
    var onHatedButtonTapped: (() -> Void)?
    var onToTryButtonTapped: (() -> Void)?
    var onOtherListsButtonTapped: (() -> Void)?
    var onCreateNewReviewButtonTapped: (() -> Void)?
    var onBrandButtonWasTapped: (() -> Void)?
    
    // SCORE DISTRIBUTION VIEW:
    // - Views
    let distributionView = GRScoreDistributionView()
    
    // REVIEWS VIEW:
    // - Views
    private let reviewsSectionHeader = UIView()
    private let reviewsCounter = UILabel()
    let reviewsTable = UITableView()
    private let seeAllReviewsButton = UIButton()
    // - Properties
    let reviewsTableDataSource = GRProductDetailReviewsListDataSource()
    var numberOfReviews: Int = 0 {
        didSet {
            switch numberOfReviews {
            case 0:
                numberOfReviewsLabel.isHidden = true
                editIcon.isHidden = true
                createReviewLabel.isHidden = false
            case 1:
                numberOfReviewsLabel.isHidden = false
                editIcon.isHidden = false
                createReviewLabel.isHidden = true
                let text = NSMutableAttributedString(string: "1 voto")
                text.addAttribute(NSFontAttributeName, value: Constants.BrandFonts.avenirMedium20!, range: NSRange(location: 0, length: 1))
                text.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0), range: NSRange(location: 0, length: 1))
                numberOfReviewsLabel.attributedText = text
            default:
                numberOfReviewsLabel.isHidden = false
                editIcon.isHidden = false
                createReviewLabel.isHidden = true
                let text = NSMutableAttributedString(string: "\(numberOfReviews) voti")
                text.addAttribute(NSFontAttributeName, value: Constants.BrandFonts.avenirMedium20!, range: NSRange(location: 0, length: String(numberOfReviews).characters.count))
                text.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0), range: NSRange(location: 0, length: String(numberOfReviews).characters.count))
                numberOfReviewsLabel.attributedText = text
            }
        }
    }
    var numberOfReviewsWithText: Int = 0 { // ( comments )
        didSet {
            if numberOfReviewsWithText == 1 {
                reviewsCounter.text = "1 commento scritto"
            } else {
                reviewsCounter.text = "\(numberOfReviewsWithText) commenti scritti"
            }
        }
    }

    var hideSeeAllReviewsButton = false {
        didSet {
            seeAllReviewsButton.isHidden = hideSeeAllReviewsButton
            if hideSeeAllReviewsButton {
                seeAllReviewsButton.snp.remakeConstraints { make in
                    make.top.equalTo(reviewsTable.snp.bottom).offset(-64 / masterRatio)
                    make.bottom.equalTo(reviewsView.snp.bottom).offset(-5 / masterRatio)
                    make.left.equalTo(contentView).offset(32 / masterRatio)
                    make.right.equalTo(contentView).offset(-32 / masterRatio)
                }
            } else {
                seeAllReviewsButton.snp.remakeConstraints { make in
                    make.top.equalTo(reviewsTable.snp.bottom).offset(64 / masterRatio)
                    make.bottom.equalTo(reviewsView.snp.bottom).offset(-64 / masterRatio)
                    make.left.equalTo(contentView).offset(32 / masterRatio)
                    make.right.equalTo(contentView).offset(-32 / masterRatio)
                }
            }
        }
    }
    // - Callbacks
    var onSeeAllReviewsButtonTapped: (() -> Void)?
    
    // FOOTER VIEW:
    // - Views
    private let relatedProductsTitle = UILabel()
    private let relatedProductsView = GRRelatedProductsView()
    private let tagsTitle = UILabel()
    private let tagsList = TagListView()
    // - Properties
    var relatedProducts = [JSON]() {
        didSet {
            relatedProductsView.populate(with: relatedProducts)
            if relatedProducts.count > 0 {
                relatedProductsTitle.isHidden = false
                relatedProductsView.isHidden = false
                
                tagsTitle.snp.remakeConstraints { make in
                    make.top.equalTo(relatedProductsView.snp.bottom).offset(50 / masterRatio)
                    make.left.equalTo(footerView).offset(32 / masterRatio)
                    make.right.equalTo(footerView).offset(-32 / masterRatio)
                }
                
                updateFooterViewHeight()
            }
        }
    }
    var tags: [String] = [String]() {
        didSet {
            tagsList.removeAllTags()
            for tag in tags {
                let tagView = tagsList.addTag(tag)
                tagView.onTap = { _ in
                    self.onTagTapped?(tag)
                }
            }
            updateFooterViewHeight()
        }
    }
    
    private func updateFooterViewHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(16)) { // Or 1/60 of a second
            self.footerView.snp.remakeConstraints { make in
                make.top.equalTo(self.reviewsView.snp.bottom)
                make.width.bottom.equalTo(self.contentView)
                if self.relatedProducts.count > 0 {
                    let height = (455 / masterRatio) + self.tagsTitle.frame.height + (43 / masterRatio) + self.tagsList.frame.height + (32 / masterRatio)
                    make.height.equalTo(height)
                } else {
                    let height = (36 / masterRatio) + self.tagsTitle.frame.height + (43 / masterRatio) + self.tagsList.frame.height + (32 / masterRatio)
                    make.height.equalTo(height)
                }
            }
        }
    }
    
    // - Callbacks
    var onRelatedProductTapped: ((JSON) -> Void)?
    var onTagTapped: ((String) -> Void)?
    
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
        setupReviewsView()
        setupFooterView()
        
        let trailingBackgroundView = UIView()
        trailingBackgroundView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        contentView.addSubview(trailingBackgroundView)
        trailingBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.top.equalTo(footerView.snp.bottom)
            make.height.equalTo(2000 / masterRatio)
        }
    }
    
    private func setupHeaderView() {
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.width.equalTo(contentView)
            //make.height.equalTo(894 / masterRatio)
        }
        
        let shareButton = UIButton(type: .custom)
        shareButton.setBackgroundImage(UIImage(named: "share"), for: .normal)
        shareButton.addTarget(self, action: #selector(self._shareButtonTapped(_:)), for: .touchUpInside)
        headerView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.width.equalTo(33 / masterRatio)
            make.height.equalTo(44 / masterRatio)
            make.top.equalTo(headerView).offset(26 / masterRatio)
            make.right.equalTo(headerView).offset(-32 / masterRatio)
        }
        
        let image = UIImage(named: "shop_icon")?.withRenderingMode(.alwaysTemplate)
        availabilityButton.setBackgroundImage(image, for: .normal)
        availabilityButton.tintColor = UIColor.grocerestBlue()
        availabilityButton.layer.opacity = 0
        availabilityButton.addTarget(self, action: #selector(self._availabilityButtonTapped(_:)), for: .touchUpInside)
        headerView.addSubview(availabilityButton)
        availabilityButton.snp.makeConstraints { make in
            make.width.equalTo(50 / masterRatio)
            make.height.equalTo(44 / masterRatio)
            make.top.equalTo(headerView).offset(26 / masterRatio)
            make.left.equalTo(headerView).offset(32 / masterRatio)
        }
        
        productImageView.contentMode = .scaleAspectFit
        headerView.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(300 / masterRatio)
            make.top.equalTo(headerView).offset(48 / masterRatio)
            make.centerX.equalTo(headerView)
        }

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self._productImageTapped(_:)))
        productImageView.isUserInteractionEnabled = true
        productImageView.addGestureRecognizer(recognizer)
        
       // productCategoryView.layer.cornerRadius = 15 / masterRatio
        headerView.addSubview(productCategoryView)
        productCategoryView.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(56 / masterRatio)
            make.centerX.equalTo(headerView)
            make.width.equalTo(156 / masterRatio)
            make.height.equalTo(31 / masterRatio)
        }
        
        categoryLabel.text = ""
        categoryLabel.font = Constants.BrandFonts.avenirMedium10
        categoryLabel.textColor = UIColor.white
        productCategoryView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(productCategoryView)
        }
        categoryLabel.clipsToBounds = true
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.cornerRadius = 15 / masterRatio
        
        
        titleLabel.text = ""
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 4
        titleLabel.font = Constants.BrandFonts.ubuntuMedium20
        titleLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(632 / masterRatio)
            make.centerX.equalTo(headerView)
            make.top.equalTo(productCategoryView.snp.bottom).offset(21 / masterRatio)
        }
        
        brandLabel.text = ""
        brandLabel.textAlignment = .center
        brandLabel.font = Constants.BrandFonts.avenirBook11
        brandLabel.textColor = UIColor.grocerestBlue()
        headerView.addSubview(brandLabel)
        brandLabel.snp.makeConstraints { make in
            make.width.equalTo(269 / masterRatio)
            make.centerX.equalTo(headerView)
            make.top.equalTo(titleLabel.snp.bottom).offset(10 / masterRatio)
        }
        
        headerView.addSubview(brandButton)
        brandButton.snp.makeConstraints { make in
            make.edges.equalTo(brandLabel)
        }
        brandButton.addTarget(
            self,
            action: #selector(self._brandButtonWasTapped(_:)),
            for: .touchUpInside
        )

        
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
            make.top.equalTo(brandLabel.snp.bottom).offset(55 / masterRatio)
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
        
        numberOfReviewsLabel.isHidden = true
        numberOfReviewsLabel.font = Constants.BrandFonts.avenirBook11
        numberOfReviewsLabel.textColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        headerView.addSubview(numberOfReviewsLabel)
        numberOfReviewsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(scoreLabel)
            make.left.equalTo(editIcon.snp.right).offset(12 / masterRatio)
        }
        
        createReviewLabel.text = "VOTA PRIMA DI TUTTI\nE RADDOPPIA I PUNTI"
        createReviewLabel.font = Constants.BrandFonts.avenirMedium10
        createReviewLabel.textColor = UIColor.grocerestBlue()
        createReviewLabel.numberOfLines = 2
        headerView.addSubview(createReviewLabel)
        createReviewLabel.snp.makeConstraints { make in
            make.left.equalTo(separator).offset(32 / masterRatio)
            make.centerY.equalTo(separator)
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self._createReviewButtonWasTapped(_:)))
        createReviewLabel.addGestureRecognizer(tapRecognizer)
        createReviewLabel.isUserInteractionEnabled = true
        
        // Lists buttons
        
        favouriteButton.addTarget(self, action: #selector(self._favouriteButtonTapped(_:)), for: .touchUpInside)
        hatedButton.addTarget(self, action: #selector(self._hatedButtonTapped(_:)), for: .touchUpInside)
        toTryButton.addTarget(self, action: #selector(self._toTryButtonTapped(_:)), for: .touchUpInside)
        otherListsButton.addTarget(self, action: #selector(self._otherListsButtonTapped(_:)), for: .touchUpInside)
        
        func createButtonView(_ button: UIButton, imageForNormalState: UIImage, imageForSelectedState: UIImage, title: String) -> UIStackView {
            let view = UIStackView()
            view.axis  = UILayoutConstraintAxis.vertical
            view.distribution  = UIStackViewDistribution.equalCentering
            view.alignment = UIStackViewAlignment.center
            view.spacing = 12 / masterRatio
            
            button.setBackgroundImage(imageForNormalState, for: UIControlState())
            button.setBackgroundImage(imageForSelectedState, for: .highlighted)
            
            let label = UILabel()
            label.text = title
            label.font = Constants.BrandFonts.avenirBook12
            label.textColor = UIColor.lightGrayTextcolor()
            label.textAlignment = .center
            
            view.addArrangedSubview(button)
            view.addArrangedSubview(label)
            return view
        }
        
        let favouriteButtonView = createButtonView(favouriteButton, imageForNormalState: UIImage(named: "preferiti_detail_off")!, imageForSelectedState: UIImage(named: "preferiti_detail_on")!, title: "preferiti")
        let hatedButtonView = createButtonView(hatedButton, imageForNormalState: UIImage(named: "evitare_detail_off")!, imageForSelectedState: UIImage(named: "evitare_detail_on")!, title: "da evitare")
        let toTryButtonView = createButtonView(toTryButton, imageForNormalState: UIImage(named: "provare_detail_off")!, imageForSelectedState: UIImage(named: "provare_detail_on")!, title: "da provare")
        let otherListsIcon = UIImage(named: "altre_liste")!
        let otherListsButtonView = createButtonView(otherListsButton, imageForNormalState: otherListsIcon, imageForSelectedState: otherListsIcon, title: "altre liste")
        
        let buttonsStack = UIStackView()
        headerView.addSubview(buttonsStack)
        buttonsStack.axis  = UILayoutConstraintAxis.horizontal
        buttonsStack.distribution  = UIStackViewDistribution.equalSpacing
        buttonsStack.alignment = UIStackViewAlignment.center
        buttonsStack.spacing = 40 / masterRatio
        
        buttonsStack.addArrangedSubview(favouriteButtonView)
        buttonsStack.addArrangedSubview(hatedButtonView)
        buttonsStack.addArrangedSubview(toTryButtonView)
        buttonsStack.addArrangedSubview(otherListsButtonView)
        
        buttonsStack.snp.makeConstraints { make in
            make.top.equalTo(scoreIndicators.snp.bottom).offset(49 / masterRatio)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(headerView.snp.bottom).offset(-1 * 49 / masterRatio)
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
    
    private func setupReviewsView() {
        contentView.addSubview(reviewsView)
        reviewsView.snp.makeConstraints { make in
            make.top.equalTo(scoreDistributionView.snp.bottom)
            make.left.right.equalTo(contentView)
        }
        
        reviewsSectionHeader.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        reviewsView.addSubview(reviewsSectionHeader)
        reviewsSectionHeader.snp.makeConstraints { make in
            make.top.width.equalTo(reviewsView)
            make.height.equalTo(64 / masterRatio)
        }
        
        reviewsCounter.text = "0 voti"
        reviewsCounter.font = Constants.BrandFonts.avenirBook11
        reviewsCounter.textColor = UIColor.grocerestLightGrayColor()
        reviewsSectionHeader.addSubview(reviewsCounter)
        reviewsCounter.snp.makeConstraints { make in
            make.centerY.equalTo(reviewsSectionHeader)
            make.left.equalTo(reviewsSectionHeader).offset(31 / masterRatio)
        }
        
        reviewsTable.rowHeight = 234 / masterRatio
        reviewsTable.register(GRReviewTableViewCell.self, forCellReuseIdentifier: "cell")
        reviewsTable.dataSource = reviewsTableDataSource
        reviewsTable.isScrollEnabled = false
        reviewsTable.allowsSelection = false
        reviewsTable.separatorColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        reviewsView.addSubview(reviewsTable)
        updateReviewsTableHeight()
        
        seeAllReviewsButton.layer.borderWidth = 4 / masterRatio
        seeAllReviewsButton.layer.borderColor = UIColor.grocerestBlue().cgColor
        seeAllReviewsButton.layer.cornerRadius = 7 / masterRatio
        seeAllReviewsButton.layer.masksToBounds = true
        seeAllReviewsButton.setTitle("VEDI TUTTE LE RECENSIONI", for: UIControlState())
        seeAllReviewsButton.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        seeAllReviewsButton.titleLabel!.font = Constants.BrandFonts.avenirHeavy11
        seeAllReviewsButton.titleEdgeInsets = UIEdgeInsets(top: 20 / masterRatio, left: 47 / masterRatio, bottom: 20 / masterRatio, right: 47 / masterRatio)
        reviewsView.addSubview(seeAllReviewsButton)
        seeAllReviewsButton.snp.makeConstraints { make in
            make.top.equalTo(reviewsTable.snp.bottom).offset(64 / masterRatio)
            make.bottom.equalTo(reviewsView.snp.bottom).offset(-64 / masterRatio)
            make.left.equalTo(contentView).offset(32 / masterRatio)
            make.right.equalTo(contentView).offset(-32 / masterRatio)
        }
        seeAllReviewsButton.addTarget(self, action: #selector(self._seeAllReviewsButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupFooterView() {
        contentView.addSubview(footerView)
        footerView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        footerView.snp.makeConstraints { make in
            make.top.equalTo(reviewsView.snp.bottom)
            make.width.bottom.equalTo(contentView)
            make.height.equalTo(650 / masterRatio)
        }
        
        relatedProductsTitle.font = Constants.BrandFonts.avenirRoman13
        relatedProductsTitle.textColor = UIColor.grocerestDarkBoldGray()
        relatedProductsTitle.text = "Prodotti correlati"
        relatedProductsTitle.isHidden = true
        footerView.addSubview(relatedProductsTitle)
        relatedProductsTitle.snp.makeConstraints { make in
            make.top.equalTo(footerView).offset(36 / masterRatio)
            make.left.equalTo(footerView).offset(32 / masterRatio)
        }
        
        relatedProductsView.onTap = { productData in
            self.onRelatedProductTapped?(productData)
        }
        relatedProductsView.isHidden = true
        footerView.addSubview(relatedProductsView)
        relatedProductsView.snp.makeConstraints { make in
            make.top.equalTo(relatedProductsTitle.snp.bottom).offset(20 / masterRatio)
            make.left.right.equalTo(footerView)
        }
        
        tagsTitle.font = Constants.BrandFonts.avenirRoman13
        tagsTitle.textColor = UIColor.grocerestDarkBoldGray()
        footerView.addSubview(tagsTitle)
        tagsTitle.snp.makeConstraints { make in
            make.top.equalTo(footerView).offset(36 / masterRatio)
            make.left.equalTo(footerView).offset(32 / masterRatio)
            make.right.equalTo(footerView).offset(-32 / masterRatio)
        }
        
        tagsList.textFont = Constants.BrandFonts.avenirMedium11!
        tagsList.textColor = UIColor.grocerestLightGrayColor()
        tagsList.borderWidth = 1 / masterRatio
        tagsList.borderColor = UIColor.grocerestLightGrayColor()
        tagsList.tagBackgroundColor = UIColor.F1F1F1Color()
        tagsList.cornerRadius = 18 / masterRatio
        tagsList.paddingX = 24 / masterRatio
        tagsList.paddingY = 6 / masterRatio
        tagsList.marginY = 20 / masterRatio
        tagsList.marginX = 20 / masterRatio
        footerView.addSubview(tagsList)
        tagsList.snp.makeConstraints { make in
            make.top.equalTo(tagsTitle.snp.bottom).offset(43 / masterRatio)
            make.left.equalTo(footerView).offset(32 / masterRatio)
            make.right.equalTo(footerView).offset(-32 / masterRatio)
        }
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
    func updateReviewsTableHeight() {
        reviewsTable.snp.remakeConstraints { make in
            make.top.equalTo(reviewsSectionHeader.snp.bottom)
            make.left.right.equalTo(reviewsView)
            let height: CGFloat = 234 * CGFloat(reviewsTable.numberOfRows(inSection: 0))
            make.height.equalTo(height / masterRatio )
        }
    }
    
    // Callbacks calling functions
    
    func _shareButtonTapped(_: UIButton) {
        onShareButtonTapped?()
    }
    
    func _availabilityButtonTapped(_: UIButton) {
        onAvailabilityButtonTapped?()
    }
    func _productImageTapped(_: UITapGestureRecognizer) {
        onProductImageTapped?()
    }
    
    func _favouriteButtonTapped(_: UITapGestureRecognizer) {
        onFavouriteButtonTapped?()
    }
    
    func _hatedButtonTapped(_: UITapGestureRecognizer) {
        onHatedButtonTapped?()
    }
    
    func _toTryButtonTapped(_: UITapGestureRecognizer) {
        onToTryButtonTapped?()
    }
    
    func _otherListsButtonTapped(_: UITapGestureRecognizer) {
        onOtherListsButtonTapped?()
    }
    
    func _seeAllReviewsButtonTapped(_: UIButton) {
        onSeeAllReviewsButtonTapped?()
    }
    
    func _createReviewButtonWasTapped(_: UITapGestureRecognizer) {
        onCreateNewReviewButtonTapped?()
    }
    
    func _brandButtonWasTapped(_ sender: UIButton) {
        onBrandButtonWasTapped?()
    }
    
}
