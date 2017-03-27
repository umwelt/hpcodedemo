//
//  GREditProfileViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 19/02/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Haneke
import RealmSwift
import SwiftLoader
import AVFoundation
import MobileCoreServices

class GREditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let realm = try! Realm()
    var userData: JSON? {
        didSet {
            self.managedView.userData = self.userData
            self.setupCallbacks()
        }
    }
    var userCategories = [String]()
    var currentImage:UIImage = UIImage()
    
    var delegate : GRProfileUpdateProtocol?
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    fileprivate var managedView: GREditProfileView {
        return self.view as! GREditProfileView
    }
    
    override func loadView() {
        super.loadView()
        view = GREditProfileView()
        managedView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        self.setupCallbacks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userCategories.removeAll()
    }
    
    func setupViews() {
        //. 0 Image
        let type = AvatarType.cells
        managedView.profileImageView.setUserProfileAvatar(GRUser.sharedInstance.picture!, name: GRUser.sharedInstance.firstname!, lastName: GRUser.sharedInstance.lastname!, type: type)

    }
    
    func closeButtonWasPressed(_ sender:UIButton){
        self.dismiss(animated: true, completion: { () -> Void in
            self.delegate?.formatUserProfile()
        })
    }
    
    func getUserData() {
        GrocerestAPI.getUser(GrocerestAPI.userId!) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            self.userData = data
            self.setupViews()
            
            for category in data["categories"].arrayValue {
               self.userCategories.append(category.string!)
            }
            
            persistUserWithData(data)
        }
    }
    
    // MARK: Image picker
    
    func editUserPhoto(_ sender:UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        dismiss(animated: true) { () -> Void in
            self.managedView.profileImageView.layoutIfNeeded()
            // Set Image manually
            self.managedView.profileImageView.onEditionPreviewPhoto(image)
            self.currentImage = self.resizeImage(image, newWidth: 400)
            self.sendImage()
        }
    }
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func sendImage() {
        SwiftLoader.show(title: "Sending Image", animated: true)

        let url:URL = URL(string: "\(GrocerestAPI.API_URL)user/\(GrocerestAPI.userId!)/picture")!
        let fileName = "image"
        let image = self.currentImage
        // TODO: scale down image size
        // handle orientation ?
        let data:Data = UIImageJPEGRepresentation(image, 1.0)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = "PUT"
        
        let boundary = "----------V2ymHFg03esomerandomstuffhbqgZCaKO6jy";
        let fullData = self.photoDataToFormData(data, boundary:boundary, fileName:fileName)
        
        request.setValue("Bearer \(GrocerestAPI.bearerToken!)", forHTTPHeaderField: "Authorization")
        
        request.setValue("multipart/form-data; boundary=" + boundary,
            forHTTPHeaderField: "Content-Type")
        
        request.setValue(String(fullData.count), forHTTPHeaderField: "Content-Length")
        
        request.httpBody = fullData
        request.httpShouldHandleCookies = false
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                if let errorMessage = error?.localizedDescription {
                    print("error: \(errorMessage)")
                }
                DispatchQueue.main.async { SwiftLoader.hide() }
                return
            }
            
            DispatchQueue.main.async { SwiftLoader.hide() }
            self.userState()
        }) 
        
        dataTask.resume()
    }
    
    func photoDataToFormData(_ data:Data,boundary:String,fileName:String) -> Data {
        let fullData = NSMutableData()
        
        // 1 - Boundary should start with -
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.append(lineTwo.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 4
        fullData.append(data)
        
        // 5
        let lineFive = "\r\n"
        fullData.append(lineFive.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        return fullData as Data
    }

    func userState() {
        GrocerestAPI.getUser(GrocerestAPI.userId!) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            if let picture = data["picture"].string {
                print("my photo: \(data["picture"].string)")
                let cache = Haneke.Shared.imageCache
                cache.remove(key: picture, formatName: "profilePicture")
                cache.removeAll()
            }
            
            persistUserWithData(data)
            self.setupViews()
        }
    }
    
    func setupCallbacks() {
        let table = managedView.tableView
        
        table.favoriteCategories.onTap = {
            let categoriesViewController = GRCategoryListViewController()
            categoriesViewController.onEdition = true
            self.present(categoriesViewController, animated: true, completion: nil)
        }
        
        table.password.onTap = {
            GRPasswordChangeAlertViewController.show { password in
                if password != nil {
                    GrocerestAPI.changePassword(GrocerestAPI.userId!, fields: ["new_password": password!]) { res, err in
                        if res.count == 0 {
                            let alert = UIAlertController(title: "Cambio password", message: "Password cambiata con successo.", preferredStyle: .alert)
                            let dismissAlertAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                                alert.dismiss(animated: true, completion: nil)
                            })
                            alert.addAction(dismissAlertAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
        table.firstName.onTap = {
            if self.userData != nil {
                GRNameChangeAlertViewController.show(title: "Cambia il nome", name: self.userData!["firstname"].stringValue, placeholder: "Nome", errorMessage: "Il nome non può essere vuoto") { firstname in
                    if firstname != nil && self.userData!["firstname"].stringValue != firstname! {
                        GrocerestAPI.updateUser(GrocerestAPI.userId!, fields: ["firstname": firstname!])
                        self.userData!["firstname"].string = firstname!
                    }
                }
            }
        }
        
        table.secondName.onTap = {
            if self.userData != nil {
                GRNameChangeAlertViewController.show(title: "Cambia il cognome", name: self.userData!["lastname"].stringValue, placeholder: "Cognome", errorMessage: "Il cognome non può essere vuoto") { lastname in
                    if lastname != nil && self.userData!["lastname"].stringValue != lastname! {
                        GrocerestAPI.updateUser(GrocerestAPI.userId!, fields: ["lastname": lastname!])
                        self.userData!["lastname"].string = lastname!
                    }
                }
            }
        }
        
        table.birthdate.onTap = {
            var birthdate: Date? = nil
            if self.userData != nil && !self.userData!["birthdate"].stringValue.isEmpty {
                birthdate = Date(timeIntervalSince1970: Double(self.userData!["birthdate"].stringValue)! / 1000)
            }
            GRDateSelectorAlertViewController.show(title: "Data di nascita", unspecifiedButtonText: "Nessuna data", initialDate: birthdate) { date in
                if let date = date {
                    let unixTime = Int(date.timeIntervalSince1970 * 1000)
                    self.userData?["birthdate"].string = String(unixTime)
                    GrocerestAPI.updateUser(GrocerestAPI.userId!, fields: ["birthdate": unixTime])
                } else {
                    self.userData?["birthdate"].string = nil
                    // TODO: why not nil?
                    GrocerestAPI.updateUser(GrocerestAPI.userId!, fields: ["birthdate": NSNull()])
                }
            }
        }
        
        table.gender.onTap = {
            let data = ["Maschio","Femmina"]
            var selected: String?
            if let previousGender = self.userData?["gender"].string {
                selected = (previousGender == "F" ? "Femmina" : "Maschio")
            }
            GRSelectorAlertViewController.show(title: "Sesso", unspecifiedButtonText: "Non specificato", data: data, selected: selected) { gender in
                if gender != nil {
                    let oneLetterGender = (gender! == "Maschio" ? "M" : "F")
                    GrocerestAPI.updateUser(GrocerestAPI.userId!, fields: ["gender": oneLetterGender])
                    self.userData?["gender"].string = oneLetterGender
                } else {
                    GrocerestAPI.updateUser(GrocerestAPI.userId!, fields: ["gender": ""])
                    self.userData?["gender"].string = nil
                }
            }
        }
        
        table.family.onTap = {
            let data = ["Single", "Coppia", "Con figli"]
            GRSelectorAlertViewController.show(title: "Nucleo familiare", unspecifiedButtonText: "Non specificato", data: data, selected: self.userData?["family"].string) { family in
                if family != nil {
                    GrocerestAPI.updateUser(GrocerestAPI.userId!, fields: ["family": family!])
                } else {
                    GrocerestAPI.updateUser(GrocerestAPI.userId!, fields: ["family": ""])
                }
                self.userData?["family"].string = family
            }
        }
    }

}
