//
//  AppDelegateExtension.swift
//  Mutelcore
//
//  Created by Appinventiv on 04/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation

// MARK:- AppDelegate Extension
//=============================
extension AppDelegate {
    
    func goToHome() {
        
        let leftMenuViewController = SideMenuVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
        let mainViewController = DashboardVC.instantiate(fromAppStoryboard: .Dashboard)
        
        self.nvc = UINavigationController(rootViewController: mainViewController)
        
        self.slideMenu = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftMenuViewController)
        self.nvc.automaticallyAdjustsScrollViewInsets = false
        self.slideMenu.mainViewController = self.nvc
        self.slideMenu.changeLeftViewWidth(UIDevice.getScreenWidth - 100)
        self.slideMenu.automaticallyAdjustsScrollViewInsets = true
        self.window?.rootViewController =  self.slideMenu
        self.window?.makeKeyAndVisible()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
//        self.nvc.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func goFromSideMenu(nextViewController : BaseViewController) {
        
        self.nvc.viewControllers.removeAll()
        self.nvc.pushViewController(nextViewController, animated: false)
        self.nvc.automaticallyAdjustsScrollViewInsets = false
        self.slideMenu.mainViewController = self.nvc
        self.slideMenu.automaticallyAdjustsScrollViewInsets = true

//        self.nvc.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

    }
    
    func goToLoginOption() {
        
        let vc = SignInVC.instantiate(fromAppStoryboard: .Main)
        self.nvc = UINavigationController(rootViewController: vc)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.nvc.isNavigationBarHidden = false
        
        self.nvc.automaticallyAdjustsScrollViewInsets = false
        self.window?.rootViewController = self.nvc
        self.nvc.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
}
