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
import Starscream

// MARK: WebSocketDelegate
extension AppDelegate: WebSocketDelegate {
    
    func websocketDidConnect(socket: WebSocket) {
        //printlnDebug("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
//        if let err = error {
//            printlnDebug("websocket is disconnected: \(err.localizedDescription)")
//        } else {
//            printlnDebug("websocket is disconnected")
//        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        //printlnDebug("got some text: \(text)")
        
        let json = JSON(parseJSON: text)
        guard let type = SocketDataType(rawValue: json["type"].stringValue),
            type == .ended else {
            return
        }
        
        AppDelegate.shared.endAllCalls()
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        //printlnDebug("got some data: \(data.count)")
    }
    
}
