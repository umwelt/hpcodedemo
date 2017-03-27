//
//  GRDateSelectorAlertView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 15/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRDateSelectorAlertView: UIView {
    
    fileprivate let scalingView = UIView()
    fileprivate let alertBox = UIView()
    fileprivate let titleLabel = UILabel()
    fileprivate let picker = UIDatePicker()
    fileprivate let unspecifiedLabel = UILabel()
    fileprivate let cancelButton = UIButton(type: .custom)
    fileprivate let confirmButton = UIButton(type: .custom)
    
    var title: String {
        get { return titleLabel.text! }
        set (newValue) { titleLabel.text = newValue }
    }
    
    var unspecifiedButtonText: String {
        get { return unspecifiedLabel.text! }
        set (newValue) { unspecifiedLabel.text = newValue }
    }
    
    var date: Date {
        get { return picker.date }
        set (newValue) { picker.date = newValue }
    }
    
    var cancelCallback: (() -> Void)?
    var unspecifiedCallback: (() -> Void)?
    var confirmCallback: (() -> Void)?
    
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
    
    // - MARK: Scaling
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
    
    // - MARK: Custom
    
    fileprivate func setupHierarchy() {
        scalingView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
        self.addSubview(scalingView)
        scalingView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        let backgroundTappableArea = UIButton(type: .custom)
        scalingView.addSubview(backgroundTappableArea)
        backgroundTappableArea.snp.makeConstraints { make in
            make.edges.equalTo(scalingView)
        }
        backgroundTappableArea.addTarget(self, action: #selector(GRDateSelectorAlertView.backgroundButtonWasPressed(_:)), for: .touchUpInside)
        
        alertBox.clipsToBounds = true
        alertBox.layer.masksToBounds = false
        alertBox.layer.cornerRadius = 5
        alertBox.backgroundColor = UIColor.white
        scalingView.addSubview(alertBox)
        alertBox.snp.makeConstraints { make in
            make.bottom.equalTo(scalingView.snp.bottom).offset(450)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(583 / masterRatio)
            make.height.equalTo(535 / masterRatio)
        }
        
        titleLabel.font = Constants.BrandFonts.avenirRoman13
        titleLabel.textColor = UIColor.grocerestDarkGrayText()
        alertBox.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(alertBox.snp.top).offset(29 / masterRatio)
            make.centerX.equalTo(alertBox.snp.centerX)
        }
        
        confirmButton.setImage(UIImage(named: "check_blue"), for: UIControlState())
        confirmButton.contentMode = .center
        alertBox.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalTo(alertBox.snp.right).offset(-19 / masterRatio)
        }
        confirmButton.imageView?.snp.makeConstraints { make in
            make.width.equalTo(38 / masterRatio)
            make.height.equalTo(25 / masterRatio)
        }
        confirmButton.addTarget(self, action: #selector(GRDateSelectorAlertView.confirmButtonWasPressed(_:)), for: .touchUpInside)
        
        let horizontalLine = UIView()
        horizontalLine.layer.borderColor = UIColor.grocerestLightGrayColor().cgColor
        horizontalLine.layer.borderWidth = 1 / masterRatio
        alertBox.addSubview(horizontalLine)
        horizontalLine.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(29 / masterRatio)
            make.left.equalTo(alertBox.snp.left)
            make.right.equalTo(alertBox.snp.right)
            make.height.equalTo(2 / masterRatio)
        }
        
        let calendar = Calendar.current
        
        var components = DateComponents()
        components.year = 1900
        let minimumDate = calendar.date(from: components)
        
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.day, .month, .year]
        var nowComponents = (calendar as NSCalendar).components(unitFlags, from: now)
        nowComponents.year = nowComponents.year! - 10
        let tenYearsInThePast = calendar.date(from: nowComponents)
        
        picker.timeZone = TimeZone(secondsFromGMT: 0)
        picker.datePickerMode = .date
        picker.minimumDate = minimumDate
        picker.maximumDate = tenYearsInThePast
        picker.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: 1)
        picker.layer.borderColor = UIColor.transparentGrayColor().cgColor
        picker.layer.borderWidth = 1 / masterRatio
        alertBox.addSubview(picker)
        picker.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine.snp.top).offset(1 / masterRatio)
            make.left.equalTo(alertBox.snp.left)
            make.right.equalTo(alertBox.snp.right)
            make.height.equalTo(313 / masterRatio)
        }
        
        unspecifiedLabel.font = Constants.BrandFonts.avenirBook15
        unspecifiedLabel.textColor = UIColor.grocerestLightGrayColor()
        alertBox.addSubview(unspecifiedLabel)
        unspecifiedLabel.snp.makeConstraints { make in
            make.bottom.equalTo(alertBox.snp.bottom).offset(-50 / masterRatio)
            make.centerX.equalTo(alertBox.snp.centerX)
        }
        
        let unspecifiedButton = UIButton(type: .custom)
        alertBox.addSubview(unspecifiedButton)
        unspecifiedButton.snp.makeConstraints { make in
            make.top.equalTo(picker.snp.bottom)
            make.left.right.equalTo(alertBox)
            make.bottom.equalTo(alertBox.snp.bottom)
        }
        unspecifiedButton.addTarget(self, action: #selector(GRDateSelectorAlertView.unspecifiedButtonWasPressed(_:)), for: .touchUpInside)
    }
    
    func showBoxView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: UIViewAnimationOptions(), animations: {
            self.alertBox.transform = CGAffineTransform(translationX: 0, y: -890 / masterRatio)
            }, completion: nil)
    }
    
    func hideBoxView(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.alertBox.transform = CGAffineTransform(translationX: 0, y: 450 / masterRatio)
            }, completion: { _ in
                completion?()
        })
    }
    
    func unspecifiedButtonWasPressed(_ sender: UIButton) {
        unspecifiedCallback?()
    }
    
    func backgroundButtonWasPressed(_ sender: UIButton) {
        cancelCallback?()
    }
    
    func confirmButtonWasPressed(_ sender: UIButton) {
        confirmCallback?()
    }
    
}
