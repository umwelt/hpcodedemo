//
//  GRZoomViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 25/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftLoader
import Haneke

class GRZoomViewController: UIViewController, UIScrollViewDelegate {
    var imageURLString = ""
    var tapGesture = UITapGestureRecognizer()
    weak var fromImageView:UIImageView? = nil
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resizeWithFromImageView()
        
        // self.fromImageView?.hidden = true
        self.managedView.layer.opacity = 0.0
    }
    
    func resizeWithFromImageView() {
        if
            let origin = fromImageView?.superview?.convert(fromImageView!.frame.origin, to: self.managedView),
            let size = fromImageView?.frame.size,
            let image = fromImageView?.image
        {
            self.managedView.zoomedImageView.frame.origin = origin
            self.managedView.zoomedImageView.frame.size = size
            self.managedView.zoomedImageView.image = image
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if fromImageView == nil {
            self.resizeContent()
            self.centerContent()
        }
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            self.managedView.layer.opacity = 1.0
            self.resizeContent()
            self.centerContent()
        }, completion: nil)
    }
    
    fileprivate var managedView: GRZoomView {
        return self.view as! GRZoomView
    }

    override func loadView() {
        super.loadView()
        view = GRZoomView()
        managedView.delegate = self
    }
    
    func setupViews() {
        SwiftLoader.hide()
        
        self.managedView.zoomedImageView.translatesAutoresizingMaskIntoConstraints = true
        
        tapGesture.addTarget(self, action: #selector(GRZoomViewController.actionScreenWastapped(_:)))
        self.managedView.addGestureRecognizer(tapGesture)
        
        self.managedView.backView.minimumZoomScale = 1.0
        self.managedView.backView.maximumZoomScale = 2.0
        self.managedView.backView.zoomScale = 1.0
        
        self.managedView.backView.autoresizingMask =  UIViewAutoresizing.flexibleHeight
        self.managedView.backView.clipsToBounds = true
        self.managedView.backView.delegate = self
        self.managedView.backView.isPagingEnabled = false
        
        // self.managedView.layoutIfNeeded()
        let url = URL(string: self.imageURLString)!
        self.managedView.zoomedImageView.hnk_setImageFromURL(url, format: Haneke.Format(name: "original"), success: { image in
            self.managedView.zoomedImageView.image = image
        })
    }
    
    
    func closeButtonWasPressed(_ sender:UIButton) {}
    
    func actionScreenWastapped(_ sender:UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.managedView.layer.opacity = 0.0
        }, completion: { animated in
            self.dismiss(animated: false, completion: nil)
            // self.fromImageView?.hidden = false
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            self.managedView.backView.zoomScale = 1.0
            self.resizeContent()
            self.resizeWithFromImageView()
        }, completion: { animated in
        
        })
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return managedView.zoomedImageView
    }
    
    func resizeContent() {
        let scrollView = self.managedView.backView
        let imageView = self.managedView.zoomedImageView
        imageView.frame.size.width = scrollView.frame.width * 0.8
        imageView.frame.size.height = scrollView.frame.width * 0.8
    }
    
    func centerContent() {
        let scrollView = managedView.backView
        let imageView = managedView.zoomedImageView
        
        let bounds = scrollView.bounds
        var imageViewFrame = imageView.frame
        
        if (imageViewFrame.size.width < bounds.width) {
            imageViewFrame.origin.x = (bounds.width - imageViewFrame.size.width) / 2.0
        } else {
            imageViewFrame.origin.x = 0
        }
        
        if (imageViewFrame.size.height < bounds.height) {
            imageViewFrame.origin.y = (bounds.height - imageViewFrame.size.height) / 2.0
        } else {
            imageViewFrame.origin.y = 0
        }
        
        imageView.frame = imageViewFrame
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerContent()
    }
    
}

