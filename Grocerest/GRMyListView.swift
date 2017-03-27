//
//  GRMyListView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 14/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRMyListView: UIView, UIToolbarDelegate, GRToolBarProtocol{
    
    var viewsByName: [String: UIView]!
    var delegate : GRToolBarProtocol?
    var newListView : UIView?
    var navigationToolBar : GRToolbar?
    
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
        
        navigationToolBar = GRToolbar()
        navigationToolBar!.delegate = self
        navigationToolBar!.isThisBarWithTitle(true, title:Constants.AppLabels.ToolBarLabels.myLists)
        self.addSubview(navigationToolBar!)
        navigationToolBar!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.left.equalTo(0)
        }
        
        
        newListView = UIView()
        __scaling__.addSubview(newListView!)
        newListView!.backgroundColor = UIColor.white
        newListView!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(146/masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(navigationToolBar!.snp.bottom)
        }
        
        let separator = UIView()
        __scaling__.addSubview(separator)
        separator.backgroundColor = UIColor.lightGray
        separator.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(0.5)
            make.top.equalTo((newListView?.snp.bottom)!).offset(-1)
            make.left.equalTo(0)
        }
        
        let newListIcon = UIImageView()
        newListView!.addSubview(newListIcon)
        newListIcon.image = UIImage(named: "nuova_lista")
        newListIcon.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.listIconSize)
            make.left.equalTo(newListView!.snp.left).offset(40 / masterRatio)
            make.centerY.equalTo(newListView!)
        }
        
        let newlistLabel = UILabel()
        newListView!.addSubview(newlistLabel)
        newlistLabel.text = Constants.AppLabels.ListLabels.createnNewList
        newlistLabel.textColor = UIColor.grocerestDarkGrayText()
        newlistLabel.font = Constants.BrandFonts.avenirRoman13
        newlistLabel.textAlignment = .left
        newlistLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(newListIcon.snp.right).offset(28 / masterRatio)
            make.centerY.equalTo(newListView!)
        }
        
        let newlistButton = UIButton()
        newListView!.addSubview(newlistButton)
        newlistButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(newListView!)
        }
        newlistButton.addTarget(self, action: #selector(GRMyListView.actionNewListButtonWasPressed(_:)), for: .touchUpInside)
        
        
        viewsByName["newListView"] = newListView
        
        self.viewsByName = viewsByName

    }
    
    
    
    // MARK: delegation
    

    
    func menuButtonWasPressed(_ sender: UIButton){
        delegate?.menuButtonWasPressed!(sender)
    }
    
    func grocerestButtonWasPressed(_ sender: UIButton){
        delegate?.grocerestButtonWasPressed!(sender)
        
    }
    
    func scannerButtonWasPressed(_ sender: UIButton){
        delegate?.scannerButtonWasPressed!(sender)
    }
    
    func searchButtonWasPressed(_ sender: UIButton){
        delegate?.searchButtonWasPressed!(sender)
    }
    
    /// new list button
    
    func actionNewListButtonWasPressed(_ sender:UIButton) {
        
        delegate?.newlistButtonWasPressed!(sender)
    }
    
}

