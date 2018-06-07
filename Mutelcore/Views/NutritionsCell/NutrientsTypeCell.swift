//
//  NutrientsTypeCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 22/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
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
        // Initialization code
        
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
        
        if indexPath.item == selectedNutrientIndex{
            
            self.cellTitleLabel.textColor = UIColor.appColor
            self.bottomView.backgroundColor = UIColor.appColor
            self.bottomView.isHidden = false
            
            if indexPath.item == nutrientType.count {
                
                self.horizontalSepratorView.isHidden = true
            }else{
                
                self.horizontalSepratorView.isHidden = false
            }
            
        }else{
            
            self.cellTitleLabel.textColor = UIColor.grayLabelColor
            self.bottomView.isHidden = true
        }
    }
    
    func populateGraphNutrientData(_ indexPath : IndexPath, _ selectedGraphNutrientIndex : Int,_ nutrientType : [String]){
        
        if indexPath.item == selectedGraphNutrientIndex{
            
            self.cellTitleLabel.textColor = UIColor.appColor
            self.bottomView.backgroundColor = UIColor.appColor
            self.bottomView.isHidden = false
            
            if indexPath.item == nutrientType.count {
                
                self.horizontalSepratorView.isHidden = true
            }else{
                
                self.horizontalSepratorView.isHidden = false
            }
            
        }else{
            
            self.cellTitleLabel.textColor = UIColor.grayLabelColor
            self.bottomView.isHidden = true
        }
    }
}
