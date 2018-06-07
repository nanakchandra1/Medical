//
//  EPrescriptionTableCell.swift
//  Mutelcor
//
//  Created by  on 29/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class EPrescriptionTableCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var viewContainAllObjects: UIView!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var timeTextLabel: UILabel!
    @IBOutlet weak var monthYearTextLabel: UILabel!
    
    @IBOutlet weak var dateTextverticalLineView: UIView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorSpecialityLabel: UILabel!
    
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var shareImageContainerView: UIView!
    @IBOutlet weak var shareBtnOutlt: UIButton!
    
    @IBOutlet weak var ePrescriptionBtn: UIButton!
    @IBOutlet weak var ePrescriptionBtnContainerView: UIView!
    @IBOutlet weak var ePrescriptionBtnContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var remarkView: UIView!
    @IBOutlet weak var remarkViewTopLineView: UIView!
    @IBOutlet weak var remarkViewBottomLineView: UIView!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var remarkViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var prescriptionsLabel: UILabel!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
        resetCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    private func resetCell() {
        remarkLabel.text = nil
        noDataAvailiableLabel.isHidden = true
        remarkViewHeightConstraint.constant = 0
    }
}

extension EPrescriptionTableCell {
    
    fileprivate func setupUI(){
        
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.noDataAvailiableLabel.isHidden = true
        self.noDataAvailiableLabel.text = "No Records Found!"
        
        self.viewContainAllObjects.layer.cornerRadius = 2.2
        self.viewContainAllObjects.layer.masksToBounds = true
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.outerView.layer.cornerRadius = 2.2
        self.outerView.clipsToBounds = false
        self.outerView.layer.masksToBounds = false
        
        self.shareImageView.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.shareImageView.image = #imageLiteral(resourceName: "icActivityplanShare")
        self.dateTextLabel.font = AppFonts.sansProBold.withSize(29.5)
        self.monthYearTextLabel.font = AppFonts.sansProBold.withSize(12.5)
        self.timeTextLabel.font = AppFonts.sanProSemiBold.withSize(12)
        self.doctorNameLabel.font = AppFonts.sanProSemiBold.withSize(18)
        self.doctorSpecialityLabel.font = AppFonts.sansProRegular.withSize(11.3)
        self.dateTextverticalLineView.backgroundColor = UIColor.sepratorColor
        self.remarkViewTopLineView.backgroundColor = UIColor.sepratorColor
        self.remarkViewBottomLineView.backgroundColor = UIColor.sepratorColor
        self.ePrescriptionBtn.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.ePrescriptionBtn.setTitle(K_EPRESCRIPTION_SCREEN_TITLE.localized, for: UIControlState.normal)
        self.ePrescriptionBtn.setTitleColor(UIColor.appColor, for: UIControlState.normal)
        self.ePrescriptionBtn.tintColor = UIColor.appColor
        
        self.contentView.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
    }
    
