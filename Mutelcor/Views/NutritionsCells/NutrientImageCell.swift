//
//  NutrientImageCellTableViewCell.swift
//  Mutelcor
//
//  Created by on 05/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class NutrientImageCell: UITableViewCell {
    
    
    //    MARK:- IBOutlets
    //    ================
    
    @IBOutlet weak var leftArrowBtn: UIButton!
    @IBOutlet weak var rightArrowBtn: UIButton!
    @IBOutlet weak var imageCollectionView: IndexedCollectionView!
    @IBOutlet weak var viewContainObjects: UIView!
    @IBOutlet weak var nutrientCollectionView: IndexedCollectionView!
    @IBOutlet weak var outerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.setupUI()
    }
}

extension NutrientImageCell {
    
    fileprivate func setupUI(){
        
        self.leftArrowBtn.setImage(#imageLiteral(resourceName: "icActivityplanLeftarrow"), for: .normal)
        self.rightArrowBtn.setImage(#imageLiteral(resourceName: "icActivityplanRightarrow"), for: .normal)
        self.contentView.backgroundColor = UIColor.sepratorColor
        self.viewContainObjects.layer.cornerRadius = 2.2
        self.viewContainObjects.layer.masksToBounds = true
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.outerView.layer.cornerRadius = 2.2
        self.outerView.clipsToBounds = false
        self.outerView.layer.masksToBounds = false
        
        self.registerNibs()
        
    }
    
    fileprivate func registerNibs(){
        
        let imageCollectionViewNib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        let nutritionTypeCellNib = UINib(nibName: "NutrientsTypeCell", bundle: nil)
        self.nutrientCollectionView.register(nutritionTypeCellNib, forCellWithReuseIdentifier: "nutrientsTypeCellID")
        
        self.imageCollectionView.register(imageCollectionViewNib, forCellWithReuseIdentifier: "imageCollectionViewCellID")
        
        self.imageCollectionView.register(UINib(nibName: "PieChartCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PieChartCollectionCell")
        
    }
    
    func hideLeftButton(){
        
        self.leftArrowBtn.isHidden = true
        self.rightArrowBtn.isHidden = false
    }
    
    func hideRightButton(){
        
        self.leftArrowBtn.isHidden = false
        self.rightArrowBtn.isHidden = true
    }
    
    func dontHideButton(){
        
        self.leftArrowBtn.isHidden = false
        self.rightArrowBtn.isHidden = false
    }
}
