//
//  GRCommentModalViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 04/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit

class GRCommentModalViewController: UIViewController, UITextViewDelegate {

    var currentReview : String?
    var product: JSON?
    var reviewDelegate : GRAfterReviewProtocol?
    var indexRow = 0

    var lastReviewText = ""

    var fromProfile = false



    override var prefersStatusBarHidden : Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        managedView.commentTextView?.becomeFirstResponder()
        prepareView()
        NotificationCenter.default.addObserver(self, selector: #selector(GRCommentModalViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GRCommentModalViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        formatReview()
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

        if lastReviewText.characters.count > 0 {
            managedView.commentTextView?.text = lastReviewText
        }
        if let view = managedView.commentTextView {
            self.textViewDidChange(view)
        }
    }


    fileprivate var managedView: GRCommentModalView {
        return self.view as! GRCommentModalView
    }

    override func loadView() {
        super.loadView()
        view = GRCommentModalView()
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

        if let name = product?["display_name"].string {
            managedView.productMainLabel?.text = name
        }

        if let brand = product?["brand"].stringValue {
            managedView.brandLabel?.text = productJONSToBrand(data: product!)
        }

        if let category = product?["category"].string {
            self.managedView.reviewCategoryImageView?.image = UIImage(named: category)
        }

        self.updateCounterLabel("")

    }

    func actionCloseButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }


    func textViewDidChange(_ textView: UITextView) {

        if textView.text.characters.count > 30 {
            textView.enablesReturnKeyAutomatically = true
        }

        let trimmedString = textView.text.replacingOccurrences(of: "\\s", with: "", options: NSString.CompareOptions.regularExpression, range: nil)

        self.updateCounterLabel(trimmedString)
    }
    
    func updateCounterLabel(_ str: String?) {
        let typed = (str ?? "").characters.count;
        let minimum = 30
        let insufficient = typed < minimum
        
        let color = insufficient ? "#f00" : "#4a4a4a"
        let avenirBook10 = Constants.BrandFonts.avenirBook10!
        let text =
            "<style>" +
            "* { " +
                "font-family: \(avenirBook10.fontName); " +
                "font-size: \(avenirBook10.pointSize)px; " +
                "color: \(UIColor.nineSevenGrayColor().hexString) } " +
            "span { color: \(color); } " +
            "</style>" +
            "<span>\(typed)</span> (almeno \(minimum) caratteri)"

        if let data = text.data(using: .utf8) {
            managedView.counterLabel?.attributedText = try? NSAttributedString(
                data: data,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil
            )
        }
        
        managedView.counterLabel?.isHidden = false
        managedView.toggleConfirmButtonState(!insufficient)
    }


    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text == "\n" {

            let trimmedString = textView.text.replacingOccurrences(of: "\\s", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
            if trimmedString.characters.count < 30 {
                showValidationAlertWithTitleAndMessage("Attenzione", message: "Inserisce almeno 30 caratteri")
                return false
            }
            updateCommentReview()
            managedView.commentTextView?.resignFirstResponder()
            return true
        }
        return true
    }




    func updateCommentReview() {

        if fromProfile {
            self.dismiss(animated: false, completion: nil)
            self.reviewDelegate!.passProductReview!((self.managedView.commentTextView?.text)!, indexRow: self.indexRow, currentReview: self.currentReview!)
            return
        }

        let review: String = managedView.commentTextView!.text
        
        // check if we are adding a text to a review that did not have a text before
        let textWasAdded = self.lastReviewText.isEmpty && (!review.isEmpty)
        
        DispatchQueue.main.async {
            GrocerestAPI.updateReview(reviewId: self.currentReview!, fields: ["review": review]) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    return
                }
                
                if textWasAdded {
                    FBSDKAppEvents.logEvent("comment")
                }
                
                self.dismiss(animated: false, completion: nil)
                self.reviewDelegate!.passProductReview!((self.managedView.commentTextView?.text)!, indexRow: self.indexRow, currentReview: self.currentReview!)
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

    func formatReview() {
        if lastReviewText.characters.count > 0 {
            managedView.commentTextView?.text = lastReviewText
        }
        if let view = managedView.commentTextView {
            self.textViewDidChange(view)
        }
    }




}
