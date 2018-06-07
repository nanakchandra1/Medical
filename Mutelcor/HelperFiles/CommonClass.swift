//
//  GTToast.swift
//  Mutelcor
//
//  Created by  on 24/04/17.
//  Copyright © 2017. All rights reserved.
//

import GTToast

class CommonFunctions {

    final class func configureSlideMenu() {
        SlideMenuOptions.contentViewDrag = false
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.shadowOpacity = 0.5
        SlideMenuOptions.shadowRadius = 5
        SlideMenuOptions.opacityViewBackgroundColor = UIColor.black
        SlideMenuOptions.contentViewOpacity = 0.7
    }
    
   static let toastConfigure = GTToastConfig(contentInsets: UIEdgeInsetsMake(10, 10, 10, 10),
                                       cornerRadius: 2.0,
                                       font: AppFonts.sansProRegular.withSize(12.0),
                                       textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                       textAlignment: .center,
                                       backgroundColor: UIColor.black.withAlphaComponent(0.7),
                                       animation: GTScaleAnimation(),
                                       displayInterval: 1.0,
                                       bottomMargin: 25,
                                       imageMargins: UIEdgeInsetsMake(10, 10, 10, 10),
                                       imageAlignment: .left,
                                       maxImageSize: CGSize(width: 10, height: 10))
    
    private class func convertToData(_ json: JSONDictionary) -> (Data?, Error?) {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return (data, nil)
        } catch {
            return (nil, error)
        }
    }
    
    class func writeToSocket(_ json: JSONDictionary) {
        DispatchQueue.main.async {
            let (data, error) = convertToData(json)
            if let unwrappedData = data {
                AppDelegate.shared.socket.write(data: unwrappedData)
            } else if let _ = error {
            } else {
            }
        }
    }
}
