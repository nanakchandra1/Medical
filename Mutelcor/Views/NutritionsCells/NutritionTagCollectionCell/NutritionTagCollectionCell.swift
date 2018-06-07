//
//  NutritionTagCollectionCell.swift
//  Mutelcor
//
//  Created by on 21/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class NutritionTagCollectionCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagLabel.layer.cornerRadius = 3
        tagLabel.font = AppFonts.sanProSemiBold.withSize(10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagLabel.text = nil
    }

}
