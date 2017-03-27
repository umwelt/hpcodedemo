//
//  GRTutorialView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 24/03/16.
//  Copyright © 2016 grocerest. All rights reserved.
//


import Foundation
import UIKit

@IBDesignable
class GRTutorialView: UIView {
    var zoomedImageView = UIImageView()
    var delegate = GRTutorialViewController()
    var backView = UIScrollView()
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    
    var page_1 = UIView()
    var page_2 = UIView()
    var page_3 = UIView()
    var page_4 = UIView()
    var page_5 = UIView()
    var page_6 = UIView()
    var page_7 = UIView()
    var page_8 = UIView()
    
    var complimentLabel = UILabel()
    
    var navImageSize = CGSize(width: 27 / masterRatio, height: 53 / masterRatio)
    
    
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
        
        let image_0 = coverImage("base_prod")
        addSubview(image_0)
        image_0.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        
        addSubview(backView)
        backView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        backView.contentSize = CGSize(width: UIScreen.main.bounds.width * 8, height: UIScreen.main.bounds.height)
        
        
        backView.addSubview(page_1)
        page_1.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
            make.left.equalTo(backView.snp.left)
            make.top.equalTo(0)
        }
        
        let image_1 = coverImage("base")
        page_1.addSubview(image_1)
        image_1.snp.makeConstraints { (make) in
            make.edges.equalTo(page_1)
        }
        
        
        let iconView = UIImageView()
        page_1.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.width.equalTo(237 / masterRatio)
            make.height.equalTo(206 / masterRatio)
            make.centerX.equalTo(page_1.snp.centerX)
            make.top.equalTo(344 / masterRatio)
        }
        iconView.contentMode = .scaleAspectFit
        iconView.image = UIImage(named: "tutorialIcon")
        
        complimentLabel = UILabel()
        page_1.addSubview(complimentLabel)
        complimentLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(page_1.snp.centerX)
            make.top.equalTo(iconView.snp.bottom).offset(36 / masterRatio)
        }
        complimentLabel.font = Constants.BrandFonts.avenirLight20
        complimentLabel.textColor = UIColor.grocerestBlue()
        complimentLabel.textAlignment = .center
        
        let pionerLabel = UILabel()
        page_1.addSubview(pionerLabel)
        pionerLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(page_1.snp.centerX)
            make.top.equalTo(complimentLabel.snp.bottom).offset(19 / masterRatio)
        }
        pionerLabel.text = "DA OGGI SEI UN PIONIERE \n DI GROCEREST"
        pionerLabel.font = Constants.BrandFonts.avenirLight13
        pionerLabel.textColor = UIColor.white
        pionerLabel.textAlignment = .center
        pionerLabel.numberOfLines = 2
        
        let button_1 = buttonSkip()
        page_1.addSubview(button_1)
        button_1.snp.makeConstraints { (make) in
            make.width.equalTo(230 / masterRatio)
            make.height.equalTo(53 / masterRatio)
            make.centerX.equalTo(page_1.snp.centerX)
            make.bottom.equalTo(page_1.snp.bottom).offset(-53 / masterRatio)
        }
        
        
        
        
        backView.addSubview(page_2)
        page_2.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
            make.left.equalTo(page_1.snp.right)
            make.top.equalTo(0)
        }
        
        let image_2 = coverImage("page_2")
        page_2.addSubview(image_2)
        image_2.snp.makeConstraints { (make) in
            make.edges.equalTo(page_2)
        }
        
        
        let button_2 = buttonSkip()
        page_2.addSubview(button_2)
        button_2.snp.makeConstraints { (make) in
            make.width.equalTo(230 / masterRatio)
            make.height.equalTo(53 / masterRatio)
            make.centerX.equalTo(page_2.snp.centerX)
            make.bottom.equalTo(page_2.snp.bottom).offset(-53 / masterRatio)
        }
        
        
        backView.addSubview(page_3)
        page_3.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
            make.left.equalTo(page_2.snp.right)
            make.top.equalTo(0)
        }
        
        let image_3 = coverImage("page_3")
        page_3.addSubview(image_3)
        image_3.snp.makeConstraints { (make) in
            make.edges.equalTo(page_3)
        }
        
        
        let button_3 = buttonSkip()
        page_3.addSubview(button_3)
        button_3.snp.makeConstraints { (make) in
            make.width.equalTo(230 / masterRatio)
            make.height.equalTo(53 / masterRatio)
            make.centerX.equalTo(page_3.snp.centerX)
            make.bottom.equalTo(page_3.snp.bottom).offset(-53 / masterRatio)
        }
        
        
        
        backView.addSubview(page_4)
        page_4.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
            make.left.equalTo(page_3.snp.right)
            make.top.equalTo(0)
        }
        
        let image_4 = coverImage("page_4")
        page_4.addSubview(image_4)
        image_4.snp.makeConstraints { (make) in
            make.edges.equalTo(page_4)
        }
        
        let button_4 = buttonSkip()
        page_4.addSubview(button_4)
        button_4.snp.makeConstraints { (make) in
            make.width.equalTo(230 / masterRatio)
            make.height.equalTo(53 / masterRatio)
            make.centerX.equalTo(page_4.snp.centerX)
            make.bottom.equalTo(page_4.snp.bottom).offset(-53 / masterRatio)
        }
        
        
        backView.addSubview(page_5)
        page_5.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
            make.left.equalTo(page_4.snp.right)
            make.top.equalTo(0)
        }
        
        let image_5 = coverImage("page_5")
        page_5.addSubview(image_5)
        image_5.snp.makeConstraints { (make) in
            make.edges.equalTo(page_5)
        }
        
        let button_5 = buttonSkip()
        page_5.addSubview(button_5)
        button_5.snp.makeConstraints { (make) in
            make.width.equalTo(230 / masterRatio)
            make.height.equalTo(53 / masterRatio)
            make.centerX.equalTo(page_5.snp.centerX)
            make.bottom.equalTo(page_5.snp.bottom).offset(-53 / masterRatio)
        }
        
        
        backView.addSubview(page_6)
        page_6.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
            make.left.equalTo(page_5.snp.right)
            make.top.equalTo(0)
        }
        
        let image_6 = coverImage("page_6")
        page_6.addSubview(image_6)
        image_6.snp.makeConstraints { (make) in
            make.edges.equalTo(page_6)
        }
        
        let button_6 = buttonSkip()
        page_6.addSubview(button_6)
        button_6.snp.makeConstraints { (make) in
            make.width.equalTo(230 / masterRatio)
            make.height.equalTo(53 / masterRatio)
            make.centerX.equalTo(page_6.snp.centerX)
            make.bottom.equalTo(page_6.snp.bottom).offset(-53 / masterRatio)
        }
        
        
        backView.addSubview(page_7)
        page_7.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
            make.left.equalTo(page_6.snp.right)
            make.top.equalTo(0)
        }
        
        let image_7 = coverImage("page_7")
        page_7.addSubview(image_7)
        image_7.snp.makeConstraints { (make) in
            make.edges.equalTo(page_7)
        }
        
        let button_7 = buttonSkip()
        page_7.addSubview(button_7)
        button_7.snp.makeConstraints { (make) in
            make.width.equalTo(230 / masterRatio)
            make.height.equalTo(53 / masterRatio)
            make.centerX.equalTo(page_7.snp.centerX)
            make.bottom.equalTo(page_7.snp.bottom).offset(-53 / masterRatio)
        }
        
        
        backView.addSubview(page_8)
        page_8.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
            make.left.equalTo(page_7.snp.right)
            make.top.equalTo(0)
        }
        
        let image_8 = coverImage("page_8")
        page_8.addSubview(image_8)
        image_8.snp.makeConstraints { (make) in
            make.edges.equalTo(page_8)
        }
        
        
        
        let startButton = UIButton(type:.custom)
        page_8.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.width.equalTo(258 / masterRatio)
            make.height.equalTo(103 / masterRatio)
            make.centerX.equalTo(page_8.snp.centerX)
            make.top.equalTo(942 / masterRatio)
        }
        startButton.layer.borderWidth = 2
        startButton.layer.cornerRadius = 10 / masterRatio
        startButton.layer.borderColor = UIColor.grocerestBlue().cgColor
        startButton.setTitle("INIZIA", for: UIControlState())
        startButton.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        startButton.addTarget(self, action: #selector(GRTutorialView.actionSkipButtonWasPressed(_:)), for: .touchUpInside)
        
        
        // Next page buttons
        addNextButtonToView(page_1, page: 1, visible: true)
        addNextButtonToView(page_2, page: 2)
        addNextButtonToView(page_3, page: 3)
        addNextButtonToView(page_4, page: 4)
        addNextButtonToView(page_5, page: 5)
        addNextButtonToView(page_6, page: 6)
        addNextButtonToView(page_7, page: 7)
        
        // Previous page buttons
        addPreviousButtonToView(page_2, page: 0)
        addPreviousButtonToView(page_3, page: 1)
        addPreviousButtonToView(page_4, page: 2)
        addPreviousButtonToView(page_5, page: 3)
        addPreviousButtonToView(page_6, page: 4)
        addPreviousButtonToView(page_7, page: 5)
        addPreviousButtonToView(page_8, page: 6)
    }
    
    
    func buttonSkip() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("SKIP TUTORIAL", for: UIControlState())
        button.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        button.titleLabel?.font = Constants.BrandFonts.avenirHeavy12
        button.addTarget(self, action: #selector(GRTutorialView.actionSkipButtonWasPressed(_:)), for: .touchUpInside)
        
        return button
    }
    
    func navigationImage(_ direction:String) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: direction)
        
        return imageView
    }
    
    func coverImage(_ imageBack:String) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: imageBack)
        
        return imageView
        
    }
    
    func navButtonWasPressed(_ sender: UIButton) {
        print("Premuto il bottone per andare a pagina \(sender.tag)!!!")
        scrollToPage(sender.tag)
    }
    
    func actionSkipButtonWasPressed(_ sender:UIButton) {
        delegate.skipButtonWasPressed(sender)
    }

    func scrollToPage(_ page: Int) {
        var frame: CGRect = backView.frame
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        backView.scrollRectToVisible(frame, animated: true)
    }
    
    fileprivate class CustomButtonWithExtendedTouchArea : UIButton {
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let relativeFrame = self.bounds
            let hitTestEdgeInsets = UIEdgeInsetsMake(-60 / masterRatio, -60 / masterRatio, -60 / masterRatio, -60 / masterRatio)
            let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
            return hitFrame.contains(point)
        }
    }
    
    func addNextButtonToView(_ view: UIView, page: Int, visible: Bool = false) {
        let button = CustomButtonWithExtendedTouchArea()
        if visible { button.setImage(UIImage(named: "avanti"), for: UIControlState()) }
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerY.equalTo(view.snp.centerY)
            make.size.equalTo(navImageSize)
            make.right.equalTo(-36 / masterRatio)
        }
        button.tag = page // Used to keep track of the page this button will lead to
        button.addTarget(self, action: #selector(GRTutorialView.navButtonWasPressed(_:)), for: .touchUpInside)
    }
    
    func addPreviousButtonToView(_ view: UIView, page: Int, visible: Bool = false) {
        let button = CustomButtonWithExtendedTouchArea()
        if visible { button.setImage(UIImage(named: "indietro"), for: UIControlState()) }
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerY.equalTo(view.snp.centerY)
            make.size.equalTo(navImageSize)
            make.left.equalTo(36 / masterRatio)
        }
        button.tag = page // Used to keep track of the page this button will lead to
        button.addTarget(self, action: #selector(GRTutorialView.navButtonWasPressed(_:)), for: .touchUpInside)
    }
}

