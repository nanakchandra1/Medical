//
//  UIDeviceExtension.swift
//  Mutelcor
//
//  Created by on 12/06/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import CoreTelephony
import SystemConfiguration




extension UIDevice {
    
    var modelName: String? {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    static var getScreenSize : CGSize {
        return UIScreen.main.bounds.size
    }
    static var getScreenHeight : CGFloat{
        return UIScreen.main.bounds.height
    }
    static var getScreenWidth : CGFloat{
        return UIScreen.main.bounds.width
    }
    static var osType : String {
        return UIDevice.current.systemVersion
    }
    static var deviceModel : String {
        return UIDevice.current.name
    }
    static var UDID : String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static var getNetworkType: String {
        
        if let reachability: Reachability = Reachability.forInternetConnection(){
            reachability.startNotifier()
            let status = reachability.currentReachabilityStatus()
            switch status.rawValue {
            case 0:
                return ""
                //printlnDebug("Not Reachable")
            case 1:
                return "WiFi"
            case 2:
                //reachableViaWWAN
                
                let netInfo = CTTelephonyNetworkInfo()
                if let cRAT = netInfo.currentRadioAccessTechnology {
                    
                    switch cRAT {
                        
                    case CTRadioAccessTechnologyGPRS,
                         CTRadioAccessTechnologyEdge,
                         CTRadioAccessTechnologyCDMA1x :
                        return "2G"
                    case CTRadioAccessTechnologyWCDMA,
                         CTRadioAccessTechnologyHSDPA,
                         CTRadioAccessTechnologyHSUPA,
                         CTRadioAccessTechnologyCDMAEVDORev0,
                         CTRadioAccessTechnologyCDMAEVDORevA,
                         CTRadioAccessTechnologyCDMAEVDORevB,
                         CTRadioAccessTechnologyeHRPD:
                        return "3G"
                        
                    case CTRadioAccessTechnologyLTE:
                        return "4G"
                    default:
                        fatalError("error")
                    }
                }
            default:
                fatalError("error")
            }
        }
        return ""
    }
}

enum RadioAccessTechnology: String {
    case cdma = "CTRadioAccessTechnologyCDMA1x"
    case edge = "CTRadioAccessTechnologyEdge"
    case gprs = "CTRadioAccessTechnologyGPRS"
    case hrpd = "CTRadioAccessTechnologyeHRPD"
    case hsdpa = "CTRadioAccessTechnologyHSDPA"
    case hsupa = "CTRadioAccessTechnologyHSUPA"
    case lte = "CTRadioAccessTechnologyLTE"
    case rev0 = "CTRadioAccessTechnologyCDMAEVDORev0"
    case revA = "CTRadioAccessTechnologyCDMAEVDORevA"
    case revB = "CTRadioAccessTechnologyCDMAEVDORevB"
    case wcdma = "CTRadioAccessTechnologyWCDMA"
    case wifi = ""
    
    var description: String {
        switch self {
        case .gprs, .edge, .cdma:
            return "2G"
        case .lte:
            return "4G"
        default:
            return "3G"
        }
    }
}

enum UIUserInterfaceIdiom : Int{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}
