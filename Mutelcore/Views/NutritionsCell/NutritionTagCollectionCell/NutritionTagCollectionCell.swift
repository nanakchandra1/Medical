//
//  NutritionTagCollectionCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 21/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NutritionTagCollectionCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagLabel.layer.cornerRadius = 3
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagLabel.text = nil
    }

}
