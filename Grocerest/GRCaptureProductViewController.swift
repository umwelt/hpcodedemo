//
//  GRCaptureProductViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 05/02/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import AVFoundation
import Alamofire
import SwiftLoader
import AudioToolbox

class GRCaptureProductViewController: UIViewController, UITextFieldDelegate {
    
    var imageURLString = ""
    var tapGesture = UITapGestureRecognizer()
    let session = AVCaptureSession()
    var captureButton = UIButton()
    var scannerArea = UIImageView()
    var searchedString = ""
    var currentImage:UIImage = UIImage()
    var flashView = UIView()
    
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCamera()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate var managedView: GRCaptureProductView {
        return self.view as! GRCaptureProductView
    }
    
    override func loadView() {
        super.loadView()
        view = GRCaptureProductView()
        managedView.delegate = self
    }
    
    func setupViews() {
        let devices = AVCaptureDevice.devices().filter{ ($0 as AnyObject).hasMediaType(AVMediaTypeVideo) && ($0 as AnyObject).position == AVCaptureDevicePosition.back }
        if let captureDevice = devices.first as? AVCaptureDevice  { // TODO: and if not ??
            
            captureSession.addInput(try! AVCaptureDeviceInput(device: captureDevice))
            captureSession.sessionPreset = AVCaptureSessionPresetMedium
            captureSession.startRunning()
            
            let maskView = UIView()
            self.managedView.addSubview(maskView)
            maskView.backgroundColor = UIColor.clear
            maskView.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(self.view)
            }
            
            
            let lightImageView = UIImageView()
            maskView.addSubview(lightImageView)
            maskView.backgroundColor = UIColor.clear
            lightImageView.snp.makeConstraints { (make) -> Void in
                make.height.width.equalTo(56 / masterRatio)
                make.top.left.equalTo(47 / masterRatio)
            }
            lightImageView.contentMode = .scaleAspectFit
            lightImageView.image = UIImage(named: "light")
            
            let torchButton = UIButton()
            maskView.addSubview(torchButton)
            torchButton.snp.makeConstraints { (make) -> Void in
                make.height.width.equalTo(56 / masterRatio)
                make.top.left.equalTo(47 / masterRatio)
            }
            torchButton.addTarget(self, action: #selector(GRCaptureProductViewController.torcheOn), for: .touchUpInside)
            maskView.bringSubview(toFront: torchButton)
            
            let closeButton = UIButton()
            maskView.addSubview(closeButton)
            closeButton.snp.makeConstraints { (make) -> Void in
                make.height.width.equalTo(100 / masterRatio)
                make.top.equalTo(27 / masterRatio)
                make.right.equalTo(-27 / masterRatio)
            }
            closeButton.contentMode = .center
            closeButton.setImage(UIImage(named: "white_close"), for: UIControlState())
            closeButton.addTarget(self, action: #selector(GRCaptureProductViewController.actionCloseButtonWasPressed(_:)), for: .touchUpInside)
            
            
            scannerArea = UIImageView()
            maskView.addSubview(scannerArea)
            scannerArea.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(582 / masterRatio)
                make.height.equalTo(300 / masterRatio)
                make.top.equalTo(533 / masterRatio)
                make.centerX.equalTo(self.view.snp.centerX)
            }
            scannerArea.contentMode = .scaleAspectFit
            scannerArea.image = UIImage(named: "target_product")
            
            
            captureButton = UIButton(type: .custom)
            maskView.addSubview(captureButton)
            captureButton.snp.makeConstraints { (make) -> Void in
                make.width.height.equalTo(168 / masterRatio)
                make.centerX.equalTo(self.view.snp.centerX)
                make.bottom.equalTo(self.view.snp.bottom).offset(-40 / masterRatio)
            }
            captureButton.contentMode = .scaleAspectFit
            captureButton.setImage(UIImage(named: "shutter"), for: UIControlState())
            captureButton.addTarget(self, action: #selector(GRCaptureProductViewController.saveToCamera(_:)), for: .touchUpInside)
            
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
            
            
            
            
            
            if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                previewLayer.bounds = view.bounds
                previewLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                let cameraPreview = UIView()
                self.view.addSubview(cameraPreview)
                cameraPreview.snp.makeConstraints({ (make) -> Void in
                    make.edges.equalTo(self.view)
                })
                
                
                cameraPreview.layer.addSublayer(previewLayer)
                cameraPreview.addSubview(maskView)
                self.view.bringSubview(toFront: maskView)
                
            }
            
        } else {
            
            
        }
    
    }
    
