//
//  GRProductSearchPlaceholder.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 21/12/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

/// Shown in ProductSearch's bottom view when the user hasn't yet started a search
class GRProductSearchPlaceholder: UIView {
    
    // Used by running iOS app
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    // Used by Inteface Builder
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    private func initialization() {
        let arrow = UIImageView()
        arrow.contentMode = .scaleAspectFit
        arrow.image = UIImage(named: "empty_list")
        addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.top.equalTo(self).offset(90 / masterRatio)
            make.centerX.equalTo(self)
        }
        
        let title = UILabel()
        title.text = "Inizia la ricerca"
        title.font = .ubuntuMedium(32)
        title.textColor = UIColor(hexString: "4A4A4A")
        title.textAlignment = .center
        addSubview(title)
        title.snp.makeConstraints{ make in
            make.top.equalTo(arrow.snp.bottom).offset(30 / masterRatio)
            make.centerX.equalTo(arrow)
        }
        
        let subTitle = UILabel()
        subTitle.text = "digita una o più parole"
        subTitle.font = .avenirBook(30)
        subTitle.textColor = UIColor(hexString: "9B9B9B")
        subTitle.textAlignment = .center
        addSubview(subTitle)
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8 / masterRatio)
            make.centerX.equalTo(arrow)
        }
    }
    
}
