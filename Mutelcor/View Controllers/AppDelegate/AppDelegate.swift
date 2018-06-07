 //
 //  AppDelegate.swift
 //  Mutelcor
 //
 //  Created by on 03/03/17.
 //  Copyright © 2017. All rights reserved.
 //
 
 import UIKit
 import SwiftyJSON
 import CoreData
 import Fabric
 import Crashlytics
 import UserNotifications
 import PushKit
 import Starscream
 import WebRTC
 import EventKit
 import IQKeyboardManagerSwift
 
 //MARK:- Need to delete the Notification VC
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Enum
    //    ===========
    enum CallAction {
        case ring
        case accept
        case none
    }
    
    // MARK: Properties
    //    =================
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?
    var nvc : UINavigationController!
    var slideMenu : SlideMenuController!
    lazy var eventStore = EKEventStore()
    var eventStoreCalendar: EKCalendar!
    
    var callManager: Any?
    var providerDelegate: Any?
    var callTimeOutTimer: Timer?
    
    let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
    let socket = WebSocket(url: URL(string: "wss://digitalhealth.mutelcor.com")!)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AppNetworking.configureAlamofire()
        CommonFunctions.configureSlideMenu()
        registerUserNotifications()
        IQKeyboardManager.sharedManager().enable = true

        if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable : Any] {
            self.application(application, didReceiveRemoteNotification: userInfo)
        }

        /*if AppUserDefaults.value(forKey: .isSplashDisplayed) == JSON.null {
            self.goToSplashScreen()
        }else*/ if AppUserDefaults.value(forKey: .mobileVerified) != JSON.null , AppUserDefaults.value(forKey: .mobileVerified).int == 0 {
            goToLoginOption()
        }else if AppUserDefaults.value(forKey: .accessToken) != JSON.null, !AppUserDefaults.value(forKey: .accessToken).stringValue.isEmpty {
            self.goToHome()
        }else{
            goToLoginOption()
        }
        
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        registerUserNotifications()
        
        if #available(iOS 10.0, *) {
            callManager = CallManager()
            providerDelegate = ProviderDelegate(callManager: callManager as! CallManager)
        } else if let launchOptions = launchOptions {
            
            if let userInfo = launchOptions[.localNotification] as? JSONDictionary,
                let aps = userInfo["aps"] as? JSONDictionary {
                handleVoIPInfo(aps, by: .accept)
            }
        } else if let aps = AppUserDefaults.value(forKey: .notificationUserInfo, fallBackValue: JSON.null).dictionaryObject {
            handleVoIPInfo(aps, by: .accept)
            AppUserDefaults.removeValue(forKey: .notificationUserInfo)
        }
        
        removeAllLocalNotifications()
        RTCInitializeSSL()
        Fabric.with([Crashlytics.self])

        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let handle = userActivity.startCallHandle else {
            //printlnDebug("Could not determine start call handle from user activity: \(userActivity)")
            return false
        }
        
        guard let video = userActivity.video else {
            //printlnDebug("Could not determine video from user activity: \(userActivity)")
            return false
        }
        
        if #available(iOS 10.0, *), let callManager = callManager as? CallManager {
            callManager.startCall(handle: handle, videoEnabled: video)
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if let videoChatScene = UIApplication.topViewController() as? RTCVideoChatVC {
            videoChatScene.disconnect()
        }
        endAllCalls()
        RTCCleanupSSL()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let characterSet: CharacterSet = CharacterSet( charactersIn: "<>" )
        
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        token = token.trimmingCharacters(in: characterSet)
        token = token.replacingOccurrences(of: " ", with: "")
        
        if !token.isEmpty {
            AppUserDefaults.save(value: token, forKey: .deviceToken)
            //printlnDebug(token)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //printlnDebug("\(#function) \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        if application.applicationState == .inactive {
            handleRemotePushInfo(userInfo as? JSONDictionary)
        }
    }
    
    func handleRemotePushInfo(_ userInfo: JSONDictionary?) {
        
        guard let type = userInfo?["type"] as? Int else {
            return
        }
        
        if type == true.rawValue {
            let notificationScene = NotificationsVC.instantiate(fromAppStoryboard: .Notification)
            notificationScene.proceedToScreenThrough = .sideMenu
            AppDelegate.shared.goFromSideMenu(nextViewController: notificationScene)
        }else{
            let messageScene = MessagesVC.instantiate(fromAppStoryboard: .Message)
            messageScene.proceedToScreenThrough = .sideMenu
            AppDelegate.shared.goFromSideMenu(nextViewController: messageScene)
        }
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        handleVoIPInfo(notification.userInfo as? JSONDictionary, by: .ring)
    }
    
    fileprivate func handleVoIPInfo(_ userInfo: JSONDictionary?, by action: CallAction) {

        guard let aps = userInfo?["aps"] as? JSONDictionary else {
            return
        }
        
        guard let timeInterval = aps["date"] as? Double,
            (timeInterval + 60) > Date().timeIntervalSince1970 else {
                return
        }
        
        let callerJSON = JSON(aps)
        guard let caller = Caller(json: callerJSON) else {
            return
        }
        
        connectAndLogin(caller: caller, performing: action)
    }
    
    func connectAndLogin(caller: Caller, performing action: CallAction, completion: (() -> Void)? = nil) {
        
        if !socket.isConnected {
            socket.connect()
        }
        socket.onConnect = { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            let userId = AppUserDefaults.value(forKey: .userId).stringValue
            let firstname = AppUserDefaults.value(forKey: .firstname).stringValue
            let loginJson = ["type": "login", "name": "\(userId)_\(firstname)"]
            CommonFunctions.writeToSocket(loginJson)
            
            switch action {
            case .ring:
                strongSelf.moveToCallScene(with: caller)
            case .accept:
                strongSelf.moveToVideoChatScene(with: caller)
            case .none:
                break
            }
            
            completion?()
            self?.socket.onConnect = nil
        }
    }
    
    func moveToCallScene(with caller: Caller) {
        if slideMenu == nil {
            return
        }
        
        let callScene = CallVC.instantiate(fromAppStoryboard: .Calling)
        callScene.caller = caller
        let callNavVC = UINavigationController(rootViewController: callScene)
        callNavVC.isNavigationBarHidden = true
        callNavVC.modalTransitionStyle = .flipHorizontal
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        delay(1.5) {
            UIApplication.shared.endIgnoringInteractionEvents()
            self.slideMenu.present(callNavVC, animated: true, completion: nil)
        }
    }
    
    func moveToVideoChatScene(with caller: Caller) {
        if slideMenu == nil {
            return
        }
        
        let videoChatScene = RTCVideoChatVC.instantiate(fromAppStoryboard: .Calling)
        videoChatScene.caller = caller
        let chatNavVC = UINavigationController(rootViewController: videoChatScene)
        chatNavVC.isNavigationBarHidden = true
        chatNavVC.modalTransitionStyle = .flipHorizontal
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        delay(1.5) {
            UIApplication.shared.endIgnoringInteractionEvents()
            self.slideMenu.present(chatNavVC, animated: true, completion: nil)
        }
    }
    
    private func registerUserNotifications() {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (grant, error)  in
                if error == nil, grant {
                    DispatchQueue.main.async {
                        self.registerUNNotificationCategory()
                        self.registerForPushNVoip()
                    }
                } else if error != nil {
                    //printlnDebug("error: \(unwrappedError.localizedDescription)")
                }
            })
        } else {
            registerUIUserNotificationCategory()
            registerForPushNVoip()
        }
    }
    
    private func registerForPushNVoip() {
        //register for voip notifications
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        voipRegistry.delegate = self
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    @available(iOS 10.0, *)
    private func registerUNNotificationCategory() {
        
        let answerableCategory: UNNotificationCategory = {
            
            let acceptAction = UNNotificationAction(
                identifier: "ACCEPT_IDENTIFIER",
                title: "ACCEPT",
                options: [.foreground])
            
            let rejectAction = UNNotificationAction(
                identifier: "REJECT_IDENTIFIER",
                title: "REJECT",
                options: [.destructive])
            
            return UNNotificationCategory(identifier: "ANSWER_CATEGORY", actions: [acceptAction, rejectAction], intentIdentifiers: [], options: [.customDismissAction])
        }()
        
        UNUserNotificationCenter.current().setNotificationCategories([answerableCategory])
    }
    
    private func registerUIUserNotificationCategory() {
        let acceptAction = UIMutableUserNotificationAction()
        acceptAction.identifier = "ACCEPT_IDENTIFIER"
        acceptAction.title = "ACCEPT"
        acceptAction.isDestructive = false
        acceptAction.isAuthenticationRequired = false
        acceptAction.activationMode = .background
        
        let rejectAction = UIMutableUserNotificationAction()
        rejectAction.identifier = "REJECT_IDENTIFIER"
        rejectAction.title = "REJECT"
        rejectAction.isDestructive = true
        rejectAction.isAuthenticationRequired = false
        rejectAction.activationMode = .background
        
        let answerableCategory = UIMutableUserNotificationCategory()
        answerableCategory.identifier = "ANSWER_CATEGORY"
        answerableCategory.setActions([acceptAction, rejectAction], for: .default)
        
        let types: UIUserNotificationType = [.alert, .sound, .badge]
        let notificationSettings = UIUserNotificationSettings(types: types, categories: [answerableCategory])
        
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    func setupTimeoutTimer() {
        callTimeOutTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timeoutCall), userInfo: nil, repeats: false)
    }
    
    func invalidateTimeoutTimer() {
        callTimeOutTimer?.invalidate()
        callTimeOutTimer = nil
    }
    
    @objc private func timeoutCall() {
        endAllCalls()
    }
    
    func removeAllLocalNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    
    /*private func registerUserNotifications() {
     
     if #available(iOS 10.0, *) {
     let center = UNUserNotificationCenter.current()
     center.delegate = self
     center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (grant, error)  in
     if error == nil, grant {
     DispatchQueue.main.async {
     UIApplication.shared.registerForRemoteNotifications()
     self.registerUIUserNotificationCategory()
     }
     } else if let unwrappedError = error {
     //printlnDebug("error: \(unwrappedError.localizedDescription)")
     }
     })
     } else {
     UIApplication.shared.registerForRemoteNotifications()
     registerUIUserNotificationCategory()
     }
     }
     
     /Users/apple/Appinventiv/MutelCoreProject/Mutelcore_iOS/Mutelcore.xcodeproj     private func registerUIUserNotificationCategory() {
     
     let types: UIUserNotificationType = [.alert, .sound, .badge]
     let notificationSettings = UIUserNotificationSettings(types: types, categories: nil)
     
     UIApplication.shared.registerUserNotificationSettings(notificationSettings)
     }*/
 }
 
 @available(iOS 10.0, *)
 extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //printlnDebug(notification.request.content.userInfo)
        completionHandler(.badge)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo  as? JSONDictionary

        handleVoIPInfo(userInfo, by: .ring)
        handleRemotePushInfo(userInfo)
        completionHandler()
    }
 }
 
 //calling payload format:- {"aps":{"UUID":"8C91992B-5FB1-4CB1-8FFA-2526593EF3BE","id":"baba","type":"calling","alert":"Halo Baba","badge":1,"sound":"default"}}

