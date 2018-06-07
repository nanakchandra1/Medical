/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 CallKit provider delegate class, which conforms to CXProviderDelegate protocol
 */

import UIKit
import CallKit
import WebRTC

@available(iOS 10.0, *)
final class ProviderDelegate: NSObject {
    
    let callManager: CallManager
    fileprivate let provider: CXProvider
    
    init(callManager: CallManager) {
        self.callManager = callManager
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        
        super.init()
        
        provider.setDelegate(self, queue: nil)
    }
    
    /// The app's provider configuration, representing its CallKit capabilities
    static var providerConfiguration: CXProviderConfiguration {
        
        let providerConfiguration = CXProviderConfiguration(localizedName: "MutelCore")
        
        providerConfiguration.supportsVideo = true
        
        providerConfiguration.maximumCallsPerCallGroup = 1
        
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        
        if let iconMaskImage = UIImage(named: "IconMask") {
            providerConfiguration.iconTemplateImageData = UIImagePNGRepresentation(iconMaskImage)
        }
        
        //providerConfiguration.ringtoneSound = "Ringtone.caf"
        
        return providerConfiguration
    }
    
    // MARK: Incoming Calls
    
    /// Use CXProvider to report the incoming call to the system
    func reportIncomingCall(for caller: Caller, completion: ((NSError?) -> Void)? = nil) {
        // Construct a CXCallUpdate describing the incoming call, including the caller.
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: caller.identifier)
        update.localizedCallerName = caller.name
        update.hasVideo = caller.hasVideo
        
        // Report the incoming call to the system
        provider.reportNewIncomingCall(with: caller.uuid, update: update) { error in
            /*
             Only add incoming call to the app's list of calls if the call was allowed (i.e. there was no error)
             since calls may be "denied" for various legitimate reasons. See CXErrorCodeIncomingCallError.
             */
            if error == nil {
                let call = Call(uuid: caller.uuid, handle: caller.name, firstname: caller.firstname, userId: caller.identifier)
                self.callManager.add(call)
                configureAudioSession()
            }
            
            completion?(error as NSError?)
        }
    }
}
// MARK: - CXProviderDelegate

@available(iOS 10.0, *)
extension ProviderDelegate: CXProviderDelegate {
    
    func providerDidReset(_ provider: CXProvider) {
        
        stopAudio()
        
        /*
         End any ongoing calls if the provider resets, and remove them from the app's list of calls,
         since they are no longer valid.
         */
        for call in callManager.calls {
            call.end()
        }
        
        // Remove all calls from the app's list of calls.
        callManager.removeAllCalls()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        // Create & configure an instance of Call, the app's model class representing the new outgoing call.
        let userId = AppUserDefaults.value(forKey: .userId).stringValue
        let firstname = AppUserDefaults.value(forKey: .firstname).stringValue
        let call = Call(uuid: action.callUUID, isOutgoing: true, handle: action.handle.value, firstname: firstname, userId: userId)
        
        /*
         Configure the audio session, but do not start call audio here, since it must be done once
         the audio session has been activated by the system after having its priority elevated.
         */
        configureAudioSession()
        
        /*
         Set callback blocks for significant events in the call's lifecycle, so that the CXProvider may be updated
         to reflect the updated state.
         */
        call.hasStartedConnectingDidChange = { [weak self] in
            self?.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: call.connectingDate)
        }
        call.hasConnectedDidChange = { [weak self] in
            self?.provider.reportOutgoingCall(with: call.uuid, connectedAt: call.connectDate)
        }
        
        // Trigger the call to be started via the underlying network service.
        call.start { success in
            if success {
                // Signal to the system that the action has been successfully performed.
                action.fulfill()
                
                // Add the new outgoing call to the app's list of calls.
                self.callManager.add(call)
            } else {
                // Signal to the system that the action was unable to be performed.
                action.fail()
            }
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        // Retrieve the Call instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        
        /*
         Configure the audio session, but do not start call audio here, since it must be done once
         the audio session has been activated by the system after having its priority elevated.
         */
        configureAudioSession()
        
        // Trigger the call to be answered via the underlying network service.
        call.answer()
        
        // Signal to the system that the action has been successfully performed.
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // Retrieve the Call instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        
        // Stop call audio whenever ending the call.
        stopAudio()
        
        // Trigger the call to be ended via the underlying network service.
        call.end()
        
        // Signal to the system that the action has been successfully performed.
        action.fulfill()
        
        // Remove the ended call from the app's list of calls.
        callManager.remove(call)
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        // Retrieve the Call instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        
        // Update the Call's underlying hold state.
        call.isOnHold = action.isOnHold
        
        // Stop or start audio in response to holding or unholding the call.
        if call.isOnHold {
            stopAudio()
        } else {
            startAudio()
        }
        
        // Signal to the system that the action has been successfully performed.
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        print("Timed out \(#function)")
        
        // React to the action timeout if necessary, such as showing an error UI.
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("Received \(#function)")
        RTCAudioSession.sharedInstance().audioSessionDidActivate(audioSession)

        // Start call audio media, now that the audio session has been activated after having its priority boosted.
        startAudio()
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("Received \(#function)")
        RTCAudioSession.sharedInstance().audioSessionDidDeactivate(audioSession)
        
        /*
         Restart any non-call related audio now that the app's audio session has been
         de-activated after having its priority restored to normal.
         */
        callManager.calls.forEach { call in
            call.end()
        }
        callManager.removeAllCalls()
    }
    
}
