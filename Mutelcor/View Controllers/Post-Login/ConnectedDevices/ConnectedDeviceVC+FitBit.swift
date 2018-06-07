//
//  ConnectedDeviceVC+FitBit.swift
//  Mutelcor
//
//  Created by on 01/01/18.
//  Copyright © 2018 "" All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK:- FitBit API Data
//=======================
extension ConnectedDeviceVC {
    
    // This adds FitBit CLIENT_ID CLIENT_SECRET and REDIRECT_URI to provided dict
    func addFitbitMandatoryFields(_ dict: inout [String: String]){
        
        let clientId = "22CH5Y"
        let clientSecret = "317e2dc1c5ed6376df4acde0e9f28c96"
        let iHealthAuthiOSCallbackUrl = WebServices.EndPoint.fitbitCallBackUrl.url
        
        dict["client_id"] = clientId
        dict["grant_type"] = "authorization_code"
        dict["client_secret"] = clientSecret
        dict["redirect_uri"] = iHealthAuthiOSCallbackUrl
    }
    
    //Fitbit tapped to sync data
    func fibitTapped(){
        
        let json = AppUserDefaults.value(forKey: .fitBitToken)
        let currentTimeStamp = Date().timeIntervalSince1970
        if let tokenData = FitbitToken(json: json) {
            if currentTimeStamp < tokenData.expiry {
                self.fitBitRefreshToken()
            } else {
                self.fetchFitBitData(tokenData: tokenData)
            }
            return
        }
        
        let clientId = "22CH5Y"
        let authUrl = WebServices.EndPoint.fitbitAuthUrl.url
        let fitbitCallbackUrl = WebServices.EndPoint.fitbitCallBackUrl.url
        
        let apis = ["activity", "nutrition", "weight", "heartrate", "location", "profile", "settings", "sleep", "social"]
        
        let urlInfoDict = [
            "client_id": clientId,
            "response_type": "code",
            "scope": apis.joined(separator: " "),
            "redirect_uri": fitbitCallbackUrl,
            ]
        
        if let comps = URLComponents(string: authUrl) {
            var components = comps
            components.queryItems = queryItems(dictionary: urlInfoDict)
            if let fitbitAuthUrl = components.url {
                self.openWebView(authUrl: fitbitAuthUrl, webViewVCFor: OpenWebViewVC.fitbit)
            }
        }
    }
    
    //get fitbit token
    func getfitbitToken(parameters: [String: String]) {
        WebServices.getFitBitAccessToken(parameters: parameters, success: { [weak self](tokenData) in
            
            guard let strongSelf = self else{
                return
            }
            strongSelf.fetchFitBitData(tokenData: tokenData)
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    //    MARK:- Refresh FitBit Token
    //    ===========================
    func fitBitRefreshToken() {
        
        let json = AppUserDefaults.value(forKey: .fitBitToken)
        guard let tokenData = FitbitToken(json: json) else {
            return
        }
        
        var parameters = [
            "grant_type": "refresh_token",
            "refresh_token": tokenData.refreshToken
        ]
        
        self.addFitbitMandatoryFields(&parameters)
        self.getfitbitToken(parameters: parameters)
    }
    
    //    MARK:- Get FitBit Data
    //    ======================
    func fetchFitBitData(tokenData: FitbitToken) {
        
        let userId = tokenData.userId
        let token = tokenData.accessToken
        
        WebServices.getFitBitCalories(userId: userId,
                                      token: token,
                                      success: {[weak self](data: [FitBitDataModel]) in
                                        guard let strongSelf = self else{
                                            return
                                        }
                                        strongSelf.connectedDeviceSync = .fitbitAPi
                                        strongSelf.connectedApi.append([K_FITBIT.localized, #imageLiteral(resourceName: "ic_fitbit_")])
                                        strongSelf.applicationTableView.reloadData()
                                        strongSelf.calculateFitBitData(fitBitData: data)
        }){(error: Error) in
            showToastMessage(error.localizedDescription)
            showToastMessage("Data is not Synced yet.")
        }
    }
    
    
//    MARK:- Calculate Fitbit Data
//    ============================
    func calculateFitBitData(fitBitData: [FitBitDataModel]){
        
        guard !fitBitData.isEmpty else{
            showToastMessage("No Synced Data.")
            return
        }
        
        // Check to data which is synced last time
        let lastSyncData = self.lastSyncedData.filter({ (lastSyncData) -> Bool in
            return lastSyncData.deviceType.rawValue == self.connectedDeviceSync.rawValue
        })
        
        let activityData = self.calculateActivityIDAndIndex()
        guard let index = activityData.0,
            let activityID = activityData.1 else{
                return
        }
        
        var activityType: [[String: Any]] = []

        for value in fitBitData {
            
            var calories: Double = 0.0
            if !lastSyncData.isEmpty && lastSyncData.first?.deviceType.rawValue == self.connectedDeviceSync.rawValue{
                
                if lastSyncData.first?.activityDateInterval == value.timeInterval &&
                    lastSyncData.first?.calories == value.calories {
                    break
                }else if lastSyncData.first?.activityDateInterval == value.timeInterval && lastSyncData.first?.calories != value.calories{
                    calories = Double(value.calories - lastSyncData[0].calories)
                }else if value.calories != 0, !value.date.isEmpty {
                    calories = Double(value.calories)
                }
            }
            
            if calories != 0.0 {
                let dic = self.calculatedConnectedDevicesData(caloriesUnit: Double(value.calories), date: value.date, activityID: activityID, index: index)
                activityType.append(dic)
            }
        }
        
        let jsonDic = typeJSONArray(activityType, dicKey: "activity_list")
        AppUserDefaults.save(value: self.connectedDeviceSync.rawValue, forKey: .lastSyncDevice)
        self.addMultipleActivity(parameters: jsonDic)
    }
}
