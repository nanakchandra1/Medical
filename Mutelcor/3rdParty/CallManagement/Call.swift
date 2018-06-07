/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	Model class representing a single call
*/

import Foundation

final class Call {

    // MARK: Metadata Properties

    let uuid: UUID
    let isOutgoing: Bool
    let handle: String
    let userId: String
    let firstname: String

    // MARK: Call State Properties

    var connectingDate: Date? {
        didSet {
            stateDidChange?()
            hasStartedConnectingDidChange?()
        }
    }
    var connectDate: Date? {
        didSet {
            stateDidChange?()
            hasConnectedDidChange?()
        }
    }
    var endDate: Date? {
        didSet {
            stateDidChange?()
            hasEndedDidChange?()
        }
    }
    var isOnHold = false {
        didSet {
            stateDidChange?()
        }
    }

    // MARK: State change callback blocks

    var stateDidChange: (() -> Void)?
    var hasStartedConnectingDidChange: (() -> Void)?
    var hasConnectedDidChange: (() -> Void)?
    var hasEndedDidChange: (() -> Void)?

    // MARK: Derived Properties

    var hasStartedConnecting: Bool {
        get {
            return connectingDate != nil
        }
        set {
            connectingDate = newValue ? Date() : nil
        }
    }
    var hasConnected: Bool {
        get {
            return connectDate != nil
        }
        set {
            connectDate = newValue ? Date() : nil
        }
    }
    var hasEnded: Bool {
        get {
            return endDate != nil
        }
        set {
            endDate = newValue ? Date() : nil
        }
    }
    var duration: TimeInterval {
        guard let connectDate = connectDate else {
            return 0
        }

        return Date().timeIntervalSince(connectDate)
    }
    
    var startCallCompletion: ((Bool) -> Void)?

    // MARK: Initialization

    init(uuid: UUID, isOutgoing: Bool = false, handle: String, firstname: String, userId: String) {
        self.uuid = uuid
        self.isOutgoing = isOutgoing
        self.handle = handle
        self.userId = userId
        self.firstname = firstname
    }

    // MARK: Actions

    func start(completion: ((_ success: Bool) -> Void)?) {
        startCallCompletion = completion
    }

    func answer() {
        
        hasStartedConnecting = true
        AppDelegate.shared.invalidateTimeoutTimer()

        let caller = Caller(uuid: uuid, name: handle, firstname: firstname, identifier: userId, hasVideo: true, type: "calling")
        AppDelegate.shared.moveToVideoChatScene(with: caller)
    }

    func end() {
        hasEnded = true
        AppDelegate.shared.invalidateTimeoutTimer()

        // Notify user busy
        sendBusyToPeer("\(userId)_\(firstname)")
        
        //Disconnect socket
        delay(2.0) {
            AppDelegate.shared.socket.disconnect()
        }
    }
    
    private func sendBusyToPeer(_ loginId: String) {
        let json = ["type": "busy", "name": loginId]
        CommonFunctions.writeToSocket(json)
    }

}
