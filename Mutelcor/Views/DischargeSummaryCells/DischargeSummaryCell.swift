//
//  DischargeSummaryCell.swift
//  Mutelcor
//
//  Created by on 03/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class DischargeSummaryCell: UITableViewCell {
    
    //  MARK:- IBOutlets
//    ====================
    @IBOutlet weak var viewContainObjects: UIView!
    @IBOutlet weak var dischargeDateLabel: UILabel!
    @IBOutlet weak var dischargeMonthLabel: UILabel!
    @IBOutlet weak var dischargeTimeLabel: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var shareBtnOutlt: UIButton!
    
    @IBOutlet weak var surgeryTypeLabel: UILabel!
    @IBOutlet weak var surgeryTypeDescription: UILabel!
    @IBOutlet weak var operativeApproachLabel: UILabel!
    @IBOutlet weak var operativeApproachDescription: UILabel!
    @IBOutlet weak var surgeryProcedureLabel: UILabel!
    @IBOutlet weak var surgeryProcedureDescription: UILabel!
    
    @IBOutlet weak var dateIntervalView: UIView!
    @IBOutlet weak var dischargeDateIntervalView: UIView!
    @IBOutlet weak var dischargeDateInnerIntervalView: UIView!
    @IBOutlet weak var dischargeDateDotLineView: UIView!
    
    @IBOutlet weak var admissionDateIntervalView: UIView!
    @IBOutlet weak var admissionDateInnerIntervalView: UIView!
    @IBOutlet weak var admissionDateDotLineView: UIView!
    
    @IBOutlet weak var surgeryDateIntervalView: UIView!
    @IBOutlet weak var surgeryDateInnerIntervalView: UIView!
    @IBOutlet weak var surgeryDateDotLineView: UIView!
    
    @IBOutlet weak var admissionDateLabel: UILabel!
    @IBOutlet weak var admissionDate: UILabel!
    
    @IBOutlet weak var surgeyDateLabel: UILabel!
    @IBOutlet weak var surgeryDate: UILabel!
    
    @IBOutlet weak var dischargedDatLabel: UILabel!
    @IBOutlet weak var dischargeDate: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    @IBOutlet weak var outerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.setupUI()
    }
}

//MARK:- Methods
//===============
extension DischargeSummaryCell {
    
