//
//  CallVC.swift
//  VoiceCallingDemo
//
//  Created by  on 01/09/17.
//  Copyright © 2017. All rights reserved.
//

import AVFoundation
import SwiftyJSON
import UIKit
import Starscream

// MARK: Global Enum
enum CallType {
    case send
    case receive
}

class CallVC: UIViewController {
    
    // MARK:- Properties
    // =================
    var caller: Caller!
    var callType = CallType.receive

    private var waitingTonePlayer: AVAudioPlayer?
    private var callTimeOutTimer: Timer?
    
    // MARK:- IBOutlets
    // ================
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var connectingLabel: UILabel!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    // MARK:- View Life Cycle
    // ======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        AppDelegate.shared.socket.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
        
        rejectButton.layer.cornerRadius = rejectButton.frame.height/2
        rejectButton.clipsToBounds = true
        
        acceptButton.layer.cornerRadius = acceptButton.frame.height/2
        acceptButton.clipsToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeCallingRingTone()
        AppDelegate.shared.socket.onText = nil
    }
    
    private func setupSubViews() {
        
        switch callType {
        
        case .send:
            addCallingRingTone()
            callUser()
            
        case .receive:
            addIncomingCallRingTone()
        }
        
        setupTimeoutTimer()
        setupButtons()
        userNameLabel.text = caller.name
    }
    
    private func setupTimeoutTimer() {
        callTimeOutTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timeoutCall), userInfo: nil, repeats: false)
    }
    
    private func invalidateTimeoutTimer() {
        callTimeOutTimer?.invalidate()
        callTimeOutTimer = nil
    }
    
    private func sendBusyToPeer() {
        let json = ["type": "busy", "name": caller.loginId]
        CommonFunctions.writeToSocket(json)
    }
    
    private func sendDisconnectToPeer() {
        let json = ["type": "leave", "name": caller.loginId]
        CommonFunctions.writeToSocket(json)
    }
    
    private func callUser() {
        let json: JSONDictionary = ["callerId": caller.identifier, "calleeDeviceId": caller.uuid, "callType": "incoming", "callerName": "caller"]
        CommonFunctions.writeToSocket(json)
    }
    
    private func addCallingRingTone() {
        let tonePath = Bundle.main.path(forResource: "waiting_tone", ofType: "wav")
        let toneURL = URL(fileURLWithPath: tonePath!)
        waitingTonePlayer = try? AVAudioPlayer(contentsOf: toneURL)
        waitingTonePlayer?.prepareToPlay()
        waitingTonePlayer?.numberOfLoops = -1
        waitingTonePlayer?.play()
    }
    
    private func addIncomingCallRingTone() {
        let tonePath = Bundle.main.path(forResource: "incoming", ofType: "mp3")
        let toneURL = URL(fileURLWithPath: tonePath!)
        waitingTonePlayer = try? AVAudioPlayer(contentsOf: toneURL)
        waitingTonePlayer?.prepareToPlay()
        waitingTonePlayer?.numberOfLoops = -1
        waitingTonePlayer?.play()
    }
    
    private func removeCallingRingTone() {
        waitingTonePlayer?.pause()
        waitingTonePlayer = nil
    }
    
    private func setupButtons() {
        
        switch callType {
        case .send:
            acceptButton.isHidden = true
            
        case .receive:
            acceptButton.isHidden = false
        }
    }
    
    private func acceptCall() {
        let json: JSONDictionary = ["type": "accepted", "name": caller.loginId]
        CommonFunctions.writeToSocket(json)
        
        invalidateTimeoutTimer()
        removeCallingRingTone()
        moveToVideoController()
    }
    
    private func moveToVideoController() {
        let videoChatScene = RTCVideoChatVC.instantiate(fromAppStoryboard: .Calling)
        videoChatScene.caller = caller
        videoChatScene.modalTransitionStyle = .flipHorizontal
        navigationController?.pushViewController(videoChatScene, animated: true)
    }
    
    @objc private func timeoutCall() {
        switch callType {
        case .send:
            sendDisconnectToPeer()
            
        case .receive:
            break
        }
        
        disconnectCall()
    }
    
    fileprivate func disconnectCall() {
        
        removeCallingRingTone()
        invalidateTimeoutTimer()

        AppDelegate.shared.endAllCalls()
        navigationController?.dismiss(animated: true, completion: nil)

        delay(2.0) {
            AppDelegate.shared.socket.disconnect()
        }
    }
    
    // MARK: IBActions
    @IBAction func rejectButtonTapped(_ sender: UIButton) {
        sendBusyToPeer()
        disconnectCall()
    }
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        acceptCall()
    }
}

// MARK: WebSocketDelegate
extension CallVC: WebSocketDelegate {
    
    func websocketDidConnect(socket: WebSocket) {
        //printlnDebug("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
//        if let err = error {
            //printlnDebug("websocket is disconnected: \(err.localizedDescription)")
//        } else {
            //printlnDebug("websocket is disconnected")
//        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        //printlnDebug("got some text: \(text)")
        
        let json = JSON(parseJSON: text)
        guard let type = SocketDataType(rawValue: json["type"].stringValue),
            type == .ended else {
                return
        }
        
        disconnectCall()
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        //printlnDebug("got some data: \(data.count)")
    }
    
}
