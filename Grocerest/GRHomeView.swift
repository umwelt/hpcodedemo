//
//  GRHomeView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 02/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit



@IBDesignable
class GRHomeView: UIView, UIToolbarDelegate, GRToolBarProtocol {
    
    var viewsByName: [String: UIView]!
    var latestLists : GRTopListView?
    var inviteFriendsView : GRInviteFriendsView?
    //weak var delegate = GRHomeViewController()
    var delegate : GRToolBarProtocol?
    var pageControllerGhostView : UIView?
    var newListView = UIView()
    
    var ballonView = GRHomeBaloon()
    
    var wrapper = UIView()
    
    var reviewPlaceHolder = GRReviewsToCompletePlaceHolderView()
    var latestReviewsPlaceHolder = GRLatestReviewsPlaceHolderView()
    
    var inviteFriendsBlueButton : GRShineButton = {
        let button = GRShineButton()
        button.layer.borderWidth = 4 / masterRatio
        button.layer.borderColor = UIColor.grocerestBlue().cgColor
        button.layer.cornerRadius = 10 / masterRatio
        
        return button
    }()
    
    var inviteScroll : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: 240 / masterRatio)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delaysContentTouches = false
        scrollView.isScrollEnabled = true
        
        return scrollView
    }()
    
    fileprivate lazy var emailContactsLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.avenirRoman(30)
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    fileprivate lazy var fbContactsLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.avenirRoman(30)
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    

    
    
    var emailContacts : GRShineButton = {
        let button = GRShineButton()
        button.setImage(UIImage(named: "invite_mail"), for: UIControlState())
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    
    var fbContacts : UIButton = {
        let button = GRShineButton()
        button.setImage(UIImage(named: "invite_fb"), for: UIControlState())
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    
    var inviteFriendsButton = UIButton(type: .custom)
    
    
    lazy var  inviteFriends : UILabel = {
        let label = UILabel()
        label.text = Constants.AppLabels.inviteFriendsLabel
        label.font = Constants.BrandFonts.avenirBook11
        label.textColor = UIColor.grocerestLightGrayColor()
        label.textAlignment = .left
                
        return label
    }()
    
    
    lazy var inviteFriendsTitle : UILabel = {
        let label = UILabel()
        
        label.text = Constants.AppLabels.inviteYourFriends
        label.font = Constants.BrandFonts.ubuntuMedium20
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        return label
    }()
    
    lazy var inviteFriendsText : UILabel = {
        let label = UILabel()
        label.text = Constants.AppLabels.inviteYourFriendsText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Constants.BrandFonts.avenirRoman15
        label.textColor = UIColor.white
        
        return label
    }()
    
    
    lazy var daCompletareText : UILabel = {
        let label = UILabel()
        label.font = Constants.BrandFonts.avenirBook11
        label.textColor = UIColor.grocerestLightGrayColor()
        label.textAlignment = .left
        label.text = "Caricamento…"
        
        return label
    }()
    

    
    
    var completareOrCategoriesString: String? {
        get {
            return daCompletareText.text
        }
        set(newString) {
            daCompletareText.text = newString
        }
    }
    
    
    var reviewsToCompleteView = GRReviewsToComplete()
    
    var categoriesView = GRCategoriesToExplore()
    
    var lastReview = GRLastReviews()

    
    // - MARK: Life Cycle
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        // self.navigationToolBar?.delegate = self
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
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
    
    func setupHierarchy() {
        
        var viewsByName: [String: UIView] = [:]
        
        
        
        let navigationToolBar = GRToolbar()
        navigationToolBar.delegate = self
        self.addSubview(navigationToolBar)
        navigationToolBar.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.left.equalTo(0)
        }
        
        
        let __scaling__ = UIScrollView()
        __scaling__.bounces = true
        __scaling__.backgroundColor = UIColor.F1F1F1Color()
        self.addSubview(__scaling__)
        self.sendSubview(toBack: __scaling__)
        //__scaling__.contentSize.height = 2600 / masterRatio
        __scaling__.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(navigationToolBar.snp.bottom).offset(140 / masterRatio)
            make.width.equalTo(self)
            make.height.equalTo(self)
        }
        
        viewsByName["__scaling__"] = __scaling__

        
        
        __scaling__.addSubview(wrapper)
        wrapper.snp.makeConstraints { (make) in
            make.edges.equalTo(__scaling__)
            make.width.equalTo(self.snp.width)
        }
        
        
        wrapper.addSubview(ballonView)
        ballonView.snp.makeConstraints { (make) in
            make.width.equalTo(709 / masterRatio)
            make.height.equalTo(330 / masterRatio)
            make.top.equalTo(__scaling__.snp.top).offset(172 / masterRatio)
            make.left.equalTo(9 / masterRatio)
        }
        
        
        wrapper.addSubview(inviteFriendsBlueButton)
        inviteFriendsBlueButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(686 / masterRatio)
            make.right.equalTo(ballonView.snp.right)
            make.height.equalTo(70 / masterRatio)
            make.top.equalTo(ballonView.snp.bottom).offset(18 / masterRatio)
        }
        inviteFriendsBlueButton.setTitle(Constants.AppLabels.inviteYourFriends, for: UIControlState())
        inviteFriendsBlueButton.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        inviteFriendsBlueButton.titleLabel?.font = UIFont.avenirHeavy(22)
        inviteFriendsBlueButton.titleLabel?.textAlignment = .center
        
        inviteFriendsBlueButton.addTarget(self, action: #selector(GRHomeView.actionInviteFriendsWasPressed(_:)), for: .touchUpInside)
        
        
        wrapper.addSubview(daCompletareText)
        daCompletareText.snp.makeConstraints { (make) in
            make.top.equalTo(inviteFriendsBlueButton.snp.bottom).offset(22 / masterRatio)
            make.left.equalTo(inviteFriendsBlueButton.snp.left)
        }
        
        
        wrapper.addSubview(reviewPlaceHolder)
        reviewPlaceHolder.snp.makeConstraints { (make) in
            make.width.equalTo(891 / masterRatio)
            make.height.equalTo(370 / masterRatio)
            make.left.equalTo(0)
            make.top.equalTo(daCompletareText.snp.bottom).offset(20 / masterRatio)
        }
        
        
        
        wrapper.addSubview(reviewsToCompleteView)
        reviewsToCompleteView.snp.makeConstraints { (make) in
            make.width.equalTo(891 / masterRatio)
            make.height.equalTo(370 / masterRatio)
            make.left.equalTo(0)
            make.top.equalTo(daCompletareText.snp.bottom).offset(20 / masterRatio)
        }
        
        
        
        
        wrapper.addSubview(categoriesView)
        categoriesView.snp.makeConstraints { (make) in
            make.width.equalTo(891 / masterRatio)
            make.height.equalTo(370 / masterRatio)
            make.left.equalTo(0)
            make.top.equalTo(daCompletareText.snp.bottom).offset(20 / masterRatio)
        }
        categoriesView.isHidden = true
        
        //inviteFriendsButton.addTarget(self, action: #selector(GRAddFriendsView.actionBottomButtonWasPressed(_:)), forControlEvents: .TouchUpInside)
        
        pageControllerGhostView = UIView()
        wrapper.addSubview(pageControllerGhostView!)
        pageControllerGhostView!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(__scaling__.snp.width)
            make.height.equalTo(920 / masterRatio)
            make.left.equalTo(0)
            make.top.equalTo(reviewsToCompleteView.snp.bottom).offset(23 / masterRatio)
        }
        
        let lastReviewsLabel = UILabel()
        lastReviewsLabel.text = "Ultime Recensioni"
        lastReviewsLabel.font = UIFont.avenirBook(22)
        lastReviewsLabel.textColor = UIColor(hexString: "#979797")
        wrapper.addSubview(lastReviewsLabel)
        lastReviewsLabel.snp.makeConstraints { (make) in
            make.top.equalTo((pageControllerGhostView?.snp.bottom)!).offset(10 / masterRatio)
            make.left.equalTo((pageControllerGhostView?.snp.left)!).offset(33 / masterRatio)
            make.height.equalTo(30 / masterRatio)
        }
        
        
        wrapper.addSubview(latestReviewsPlaceHolder)
        latestReviewsPlaceHolder.snp.makeConstraints { (make) in
            make.width.equalTo(wrapper.snp.width)
            make.left.equalTo(0)
            make.top.equalTo(lastReviewsLabel.snp.bottom).offset(20 / masterRatio)
        }
        
        
        wrapper.addSubview(lastReview)
        lastReview.snp.makeConstraints { (make) in
            make.width.equalTo(wrapper.snp.width)
            make.left.equalTo(0)
            make.top.equalTo(lastReviewsLabel.snp.bottom).offset(20 / masterRatio)
           // make.height.lessThanOrEqualTo(1244 / masterRatio)
        }

        inviteFriendsView = GRInviteFriendsView()
        wrapper.addSubview(inviteFriendsView!)
        inviteFriendsView!.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(lastReview.snp.bottom).offset(32 / masterRatio)
            make.height.equalTo(400 / masterRatio)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.left.equalTo(0)
        }

        wrapper.addSubview(inviteScroll)
        
        inviteScroll.snp.makeConstraints { (make) in
            make.height.equalTo(400 / masterRatio)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.left.equalTo(0)
            make.top.equalTo(inviteFriendsView!.snp.top)
        }
        
        
        inviteScroll.addSubview(inviteFriendsTitle)
        inviteFriendsTitle.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(inviteFriendsView!.snp.width)
            make.height.equalTo(46 / masterRatio)
            make.centerX.equalTo(inviteScroll.snp.centerX)
            make.top.equalTo(inviteScroll.snp.top).offset(142 / masterRatio)
        }
        
        inviteScroll.addSubview(inviteFriendsText)
        inviteFriendsText.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(400 / masterRatio)
            make.height.equalTo(100 / masterRatio)
            make.top.equalTo(inviteScroll.snp.top).offset(178 / masterRatio)
            make.centerX.equalTo(inviteScroll.snp.centerX)
        }
            
        
        wrapper.addSubview(inviteFriendsButton)
        inviteFriendsButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(inviteScroll.snp.edges)
            
        }
        inviteFriendsButton.addTarget(self, action: #selector(GRHomeView.actionInviteFriendsWasPressed(_:)), for: .touchUpInside)
        
        

        
        let socialSelect = UIView()
        inviteScroll.addSubview(socialSelect)
        socialSelect.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(inviteScroll.snp.height)
            make.left.equalTo(UIScreen.main.bounds.width)
            make.top.equalTo(inviteFriendsView!.inviteFriendsView.snp.top)
        }
        
        wrapper.addSubview(emailContacts)
        emailContacts.snp.makeConstraints { (make) in
            make.width.height.equalTo(86 / masterRatio)
            make.top.equalTo(inviteScroll.snp.top).offset(134 / masterRatio)
            make.left.equalTo(socialSelect.snp.left).offset(257 / masterRatio)
        }
        emailContacts.addTarget(self, action: #selector(GRHomeView.emailContactsWasPressed(_:)), for: .touchUpInside)
        
        inviteScroll.addSubview(emailContactsLabel)
        emailContactsLabel.snp.makeConstraints { (make) in
            make.width.equalTo(236 / masterRatio)
            //make.height.equalTo(74 / masterRatio)
            make.right.equalTo(emailContacts.snp.right)
            make.top.equalTo(emailContacts.snp.bottom).offset(11 / masterRatio)
        }
        emailContactsLabel.text = "Accedi ai contatti della tua rubrica"
        
        
        
        wrapper.addSubview(fbContacts)
        fbContacts.snp.makeConstraints { (make) in
            make.width.height.equalTo(86 / masterRatio)
            make.top.equalTo(inviteScroll.snp.top).offset(134 / masterRatio)
            make.left.equalTo(emailContacts.snp.right).offset(64 / masterRatio)
        }
        
        fbContacts.addTarget(self, action: #selector(GRHomeView.fbContactsWasPressed(_:)), for: .touchUpInside)
        
        inviteScroll.addSubview(fbContactsLabel)
        fbContactsLabel.snp.makeConstraints { (make) in
            make.width.equalTo(236 / masterRatio)
            //make.height.equalTo(74 / masterRatio)
            make.left.equalTo(fbContacts.snp.left)
            make.top.equalTo(fbContacts.snp.bottom).offset(11 / masterRatio)
        }
        fbContactsLabel.text = "Invita i tuoi amici di Facebook"
        
        inviteScroll.bringSubview(toFront: emailContacts)
        
        let ghostArea = UIView()
        wrapper.addSubview(ghostArea)
        ghostArea.snp.makeConstraints { (make) in
            make.width.equalTo(wrapper.snp.width)
            make.top.equalTo(inviteFriendsView!.snp.bottom)
            make.height.equalTo(72 / masterRatio)
            make.bottom.equalTo(wrapper.snp.bottom)
        }

        self.viewsByName = viewsByName
        
    }
    
    
    // MARK: delegation
    
    func menuButtonWasPressed(_ sender: UIButton){
        delegate?.menuButtonWasPressed!(sender)
    }
    
    func grocerestButtonWasPressed(_ sender: UIButton){
    }
    
    func scannerButtonWasPressed(_ sender: UIButton){
        delegate?.scannerButtonWasPressed!(sender)
    }
    
    func searchButtonWasPressed(_ sender: UIButton){
        delegate?.searchButtonWasPressed!(sender)
    }
    
    func actionInviteFriendsWasPressed(_ sender:UIButton) {
         delegate?.inviteFriendsWasPressed!(sender)
    }
    
    func emailContactsWasPressed(_ sender:UIButton) {
        delegate?.contactsWasPressed!(sender)
    }
    
    func fbContactsWasPressed(_ sender:UIButton) {
        delegate?.fbcontactsWasPressed!(sender)
    }
    
    func willShowEitherToCompleteOrCategoriesView(_ reviews:Bool) {
        
        reviewPlaceHolder.isHidden = true
        
        if reviews {
            completareOrCategoriesString = Constants.AppLabels.daCompletare
            reviewsToCompleteView.isHidden = false
            categoriesView.isHidden = true
        } else {
            completareOrCategoriesString = Constants.AppLabels.esploraCategorie
            reviewsToCompleteView.isHidden = true
            categoriesView.isHidden = false
        }
    }
}
