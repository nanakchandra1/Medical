//
//  ImageCollectionViewCell.swift
//  Mutelcor
//
//  Created by on 22/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var nutrientsQuantity: UILabel!
    @IBOutlet weak var nutrientsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.nutrientsImage.image = #imageLiteral(resourceName: "icAddmenuFillGlass")
    }
    
    func populateData(_ graphView : [GraphView]){
        
        var totalWater = 0.0
        for (count,_) in graphView.enumerated() {
            let waterTaken = graphView[count].waterTaken ?? 0
        totalWater = totalWater + waterTaken
        }
        
        let water = "\(totalWater.rounded().cleanValue)"
        let waterQuantity = NSMutableAttributedString(string: water, attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(25)])
        let waterUnit = NSAttributedString(string: "ltr", attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(20)])
        waterQuantity.append(waterUnit)
        self.nutrientsQuantity.attributedText = waterQuantity
    }
}
