//
//  NutrientsDataCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 22/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NutrientsDataCell: UICollectionViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var nutrientNameLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.bottomView.backgroundColor = UIColor.appColor
    }
}
