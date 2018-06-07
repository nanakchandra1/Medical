//
//  FamilyHistoryOfObesity.swift
//  Mutelcor
//
//  Created by on 04/01/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class FamilyHistoryOfObesity: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var yesButton: IndexedButton!
    @IBOutlet weak var noButton: IndexedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
        
        for (index,button) in [self.yesButton, self.noButton].enumerated(){
            button?.outerIndex = index
            button?.setImage(#imageLiteral(resourceName: "icAppointmentDeselectedradio"), for: .normal)
            button?.setImage(#imageLiteral(resourceName: "icAppointmentSelectedRadio"), for: .selected)
            button?.setTitleColor(UIColor.appColor, for: .selected)
            button?.setTitleColor(UIColor.grayLabelColor, for: .normal)
            button?.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        }
    }

    func populateData(userInfo: UserInfo?, indexPath: IndexPath){
        
        guard let userData = userInfo else{
            return
        }
        guard let activityData = userData.activityInfo.first else{
            return
        }

        switch indexPath.section {
        case 5:
            switch indexPath.row {
            case 1:
                self.selectedButton(buttonType: activityData.familiyHistoryObesity)
            case 3:
                self.selectedButton(buttonType: activityData.familyHistoryOfMedicalDiseases)
            case 5:
                self.selectedButton(buttonType: activityData.loveToEat)
            case 6:
                self.selectedButton(buttonType: activityData.excessiveApetite)
            case 10:
                self.selectedButton(buttonType: activityData.afinitySweets)
            case 11:
                self.selectedButton(buttonType: activityData.alcohol)
            case 13:
                self.selectedButton(buttonType: activityData.tobacco)
            case 15:
                self.selectedButton(buttonType: activityData.illegalDrug)
            case 18:
                self.selectedButton(buttonType: activityData.obese)
            case 19:
                self.selectedButton(buttonType: activityData.treatmentForObesity)
            default:
                return
            }
        default:
            return
        }
    }
    
    fileprivate func selectedButton(buttonType: Int){
        // Female rawVlue is 1 and other RawValue is 2 and buttonType value other than this when no button is selected
            if buttonType == Gender.female.rawValue {
                self.yesButton.isSelected = true
                self.noButton.isSelected = false
            }else if buttonType == Gender.others.rawValue{
                self.yesButton.isSelected = false
                self.noButton.isSelected = true
            }else{
                self.yesButton.isSelected = false
                self.noButton.isSelected = false
            }
    }
}
