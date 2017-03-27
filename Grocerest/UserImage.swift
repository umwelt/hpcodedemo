//
//  UserImage.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 18/08/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit
import SnapKit
import Haneke

enum AvatarType {
    case menu
    case profile
    case cells
    case small
}

// REFACTORING TODO: create a new cleaner UserImage widget. It will
// be a UIView and it won't have pre-fixed dimensions. It will simply
// scale according to the dimensions it will be given by whatever view
// that uses it.
class UserImage: UIControl {
    
    var avatarType = AvatarType.menu
    
    fileprivate lazy var userProfileImage : UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    fileprivate lazy var generatedUserProfileImage: UILabel = {
        let label = UILabel()
        label.layer.borderWidth = 1.0
        label.layer.masksToBounds = false
        label.clipsToBounds = true
        label.textAlignment = .center
        label.numberOfLines = 2
        
        
        return label
    }()
    
    // - MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}

extension UserImage {
    
    fileprivate var userImage: UIImage? {
        
        get{
            return userProfileImage.image
        }
        set(newImage){
            userProfileImage.image = newImage
        }
    }
    
    fileprivate var userInitials: String? {
        get{
            return generatedUserProfileImage.text
        }
        set(newText){
            generatedUserProfileImage.text = newText
        }
    }
    
    fileprivate var onImageColor: CGColor? {
        get {
            return userProfileImage.layer.borderColor
        }
        set(newColor) {
            userProfileImage.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    fileprivate var white : UIColor {
        return UIColor.white
    }
    
    fileprivate var grocerest: UIColor {
        return UIColor.grocerestColor()
    }
    
    fileprivate var menuSize: CGSize {
        return CGSize.menuProfileAvatar
    }
    
    fileprivate var profileSize: CGSize {
        return CGSize.largeProfileAvatar
    }
    
    fileprivate var cellsSize: CGSize {
        return CGSize.cellProfileAvatar
    }
    
    fileprivate var smallSize: CGSize {
        return CGSize.smallProfileAvatar
    }
    
    
}

extension UserImage {
    
    //: MARK - Public API
    
    func setUserProfileAvatar(_ url: String, name: String, lastName:String, type: AvatarType){
        avatarType = type
        if url == "" {
            formatAvatarLabel(name, lastName: lastName)
        } else {
            fromStringURL(url, name: name, lastName: lastName)
        }
    }
    
    func onEditionPreviewPhoto(_ image: UIImage) {
        userImage = image
    }
 
}

extension UserImage {
    
    fileprivate func formatAvatar() {
        
        generatedUserProfileImage.removeFromSuperview()
        addSubview(userProfileImage)

        switch avatarType {
            
        case .menu:
            
            typePhotoBasedAvatarFormating(menuSize)
            
            return
        case .profile:
            
            typePhotoBasedAvatarFormating(profileSize)

            return
        case .cells:
            
            typePhotoBasedAvatarFormating(cellsSize)
            
            return
        case .small:
            
            typePhotoBasedAvatarFormating(smallSize)
            
            return
        }
        
    }
    
    fileprivate func formatAvatarLabel(_ name: String, lastName: String) {
        
        userProfileImage.removeFromSuperview()
        addSubview(generatedUserProfileImage)
        
        userInitials = formatInitials(name, lastName: lastName)
        
        switch avatarType {
            
        case .menu:

            typeLabelBasedAvatarFormating(white, borderColor: grocerest, font: UIFont.menuAvatarFont(36), size: menuSize)
            
            return
        case .profile:

            typeLabelBasedAvatarFormating(white, borderColor: white, font: UIFont.menuAvatarFont(76), size: profileSize)
            
            return
        case .cells:

            typeLabelBasedAvatarFormating(grocerest, borderColor: grocerest, font: UIFont.menuAvatarFont(28), size: cellsSize)
            
            return
        case .small:
        
            typeLabelBasedAvatarFormating(grocerest, borderColor: grocerest, font: UIFont.menuAvatarFont(14), size: smallSize)
        
            return
        }
    
    }
    
    fileprivate func typePhotoBasedAvatarFormating(_ size: CGSize) {
        
        userProfileImage.layer.borderWidth = 0
        userProfileImage.layer.borderColor = UIColor.clear.cgColor
        
        userProfileImage.layer.cornerRadius = size.width / 2
        
        userProfileImage.snp.makeConstraints { (make) in
            make.size.equalTo(size)
            make.center.equalTo(self.snp.center)
        }
    }
    
    fileprivate func typeLabelBasedAvatarFormating(_ textColor: UIColor, borderColor:UIColor, font: UIFont, size: CGSize) {
        
        generatedUserProfileImage.snp.makeConstraints { (make) in
            make.size.equalTo(size)
            make.center.equalTo(self.snp.center)
        }
        
        generatedUserProfileImage.textColor = textColor
        generatedUserProfileImage.layer.borderColor = borderColor.cgColor
        generatedUserProfileImage.layer.cornerRadius = size.width / 2
        generatedUserProfileImage.font = font
    }
    
    fileprivate func formatInitials(_ name:String, lastName: String) -> String {
        
        if name != "" {
            return "\(String(name[name.characters.index(name.startIndex, offsetBy: 0)]).uppercased())\(String(lastName[lastName.characters.index(lastName.startIndex, offsetBy: 0)]).uppercased())"
        }
        
        return ""
        
    }
    
    
    fileprivate func fromStringURL(_ url: String, name: String, lastName:String) {
        
        let format = Format<UIImage>(name: "profilePicture")
        
        func onImageReady(_ image: UIImage) {
            _ = image.size
            userImage = image
            formatAvatar()
        }
        
        userProfileImage.hnk_setImageFromURL(
            formatURLStringForPicture(url),
            placeholder: nil,
            format: format,
            failure: { error in
                self.formatAvatarLabel(name, lastName: lastName)
            },
            success: onImageReady)
        
    }
    
    fileprivate func formatURLStringForPicture(_ imageName:String) -> URL {
        
        var imageUrl = URL(string: imageName)!
        let types: NSTextCheckingResult.CheckingType = .link
        let detector = try? NSDataDetector(types: types.rawValue)
        
        guard let detect = detector else { return imageUrl }
        
        let matches = detect.matches(in: imageName, options: .reportCompletion, range: NSMakeRange(0, imageName.characters.count))
        
        if matches.count > 0 {
            for match in matches {
                imageUrl = URL(string: "\(match.url!)")!
            }
        } else {
            imageUrl = URL(string:"\(getUserImagesPath())/\(imageName)")!
        }
        
        return imageUrl
        
    }
}
