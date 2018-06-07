//
//  NutrientsDataCell.swift
//  Mutelcor
//
//  Created by on 22/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class NutrientsDataCell: UICollectionViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var nutrientNameLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.bottomView.backgroundColor = UIColor.appColor
    }
}
