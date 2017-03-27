//
//  GRProductSearchFilterView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 28/12/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRProductSearchFilterView: UIView {
    
    var onDismissButtonTap,
        onAcceptButtonTap,
        onOptionsChanged: (() -> Void)?
    
    var isAcceptButtonEnabled: Bool {
        get { return acceptButton.isEnabled }
        set {
            acceptButton.isEnabled = newValue
        }
    }
    
    var orderBy: String? {
        return orderSection.selectedOption
    }
    
    var ownProductsOnlyFilter: Bool {
        get {
            return filtersSection.ownProductsOnly
        }
        set {
            filtersSection.ownProductsOnly = newValue
        }
    }
    
    var productsWithoutReviewsOnlyFilter: Bool {
        get {
            return filtersSection.productsWithoutReviewsOnly
        }
        set {
            filtersSection.productsWithoutReviewsOnly = newValue
        }
    }
    
    var minimumRating: Int {
        return minimumVoteSection.score
    }
    
    var selectedCategoryId: String? {
        return categoriesSection.selectedCategoryId
    }
    
    func setDefault(options: JSON) {
        if let orderBy = options["orderBy"].string {
            orderSection.selectedOption = orderBy
        }
        
        filtersSection.ownProductsOnly = options["ownProductsOnly"].boolValue
        filtersSection.productsWithoutReviewsOnly = options["productsWithoutReviewsOnly"].boolValue
        
        minimumVoteSection.score = options["minimumRating"].intValue
        
        if let categoryId = options["category"].string {
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
    private let orderSection = OrderSection()
    private let filtersSection = FiltersSection()
    private let minimumVoteSection = MinimumVoteSection()
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
        
        orderSection.onOptionChanged = { self.onOptionsChanged?() }
        stackView.addArrangedSubview(orderSection)
        
        filtersSection.ownProductsOnly = true
        filtersSection.productsWithoutReviewsOnly = false
        filtersSection.onOptionChanged = {
            if self.filtersSection.productsWithoutReviewsOnly {
                self.minimumVoteSection.isHidden = true
            } else {
                self.minimumVoteSection.isHidden = false
            }
            
            self.onOptionsChanged?()
        }
        stackView.addArrangedSubview(filtersSection)
        
        minimumVoteSection.onOptionChanged = { self.onOptionsChanged?() }
        stackView.addArrangedSubview(minimumVoteSection)
        
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



fileprivate class OrderSection: UIView {
    
    var onOptionChanged: (() -> Void)?
    
    var selectedOption: String? {
        get {
            return _selectedOption
        }
        set {
            _selectedOption = newValue
            
            if let newOption = newValue {
                // Option given. We highlight the corresponding button
                for view in buttonsStack.arrangedSubviews {
                    let button = view as! UIButton
                    if options[button.tag] == newOption {
                        // We highlight it
                        button.backgroundColor = UIColor(hexString: "29ABE2")
                        button.setTitleColor(.white, for: .normal)
                    } else {
                        // We reset it
                        button.backgroundColor = .white
                        button.setTitleColor(UIColor(hexString: "29ABE2"), for: .normal)
                    }
                }
            } else {
                // Nil given. We deselect all buttons.
                for view in buttonsStack.arrangedSubviews {
                    let button = view as! UIButton
                    button.backgroundColor = .white
                    button.setTitleColor(UIColor(hexString: "29ABE2"), for: .normal)
                }
            }
        }
    }
    
    private let titles   = ["Classifica", "Media voto", "Numero di commenti scritti", "Numero di voti"]
    private let options = ["reputation", "rating", "comments", "votes"]
    private var _selectedOption: String?
    
    private let buttonsStack = UIStackView()
    
    convenience init() {
        self.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        stackView.addArrangedSubview(SectionHeader(title: "ORDINAMENTO"))
        
        let scrollView = UIScrollView()
        stackView.addArrangedSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.height.equalTo(140 / masterRatio)
            make.left.right.equalTo(self)
        }
        
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 32 / masterRatio
        buttonsStack.layoutMargins = UIEdgeInsets(top: 40 / masterRatio, left: 32 / masterRatio, bottom: 0, right: 32 / masterRatio)
        buttonsStack.isLayoutMarginsRelativeArrangement = true
        scrollView.addSubview(buttonsStack)
        buttonsStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
        }
        
        for (i, title) in titles.enumerated() {
            addButton(title: title, index: i)
        }
    }
    
    private func addButton(title: String, index: Int) {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.tag = index
        
        button.contentEdgeInsets = UIEdgeInsets(top: 12 / masterRatio,
                                                left: 44 / masterRatio,
                                                bottom: 12 / masterRatio,
                                                right: 44 / masterRatio)
        
        button.layer.borderWidth = 2 / masterRatio
        button.layer.cornerRadius = 10 / masterRatio
        button.layer.borderColor = UIColor(hexString: "29ABE2").cgColor
        
        button.titleLabel?.font = .avenirBook(26)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor(hexString: "29ABE2"), for: .normal)
        
        button.addTarget(self, action: #selector(self._buttonTapped(_:)), for: .touchUpInside)
        buttonsStack.addArrangedSubview(button)
    }
    
    func _buttonTapped(_ tappedButton: UIButton) {
        selectedOption = options[tappedButton.tag]
        
        for view in buttonsStack.arrangedSubviews {
            let button = view as! UIButton
            button.backgroundColor = .white
            button.setTitleColor(UIColor(hexString: "29ABE2"), for: .normal)
        }
        
        tappedButton.backgroundColor = UIColor(hexString: "29ABE2")
        tappedButton.setTitleColor(.white, for: .normal)
        
        onOptionChanged?()
    }
    
}



