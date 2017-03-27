//
//  GREditProfileView.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 19/02/16.
//  Copyright © 2016 grocerest. All rights reserved.
//


import Foundation
import UIKit

class GREditProfileView: UIView {
    
    var delegate = GREditProfileViewController()
    lazy var profileImageView : UserImage = {
        let userImage = UserImage()
        
        return userImage
    }()

    let tableView = GREditProfileTableView()
    
    var editPhotoButton = UIButton()
    var confirmButton = UIButton()
    
    var userData: JSON? {
        didSet {
            tableView.userData = userData
        }
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
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
    }
    
    func setupHierarchy() {
        backgroundColor = UIColor.white
        
        let pageLabel = UILabel()
        addSubview(pageLabel)
        pageLabel.snp.makeConstraints { make in
            make.width.equalTo(200 / masterRatio)
            make.height.equalTo(42 / masterRatio)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(72 / masterRatio)
        }
        pageLabel.text = "Modifica"
        pageLabel.textColor = UIColor.grocerestColor()
        pageLabel.font = Constants.BrandFonts.ubuntuLight18
        pageLabel.textAlignment = .center
        
        
        let closeButton = UIButton()
        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(100 / masterRatio)
            make.centerY.equalTo(pageLabel.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-10)
        }
        closeButton.setImage(UIImage(named: "close_modal"), for: UIControlState())
        closeButton.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(GREditProfileView.actionCloseButtonWasPressed(_:)), for: .touchUpInside)
        

        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(86 / masterRatio)
            make.left.equalTo(self.snp.left).offset(46 / masterRatio)
            make.top.equalTo(196 / masterRatio)
        }
        
        
        addSubview(editPhotoButton)
        editPhotoButton.snp.makeConstraints { make in
            make.width.equalTo(368 / masterRatio)
            make.height.equalTo(68 / masterRatio)
            make.left.equalTo((profileImageView.snp.right)).offset(58 / masterRatio)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        editPhotoButton.layer.borderWidth = 2
        editPhotoButton.layer.cornerRadius = 6
        editPhotoButton.layer.borderColor = UIColor.grocerestBlue().cgColor
        editPhotoButton.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        editPhotoButton.setTitle("CAMBIA IMMAGINE", for: UIControlState())
        editPhotoButton.titleLabel?.font = Constants.BrandFonts.avenirHeavy11
        editPhotoButton.titleLabel?.textAlignment = .center
        editPhotoButton.addTarget(self, action: #selector(GREditProfileView.actionChangeImageWasPressed(_:)), for: .touchUpInside)
        
        let separatorTop = UIView()
        addSubview(separatorTop)
        separatorTop.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(1 / masterRatio)
            make.left.equalTo(0)
            make.top.equalTo(editPhotoButton.snp.bottom).offset(48 / masterRatio)
        }
        separatorTop.backgroundColor = UIColor.F1F1F1Color()
        
        tableView.separatorColor = UIColor.productsSeparatorcolor()
        tableView.allowsSelection = false
        tableView.delegate = tableView
        tableView.dataSource = tableView
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(editPhotoButton.snp.bottom).offset(48 / masterRatio)
            make.left.right.bottom.equalTo(self)
        }
    }
    
    func actionCloseButtonWasPressed(_ sender:UIButton) {
        delegate.closeButtonWasPressed(sender)
    }
    
    func actionChangeImageWasPressed(_ sender:UIButton) {
        delegate.editUserPhoto(sender)
        
    }
    
}

// MARK: Table View

class GREditProfileTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var userData: JSON? {
        didSet {
            self.reloadData()
        }
    }
    
    var publicName = GREditProfileTableCellView.publicName()
    var email = GREditProfileTableCellView.email()
    var password = GREditProfileTableCellView.password()
    var favoriteCategories = GREditProfileTableCellView.favoriteCategories()
    var firstName = GREditProfileTableCellView.firstName()
    var secondName = GREditProfileTableCellView.secondName()
    var gender = GREditProfileTableCellView.gender()
    var birthdate = GREditProfileTableCellView.birthdate()
    var family = GREditProfileTableCellView.family()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 4
            default:
                return 5
        }
    }
    
    // MARK: Headers
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64 / masterRatio
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.F1F1F1Color()
        
        let label = UILabel()
        header.addSubview(label)
        label.font = Constants.BrandFonts.avenirMedium11
        label.textColor = UIColor.grocerestLightGrayColor()
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(header)
        }
        
        switch section {
            case 0:
                label.text = "DATI GROCEREST"
            case 1:
                label.text = "DATI PERSONALI"
            default:
                fatalError("Invalid section")
        }
        
        return header
    }
    
    // MARK: Rows
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161 / masterRatio
    }
    
    fileprivate func isUserDataFieldEmpty(_ field: String) -> Bool {
        if userData == nil || userData![field].stringValue.isEmpty {
            return true
        }
        return false
    }
    
    fileprivate func getUserDataField(_ field: String) -> String {
        return userData![field].stringValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            // Dati Grocerest
            case 0:
                switch indexPath.row {
                    case 0:
                        if !self.isUserDataFieldEmpty("username") {
                            publicName.subtitle = self.getUserDataField("username")
                        }
                        return publicName
                    case 1:
                        if !self.isUserDataFieldEmpty("email") {
                            email.subtitle = self.getUserDataField("email")
                        }
                        return email
                    case 2:
                        return password
                    case 3:
                        return favoriteCategories
                    default:
                        fatalError("Invalid index path row")
                }
            // Dati personali
            case 1:
                switch indexPath.row {
                    case 0:
                        if !self.isUserDataFieldEmpty("firstname") {
                            firstName.subtitle = self.getUserDataField("firstname")
                        }
                        return firstName
                    case 1:
                        if !self.isUserDataFieldEmpty("lastname") {
                            secondName.subtitle = self.getUserDataField("lastname")
                        }
                        return secondName
                    case 2:
                        if !self.isUserDataFieldEmpty("gender") {
                            gender.subtitle = (self.getUserDataField("gender") == "M" ? "Maschio" : "Femmina")
                            gender.showGoldenBadge()
                        } else {
                            gender.subtitle = "Non specificato"
                            gender.showGrayBadge()
                        }
                        return gender
                    case 3:
                        if !self.isUserDataFieldEmpty("birthdate") {
                            let date = Date(timeIntervalSince1970: Double(self.getUserDataField("birthdate"))! / 1000)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .long
                            birthdate.subtitle = dateFormatter.string(from: date)
                            birthdate.showGoldenBadge()
                        } else {
                            birthdate.subtitle = "Non specificata"
                            birthdate.showGrayBadge()
                        }
                        return birthdate
                    case 4:
                        if !self.isUserDataFieldEmpty("family") {
                            family.subtitle = self.getUserDataField("family")
                            family.showGoldenBadge()
                        } else {
                            family.subtitle = "Non specificato"
                            family.showGrayBadge()
                        }
                        return family
                    default:
                        fatalError("Invalid index path row")
                }
            default:
                fatalError("Invalid index path section")
        }
    }
    
}

// MARK: Table Cell View

class GREditProfileTableCellView: UITableViewCell {
    
    fileprivate let titleLabel = UILabel()
    fileprivate let subtitleLabel = UILabel()
    fileprivate let iconView = UIImageView()
    
    fileprivate var rightIconView: UIImageView?
    
    var onTap: ((Void) -> Void)?
    
    var title: String? {
        get { return titleLabel.text }
        set (value) { titleLabel.text = value }
    }
    
    var subtitle: String? {
        get { return subtitleLabel.text }
        set (value) { subtitleLabel.text = value }
    }
    
    var icon: UIImage? {
        get { return iconView.image }
        set (value) { iconView.image = value }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, subtitle: String) {
        self.init(style: .default, reuseIdentifier: nil)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(GREditProfileTableCellView.cellWasTapped))
        contentView.addGestureRecognizer(tapRecognizer)
        
