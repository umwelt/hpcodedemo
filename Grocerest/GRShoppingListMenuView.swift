//
//  GRShoppingListMenuView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

class GRShoppingListMenuView: UIView {
    
    weak var delegate = GRShoppingListMenuViewController()
    var backView = UIView()
    
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }
    
    convenience init(owner: Bool) {
        self.init()
        self.setupHierarchy()
    }
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupHierarchy() {
        addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
    }
}
