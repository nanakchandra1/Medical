//
//  AppNetworking+Loader.swift
//  TNIGHT
//
//  Created by Ashish on 08/03/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

import Foundation
import UIKit

extension AppNetworking {
    
    static func showLoader () {
        
        DispatchQueue.main.async {
            ActivityLoader.start()
        
        }
    }
    
    static func hideLoader () {
        
        DispatchQueue.main.async {
            ActivityLoader.stop()
        }
    }
}

let ActivityLoader = LoaderClass()

class LoaderClass : UIView {
    
    private let spinnerBackView = UIView()
    private let spinner = JTMaterialSpinner()
    
    var isLoading = false
    
    
    private override init(frame: CGRect) {
        let screenSize = UIDevice.getScreenSize

        super.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        self.isUserInteractionEnabled = true

        let spinnerBackViewWidth : CGFloat = 100
        let spinnerBackViewHeight : CGFloat = 100
        
        self.spinner.frame = CGRect(x: self.bounds.origin.x + 20, y: self.bounds.origin.y, width: 60, height: 60)
        self.spinner.circleLayer.lineWidth = 2.0
        self.spinner.circleLayer.strokeColor = UIColor.appColor.cgColor
        
        self.spinnerBackView.frame = CGRect(x: (screenSize.width - spinnerBackViewWidth)/2,y: (screenSize.height - spinnerBackViewHeight)/2, width: spinnerBackViewWidth, height: spinnerBackViewHeight)

        self.spinnerBackView.backgroundColor = UIColor.clear //(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.spinnerBackView.layer.cornerRadius = 20.0
        self.spinnerBackView.clipsToBounds = true
        self.spinnerBackView.addSubview(self.spinner)

        self.addSubview(self.spinnerBackView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Not Loading Properly")
    }
    
    func start() {
        if self.isLoading {
            return
        }
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        self.spinner.beginRefreshing()
        self.isLoading = true
    }
    
    func stop() {
        self.spinner.endRefreshing()
        self.removeFromSuperview()
        self.isLoading = false
    }
}
