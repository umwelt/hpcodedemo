//
//  GRCustomNavigationAnimationController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 22/12/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

class CustomNavigationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var reverse: Bool = false
    
    var snapshot : UIView!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.1
    }
    
    
    func animationControllerForPresentedController(_ presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    return self
    }
    
    func animationControllerForDismissedController(_ dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    return self
    }
    

    
//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        let container = transitionContext.containerView()
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
//        let fromView = fromViewController!.view
//        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
//        let toView = toViewController!.view
//        
//       // let size = toView.frame.size
//        
//        
//        var rotationAndPerspectiveTransform:CATransform3D  = CATransform3DIdentity;
//        rotationAndPerspectiveTransform.m34 = 1.0 / 500;
//        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 45.0 * CGFloat(M_PI) / 1.0, 0.0, 0.0, 0.0);
//        
//        
//        
//        snapshot = fromView.snapshotViewAfterScreenUpdates(true)
//        
//        container!.addSubview(toView)
//        container!.addSubview(snapshot)
//        
//       // let duration = self.transitionDuration(transitionContext)
//        
//        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
//            //self.snapshot.transform = offSetTransform
//            self.snapshot.layer.transform = rotationAndPerspectiveTransform;
//            
//            }, completion: {
//                finished in
//                transitionContext.completeTransition(true)
//        })
//    
//    }
    
    
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            
            let containerView = transitionContext.containerView
            containerView.backgroundColor = UIColor.clear
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
            let toView = toViewController.view
            let fromView = fromViewController.view
            let direction: CGFloat = reverse ? -1 : 1
            let const: CGFloat = -0.005
    
            toView?.layer.anchorPoint = CGPoint(x: direction == 1 ? 0 : 1, y: 0.5)
            fromView?.layer.anchorPoint = CGPoint(x: direction == 1 ? 1 : 0, y: 0.5)
    
            var viewFromTransform: CATransform3D = CATransform3DMakeRotation(direction * CGFloat(M_PI_2), 0.0, 1.0, 0.0)
            var viewToTransform: CATransform3D = CATransform3DMakeRotation(-direction * CGFloat(M_PI_2), 0.0, 1.0, 0.0)
            viewFromTransform.m34 = const
            viewToTransform.m34 = const
    
            containerView.transform = CGAffineTransform(translationX: direction * containerView.frame.size.width / 2.0, y: 0)
            toView?.layer.transform = viewToTransform
            containerView.addSubview(toView!)
    
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                containerView.transform = CGAffineTransform(translationX: -direction * containerView.frame.size.width / 2.0, y: 0)
                fromView?.layer.transform = viewFromTransform
                toView?.layer.transform = CATransform3DIdentity
                }, completion: {
                    finished in
                    containerView.transform = CGAffineTransform.identity
                    fromView?.layer.transform = CATransform3DIdentity
                    toView?.layer.transform = CATransform3DIdentity
                    fromView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
                    if (transitionContext.transitionWasCancelled) {
                        toView?.removeFromSuperview()
                    } else {
                        fromView?.removeFromSuperview()
                    }
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    
    
}
