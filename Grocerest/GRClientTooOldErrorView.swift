//
//  GRClientTooOldErrorView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 17/05/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

@IBDesignable
class GRClientTooOldErrorView: UIView {

    var viewsByName: [String: UIView]!

    var downloadButton = UIButton()

    // - MARK: Life Cycle

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.setupHierarchy()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }


    var delegate : GRClientTooOldErrorViewProtocol?

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
        var viewsByName: [String: UIView] = [:]
        let __scaling__ = UIView()
        self.addSubview(__scaling__)
        __scaling__.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        viewsByName["__scaling__"] = __scaling__


        let backgroundImg = UIImageView()
        __scaling__.addSubview(backgroundImg)
        backgroundImg.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        var mallImg: UIImage!
        mallImg = UIImage(named: "mall")
        backgroundImg.image = mallImg
        backgroundImg.contentMode = .scaleAspectFit;
        viewsByName["backgroundImg"] = backgroundImg

        let alpha_cover = UIImageView()
        __scaling__.addSubview(alpha_cover)
        alpha_cover.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        alpha_cover.backgroundColor = UIColor(colorLiteralRed: 0.898, green: 0.204, blue: 0.325, alpha: 0.9)
        viewsByName["alpha_cover"] = alpha_cover


        let grocerestLogo = UIImageView()
        __scaling__.addSubview(grocerestLogo)
        grocerestLogo.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(210 / masterRatio)
            make.width.equalTo(self)
            make.centerX.equalTo(self.snp.centerX)
        }
        grocerestLogo.image = UIImage(named: "grocerest_logo")
        grocerestLogo.contentMode = .scaleAspectFit
        viewsByName["grocerestLogo"] = grocerestLogo


        let logo = UIImageView()
        __scaling__.addSubview(logo)
        logo.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(grocerestLogo.snp.bottom).offset(100 / masterRatio)
            make.width.equalTo(self)
            make.centerX.equalTo(self.snp.centerX)
        }
        logo.image = UIImage(named: "error_icon")
        logo.contentMode = .scaleAspectFit
        viewsByName["logo"] = logo

        let titleLabel = UILabel()
        titleLabel.numberOfLines = 3
        titleLabel.text = "ATTENZIONE!"
        titleLabel.font = Constants.BrandFonts.avenirRoman15
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        __scaling__.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(logo.snp.bottom).offset(25 / masterRatio)
        }
        viewsByName["titleLabel"] = titleLabel

        let messageLabel = UILabel()
        messageLabel.numberOfLines = 6
        messageLabel.text = "La tua versione di Grocerest è obsoleta.\n Ti chiediamo la cortesia di andare sullo\n App Store e aggiornarla.\n\nIn questo modo potrai fruire di tutte\nle nuove funzionalità incluse."
        messageLabel.font = Constants.BrandFonts.avenirRoman15
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = .center
        __scaling__.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(50 / masterRatio)
        }
        viewsByName["messageLabel"] = messageLabel


        downloadButton = UIButton(type: .custom)
        __scaling__.addSubview(downloadButton)
        var imageDownloadButton: UIImage!
        imageDownloadButton = UIImage(named: "trasparent_button")
        downloadButton.setBackgroundImage(imageDownloadButton, for: UIControlState())
        downloadButton.contentMode = .center
        downloadButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.UISizes.bigButtonSize)
            make.top.equalTo(messageLabel.snp.bottom).offset(50 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
        }
        downloadButton.addTarget(self, action: #selector(GRClientTooOldErrorView.actionDownloadButtonWasPressed), for: .touchUpInside)


        let downloadLabel = UILabel()
        downloadLabel.text = Constants.AppLabels.downloadLabel
        downloadLabel.font = Constants.BrandFonts.smallLabelFontA
        downloadLabel.textColor = UIColor.white
        downloadLabel.textAlignment = .center
        downloadButton.addSubview(downloadLabel)
        downloadLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(downloadButton.snp.centerX)
            make.centerY.equalTo(downloadButton.snp.centerY)

        }
        viewsByName["downloadButton"] = downloadButton


        self.viewsByName = viewsByName
    }

    // - MARK: delegated

    func actionDownloadButtonWasPressed() {
        delegate?.downloadButtonWasPressed()
    }
}
