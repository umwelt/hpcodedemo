//
//  GRScoreDistributionView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 30/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRScoreDistributionView: UIView {
    
    private class CustomProgressview: UIProgressView {
        
        override func setProgress(_ progress: Float, animated: Bool) {
            if !animated {
                self.progress = progress
                self.layoutIfNeeded()
                return
            }
            
            self.layoutIfNeeded() // ensure bars are sized allright
            self.progress = progress
            let duration: TimeInterval = 1.0
            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    
    private var bars: [CustomProgressview]!
    private var labels: [UILabel]!
    private var counters: [UILabel]!
    private let stack = UIStackView()
    
    var labelsColor: UIColor? {
        didSet {
            for label in labels {
                label.textColor = labelsColor
            }
        }
    }
    
    var labelsFont: UIFont? {
        didSet {
            for label in labels {
                label.font = labelsFont
            }
        }
    }
    
    var countersColor: UIColor? {
        didSet {
            for counter in counters {
                counter.textColor = countersColor
            }
        }
    }
    
    var countersFont: UIFont? {
        didSet {
            for counter in counters {
                counter.font = countersFont
            }
        }
    }
    
    var barsSpacing: CGFloat = 0 {
        didSet {
            stack.spacing = barsSpacing
        }
    }
    
    var barsColor: UIColor? {
        didSet {
            for bar in bars {
                bar.progressTintColor = barsColor
            }
        }
    }
    
    var barsBackgroundColor: UIColor? {
        didSet {
            for bar in bars {
                bar.trackTintColor = barsBackgroundColor
            }
        }
    }
    
    var reviews: [Int] = [0, 0, 0, 0, 0] {
        didSet {
            let totalNumberOfReviews = reviews.reduce(0) { sum, numberOfReviews in return sum + numberOfReviews }
            for i in 0...4 {
                if reviews[i] == 0 {
                    self.bars[i].setProgress(0, animated: true)
                } else {
                    let percentage: Float = Float(reviews[i]) / Float(totalNumberOfReviews)
                    self.bars[i].setProgress(percentage, animated: true)
                }
                counters[i].text = "\(reviews[i])"
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }
    
    // To replay the animation whenever it shows up
    func replayAnimation() {
        let totalNumberOfReviews = reviews.reduce(0) { sum, numberOfReviews in return sum + numberOfReviews }
        for (i, bar) in bars.enumerated() {
            // Do not animate an empty bar (because it will fill up the entire bar even if it's 0)
            if 0 == bar.progress + Float(reviews[i]) { return }
            bar.setProgress(0, animated: false)
            let percentage: Float = Float(reviews[i]) / Float(totalNumberOfReviews)
            bar.setProgress(percentage, animated: true)
        }
    }
    
    func setupHierarchy() {
        let (table, bars, counters, labels) = createTable()
        addSubview(table)
        table.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        self.bars = bars
        self.counters = counters
        self.labels = labels
    }
    
    private func createTable() -> (UIStackView, [CustomProgressview], [UILabel], [UILabel]) {
        stack.axis  = UILayoutConstraintAxis.vertical
        stack.distribution  = UIStackViewDistribution.equalCentering
        stack.alignment = UIStackViewAlignment.center
        
        let labelsText = ["Ottimo", "Buono", "Medio", "Scarso", "Pessimo"]
        var bars = [CustomProgressview]()
        var labels = [UILabel]()
        var counters = [UILabel]()
        for labelText in labelsText {
            let (row, bar, counter, label) = createRow(labelText)
            stack.addArrangedSubview(row)
            bars.append(bar)
            counters.append(counter)
            labels.append(counter)
            labels.append(label)
        }
        
        return (stack, bars, counters, labels)
    }
    
    private func createRow(_ labelText: String) -> (UIStackView, CustomProgressview, UILabel, UILabel) {
        let row = UIStackView()
        row.axis  = UILayoutConstraintAxis.horizontal
        row.distribution  = UIStackViewDistribution.fill
        row.alignment = UIStackViewAlignment.center
        
        let label = UILabel()
        label.text = labelText
        label.font = Constants.BrandFonts.avenirRoman13
        label.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        label.textAlignment = .left
        row.addArrangedSubview(label)
        label.snp.makeConstraints { make in
            make.width.equalTo(161 / masterRatio)
        }
        
        let bar = createBar()
        row.addArrangedSubview(bar)
        bar.snp.makeConstraints { make in
            make.width.equalTo(360 / masterRatio)
            make.height.equalTo(14 / masterRatio)
        }
        
        let counter = UILabel()
        counter.text = "0"
        counter.font = Constants.BrandFonts.ubuntuBold14
        counter.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        counter.textAlignment = .right
        row.addArrangedSubview(counter)
        counter.snp.makeConstraints { make in
            make.width.equalTo(101 / masterRatio)
        }
        
        return (row, bar, counter, label)
    }
    
    private func createBar() -> CustomProgressview {
        let bar = CustomProgressview()
        bar.layer.cornerRadius = 8 / masterRatio
        bar.clipsToBounds = true
        bar.trackTintColor = UIColor.F1F1F1Color()
        bar.progressTintColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        return bar
    }
    
}
