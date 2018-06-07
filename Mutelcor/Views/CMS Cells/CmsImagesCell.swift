//
//  CmsImagesCell.swift
//  Mutelcor
//
//  Created by on 10/08/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON

class CmsImagesCell: UICollectionViewCell {
    
//    MARK:- IBOutlets
//    =====================
    @IBOutlet weak var cmsImages: UIImageView!
    @IBOutlet weak var thumbnailPlayIconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cmsImages.roundCorner(radius: 2.2, borderColor: UIColor.gray, borderWidth: 1.0)
    }
    
    func populateData(_ uploadData : [CmsImages], _ indexPath: IndexPath, _ cmsVideos: [CmsImages]){
        
        guard !uploadData.isEmpty else{
            self.thumbnailPlayIconImage.isHidden = true
            self.cmsImages.isHidden = true
            return
        }
        
        self.thumbnailPlayIconImage.isHidden = false
        self.cmsImages.isHidden = false
        
        let thumbnailImages = uploadData[indexPath.item].fileThumbnail
        if let images = thumbnailImages,!images.isEmpty {
            let replacingURl = images.replacingOccurrences(of: " ", with: "%20")
            let imageUrl = URL(string: replacingURl)
            if let url = imageUrl {
                self.cmsImages.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "personal_info_place_holder"))
            }
        }
        let isPlayIconDisplay = (uploadData.count <= cmsVideos.count) ? false : true
        self.thumbnailPlayIconImage.isHidden = isPlayIconDisplay
    }
}
