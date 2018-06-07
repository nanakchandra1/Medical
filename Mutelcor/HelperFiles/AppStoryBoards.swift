//
//  AppStoryBoards.swift
//  Mutelcor
//
//  Created by on 07/03/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    
    case Main
    case ProfileBuildUp
    case Message
    case Measurement
    case AppointMent
    case Dashboard
    case Notification
    case LogBook
    case GenerateHealthReport
    case DischargeSummary
    case ConnectedDevices
    case UserGuide
    case Help
    case Settings
    case MedicationReminder
    case ePrescription
    case Calender
    case Activity
    case Nutrition
    case CMS
    case Symptoms
    case Calling
    case Timeline
}

extension AppStoryboard {
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(_ viewControllerClass : T.Type,
                        function : String = #function, // debugging purposes
        line : Int = #line,
        file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(self)
    }
}

