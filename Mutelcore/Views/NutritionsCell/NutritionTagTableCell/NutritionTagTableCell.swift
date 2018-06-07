//
//  NutritionTagTableCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 21/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NutritionTagTableCell: UITableViewCell {

    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib(nibName: "NutritionTagCollectionCell", bundle: nil)
        tagsCollectionView.register(nib, forCellWithReuseIdentifier: "NutritionTagCollectionCell")
    }
    
}
