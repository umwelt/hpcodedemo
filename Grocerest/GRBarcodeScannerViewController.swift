//
//  GRBarcodeScanner.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 30/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import AVFoundation
import UIKit
import RealmSwift
import Google
import RealmSwift
import FBSDKCoreKit
import FBSDKLoginKit
import RealmSwift
import SwiftLoader
import AudioToolbox

class GRBarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, GRUserCategorizedProductsProtocol {
 
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let realm = try! Realm()
    var scannerArea : UIImageView?
    var bottomView : UIView?
    var foundEan: String?
    
    var fromProfile = false
    
    var delegate = GRModalRecensioneViewController()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCamera()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
        
        do {
            try videoCaptureDevice.lockForConfiguration()
            // When this point is reached, we can be sure that the locking succeeded
            if videoCaptureDevice.isFocusModeSupported(.continuousAutoFocus) {
                videoCaptureDevice.focusMode = .continuousAutoFocus
            }
            videoCaptureDevice.unlockForConfiguration()
        } catch {
            // handle error
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode39Mod43Code,
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeCode93Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypePDF417Code,
                AVMetadataObjectTypeQRCode,
                AVMetadataObjectTypeAztecCode,
                AVMetadataObjectTypeDataMatrixCode]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds

        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        
        let rectOfInterest : CGRect = previewLayer.metadataOutputRectOfInterest(for: view.frame)
        previewLayer.backgroundColor = UIColor.red.withAlphaComponent(0.5).cgColor
        
        metadataOutput.rectOfInterest = rectOfInterest
        
        captureSession.startRunning();
        
        let maskView = UIView()
        self.view.addSubview(maskView)
        maskView.backgroundColor = UIColor.clear
        maskView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        let lightImageView = UIImageView()
        maskView.addSubview(lightImageView)
        lightImageView.snp.makeConstraints { make in
            make.height.width.equalTo(56 / masterRatio)
            make.top.left.equalTo(47 / masterRatio)
        }
        lightImageView.contentMode = .scaleAspectFit
        lightImageView.image = UIImage(named: "light")
        
        let torchButton = UIButton()
        maskView.addSubview(torchButton)
        torchButton.snp.makeConstraints { make in
            make.height.width.equalTo(56 / masterRatio)
            make.top.left.equalTo(47 / masterRatio)
        }
        torchButton.addTarget(self, action: #selector(self.torchOn), for: .touchUpInside)
        maskView.bringSubview(toFront: torchButton)
        
        let closeButton = UIButton()
        maskView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(56 / masterRatio)
            make.top.equalTo(47 / masterRatio)
            make.right.equalTo(-47 / masterRatio)
        }
        closeButton.contentMode = .center
        closeButton.setImage(UIImage(named: "white_close"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(self.actionCloseButtonWasPressed(_:)), for: .touchUpInside)
        
        
        scannerArea = UIImageView()
        maskView.addSubview(scannerArea!)
        scannerArea!.snp.makeConstraints { make in
            make.width.equalTo(582 / masterRatio)
            make.height.equalTo(300 / masterRatio)
            make.top.equalTo(533 / masterRatio)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        scannerArea!.contentMode = .scaleAspectFit
        scannerArea!.image = UIImage(named: "scanner_pointer")
        
        bottomView = UIView()
        maskView.addSubview(bottomView!)
        bottomView!.snp.makeConstraints { make in
            make.width.equalTo(self.view)
            make.bottom.equalTo(0)
            make.height.equalTo(120 / masterRatio)
        }
        bottomView!.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        
        let bottomLabel = UILabel()
        bottomView!.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView!.snp.centerY)
            make.centerX.equalTo(bottomView!.snp.centerX)
            make.width.equalTo(430 / masterRatio)
            make.height.equalTo(40 / masterRatio)
        }
        bottomLabel.font = Constants.BrandFonts.ubuntuLight18
        bottomLabel.textColor = UIColor.grocerestDarkBoldGray()
        bottomLabel.textAlignment = .center
        bottomLabel.text = "Inquadra il codice a barre"

