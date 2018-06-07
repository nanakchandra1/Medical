//
//  addAllergyCell.swift
//  Mutelcor
//
//  Created by on 06/09/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class AddAllergyCell: UICollectionViewCell {
    
//    MARK:- IBoutlets
//    ================
    @IBOutlet weak var allergyTitle: UILabel!
    @IBOutlet weak var deleteAllergyBtn: UIButton!
    @IBOutlet weak var outerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.outerView.backgroundColor = UIColor.appColor
        self.allergyTitle.textColor = .white
        self.deleteAllergyBtn.setImage(#imageLiteral(resourceName: "icCross"), for: .normal)
        self.allergyTitle.font = AppFonts.sanProSemiBold.withSize(16)

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.outerView.layer.cornerRadius = self.outerView.frame.height / 2
        self.outerView.clipsToBounds = true
    }
}
