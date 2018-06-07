//
//  GTToast.swift
//  Mutelcore
//
//  Created by Ashish on 24/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import GTToast

class CommonClass {
    
    static let dateFormatter = DateFormatter()
    
    static let toastConfigure = GTToastConfig(contentInsets: UIEdgeInsetsMake(10, 10, 10, 10),
                                       cornerRadius: 2.0,
                                       font: AppFonts.sansProRegular.withSize(12.0),
                                       textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                       textAlignment: .center,
                                       backgroundColor: UIColor.black,
                                       animation: GTScaleAnimation(),
                                       displayInterval: 1.0,
                                       bottomMargin: 2.0,
                                       imageMargins: UIEdgeInsetsMake(10, 10, 10, 10),
                                       imageAlignment: .left,
                                       maxImageSize: CGSize(width: 10, height: 10))
}

