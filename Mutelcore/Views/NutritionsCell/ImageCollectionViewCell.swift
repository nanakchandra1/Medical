//
//  ImageCollectionViewCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 22/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var nutrientsQuantity: UILabel!
    @IBOutlet weak var nutrientsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.nutrientsImage.image = #imageLiteral(resourceName: "icAddmenuFillGlass")
    }
    
    func populateData(_ graphView : [GraphView]){
        
        var totalWater = 0.0
        
        for (count,_) in graphView.enumerated() {
            
        totalWater = totalWater + graphView[count].waterTaken!
            
        }
        
        let water = "\(totalWater.rounded(.toNearestOrAwayFromZero))"
        
        let waterQuantity = NSMutableAttributedString(string: water, attributes: [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(25)])
        let waterUnit = NSAttributedString(string: "ltr", attributes: [NSFontAttributeName : AppFonts.sansProRegular.withSize(20)])
        
        waterQuantity.append(waterUnit)
        
        self.nutrientsQuantity.attributedText = waterQuantity
    }
    
}
