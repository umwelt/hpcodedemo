//
//  GRLoadingTopListView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 06/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRLoadingTopListView: UIView {
    
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
    
    var delegate : GRToolBarProtocol?
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func createTopListItemView() -> UIView {
        let toplistViewOne = UIView()
        toplistViewOne.layer.cornerRadius = 5
        toplistViewOne.backgroundColor = UIColor.white
        toplistViewOne.snp.makeConstraints { make in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(155 / masterRatio)
        }
        
        let topOneListIcon = UIView()
        toplistViewOne.addSubview(topOneListIcon)
        topOneListIcon.backgroundColor = UIColor.F1F1F1Color()
        
        topOneListIcon.snp.makeConstraints { make in
            make.width.height.equalTo(86 / masterRatio)
            make.left.equalTo(toplistViewOne.snp.left).offset(40 / masterRatio)
            make.top.equalTo(toplistViewOne.snp.top).offset(35 / masterRatio)
        }
        topOneListIcon.layer.masksToBounds = false
        topOneListIcon.layer.cornerRadius = 43 / masterRatio
        topOneListIcon.clipsToBounds = true
        
        let topOneLabel = UIView()
        toplistViewOne.addSubview(topOneLabel)
        topOneLabel.backgroundColor = UIColor.F1F1F1Color()
        topOneLabel.snp.makeConstraints { make in
            make.left.equalTo(topOneListIcon.snp.right).offset(28 / masterRatio)
            make.top.equalTo(toplistViewOne.snp.top).offset(44 / masterRatio)
            make.width.equalTo(260 / masterRatio)
            make.height.equalTo(30 / masterRatio)
        }
        
        let topOneElementsLabel = UIView()
        toplistViewOne.addSubview(topOneElementsLabel)
        topOneElementsLabel.backgroundColor = UIColor.F1F1F1Color()
        topOneElementsLabel.snp.makeConstraints { make in
            make.left.equalTo(topOneListIcon.snp.right).offset(28 / masterRatio)
            make.top.equalTo(topOneLabel.snp.bottom).offset(8 / masterRatio)
            make.width.equalTo(160 / masterRatio)
            make.height.equalTo(20 / masterRatio)
        }
        
        return toplistViewOne
    }
    
    func setupHierarchy() {
        let itemOne = createTopListItemView()
        self.addSubview(itemOne)
        itemOne.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(16 / masterRatio)
        }
        
        let itemTwo = createTopListItemView()
        self.addSubview(itemTwo)
        itemTwo.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(itemOne.snp.bottom).offset(16 / masterRatio)
        }
    }
}
