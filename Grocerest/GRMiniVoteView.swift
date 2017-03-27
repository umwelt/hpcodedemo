//
//  GRMiniVoteView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 14/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SnapKit



class voteButton: UIButton {
    
    convenience init(type buttonType: UIButtonType) {
        self.init(frame: CGRect.zero)
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
    }
    
    
    
    func setupHierarchy(){

        setBackgroundImage( UIImage(named: "neutral_vote"), for: UIControlState())
        contentMode = .scaleAspectFit
        self.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.smallVoteButtonSize)
            make.left.equalTo(self.snp.left).offset(66 / masterRatio)
           // make.top.equalTo(reviewLabel.snp.bottom).offset(30 / masterRatio)
        }
        
    }
    
}

@IBDesignable

class GRMiniVoteView: UIView {
        
    var voteOne : UIButton?
    var voteTwo : UIButton?
    var voteThree : UIButton?
    var voteFour : UIButton?
    var voteFive : UIButton?
    
    
    // - MARK: Life Cycle
    
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

    }
    
    func setupHierarchy() {
        
        voteOne = UIButton(type: .custom)
        self.addSubview(voteOne!)
        var imagevoteOneButton: UIImage!
        imagevoteOneButton = UIImage(named: "neutral_vote")
        voteOne!.setBackgroundImage(imagevoteOneButton, for: UIControlState())
        voteOne!.setImage(UIImage(named: "positive_vote"), for: .selected)
        voteOne!.contentMode = .scaleAspectFit
        voteOne!.tag = 1
        voteOne!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.smallVoteButtonSize)
            make.left.equalTo(self.snp.left)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        
        voteTwo = UIButton(type: .custom)
        self.addSubview(voteTwo!)
        var imagevotetwoButton: UIImage!
        imagevotetwoButton = UIImage(named: "neutral_vote")
        voteTwo!.setImage(imagevotetwoButton, for: UIControlState())
        voteTwo!.setImage(UIImage(named: "positive_vote"), for: .selected)
        voteTwo!.contentMode = .scaleAspectFit
        voteTwo!.tag = 2
        voteTwo!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.smallVoteButtonSize)
            make.left.equalTo(voteOne!.snp.right).offset(10 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        voteThree = UIButton(type: .custom)
        self.addSubview(voteThree!)
        var imagevoteThreeButton: UIImage!
        imagevoteThreeButton = UIImage(named: "neutral_vote")
        voteThree!.setImage(imagevoteThreeButton, for: UIControlState())
        voteThree!.setImage(UIImage(named: "positive_vote"), for: .selected)
        voteThree!.contentMode = .scaleAspectFit
        voteThree!.tag = 3
        voteThree!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.smallVoteButtonSize)
            make.left.equalTo(voteTwo!.snp.right).offset(10 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        voteFour = UIButton(type: .custom)
        self.addSubview(voteFour!)
        var imagevoteFourButton: UIImage!
        imagevoteFourButton = UIImage(named: "neutral_vote")
        voteFour!.setImage(imagevoteFourButton, for: UIControlState())
        voteFour!.setImage(UIImage(named: "positive_vote"), for: .selected)
        voteFour!.contentMode = .scaleAspectFit
        voteFour!.tag = 4
        voteFour!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.smallVoteButtonSize)
            make.left.equalTo(voteThree!.snp.right).offset(10 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        voteFive = UIButton(type: .custom)
        self.addSubview(voteFive!)
        var imagevoteFiveButton: UIImage!
        imagevoteFiveButton = UIImage(named: "neutral_vote")
        voteFive!.setImage(imagevoteFiveButton, for: UIControlState())
        voteFive!.setImage(UIImage(named: "positive_vote"), for: .selected)
        voteFive!.contentMode = .scaleAspectFit
        voteFive!.tag = 5
        voteFive!.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.smallVoteButtonSize)
            make.left.equalTo(voteFour!.snp.right).offset(10 / masterRatio)
            make.centerY.equalTo(self.snp.centerY)
        }

        
    }
    
    func chainedButtonState(_ sender: UIButton) {
        //TODO Makeit nice
                switch sender.tag {
                case 1:
                    voteOne?.isSelected = true
                    voteTwo?.isSelected = false
                    voteThree?.isSelected = false
                    voteFour?.isSelected = false
                    voteFive?.isSelected = false
                case 2:
        
                    voteOne?.isSelected = true
                    voteTwo?.isSelected = true
                    voteThree?.isSelected = false
                    voteFour?.isSelected = false
                    voteFive?.isSelected = false
                case 3:
        
                    voteOne?.isSelected = true
                    voteTwo?.isSelected = true
                    voteThree?.isSelected = true
                    voteFour?.isSelected = false
                    voteFive?.isSelected = false
                case 4:
                    voteOne?.isSelected = true
                    voteTwo?.isSelected = true
                    voteThree?.isSelected = true
                    voteFour?.isSelected = true
                    voteFive?.isSelected = false
                case 5:
        
                    voteOne?.isSelected = true
                    voteTwo?.isSelected = true
                    voteThree?.isSelected = true
                    voteFour?.isSelected = true
                    voteFive?.isSelected = true
                    
                    
                default:
                    print("this just cant happen")
                }
        
    }
    

    
    
}
