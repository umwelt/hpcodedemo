//
//  GRSingleProductMoreActionsModalView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRSingleProductMoreActionsModalView: UITableViewCell {
    
    let backgroundControllerView = UIView()
    let closeButton = UIButton()
    
    var viewsByName: [String: UIView]!
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var backgroundCover = UIView()
    var delegate : GRSingleProductMoreActionsProtocol?
    var productImageView : UIImageView?
    var productMainLabel : UILabel?
    var toProductButton = UIButton()
    
    var productSecondaryLabel: UILabel?
    var recensioneButton: UIButton?
    var moreButton: UIButton?
    var midContainer = UIView()
    var bottomMidContainer : UIView?
    var preferitiButton : UIButton?
    var evitareButton : UIButton?
    var provareButton : UIButton?
    
    var footer = UIView()
    
    private let listIcon = UIImageView()
    private let scannedIcon = UIImageView()
    private let reviewsIcon = UIImageView(image: UIImage(named: "edit-small"))
    private let reviewsCounter = UILabel()
    private let reviewsText = UILabel()
    private let noReviewsMessage = UILabel()
    private var scoreIndicators = UIStackView()
    private let scoreCounter = UILabel()
    private let noScoreLabel = UILabel()
    
    var onTitleOrBrandTapped: (() -> Void)?
    var onBottomTapped: (() -> Void)?
    var onReviewButtonTapped: (() -> Void)?
    
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
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
        
        if let scalingView = self.viewsByName["__scaling__"] {
            var xScale = self.bounds.size.width / scalingView.bounds.size.width
            var yScale = self.bounds.size.height / scalingView.bounds.size.height
            switch contentMode {
            case .scaleToFill:
                break
            case .scaleAspectFill:
                let scale = max(xScale, yScale)
                xScale = scale
                yScale = scale
            default:
                let scale = min(xScale, yScale)
                xScale = scale
                yScale = scale
            }
            scalingView.transform = CGAffineTransform(scaleX: xScale, y: yScale)
            scalingView.center = CGPoint(x:self.bounds.midX, y:self.bounds.midY)
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
           // if reviewStatus == oldValue { return }
            recensioneButton?.imageView?.image = nil
            switch reviewStatus {
            case .none:
                recensioneButton!.setImage(UIImage(named: "v2_scrivi_recensione"), for: UIControlState())
            case .incomplete:
                recensioneButton!.setImage(UIImage(named: "v2_recensione_nocompleta"), for: UIControlState())
            case .complete:
                recensioneButton!.setImage(UIImage(named: "v2_recensione_completa"), for: UIControlState())
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
                    make.right.equalTo(listIcon.snp.left).offset(-13 / masterRatio)
                }
            }
            listIcon.image =  nil
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
                scannedIcon.snp.removeConstraints()
                scannedIcon.snp.makeConstraints { make in
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
    
    var numberOfReviews: Int = 0 {
        didSet {
            if numberOfReviews < 0 {
                // Cannot set a negative number of reviews
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEvent(withCategory: "Soft errors",
                                                                         action: "ProductsResultTableViewCell: negative numberOfReviews",
                                                                         label: "fix this",
                                                                         value: nil
                )
                tracker?.send(event?.build() as [NSObject: AnyObject]?)
                numberOfReviews = 0
                return
            }
            
            if numberOfReviews == 0 {
                reviewsIcon.isHidden = true
                reviewsCounter.isHidden = true
                reviewsText.text = "recensioni"
                reviewsText.isHidden = true
                noReviewsMessage.isHidden = false
            } else {
                reviewsCounter.text = "\(numberOfReviews)"
                reviewsIcon.isHidden = false
                reviewsCounter.isHidden = false
                reviewsText.text = (numberOfReviews == 1 ? "recensione" : "recensioni")
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
                                                                         label: "fix thois",
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

    
    
    
    func setupHierarchy() {
        
        var viewsByName: [String: UIView] = [:]
        let __scaling__ = UIView()
        __scaling__.backgroundColor = UIColor.clear
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        __scaling__.addSubview(backgroundCover)
        backgroundCover.snp.makeConstraints { (make) in
            make.edges.equalTo(__scaling__)
        }
        backgroundCover.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.backgroundCover.alpha = 0
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.backgroundCover.addSubview(blurEffectView)
        
        
        __scaling__.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(80 / masterRatio)
            make.top.equalTo(28 / masterRatio)
            make.right.equalTo(-29 / masterRatio)
        }
        closeButton.contentMode = .center
        closeButton.setImage(UIImage(named: "whiteCloseButton"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(GRSingleProductMoreActionsModalView.actionCloseButtonWasPressed(_:)), for: .touchUpInside)
        
        
        
        __scaling__.addSubview(backgroundControllerView)
        backgroundControllerView.backgroundColor = UIColor.white
        backgroundControllerView.layer.cornerRadius = 5
        backgroundControllerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(687 / masterRatio)
            make.height.equalTo(830 / masterRatio)
            make.centerX.equalTo(__scaling__.snp.centerX)
            make.top.equalTo(-450)
        }
        
        viewsByName["backgroundControllerView"] = backgroundControllerView
        
        
        let topContainer = UIView()
        backgroundControllerView.addSubview(topContainer)
        topContainer.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(backgroundControllerView.snp.width)
            make.height.equalTo(252 / masterRatio)
            make.top.equalTo(backgroundControllerView.snp.top)
            make.centerX.equalTo(backgroundControllerView.snp.centerX)
        }
        
        productImageView = UIImageView()
        topContainer.addSubview(productImageView!)
        productImageView?.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(218 / masterRatio)
            make.left.top.equalTo(20 / masterRatio)
        })
        productImageView?.contentMode = .scaleAspectFit
        
        productMainLabel = UILabel()
        topContainer.addSubview(productMainLabel!)
        productMainLabel?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(400 / masterRatio)
            make.left.equalTo(productImageView!.snp.right).offset(20 / masterRatio)
            make.top.equalTo(topContainer.snp.top).offset(40 / masterRatio)
        })
        productMainLabel?.textAlignment = .left
        productMainLabel?.lineBreakMode = .byWordWrapping
        productMainLabel?.numberOfLines = 2
        productMainLabel?.font = Constants.BrandFonts.ubuntuMedium16
        productMainLabel?.textColor = UIColor.grocerestDarkBoldGray()
        
        
        topContainer.addSubview(toProductButton)
        toProductButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(productMainLabel!)
        }
        
        
        
        productSecondaryLabel = UILabel()
        topContainer.addSubview(productSecondaryLabel!)
        productSecondaryLabel?.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(400 / masterRatio)
            make.height.equalTo(30 / masterRatio)
            make.left.equalTo(productMainLabel!.snp.left)
            make.top.equalTo(productMainLabel!.snp.bottom).offset(11 / masterRatio)
        })
        productSecondaryLabel!.textAlignment = .left
        productSecondaryLabel!.font = Constants.BrandFonts.avenirBook11
        productSecondaryLabel!.textColor = UIColor.grocerestLightGrayColor()
        
        recensioneButton = UIButton(type: .custom)
        topContainer.addSubview(recensioneButton!)
        recensioneButton!.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50 / masterRatio)
            make.top.equalTo(productSecondaryLabel!.snp.bottom).offset(12 / masterRatio)
            make.left.equalTo(productMainLabel!.snp.left)
        }
        recensioneButton!.contentMode = .scaleAspectFit
        recensioneButton?.addTarget(self, action: #selector(GRSingleProductMoreActionsModalView.actionRecensioneButtonWasPressed(_:)), for: .touchUpInside)
        
        
        moreButton = UIButton(type:.custom)
        topContainer.addSubview(moreButton!)
        moreButton?.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(50 / masterRatio)
            make.top.equalTo(recensioneButton!.snp.top)
            make.left.equalTo(recensioneButton!.snp.right).offset(16 / masterRatio)
        })
        
        moreButton?.contentMode = .scaleAspectFit
        moreButton?.setBackgroundImage(UIImage(named: "v2_plus"), for: UIControlState())
        moreButton?.addTarget(self, action: #selector(GRSingleProductMoreActionsModalView.actionCloseButtonWasPressed(_:)), for: .touchUpInside)
        
        
        //
        
        let selectorTriangleImageView = UIImageView()
        topContainer.addSubview(selectorTriangleImageView)
        selectorTriangleImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(65 / masterRatio)
            make.height.equalTo(36 / masterRatio)
            make.left.equalTo(316 / masterRatio)
            make.bottom.equalTo(topContainer.snp.bottom).offset(3)
        }
        selectorTriangleImageView.contentMode = .scaleAspectFit
        selectorTriangleImageView.image = UIImage(named: "triangle_pointer")
        
        viewsByName["topContainer"] = topContainer
        
        
        backgroundControllerView.addSubview(midContainer)
        midContainer.backgroundColor = UIColor.F1F1F1Color()
        midContainer.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(backgroundControllerView.snp.width)
            make.height.equalTo(505 / masterRatio)
            make.top.equalTo(topContainer.snp.bottom)
            make.centerX.equalTo(backgroundControllerView.snp.centerX)
        }
        
        
        let topMidContainer = UIView()
        midContainer.addSubview(topMidContainer)
        topMidContainer.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(midContainer.snp.width)
            make.height.equalTo(240 / masterRatio)
            make.top.equalTo(midContainer.snp.top)
            make.centerX.equalTo(midContainer.snp.centerX)
        }
        
        /// Preferiti Button
        
        let buttonSize = CGSize(width: 98 / masterRatio, height: 98 / masterRatio)
        
        
        preferitiButton = UIButton()
        topMidContainer.addSubview(preferitiButton!)
        preferitiButton!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(buttonSize)
            make.left.equalTo(topMidContainer.snp.left).offset(64 / masterRatio)
            make.top.equalTo(topMidContainer.snp.top).offset(50 / masterRatio)
        }
        preferitiButton!.contentMode = .scaleAspectFit
        preferitiButton!.setImage(UIImage(named: "preferiti_on"), for: .selected)
        preferitiButton!.setImage(UIImage(named: "preferiti_off"), for: UIControlState())
        preferitiButton!.addTarget(self, action: #selector(GRSingleProductMoreActionsModalView.actionPreferitiButtonWasPressed(_:)), for: .touchUpInside)
        
        let label = UILabel()
        preferitiButton!.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(116 / masterRatio)
            make.height.equalTo(28 / masterRatio)
            make.centerX.equalTo(preferitiButton!.snp.centerX)
            make.top.equalTo(preferitiButton!.snp.bottom).offset(20 / masterRatio)
        }
        label.text = "preferiti"
        label.textColor = UIColor.lightGrayTextcolor()
        label.font = Constants.BrandFonts.avenirBook12
        label.textAlignment = .center
        
        
        /// Evitare Button
        
        evitareButton = UIButton()
        topMidContainer.addSubview(evitareButton!)
        evitareButton!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(buttonSize)
            make.left.equalTo(preferitiButton!.snp.right).offset(56 / masterRatio)
            make.top.equalTo(preferitiButton!.snp.top)
        }
        evitareButton?.setImage(UIImage(named: "evitare_on"), for: .selected)
        evitareButton?.setImage(UIImage(named: "evitare_off"), for: UIControlState())
        evitareButton!.addTarget(self, action: #selector(GRSingleProductMoreActionsModalView.actionEvitareButtonWasPressed(_:)), for: .touchUpInside)
        
        
        let evitareLabel = UILabel()
        evitareButton!.addSubview(evitareLabel)
        evitareLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(116 / masterRatio)
            make.height.equalTo(28 / masterRatio)
            make.centerX.equalTo(evitareButton!.snp.centerX)
            make.top.equalTo(label.snp.top)
        }
        evitareLabel.text = "da evitare"
        evitareLabel.textColor = UIColor.lightGrayTextcolor()
        evitareLabel.font = Constants.BrandFonts.avenirBook12
        evitareLabel.textAlignment = .center
        
        
        /// Provare Button
        
        
        provareButton = UIButton()
        topMidContainer.addSubview(provareButton!)
        provareButton!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(buttonSize)
            make.left.equalTo(evitareButton!.snp.right).offset(56 / masterRatio)
            make.top.equalTo(evitareButton!.snp.top)
        }
        provareButton?.contentMode = .scaleAspectFit
        provareButton?.setImage(UIImage(named: "provare_on"), for: .selected)
        provareButton?.setImage(UIImage(named: "provare_off"), for: UIControlState())
        provareButton!.addTarget(self, action: #selector(GRSingleProductMoreActionsModalView.actionProvareButtonWasPressed(_:)), for: .touchUpInside)
        
        
        
        let provareLabel = UILabel()
        provareButton!.addSubview(provareLabel)
        provareLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(116 / masterRatio)
            make.height.equalTo(28 / masterRatio)
            make.centerX.equalTo(provareButton!.snp.centerX)
            make.top.equalTo(label.snp.top)
        }
        provareLabel.text = "da provare"
        provareLabel.textColor = UIColor.lightGrayTextcolor()
        provareLabel.font = Constants.BrandFonts.avenirBook12
        provareLabel.lineBreakMode = .byWordWrapping
        provareLabel.textAlignment = .center
        
        
        
        /// Nuova Lista Button
        
        
        
        let newListButton = UIButton()
        topMidContainer.addSubview(newListButton)
        newListButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(146 / masterRatio)
            make.width.equalTo(98 / masterRatio)
            make.left.equalTo(provareButton!.snp.right).offset(56 / masterRatio)
            make.top.equalTo(provareButton!.snp.top)
        }
        
        newListButton.addTarget(self, action: #selector(GRSingleProductMoreActionsModalView.actionNuovaListaButtonWasPressed(_:)), for: .touchUpInside)
        
        let newListImageView = UIImageView()
        newListButton.addSubview(newListImageView)
        newListImageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(newListButton.snp.centerX)
            make.top.equalTo(newListButton.snp.top)
            make.width.equalTo(98 / masterRatio)
        }
        newListImageView.contentMode = .scaleAspectFit
        newListImageView.image = UIImage(named: "nuovalista_large")
        
        let newListLabel = UILabel()
        newListButton.addSubview(newListLabel)
        newListLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(116 / masterRatio)
            make.height.equalTo(28 / masterRatio)
            make.centerX.equalTo(newListButton.snp.centerX)
            make.top.equalTo(label.snp.top)
        }
        newListLabel.text = "nuova lista"
        newListLabel.textColor = UIColor.lightGrayTextcolor()
        newListLabel.font = Constants.BrandFonts.avenirBook12
        newListLabel.lineBreakMode = .byWordWrapping
        newListLabel.textAlignment = .center
        
        
        /// End midtopActions
        bottomMidContainer = UIView()
        midContainer.addSubview(bottomMidContainer!)
        bottomMidContainer!.backgroundColor = UIColor.F1F1F1Color()
        bottomMidContainer!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(midContainer.snp.width)
            make.height.equalTo(220 / masterRatio)
            make.top.equalTo(topMidContainer.snp.bottom)
            make.centerX.equalTo(midContainer.snp.centerX)
        }
        
        viewsByName["midContainer"] = midContainer
        
        
        backgroundControllerView.addSubview(footer)
        footer.snp.makeConstraints { make in
            make.left.equalTo((bottomMidContainer?.snp.left)!)
            make.width.equalTo(midContainer.snp.width)
            make.height.equalTo(68 / masterRatio)
            make.bottom.equalTo(backgroundControllerView.snp.bottom)
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
        reviewsCounter.translatesAutoresizingMaskIntoConstraints = false
        reviewsCounter.numberOfLines = 0
        
        
        reviewsText.font = Constants.BrandFonts.avenirMedium13
        reviewsText.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
       // reviewsText.text = "recensioni"
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
        self.viewsByName = viewsByName
    }
    
    
    func actionCloseButtonWasPressed(_ sender:UIButton) {
        delegate?.closeButtonWasPressed!(sender)
    }
    
    func actionPreferitiButtonWasPressed(_ sender:UIButton) {
        delegate?.preferitiButtonWasPressed!(sender)
    }
    
    func actionEvitareButtonWasPressed(_ sender:UIButton) {
        delegate?.evitareButtonWasPressed!(sender)
    }
    
    func actionProvareButtonWasPressed(_ sender:UIButton) {
        delegate?.provareButtonWasPressed!(sender)
    }
    
    
    func actionNuovaListaButtonWasPressed(_ sender:UIButton) {
        delegate?.createNewListWasPressed!(sender)
    }
    
    func actionMapButtonWasPressed(_ sender:UIButton) {
        delegate?.localizeButtonWasPressed!(sender)
    }
    
    func actionRecensioneButtonWasPressed(_ sender:UIButton) {
        delegate?.recensioneButtonWasPressed!(sender)
    }
    
    func recensioneButtonTapped(_ sender: UIButton) {
        onReviewButtonTapped?()
    }
    
    func productButtonTapped(_ sender: UIButton) {
        onTitleOrBrandTapped?()
    }
    
    func bottomButtonTapped(_ sender: UIButton) {
        onBottomTapped?()
    }
    
    
    func willShowComponentView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.backgroundCover.alpha = 0.95
        })
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: UIViewAnimationOptions(), animations: {
            self.viewsByName["backgroundControllerView"]!.transform = CGAffineTransform(translationX: 0, y: 1050 / masterRatio)
        })
    }
    
    func willHideComponentView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.viewsByName["backgroundControllerView"]!.transform = CGAffineTransform(translationX: 0, y: -450 / masterRatio)
        })
    }
    
}
