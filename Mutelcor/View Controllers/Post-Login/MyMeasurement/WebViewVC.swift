//
//  WebViewVC.swift
//  Mutelcor
//
//  Created by on 05/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol HealthApiLoginDelegate: class {
    func codeRetrieved(_ code: String, openWebViewVC: OpenWebViewVC)
}

enum OpenWebViewVC {
    case iHealth
    case fitbit
    case termsAndCondition
    case other
}

class WebViewVC: BaseViewController {
    
    //    MARK:- Proporties
    //    =================
    var openWebViewVC: OpenWebViewVC = .other
    var webViewUrl: String?
    var screenName = ""
    var iHealthAuthUrl: URL!
    weak var delegate: HealthApiLoginDelegate?
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var webViewOutlt: UIWebView!
    
    //    MARK:- ViewController LIfe Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigationControllerFor: NavigationControllerOn = self.openWebViewVC == .termsAndCondition ? .login : .dashboard
        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = navigationControllerFor
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: screenName)
    }
}

//MARK:- UIWebViewDelegate Methods
//================================
extension WebViewVC: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        var callbackUrl: String = ""
        
        switch self.openWebViewVC {
        case .fitbit:
            callbackUrl = WebServices.EndPoint.fitbitCallBackUrl.url
        case .iHealth:
            callbackUrl = WebServices.EndPoint.iHealthAuthiOSCallbackUrl.url
        case .other:
            return true
        default:
            return true
        }

        let iHealthAuthiOSSuccessCallbackUrl = "\(callbackUrl)?code="
        let iHealthAuthiOSFailureCallbackUrl = "\(callbackUrl)?error="
        
        if let urlStr = request.url?.absoluteString, urlStr.contains(iHealthAuthiOSSuccessCallbackUrl) {
            let code = urlStr.replacingOccurrences(of: iHealthAuthiOSSuccessCallbackUrl, with: "")
            let reterivedCode = code//.replacingOccurrences(of: "#_=_", with: "")
            self.delegate?.codeRetrieved(reterivedCode, openWebViewVC: self.openWebViewVC)
            navigationController?.popViewController(animated: true)
        } else if let url = request.url, url.absoluteString.contains(iHealthAuthiOSFailureCallbackUrl) {
            var components = JSONDictionary()
            for component in url.pathComponents {
                let keyValuePair: [String] = component.components(separatedBy: "=")
                if keyValuePair.count < 2 {
                    continue
                }
                if let key = keyValuePair.first {
                    components[key] = keyValuePair.last
                }
            }
            
            if let errorStr = components["error_description"] as? String {
                let errorArr: [String] = errorStr.components(separatedBy: "+")
                let errorMessage = errorArr.joined(separator: " ")
                showToastMessage(errorMessage)
            }
            navigationController?.popViewController(animated: true)
        } else {
            return true
        }
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        AppNetworking.showLoader()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        AppNetworking.hideLoader()
    }
}

//Mark:- Methods
//==============
extension WebViewVC {
    
    fileprivate func setupUI(){
        self.webViewOutlt.delegate = self
        self.floatBtn.isHidden = true
        
        self.view.backgroundColor = #colorLiteral(red: 0.9332545996, green: 0.9333854318, blue: 0.9332134128, alpha: 1)
        
        switch self.openWebViewVC {
            
        case .fitbit:
            screenName = K_FITBIT.localized
            webViewOutlt.loadRequest(URLRequest(url: iHealthAuthUrl))
        case .iHealth:
            screenName = K_IHEALTH.localized
            webViewOutlt.loadRequest(URLRequest(url: iHealthAuthUrl))
        case .termsAndCondition:
            self.loadWebView()
        default:
            screenName = K_ATTACHMENTS_SECTION_TITLE_PLACEHOLDER.localized.lowercased().capitalized
            self.loadWebView()
        }
    }
    
   fileprivate func loadWebView(){
        if let urlStr = self.webViewUrl {
            if !urlStr.isEmpty {
                let removeSpaceURl = urlStr.replacingOccurrences(of: " ", with: "%20")
                if let url = URL(string: removeSpaceURl){
                    self.webViewOutlt.loadRequest(URLRequest(url: url))
                }
            }
        }
    }
}
