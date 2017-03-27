//
//  GRCategoryListView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 01/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import UIKit
import SnapKit



@IBDesignable
class GRCategoryListView: UIView {
    
    var viewsByName: [String: UIView]!
    var addAllButton = UIButton()
    var selectedCategoriesButton = UIButton()
    var footerView = UIView()
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
    
    var delegate: GRCategoryListProtocol?
    
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
            scalingView.center = CGPoint(x:self.bounds.midX, y: self.bounds.midY)
        }
    }
    
    
    func setupHierarchy() {
        
        var viewsByName: [String: UIView] = [:]
        let __scaling__ = UIView()
        __scaling__.backgroundColor = UIColor.white
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        
        let statusBarBackground = UIView()
        __scaling__.addSubview(statusBarBackground)
        statusBarBackground.backgroundColor = UIColor.grocerestColor()
        statusBarBackground.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.left.top.equalTo(0)
            make.height.equalTo(20)
        }
        viewsByName["statusBarBackground"] = statusBarBackground
        
        let headerView = UIView()
        __scaling__.addSubview(headerView)
        headerView.backgroundColor = UIColor.F1F1F1Color()
        headerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.left.equalTo(0)
            make.top.equalTo(20)
            make.height.equalTo(62.425)
        }
        
        viewsByName["headerView"] = headerView
        
        let actionLabel = UILabel()
        headerView.addSubview(actionLabel)
        actionLabel.text = Constants.AppLabels.selectFavoriteCategories
        actionLabel.font = Constants.BrandFonts.avenirRoman13
        actionLabel.textColor = UIColor.grocerestDarkGrayText()
        actionLabel.textAlignment = .center
        actionLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(39)
            make.centerY.equalTo(headerView.snp.centerY)
            make.height.equalTo(20)
        }
        
        viewsByName["actionLabel"] = actionLabel
        
        addAllButton = UIButton(type: .custom)
        headerView.addSubview(addAllButton)
        addAllButton.contentMode = .scaleAspectFit
        addAllButton.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(-13.5)
            make.centerY.equalTo(headerView.snp.centerY)
            make.width.equalTo(68.5)
        }
        addAllButton.setTitle("tutte", for: UIControlState())
        addAllButton.titleLabel?.font = Constants.BrandFonts.avenirHeavy15
        addAllButton.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        addAllButton.titleLabel?.textAlignment = .center
        addAllButton.addTarget(self, action: #selector(GRCategoryListView.actionAddAllButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["addAllButton"] = addAllButton
        
    
        
        footerView = UIView()
        __scaling__.addSubview(footerView)
        footerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.bottom.left.equalTo(0)
            make.height.equalTo(120 / masterRatio)
        }
        footerView.backgroundColor = UIColor.grocerestBlue()
        
        
        
        selectedCategoriesButton = UIButton(type: .custom)
        __scaling__.addSubview(selectedCategoriesButton)
        selectedCategoriesButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(footerView.snp.centerX)
            make.centerY.equalTo(footerView.snp.centerY)
            make.width.equalTo(self)
            make.height.equalTo(80 / masterRatio)
        }
        selectedCategoriesButton.titleLabel!.font = Constants.BrandFonts.avenirBookFont
        selectedCategoriesButton.setTitleColor(UIColor.white, for: UIControlState())
        selectedCategoriesButton.titleLabel!.textAlignment = .center
        
        selectedCategoriesButton.addTarget(self, action: #selector(GRCategoryListView.actionSelectedButtonWasPressed(_:)), for: .touchUpInside)
        viewsByName["selectedCategoriesButton"] = selectedCategoriesButton
        
        viewsByName["footerView"] = footerView
        
  
        
        self.viewsByName = viewsByName
    }
    
    func actionSelectedButtonWasPressed(_ sender: UIButton) {
        delegate?.selectButtonWasPressed(sender)

    }
    
    func actionAddAllButtonWasPressed(_ sender: UIButton) {
        delegate?.addAllButtonWasPressed(sender)
    }
    
    func setButtonStatusLabelTitle(_ title: String) {
        addAllButton.setTitle(title, for: UIControlState())
    }
    
}