    func saveToCamera(_ sender: UIButton) {
        // Play the camera shutter system sound
        // AudioServicesPlayAlertSound(1108)
        
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) { imageDataSampleBuffer, error in
                if let buffer = imageDataSampleBuffer,
                   let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer),
                   let image = UIImage(data: imageData) {
                    self.scannerArea.isHidden = true
                    self.captureButton.isHidden = true
                    self.captureSession.stopRunning()
                    self.processingImageView(image)
                }
            }
        }
    }
    
    func torcheOn () {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureTorchMode.on) {
                    device?.torchMode = AVCaptureTorchMode.off
                } else {
                    try device?.setTorchModeOnWithLevel(0.5)
                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    func actionCloseButtonWasPressed(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)

    
    func processingImageView(_ image:UIImage) {
        self.currentImage = image
        let viewBlurredBackground = UIVisualEffectView(effect: blurEffect)
        self.view.addSubview(viewBlurredBackground)
        viewBlurredBackground.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
        let closeButton = UIButton(type: .custom)
        viewBlurredBackground.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100 / masterRatio)
            make.right.equalTo(viewBlurredBackground.snp.right).offset(-40 / masterRatio)
            make.top.equalTo(viewBlurredBackground.snp.top).offset(40 / masterRatio)
        }
        closeButton.contentMode = .center
        closeButton.setImage(UIImage(named: "white_close"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(GRCaptureProductViewController.actionCloseCameraView(_:)), for: .touchUpInside)
        
        let containerView = UIView()
        viewBlurredBackground.addSubview(containerView)
        containerView.backgroundColor = UIColor.white
        containerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(686 / masterRatio)
            make.height.equalTo(447 / masterRatio)
            make.centerX.equalTo(viewBlurredBackground.snp.centerX)
            make.top.equalTo(130 / masterRatio)
        }
        containerView.layer.cornerRadius = 4
        
        let imageView = UIImageView()
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(218 / masterRatio)
            make.height.equalTo(280 / masterRatio)
            make.left.equalTo(40 / masterRatio)
            make.top.equalTo(self.managedView.snp.top).offset(259 / masterRatio)
        }
        imageView.contentMode = .scaleAspectFit
        DispatchQueue.main.async { () -> Void in
            imageView.image = image
        }
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.isOpaque = false
        imageView.layer.cornerRadius = 6
        
        
        let prodottoLabel = UILabel()
        containerView.addSubview(prodottoLabel)
        prodottoLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(containerView.snp.top).offset(34 / masterRatio)
            make.left.equalTo(imageView.snp.left)
            make.bottom.equalTo(imageView.snp.top).offset(-34 / masterRatio)
        }
        prodottoLabel.text = "Associa prodotto"
        prodottoLabel.font = Constants.BrandFonts.ubuntuLight18
        prodottoLabel.textColor = UIColor.grocerestColor()
        prodottoLabel.textAlignment = .left
        
        
        let prodottoTextField = UITextField()
        containerView.addSubview(prodottoTextField)
        prodottoTextField.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(332 / masterRatio)
            make.height.equalTo(78 / masterRatio)
            make.left.equalTo(imageView.snp.right).offset(34 / masterRatio)
            make.top.equalTo(imageView.snp.top).offset(10 / masterRatio)
        }
        prodottoTextField.textColor = UIColor.grocerestLightGrayColor()
        prodottoTextField.textAlignment = .left
        prodottoTextField.font = Constants.BrandFonts.avenirBook15
        prodottoTextField.placeholder = "Nome Prodotto"
        prodottoTextField.tag = 0
        prodottoTextField.delegate = self
        prodottoTextField.addTarget(self, action: #selector(GRCaptureProductViewController.textWasEntered(_:)), for: .allEditingEvents)
        prodottoTextField.returnKeyType = .go
        prodottoTextField.text = searchedString
        
        let separator = UIView()
        containerView.addSubview(separator)
        separator.backgroundColor = UIColor.lightGray
        separator.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(prodottoTextField.snp.width)
            make.height.equalTo(0.5)
            make.top.equalTo(prodottoTextField.snp.bottom).offset(10 / masterRatio)
            make.left.equalTo(prodottoTextField.snp.left)
        }
        
        let brandTextField = UITextField()
        containerView.addSubview(brandTextField)
        brandTextField.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(332 / masterRatio)
            make.height.equalTo(78 / masterRatio)
            make.left.equalTo(prodottoTextField.snp.left)
            make.top.equalTo(separator.snp.bottom).offset(10 / masterRatio)
        }
        brandTextField.textColor = UIColor.grocerestLightGrayColor()
        brandTextField.textAlignment = .left
        brandTextField.font = Constants.BrandFonts.avenirBook15
        brandTextField.placeholder = "Marca"
        brandTextField.tag = 1
        brandTextField.delegate = self
        brandTextField.addTarget(self, action: #selector(GRCaptureProductViewController.textWasEntered(_:)), for: .allEditingEvents)
        brandTextField.returnKeyType = .go
        
        let separatorb = UIView()
        containerView.addSubview(separatorb)
        separatorb.backgroundColor = UIColor.lightGray
        separatorb.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(prodottoTextField.snp.width)
            make.height.equalTo(0.5)
            make.top.equalTo(brandTextField.snp.bottom).offset(10 / masterRatio)
            make.left.equalTo(prodottoTextField.snp.left)
        }
        
        
        let confezioneTextField = UITextField()
        containerView.addSubview(confezioneTextField)
        confezioneTextField.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(332 / masterRatio)
            make.height.equalTo(78 / masterRatio)
            make.left.equalTo(prodottoTextField.snp.left)
            make.top.equalTo(separatorb.snp.bottom).offset(10 / masterRatio)
        }
        confezioneTextField.textColor = UIColor.grocerestLightGrayColor()
        confezioneTextField.textAlignment = .left
        confezioneTextField.font = Constants.BrandFonts.avenirBook15
        confezioneTextField.placeholder = "Confezione"
        confezioneTextField.tag = 2
        confezioneTextField.delegate = self
        confezioneTextField.addTarget(self, action: #selector(GRCaptureProductViewController.textWasEntered(_:)), for: .allEditingEvents)
        confezioneTextField.returnKeyType = .go
        
        
        
        
    }
    
    
    var brandName = ""
    var ean = ""
    var confezione = ""
    
    
    func textWasEntered(_ sender:UITextField) {
        switch sender.tag {
        case 0:
            searchedString = sender.text!
        case 1:
            brandName = sender.text!
        case 2:
            confezione = sender.text!
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendData()
        return true
    }
    
    func sendData(){
        let fields = [
            "name": searchedString,
            "brand": brandName,
            "ean": ean,
            "packagingType": confezione
        ]
        
        GrocerestAPI.productProposal(fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            self.sendImage(data["_id"].string!)
        }
    }
    
    func sendImage(_ proposalId:String) {
        SwiftLoader.show(title: "Invio in corso…", animated: false)
        
        let url:URL = URL(string: "\(GrocerestAPI.API_URL)amendment/product-proposal/\(proposalId)/picture")!
        let fileName = "image"
        let image = self.currentImage
        // TODO: scale down image size
        // handle orientation ?
        // crop ? holy fuck !
        let data:Data = UIImageJPEGRepresentation(image, 1.0)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
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
            
            if (data != nil) {
                OperationQueue.main.addOperation {
                    SwiftLoader.hide()
                }
                
            }
            
            if (response != nil) {
                
                OperationQueue.main.addOperation {
                    SwiftLoader.hide()
                    self.presentMarioModal()
                }
                
            }
        
            if error != nil {
                OperationQueue.main.addOperation {
                    SwiftLoader.hide()
                }
            }
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

    fileprivate func showValidationAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in
            self.navigationController?.popToRootViewController(animated: false)
        }
        alert.addAction(action)
        DispatchQueue.main.async { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func actionCloseCameraView(_ sender:UIButton){
        self.navigationController?.popViewController(animated: false)
    }
    
    var wholeView = UIView()
    
    func presentMarioModal() {
        
        
        self.view.addSubview(wholeView)
        wholeView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        wholeView.backgroundColor = UIColor.clear
        
        let viewBlurredBackground = UIVisualEffectView(effect: blurEffect)
        wholeView.addSubview(viewBlurredBackground)
        viewBlurredBackground.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
        let viewWithVibrancy = UIVisualEffectView(effect: blurEffect)
        viewBlurredBackground.contentView.addSubview(viewWithVibrancy)
        viewWithVibrancy.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
        let hugePoints = UIImageView()
        viewWithVibrancy.addSubview(hugePoints)
        hugePoints.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(335 / masterRatio)
            make.height.equalTo(125 / masterRatio)
            make.centerX.equalTo(viewBlurredBackground.snp.centerX)
            make.top.equalTo(303 / masterRatio)
        }
        hugePoints.contentMode = .scaleAspectFit
        hugePoints.image = UIImage(named: "huge_twelve")
        
        let thanksLabel = UILabel()
        viewWithVibrancy.addSubview(thanksLabel)
        thanksLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(hugePoints.snp.bottom).offset(22 /  masterRatio)
            make.centerX.equalTo(hugePoints.snp.centerX)
        }
        thanksLabel.text = "Grazie \(username!)!"
        thanksLabel.font = Constants.BrandFonts.avenirLight30
        thanksLabel.textColor = UIColor.grocerestBlue()
        thanksLabel.textAlignment = .center
        
        
        let noticeLabel = UILabel()
        viewWithVibrancy.addSubview(noticeLabel)
        noticeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(thanksLabel.snp.bottom).offset(26 /  masterRatio)
            make.centerX.equalTo(hugePoints.snp.centerX)
        }
        noticeLabel.text = "Il prodotto è stato inviato alla redazione."
        noticeLabel.font = Constants.BrandFonts.avenirLight16
        noticeLabel.textColor = UIColor.white
        noticeLabel.textAlignment = .center
        
        
        let assocLabel = UILabel()
        viewWithVibrancy.addSubview(assocLabel)
        assocLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(noticeLabel.snp.bottom).offset(193 /  masterRatio)
            make.centerX.equalTo(hugePoints.snp.centerX)
            make.width.equalTo(667 / masterRatio)
        }
        
        assocLabel.text = "Se l’associazione del codice a barre verrà approvata, sarai subito informato e ti saranno riconosciuti 12 punti reputation."
        assocLabel.numberOfLines = 3
        assocLabel.font = Constants.BrandFonts.avenirLight13
        assocLabel.textColor = UIColor.white
        assocLabel.textAlignment = .center
        
        let button = UIButton(type: .custom)
        viewWithVibrancy.addSubview(button)
        button.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(174 / masterRatio)
            make.height.equalTo(68 / masterRatio)
            make.centerX.equalTo(viewWithVibrancy.snp.centerX)
            make.top.equalTo(assocLabel.snp.bottom).offset(59 / masterRatio)
        }
        button.setTitle("OK", for: UIControlState())
        button.titleLabel?.font = Constants.BrandFonts.avenirBook11
        button.setTitleColor(UIColor.grocerestBlue(), for: UIControlState())
        button.setBackgroundImage(UIImage(named: "small_blue"), for: UIControlState())
        button.addTarget(self, action: #selector(GRCaptureProductViewController.okProductWasPressed(_:)), for: .touchUpInside)
        
    }
    
    func okProductWasPressed(_ sender:UIButton) {
        wholeView.removeFromSuperview()
        self.navigationController?.popToRootViewController(animated: false)
        
    }
    
    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authStatus {
        case .authorized: break // Do you stuffer here i.e. allowScanning()
        case .denied: alertToEncourageCameraAccessInitially()
        case .notDetermined: alertPromptToAllowCameraAccessViaSetting()
        default: alertToEncourageCameraAccessInitially()
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "Importante",
            message: "Vuoi accedere alla fotocamera",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Non autorizzare", style: .default, handler: { (alert) -> Void in
            if (self.navigationController != nil) {
                self.navigationController?.popViewController(animated: false)
                return
            }
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Autorizza", style: .cancel, handler: { (alert) -> Void in
            
            if (self.navigationController != nil) {
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                self.navigationController?.popViewController(animated: false)
                return
            }
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let alert = UIAlertController(
            title: "Attenzione",
            message: "Permette accesso alla fotocamera",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Cancella", style: .cancel) { alert in
            if AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count > 0 {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
                    DispatchQueue.main.async {
                        self.checkCamera() } }
            }
            }
        )
        present(alert, animated: true, completion: nil)
    }


    

}
