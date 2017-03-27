//
//  GRReportViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 21/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit

class GRReportViewController: UIViewController, UITextViewDelegate, AlertViewProtocol {
    
    var currentReview : JSON?
    var indexRow = 0
    
    var report = ""
    
    var fromProfile = false
    
    var alertText = "Grazie \(GRUser.sharedInstance.username!),\n la tua segnalazione è stata inviata alla redazione."
    
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedView.commentTextView?.becomeFirstResponder()
        prepareView()
        NotificationCenter.default.addObserver(self, selector: #selector(GRReportViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GRReportViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isBeingPresented {
            print("presented")
        }
    }
    
    fileprivate var managedView: GRReportView {
        return self.view as! GRReportView
    }
    
    override func loadView() {
        super.loadView()
        view = GRReportView()
        managedView.delegate = self
        managedView.commentTextView!.delegate = self
        managedView.commentTextView?.layoutManager.allowsNonContiguousLayout = false
    }
    
    func keyboardWillShow(_ notification: Notification) {
        guard let kbSizeValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let kbDurationNumber = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        animateToKeyboardHeight(kbSizeValue.cgRectValue.height, duration: kbDurationNumber.doubleValue)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        guard let kbDurationNumber = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        animateToKeyboardHeight(0, duration: kbDurationNumber.doubleValue)
    }
    
    func animateToKeyboardHeight(_ kbHeight: CGFloat, duration: Double) {
        
        self.managedView.onCommentProductView.snp.remakeConstraints { (make) in
            make.width.equalTo(self.managedView)
            make.height.equalTo(75)
            make.bottom.equalTo(-kbHeight)
            make.left.equalTo(0)
        }
    }
    
    
    func prepareView() {
        
        if let name = currentReview?["product"]["display_name"].string {
            managedView.formatProductLabel(name)
        }
        
        managedView.formatReviewLabel((currentReview?["author"]["username"].stringValue)!, data: formateCarinaDate((currentReview?["tsCreated"].stringValue)!))
        
        if let category = currentReview?["product"]["category"].string {
            self.managedView.reviewCategoryImageView?.image = UIImage(named: category)
        }
        
    }
    
    func actionCloseButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func completedAction(){
        dismiss(animated: true, completion: nil)
    }
    
    
    func confirmWasPressed(_ sender:UIButton){
        reportReview()
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            reportReview()
        }
        return true
    }
    
    func reportReview() {
        var fields = [String: Any]()
        
        fields["message"] = self.managedView.commentTextView?.text
        
        GrocerestAPI.willReportReview(currentReview!["_id"].stringValue, fields: fields) { data, error in
            
            if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                return
            }
            
            if data != nil {
                let alert = GRAlertViewController()
                alert.setAlertMessageText(self.alertText, lines: 3)
                alert.dismissDelegate = self
                alert.modalPresentationStyle = .overCurrentContext
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /// Alert on errors
    
    fileprivate func showValidationAlertWithTitleAndMessage(_ title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
}
