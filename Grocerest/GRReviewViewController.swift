//
//  GRReviewViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/11/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftyJSON
import SwiftLoader

class GRReviewViewController: UIViewController, GRPostReviewProtocol {
    
    var pageIndex : Int = 0
    var dataSource : JSON?
    var product: [String:String]?
    var currentReview : String?
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentReview = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var managedView: GRReviewView {
        return self.view as! GRReviewView
    }
    
    override func loadView() {
        view = GRReviewView()
        managedView.delegate = self
        managedView.reviewScrollView?.delegate = self
        
        
    }
    
    func prepareViews(_ productData: [String:String]) {
        product = productData
        
        
        self.managedView.reviewProductImageView?.layoutIfNeeded()
        DispatchQueue.main.async {
            if let name = productData["name"]{
                self.managedView.productMainLabel?.text = name
            }
            if let category = productData["category"] {
                self.managedView.reviewCategoryImageView?.image = UIImage(named: "products_" + category)?.imageWithInsets(10)
            }
            if let brand = productData["display_brand"] {
                let sanitizedString = brand.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                self.managedView.productsSecondaryLabel?.text = sanitizedString
            }
            
            
            if let image = productData["image"] {
                
                
                
                self.managedView.reviewProductImageView?.alpha = 0
                self.managedView.reviewProductImageView?.hnk_setImageFromURL(URL(string: image)!, placeholder: UIImage(named: "logoRed")?.withRenderingMode(UIImageRenderingMode.automatic), failure: { (error) -> Void in
                        print(error)
                        
                }, success: { (image) -> Void in
                    
                    UIView.animate(withDuration: 1, delay: 0.0, options: .transitionCrossDissolve, animations: { () -> Void in
                        self.managedView.reviewProductImageView?.image = image
                        self.managedView.reviewProductImageView?.alpha = 1
                        }) { (finished: Bool) -> Void in
                            print("finished")
                    }
                    
                    })}
   
        }
    }
    
    /**
     Vote as for button.tag
     
     - parameter sender: <#sender description#>
     */
    func postVoteForItem(_ sender:UIButton){
        var fields = [String: String]()
        
        if let product = product!["product"]{
            fields["product"] = product
        }
        
        fields["rating"] = "\(sender.tag)"
        
        if self.currentReview! == "" {
            fields["review"] = ""
            fields["frequency"] = ""
            fields["barcode"] = ""
            DispatchQueue.main.async { () -> Void in
                GrocerestAPI.postReview(fields) { data, error in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        SwiftLoader.hide()
                        return
                    }
                    
                    self.currentReview = data["_id"].string!
                }
            }
        } else {
            DispatchQueue.main.async { () -> Void in
                GrocerestAPI.updateReview(reviewId: self.currentReview!, fields: fields) { data, error in
                    
                    if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                        SwiftLoader.hide()
                        return
                    }
                    
                }
            }
        }
    }
    
    func postFrequencyForItem(_ sender:UIButton) {
        var fields = [String: String]()
        
        if let product = product!["product"]{
            fields["product"] = product
        }
        
        fields["frequency"] = voteFrequencyAsString(sender.tag)
        
        DispatchQueue.main.async { () -> Void in
            GrocerestAPI.updateReview(reviewId: self.currentReview!, fields: fields) { data, error in
                
                if GrocerestAPI.isRequestUnsuccessful(for: data, and: error) {
                    SwiftLoader.hide()
                    return
                }
                
                self.managedView.reviewScrollView?.viewFrequency?.setHighlight(sender.tag)
                
            }
        }
    }
    
    
    
    func postCommentForItem(_ sender:UIButton) {
        
//        let commentModalViewController = GRCommentModalViewController()
//        commentModalViewController.currentReview = currentReview
//        commentModalViewController.product = product
//        commentModalViewController.reviewDelegate = self
//        presentViewController(commentModalViewController, animated: true) { () -> Void in
//            
//        }


    }
    
    
    
    func voteFrequencyAsString(_ vote:Int) -> String {
        
        switch vote {
        case 0:
            return Constants.FrequencyLabels.first
        case 1:
            return Constants.FrequencyLabels.rarely
        case 2:
            return Constants.FrequencyLabels.once
        case 3:
            return Constants.FrequencyLabels.weekly
        case 4:
            return Constants.FrequencyLabels.every
        default:
            return ""
            
        }
        
    }
    
    
//    func passProductReview(review:String) {
//        
//        managedView.reviewScrollView?.viewCommentReview?.commentTextField?.text = review
//    }
//    
}
