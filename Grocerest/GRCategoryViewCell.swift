//
//  GRCategoryViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 01/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GRCategoryViewCell: UITableViewCell {
    
    var viewsByName: [String: UIView]!
    var categoryLabel : UILabel?
    var iconCellView: UIImageView?
    var selectionCellView: UIImageView?
    var checked = false

    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
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
    
    
    func setupHierarchy() {
        var viewsByName: [String: UIView] = [:]
        let __scaling__ = UIView()
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(0)
            make.width.equalTo(self)
            make.height.equalTo(Constants.UISizes.grocerestStandardHeightCell)
        }
        viewsByName["__scaling__"] = __scaling__
        
        categoryLabel = UILabel()
        categoryLabel!.font = Constants.BrandFonts.avenirBookFont
        categoryLabel!.textColor = UIColor.grocerestLightGrayColor()
        categoryLabel!.textAlignment = .center
        __scaling__.addSubview(categoryLabel!)
        categoryLabel!.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp.left).offset(94.5)
            make.top.equalTo(self.snp.top).offset(31.5)
            make.height.equalTo(19)
            
        }
        viewsByName["categoryLabel"] = categoryLabel
        
        iconCellView = UIImageView()
        iconCellView?.contentMode = .scaleAspectFit
        __scaling__.addSubview(iconCellView!)
        iconCellView?.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(39)
            make.centerY.equalTo(self.snp.centerY)
        })
        viewsByName["iconCellView"] = iconCellView
        
        selectionCellView = UIImageView()
        selectionCellView?.contentMode = .scaleAspectFit
        selectionCellView?.image = UIImage(named: "uncheck")
        __scaling__.addSubview(selectionCellView!)
        selectionCellView?.snp.makeConstraints({ (make) -> Void in
            make.right.equalTo(__scaling__.snp.right).offset(-30.5)
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(32.5)
        })
        
        viewsByName["selectionCellView"] = selectionCellView
        
        self.viewsByName = viewsByName
    }
    
    
    func setChecked(_ checked: Bool, statusImage: String) {
        self.checked = checked
        if (checked) {
            selectionCellView?.image = UIImage(named: statusImage)
            selectionCellView?.setNeedsLayout()
            selectionCellView?.setNeedsDisplay()
        } else {
            selectionCellView?.image = UIImage(named: statusImage)
            selectionCellView?.setNeedsLayout()
            selectionCellView?.setNeedsDisplay()
        }
    }
    
    func updateCellWithCategoryData(_ categoryData: Dictionary<String,String>, originalCell: GRCategoryViewCell) {
        categoryLabel?.text = categoryData["categoryTitle"]
        iconCellView?.image = UIImage(named: categoryData["categoryIcon"]!)
        
        if (checked == true) {
            selectionCellView?.image = UIImage(named: categoryData["selectedIcon"]!)
        } else {
            selectionCellView?.image = UIImage(named: categoryData["selectIcon"]!)
            
            
        }
        
        self.setNeedsDisplay()
    }
    
    func toogleSelection() {
        
        
        if checked ?? false {
            checked = false
        } else {
            checked = true
        }
        


    }
    
    func selectCell() {
        checked = true
    }
    

    func deselect() {
        checked = false
    }
    
    func isChecked() -> Bool {
        if checked == true {
            return true
        }
        return false
    }
    
    func preloadSelectableCells(_ iconName: String) {
        selectionCellView?.image = UIImage(named: iconName)
    }

}
