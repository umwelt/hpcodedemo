//
//  GRReviewBoxView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit



@IBDesignable
class GRReviewBoxView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var viewsByName: [String: UIView]!
    var paginatedScrollView = UIScrollView()
    var numberOfPages :CGFloat =  3.00
    var pageSize =  CGSize(width: 684 / masterRatio, height: 290 / masterRatio)
    var pageWidth = 684 / masterRatio
    var delegate : GRPostReviewProtocol?
    
    var pageControl = UIPageControl()
    
    var voteView: GRReviewBoxVote?
    var viewFrequency : GRReviewBoxFrequency?
    var viewComment : GRReviewBoxWriteComment?
    
    
    // MARK: Life Cycle
    
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
   
    
    // - MARK: Scaling
    
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
        let __scaling__ = UIView()
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        paginatedScrollView = UIScrollView()
        __scaling__.addSubview(paginatedScrollView)
        paginatedScrollView.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(0)
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(310 / masterRatio)
        }
        
        paginatedScrollView.isPagingEnabled = true
        paginatedScrollView.showsHorizontalScrollIndicator = false
        paginatedScrollView.bounces = false
        paginatedScrollView.delegate = self
        paginatedScrollView.contentSize = CGSize(width: 2052 / masterRatio, height: pageSize.height)
        paginatedScrollView.contentInset = UIEdgeInsetsMake(0, 2.0, 0, 2.0)
        paginatedScrollView.autoresizesSubviews = false
        
        
        let frame = CGRect(x: 0, y: 0, width: 684 / masterRatio, height: 260 / masterRatio)
        voteView = GRReviewBoxVote(frame: frame)
        paginatedScrollView.addSubview(voteView!)
        voteView!.layer.cornerRadius = 5.0
        paginatedScrollView.isScrollEnabled = false
        voteView!.backgroundColor = UIColor.white
        
        voteView?.voteOne?.addTarget(self, action: #selector(GRReviewBoxView.actionVoteOneButtonWasPressed(_:)), for: .touchUpInside)
        voteView?.voteTwo?.addTarget(self, action: #selector(GRReviewBoxView.actionVotetwoButtonWasPressed(_:)), for: .touchUpInside)
        voteView?.voteThree?.addTarget(self, action: #selector(GRReviewBoxView.actionVoteThreeButtonWasPressed(_:)), for: .touchUpInside)
        voteView?.voteFour?.addTarget(self, action: #selector(GRReviewBoxView.actionVoteFourButtonWasPressed(_:)), for: .touchUpInside)
        voteView?.voteFive?.addTarget(self, action: #selector(GRReviewBoxView.actionVoteFiveButtonWasPressed(_:)), for: .touchUpInside)
        
        
        let frameFQ = CGRect(x: pageSize.width + 1, y: 0, width: 684 / masterRatio, height: 260 / masterRatio)
        viewFrequency = GRReviewBoxFrequency(frame: frameFQ)
        viewFrequency!.layer.cornerRadius = 5.0
        viewFrequency!.backgroundColor = UIColor.white
        
        
        viewFrequency!.freqFirst!.addTarget(self, action: #selector(GRReviewBoxView.actionFreqFirstWasPressed(_:)), for: .touchUpInside)
        viewFrequency!.freqRarely!.addTarget(self, action: #selector(GRReviewBoxView.actionFreqRarelyWasPressed(_:)), for: .touchUpInside)
        viewFrequency!.freqMontly!.addTarget(self, action: #selector(GRReviewBoxView.actionFreqMontlyWasPressed(_:)), for: .touchUpInside)
        viewFrequency!.freqWeakly!.addTarget(self, action: #selector(GRReviewBoxView.actionfreqWeaklyWasPressed(_:)), for: .touchUpInside)
        viewFrequency!.freqDaily!.addTarget(self, action: #selector(GRReviewBoxView.actionFreqDailyWasPressed(_:)), for: .touchUpInside)
        
        
        let frameComment = CGRect(x: pageSize.width * 2 + 1, y: 0, width: 684 / masterRatio, height: 260 / masterRatio)
        viewComment = GRReviewBoxWriteComment(frame: frameComment)
        viewComment!.layer.cornerRadius = 5.0
        viewComment!.backgroundColor = UIColor.white
        viewComment!.writeCommentButton!.addTarget(self, action: #selector(GRReviewBoxView.actionWriteCommentButtonWasPressed(_:)), for: .touchUpInside)
        
        
        
        paginatedScrollView.addSubview(viewFrequency!)
        paginatedScrollView.addSubview(viewComment!)
        //paginatedScrollView.addSubview(viewCommentReview!)

        viewsByName["paginatedScrollView"] = paginatedScrollView
        self.viewsByName = viewsByName
        
        pageControl = UIPageControl()
        __scaling__.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(paginatedScrollView.snp.width)
            make.height.equalTo(20)
            make.bottom.equalTo(paginatedScrollView.snp.bottom).offset(-60 / masterRatio)
            make.centerX.equalTo(paginatedScrollView.snp.centerX)
        }
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.isEnabled = false
        pageControl.isUserInteractionEnabled = false
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.grocerestLightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.grocerestLightGrayColor()
        
    }
    


    
    //View for comment inserted
    
    func commentView()-> GRReviewBoxComented {
        let frame = CGRect(x: pageSize.width * 3 + 1 , y: 0, width: 684 / masterRatio, height: 220 / masterRatio)
        let view = GRReviewBoxComented(frame: frame)
        view.layer.cornerRadius = 5.0
        view.backgroundColor = UIColor.white
        return view
    }
    
    func touchesShouldCancelInContentView(_ view: UIView!) -> Bool {
        if view.isKind(of: UIButton.self) {
            return false
        }
        return true
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // FIRST BOX : VOTE
    
    
    
    func actionVoteOneButtonWasPressed(_ sender: UIButton){
        delegate?.postVoteForItem!(sender)
        chainedButtonState(sender.tag)
        animateTransition(pageWidth)
        pageControl.currentPage = 1
        
    }
    
    func actionVotetwoButtonWasPressed(_ sender: UIButton){
        delegate?.postVoteForItem!(sender)
        chainedButtonState(sender.tag)
        animateTransition(pageWidth)
        pageControl.currentPage = 1
    }
    
    func actionVoteThreeButtonWasPressed(_ sender : UIButton){
        delegate?.postVoteForItem!(sender)
        chainedButtonState(sender.tag)
        animateTransition(pageWidth)
        pageControl.currentPage = 1
    }
    
    func actionVoteFourButtonWasPressed(_ sender : UIButton){
        delegate?.postVoteForItem!(sender)
        chainedButtonState(sender.tag)
        animateTransition(pageWidth)
        pageControl.currentPage = 1
    }
    
    func actionVoteFiveButtonWasPressed(_ sender : UIButton){
        delegate?.postVoteForItem!(sender)
        chainedButtonState(sender.tag)
        animateTransition(pageWidth)
        pageControl.currentPage = 1
    }
    
    func animateTransition(_ xPosition: CGFloat) {
        
        if xPosition > 100 {
            paginatedScrollView.isScrollEnabled = true
            pageControl.isEnabled = true
        }
        
        
        pageControl.currentPageIndicatorTintColor = UIColor.grocerestBlue()
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .transitionFlipFromRight, animations: { () -> Void in
            
            self.paginatedScrollView.contentOffset = CGPoint(x: xPosition, y: 0)
           
            }) { (finished: Bool) -> Void in
                print("finished")
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x < 343 {
            pageControl.currentPage = 0
        } else if 343 <= scrollView.contentOffset.x && scrollView.contentOffset.x < 685 {
            pageControl.currentPage = 1
        } else {
            pageControl.currentPage = 2
        }
        
    }
    
    
    
    
    
    // SECOND BOX : VOTE
    
    func actionFreqFirstWasPressed(_ sender: UIButton){
        delegate?.postFrequencyForItem!(sender)
        animateTransition(1372 / masterRatio)
        pageControl.currentPage = 2
    }
    func actionFreqRarelyWasPressed(_ sender: UIButton){
        delegate?.postFrequencyForItem!(sender)
        animateTransition(1372 / masterRatio)
        pageControl.currentPage = 2
    }
    func actionFreqMontlyWasPressed(_ sender: UIButton){
        delegate?.postFrequencyForItem!(sender)
        animateTransition(1372 / masterRatio)
        pageControl.currentPage = 2
    }
    func actionfreqWeaklyWasPressed(_ sender: UIButton){
        delegate?.postFrequencyForItem!(sender)
        animateTransition(1372 / masterRatio)
        pageControl.currentPage = 2
    }
    func actionFreqDailyWasPressed(_ sender: UIButton){
        delegate?.postFrequencyForItem!(sender)
        animateTransition(1372 / masterRatio)
        pageControl.currentPage = 2
    }
    
    // THIRD BOX : COMMENT
    
    func actionWriteCommentButtonWasPressed(_ sender: UIButton) {
        delegate?.postCommentForItem!(sender)
    }
    
    
    /**
    *  Buttons
    */
    
    func setState(_ button: UIButton) {
        button.isSelected = !button.isSelected
    }
    
    func chainedButtonState(_ sender: Int) {
        //TODO Makeit nice
        switch sender {
        case 0:
            voteView!.voteOne?.isSelected = false
            voteView!.voteTwo?.isSelected = false
            voteView!.voteThree?.isSelected = false
            voteView!.voteFour?.isSelected = false
            voteView!.voteFive?.isSelected = false
            
        case 1:
            voteView!.voteOne?.isSelected = true
            voteView!.voteTwo?.isSelected = false
            voteView!.voteThree?.isSelected = false
            voteView!.voteFour?.isSelected = false
            voteView!.voteFive?.isSelected = false
        case 2:
            
            voteView!.voteOne?.isSelected = true
            voteView!.voteTwo?.isSelected = true
            voteView!.voteThree?.isSelected = false
            voteView!.voteFour?.isSelected = false
            voteView!.voteFive?.isSelected = false
        case 3:
            
            voteView!.voteOne?.isSelected = true
            voteView!.voteTwo?.isSelected = true
            voteView!.voteThree?.isSelected = true
            voteView!.voteFour?.isSelected = false
            voteView!.voteFive?.isSelected = false
        case 4:
            voteView!.voteOne?.isSelected = true
            voteView!.voteTwo?.isSelected = true
            voteView!.voteThree?.isSelected = true
            voteView!.voteFour?.isSelected = true
            voteView!.voteFive?.isSelected = false
        case 5:
            
            voteView!.voteOne?.isSelected = true
            voteView!.voteTwo?.isSelected = true
            voteView!.voteThree?.isSelected = true
            voteView!.voteFour?.isSelected = true
            voteView!.voteFive?.isSelected = true
            
        default:
            print("this just cant happen")
        }
        
    }
    
    func simulateButtonPress(_ sender: Int) {
        chainedButtonState(sender)
        animateTransition(0)
        pageControl.currentPage = 0
    }
    




    
}
