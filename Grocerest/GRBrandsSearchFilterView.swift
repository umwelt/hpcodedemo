//
//  GRBrandsSearchFilterView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/02/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation

class GRBrandsSearchFilterView: UIView {
    
    var onDismissButtonTap,
    onAcceptButtonTap,
    onOptionsChanged: (() -> Void)?
    
    var isAcceptButtonEnabled: Bool {
        get { return acceptButton.isEnabled }
        set {
            acceptButton.isEnabled = newValue
        }
    }
    
    var selectedCategoryId: String? {
        return categoriesSection.selectedCategoryId
    }
    
    var selectedCategorySlug: String? {
        return categoriesSection.selectedCategorySlug
    }
    
    func setDefault(options: JSON) {
        if let categoryId = options["categoryId"].string {
            categoriesSection.selectedCategoryId = categoryId
        }
        
        if let subcategoryName = options["subcategoryName"].string {
            categoriesSection.subcategoryNameOfSelectedCategory = subcategoryName
        }
    }
    
    var isCategorySelectionDisabled: Bool {
        get {
            return categoriesSection.isSelectionDisabled
        }
        set {
            categoriesSection.isSelectionDisabled = newValue
        }
    }
    
    private let acceptButton = CustomButtonWithExtendedTouchArea(type: .custom)
    private let categoriesSection = CategoriesSection()
    
    convenience init() {
        let yOffset: CGFloat = 41 // To account for the status bar
        self.init(frame: CGRect(x: 0, y: yOffset, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - yOffset))
    }
    
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
        backgroundColor = .white
        
        let title = UILabel()
        title.text = "Ordina e filtra"
        title.textColor = UIColor(hexString: "DC304E")
        title.font = .ubuntuLight(36)
        addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(self).offset(69 / masterRatio)
            make.centerX.equalTo(self)
        }
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.setImage(UIImage(named: "close_modal"), for: .normal)
        dismissButton.addTarget(self, action: #selector(self._dismissButtonWasTapped(_:)), for: .touchUpInside)
        addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.left.equalTo(self).offset(34 / masterRatio)
            make.centerY.equalTo(title)
        }
        
        acceptButton.setImage(UIImage(named: "ok_lampone"), for: .normal)
        acceptButton.setImage(UIImage(named: "check-disabled"), for: .disabled)
        acceptButton.isEnabled = false
        acceptButton.addTarget(self, action: #selector(self._acceptButtonWasTapped(_:)), for: .touchUpInside)
        addSubview(acceptButton)
        acceptButton.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-33 / masterRatio)
            make.centerY.equalTo(title)
        }
        
        let separator = UIView()
        separator.backgroundColor = UIColor(hexString: "C8C7CC")
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(33 / masterRatio)
            make.left.right.equalTo(self)
            make.height.equalTo(1 / masterRatio)
        }
        
        let scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
        }
        
        categoriesSection.onOptionChanged = { self.onOptionsChanged?() }
        stackView.addArrangedSubview(categoriesSection)
    }
    
    // ** Buttons callbacks **
    
    func _dismissButtonWasTapped(_ button: UIButton) {
        onDismissButtonTap?()
    }
    
    func _acceptButtonWasTapped(_ button: UIButton) {
        onAcceptButtonTap?()
    }
    
}



// ** Classes for internal use only **



fileprivate class CustomButtonWithExtendedTouchArea: UIButton {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsetsMake(-20/masterRatio, -20/masterRatio, -20/masterRatio, -20/masterRatio)
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
    
}



fileprivate class SectionHeader: UIView {
    
    var isResetButtonHidden = true {
        didSet {
            resetButton?.isHidden = isResetButtonHidden
        }
    }
    
    var onReset: (() -> Void)? {
        didSet {
            if onReset != nil {
                let button = UIButton()
                button.isHidden = isResetButtonHidden
                button.setTitle("RESET", for: .normal)
                button.setTitleColor(UIColor(hexString: "29ABE2"), for: .normal)
                button.titleLabel?.font = .avenirMedium(22)
                button.addTarget(self, action: #selector(self._resetButtonTapped(_:)), for: .touchUpInside)
                addSubview(button)
                button.snp.makeConstraints { make in
                    make.right.equalTo(self).offset(-36 / masterRatio)
                    make.centerY.equalTo(self)
                }
                
                resetButton = button
            }
        }
    }
    
    private var resetButton: UIButton?
    
    convenience init(title: String) {
        self.init(frame: .zero)
        
        backgroundColor = UIColor(hexString: "F1F1F1")
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(64 / masterRatio)
        }
        
        let label = UILabel()
        label.text = title
        label.textColor = UIColor(hexString: "979797")
        label.font = .avenirMedium(22)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(self).offset(32 / masterRatio)
            make.centerY.equalTo(self)
        }
    }
    
    func _resetButtonTapped(_ button: UIButton) {
        onReset?()
    }
    
}



