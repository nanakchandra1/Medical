//
//  CmsAttachmentCell.swift
//  Mutelcor
//
//  Created by on 10/08/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class CmsAttachmentCell: UITableViewCell {
    
//    MARK:- IBOutelts
//    ================
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ImagesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.textColor = UIColor.appColor
        self.titleLabel.font = AppFonts.sansProRegular.withSize(15)
        self.titleLabel.text = "Attachment"
        let imagesCellNib = UINib(nibName: "CmsImagesCell", bundle: nil)
        self.ImagesCollectionView.register(imagesCellNib, forCellWithReuseIdentifier: "cmsImagesCellID")
    }
}