        titleLabel.textColor = UIColor.grocerestBlue()
        titleLabel.font = Constants.BrandFonts.avenirHeavy11
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(44 / masterRatio)
            make.left.equalTo(contentView).offset(188 / masterRatio)
        }
        
        subtitleLabel.textColor = UIColor.grayText()
        subtitleLabel.font = Constants.BrandFonts.avenirBook15
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4 / masterRatio)
            make.left.equalTo(contentView).offset(188 / masterRatio)
        }
        
        iconView.contentMode = .center
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.bottom.left.equalTo(contentView)
            make.width.equalTo(188 / masterRatio)
        }
    }
    
    func cellWasTapped() {
        self.onTap?()
    }
    
    func showGoldenBadge() {
        rightIconView?.snp.removeConstraints()
        rightIconView?.removeFromSuperview()
        rightIconView = UIImageView(image: UIImage(named: "3_points_badge_golden"))
        rightIconView!.contentMode = .center
        contentView.addSubview(rightIconView!)
        rightIconView?.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(contentView).offset(-1 / masterRatio)
        }
    }
    
    func showGrayBadge() {
        rightIconView?.snp.removeConstraints()
        rightIconView?.removeFromSuperview()
        rightIconView = UIImageView(image: UIImage(named: "3_points_badge_gray"))
        rightIconView!.contentMode = .center
        contentView.addSubview(rightIconView!)
        rightIconView?.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(contentView).offset(-1 / masterRatio)
        }
    }
    func showArrow() {
        rightIconView?.snp.removeConstraints()
        rightIconView?.removeFromSuperview()
        rightIconView = UIImageView(image: UIImage(named: "arrow_blue"))
        rightIconView!.contentMode = .center
        contentView.addSubview(rightIconView!)
        rightIconView?.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(contentView).offset(-31 / masterRatio)
        }
    }
    
    // MARK: Cell factories
    
    static func publicName() -> GREditProfileTableCellView {
        let cell = GREditProfileTableCellView()
        cell.title = "Nome pubblico"
        cell.subtitle = "-"
        cell.icon = UIImage(named: "icon_userp")
        return cell
    }
    
    static func email() -> GREditProfileTableCellView {
        let cell = GREditProfileTableCellView()
        cell.title = "Email"
        cell.subtitle = "-"
        cell.icon = UIImage(named: "icon_emailp")
        return cell
    }
    
    static func password() -> GREditProfileTableCellView {
        let cell = GREditProfileTableCellView()
        cell.title = "Password"
        cell.subtitle = "●●●●●●●"
        cell.icon = UIImage(named: "icon_passwordp")
        cell.showArrow()
        return cell
    }
    
    static func favoriteCategories() -> GREditProfileTableCellView {
        let cell = GREditProfileTableCellView()
        cell.title = ""
        cell.subtitle = "Categorie preferite"
        cell.icon = UIImage(named: "icon_categoriep")
        cell.showArrow()
        return cell
    }
    
    static func firstName() -> GREditProfileTableCellView {
        let cell = GREditProfileTableCellView()
        cell.title = "Nome"
        cell.subtitle = "Non specificato"
        cell.icon = UIImage(named: "icon_userp")
        return cell
    }
    
    static func secondName() -> GREditProfileTableCellView {
        let cell = GREditProfileTableCellView()
        cell.title = "Cognome"
        cell.subtitle = "Non specificato"
        cell.icon = UIImage(named: "icon_userp")
        return cell
    }
    
    static func gender() -> GREditProfileTableCellView {
        let cell = GREditProfileTableCellView()
        cell.title = "Sesso"
        cell.subtitle = "Non specificato"
        cell.icon = UIImage(named: "icon_userp")
        cell.showGrayBadge()
        return cell
    }
    
    static func birthdate() -> GREditProfileTableCellView {
        let cell = GREditProfileTableCellView()
        cell.title = "Data di nascita"
        cell.subtitle = "Non specificata"
        cell.icon = UIImage(named: "icon_birthdatep")
        cell.showGrayBadge()
        return cell
    }
    
    static func profession() -> GREditProfileTableCellView {
        let cell = GREditProfileTableCellView()
        cell.title = "Professione"
        cell.subtitle = "Non specificata"
        cell.icon = UIImage(named: "icon_professionep")
        cell.showGrayBadge()
        return cell
    }
    
    static func qualification() -> GREditProfileTableCellView {
        let cell = GREditProfileTableCellView()
        cell.title = "Titolo di studio"
        cell.subtitle = "Non specificato"
        cell.icon = UIImage(named: "icon_studiop")
        cell.showGrayBadge()
        return cell
    }
    
    static func family() -> GREditProfileTableCellView {
        let cell = GREditProfileTableCellView()
        cell.title = "Nucleo familiare"
        cell.subtitle = "Non specificato"
        cell.icon = UIImage(named: "icon_familyp")
        cell.showGrayBadge()
        return cell
    }
    
}
