//
//  GRUsersView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 18/10/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SnapKit

class GRUsersView: UIView {
    var viewsByName: [String: UIView]!
    var navigationToolBar : GRToolbar?
    
    fileprivate let usersStackView = UIStackView()
    
    var users = [GRUserView]() {
        didSet {
            for view in usersStackView.arrangedSubviews {
                usersStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            for user in users {
                usersStackView.addArrangedSubview(user)
                
                // Separator view
                let separator = UIView()
                usersStackView.addArrangedSubview(separator)
                separator.backgroundColor = UIColor(hexString: "E4E4E4")
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.snp.makeConstraints { make in
                    make.height.equalTo(1 / masterRatio)
                    make.width.equalTo(user)
                }
                
                let whitePortion = UIView()
                whitePortion.backgroundColor = UIColor.white
                separator.addSubview(whitePortion)
                whitePortion.translatesAutoresizingMaskIntoConstraints = false
                whitePortion.snp.makeConstraints { make in
                    make.left.top.equalTo(separator)
                    make.height.equalTo(separator)
                    make.width.equalTo(40 / masterRatio)
                }
            }
        }
    }
    
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
    weak var delegate = GRUsersViewController()
    
    // - MARK: Scaling
    
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
        var viewsByName: [String : UIView] = [:]
        let __scaling__ = UIView()
        
        __scaling__.backgroundColor = UIColor.F1F1F1Color()
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__
        
        
        navigationToolBar = GRToolbar()
        navigationToolBar!.isThisBarWithTitle(true, title:Constants.AppLabels.ToolBarLabels.myLists)
        self.addSubview(navigationToolBar!)
        navigationToolBar!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(140 / masterRatio)
            make.top.left.equalTo(0)
        }
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(hexString: "979797")
        titleLabel.font = UIFont.avenirBook(22)
        titleLabel.text = "Top 20 della settimana"
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationToolBar!.snp.bottom).offset(18 / masterRatio)
            make.left.equalTo(self).offset(34 / masterRatio)
        }

        
        let scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18 / masterRatio)
            make.left.bottom.right.equalTo(self)
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        // This is the important part
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(self)
        }
        
        usersStackView.axis = .vertical
        scrollView.addSubview(usersStackView)
        usersStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.bottom.equalTo(contentView)
        }
        
        self.viewsByName = viewsByName
    }
    
    override func prepareForInterfaceBuilder() {
        var fakeUsers = [GRUserView]()
        for _ in 1...20 {
            let user = GRUserView()
            user.prepareForInterfaceBuilder()
            fakeUsers.append(user)
        }
        users = fakeUsers
    }
    
}
