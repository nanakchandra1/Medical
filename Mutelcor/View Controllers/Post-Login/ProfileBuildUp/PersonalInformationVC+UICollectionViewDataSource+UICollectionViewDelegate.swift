//
//  PersonalInformationVC+UICollectionViewDataSource+UICollectionViewDelegate.swift
//  Mutelcor
//
//  Created by  on 05/01/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation

//MARK:- UICollectionViewDataSource Methods
//=========================================
extension PersonalInformationVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else{
            return 0
        }
        
        switch outerIndexPath.section {
        case 2:
            return self.addEnvironmentalAllergy.count
        case 3:
            return self.addFoodAllergy.count
        case 4:
            return self.addDrugAllergy.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else{
            fatalError("IndexedCollectionView not Foound!")
        }
        
        guard let addAlleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addAllergyCellID", for: indexPath) as? AddAllergyCell else{
            fatalError("AddAllergyCell Not Found!")
        }
        
        addAlleryCell.outerView.layer.cornerRadius = addAlleryCell.outerView.frame.height / 2
        addAlleryCell.outerView.clipsToBounds = true
        addAlleryCell.deleteAllergyBtn.addTarget(self, action: #selector(self.deleteAllergyBtnTapped(_:)), for: .touchUpInside)
        
        switch outerIndexPath.section {
        case 2:
            addAlleryCell.allergyTitle.text = self.addEnvironmentalAllergy[indexPath.item]
        case 3:
            addAlleryCell.allergyTitle.text = self.addFoodAllergy[indexPath.item]
        case 4:
            addAlleryCell.allergyTitle.text = self.addDrugAllergy[indexPath.item]
        default:
            fatalError("CollectionView item not found!")
        }
        
        return addAlleryCell
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//=================================================
extension PersonalInformationVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else{
            return CGSize.zero
        }
        
        switch outerIndexPath.section {
        case 2:
            let text = self.addEnvironmentalAllergy[indexPath.item]
            let width = text.widthWithConstrainedHeight(height: indexedCollectionView.frame.height, font: AppFonts.sanProSemiBold.withSize(16)) + 90
            let calculatedWidth = width <= (UIDevice.getScreenWidth - 30) ? width : UIDevice.getScreenWidth - 30
            let height = text.heightWithConstrainedWidth(width: indexedCollectionView.frame.width, font: AppFonts.sanProSemiBold.withSize(16)) + 25
            return CGSize(width: calculatedWidth, height: height)
        case 3:
            let text = self.addFoodAllergy[indexPath.item]
            let width = text.widthWithConstrainedHeight(height: indexedCollectionView.frame.height, font: AppFonts.sanProSemiBold.withSize(16)) + 90
            let calculatedWidth = width <= (UIDevice.getScreenWidth - 30) ? width : UIDevice.getScreenWidth - 30
            let height = text.heightWithConstrainedWidth(width: indexedCollectionView.frame.width, font: AppFonts.sanProSemiBold.withSize(16)) + 25
            return CGSize(width: calculatedWidth, height: height)
        case 4:
            let text = self.addDrugAllergy[indexPath.item]
            let width = text.widthWithConstrainedHeight(height: indexedCollectionView.frame.height, font: AppFonts.sanProSemiBold.withSize(16)) + 90
            let calculatedWidth = width <= (UIDevice.getScreenWidth - 30) ? width : UIDevice.getScreenWidth - 30
            let height = text.heightWithConstrainedWidth(width: indexedCollectionView.frame.width, font: AppFonts.sanProSemiBold.withSize(16)) + 25
            return CGSize(width: calculatedWidth, height: height)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(2, 2, 2, 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 2
    }
}
