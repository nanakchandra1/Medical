//
//  DateOfBirthCell.swift
//  Mutelcor
//
//  Created by  on 20/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON

class DateOfBirthCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    =================
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var celltextField: UITextField!
    @IBOutlet weak var cellBtnOutlt: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
        self.celltextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.celltextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icNotificationRightarrow"))
        self.celltextField.rightViewMode = .always
        self.cellBtnOutlt.removeTarget(self, action: nil, for: .allEvents)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.celltextField.removeTarget(self, action: nil, for: .allEvents)
    }
}

//MARK:- Data Populate on Cell
//============================
extension DateOfBirthCell {
    
    func populateDateOfBirth(_ userInfo : UserInfo?){

        guard let userData = userInfo else{
            return
        }
        if let date = userData.patientDob {
            self.celltextField.text = date.stringFormDate(.ddMMMYYYY)
        }
    }
    
    
    func populateBloodData(_ userInfo : UserInfo?) {
        
        guard let userData = userInfo else{
            return
        }
        
        guard !userData.medicalInfo.isEmpty else{
            return
        }
        self.celltextField.text = userData.medicalInfo.first?.patientBloodGroup
    }
    
    func populateSurgeryData(_ selectedSurgerydata : [SurgeryModel]){
        
        guard !selectedSurgerydata.isEmpty else{
            return
        }
        self.celltextField.text = selectedSurgerydata.first?.surgeryName
    }
    
    func populateSpecilityData(_ selectedSpeciality : [SpecialityModel]){
        guard !selectedSpeciality.isEmpty else{
            return
        }
        self.celltextField.text = selectedSpeciality.first?.specialityName
    }
    
    func populateHospitalData(_ userInfo : UserInfo?, _ indexPath: IndexPath){
        
        self.celltextField.isEnabled = false
        self.celltextField.textColor = UIColor.gray
        guard let userData = userInfo else{
            return
        }
        
        switch indexPath.row{
            
        case 0:
            self.celltextField.text = userData.doctorName
        case 1:
            self.celltextField.text = userData.patientHospitalName
        case 2:
            self.celltextField.text = userData.assosiatedDoctor
        default:
            return
        }
    }
 
    func populateUserOccupationData(_ userInfo: UserInfo?, _ indexPath: IndexPath,_ occupation: [String], _ maritialStatus: [String]){
        
        var patientOccupation = ""
        var status = ""
        guard let userData = userInfo else{
            return
        }
        switch indexPath.row{
        case 7:
            let occupatn = userData.occupation
            
            if occupatn == PatientOccupation.services.rawValue {
                patientOccupation = occupation[0]
            }else if occupatn == PatientOccupation.business.rawValue {
                patientOccupation = occupation[1]
            }else{
                patientOccupation = occupation[2]
            }
            self.celltextField.text = patientOccupation
        case 8:
            let maritialStats = userData.maritalStatus
            
            if maritialStats == MaritalStatus.single.rawValue {
                status = maritialStatus[0]
            }else if maritialStats == MaritalStatus.married.rawValue {
                status = maritialStatus[1]
            }else{
                status = maritialStatus[2]
            }
            self.celltextField.text = status
        default:
            return
        }
    }
    
    func populateEmergencyContactDetail(_ userInfo: UserInfo?, indexPath : IndexPath){
        
        guard let userData = userInfo else{
            return
        }
        switch indexPath.row {
        case 0:
            self.celltextField.text = userData.emergencyContactPerson
        case 1:
            self.celltextField.text = userData.patientEmergencyRelationShip
        default:
            return
        }
    }
}
