//
//  AppFonts.swift
//  Mutelcor
//
//  Created by on 07/03/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit


enum AppFonts : String {
    
    case sanProSemiBold = "SourceSansPro-Semibold"
    case sansProRegular = "SourceSansPro-Regular"
    case sansProBold = "SourceSansPro-Bold"
    case sfCompactDisplayBold = "SF-Compact-Display-Bold"
    case sansProBoldlt = "SourceSansPro-BoldIt"
    case sansProlt = "SourceSansPro-It"
}

extension AppFonts {
    
    func withSize(_ fontSize: CGFloat) -> UIFont {
        let size = DeviceType.IS_IPHONE_5 ? fontSize - 2 : fontSize
        let font = DeviceType.IS_IPHONE_4_OR_LESS ? size - 2 : size
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: font)
    }
    
    func withDefaultSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
}

// USAGE : let font = AppFonts.Helvetica.withSize(13.0)
// USAGE : let font = AppFonts.Helvetica.withDefaultSize()
