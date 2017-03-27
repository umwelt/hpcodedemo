///
//  SideMenu.swift
//  SwiftSideMenu
//
//  Created by Evgeny on 24.07.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

@objc public protocol ENSideMenuDelegate {
    @objc optional func sideMenuWillOpen()
    @objc optional func sideMenuWillClose()
    @objc optional func sideMenuDidOpen()
    @objc optional func sideMenuDidClose()
    @objc optional func sideMenuShouldOpenSideMenu () -> Bool
}

@objc public protocol ENSideMenuProtocol {
    var sideMenu : ENSideMenu? { get }
    func setContentViewController(_ contentViewController: UIViewController)
}

public enum ENSideMenuAnimation : Int {
    case none
    case `default`
}
/**
The position of the side view on the screen.

- Left:  Left side of the screen
- Right: Right side of the screen
*/
public enum ENSideMenuPosition : Int {
    case left
    case right
}

// TODO: why all this nonsense injiection/extension
// when we could have the menu as a clean shared singleton ?

public extension UIViewController {
    /**
    Changes current state of side menu view.
    */
    public func toggleSideMenuView () {
        sideMenuController()?.sideMenu?.toggleMenu()
    }
    /**
    Hides the side menu view.
    */
    public func hideSideMenuView () {
        sideMenuController()?.sideMenu?.hideSideMenu()
    }
    /**
    Shows the side menu view.
    */
    public func showSideMenuView () {
        sideMenuController()?.sideMenu?.showSideMenu()
    }
    
    /**
    Returns a Boolean value indicating whether the side menu is showed.
    
    :returns: BOOL value
    */
    public func isSideMenuOpen () -> Bool {
        let sieMenuOpen = self.sideMenuController()?.sideMenu?.isMenuOpen
        return sieMenuOpen!
    }
    
    /**
     * You must call this method from viewDidLayoutSubviews in your content view controlers so it fixes size and position of the side menu when the screen
     * rotates.
     * A convenient way to do it might be creating a subclass of UIViewController that does precisely that and then subclassing your view controllers from it.
     */
    func fixSideMenuSize() {
        if let navController = self.navigationController as? ENSideMenuNavigationController {
            navController.sideMenu?.updateFrame()
        }
    }
    /**
    Returns a view controller containing a side menu
    
    :returns: A `UIViewController`responding to `ENSideMenuProtocol` protocol
    */
    public func sideMenuController () -> ENSideMenuProtocol? {
        var iteration : UIViewController? = self.parent
        if (iteration == nil) {
            return topMostController()
        }
        repeat {
            if (iteration is ENSideMenuProtocol) {
                return iteration as? ENSideMenuProtocol
            } else if (iteration?.parent != nil && iteration?.parent != iteration) {
                iteration = iteration!.parent
            } else {
                iteration = nil
            }
        } while (iteration != nil)
        
        return iteration as? ENSideMenuProtocol
    }
    
    internal func topMostController () -> ENSideMenuProtocol? {
        var topController : UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        if (topController is UITabBarController) {
            topController = (topController as! UITabBarController).selectedViewController
        }
        while (topController?.presentedViewController is ENSideMenuProtocol) {
            topController = topController?.presentedViewController
        }
        
        return topController as? ENSideMenuProtocol
    }
    
    
    
}

open class ENSideMenu : NSObject, UIGestureRecognizerDelegate {
    /// The width of the side menu view. The default value is 160.
    
    var blackBg: UIImageView = UIImageView()
    var blackBgAnimating: Bool = false
    
    open var menuWidth : CGFloat = 160.0 {
        didSet {
            needUpdateApperance = true
            updateSideMenuApperanceIfNeeded()
            updateFrame()
        }
    }
    fileprivate var menuPosition:ENSideMenuPosition = .left
    fileprivate var blurStyle: UIBlurEffectStyle = .light
    ///  A Boolean value indicating whether the bouncing effect is enabled. The default value is TRUE.
    open var bouncingEnabled :Bool = true
    /// The duration of the slide animation. Used only when `bouncingEnabled` is FALSE.
    open var animationDuration = 0.4
    fileprivate let sideMenuContainerView =  UIView()
    fileprivate(set) var menuViewController : GRMenuViewController!
    fileprivate var animator: UIDynamicAnimator!
    fileprivate var sourceView : UIView!
    fileprivate var needUpdateApperance : Bool = false
    /// The delegate of the side menu
    open weak var delegate : ENSideMenuDelegate?
    fileprivate(set) var isMenuOpen : Bool = false
    /// A Boolean value indicating whether the left swipe is enabled.
    open var allowLeftSwipe : Bool = true
    /// A Boolean value indicating whether the right swipe is enabled.
    open var allowRightSwipe : Bool = true
    open var allowPanGesture : Bool = true
    fileprivate var panRecognizer : UIPanGestureRecognizer?
    // when true the user can slide from the left/right edge to open the menu
    open var allowSwipeToOpen: Bool = false
    fileprivate var navigationController: UINavigationController? = nil
    
