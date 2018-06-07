//
//  ConnectedDeviceVC+iHealthAPI.swift
//  Mutelcor
//
//  Created by on 02/01/18.
//  Copyright © 2018 "" All rights reserved.
//

import Foundation
import SwiftyJSON

extension ConnectedDeviceVC {
    
    func iHealthTapped() {
        
        let json = AppUserDefaults.value(forKey: .iHealthToken)
        let currentTimeStamp = Date().timeIntervalSince1970
        if let tokenData = iHealthToken(json: json) {
            if currentTimeStamp < tokenData.expiry {
                iHealthRefreshToken()
            } else {
                fetchiHealthData(tokenData: tokenData)
            }
            return
        }
        
        let apis = ["OpenApiActivity", "OpenApiBP", "OpenApiSpO2", "OpenApiWeight", "OpenApiBG", "OpenApiSleep", "OpenApiUserInfo"]
        let clientId = "c64aa9050d264a208937269f2412d792"
        let authUrl = WebServices.EndPoint.iHealthAuthUrl.url
        let iHealthAuthiOSCallbackUrl = WebServices.EndPoint.iHealthAuthiOSCallbackUrl.url
        
        let urlInfoDict = [
            "client_id": clientId,
            "response_type": "code",
            "redirect_uri": iHealthAuthiOSCallbackUrl,
            "APIName": apis.joined(separator: " ")
        ]
        
        if let comps = URLComponents(string: authUrl) {
            var components = comps
            components.queryItems = queryItems(dictionary: urlInfoDict)
            if let iHealthAuthUrl = components.url {
                self.openWebView(authUrl: iHealthAuthUrl, webViewVCFor: OpenWebViewVC.iHealth)
            }
        }
    }
    
    
    func iHealthRefreshToken() {
        
        let json = AppUserDefaults.value(forKey: .iHealthToken)
        guard let tokenData = iHealthToken(json: json) else {
            return
        }
        
        var parameters = [
            "response_type": "refresh_token",
            "refresh_token": tokenData.refreshToken,
            "UserID": tokenData.userId
        ]
        
        addiHealthMandatoryFields(&parameters)
        getiHealthToken(parameters: parameters)
    }
    
    func getiHealthToken(parameters: [String: String]) {
        WebServices.getiHealthAccessToken(parameters: parameters, success: { [weak self] tokenData in
            guard let strongSelf = self else{
                return
            }
            strongSelf.fetchiHealthData(tokenData: tokenData)
            }, failure: {error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    func fetchiHealthData(tokenData: iHealthToken) {
        
        let sc = "aa346ee38383487ba464cd0f7ec27e28"
        let sv = "4f55c5ef08d941dcafbf3ab27319aa7c"
        let userId = tokenData.userId
        
        var startTime: Int?
        let time = AppUserDefaults.value(forKey: .iHealthActivityLastFetchedTime)
        if time != JSON.null {
            startTime = time.intValue
        } else {
            let timeInterval = Date().timeIntervalSince1970
            AppUserDefaults.save(value: timeInterval, forKey: .iHealthActivityLastFetchedTime)
        }
        
        var parameters = [
            "access_token": tokenData.accessToken,
            "refresh_token": tokenData.refreshToken,
            "sc": sc,
            "sv": sv
        ]
        
        if let t = startTime {
            parameters["start_time"] = "\(t)"
        }
        
        addiHealthMandatoryFields(&parameters)

        WebServices.fetchARDataList(userId: userId,
                                    parameters: parameters,
                                    success: {[weak self](arDataList: [ARDataList]) in
                                        
                                        guard let strongSelf = self else{
                                            return
                                        }
                                        
                                        strongSelf.isiHealthAPIConnected()
                                        strongSelf.calculateiHealthData(iHealthData: arDataList)
            }, failure: {[weak self](error) in
                guard let strongSelf = self else{
                    return
                }
                strongSelf.isiHealthAPIConnected()
                showToastMessage("Data is not Synced yet.")
        })
    }
    
    
    fileprivate func isiHealthAPIConnected(){
        self.connectedDeviceSync = .iHealthApi
        AppUserDefaults.save(value: self.connectedDeviceSync.rawValue, forKey: .lastSyncDevice)
//        self.availiableApi.remove(at: 0)
        self.connectedApi.append([K_IHEALTH.localized, #imageLiteral(resourceName: "ihealth")])
        self.applicationTableView.reloadData()
    }
    
    // This adds iHealth CLIENT_ID CLIENT_SECRET and REDIRECT_URI to provided dict
    func addiHealthMandatoryFields(_ dict: inout [String: String]) {
        let clientId = "c64aa9050d264a208937269f2412d792"
        let clientSecret = "f1dd7b28390640979a1dde5b02f02b25"
        let iHealthAuthiOSCallbackUrl = WebServices.EndPoint.iHealthAuthiOSCallbackUrl.url
        
        dict["client_id"] = clientId
        dict["client_secret"] = clientSecret
        dict["redirect_uri"] = iHealthAuthiOSCallbackUrl
    }
    
    //    MARK:- Calculate iHealth Data
    //    ==============================
    func calculateiHealthData(iHealthData: [ARDataList]){
        self.connectedDeviceSync = .iHealthApi
       
        // Check to data which is synced last time
        let lastSyncData = self.lastSyncedData.filter({ (lastSyncData) -> Bool in
            return lastSyncData.deviceType.rawValue == self.connectedDeviceSync.rawValue
        })
        
        guard !iHealthData.isEmpty else{
            showToastMessage("No Synced Data.")
            return
        }
        let activityData = self.calculateActivityIDAndIndex()
        guard let index = activityData.0,
            let activityID = activityData.1 else{
                return
        }

        var activityType: [[String: Any]] = []

        for value in iHealthData {
            
            var calories: Double = 0.0
            if !lastSyncData.isEmpty && lastSyncData.first?.deviceType.rawValue == self.connectedDeviceSync.rawValue{
                
                if lastSyncData.first?.activityDateInterval == value.timeInterval &&
                    lastSyncData.first?.calories == value.calories {
                    break
                }else if lastSyncData.first?.activityDateInterval == value.timeInterval && lastSyncData.first?.calories != value.calories{
                    calories = Double(value.calories - lastSyncData[0].calories)
                }else if value.calories != 0, !value.measurementDate.isEmpty {
                    calories = Double(value.calories)
                }
            }
            
            if calories != 0.0 {
                let dic = self.calculatedConnectedDevicesData(caloriesUnit: Double(value.calories), date: value.measurementDate, activityID: activityID, index: index)
                activityType.append(dic)
            }
        }

        let jsonDic = typeJSONArray(activityType, dicKey: "activity_list")
        AppUserDefaults.save(value: self.connectedDeviceSync.rawValue, forKey: .lastSyncDevice)
        self.addMultipleActivity(parameters: jsonDic)
    }
}