    fileprivate func setupUI(){
        
        self.viewContainObjects.layer.cornerRadius = 2.2
        self.viewContainObjects.clipsToBounds = true
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        
        self.dischargeDateLabel.font = AppFonts.sansProBold.withSize(29)
        self.dischargeMonthLabel.font = AppFonts.sansProBold.withSize(12.5)
        self.dischargeTimeLabel.font = AppFonts.sanProSemiBold.withSize(12)
        self.doctorName.font = AppFonts.sanProSemiBold.withSize(18)
        self.doctorSpeciality.font = AppFonts.sansProRegular.withSize(11.3)
        
        self.shareBtnOutlt.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.shareBtnOutlt.setImage(#imageLiteral(resourceName: "icActivityplanShare"), for: .normal)
        
        self.dischargeDateIntervalView.roundCorner(radius: self.dischargeDateIntervalView.frame.width / 2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.dischargeDateInnerIntervalView.roundCorner(radius: self.dischargeDateInnerIntervalView.frame.width / 2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.dischargeDateInnerIntervalView.backgroundColor = UIColor.appColor
        self.dischargeDateIntervalView.backgroundColor = UIColor.white
        self.dischargeDateDotLineView.backgroundColor = UIColor.clear
        
        self.admissionDateIntervalView.roundCorner(radius: self.admissionDateIntervalView.frame.width / 2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.admissionDateInnerIntervalView.roundCorner(radius: self.admissionDateInnerIntervalView.frame.width / 2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.admissionDateInnerIntervalView.backgroundColor = UIColor.appColor
        self.admissionDateIntervalView.backgroundColor = UIColor.white
        self.admissionDateDotLineView.backgroundColor = UIColor.clear
        
        self.surgeryDateIntervalView.roundCorner(radius: self.surgeryDateIntervalView.frame.width / 2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.surgeryDateInnerIntervalView.roundCorner(radius: self.surgeryDateInnerIntervalView.frame.width / 2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.surgeryDateInnerIntervalView.backgroundColor = UIColor.appColor
        self.surgeryDateIntervalView.backgroundColor = UIColor.white
        self.surgeryDateDotLineView.backgroundColor = UIColor.clear
        
        self.admissionDateDotLineView.dashLine(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: self.admissionDateDotLineView.layer.bounds.height), [3,2])
        self.surgeryDateDotLineView.dashLine(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: self.surgeryDateDotLineView.layer.bounds.height), [3,2])
        self.dischargeDateDotLineView.dashLine(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: self.dischargeDateDotLineView.layer.bounds.height), [3,2])
        
        self.shareBtnOutlt.tintColor = UIColor.appColor
        
        for label in [self.admissionDateLabel, self.surgeyDateLabel, self.dischargedDatLabel, self.descriptionLabel]{
            
            label?.font = AppFonts.sansProRegular.withSize(14)
        }
    }
    
    func populateData(_ dischargeSummaryData : [DischargeSummaryModel], indexPath : IndexPath){
        
        guard !dischargeSummaryData.isEmpty else{
            return
        }
        
        if let docName = dischargeSummaryData[indexPath.row].doctorName, !docName.isEmpty {
            self.doctorName.text = docName
        }else{
            self.doctorName.text = AppUserDefaults.value(forKey: .doctorName).stringValue
        }
        
        if let doctorSpeciality = dischargeSummaryData[indexPath.row].doctorSpecialization, !doctorSpeciality.isEmpty {
            self.doctorSpeciality.text = doctorSpeciality
        }else{
            self.doctorSpeciality.text = AppUserDefaults.value(forKey: .doctorSpecialization).stringValue
        }
        self.surgeryTypeDescription.text = dischargeSummaryData[indexPath.row].surgeryType
        self.operativeApproachDescription.text = dischargeSummaryData[indexPath.row].operativeApproach
        self.surgeryProcedureDescription.text = dischargeSummaryData[indexPath.row].surgeryProcedure
        self.admissionDate.text = dischargeSummaryData[indexPath.row].dateAdmission?.changeDateFormat(.utcTime, .ddMMMYYYY)
        self.surgeryDate.text = dischargeSummaryData[indexPath.row].dateSurgery?.changeDateFormat(.utcTime, .ddMMMYYYY)
        if let attachment = dischargeSummaryData[indexPath.row].attachment, !attachment.isEmpty{
            self.shareBtnOutlt.isHidden = false
        }else{
            self.shareBtnOutlt.isHidden = true
        }
        
        if let createdDate = dischargeSummaryData[indexPath.row].createdAt {
            self.dischargeDate.text = createdDate.changeDateFormat(.utcTime, .ddMMMYYYY)
            self.dischargeDateLabel.text = createdDate.changeDateFormat(.utcTime, .DD)
            self.dischargeMonthLabel.text = createdDate.changeDateFormat(.utcTime, .mmYYYY)
            self.dischargeTimeLabel.text = createdDate.changeDateFormat(.utcTime, .Hmm)
        }
        
        self.dischargeDate.text = dischargeSummaryData[indexPath.row].dateDischarge?.changeDateFormat(.utcTime, .ddMMMYYYY)
        
        var finalDiagnosis : NSMutableAttributedString?
        var procedures : NSMutableAttributedString?
        var hospitalCourse : NSMutableAttributedString?
        var dischargeMedication : NSMutableAttributedString?
        var followUpAppointment : NSMutableAttributedString?
        var dischargeAdvice : NSMutableAttributedString?
        var labratoryData : NSMutableAttributedString?
        var illnessHistory : NSMutableAttributedString?
        
        
        if let finalDiagnos = dischargeSummaryData[indexPath.row].finalDiaognises, !finalDiagnos.isEmpty{
            finalDiagnosis = self.addAttributes(K_FINAL_DIAGNOSIS.localized, finalDiagnos)
        }else{
            finalDiagnosis = self.addAttributes(K_FINAL_DIAGNOSIS.localized, "No record Found!")
        }
        
        if let procedure = dischargeSummaryData[indexPath.row].procedures, !procedure.isEmpty{
            procedures = self.addAttributes(K_PROCEDURES.localized, procedure)
        }else{
            procedures = self.addAttributes(K_PROCEDURES.localized, "No record Found!")
        }
        
        if let hospitalCours = dischargeSummaryData[indexPath.row].hospitalCourse, !hospitalCours.isEmpty{
            hospitalCourse = self.addAttributes(K_HOSPITAL_COURSE.localized, hospitalCours)
        }else{
            hospitalCourse = self.addAttributes(K_HOSPITAL_COURSE.localized, "No record Found!")
        }
        if let dischargeMedic = dischargeSummaryData[indexPath.row].dischargeMedication, !dischargeMedic.isEmpty{
            dischargeMedication = self.addAttributes(K_DISCHARGE_MEDICATION.localized, dischargeMedic)
        }else{
            dischargeMedication = self.addAttributes(K_DISCHARGE_MEDICATION.localized, "No record Found!")
        }
        if let followAppoint = dischargeSummaryData[indexPath.row].followAppointment, !followAppoint.isEmpty{
            followUpAppointment = self.addAttributes(K_FOLLOW_UP_APPOINTMENT.localized, followAppoint)
        }else{
            followUpAppointment = self.addAttributes(K_FOLLOW_UP_APPOINTMENT.localized, "No record Found!")
        }
        
        if let dischargeAdvise = dischargeSummaryData[indexPath.row].dischargeAdvice, !dischargeAdvise.isEmpty{
            dischargeAdvice = self.addAttributes(K_DISCHARGE_ADVICE.localized, dischargeAdvise)
        }else{
            dischargeAdvice = self.addAttributes(K_DISCHARGE_ADVICE.localized, "No record Found!")
        }
        
        if let labData = dischargeSummaryData[indexPath.row].laboratoryData, !labData.isEmpty{
            labratoryData = self.addAttributes(K_LABORATORY_DATA.localized, labData)
        }else{
            labratoryData = self.addAttributes(K_LABORATORY_DATA.localized, "No record Found!")
        }
        
        if let illness = dischargeSummaryData[indexPath.row].finalDiaognises, !illness.isEmpty{
            illnessHistory = self.addAttributes(K_ILLNESS_HISTORY.localized, illness, true)
        }else{
            illnessHistory = self.addAttributes(K_ILLNESS_HISTORY.localized, "No record Found!")
        }
        
        finalDiagnosis!.append(procedures!)
        finalDiagnosis!.append(hospitalCourse!)
        finalDiagnosis!.append(dischargeMedication!)
        finalDiagnosis!.append(followUpAppointment!)
        finalDiagnosis!.append(dischargeAdvice!)
        finalDiagnosis!.append(labratoryData!)
        finalDiagnosis!.append(illnessHistory!)
        
        self.descriptionLabel.attributedText = finalDiagnosis
        
        let updatedAt = dischargeSummaryData[indexPath.row].updatedAt?.changeDateFormat(.utcTime, .ddMMMYYYYHHmm)
        let updatedBy = dischargeSummaryData[indexPath.row].updatedBy
        
        let lastUpdatedMutableString = NSMutableAttributedString(string: "LAST UPDATED: ", attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(14),NSAttributedStringKey.foregroundColor : UIColor.grayLabelColor])
        
        let attributedString = NSAttributedString(string: "\(updatedAt ?? "") ", attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(14), NSAttributedStringKey.foregroundColor : UIColor.black])
        
        let byText = (!updatedBy!.isEmpty) ? "By " : ""
        
        let byAttributedString = NSAttributedString(string: byText, attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(14),NSAttributedStringKey.foregroundColor : UIColor.grayLabelColor])
        let updatedByAttributedString = NSAttributedString(string: "\(updatedBy ?? "")", attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(14), NSAttributedStringKey.foregroundColor : UIColor.black])
        
        lastUpdatedMutableString.append(attributedString)
        lastUpdatedMutableString.append(byAttributedString)
        lastUpdatedMutableString.append(updatedByAttributedString)
        
        self.lastUpdateLabel.attributedText = lastUpdatedMutableString
    }
    
    fileprivate func addAttributes(_ header : String, _ text : String, _ illnessHistory : Bool = false) -> NSMutableAttributedString{
        
        let mutableHeader = NSMutableAttributedString(string: "\(header)\n", attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(14)])
        
        let lineChange = (!illnessHistory) ? "\n\n" : ""
        
        let attributedString = NSAttributedString(string: "\(text)\(lineChange)", attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(14), NSAttributedStringKey.foregroundColor : UIColor.black])
        
        mutableHeader.append(attributedString)
        
        return mutableHeader
    }
}
