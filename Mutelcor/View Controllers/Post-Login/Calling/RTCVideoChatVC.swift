//
//  CallVC.swift
//  de
//
//  Created by  on 01/09/17.
//  Copyright © 2017. All rights reserved.
//

import Starscream
import SwiftyJSON
import UIKit
import WebRTC

// MARK: Global Enum
enum SocketDataType: String {
    case offer
    case answer
    case candidate
    case leave
    case ended
}

class RTCVideoChatVC: UIViewController {
    
    var caller: Caller!
    
    var videoClient: RTCClient!
    var callType = CallType.receive
    var isZoom = false //used for double tap remote view

    var localVideoTrack: RTCVideoTrack?
    var remoteVideoTrack: RTCVideoTrack?
    var localVideoSize: CGSize?
    var remoteVideoSize: CGSize?
    
    //Views, Labels, and Buttons Outlets
    @IBOutlet weak var localVideoView: RTCEAGLVideoView!
    @IBOutlet weak var remoteVideoView: RTCEAGLVideoView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var hangupButton: UIButton!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!

    //Auto Layout Constraints used for animations
    @IBOutlet weak var remoteViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var remoteViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var remoteViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var remoteViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var localViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var localViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var localViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var localViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonContainerViewLeftConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.shared.socket.delegate = self
        remoteVideoView.delegate = self
        localVideoView.delegate = self
        
        let acceptCallJson = ["type": "accepted", "name": caller.loginId]
        CommonFunctions.writeToSocket(acceptCallJson)
        
        configureVideoClient()
        addGestures()
        addOrientationObserver()
        
