/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 High-level call audio management functions
 */

import Foundation

private var audioController: AudioController?

func configureAudioSession() {
    
    if audioController == nil {
        audioController = AudioController()
    }
}

func startAudio() {
}

func stopAudio() {
    audioController = nil
}

func configureAVAudioSession() {
    let session = AVAudioSession.sharedInstance()
    
    do {
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .duckOthers)
    } catch {
    }
    
    do {
        try session.setMode(AVAudioSessionModeVoiceChat)
    } catch {
    }
    
    do {
        try session.setPreferredIOBufferDuration(0.005)
    } catch {
    }
    
    do {
        try session.setPreferredSampleRate(44100)
    } catch {
    }
}