    func populateCurrentEprescriptionData(_ prescriptionData : [EprescriptionModel], _ index : IndexPath){
        
        guard !prescriptionData.isEmpty else{
            self.noDataAvailiableLabel.isHidden = false
            return
        }
        self.noDataAvailiableLabel.isHidden = true
        self.doctorNameLabel.text = prescriptionData[index.row].doctorName
        self.doctorSpecialityLabel.text = prescriptionData[index.row].docSpecialisation
        
        let isAttachmentBtnHidden = (!prescriptionData[index.row].attachmentPath.isEmpty ) ? false : true
        self.ePrescriptionBtn.isHidden = isAttachmentBtnHidden
        let btnContainerHeight = (!isAttachmentBtnHidden) ? 45 : 0
        self.ePrescriptionBtnContainerHeight.constant = CGFloat(btnContainerHeight)
        let currentDate = prescriptionData[index.row].createdAt
        
        self.dateTextLabel.text = currentDate.changeDateFormat(.utcTime, .DD)
        self.monthYearTextLabel.text = currentDate.changeDateFormat(.utcTime, .mmYYYY)
        self.timeTextLabel.text = currentDate.changeDateFormat(.utcTime, .Hmm)
        
        let remarks = prescriptionData[index.row].remark
        
        if !remarks.isEmpty {
            let remarkAttributed = NSMutableAttributedString(string: "Remarks: ", attributes: [NSAttributedStringKey.font : AppFonts.sansProBoldlt.withSize(14), NSAttributedStringKey.foregroundColor : UIColor.appColor])
            let remarkAtt = NSAttributedString(string: remarks, attributes: [NSAttributedStringKey.font : AppFonts.sansProlt.withSize(14)])
            remarkAttributed.append(remarkAtt)
            self.remarkLabel.attributedText = remarkAttributed
            let remarkLableWidth = (UIScreen.main.bounds.width - 48.5)
            remarkViewHeightConstraint.constant = 20 + remarkAttributed.boundingRect(with: CGSize(width: remarkLableWidth, height: 1000), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
        }
        
        let drugNameAtt = NSMutableAttributedString(string: "")
        let totalPrescriptionsCount = prescriptionData.count
        
        for (index, prescription) in prescriptionData.enumerated() {
            let drugNameAttributed = NSMutableAttributedString(string: "\(prescription.drugName)\n", attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(15)])
            let lineChange = (index == (totalPrescriptionsCount-1) ? "":"\n")
            let drugInfo = NSAttributedString(string: "\(prescription.drugInfo)\n\(lineChange)", attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(13)])
            drugNameAttributed.append(drugInfo)
            drugNameAtt.append(drugNameAttributed)
        }
        self.prescriptionsLabel.attributedText = drugNameAtt
    }
    
    func populatePreviousEPrescriptionData(_ prescriptionData : [[EprescriptionModel]], _ index : IndexPath){
        
        guard !prescriptionData.isEmpty else{
            return
        }
        self.doctorNameLabel.text = prescriptionData[index.row][0].doctorName
        self.doctorSpecialityLabel.text = prescriptionData[index.row][0].docSpecialisation
        
        let currentDate = prescriptionData[index.row][0].createdAt
            
            self.dateTextLabel.text = currentDate.changeDateFormat(.utcTime, .DD)
            self.monthYearTextLabel.text = currentDate.changeDateFormat(.utcTime, .mmYYYY)
            self.timeTextLabel.text = currentDate.changeDateFormat(.utcTime, .Hmm)
        let isAttachmentBtnHidden = (!prescriptionData[index.row][0].attachmentPath.isEmpty ) ? false : true
        self.ePrescriptionBtn.isHidden = isAttachmentBtnHidden
        let btnContainerHeight = (!isAttachmentBtnHidden) ? 45 : 0
        self.ePrescriptionBtnContainerHeight.constant = CGFloat(btnContainerHeight)
        
        let remarks = prescriptionData[index.row][0].remark
        
        if !remarks.isEmpty {
            
            let remarkAttributed = NSMutableAttributedString(string: "Remarks: ", attributes: [NSAttributedStringKey.font : AppFonts.sansProBoldlt.withSize(14), NSAttributedStringKey.foregroundColor : UIColor.appColor])
            
            let remarkAtt = NSAttributedString(string: remarks, attributes: [NSAttributedStringKey.font : AppFonts.sansProlt.withSize(14)])
            
            remarkAttributed.append(remarkAtt)
            self.remarkLabel.attributedText = remarkAttributed
            
            let remarkLableWidth = (UIScreen.main.bounds.width - 48.5)
            remarkViewHeightConstraint.constant = 20 + remarkAttributed.boundingRect(with: CGSize(width: remarkLableWidth, height: 1000), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
        }
        
        let drugNameAtt = NSMutableAttributedString(string: "")
        let totalPrescriptionsCount = prescriptionData.count
        
        for (index, prescription) in prescriptionData[index.row].enumerated() {
            
            let drugNameAttributed = NSMutableAttributedString(string: "\(prescription.drugName)\n", attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(15)])
            let lineChange = (index == (totalPrescriptionsCount-1) ? "":"\n")
            let drugInfo = NSAttributedString(string: "\(prescription.drugInfo)\(lineChange)", attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(13)])
            
            drugNameAttributed.append(drugInfo)
            drugNameAtt.append(drugNameAttributed)
        }
        self.prescriptionsLabel.attributedText = drugNameAtt
    }
}

