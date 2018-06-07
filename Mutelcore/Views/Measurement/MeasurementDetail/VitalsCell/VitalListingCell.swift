//
//  VitalListingCellCollectionViewCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 10/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class VitalListingCell: UICollectionViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var vitalData: UILabel!
    @IBOutlet weak var vitalUnit: UILabel!
    @IBOutlet weak var vitalName: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var vitalDate: UILabel!
    @IBOutlet weak var vitalTime: UILabel!
    @IBOutlet weak var stackViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var imageViewStacktopConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }
}

//MARK:- Methods
//===============
extension VitalListingCell {

   fileprivate func setupUI(){
    
        self.cellImage.layer.cornerRadius = self.cellImage.layer.frame.width / 2
        self.cellImage.clipsToBounds = true
        self.vitalData.font = AppFonts.sanProSemiBold.withSize(25)
        self.vitalUnit.font = AppFonts.sanProSemiBold.withSize(12)
        self.vitalUnit.textColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        self.vitalName.textColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        self.vitalDate.textColor = #colorLiteral(red: 0.5215686275, green: 0.5215686275, blue: 0.5215686275, alpha: 1)
        self.vitalDate.font = AppFonts.sanProSemiBold.withSize(11.3)
        self.vitalTime.font = AppFonts.sanProSemiBold.withSize(11.3)
        self.vitalTime.textColor = #colorLiteral(red: 0.5215686275, green: 0.5215686275, blue: 0.5215686275, alpha: 1)
        self.sepratorView.backgroundColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
    
        self.layer.cornerRadius = 2.0
        self.clipsToBounds = true
        
    }
    
    
    func populateMeasurementData(_ measurementHomeData : [MeasurementHomeData], _ index : IndexPath){
     
        if !measurementHomeData.isEmpty {
            
            if let image = measurementHomeData[index.item].vitalIcon {
                
                let imageUrlInStr = image.replacingOccurrences(of: " ", with: "%20")
                
                let imgURl = URL(string: imageUrlInStr)
                
                self.cellImage.af_setImage(withURL: imgURl!)
                
            }
            
            if let rating = measurementHomeData[index.item].rating {
                
                if rating == 0 {
                    
                    self.cellImage.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
                    self.vitalData.textColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
                    
                }else if rating == 1{
                    
                    self.cellImage.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
                    self.vitalData.textColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
                }else if rating == 2 {
                    
                    self.cellImage.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
                    self.vitalData.textColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
                }else{
                    
                    self.cellImage.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.vitalData.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
            }
            
            self.vitalName.text = measurementHomeData[index.item].vitalName
            
            if let measurementDate = measurementHomeData[index.item].measurementDate{
                
                self.vitalDate.text = measurementDate.dateFString(DateFormat.yyyyMMdd.rawValue, DateFormat.dMMMyyyy.rawValue)
                
            }
            
            self.vitalTime.text = measurementHomeData[index.item].measurementTime
            self.vitalUnit.text = measurementHomeData[index.item].vitalSubName
            self.vitalData.text = measurementHomeData[index.item].valueConversion
  
        }
    }
    
//    func populateLabTestData(_ labTestData : [LabTestModel], _ index : IndexPath){
//        
//        if !labTestData.isEmpty {
//            
//            if let image = labTestData[index.item].vitalIcon {
//                
//                let imageUrlInStr = image.replacingOccurrences(of: " ", with: "%20")
//                
//                let imgURl = URL(string: imageUrlInStr)
//                
//                self.cellImage.af_setImage(withURL: imgURl!)
//                
//            }
//            
//            if let rating = labTestData[index.item].rating {
//                
//                if rating == 0 {
//                    
//                    self.cellImage.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
//                    self.vitalData.textColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
//                    
//                }else if rating == 1{
//                    
//                   self.cellImage.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
//                    self.vitalData.textColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
//                }else if rating == 2 {
//                    
//                    self.cellImage.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
//                    self.vitalData.textColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
//                }else{
//                    
//                   self.cellImage.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//                    self.vitalData.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//                }
//            }
//            
//            self.vitalName.text = labTestData[index.item].vitalName
//            
//            if let measurementDate = labTestData[index.item].measurementDate{
//                
//                self.vitalDate.text = measurementDate.dateFString(DateFormat.yyyyMMdd.rawValue, DateFormat.dMMMyyyy.rawValue)
//                
//            }
//            
//            self.vitalTime.text = labTestData[index.item].measurementTime
//            self.vitalUnit.text = labTestData[index.item].vitalSubName
//            self.vitalData.text = labTestData[index.item].vitalConversion
//
//        }
//    }
    
//    MARK:- Populate Data on Image VC
//    ================================
    func populateImageData(_ imageData : [ImageDataModel], _ index : IndexPath){
        
        if !imageData.isEmpty {
            
            if let image = imageData[index.item].vitalIcon {
               
                printlnDebug("image :\(image)")
                let imageUrlInStr = image.replacingOccurrences(of: " ", with: "%20")
                
                let imgURl = URL(string: imageUrlInStr)
                
                printlnDebug("url :\(imgURl)")
                self.cellImage.af_setImage(withURL: imgURl!)
            }

            self.cellImage.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
//            if let rating = imageData[index.item].rating {
//                
//                if rating == 0 {
//                    
//                    self.cellImage.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
//                    self.vitalData.textColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
//                    
//                }else if rating == 1{
//                    
//                    self.cellImage.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
//                    self.vitalData.textColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
//                }else if rating == 2 {
//                    
//                    self.cellImage.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
//                    self.vitalData.textColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
//                }else{
//                    
//                    self.cellImage.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//                    self.vitalData.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//                }
//            }

            self.vitalName.text = imageData[index.item].vitalName
            
            if let measurementDate = imageData[index.item].measurementDate{
                
                self.vitalDate.text = measurementDate.dateFString(DateFormat.yyyyMMdd.rawValue, DateFormat.dMMMyyyy.rawValue)
                
            }
            
            self.vitalTime.text = imageData[index.item].measurementTime
            self.vitalUnit.isHidden = true
            self.vitalData.isHidden = true
//            self.vitalUnit.text = imageData[index.item].
//            self.vitalData.text = imageData[index.item].vitalConversion
            
        }
    }
    
//    MARK:- Populate Data on Image Detail Cell
//    =========================================
    func populateImageData(_ ImageData : ImageDataModel, imageCount : [String], index : IndexPath){
        
        let imageName = imageCount[index.item]
        
        self.vitalName.text = imageName
        
        if imageName.hasSuffix(".pdf"){
            
            self.cellImage.image = #imageLiteral(resourceName: "icMeasurementPdf")
            
        }else{
            
            self.cellImage.image = #imageLiteral(resourceName: "icImage")
            
        }
    }
    
//    MARK:- Populate Latest Vital Data
//    =================================
    func populateLatestVitalData(_ latestVitalData : [LatestThreeVitalData], _ index : IndexPath){
        
        guard !latestVitalData.isEmpty else{
            
            return
        }
        
        self.vitalData.text = latestVitalData[index.item].vitalConversion
        self.vitalUnit.text = latestVitalData[index.item].mainUnit
        self.vitalName.text = latestVitalData[index.item].vitalSubName
        self.vitalTime.text = latestVitalData[index.item].measurementTime
        
        if let vitalDate = latestVitalData[index.item].measurementDate{
            
            self.vitalDate.text = vitalDate.dateFString(DateFormat.yyyyMMdd.rawValue, DateFormat.dMMMyyyy.rawValue)
            
        }
        
        if index.item == 0 {
           
            self.vitalData.textColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
            
        }else if index.item == 1{
            
            self.vitalData.textColor = #colorLiteral(red: 0.9294117647, green: 0.1803921569, blue: 0.2862745098, alpha: 1)
            
        }else{
            
           self.vitalData.textColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
            
        }
    }
}
