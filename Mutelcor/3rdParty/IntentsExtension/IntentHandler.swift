/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	Intents handler principal class
*/

import Intents

@available(iOS 10.0, *)
class IntentHandler: INExtension, INStartAudioCallIntentHandling, INStartVideoCallIntentHandling {
    func handle(intent: INStartAudioCallIntent, completion: @escaping (INStartAudioCallIntentResponse) -> Void) {
        let response: INStartAudioCallIntentResponse
        defer {
            completion(response)
        }
        
        // Ensure there is a person handle
        guard intent.contacts?.first?.personHandle != nil else {
            response = INStartAudioCallIntentResponse(code: .failure, userActivity: nil)
            return
        }
        
        let userActivity = NSUserActivity(activityType: String(describing: INStartAudioCallIntent.self))
        
        response = INStartAudioCallIntentResponse(code: .continueInApp, userActivity: userActivity)
    }
    
    func handle(intent: INStartVideoCallIntent, completion: @escaping (INStartVideoCallIntentResponse) -> Swift.Void) {
        let response: INStartVideoCallIntentResponse
        defer {
            completion(response)
        }
        
        // Ensure there is a person handle
        guard intent.contacts?.first?.personHandle != nil else {
            response = INStartVideoCallIntentResponse(code: .failure, userActivity: nil)
            return
        }
        
        let userActivity = NSUserActivity(activityType: String(describing: INStartVideoCallIntent.self))
        
        response = INStartVideoCallIntentResponse(code: .continueInApp, userActivity: userActivity)
    }

}