fileprivate class FiltersSection: UIView {
    
    var ownProductsOnly: Bool {
        get {
            return ownProducts.optionValue
        }
        set {
            ownProducts.optionValue = newValue
        }
    }
    
    var productsWithoutReviewsOnly: Bool {
        get {
            return withoutReviews.optionValue
        }
        set {
            withoutReviews.optionValue = newValue
        }
    }
    
    var onOptionChanged: (() -> Void)? {
        didSet {
            ownProducts.onOptionChanged = onOptionChanged
            withoutReviews.onOptionChanged = onOptionChanged
        }
    }
    
    private let ownProducts = FilterCell(title: "Cerca solo tra i miei prodotti")
    private let withoutReviews = FilterCell(title: "Mostra solo prodotti senza recensioni")
    
    convenience init() {
        self.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        stackView.addArrangedSubview(SectionHeader(title: "FILTRI"))
        
        stackView.addArrangedSubview(ownProducts)
        
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
        
        stackView.addArrangedSubview(separator)
        
        stackView.addArrangedSubview(withoutReviews)
    }
    
    private class FilterCell: UIView {
        
        var onOptionChanged: (() -> Void)?
        
        var optionValue: Bool {
            get {
                return switchControl.isOn
            }
            set {
                switchControl.setOn(newValue, animated: false)
                onOptionChanged?()
            }
        }
        
        private let switchControl = UISwitch(frame: .zero)
        
        convenience init(title: String) {
            self.init(frame: .zero)
            
            translatesAutoresizingMaskIntoConstraints = false
            snp.makeConstraints { make in
                make.width.equalTo(UIScreen.main.bounds.width)
                make.height.equalTo(145 / masterRatio)
            }
            
            let label = UILabel()
            label.text = title
            label.font = .avenirBook(26)
            label.textColor = UIColor(hexString: "4A4A4A")
            addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalTo(self)
                make.left.equalTo(self).offset(32 / masterRatio)
            }
            
            switchControl.onTintColor = UIColor(hexString: "29ABE2")
            switchControl.addTarget(self, action: #selector(self._switchValueChanged(_:)), for: .valueChanged)
            addSubview(switchControl)
            switchControl.snp.makeConstraints { make in
                make.centerY.equalTo(self)
                make.right.equalTo(self).offset(-32 / masterRatio)
            }
        }
        
        func _switchValueChanged(_ switchControl: UISwitch) {
            onOptionChanged?()
        }
        
    }
    
}



fileprivate class MinimumVoteSection: UIView {
    
    var onOptionChanged: (() -> Void)?
    
    var score: Int = 0 {
        didSet {
            if score < 0 || score > 5 {
                fatalError("Score must be an integer between 0 and 5 included")
            }
            
            for circle in circlesStack.arrangedSubviews {
                let button = circle as! UIButton
                if button.tag <= score {
                    button.setBackgroundImage(UIImage(named: "score-full-big"), for: .normal)
                } else {
                    button.setBackgroundImage(UIImage(named: "score-empty-big"), for: .normal)
                }
            }
            
            if score == 0 {
                label.text = "Tutti"
                header.isResetButtonHidden = true
            } else if score < 5 {
                label.text = "Da \(score) in su"
                header.isResetButtonHidden = false
            } else {
                label.text = "Solo 5"
                header.isResetButtonHidden = false
            }
            
            onOptionChanged?()
        }
    }
    
    private let header = SectionHeader(title: "VOTO MINIMO")
    private let circlesStack = UIStackView()
    private let label = UILabel()
    
    convenience init() {
        self.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        header.onReset = {
            self.score = 0
        }
        stackView.addArrangedSubview(header)
        
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(172 / masterRatio)
        }
        stackView.addArrangedSubview(content)
        
        circlesStack.axis = .horizontal
        circlesStack.spacing = 30 / masterRatio
        content.addSubview(circlesStack)
        circlesStack.snp.makeConstraints { make in
            make.left.equalTo(content).offset(34 / masterRatio)
            make.centerY.equalTo(content)
        }
        
        for i in 1...5 {
            let circleButton = UIButton(type: .custom)
            circleButton.tag = i
            circleButton.setBackgroundImage(UIImage(named: "score-empty-big"), for: .normal)
            circleButton.imageView?.contentMode = .scaleAspectFit
            circleButton.addTarget(self, action: #selector(self._buttonTapped(_:)), for: .touchUpInside)
            circlesStack.addArrangedSubview(circleButton)
            circleButton.translatesAutoresizingMaskIntoConstraints = false
            circleButton.snp.makeConstraints { make in
                make.width.equalTo(73.12 / masterRatio)
                make.height.equalTo(72 / masterRatio)
            }
        }
        
        label.text = "Tutti"
        label.textColor = UIColor(hexString: "4A4A4A")
        label.font = .avenirBook(26)
        content.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(circlesStack.snp.right).offset(45 / masterRatio)
            make.centerY.equalTo(content)
        }
    }

    func _buttonTapped(_ button: UIButton) {
        score = button.tag
    }

}



fileprivate class CategoriesSection: UIView {
    
    var onOptionChanged: (() -> Void)?
    
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
                            } else {
                                self.selectedCategoryId = nil
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
