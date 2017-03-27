//
//  GRBrandsListView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 02/02/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation

class GRBrandsListView: UIView {

    let toolbar = GRToolbar()
    let resultsView = GRBrandsSearchResultsView()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor(hexString: "F1F1F1")
        
        toolbar.isThisBarWithTitle(true, title: "Brand")
        addSubview(toolbar)
        toolbar.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.left.equalTo(0)
        }
        
        resultsView.topMode = true
        resultsView.isRankHidden = false
        resultsView.backgroundColor = .clear
        addSubview(resultsView)
        resultsView.snp.makeConstraints { make in
            make.top.equalTo(toolbar.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
    }
    
}
