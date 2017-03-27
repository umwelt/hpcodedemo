//
//  GRReputationViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

class GRReputationViewController : UIViewController {
    
    var data: JSON?
    var timer: Timer!
    var counter = 0

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = data { managedView.populateViewWith(data) }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let data = data { managedView.animateProgressBarWith(data) }
        updateLabel()
    }
    
    fileprivate var managedView: GRReputationView {
        return self.view as! GRReputationView
    }
    
    override func loadView() {
        super.loadView()
        view = GRReputationView()
        managedView.delegate = self
    }
    
    func dismiss(_ sender:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func closeView(_ sender:UIButton) {
        timer.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    func updateLabel() {
         timer = Timer.scheduledTimer(timeInterval: 0.003, target: self, selector: #selector(GRReputationViewController.countUp), userInfo: nil, repeats: true)
    }
    
    func countUp() {
        if let score = data?["score"].int, let nextLevel = data?["levelEnd"].int {
            if counter < (nextLevel - score) {
                counter += 2
                managedView.pointsTo.text = "\(counter) punti"
            } else {
                managedView.pointsTo.text = "\(nextLevel - score) punti"
                timer.invalidate()
            }
        }
    }
    
}
