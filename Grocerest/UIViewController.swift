//
//  UIViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 07/12/2016.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

extension UIViewController {
    func presentViewControllerFromVisibleViewController(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let navigationController = self as? UINavigationController, let topViewController = navigationController.topViewController {
            topViewController.presentViewControllerFromVisibleViewController(viewControllerToPresent, animated: true, completion: completion)
        } else if (presentedViewController != nil) {
            presentedViewController!.presentViewControllerFromVisibleViewController(viewControllerToPresent, animated: true, completion: completion)
        } else {
            present(viewControllerToPresent, animated: true, completion: completion)
        }
    }
}
