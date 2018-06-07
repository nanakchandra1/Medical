//
//  UIApplicationExtension.swift
//  VoiceCallingDemo
//
//  Created by  on 21/08/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        //if let slideMenuController = controller as? SlideMenuController {
        //    return topViewController(controller: slideMenuController.mainViewController)
        //}
        
        return controller
    }
}
