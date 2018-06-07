////
////  HypertensionCell.swift
////  Mutelcor
////
////  Created by  on 24/03/17.
////  Copyright © 2017. All rights reserved.
////
//
//import UIKit
//
//class HypertensionCell: UITableViewCell {
//    
////    MARK:- IBOutlets
////    ================
//    @IBOutlet weak var cellTitle: UILabel!
//    @IBOutlet weak var toogleBtn: UIButton!
//   
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
//        
//        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
//        self.cellTitle.textColor = UIColor.appColor
//        
//    }
//}
//
//extension HypertensionCell {
//    
//    func populateHypertensionData(_ userInfo: UserInfo?, _ indexPath: IndexPath){
//        
//        switch indexPath.row {
//            
//        case 0:
//            
//            guard let userData = userInfo else{
//                return
//            }
//            guard !userData.medicalInfo.isEmpty else{
//                return
//            }
////            let hypertensionValue = userData.medicalInfo.first?.hypertension ?? 0
//            let btnImage = (hypertensionValue == false.rawValue) ? #imageLiteral(resourceName: "personal_info_switch_off") : #imageLiteral(resourceName: "personal_info_switch_on_shift")
//            self.toogleBtn.setImage(btnImage, for: .normal)
//            
//        case 1:
//            
//            guard let userData = userInfo else{
//                return
//            }
//            
//            guard !userData.medicalInfo.isEmpty else{
//                return
//            }
//            let fatherHyperTensionValue = userData.medicalInfo.first?.patientHyperTensionFather ?? 0
//            let btnImage = (fatherHyperTensionValue == false.rawValue) ? #imageLiteral(resourceName: "personal_info_switch_off") : #imageLiteral(resourceName: "personal_info_switch_on_shift")
//            self.toogleBtn.setImage(btnImage, for: .normal)
//            
//        case 2:
//            
//            guard let userData = userInfo else{
//                return
//            }
//            
//            guard !userData.medicalInfo.isEmpty else{
//                return
//            }
//            let motherHyperTensionValue = userData.medicalInfo.first?.patientHyperTensionMother ?? 0
//            let btnImage = (motherHyperTensionValue == false.rawValue) ? #imageLiteral(resourceName: "personal_info_switch_off") : #imageLiteral(resourceName: "personal_info_switch_on_shift")
//            self.toogleBtn.setImage(btnImage, for: .normal)
//            
//        default :
//            return
//        }
//    }
//    
//    func populateDiabitiesData(_ userInfo: UserInfo?, _ indexPath: IndexPath){
//        
//        switch indexPath.row {
//            
//        case 0:
//            
//            guard let userData = userInfo else{
//                return
//            }
//            guard !userData.medicalInfo.isEmpty else{
//                return
//            }
//            let diabities = userData.medicalInfo.first?.diabities ?? 0
//            
//            let btnImage = (diabities == false.rawValue) ? #imageLiteral(resourceName: "personal_info_switch_off") : #imageLiteral(resourceName: "personal_info_switch_on_shift")
//            self.toogleBtn.setImage(btnImage, for: .normal)
//            
//        case 1:
//            
//            guard let userData = userInfo else{
//                return
//            }
//            
//            guard !userData.medicalInfo.isEmpty else{
//                return
//            }
//            let fatherDiabitiesValue = userData.medicalInfo.first?.patientDiabitiesFather ?? 0
//            
//            let btnImage = (fatherDiabitiesValue == false.rawValue) ? #imageLiteral(resourceName: "personal_info_switch_off") : #imageLiteral(resourceName: "personal_info_switch_on_shift")
//            self.toogleBtn.setImage(btnImage, for: .normal)
//            
//        case 2:
//            
//            guard let userData = userInfo else{
//                return
//            }
//            
//            guard !userData.medicalInfo.isEmpty else{
//                return
//            }
//            let motherDiabitiesValue = userData.medicalInfo.first?.patientDiabitiesMother ?? 0
//            let btnImage = (motherDiabitiesValue == false.rawValue) ? #imageLiteral(resourceName: "personal_info_switch_off") : #imageLiteral(resourceName: "personal_info_switch_on_shift")
//            self.toogleBtn.setImage(btnImage, for: .normal)
//            
//        default :
//            return
//        }
//    }
//    
//    func populateSmokingData(_ userInfo: UserInfo?, _ indexPath: IndexPath){
//        
//        guard let userData = userInfo else{
//            return
//        }
//        guard !userData.medicalInfo.isEmpty else{
//            return
//        }
//        let smoking = userData.medicalInfo.first?.smoking ?? 0
//        let btnImage = (smoking == false.rawValue) ? #imageLiteral(resourceName: "personal_info_switch_off") : #imageLiteral(resourceName: "personal_info_switch_on_shift")
//        self.toogleBtn.setImage(btnImage, for: .normal)
//    }
//    
//    func populateFoodCategory(_ userInfo: UserInfo?, _ indexPath: IndexPath) -> Bool{
//        
//        guard let userData = userInfo else{
//            return true
//        }
//        guard !userData.medicalCategoryInfo.isEmpty else{
//            return true
//        }
//        let foodCategory = userData.medicalCategoryInfo.first?.foodCategory ?? 0
//        
//        let fooCategoryToogleState = (foodCategory == false.rawValue) ? false : true
//        if !fooCategoryToogleState {
//            let btnImage = (indexPath.row == 0) ? #imageLiteral(resourceName: "personal_info_switch_off") : #imageLiteral(resourceName: "personal_info_switch_on_shift")
//            self.toogleBtn.setImage(btnImage, for: .normal)
//        }else{
//            let btnImage = (indexPath.row == 0) ? #imageLiteral(resourceName: "personal_info_switch_on_shift") : #imageLiteral(resourceName: "personal_info_switch_off")
//            self.toogleBtn.setImage(btnImage, for: .normal)
//        }
//        return fooCategoryToogleState
//    }
//}

