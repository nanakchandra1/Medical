//
//  AppDelegateExtension.swift
//  Mutelcor
//
//  Created by on 04/05/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

// MARK:- AppDelegate Extension
//=============================
extension AppDelegate {
    
    func goToHome() {
        
        let leftMenuViewController = SideMenuVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
        let mainViewController = DashboardVC.instantiate(fromAppStoryboard: .Dashboard)
        
        self.nvc = UINavigationController(navigationBarClass: TallerNavigationBar.self, toolbarClass: nil)
        self.nvc.setViewControllers([mainViewController], animated: true)
        self.nvc.navigationBar.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: 52)

        self.slideMenu = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftMenuViewController)
        self.nvc.automaticallyAdjustsScrollViewInsets = false
        self.slideMenu.mainViewController = self.nvc
        self.slideMenu.changeLeftViewWidth(UIDevice.getScreenWidth - 100)
        self.slideMenu.automaticallyAdjustsScrollViewInsets = true
        self.window?.rootViewController =  self.slideMenu
        self.window?.makeKeyAndVisible()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    func goFromSideMenu(nextViewController : UIViewController) {
        self.nvc.viewControllers.removeAll()
        self.nvc.pushViewController(nextViewController, animated: false)
        self.nvc.automaticallyAdjustsScrollViewInsets = false
        self.slideMenu.mainViewController = self.nvc
        self.slideMenu.automaticallyAdjustsScrollViewInsets = true
    }
    
    func goToLoginOption() {
        let vc = SignInVC.instantiate(fromAppStoryboard: .Main)
        self.nvc = UINavigationController(navigationBarClass: TallerNavigationBar.self, toolbarClass: nil)
        self.nvc.setViewControllers([vc], animated: true)
        self.nvc.navigationBar.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: 52)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.nvc.isNavigationBarHidden = false
        self.nvc.automaticallyAdjustsScrollViewInsets = false
        self.window?.rootViewController = self.nvc
        self.nvc.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func goToSplashScreen(){

        AppUserDefaults.save(value: 1, forKey: .isSplashDisplayed)
        let vc = WalkThroughVC.instantiate(fromAppStoryboard: .Main)
        self.nvc = UINavigationController(navigationBarClass: TallerNavigationBar.self, toolbarClass: nil)
        self.nvc.setViewControllers([vc], animated: true)
        self.nvc.navigationBar.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: 52)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.nvc.isNavigationBarHidden = false
        self.nvc.automaticallyAdjustsScrollViewInsets = false
        self.window?.rootViewController = self.nvc
        self.nvc.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
