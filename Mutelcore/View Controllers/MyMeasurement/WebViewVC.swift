//
//  WebViewVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 05/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class WebViewVC: BaseViewController {

//    MARK:- Proporties
//    =================
    
    var webViewUrl : String?
    var screenName = ""
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var webViewOutlt: UIWebView!
    
//    MARK:- ViewController LIfe Cycle
//    ================================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.floatBtn.isHidden = true
        
        if let urlStr = self.webViewUrl {
            
            if !urlStr.isEmpty {
                
                printlnDebug("str : \(urlStr)")
                
                let removeSpaceURl = urlStr.trimmingCharacters(in: .whitespaces)
                
              self.webViewOutlt.loadRequest(URLRequest(url: URL(string: removeSpaceURl)!))
            
            }
        }
        
        self.view.backgroundColor = #colorLiteral(red: 0.9332545996, green: 0.9333854318, blue: 0.9332134128, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .BackBtn
        self.navigationControllerOn = .dashboard
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar(screenName, 2, 3)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