    /**
    Initializes an instance of a `ENSideMenu` object.
    
    :param: sourceView   The parent view of the side menu view.
    :param: menuPosition The position of the side menu view.
    
    :returns: An initialized `ENSideMenu` object, added to the specified view.
    */
    public init(sourceView: UIView, menuPosition: ENSideMenuPosition, blurStyle: UIBlurEffectStyle = .dark) {
        super.init()
        self.sourceView = sourceView
        self.menuPosition = menuPosition
        self.blurStyle = blurStyle
        
        self.blackBgViewInitialize()
        self.setupMenuView()
        
//        let frame = CGRectMake(276.0, -2, 102, sourceView.frame.height + 2)
//        outterView = UIView(frame: frame)
//        outterView.alpha = 0
//        outterView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: "hideSideMenu")
//        outterView.addGestureRecognizer(tapRecognizer)
//        outterView.userInteractionEnabled = false
//        sourceView.addSubview(outterView)
//    
        animator = UIDynamicAnimator(referenceView:sourceView)
        animator.delegate = self
        
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ENSideMenu.handlePan(_:)))
        panRecognizer!.delegate = self
        sourceView.addGestureRecognizer(panRecognizer!)
        
        // Add right swipe gesture recognizer
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ENSideMenu.handleGesture(_:)))
        rightSwipeGestureRecognizer.delegate = self
        rightSwipeGestureRecognizer.direction =  UISwipeGestureRecognizerDirection.right
        
        // Add left swipe gesture recognizer
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ENSideMenu.handleGesture(_:)))
        leftSwipeGestureRecognizer.delegate = self
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        
        if (menuPosition == .left) {
            sourceView.addGestureRecognizer(rightSwipeGestureRecognizer)
            sideMenuContainerView.addGestureRecognizer(leftSwipeGestureRecognizer)
        }
        else {
            sideMenuContainerView.addGestureRecognizer(rightSwipeGestureRecognizer)
            sourceView.addGestureRecognizer(leftSwipeGestureRecognizer)
        }
        
    }
    
    /**
    Initializes an instance of a `ENSideMenu` object.
    
    :param: sourceView         The parent view of the side menu view.
    :param: menuViewController A menu view controller object which will be placed in the side menu view.
    :param: menuPosition       The position of the side menu view.
    
    :returns: An initialized `ENSideMenu` object, added to the specified view, containing the specified menu view controller.
    */
    public convenience init(sourceView: UIView, menuViewController: UIViewController, menuPosition: ENSideMenuPosition, blurStyle: UIBlurEffectStyle = .light, navigationController: UINavigationController?) {
        self.init(sourceView: sourceView, menuPosition: menuPosition, blurStyle: blurStyle)
        self.menuViewController = menuViewController as! GRMenuViewController
        self.menuViewController.view.frame = sideMenuContainerView.bounds
        self.menuViewController.view.autoresizingMask =  [.flexibleHeight, .flexibleWidth]
        self.navigationController = navigationController
        sideMenuContainerView.addSubview(self.menuViewController.view)
    }

    // manage blackBg view
    // which is a view on top of source view but behind the menuView
    
    fileprivate func blackBgViewInitialize() {
        blackBg = UIImageView(frame: sourceView.frame)
        blackBg.backgroundColor = UIColor.clear
        blackBg.isUserInteractionEnabled = false
        blackBg.alpha = 0
        sourceView.addSubview(blackBg)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ENSideMenu.hideSideMenu))
        blackBg.addGestureRecognizer(tapRecognizer)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurredView = UIVisualEffectView(effect: blurEffect)
        blackBg.addSubview(blurredView)
        blurredView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(blackBg)
        }
    }
    

    open func blackBgAlphaUpdate(_ percent: CGFloat = -1) {
        var percent = percent
        if (percent == -1) { percent = self.sideMenuMovementPercent() }
        // set opacity, proportionally
        blackBg.alpha = percent
        blackBg.isHidden = percent < 0.02
    }
    
    open func sideMenuMovementPercent() -> CGFloat {
        // calculate % of the side menu movement
        let maxX:CGFloat = 278.0
        let posX = self.sideMenuContainerView.center.x + (self.sideMenuContainerView.frame.width / 2)
        var percent = posX / maxX
        // constrain bounds
        if (percent >= maxX) { percent = maxX }
        if (percent <= 0.01) { percent = 0.0 }
        return percent
    }
    
    // brainstorming with myself, currently not used
    open func rotoView (_ view: UIView, percent: CGFloat) {
        // update alpha according to the current menu position
        let width = blackBg.layer.bounds.width
        
        // set anchor point to middle-left point
        view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        
        // make closer things appear smaller (so we can rotate towards the camera and avoid collision with other views)
        var transform: CATransform3D  = CATransform3DIdentity
        let value = 0.00025 * CGFloat(M_PI)
        transform.m34 = value
        
        // (?) no idea why we need to translate the view away from center
        transform = CATransform3DTranslate(transform, width / 2, 0, 0)
        // apply 3d transform
        transform = CATransform3DRotate(transform, percent * 80.0 * CGFloat(M_PI) / 180.0, 0.0, 0.5, 0.0)
        view.layer.transform = transform
    }

    // Updates the frame of the side menu view.
    
    func updateFrame() {
        var width:CGFloat
        var height:CGFloat
        (width, height) = adjustFrameDimensions( sourceView.frame.size.width, height: sourceView.frame.size.height)
        let menuFrame = CGRect(
            x: (menuPosition == .left) ?
                isMenuOpen ? 0 : -menuWidth-1.0 :
                isMenuOpen ? width - menuWidth : width+1.0,
            y: sourceView.frame.origin.y,
            width: menuWidth,
            height: height
        )
        sideMenuContainerView.frame = menuFrame
    }
    
    fileprivate func adjustFrameDimensions( _ width: CGFloat, height: CGFloat ) -> (CGFloat,CGFloat) {
        if floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1 &&
            (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeRight ||
                UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeLeft) {
                    // iOS 7.1 or lower and landscape mode -> interchange width and height
                    return (height, width)
        }
        else {
            return (width, height)
        }
        
    }
    
    fileprivate func setupMenuView() {
        
        // Configure side menu container
        updateFrame()

        sideMenuContainerView.backgroundColor = UIColor.clear
        sideMenuContainerView.clipsToBounds = false
        sideMenuContainerView.layer.masksToBounds = false
        sideMenuContainerView.layer.shadowOffset = (menuPosition == .left) ? CGSize(width: 1.0, height: 1.0) : CGSize(width: -1.0, height: -1.0)
        sideMenuContainerView.layer.shadowRadius = 1.0
        sideMenuContainerView.layer.shadowOpacity = 0.125
        sideMenuContainerView.layer.shadowPath = UIBezierPath(rect: sideMenuContainerView.bounds).cgPath
        
        sourceView.addSubview(sideMenuContainerView)
        
        if (NSClassFromString("UIVisualEffectView") != nil) {
            // Add blur view
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle)) as UIVisualEffectView
            visualEffectView.frame = sideMenuContainerView.bounds
            visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            sideMenuContainerView.addSubview(visualEffectView)
        }
        else {
            // TODO: add blur for ios 7
            //
        }
    }
    
    fileprivate func toggleMenu(_ shouldOpen: Bool, initialVelocity: CGFloat = 0.0) {
        var shouldOpen = shouldOpen
        var initialVelocity = initialVelocity
        blackBg.isUserInteractionEnabled = shouldOpen
        
        if (shouldOpen && delegate?.sideMenuShouldOpenSideMenu?() == false) {
            return
        }
        updateSideMenuApperanceIfNeeded()
        isMenuOpen = shouldOpen
        
        adjustFrameDimensions(
            sourceView.frame.size.width, height: sourceView.frame.size.height)
        
        if (initialVelocity == 0.0) { // button pressed
            initialVelocity = 35 * ((shouldOpen) ? 1 : -1)
        } else { // swiping
            shouldOpen = initialVelocity > 0
            initialVelocity *= 1.2
        }
        
        animator.removeAllBehaviors()
        
        let menuXWanted = (shouldOpen) ? +(menuWidth / 2.0) : -(menuWidth / 2.0) + (-3.0) // we need -3.0 margin to hide shadow
        let menuYCurrent = sideMenuContainerView.center.y
        
        let snapBehaviour = UIAttachmentBehavior(item: sideMenuContainerView, attachedToAnchor: CGPoint(x: menuXWanted, y: menuYCurrent))
        snapBehaviour.damping = 1.5
        snapBehaviour.length = 2
        snapBehaviour.frequency = 10.0
        animator.addBehavior(snapBehaviour)
        
        let pushBehavior = UIPushBehavior(items: [sideMenuContainerView], mode: UIPushBehaviorMode.instantaneous)
        pushBehavior.magnitude = initialVelocity
        animator.addBehavior(pushBehavior)
        
        let menuViewBehavior = UIDynamicItemBehavior(items: [sideMenuContainerView])
        menuViewBehavior.allowsRotation = false
        menuViewBehavior.action = { () -> () in
            self.blackBgAlphaUpdate()
        }
        animator.addBehavior(menuViewBehavior)
        
        if (shouldOpen) {
            delegate?.sideMenuWillOpen?()
            
            self.menuViewController.updateViewsWithUserProfile(true, userImage: GRUser.sharedInstance.picture!, userName: GRUser.sharedInstance.firstname!, usName: GRUser.sharedInstance.username!, lastname: GRUser.sharedInstance.lastname!)
            
//            if let photo = picture,
//            let uName = firstname,
//            let uSSName = username,
//                let lname = lastname {
//            self.menuViewController.updateViewsWithUserProfile(true, userImage: photo, userName: uName, usName: uSSName, lastname: lname )
//            }
//            
            
        } else {
            delegate?.sideMenuWillClose?()
        }
    }
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer is UISwipeGestureRecognizer {
            let swipeGestureRecognizer = gestureRecognizer as! UISwipeGestureRecognizer
            if !self.allowLeftSwipe {
                if swipeGestureRecognizer.direction == .left {
                    return false
                }
            }
            
            if !self.allowRightSwipe {
                if swipeGestureRecognizer.direction == .right {
                    return false
                }
            }
        }
        else if gestureRecognizer.isEqual(panRecognizer) {
            if allowPanGesture == false {
                return false
            }
            let lastViewInStack = self.navigationController?.viewControllers.count == 1
            animator.removeAllBehaviors()
            let touchPosition = gestureRecognizer.location(ofTouch: 0, in: sourceView)
            if menuPosition == .left {
                if isMenuOpen {
                    if touchPosition.x < menuWidth {
                        return true
                    }
                }
                else {
                    if touchPosition.x < 30 {
                        if (allowSwipeToOpen) {
                            if (lastViewInStack) {
                                return true
                            }
                        }
                    }
                }
            }
            else {
                if isMenuOpen {
                    if touchPosition.x > sourceView.frame.width - menuWidth {
                        return true
                    }
                }
                else {
                    if touchPosition.x > sourceView.frame.width - 30 {
                        if (allowSwipeToOpen) {
                            if (lastViewInStack) {
                                return true
                            }
                        }
                    }
                }
            }
            
            return false
        }
        return true
    }
    
    internal func handleGesture(_ gesture: UISwipeGestureRecognizer) {
            ((self.menuPosition == .right && gesture.direction == .left)
                || (self.menuPosition == .left && gesture.direction == .right))
    }
    
    internal func handlePan(_ recognizer : UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: recognizer.view).x
        let leftToRight = velocity > 0
        
        switch recognizer.state {
        case .began:
            break
            
        case .changed:
            let translation = recognizer.translation(in: sourceView).x
            let xPoint : CGFloat = sideMenuContainerView.center.x + translation + (menuPosition == .left ? 1 : -1) * menuWidth / 2
            
            if menuPosition == .left {
                if xPoint <= 0 || xPoint > self.sideMenuContainerView.frame.width {
                    return
                }
            }else{
                if xPoint <= sourceView.frame.size.width - menuWidth || xPoint >= sourceView.frame.size.width
                {
                    return
                }
            }
            
            sideMenuContainerView.center.x = sideMenuContainerView.center.x + translation
            recognizer.setTranslation(CGPoint.zero, in: sourceView)
            self.blackBgAlphaUpdate()
            
        default:
            let shouldClose = menuPosition == .left ? !leftToRight && sideMenuContainerView.frame.maxX < menuWidth : leftToRight && sideMenuContainerView.frame.minX >  (sourceView.frame.size.width - menuWidth)
            toggleMenu(!shouldClose, initialVelocity: velocity)
            
        }
    }
    
    fileprivate func updateSideMenuApperanceIfNeeded () {
        if (needUpdateApperance) {
            var frame = sideMenuContainerView.frame
            frame.size.width = menuWidth
            sideMenuContainerView.frame = frame
            sideMenuContainerView.layer.shadowPath = UIBezierPath(rect: sideMenuContainerView.bounds).cgPath

            needUpdateApperance = false
        }
    }
    
    /**
    Toggles the state of the side menu.
    */
    open func toggleMenu () {
        if (isMenuOpen) {
            toggleMenu(false)
        }
        else {
            updateSideMenuApperanceIfNeeded()
            toggleMenu(true)
        }
    }
    /**
    Shows the side menu if the menu is hidden.
    */
    open func showSideMenu () {
        if (!isMenuOpen) {
            toggleMenu(true)
        }
    }
    /**
    Hides the side menu if the menu is showed.
    */
    open func hideSideMenu () {
        if (isMenuOpen) {
            toggleMenu(false)
        }
    }
}

extension ENSideMenu: UIDynamicAnimatorDelegate {
    public func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        if (self.isMenuOpen) {
            self.delegate?.sideMenuDidOpen?()
        } else {
            self.delegate?.sideMenuDidClose?()
        }
    }
    
    public func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
    }
}

