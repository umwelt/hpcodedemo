//
//  GRUsersSearchView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 24/10/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SnapKit

class GRUsersSearchView: UIView, UITextFieldDelegate {
    
    fileprivate var viewsByName: [String: UIView]!
    fileprivate let searchField = UITextField()
    fileprivate let headerLabel = UILabel()
    fileprivate let usersTable = UITableView()
    
    var onBackButtonTap: (() -> Void)?
    var onSearchFieldReturn: ((_ text: String) -> Void)?
    var usersDatasource: UITableViewDataSource? {
        didSet {
            usersTable.dataSource = usersDatasource
        }
    }
    var numberOfResults: Int? {
        didSet {
            if let results = numberOfResults, results > 0 {
                if results > 1 {
                    headerLabel.text = "\(results) utenti"
                } else {
                    headerLabel.text = "\(results) utente"
                }
            } else {
                headerLabel.text = ""
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
    weak var delegate = GRUsersSearchViewController()
    
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
    
    fileprivate class CustomButtonWithExtendedTouchArea : UIButton {
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let relativeFrame = self.bounds
            let hitTestEdgeInsets = UIEdgeInsetsMake(-10/masterRatio, -10/masterRatio, -10/masterRatio, -10/masterRatio)
            let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
            return hitFrame.contains(point)
        }
    }
    
    func setupHierarchy() {
        var viewsByName: [String : UIView] = [:]
        
        let scaling = UIView()
        scaling.backgroundColor = UIColor.white
        self.addSubview(scaling)
        scaling.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = scaling

        let backButton = CustomButtonWithExtendedTouchArea(type: .custom)
        backButton.addTarget(self, action: #selector(self._backButtonWasPressed(_:)), for: .touchUpInside)
        backButton.adjustsImageWhenHighlighted = true
        backButton.setImage(UIImage(named: "back_lampone"), for: UIControlState())
        scaling.addSubview(backButton)
        backButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(44.5 / masterRatio)
            make.height.equalTo(89 / masterRatio)
            make.top.equalTo(scaling).offset(57 / masterRatio)
            make.left.equalTo(33 / masterRatio)
        }
        
        let searchIcon = UIImageView()
        scaling.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { make in
            make.width.equalTo(44.5 / masterRatio)
            make.height.equalTo(89 / masterRatio)
            make.top.equalTo(scaling).offset(57 / masterRatio)
            make.left.equalTo(backButton.snp.right).offset(22 / masterRatio)
        }
        searchIcon.contentMode = .center
        searchIcon.image = UIImage(named: "off-search-icon")
        
        searchField.delegate = self
        scaling.addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.width.equalTo(570 / masterRatio)
            make.height.equalTo(80 / masterRatio)
            make.centerY.equalTo(searchIcon.snp.centerY)
            make.left.equalTo(searchIcon.snp.right).offset(25 / masterRatio)
        }
        searchField.returnKeyType = .search
        searchField.placeholder = "Cerca utenti di Grocerest"
        searchField.clearButtonMode = .always
        searchField.autocorrectionType = .yes
        searchField.autocapitalizationType = .none
        

        usersTable.separatorStyle = .none
        usersTable.register(UITableViewCell.self, forCellReuseIdentifier: "user")
        usersTable.rowHeight = 150 / masterRatio
        usersTable.bounces = true
        usersTable.allowsSelection = false
        scaling.addSubview(usersTable)
        usersTable.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(20 / masterRatio)
            make.right.bottom.left.equalTo(scaling)
        }
        
        
        let emptyTableBackground = UIView()
        emptyTableBackground.backgroundColor = UIColor(hexString: "F1F1F1")
        
        let emptyTableImageView = UIImageView()
        emptyTableImageView.contentMode = .scaleAspectFit
        emptyTableImageView.image = UIImage(named: "empty_list")
        emptyTableBackground.addSubview(emptyTableImageView)
        emptyTableImageView.snp.makeConstraints { make in
            make.width.equalTo(157 / masterRatio)
            make.height.equalTo(264 / masterRatio)
            make.top.equalTo(emptyTableBackground).offset(229 / masterRatio)
            make.centerX.equalTo(emptyTableBackground)
        }

        let emptyTableLabel = UILabel()
        emptyTableLabel.text = "Inizia la ricerca"
        emptyTableLabel.font = Constants.BrandFonts.ubuntuMedium16
        emptyTableLabel.textColor = UIColor.grocerestDarkBoldGray()
        emptyTableLabel.textAlignment = .center
        emptyTableBackground.addSubview(emptyTableLabel)
        emptyTableLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyTableImageView.snp.bottom).offset(88 / masterRatio)
            make.centerX.equalTo(emptyTableImageView.snp.centerX)
        }
        
        usersTable.backgroundView = emptyTableBackground
        
        
        self.viewsByName = viewsByName
    }
    
    func _backButtonWasPressed(_: UIButton) {
        onBackButtonTap?()
    }
    
    // When touching the table the keyboard is dismissed
    func _usersTableWasTouched(_ gesture: UIGestureRecognizer) {
        searchField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.characters.count > 0 {
            textField.resignFirstResponder()
            onSearchFieldReturn?(text)
        }
        return true
    }
    
    /**
     Calls reloadData on the usersTable. It also adds an header
     under the search field, pushes down the table and changes
     its background.
     */
    func refreshUsersTable() {
        // Header setup
        let scalingView = self.viewsByName["__scaling__"]!
        
        // Does this only once
        if usersTable.backgroundView != nil {
            let header = UIView()
            header.backgroundColor = UIColor(hexString: "F1F1F1")
            scalingView.addSubview(header)
            header.snp.makeConstraints { make in
                make.top.equalTo(searchField.snp.bottom).offset(20 / masterRatio)
                make.left.right.equalTo(scalingView)
                make.height.equalTo(64 / masterRatio)
            }
            
            headerLabel.font = UIFont.avenirBook(22)
            headerLabel.textColor = UIColor(hexString: "979797")
            header.addSubview(headerLabel)
            headerLabel.snp.makeConstraints { make in
                make.centerY.equalTo(header)
                make.left.equalTo(header.snp.left).offset(34 / masterRatio)
            }
            
            // Table view push down
            usersTable.snp.remakeConstraints { make in
                make.top.equalTo(header.snp.bottom)
                make.right.bottom.left.equalTo(scalingView)
            }
            
            // Table background change
            usersTable.backgroundView = nil
            usersTable.backgroundColor = UIColor.white
            
            // Table background rows' separator
            usersTable.separatorStyle = .singleLine
            usersTable.separatorColor = UIColor(hexString: "E4E4E4")
            
            // Dismisses the keyboard when you drag the table
            usersTable.keyboardDismissMode = .onDrag
        }
        
        // Reload table data
        usersTable.reloadData()
    }
    
    /**
        Make the searchfield become first responder.
     */
    func focusOnSearchField() {
        searchField.becomeFirstResponder()
    }
    
    /**
     Make the searchfield resign first responder status.
     */
    func dismissKeyboard() {
        searchField.resignFirstResponder()
    }
    
}