fileprivate class CategoriesSection: UIView {
    
    var onOptionChanged: (() -> Void)?
    
    var selectedCategorySlug: String?
    
    var selectedCategoryId: String? {
        didSet {
            update()
        }
    }
    
    var isSelectionDisabled: Bool = false {
        didSet {
            update()
        }
    }
    
    var subcategoryNameOfSelectedCategory: String? {
        didSet {
            update()
        }
    }
    
    private let stackView = UIStackView()
    
    convenience init() {
        self.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        stackView.addArrangedSubview(SectionHeader(title: "CATEGORIA"))
        
        populate()
    }
    
    private func populate() {
        DispatchQueue.global(qos: .userInitiated).async {
            GrocerestAPI.getCategories() { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }
                
                DispatchQueue.main.async {
                    for category in data["children"].arrayValue {
                        let cell = CategoryCell(from: category)
                        cell.onSelect = {
                            if cell.isSelected {
                                self.selectedCategoryId = category["_id"].string
                                self.selectedCategorySlug = category["slug"].string
                            } else {
                                self.selectedCategoryId = nil
                                self.selectedCategorySlug = nil
                            }
                        }
                        self.stackView.addArrangedSubview(cell)
                        self.stackView.addArrangedSubview(self.createSeparator())
                    }
                    self.update()
                }
            }
        }
    }
    
    private func update() {
        if let id = selectedCategoryId {
            for view in stackView.arrangedSubviews {
                if let cell = view as? CategoryCell {
                    if cell.category["_id"].stringValue == id {
                        cell.isSelected = true
                        if let subcategoryName = subcategoryNameOfSelectedCategory {
                            cell.appendSubcategory(name: subcategoryName)
                        }
                    } else {
                        cell.isSelected = false
                    }
                    cell.isDisabled = isSelectionDisabled
                }
            }
        } else {
            for view in stackView.arrangedSubviews {
                if let cell = view as? CategoryCell {
                    cell.isSelected = false
                    cell.isDisabled = isSelectionDisabled
                }
            }
        }
        
        onOptionChanged?()
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(hexString: "C8C7CC")
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.snp.makeConstraints { make in
            make.height.equalTo(1 / masterRatio)
        }
        
        // Little white space at the beginning to imitate native UITable
        // separators
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: 0))
        linePath.addLine(to: CGPoint(x: 32 / masterRatio, y: 0))
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.strokeColor = UIColor.white.cgColor
        separator.layer.addSublayer(line)
        
        return separator
    }
    
    fileprivate class CategoryButton: UIButton {
        
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let relativeFrame = self.bounds
            let hitTestEdgeInsets = UIEdgeInsetsMake(-40/masterRatio, -700/masterRatio, -40/masterRatio, -40/masterRatio)
            let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
            return hitFrame.contains(point)
        }
        
    }
    
    private class CategoryCell: UIView {
        
        var category: JSON!
        
        var isSelected: Bool = false {
            didSet {
                button.isSelected = isSelected
            }
        }
        
        var isDisabled: Bool = false {
            didSet {
                if isDisabled {
                    // Shows active image even if it's disabled
                    if isSelected {
                        button.setBackgroundImage(UIImage(named: "utile-active-checked"), for: .normal)
                    }
                    button.isEnabled = false
                    icon.layer.opacity = 0.4
                    label.layer.opacity = 0.4
                } else {
                    button.isEnabled = true
                    icon.layer.opacity = 1
                    label.layer.opacity = 1
                    // Restores default images
                    button.setBackgroundImage(UIImage(named: "utile-active-unchecked"), for: .normal)
                    button.setBackgroundImage(UIImage(named: "utile-active-checked"), for: .selected)
                    button.setBackgroundImage(UIImage(named: "utile-inactive-unchecked"), for: .disabled)
                }
            }
        }
        
        var onSelect: (() -> Void)?
        
        func appendSubcategory(name: String) {
            label.text?.append("  |  \(name)")
        }
        
        private let icon = UIImageView()
        private let label = UILabel()
        private let button = CategoryButton(type: .custom)
        
        convenience init(from category: JSON) {
            self.init(frame: .zero)
            
            self.category = category
            
            translatesAutoresizingMaskIntoConstraints = false
            snp.makeConstraints { make in
                make.width.equalTo(UIScreen.main.bounds.width)
                make.height.equalTo(124 / masterRatio)
            }
            
            icon.image = UIImage(named: category["name"].stringValue)
            icon.contentMode = .scaleAspectFill
            addSubview(icon)
            icon.snp.makeConstraints { make in
                make.width.height.equalTo(74 / masterRatio)
                make.centerY.equalTo(self)
                make.left.equalTo(self).offset(48 / masterRatio)
            }
            
            button.imageView?.contentMode = .scaleAspectFill
            button.setBackgroundImage(UIImage(named: "utile-active-unchecked"), for: .normal)
            button.setBackgroundImage(UIImage(named: "utile-active-checked"), for: .selected)
            button.setBackgroundImage(UIImage(named: "utile-inactive-unchecked"), for: .disabled)
            button.addTarget(self, action: #selector(self._buttonTapped(_:)), for: .touchUpInside)
            addSubview(button)
            button.snp.makeConstraints { make in
                make.centerY.equalTo(self)
                make.right.equalTo(self).offset(-48 / masterRatio)
                make.width.height.equalTo(44 / masterRatio)
            }
            
            label.text = category["name"].stringValue
            label.font = .avenirBook(26)
            label.textColor = UIColor(hexString: "4A4A4A")
            addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalTo(self)
                make.left.equalTo(icon.snp.right).offset(32 / masterRatio)
                make.right.equalTo(button.snp.left).offset(-32 / masterRatio)
            }
        }
        
        func _buttonTapped(_ button: UIButton) {
            isSelected = !isSelected
            onSelect?()
        }
        
    }
    
}