        self.view.bringSubview(toFront: maskView)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
            scannerArea?.isHidden = false
            bottomView?.isHidden = false
        }
        
        self.title = "Barcode Scanner View"
        let name = "Pattern~\(self.title!)"
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as [NSObject: AnyObject]?)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
            scannerArea?.isHidden = true
            bottomView?.isHidden = true
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        captureSession.stopRunning()
        var ean = ""
        
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            print("No QR code is detected")
            return
        }
        
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            ean = readableObject.stringValue
            print("EAN: \(ean)")
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            foundEan = ean
        }
        
        scannerArea?.isHidden = true
        bottomView?.isHidden = true
        
        if fromProfile {
            self.delegate.foundedEAN(ean)
            self.dismiss(animated: false, completion: nil)
            return            
        }
        
        GrocerestAPI.searchProductsForList(GRUser.sharedInstance.id!, fields: ["ean": ean]) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                let e = data["error"]["code"].stringValue
                
                if e == "E_INTERNAL" {
                    self.showValidationAlertWithTitleAndMessage("Attenzione", message: "Codice a barre non supportato")
                } else if e == "E_UNAUTHORIZED" {
                    self.noUserOrInvalidToken()
                }
                
                return
            }
            
            if let product = data["items"].arrayValue.first {
                // Found product associated with barcode
                
                self.addToScannedList(product["_id"].stringValue)
                
                DispatchQueue.main.async {
                    getUserProductsList()
                    
                    let moreActionsForProduct = GRSingleProductMoreActionsModalViewController()
                    moreActionsForProduct.product = product
                    moreActionsForProduct.delegate = self
                    moreActionsForProduct.modalTransitionStyle = .crossDissolve
                    moreActionsForProduct.modalPresentationStyle = .overCurrentContext
                    self.present(moreActionsForProduct, animated: true)
                }
            } else {
                // No associated product found
                
                DispatchQueue.main.async {
                    let productNotFound = GRScannedProductNotFoundView()
                    productNotFound.onBackgroundTap = { self.dismiss() }
                    productNotFound.onButtonTap = {
                        productNotFound.removeFromSuperview()
                        
                        SwiftLoader.show(animated: true)
                        
                        let captureImage = GRCaptureProductViewController()
                        captureImage.ean = self.foundEan!
                        
                        SwiftLoader.hide()
                        
                        self.navigationController?.pushViewController(captureImage, animated: false)
                    }
                    
                    self.view.addSubview(productNotFound)
                }
            }
        }
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    func actionCloseButtonWasPressed(_ sender:UIButton) {
        dismiss()
    }
    
    // Exit from barcode scanner
    private func dismiss() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: false)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func torchOn() {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureTorchMode.on) {
                    device?.torchMode = AVCaptureTorchMode.off
                } else {
                    try device?.setTorchModeOnWithLevel(0.2)
                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    /**
     Current configuration
     
     - returns: ProductImagesUrl
     */
    func getCurrentConfiguration() -> String {
        let configuration = realm.objects(GrocerestConfiguration.self)
        return configuration[0].productImagesBaseUrl
    }
    
    func addToScannedList(_ productId:String) {
        GrocerestAPI.addProductToPredefinedList(GRUser.sharedInstance.id!, listName: "scanned", fields: ["product": productId])
    }
    
    func restartScanner() {
        captureSession.startRunning()
        scannerArea!.isHidden = false
        bottomView!.isHidden = false
    }
    
    func reloadDataSourceForList(_ name: String) {
    }
    
    func noUserOrInvalidToken() {
        let welcomeViewController = GRWelcomeViewController()
        
        try! self.realm.write {
            self.realm.deleteAll()
        }
                
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "bearerToken")
        defaults.removeObject(forKey: "userId")
        defaults.synchronize()
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()

        self.navigationController!.setViewControllers([welcomeViewController], animated: true)
    }
    
    
    func showValidationAlertWithTitleAndMessage(_ title: String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { alert in
            self.restartScanner()
        })
        
        present(alert, animated: true, completion: nil)
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
            title: "Attenzione",
            message: "Per effettuare la scansione del codice a barre è necessario accedere alla fotocamera.",
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(UIAlertAction(title: "Non autorizzare", style: .default) { alert in
            self.navigationController?.popViewController(animated: false)
        })
        
        
        alert.addAction(UIAlertAction(title: "Autorizza", style: .cancel) { alert in
            if self.navigationController != nil {
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                self.navigationController?.popViewController(animated: false)
            }
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(
            title: "Utilizzo della fotocamera",
            message: "Per poter effetuare lo scan dei prodotti è necessario permettere l'utilizzo della fotocamera",
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(UIAlertAction(title: "Continua", style: .default) { alert in
            if AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count > 0 {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
                    DispatchQueue.main.async { self.checkCamera() }
                }
            }
        })
        
        present(alert, animated: true, completion: nil)
    }

}
