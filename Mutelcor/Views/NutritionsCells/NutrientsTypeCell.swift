//
//  NutrientsTypeCell.swift
//  Mutelcor
//
//  Created by on 22/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class NutrientsTypeCell: UICollectionViewCell {

//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var horizontalSepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       self.setupUI()
    }
}


extension NutrientsTypeCell {
    
    fileprivate func setupUI(){
        
        self.cellTitleLabel.textColor = UIColor.grayLabelColor
        self.bottomView.backgroundColor = UIColor.appColor
        self.horizontalSepratorView.backgroundColor = UIColor.sepratorColor
        
        if DeviceType.IS_IPHONE_5 {
            self.cellTitleLabel.font = AppFonts.sanProSemiBold.withSize(9)
        }else{
            self.cellTitleLabel.font = AppFonts.sanProSemiBold.withSize(11)
        }
    }
    
    func populateData(_ indexPath : IndexPath, _ selectedNutrientIndex : Int,_ nutrientType : [String]){
        
        let isSepratorViewHidden = (indexPath.item == (nutrientType.count - 1)) ? true : false
        self.horizontalSepratorView.isHidden = isSepratorViewHidden
        
        if indexPath.item == selectedNutrientIndex{
            self.cellTitleLabel.textColor = UIColor.appColor
            self.bottomView.backgroundColor = UIColor.appColor
            self.bottomView.isHidden = false
        }else{
            self.cellTitleLabel.textColor = UIColor.grayLabelColor
            self.bottomView.isHidden = true
        }
    }
    
    func populateGraphNutrientData(_ indexPath : IndexPath, _ selectedGraphNutrientIndex : Int,_ nutrientType : [String]){
        
        let isHorizontalSepratorHidden = indexPath.item == (nutrientType.count - 1) ? true : false
        self.horizontalSepratorView.isHidden = isHorizontalSepratorHidden
        
        if indexPath.item == selectedGraphNutrientIndex{
            self.cellTitleLabel.textColor = UIColor.appColor
            self.bottomView.backgroundColor = UIColor.appColor
            self.bottomView.isHidden = false
        }else{
            self.bottomView.backgroundColor = UIColor.clear
            self.cellTitleLabel.textColor = UIColor.grayLabelColor
            self.bottomView.isHidden = true
        }
    }
    
    func populateGraphMeasurementData(_ indexPath : IndexPath, _ selectedIndex : Int,_ topMostVital : [LatestThreeVitalData]){
        
        if indexPath.item == selectedIndex{
            
            self.cellTitleLabel.textColor = UIColor.appColor
            self.bottomView.backgroundColor = UIColor.appColor
            self.bottomView.isHidden = false
            
            let isHorizontalSepratorHidden = indexPath.item == topMostVital.count - 1 ? true : false
            self.horizontalSepratorView.isHidden = isHorizontalSepratorHidden
        }else{
            self.cellTitleLabel.textColor = UIColor.grayLabelColor
            self.bottomView.isHidden = true
        }
    }
}
