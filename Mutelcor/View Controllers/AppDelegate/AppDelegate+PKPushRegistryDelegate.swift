//
//  AppDelegate+PKPushRegistryDelegate.swift
//  de
//
//  Created by  on 31/08/17.
//  Copyright © 2017. All rights reserved.
//

import PushKit
import SwiftyJSON
import UIKit

// MARK: PKPushRegistryDelegate
extension AppDelegate: PKPushRegistryDelegate {
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        
        let characterSet: CharacterSet = CharacterSet( charactersIn: "<>" )
        
        var token = ""
        for i in 0..<pushCredentials.token.count {
            token = token + String(format: "%02.2hhx", arguments: [pushCredentials.token[i]])
        }
        
        token = token.trimmingCharacters(in: characterSet)
        token = token.replacingOccurrences(of: " ", with: "")
        
        if !token.isEmpty {
            NSLog("VoIP token: \(token)")
            AppUserDefaults.save(value: token, forKey: .voIPToken)
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        
        guard type == .voIP, let aps = payload.dictionaryPayload["aps"] as? JSONDictionary else { return }
        
        //printlnDebug(aps)
        NSLog(JSON(aps).rawString() ?? "")
        
        if let timeInterval = aps["date"] as? Double, (timeInterval + 60) < Date().timeIntervalSince1970 {
            //printlnDebug("Call Expired")
            //printlnDebug("\((timeInterval + 60)) < \(Date().timeIntervalSince1970)")
            return
        }
        
        let callerJSON = JSON(aps)
        guard let caller = Caller(json: callerJSON) else {
            
            if (aps["type"] as? String) == "disconnect" {
                removeAllLocalNotifications()
                AppUserDefaults.removeValue(forKey: .notificationUserInfo)
                endAllCalls()
            }
            
            return
        }
        
        let appState = UIApplication.shared.applicationState
        
        if appState == .active {
            let topVC = UIApplication.topViewController()
            
            if (topVC is CallVC) || (topVC is RTCVideoChatVC) {
                sendBusy(to: caller)
                
            } else {
                connectAndLogin(caller: caller, performing: .ring)
            }
            
        } else if #available(iOS 10.0, *) {
            
            socket.delegate = self
            
            connectAndLogin(caller: caller, performing: .none) {
                
                let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

                self.displayIncomingCall(for: caller) { _ in

                    // pre-heat the AVAudioSession
                    configureAudioSession()
                    
                    // start time out timer
                    self.setupTimeoutTimer()

                    UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                }
            }
        } else if AppUserDefaults.value(forKey: .notificationUserInfo, fallBackValue: JSON.null) != JSON.null {
            sendBusy(to: caller)
            
        } else {
            let notification = UILocalNotification()
            notification.fireDate = Date()
            notification.alertBody = "\(caller.name) is calling."
            notification.category = "ANSWER_CATEGORY"
            let userInfo = ["aps": caller.dictionaryObject]
            notification.userInfo = userInfo
            UIApplication.shared.scheduleLocalNotification(notification)
            AppUserDefaults.save(value: userInfo, forKey: .notificationUserInfo)
        }
    }
    
    func sendBusy(to caller: Caller) {
        let json: JSONDictionary = ["type": "busy", "name": caller.loginId]
        CommonFunctions.writeToSocket(json)
    }
    
    func showCallScene(on controller: UIViewController?, with caller: Caller) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let callScene = storyboard.instantiateViewController(withIdentifier: "CallID") as! CallVC
        callScene.caller = caller
        
        if let navCont = controller?.navigationController {
            navCont.pushViewController(callScene, animated: true)
        } else {
            let navCont = UINavigationController(rootViewController: callScene)
            controller?.present(navCont, animated: true, completion: nil)
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        //printlnDebug("token invalidated")
    }
    
    // Display the incoming call to the user
    @available(iOS 10.0, *)
    func displayIncomingCall(for caller: Caller, completion: ((NSError?) -> Void)? = nil) {
        if let providerDelegate = providerDelegate as? ProviderDelegate {
            providerDelegate.reportIncomingCall(for: caller, completion: completion)
        }
    }
    
    func endAllCalls() {
        if #available(iOS 10.0, *),
            let callMngr = callManager as? CallManager {
            callMngr.calls.forEach({ call in
                callMngr.end(call)
            })
        }
    }
}
