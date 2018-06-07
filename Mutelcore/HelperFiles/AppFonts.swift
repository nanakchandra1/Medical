//
//  AppFonts.swift
//  Mutelcore
//
//  Created by Appinventiv on 07/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit


enum AppFonts : String {
    
    case SFUIdisplay = "SF-UI-Display-Regular"
    case SFUIDisplayMed = "SF-UI-Display-Medium"
    case SFUIDisplayBold = "SF-UI-Display-Bold"
    case SFUIText = "SF-UI-Text-Regular"
    case SFUITextBold = "SF-UI-BOLD"
    case SFUITextSemi  = "SF-UI-Text-Semibold"
    case sanProSemiBold = "SourceSansPro-Semibold"
    case sansProRegular = "SourceSansPro-Regular"
    case sansProBold = "SourceSansPro-Bold"
    case sfCompactDisplayBold = "SF-Compact-Display-Bold"
    case SFUIDisplaySemi = "SF-UI-Display-Semibold"
    
}

extension AppFonts {
    
    func withSize(_ fontSize: CGFloat) -> UIFont {
        
        return UIFont(name: self.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    func withDefaultSize() -> UIFont {
        
        return UIFont(name: self.rawValue, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
}

// USAGE : let font = AppFonts.Helvetica.withSize(13.0)
// USAGE : let font = AppFonts.Helvetica.withDefaultSize()
