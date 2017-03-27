//
//  UIView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 12/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

extension UIView {
    func withPadding(_ padding: UIEdgeInsets) -> UIView {
        let container = UIView()
        container.addSubview(self)
        snp.makeConstraints { make in
            make.edges.equalTo(container).inset(padding)
        }
        return container
    }
}
