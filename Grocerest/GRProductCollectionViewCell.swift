//
//  GRProductCollectionViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 05/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit
import SnapKit




@IBDesignable
class GRProductCollectionViewCell: UICollectionViewCell {
    
    
    var categoryImageView : UIImageView?
    var mainLabel : UILabel?
    var counterLabel : UILabel?
    
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
    weak var delegate = GRProductsViewController()
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

    }
    
    func setupHierarchy() {
        
        self.layer.borderWidth = 0.2


        categoryImageView = UIImageView()
        addSubview(categoryImageView!)
        categoryImageView?.snp.makeConstraints({ (make) -> Void in
            make.width.height.equalTo(218 / masterRatio)
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(72 / masterRatio)
        })
        categoryImageView?.contentMode = .scaleAspectFit
        
        
        mainLabel = UILabel()
        addSubview(mainLabel!)
        mainLabel!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(40 / masterRatio)
            make.top.equalTo((categoryImageView?.snp.bottom)!).offset(40 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        mainLabel?.textAlignment = .center
        mainLabel?.font = Constants.BrandFonts.ubuntuMedium16
        mainLabel?.textColor = UIColor.grocerestDarkBoldGray()
        
        
        counterLabel = UILabel()
        contentView.addSubview(counterLabel!)
        counterLabel!.snp.makeConstraints { (make) -> Void in
            //make.width.equalTo(90 / masterRatio)
            make.height.equalTo(36 / masterRatio)
            make.top.equalTo((mainLabel?.snp.bottom)!).offset(15 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        counterLabel?.textColor = UIColor.white
        counterLabel?.font = Constants.BrandFonts.avenirMedium11

        
        
        
        
    }
}
