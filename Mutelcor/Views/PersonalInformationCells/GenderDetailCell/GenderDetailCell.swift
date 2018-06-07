//
//  GenderDetailCell.swift
//  Mutelcor
//
//  Created by  on 20/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class GenderDetailCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var maleBtn: IndexedButton!
    @IBOutlet weak var femaleBtn: IndexedButton!
    @IBOutlet weak var othersBtn: IndexedButton!
    @IBOutlet weak var sepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
        
        for (index,button) in [self.maleBtn, self.femaleBtn, self.othersBtn].enumerated(){
            button?.setImage(#imageLiteral(resourceName: "icAppointmentDeselectedradio"), for: .normal)
            button?.setImage(#imageLiteral(resourceName: "icAppointmentSelectedRadio"), for: .selected)
            button?.setTitleColor(UIColor.appColor, for: .selected)
            button?.setTitleColor(UIColor.grayLabelColor, for: .normal)
            button?.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
            button?.outerIndex = index
        }        
    }
    
    func populateButtonSelectionStatus(_ userInfo: UserInfo?, indexPath: IndexPath){
        
        switch indexPath.section {
            
        case 0:
            self.maleBtn.setTitle(K_GENDER_MALE_PLACEHOLDER.localized, for: .normal)
            self.femaleBtn.setTitle(K_GENDER_FEMALE_PLACEHOLDER.localized, for: .normal)
            self.othersBtn.setTitle(K_OTHERS_TEXT.localized, for: .normal)
            guard let userData = userInfo else{
                return
            }
            
            self.selectedButton(buttonType: userData.patientGender, isGenderButtonTapped: true)
        case 1:
            self.maleBtn.setTitle(K_VEG_PLACEHOLDER.localized, for: .normal)
            self.femaleBtn.setTitle(K_NON_VEG_PLACEHOLDER.localized, for: .normal)
            self.othersBtn.setTitle(K_BOTH_PLACEHOLDER.localized, for: .normal)
            
            guard let userData = userInfo else{
                return
            }
            guard let medicalData = userData.medicalInfo.first else{
                return
            }
            self.selectedButton(buttonType: medicalData.foodCategory, isGenderButtonTapped: false)
        case 5:
            self.sepratorView.isHidden = true
            switch indexPath.row {
            case 0:
                
                self.maleBtn.setTitle(K_ACTIVE_PLACEHOLDER.localized, for: .normal)
                self.femaleBtn.setTitle(K_MODERATE_PLACEHOLDER.localized, for: .normal)
                self.othersBtn.setTitle(K_SEDENTARY_PLACEHOLDER.localized, for: .normal)
                
                guard let userData = userInfo else{
                    return
                }
                guard let activityData = userData.activityInfo.first else{
                    return
                }
                
                self.selectedButton(buttonType: activityData.activity, isGenderButtonTapped: false)
            case 8:
                self.maleBtn.setTitle(K_YES_PLACEHOLDER.localized, for: .normal)
                self.femaleBtn.setTitle(K_NO_PLACEHOLDER.localized, for: .normal)
                self.othersBtn.setTitle(K_DONTKNOW_PLACEHOLDER.localized, for: .normal)
                
                guard let userData = userInfo else{
                    return
                }
                guard let activityData = userData.activityInfo.first else{
                    return
                }
                self.selectedButton(buttonType: activityData.erracticTimming, isGenderButtonTapped: false)
            case 9:
                self.maleBtn.setTitle(K_LARGE_PLACEHOLDER.localized, for: .normal)
                self.femaleBtn.setTitle(K_MODERATE_PLACEHOLDER.localized, for: .normal)
                self.othersBtn.setTitle(K_SMALL_PLACEHOLDER.localized, for: .normal)
                
                guard let userData = userInfo else{
                    return
                }
                guard let activityData = userData.activityInfo.first else{
                    return
                }
                self.selectedButton(buttonType: activityData.eatingVolume, isGenderButtonTapped: false)
            default:
                return
            }
        default:
            return            
        }
    }
    
    fileprivate func selectedButton(buttonType: Int?, isGenderButtonTapped: Bool){
        
        switch isGenderButtonTapped {
        case true:
            if let type = buttonType {
                if type == Gender.male.rawValue {
                    self.maleBtn.isSelected = true
                    self.femaleBtn.isSelected = false
                    self.othersBtn.isSelected = false
                }else if type == Gender.female.rawValue{
                    self.maleBtn.isSelected = false
                    self.femaleBtn.isSelected = true
                    self.othersBtn.isSelected = false
                }else if type == Gender.others.rawValue{
                    self.maleBtn.isSelected = false
                    self.femaleBtn.isSelected = false
                    self.othersBtn.isSelected = true
                }else{
                    self.maleBtn.isSelected = false
                    self.femaleBtn.isSelected = false
                    self.othersBtn.isSelected = false
                }
            }else{
                self.maleBtn.isSelected = false
                self.femaleBtn.isSelected = false
                self.othersBtn.isSelected = false
            }
        default:
            if let type = buttonType {
                if type == FoodCategoryType.veg.rawValue {
                    self.maleBtn.isSelected = true
                    self.femaleBtn.isSelected = false
                    self.othersBtn.isSelected = false
                }else if type == FoodCategoryType.nonVeg.rawValue{
                    self.maleBtn.isSelected = false
                    self.femaleBtn.isSelected = true
                    self.othersBtn.isSelected = false
                }else if type == FoodCategoryType.both.rawValue{
                    self.maleBtn.isSelected = false
                    self.femaleBtn.isSelected = false
                    self.othersBtn.isSelected = true
                }else{
                    self.maleBtn.isSelected = false
                    self.femaleBtn.isSelected = false
                    self.othersBtn.isSelected = false
                }
            }else{
                self.maleBtn.isSelected = false
                self.femaleBtn.isSelected = false
                self.othersBtn.isSelected = false
            }
        }
    }
}


