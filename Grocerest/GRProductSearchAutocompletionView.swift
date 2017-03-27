//
//  GRProductSearchAutocompletionView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 21/12/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

@IBDesignable
class GRProductSearchAutocompletionView: UIView {
    
    var typedQuery: String = "" {
        didSet {
            typedQueryButton.setTitle(typedQuery, for: .normal)
        }
    }
    
    var suggestedQueries: [String] = [] {
        didSet {
            for subview in suggestedQueriesStack.arrangedSubviews {
                subview.removeFromSuperview()
                suggestedQueriesStack.removeArrangedSubview(subview)
            }
            
            for query in suggestedQueries {
                let button = UIButton(type: .custom)
                button.setTitle(query, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = .avenirRoman(30)
                button.addTarget(self, action: #selector(self._suggestedQueryTapped(_:)), for: .touchUpInside)
                suggestedQueriesStack.addArrangedSubview(button)
            }
        }
    }
    
    var onTypedQueryTap,
        onSuggestedQueryTap: ((_ suggestedQuery: String) -> Void)?
    
    private let typedQueryButton = UIButton(type: .custom)
    private let suggestedQueriesStack = UIStackView()
    
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
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        
        typedQueryButton.setTitleColor(.white, for: .normal)
        typedQueryButton.titleLabel?.font = .avenirRoman(30)
        typedQueryButton.addTarget(self, action: #selector(self._typedQueryTapped(_:)), for: .touchUpInside)
        addSubview(typedQueryButton)
        typedQueryButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(33 / masterRatio)
            make.left.equalTo(self).offset(53 / masterRatio)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "Ricerche suggerite"
        titleLabel.textColor = UIColor(hexString: "979797")
        titleLabel.font = .avenirBook(22)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(typedQueryButton.snp.bottom).offset(13 / masterRatio)
            make.left.equalTo(self).offset(33 / masterRatio)
        }
        
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        addSubview(scrollView)
        scrollView.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(13 / masterRatio)
            make.left.equalTo(self).offset(64 / masterRatio)
            make.right.bottom.equalTo(self)
        }
        
        suggestedQueriesStack.axis = .vertical
        suggestedQueriesStack.alignment = .leading
        scrollView.addSubview(suggestedQueriesStack)
        suggestedQueriesStack.snp_makeConstraints { make in
            make.edges.equalTo(scrollView)
        }
    }
    
    func _typedQueryTapped(_ button: UIButton) {
        onTypedQueryTap?(typedQuery)
    }
    
    func _suggestedQueryTapped(_ button: UIButton) {
        onSuggestedQueryTap?(button.titleLabel!.text!)
    }
    
}
