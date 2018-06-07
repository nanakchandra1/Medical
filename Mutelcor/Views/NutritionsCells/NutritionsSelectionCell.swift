//
//  nutritionsSelectionCell.swift
//  Mutelcor
//
//  Created by on 22/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class NutritionsSelectionCell: UITableViewCell {

    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var nutrientsSelectionCollectionView: IndexedCollectionView!
    @IBOutlet weak var graphBtnOutlt: UIButton!
    @IBOutlet weak var tableBtnOutlt: UIButton!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var viewContainObjectLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewContainObjectTrailingConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.setupUI()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension NutritionsSelectionCell {
    
    fileprivate func setupUI(){
     
        self.graphBtnOutlt.setImage(#imageLiteral(resourceName: "icMeasurementSelectedgraph"), for: UIControlState.normal)
        self.tableBtnOutlt.setImage(#imageLiteral(resourceName: "icMeasurementDeselectedtable"), for: UIControlState.normal)
        
        self.sepratorView.backgroundColor = UIColor.sepratorColor
        self.contentView.backgroundColor = UIColor.sepratorColor

        self.registerNibs()
        
    }
    
    fileprivate func registerNibs(){
        
        let nutrientsTypeNib = UINib(nibName: "NutrientsTypeCell", bundle: nil)
        self.nutrientsSelectionCollectionView.register(nutrientsTypeNib, forCellWithReuseIdentifier: "nutrientsTypeCellID")
    }
}
