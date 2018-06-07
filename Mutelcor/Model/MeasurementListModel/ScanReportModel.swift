//
//  ScanReportModel.swift
//  Mutelcor
//
//  Created by on 08/12/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

// report arrange by whole description with coordinate and scannedtextReport array is for detail text with coorinate
class ScanReportModel {
    
    var completeText: String?
    var locale: String?
    var x1CompleteTextCoordinate: Int?
    var y1CompleteTextCoordinate: Int?
    var x2CompleteTextCoordinate: Int?
    var y2CompleteTextCoordinate: Int?
    var x3CompleteTextCoordinate: Int?
    var y3CompleteTextCoordinate: Int?
    var x4CompleteTextCoordinate: Int?
    var y4CompleteTextCoordinate: Int?
    var scannedTextReport: [TextReportModel] = []
    
    required init (annotationText: JSON){
        let annotation = annotationText.arrayValue
        
        for (index,annotationValue) in annotation.enumerated() {
            
            if index == 0 {
                let textAnnotations = annotationValue.dictionaryValue
                self.completeText = textAnnotations[DictionaryKeys.cmsDescription]?.stringValue
                self.locale = textAnnotations[DictionaryKeys.locale]?.stringValue
                if let boundingPoly = textAnnotations[DictionaryKeys.boundingPoly]?.dictionary{
                    if let vertices = boundingPoly[DictionaryKeys.vertices]?.array {
                        for (index, value) in vertices.enumerated() {
                            switch index{
                            case 0:
                                self.x1CompleteTextCoordinate = value[DictionaryKeys.xVertices].intValue
                                self.y1CompleteTextCoordinate = value[DictionaryKeys.yVertices].intValue
                            case 1:
                                self.x2CompleteTextCoordinate = value[DictionaryKeys.xVertices].intValue
                                self.y2CompleteTextCoordinate = value[DictionaryKeys.yVertices].intValue
                            case 2:
                                self.x3CompleteTextCoordinate = value[DictionaryKeys.xVertices].intValue
                                self.y3CompleteTextCoordinate = value[DictionaryKeys.yVertices].intValue
                            default:
                                self.x4CompleteTextCoordinate = value[DictionaryKeys.xVertices].intValue
                                self.y4CompleteTextCoordinate = value[DictionaryKeys.yVertices].intValue
                            }
                        }
                    }
                }
            }else{
                self.singleText(data: annotationValue)
            }
        }
    }
    
    init(){
    }
    
    class func getDataFromArray(data: [JSON]) ->[ScanReportModel]{

        var scanReport:[ScanReportModel] = []
        if let textAnnotation = data.first?.dictionary, let annotation = textAnnotation[DictionaryKeys.textAnnotations] {
            scanReport.append(ScanReportModel.init(annotationText: annotation))
        }
        return scanReport
    }
    
    @discardableResult func singleText(data: JSON) -> [TextReportModel]{
        let textReport = TextReportModel.init(json: data)
        self.scannedTextReport.append(textReport)
        return self.scannedTextReport
    }
}

// text in scan report arrange by single text with coordinate
class TextReportModel {
    var text: String = ""
    var vitalSuperID: Int?
    var vitalID: Int?
    var vitalName: String = ""
    var value: Double = 0.0
    var unit: String = ""
    var vitalSubName: String = ""
    
    var x1Coordinate: Int = 0
    var y1Coordinate: Int = 0
    var x2Coordinate: Int = 0
    var y2Coordinate: Int = 0
    var x3Coordinate: Int = 0
    var y3Coordinate: Int = 0
    var x4Coordinate: Int = 0
    var y4Coordinate: Int = 0
    
    init(){
        
    }
    
    required init (json: JSON){
        self.text = json[DictionaryKeys.cmsDescription].stringValue
        if let boundingPoly = json[DictionaryKeys.boundingPoly].dictionary {
            if let vertices = boundingPoly[DictionaryKeys.vertices]?.array {
                for (index, value) in vertices.enumerated() {
                    switch index{
                    case 0:
                        self.x1Coordinate = value[DictionaryKeys.xVertices].intValue
                        self.y1Coordinate = value[DictionaryKeys.yVertices].intValue
                    case 1:
                        self.x2Coordinate = value[DictionaryKeys.xVertices].intValue
                        self.y2Coordinate = value[DictionaryKeys.yVertices].intValue
                    case 2:
                        self.x3Coordinate = value[DictionaryKeys.xVertices].intValue
                        self.y3Coordinate = value[DictionaryKeys.yVertices].intValue
                    default:
                        self.x4Coordinate = value[DictionaryKeys.xVertices].intValue
                        self.y4Coordinate = value[DictionaryKeys.yVertices].intValue
                    }
                }
            }
        }
    }
}