        audioButton.layer.cornerRadius = 20.0
        videoButton.layer.cornerRadius = 20.0
        hangupButton.layer.cornerRadius = 20.0
        speakerButton.layer.cornerRadius = 20.0
        switchCameraButton.layer.cornerRadius = 20.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        localViewBottomConstraint?.constant = 0.0
        localViewRightConstraint?.constant = 0.0
        localViewHeightConstraint?.constant = view.frame.size.height
        localViewWidthConstraint?.constant = view.frame.size.width
        footerViewBottomConstraint?.constant = 0.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func addGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleButtonContainer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        let zoomGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomRemote))
        zoomGestureRecognizer.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addGestureRecognizer(zoomGestureRecognizer)
    }
    
    func addOrientationObserver() {
        let deviceOrientationDidChangeNotification = Notification.Name(rawValue: "UIDeviceOrientationDidChangeNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(_:)), name: deviceOrientationDidChangeNotification, object: nil)
    }
    
    func configureVideoClient() {
        let videoUrl = "turn:turn.mutelcor.com:5349?transport=udp"//"turn:52.8.169.78:3478?transport=udp" //"turn.mutelcor.com:5349"
        let videoUserName = "jumbo" //"appinventiv"
        let password = "jumbo" //"fnkawfjwkaf38uw89q3j2q309fjsoe48jo843wfjdros48"
        let jumboIceServer = RTCIceServer(urlStrings: [videoUrl], username: videoUserName, credential: password)
        let googleIceServer = RTCIceServer(urlStrings: ["stun:stun2.l.google.com:19302"])
        
        let client = RTCClient(iceServers: [jumboIceServer, googleIceServer], videoCall: true)
        client.delegate = self
        videoClient = client
        client.startConnection()
    }
    
    @objc func orientationChanged(_ notification: Notification) {
        if let localVideoSize = self.localVideoSize {
            videoView(localVideoView, didChangeVideoSize: localVideoSize)
        }
        if let remoteVideoSize = self.remoteVideoSize {
            videoView(remoteVideoView, didChangeVideoSize: remoteVideoSize)
        }
    }
    
    func disconnect() {
        localVideoTrack?.remove(localVideoView)
        remoteVideoTrack?.remove(remoteVideoView)
        localVideoView.renderFrame(nil)
        remoteVideoView.renderFrame(nil)
        localVideoTrack = nil
        remoteVideoTrack = nil
        
        videoClient.disconnect()
        delay(2.0) {
            AppDelegate.shared.socket.disconnect()
        }
        AppDelegate.shared.endAllCalls()
        
        //navigationController?.popToRootViewController(animated: true)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func remoteDisconnected() {
        self.remoteVideoTrack?.remove(self.remoteVideoView)
        self.remoteVideoView?.renderFrame(nil)
        if self.localVideoSize != nil {
            self.videoView(self.localVideoView!, didChangeVideoSize: self.localVideoSize!)
        }
    }
    
    @objc func toggleButtonContainer() {
        UIView.animate(withDuration: 0.3, animations: {
            if (self.buttonContainerViewLeftConstraint.constant <= -40.0) {
                self.buttonContainerViewLeftConstraint.constant = 20.0
                self.buttonContainerView.alpha = 1.0
            }
            else {
                self.buttonContainerViewLeftConstraint.constant = -40.0
                self.buttonContainerView!.alpha = 0.0
            }
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func zoomRemote() {
        //Toggle Aspect Fill or Fit
        isZoom = !isZoom
        if let remoteVideoSize = self.remoteVideoSize {
            videoView(remoteVideoView, didChangeVideoSize: remoteVideoSize)
        }
    }
    
    func sendDisconnectToPeer() {
        let json = ["type": "leave", "name": caller.loginId]
        CommonFunctions.writeToSocket(json)
    }
    
    // MARK: IBActions
    @IBAction func audioButtonPressed (_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? videoClient.muteAudio() : videoClient.unmuteAudio()
    }
    
    @IBAction func videoButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? videoClient.muteVideo() : videoClient.unmuteVideo()
    }
    
    @IBAction func hangupButtonPressed(_ sender: UIButton) {
        sendDisconnectToPeer()
        disconnect()
        AppDelegate.shared.endAllCalls()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func speakerButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? videoClient.enableSpeaker() : videoClient.disableSpeaker()
    }
    
    @IBAction func switchCameraPressed(_ sender: UIButton) {
        videoClient.switchCamera()
    }

}

// MARK: RTCClient Delegate Methods
extension RTCVideoChatVC: RTCEAGLVideoViewDelegate {
    
    func videoView(_ videoView: RTCEAGLVideoView, didChangeVideoSize size: CGSize) {
        DispatchQueue.main.async {
            let orientation: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
            UIView.animate(withDuration: 0.4, animations: {
                let containerWidth = self.view.frame.size.width
                let containerHeight = self.view.frame.size.height
                let defaultAspectRatio = CGSize(width:4, height:3)
                if videoView == self.localVideoView {
                    
                    //CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width / 4.0, height: self.view.frame.size.height / 4.0)
                    self.localVideoSize = size
                    let aspectRatio = size.equalTo(.zero) ? defaultAspectRatio : size
                    var videoRect = self.view.bounds
                    if (self.remoteVideoTrack != nil) {
                        videoRect = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width / 4.0, height: self.view.frame.size.height / 4.0)
                        if orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight {
                            videoRect = CGRect(x:0.0,y: 0.0, width:self.view.frame.size.height / 4.0, height: self.view.frame.size.width / 4.0)
                        }
                    }
                    let videoFrame = AVMakeRect(aspectRatio: aspectRatio, insideRect: videoRect)
                    self.localViewWidthConstraint.constant = videoFrame.size.width
                    self.localViewHeightConstraint.constant = videoFrame.size.height
                    if (self.remoteVideoTrack != nil) {
                        self.localViewBottomConstraint.constant = 28.0
                        self.localViewRightConstraint.constant = 28.0
                    }
                    else{
                        self.localViewBottomConstraint.constant = containerHeight/2.0 - videoFrame.size.height/2.0
                        self.localViewRightConstraint.constant = containerWidth/2.0 - videoFrame.size.width/2.0
                    }
                }
                else if videoView == self.remoteVideoView {
                    self.remoteVideoSize = size
                    let aspectRatio = size.equalTo(CGSize(width: 0, height: 0)) ? defaultAspectRatio : size
                    let videoRect = self.view.bounds
                    var videoFrame = AVMakeRect(aspectRatio: aspectRatio, insideRect: videoRect)
                    if self.isZoom {
                        let scale = max(containerWidth / videoFrame.size.width, containerHeight / videoFrame.size.height)
                        videoFrame.size.width *= scale
                        videoFrame.size.height *= scale
                    }
                    self.remoteViewTopConstraint.constant = (containerHeight / 2.0 - videoFrame.size.height / 2.0)
                    self.remoteViewBottomConstraint.constant = (containerHeight / 2.0 - videoFrame.size.height / 2.0)
                    self.remoteViewLeftConstraint.constant = (containerWidth / 2.0 - videoFrame.size.width / 2.0)
                    self.remoteViewRightConstraint.constant = (containerWidth / 2.0 - videoFrame.size.width / 2.0)
                }
                self.view.layoutIfNeeded()
            })
        }
    }
}

// MARK: RTCClient Delegate Methods
extension RTCVideoChatVC: RTCClientDelegate {
    
    func rtcClient(client : RTCClient, startCallWithSdp sdp: String) {
        let type = (callType == .receive) ? "answer" : "offer"
        let json: JSONDictionary = ["type": type, "name": caller.loginId, "sdp": ["type": type, "sdp": sdp]]
        CommonFunctions.writeToSocket(json)
    }
    
    func rtcClient(client : RTCClient, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack) {
        // Use localVideoTrack generated for rendering stream to remoteVideoView
        localVideoTrack.add(localVideoView)
        self.localVideoTrack = localVideoTrack
    }
    
    func rtcClient(client : RTCClient, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack) {
        // Use remoteVideoTrack generated for rendering stream to remoteVideoView
        remoteVideoTrack.add(remoteVideoView)
        self.remoteVideoTrack = remoteVideoTrack
        
        // Update local video view constraints when remote video view is updated
        if let localVideoSize = localVideoSize {
            videoView(localVideoView, didChangeVideoSize: localVideoSize)
        }
    }
    
    func rtcClient(client : RTCClient, didGenerateIceCandidate iceCandidate: RTCIceCandidate) {
        let json: JSONDictionary = ["type": "candidate", "name": caller.loginId,
                                    "candidate": iceCandidate.jsonDictionary]
        CommonFunctions.writeToSocket(json)
    }
    
    func rtcClient(client : RTCClient, didReceiveError error: Error) {
        //printlnDebug(error.localizedDescription)
    }
    
    func rtcClient(client : RTCClient, didChangeState state: RTCClientState) {
        DispatchQueue.main.async {
            guard #available(iOS 10.0, *),
                let callManager = AppDelegate.shared.callManager as? CallManager,
                let call = callManager.callWithUUID(uuid: self.caller.uuid)else {
                    return
            }
            
            switch state {
            case .connected:
                call.hasConnected = true
                call.startCallCompletion?(true)
            case .connecting:
                call.hasStartedConnecting = true
            case .disconnected:
                call.hasEnded = true
            }
        }
    }
    
}

// MARK: WebSocketDelegate
extension RTCVideoChatVC: WebSocketDelegate {
    
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
        guard let type = SocketDataType(rawValue: json["type"].stringValue) else {
            return
        }
        
        switch type {
        case .offer:
            videoClient.createAnswerForOfferReceived(withRemoteSDP: json["offer"]["sdp"].stringValue)
            
        case .answer:
            videoClient.handleAnswerReceived(withRemoteSDP: json["answer"]["sdp"].stringValue)
            
        case .candidate:
            let iceCandidate = RTCIceCandidate(json: json)
            videoClient.addIceCandidate(iceCandidate: iceCandidate)
            
        case .leave:
            disconnect()
            
        case .ended:
            break
        }
        
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        //printlnDebug("got some data: \(data.count)")
    }
    
}
