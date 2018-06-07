//
//  AppNetworking.swift
//  TNIGHT
//
//  Created by Ashish on 08/03/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


typealias JSONDictionary = [String : Any]
typealias JSONDictionaryArray = [JSONDictionary]


extension Notification.Name {
    
    static let NotConnectedToInternet = Notification.Name("NotConnectedToInternet")
}

enum AppNetworking {
    
    static func POST(endPoint : String,
                     parameters : JSONDictionary = [:],
                     headers : JSONDictionary = [:],
                     loader : Bool = true,
                     success : @escaping (JSON) -> Void,
                     failure : @escaping (Error) -> Void) {
        
        printlnDebug(parameters)
        
        
        
        request1(URLString: endPoint, httpMethod: .post, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func GET(endPoint : String,
                    parameters : JSONDictionary = [:],
                    headers : JSONDictionary = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        request1(URLString: endPoint, httpMethod: .get, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func PUT(endPoint : String,
                    parameters : JSONDictionary = [:],
                    headers : JSONDictionary = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        request1(URLString: endPoint, httpMethod: .put, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func DELETE(endPoint : String,
                       parameters : JSONDictionary = [:],
                       headers : JSONDictionary = [:],
                       loader : Bool = true,
                       success : @escaping (JSON) -> Void,
                       failure : @escaping (Error) -> Void) {
        
        
        request1(URLString: endPoint, httpMethod: .delete, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func PostWithImage(endPoint : String,
                              parameters : JSONDictionary = [:],
                              headers : JSONDictionary = [:],
                              loader : Bool = true,
                              imageData: Data? = nil,
                              imageKey: String = "",
                              success : @escaping (JSON) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        printlnDebug("imageData : \(imageData)")
        
        request(URLString: endPoint, httpMethod: .post, parameters: parameters, headers: headers, loader: loader,imageData: imageData,
                key: imageKey,  success: success, failure: failure)
    }
    
    static func PostWithMultipleData(endPoint : String,
                              parameters : JSONDictionary = [:],
                              headers : JSONDictionary = [:],
                              loader : Bool = true,
                              imageData: [String : Any] = [:],
                              success : @escaping (JSON) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        printlnDebug("imageData : \(imageData)")
        printlnDebug("parameters : \(parameters)")
        
        
        request(URLString: endPoint, httpMethod: .post, parameters: parameters, data: imageData, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    private static func request1(URLString : String,
                                httpMethod : HTTPMethod,
                                parameters : JSONDictionary = [:],
                                headers : JSONDictionary = [:],
                                loader : Bool = true,
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        printlnDebug("parameters :\(parameters)")
        if loader { showLoader() }
        
        let digestHeader = getDigestHeader(method: httpMethod.rawValue, uri: URLString)
        
        var accessToken = ""
        
        let accessTk =  AppUserDefaults.value(forKey: .accessToken, fallBackValue: "").stringValue
        
        printlnDebug("accessTk : \(accessTk)")
        
        if !accessTk.isEmpty{
            
            accessToken = accessTk
        }
        
        printlnDebug("AccessToken : \(accessToken)")
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization" : digestHeader,
                      "access_token" : accessToken]
        
        printlnDebug("Header : \(header)")
        
        Alamofire.request(URLString, method: httpMethod,
                          parameters: parameters,
                          encoding: URLEncoding.methodDependent,
                          headers: header).responseJSON { (response:DataResponse<Any>) in
                            
                            printlnDebug("p :\(parameters)")
                            if loader { hideLoader() }
                            
                            switch(response.result) {
                                
                            case .success(let value):
                                
                                printlnDebug(value)
                                
                                success(JSON(value))
                                
                            case .failure(let e):
                                
                                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                    
                                    // Handle Internet Not available UI
                                    
                                    NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                                }
                                
                                failure(e)
                            }
        }
    }
//===========Single Data===============
    private static func request(URLString : String,
                                httpMethod : HTTPMethod,
                                parameters : JSONDictionary = [:],
                                headers : JSONDictionary = [:],
                                loader : Bool = true,
                                imageData: Data?,
                                key: String,
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (Error) -> Void){
        if loader { showLoader() }
        showLoader()
        printlnDebug(parameters)
        
        let digestHeader = getDigestHeader(method: httpMethod.rawValue, uri: URLString)
        
        
        var accessToken = ""
        
        let accessTk =  AppUserDefaults.value(forKey: .accessToken, fallBackValue: "").stringValue
        
        printlnDebug("Accesstoken : \(accessTk)")
        
        if !accessTk.isEmpty{
            
            accessToken = accessTk
        }
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization" : digestHeader,
                      "access_token" : accessToken]
        
        printlnDebug("Header : \(header)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
           
            if let imgData = imageData{
              
                multipartFormData.append(imgData, withName: key, fileName: "\(key).jpg", mimeType: "image/jpeg")
           
            }
            
            let param = parameters
            
            printlnDebug("params: \(param)")
            for (key,value) in param{
                printlnDebug("key: \(key)")
                printlnDebug("value: \(value)")
                
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                
                
            }
            }, to: URLString, method: .post, headers: header , encodingCompletion: { (result) in

                switch result {
                    
                case .success(let upload,_,_ ):
                    
                    upload.responseJSON(completionHandler: { (dataResponse) in
                        switch dataResponse.result{
                        case .success(let value):
                            printlnDebug("=======")
                            printlnDebug(obj : value)
                            success(JSON(value))
                            hideLoader()
                        case .failure(let e):
                            hideLoader()
                            
                            if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                
                                // Handle Internet Not available UI
                                
                                NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                            }
                            failure(e)
                        }
                    })
                case .failure(let encodingError):
                    printlnDebug(encodingError)
                    hideLoader()
                    
                }
        })
    }
//    ==============Multiple Request=================
    private static func request(URLString : String,
                                httpMethod : HTTPMethod,
                                parameters : JSONDictionary = [:],
                                data: [String: Any]? = nil,
                                encoding: ParameterEncoding = JSONEncoding.default,
                                headers : JSONDictionary = [:],
                                loader : Bool = true,
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        
        if loader { showLoader() }
        
        let digestHeader = getDigestHeader(method: httpMethod.rawValue, uri: URLString)
        
        var accessToken = ""
        
        let accessTk =  AppUserDefaults.value(forKey: .accessToken, fallBackValue: "").stringValue
        
        if !accessTk.isEmpty{
            
            accessToken = accessTk
        }
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization" : digestHeader,
                      "access_token" : accessToken]
        
        printlnDebug("Header : \(header)")
        printlnDebug("data : \(data)")
        printlnDebug("parameters : \(parameters)")
        
        if let unwrappedData = data/*, unwrappedData.count > 0*/ {
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                for (key, data) in unwrappedData {
                    
                    printlnDebug("data :\(data)")
                    printlnDebug("key :\(key)")
                    
                    if let image = data as? UIImage{
                        
                        guard let imgData = UIImageJPEGRepresentation(image , 0.6) else { continue }
                        
                        multipartFormData.append(imgData, withName: key, fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
                        
                    }else{
                        
                        let pdfURl = "\(data)"
                        
                        if let data = data as? URL {
                            
                          let pdfData = NSData(contentsOf: data)
                          let pdfName = pdfURl.components(separatedBy: "/").last
                            printlnDebug(pdfName)
                            
                            let d = pdfName?.replacingOccurrences(of: "%20", with: " ")
                            
                            printlnDebug(d)
                            
                            multipartFormData.append(pdfData! as Data, withName: key, fileName: d!, mimeType: "pdf")
                        }
                    }
                }
                
                let param = parameters
                
                for (key, values) in param {
                    
                    printlnDebug("key \(key)")
                    printlnDebug("value : \(values)")
                    
                    multipartFormData.append("\(values)".data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, to: URLString, method: .post, headers: header , encodingCompletion: { (result) in
                
                switch result {
                    
                case .success(let upload,_,_ ):
                    
                    upload.responseJSON(completionHandler: { (dataResponse) in
                        switch dataResponse.result{
                        case .success(let value):
                            printlnDebug("=======")
                            printlnDebug(obj : value)
                            success(JSON(value))
                            hideLoader()
                        case .failure(let e):
                            hideLoader()
                            
                            if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                
                                // Handle Internet Not available UI
                                
                                NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                            }
                            failure(e)
                        }
                    })
                case .failure(let encodingError):
                    printlnDebug(encodingError)
                    hideLoader()
                    
                }
            })
        }
    }
//    Digest Auth
//    ============
    static func getDigestHeader(method : String, uri : String) -> String{
        
        let cnonce = "\(NSDate().timeIntervalSince1970 * 1000)"
        
        let ha1 = getMD5Hex(md5Data: MD5(string : (getMD5Hex(md5Data: MD5(string : (AppConstants.USER + ":" + AppConstants.REALM + ":" + AppConstants.PASSWORD))) + ":" + AppConstants.NONCE + ":" + cnonce)))
        
        let ha2 = getMD5Hex(md5Data: MD5(string: (method + ":" + uri)))
        
        let response = getMD5Hex(md5Data: MD5(string : (ha1 + ":" + AppConstants.NONCE + ":" + AppConstants.NONCE_COUNT + ":" + cnonce + ":" + AppConstants.QOP + ":" + ha2)))
        
        let digestHeader = "Digest username=\"\(AppConstants.USER)\", realm=\"\(AppConstants.REALM)\", nonce=\"\(AppConstants.NONCE)\", uri=\"\(uri)\", qop=\(AppConstants.QOP), nc=\(AppConstants.NONCE_COUNT), cnonce=\"\(cnonce)\", response=\"\(response)\", opaque="
        
        return digestHeader
    }
    
    private static func MD5(string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData
    }
    
    private static func getMD5Hex(md5Data : Data?) -> String
    {
        if md5Data == nil
        {
            return ""
        }
        
        return md5Data!.map { String(format: "%02hhx", $0) }.joined()
    }
}
