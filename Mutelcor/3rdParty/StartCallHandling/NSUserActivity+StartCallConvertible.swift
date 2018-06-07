/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Extension to allow creating a CallKit CXStartCallAction from an NSUserActivity which the app was launched with
 */

import Foundation
import Intents

extension NSUserActivity: StartCallConvertible {
    
    var startCallHandle: String? {
        guard #available(iOS 10.0, *),
            let interaction = interaction,
            let startCallIntent = interaction.intent as? SupportedStartCallIntent,
            let contact = startCallIntent.contacts?.first
            else {
                return nil
        }
        
        return contact.personHandle?.value
    }
    
    var video: Bool? {
        guard #available(iOS 10.0, *),
            let interaction = interaction,
            let startCallIntent = interaction.intent as? SupportedStartCallIntent
            else {
                return nil
        }
        
        return startCallIntent is INStartVideoCallIntent
    }
    
}

@available(iOS 10.0, *)
protocol SupportedStartCallIntent {
    var contacts: [INPerson]? { get }
}

@available(iOS 10.0, *)
extension INStartAudioCallIntent: SupportedStartCallIntent {}

@available(iOS 10.0, *)
extension INStartVideoCallIntent: SupportedStartCallIntent {}
