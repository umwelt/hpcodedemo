//
//  GRNavigationController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 28/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit

class GRNavigationController: ENSideMenuNavigationController, ENSideMenuDelegate, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: GRMenuViewController(), menuPosition:.left, navigationController: self)
        sideMenu?.menuWidth = 280 // optional, default is 160
        sideMenu?.bouncingEnabled = true
        sideMenu?.allowSwipeToOpen = true

        view.bringSubview(toFront: navigationBar)
        // enable swipe to go back
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (self.viewControllers.count == 1) {
            return false;
        }
        return true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
