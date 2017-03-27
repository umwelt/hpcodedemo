//
//  GRPredefinedListView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 19/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit
import SnapKit



@IBDesignable
class GRPredefinedListView: UIView {
    
    
    
    
    var viewsByName: [String: UIView]!
    var navigationToolBar : GRToolbar?
    var productsCountLabel : UILabel?
    
    var labelView : UIView = {
        let view = UIView()
        
        return view
    }()
    
    
    var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.bounces = true
        table.backgroundColor = UIColor.F1F1F1Color()
        table.register(GRProductsResultTableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        table.keyboardDismissMode = .onDrag
        table.rowHeight = (332+20) / masterRatio
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.showsVerticalScrollIndicator = false
        
        
        return table
    }()
    
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
    
    // TODO protect here
    weak var delegate = GRPredefinedListViewController()
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    func setupHierarchy() {
        
        backgroundColor = UIColor(hexString: "#F1F1F1")
        
        navigationToolBar = GRToolbar()
        navigationToolBar!.isThisBarWithTitle(true, title:Constants.AppLabels.ToolBarLabels.myLists)
        self.addSubview(navigationToolBar!)
        navigationToolBar!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.left.equalTo(0)
        }
        
        
        
        labelView.frame = CGRect(x: 10, y: 0, width: 486 / masterRatio, height: 60 / masterRatio)
        
        productsCountLabel = UILabel()
        //addSubview(productsCountLabel!)
        
        labelView.addSubview(productsCountLabel!)
        productsCountLabel!.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(20 / masterRatio)
            make.width.equalTo(400 / masterRatio)
            make.height.equalTo(40 / masterRatio)
            make.left.equalTo(30 / masterRatio)
        }
        productsCountLabel!.textColor = UIColor.grocerestLightGrayColor()
        productsCountLabel!.font = Constants.BrandFonts.avenirBook11
        productsCountLabel!.textAlignment = .left
        
       
        
        addSubview(tableView)
        tableView.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(self.snp.width)
            make.top.equalTo(navigationToolBar!.snp.bottom)
            make.left.equalTo(0)
            make.bottom.equalTo(-10)
            // set dinamic height > 3 elements from datasource
          //  make.height.equalTo(1100 / masterRatio)
        })
  
    
        
        
    }
}
