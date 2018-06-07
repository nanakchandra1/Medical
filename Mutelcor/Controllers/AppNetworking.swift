//
//  AppNetworking.swift
//  TNIGHT
//
//  Created by  on 08/03/17.
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
    
    static var alamofireManager: SessionManager!
    
    static func configureAlamofire() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15 // seconds
        configuration.timeoutIntervalForResource = 15
        self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    static func POST(endPoint : String,
                     parameters : JSONDictionary = [:],
                     headers : JSONDictionary = [:],
                     encoding: URLEncoding = URLEncoding.methodDependent,
                     loader : Bool = false,
                     success : @escaping (JSON) -> Void,
                     failure : @escaping (Error) -> Void) {
        
        request1(URLString: endPoint, httpMethod: .post, parameters: parameters, headers: headers, encoding: encoding, loader: loader, success: success, failure: failure)
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
    
    static func PostWithMultipleData(endPoint : String,
                                     parameters : JSONDictionary = [:],
                                     headers : JSONDictionary = [:],
                                     loader : Bool = true,
                                     imageData: [String : Any] = [:],
                                     success : @escaping (JSON) -> Void,
                                     failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint, httpMethod: .post, parameters: parameters, data: imageData, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func PostWithOCRData(endPoint : String,
                                parameters : JSONDictionary = [:],
                                loader : Bool = true,
                                imageData: [String : Any] = [:],
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (Error) -> Void) {
        OCRRequest(withEndPoints: endPoint, method: .post, parameters: parameters, loader: loader, success: success, failure: failure)
    }
    
    private static func request1(URLString : String,
                                 httpMethod : HTTPMethod,
                                 parameters : JSONDictionary = [:],
                                 headers : JSONDictionary = [:],
                                 encoding: URLEncoding = URLEncoding.methodDependent,
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
        
        var header: [String: String] = [:]
        
        if headers.isEmpty {
            header = ["Content-Type": "application/x-www-form-urlencoded",
                      "Authorization": digestHeader,
                      "access_token": accessToken]
        }else{
            header = headers as! [String : String]
        }
        
        alamofireManager.request(URLString,
                                 method: httpMethod,
                                 parameters: parameters,
                                 encoding: encoding,
                                 headers: header).responseJSON { (response:DataResponse<Any>) in
                                    
                                    switch(response.result) {
                                        
                                    case .success(let value):
                                        print("Response: \(JSON(value))")
                                        let json = JSON(value)
                                        if (json[error_code].intValue == 104) || (json[error_code].intValue == 500) {
                                            AppUserDefaults.save(value: "", forKey: .accessToken)
                                            //                                    AppUserDefaults.removeAllValues()
                                            AppDelegate.shared.goToLoginOption()
                                        }
                                        if loader { hideLoader() }
                                        success(json)
                                        
                                    case .failure(let e):
                                        if loader { hideLoader() }
                                        if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                            NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                                        }else if (e as NSError).code == 4 {
                                            showToastMessage("Under Maintainence")
                                        }
                                        failure(e)
                                    }
        }
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
        
        var header: [String: String] = [:]
        if headers.isEmpty {
            header = ["Content-Type": "application/x-www-form-urlencoded",
                      "Authorization": digestHeader,
                      "access_token": accessToken]
        }else{
            header = headers as! [String : String]
        }
        
        if let unwrappedData = data/*, unwrappedData.count > 0*/ {
            
            alamofireManager.upload(multipartFormData: { (multipartFormData) in
                
                for (key, data) in unwrappedData {

                    if let image = data as? UIImage{
                        guard let imgData = UIImageJPEGRepresentation(image , 0.6) else { continue }
                        multipartFormData.append(imgData, withName: key, fileName: "\(Int(Date().timeIntervalSince1970)).jpg", mimeType: "image/jpeg")
                    }else if let imageData = data as? Data{
                        multipartFormData.append(imageData, withName: key, fileName: "\(key).jpg", mimeType: "image/jpeg")
                    }else{
                        let pdfURl = "\(data)"
                        
                        var fileData : Data?
                        if let _ = data as? URL {
                            do {
                                if let url = URL(string: pdfURl) {
                                    fileData = try Data.init(contentsOf: url)
                                }
                            } catch {
                                fileData = nil
                            }
                            let pdfName = pdfURl.components(separatedBy: "/").last
                            let encodedPdf = pdfName?.replacingOccurrences(of: "%20", with: " ")
                            if let data = fileData {
                                multipartFormData.append(data, withName: key, fileName: "\(encodedPdf ?? "")", mimeType: "application/pdf")
                            }
                        }
                    }
                }
                let param = parameters
                
                for (key, values) in param {

                    multipartFormData.append("\(values)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: URLString, method: .post, headers: header , encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload,_,_ ):
                    
                    upload.responseJSON(completionHandler: { (dataResponse) in
                        
                        if loader { hideLoader() }
                        
                        switch dataResponse.result{
                        case .success(let value):
                            
                            let json = JSON(value)
                            if json[error_code].intValue == 104 {
                                AppUserDefaults.save(value: "", forKey: .accessToken)
                                AppDelegate.shared.goToLoginOption()
                            }
                            success(json)
                        case .failure(let e):
                            if loader { hideLoader() }
                            
                            if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                // Handle Internet Not available UI
                                NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                            }else if (e as NSError).code == 4 {
                                showToastMessage("Under Maintainence")
                            }
                            failure(e)
                        }
                    })
                case .failure(let encodingError):
                    if loader { hideLoader() }
                    failure(encodingError)
                }
            })
        }
    }
    
    //    MARK:- OCR Request
    //    ====================
    static func OCRRequest(withEndPoints endPoints : String,
                           method : HTTPMethod = .post,
                           parameters : JSONDictionary = [:],
                           loader : Bool,
                           success : @escaping (JSON) -> Void,
                           failure : @escaping (Error) -> Void) {
        
        if loader { showLoader() }
        
        guard let url = URL.init(string: endPoints) else {
            let error = NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Url or parameters not valid"])
            failure(error)
            return
        }
        
        var request = URLRequest.init(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        let jsonObject = convertDictionaryIntoJSON(dic: parameters)//JSON(jsonDictionary: parameters)
        guard let data = try? jsonObject.rawData() else{
            return
        }
        
        request.httpBody = data
        let session = URLSession.shared
        
        session.configuration.timeoutIntervalForRequest = TimeInterval(15)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                if loader { hideLoader() }
                failure(error!)
                return
            }
            if loader { hideLoader() }
            success(JSON.init(data: data))
        }
        task.resume()
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
