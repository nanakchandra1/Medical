//
//  CmsData.swift
//  Mutelcor
//
//  Created by on 16/08/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class CmsData {
    var cmsId : Int?
    var cmsName : String?
    var cmsDescription : String?
    var cmsLinks: String?
    var image : [JSON] = []
    var cmsImages : [CmsImages] = []
    var cmsVideos : [CmsImages] = []
    var status : Int?
    
    required init(_ cmsData : JSON){
        
        guard let cmsId = cmsData[DictionaryKeys.cmsId].int else{
            return
        }
        self.cmsId = cmsId
        self.cmsName = cmsData[DictionaryKeys.title].stringValue
        self.cmsDescription = cmsData[DictionaryKeys.cmsDescription].stringValue
        self.cmsLinks = cmsData[DictionaryKeys.cmsLink].stringValue
        
        if let status = cmsData[DictionaryKeys.cmsStatus].int {
            self.status = status
        }
     addCmsImages(cmsData)
     addCmsVideos(cmsData)
    }
    
    init(){
        
    }
    
   @discardableResult func addCmsImages(_ images : JSON) -> [CmsImages]{
        
        let images = images[DictionaryKeys.cmsImage].arrayValue
        for values in images {
            let images = CmsImages.init(values)
            cmsImages.append(images)
        }
      return cmsImages
    }
    
   @discardableResult func addCmsVideos(_ videos : JSON) -> [CmsImages]{
        
        let video = videos[DictionaryKeys.cmsVideo].arrayValue
        for values in video {
            let videos = CmsImages.init(values)
            cmsVideos.append(videos)
        }
       return cmsVideos
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [CmsData] {
        var model = [CmsData]()
        for value in array{
            model.append(CmsData(value))
        }
        return model
    }
}

class CmsImages {
    
    var fileName: String?
    var fileUrl: String?
    var fileThumbnail: String?
    
    required init(_ cmsImages : JSON){
        self.fileName = cmsImages[DictionaryKeys.cmsFileName].stringValue
        self.fileUrl = cmsImages[DictionaryKeys.cmsUrl].stringValue
        self.fileThumbnail = cmsImages[DictionaryKeys.videoThumbnail].stringValue
    }
}


