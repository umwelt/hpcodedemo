//
//  GROrderItemsView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 11/04/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

enum OrderingButtons {
    case asc
    case desc
}

@IBDesignable
class GROrderItemsView: UIView {
    
    var animationCompletions = Dictionary<CAAnimation, (Bool) -> Void>()
    var viewsByName: [String : UIView]!
    
    var oButtons = OrderingButtons.asc
    
    let blurEffect = UIBlurEffect(style: .dark)
    var delegate = GROrderItemsViewController()
    
    var ascButton = UIButton(type: .custom)
    var descButton = UIButton(type: .custom)
    
    var firstFilterButton = UIButton(type: .custom)
    var secondFilterButton = UIButton(type: .custom)
    var thirdFilterButton = UIButton(type: .custom)
    var modeScrollerView = UIView()
    
    
    fileprivate let sizeForModeButton = CGSize(width: 50 / masterRatio, height: 50 / masterRatio)
    fileprivate let sizeForFilterButton = CGSize(width: 223 / masterRatio, height: 50 / masterRatio)
    fileprivate let distanceFromLeft = 141 / masterRatio
    fileprivate let cornerForButtons = 26 / masterRatio
    fileprivate let modeScrollerSize = CGSize(width: 110 / masterRatio, height: 50 / masterRatio)
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 750 / masterRatio, height: 1134 / masterRatio))
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
        
        // backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.93)
        
        var viewsByName: [String : UIView] = [:]
        let __scaling__ = UIView()
        self.addSubview(__scaling__)
        viewsByName["__scaling__"] = __scaling__
        __scaling__.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        // dismiss action
        __scaling__.addGestureRecognizer(
            UITapGestureRecognizer.init(
                target: self, action: #selector( GROrderItemsView.buttonCancelAction(_:) )
            )
        )
        
        // background wrapping view allows us to set alpha to the blurredEffect View
        // otherwise it's not possible/correct/reliable to set alpha to a uieffectview
        let background = UIView()
        __scaling__.addSubview(background)
        viewsByName["background"] = background
        background.backgroundColor = UIColor.black
        background.alpha = 0.0
        
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        background.addSubview(blurredEffectView)
        blurredEffectView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

        // red panel sliding from top
        let velvetView = UIView()
        __scaling__.addSubview(velvetView)
        velvetView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(450 / masterRatio)
            make.top.equalTo(-450 / masterRatio)
            make.left.equalTo(0)
        }
        velvetView.isUserInteractionEnabled = true
        velvetView.backgroundColor = UIColor.grocerestColor()
        // stop taps from bubbling up to __scaling__
        let trap = UITapGestureRecognizer.init(target: self, action: nil)
        trap.cancelsTouchesInView = true
        velvetView.addGestureRecognizer(trap)

        viewsByName["velvetView"] = velvetView
        
        let orderLabel = UILabel()
        velvetView.addSubview(orderLabel)
        orderLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(83 / masterRatio)
        }
        orderLabel.font = Constants.BrandFonts.ubuntuLight18
        orderLabel.textColor = UIColor.white
        orderLabel.textAlignment = .center
        orderLabel.text = "Ordina"      
        
        let confirmImage = UIImageView()
        velvetView.addSubview(confirmImage)
        confirmImage.snp.makeConstraints { (make) in
            make.width.equalTo(38 / masterRatio)
            make.height.equalTo(24 / masterRatio)
            make.centerY.equalTo(orderLabel.snp.centerY)
            make.right.equalTo(-27 / masterRatio)
        }
        
        confirmImage.image = UIImage(named: "confirmOrder")
        confirmImage.contentMode = .scaleAspectFit
        
        viewsByName["confirmImage"] = confirmImage
        
        let confirmButton = UIButton(type: .custom)
        velvetView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.width.equalTo(60 / masterRatio)
            make.height.equalTo(40 / masterRatio)
            make.center.equalTo(confirmImage.snp.center)
        }
        confirmButton.addTarget(self, action: #selector(GROrderItemsView.buttonConfirmAction(_:)), for: .touchUpInside)
        
        
        viewsByName["confirmButton"] = confirmButton
        
        velvetView.addSubview(firstFilterButton)
        firstFilterButton.snp.makeConstraints { (make) in
            make.size.equalTo(sizeForFilterButton)
            make.top.equalTo(orderLabel.snp.bottom).offset(50 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        firstFilterButton.setTitle("CATEGORIE", for: UIControlState())
        firstFilterButton.titleLabel?.font = Constants.BrandFonts.avenirHeavy11
        firstFilterButton.setTitleColor(UIColor.white, for: UIControlState())
        firstFilterButton.layer.borderWidth = 1
        firstFilterButton.layer.borderColor = UIColor.white.cgColor
        firstFilterButton.layer.cornerRadius = cornerForButtons
        firstFilterButton.reversesTitleShadowWhenHighlighted = true
        firstFilterButton.tag = 10
        firstFilterButton.addTarget(self, action: #selector(GROrderItemsView.actionFilterButtonWasPressed(_:)), for: .touchUpInside)
        
        
        velvetView.addSubview(secondFilterButton)
        secondFilterButton.snp.makeConstraints { (make) in
            make.size.equalTo(sizeForFilterButton)
            make.top.equalTo(firstFilterButton.snp.bottom).offset(30 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        secondFilterButton.setTitle("ALFABETICO", for: UIControlState())
        secondFilterButton.titleLabel?.font = Constants.BrandFonts.avenirHeavy11
        secondFilterButton.setTitleColor(UIColor.white, for: UIControlState())
        secondFilterButton.layer.borderWidth = 0
        secondFilterButton.layer.borderColor = UIColor.white.cgColor
        secondFilterButton.layer.cornerRadius = cornerForButtons
        secondFilterButton.tag = 11
        secondFilterButton.addTarget(self, action: #selector(GROrderItemsView.actionFilterButtonWasPressed(_:)), for: .touchUpInside)
        
        
        velvetView.addSubview(thirdFilterButton)
        thirdFilterButton.snp.makeConstraints { (make) in
            make.size.equalTo(sizeForFilterButton)
            make.top.equalTo(secondFilterButton.snp.bottom).offset(30 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        thirdFilterButton.setTitle("INSERIMENTO", for: UIControlState())
        thirdFilterButton.titleLabel?.font = Constants.BrandFonts.avenirHeavy11
        thirdFilterButton.setTitleColor(UIColor.white, for: UIControlState())
        thirdFilterButton.layer.borderWidth = 0
        thirdFilterButton.layer.borderColor = UIColor.white.cgColor
        thirdFilterButton.layer.cornerRadius = cornerForButtons
        thirdFilterButton.tag = 12
        thirdFilterButton.addTarget(self, action: #selector(GROrderItemsView.actionFilterButtonWasPressed(_:)), for: .touchUpInside)
        
        
        velvetView.addSubview(modeScrollerView)
        modeScrollerView.snp.makeConstraints { (make) in
            make.size.equalTo(modeScrollerSize)
            make.left.equalTo(distanceFromLeft)
            make.centerY.equalTo(firstFilterButton.snp.centerY)
        }
        
        modeScrollerView.addSubview(descButton)
        descButton.snp.makeConstraints { (make) in
            make.size.equalTo(sizeForModeButton)
            make.left.equalTo(modeScrollerView.snp.left)
            make.centerY.equalTo(firstFilterButton.snp.centerY)
        }
        descButton.setImage(UIImage(named: "desc_arrow"), for: UIControlState())
        descButton.setBackgroundImage(UIImage(named: "circle_mode_order"), for: UIControlState())
        descButton.tag = 0
        descButton.adjustsImageWhenHighlighted = true
        descButton.addTarget(self, action: #selector(GROrderItemsView.actionSetModeFilterWasPressed(_:)), for: .touchUpInside)
        
        modeScrollerView.addSubview(ascButton)
        ascButton.snp.makeConstraints { (make) in
            make.size.equalTo(sizeForModeButton)
            make.left.equalTo(descButton.snp.right).offset(10 / masterRatio)
            make.centerY.equalTo(firstFilterButton.snp.centerY)
        }
        ascButton.setImage(UIImage(named: "up_arrow"), for: UIControlState())
        ascButton.tag = 1
        ascButton.adjustsImageWhenHighlighted = true
        ascButton.addTarget(self, action: #selector(GROrderItemsView.actionSetModeFilterWasPressed(_:)), for: .touchUpInside)
        
        self.viewsByName = viewsByName
        
    }
    
    func buttonConfirmAction(_ sender:UIButton) {
        delegate.confirmAction(sender)
    }
    
    func buttonCancelAction(_ sender:UIButton) {
        delegate.cancelAction(sender)
    }
    
    func moveBackGroundImagetoSender(_ value:Int) {
        
        switch value {
        case 0:
            ascButton.setBackgroundImage(nil, for: UIControlState())
            descButton.setBackgroundImage(UIImage(named: "circle_mode_order"), for: UIControlState())
            return
        case 1:
            descButton.setBackgroundImage(nil, for: UIControlState())
            ascButton.setBackgroundImage(UIImage(named: "circle_mode_order"), for: UIControlState())
            return
        default:
            return
            
        }
        
    }
    
    func actionSetModeFilterWasPressed(_ sender:UIButton) {
        delegate.setModeFilterWasPressed(sender)
    }
    
    
    func actionFilterButtonWasPressed(_ sender:UIButton) {
        delegate.filterButtonWasPressed(sender)
        
    }
    
    func moveModeSelectionButtonsToFilter(_ value:Int) {
        modeScrollerView.layoutIfNeeded()
        switch value {
        case 10:
            
            UIView.animate(withDuration: 2.5, delay: 0, options: .transitionFlipFromTop, animations: {
                self.firstFilterButton.layer.borderWidth = 1
                self.secondFilterButton.layer.borderWidth = 0
                self.thirdFilterButton.layer.borderWidth = 0
                
                self.modeScrollerView.snp.remakeConstraints { (make) in
                    make.size.equalTo(self.modeScrollerSize)
                    make.left.equalTo(self.distanceFromLeft)
                    make.centerY.equalTo(self.firstFilterButton.snp.centerY)
                }
                
                self.descButton.snp.remakeConstraints { (make) in
                    make.size.equalTo(self.sizeForModeButton)
                    make.left.equalTo(self.modeScrollerView.snp.left)
                    make.centerY.equalTo(self.firstFilterButton.snp.centerY)
                }
                
                self.ascButton.snp.remakeConstraints { (make) in
                    make.size.equalTo(self.sizeForModeButton)
                    make.left.equalTo(self.descButton.snp.right).offset(10 / masterRatio)
                    make.centerY.equalTo(self.firstFilterButton.snp.centerY)
                }
                }, completion: nil)
            
            return
        case 11:
            UIView.animate(withDuration: 2.5, delay: 0, options:  .transitionFlipFromTop, animations: {
                self.firstFilterButton.layer.borderWidth = 0
                self.secondFilterButton.layer.borderWidth = 1
                self.thirdFilterButton.layer.borderWidth = 0
                
               self.modeScrollerView.snp.remakeConstraints { (make) in
                    make.size.equalTo(self.modeScrollerSize)
                    make.left.equalTo(self.distanceFromLeft)
                    make.centerY.equalTo(self.secondFilterButton.snp.centerY)
                }
                
                self.descButton.snp.remakeConstraints { (make) in
                    make.size.equalTo(self.sizeForModeButton)
                    make.left.equalTo(self.modeScrollerView.snp.left)
                    make.centerY.equalTo(self.secondFilterButton.snp.centerY)
                }
                
                self.ascButton.snp.remakeConstraints { (make) in
                    make.size.equalTo(self.sizeForModeButton)
                    make.left.equalTo(self.descButton.snp.right).offset(10 / masterRatio)
                    make.centerY.equalTo(self.secondFilterButton.snp.centerY)
                }

                }, completion: nil)

            
            return
        case 12:
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.firstFilterButton.layer.borderWidth = 0
                self.secondFilterButton.layer.borderWidth = 0
                self.thirdFilterButton.layer.borderWidth = 1
                
                self.modeScrollerView.snp.remakeConstraints { (make) in
                    make.size.equalTo(self.modeScrollerSize)
                    make.left.equalTo(self.distanceFromLeft)
                    make.centerY.equalTo(self.thirdFilterButton.snp.centerY)
                }
                
                self.descButton.snp.remakeConstraints { (make) in
                    make.size.equalTo(self.sizeForModeButton)
                    make.left.equalTo(self.modeScrollerView.snp.left)
                    make.centerY.equalTo(self.thirdFilterButton.snp.centerY)
                }
                
                self.ascButton.snp.remakeConstraints { (make) in
                    make.size.equalTo(self.sizeForModeButton)
                    make.left.equalTo(self.descButton.snp.right).offset(10 / masterRatio)
                    make.centerY.equalTo(self.thirdFilterButton.snp.centerY)
                }

                }, completion: nil)
            return
        default:
            return
            
        }
        
    }
    
    // - MARK: slideDown
    
    
    func startSlideViewAnimation () {
        self.viewsByName["background"]!.alpha = 0.0
            UIView.animate(withDuration: 0.5, delay: 0, options:  .curveEaseOut, animations: {
                self.viewsByName["background"]!.alpha = 0.7
                self.viewsByName["velvetView"]!.transform = CGAffineTransform(translationX: 0, y: 450 / masterRatio)
            }, completion: nil)
        
        
    }
    
    func removeSlideViewAnimation () {
        UIView.animate(withDuration: 0.5, delay: 0, options:  .curveLinear, animations: {
            self.viewsByName["background"]!.alpha = 0.0
            self.viewsByName["velvetView"]!.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    
    
    
}


