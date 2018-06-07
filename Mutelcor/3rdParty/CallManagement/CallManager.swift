/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	Manager of Calls, which demonstrates using a CallKit CXCallController to request actions on calls
*/

import UIKit
import CallKit

@available(iOS 10.0, *)
final class CallManager: NSObject {

    let callController = CXCallController()

    // MARK: Actions

    func startCall(handle: String, videoEnabled: Bool) {
        
        // pre-heat the AVAudioSession
        configureAudioSession()
        
        let handle = CXHandle(type: .phoneNumber, value: handle)
        let startCallAction = CXStartCallAction(call: UUID(), handle: handle)

        startCallAction.isVideo = videoEnabled

        let transaction = CXTransaction()
        transaction.addAction(startCallAction)

        requestTransaction(transaction)
    }

    func end(_ call: Call) {
        let endCallAction = CXEndCallAction(call: call.uuid)
        let transaction = CXTransaction()
        transaction.addAction(endCallAction)

        requestTransaction(transaction)
    }

    func setHeld(call: Call, onHold: Bool) {
        let setHeldCallAction = CXSetHeldCallAction(call: call.uuid, onHold: onHold)
        let transaction = CXTransaction()
        transaction.addAction(setHeldCallAction)

        requestTransaction(transaction)
    }

    private func requestTransaction(_ transaction: CXTransaction) {
        callController.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction: \(error)")
            } else {
                print("Requested transaction successfully")
            }
        }
    }

    // MARK: Call Management

    static let CallsChangedNotification = Notification.Name("CallManagerCallsChangedNotification") 

    private(set) var calls = [Call]()

    func callWithUUID(uuid: UUID) -> Call? {
        guard let index = calls.index(where: { $0.uuid == uuid }) else {
            return nil
        }
        return calls[index]
    }

    func add(_ call: Call) {
        calls.append(call)

        call.stateDidChange = { [weak self] in
            self?.postCallsChangedNotification()
        }

        postCallsChangedNotification()
    }

    func remove(_ call: Call) {
        guard let index = calls.index(where: { $0 === call }) else { return }
        calls.remove(at: index)
        postCallsChangedNotification()
    }

    func removeAllCalls() {
        calls.removeAll()
        postCallsChangedNotification()
    }

    private func postCallsChangedNotification() {
        NotificationCenter.default.post(name: type(of: self).CallsChangedNotification, object: self)
    }

    // MARK: CallDelegate

    func didChangeState(_ call: Call) {
        postCallsChangedNotification()
    }

}
