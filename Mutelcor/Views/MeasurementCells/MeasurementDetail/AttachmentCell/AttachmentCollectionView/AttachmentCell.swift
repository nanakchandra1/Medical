//
//  AttachmentCellCollectionViewCell.swift
//  Mutelcor
//
//  Created by on 17/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class AttachmentCell: UICollectionViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var pdfImageView: UIImageView!
    @IBOutlet weak var pdfNameLabel: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deleteButtonOutlt: UIButton!
    @IBOutlet weak var dateStackViewConstant: NSLayoutConstraint!
    @IBOutlet weak var imageStackViewTopConstraint: NSLayoutConstraint!
    
//    MARK;- Cell LifeCycle
//    ======================
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
}

//MARK:- Methods
//==============
extension AttachmentCell{
    
    fileprivate func setupUI(){
        
        self.roundCorner(radius: 2.0, borderColor: UIColor.clear, borderWidth: 0.0)
        self.pdfImageView.image = #imageLiteral(resourceName: "icMeasurementPdf")
        
        self.pdfNameLabel.font = AppFonts.sanProSemiBold.withSize(13.6)
        self.pdfNameLabel.textColor = UIColor.textColor
        
        self.dateLabel.font = AppFonts.sanProSemiBold.withSize(11.3)
        self.dateLabel.textColor = #colorLiteral(red: 0.5215686275, green: 0.5215686275, blue: 0.5215686275, alpha: 1)
        
        self.timeLabel.font = AppFonts.sanProSemiBold.withSize(11.3)
        self.timeLabel.textColor = #colorLiteral(red: 0.5215686275, green: 0.5215686275, blue: 0.5215686275, alpha: 1)
    }
    
    func populateData(_ attachmentData : [AttachmentDataModel], index : IndexPath){

        guard !attachmentData.isEmpty else{
            return
        }
        
        if let date = attachmentData[index.item].measurementDate{
            self.dateLabel.text = date.changeDateFormat(.yyyyMMdd, .dMMMyyyy)
        }
        
        if let time = attachmentData[index.item].measurementTime {
            self.timeLabel.text = time.changeDateFormat(.HHmmss, .Hmm)
        }
        
        self.timeLabel.text = attachmentData[index.item].measurementTime
        self.pdfNameLabel.text = attachmentData[index.item].attachmentName
        
        if let imageName = attachmentData[index.item].attachmentName{
            if imageName.hasSuffix(".pdf"){
                self.pdfImageView.image = #imageLiteral(resourceName: "icMeasurementPdf")
            }else{
               self.pdfImageView.image = #imageLiteral(resourceName: "icImage")
            }
        }
    }
    
    func populateImageData(_ ImageData : ImageDataModel, imageCount : [String], index : IndexPath){
        
        let imageName = imageCount[index.item]
        self.pdfNameLabel.text = imageName
        if imageName.hasSuffix(".pdf"){
            self.pdfImageView.image = #imageLiteral(resourceName: "icMeasurementPdf")
        }else{
            self.pdfImageView.image = #imageLiteral(resourceName: "icImage")
        }
    }
}
