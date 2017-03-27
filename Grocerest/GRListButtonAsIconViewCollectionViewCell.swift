//
//  GRListButtonAsIconViewCollectionViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 08/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit
import SnapKit


@IBDesignable
class GRListButtonAsIconViewCollectionViewCell: UICollectionViewCell {
    var iconImageView : UIImageView?
    var listLabel: UILabel?
    
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
    weak var delegate = GRWelcomeViewController()
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    func setupHierarchy() {

        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }

        iconImageView = UIImageView()
        contentView.addSubview(iconImageView!)
        iconImageView!.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(98 / masterRatio)
            make.top.equalTo(0)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        iconImageView!.contentMode = .scaleAspectFit
        
        listLabel = UILabel()
        contentView.addSubview(listLabel!)
        listLabel!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(contentView.snp.width)
            make.top.equalTo((iconImageView?.snp.bottom)!).offset(26 / masterRatio)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        listLabel?.numberOfLines = 2
        listLabel?.font = Constants.BrandFonts.avenirBook12
        listLabel?.textColor = UIColor.lightGrayTextcolor()
        listLabel?.textAlignment = .center

        
        
        
    }
}
