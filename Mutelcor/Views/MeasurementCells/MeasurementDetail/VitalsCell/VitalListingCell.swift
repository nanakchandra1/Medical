//
//  VitalListingCellCollectionViewCell.swift
//  Mutelcor
//
//  Created by on 10/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class VitalListingCell: UICollectionViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var cellImageBackgroundView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var vitalData: UILabel!
    @IBOutlet weak var vitalUnit: UILabel!
    @IBOutlet weak var vitalName: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var vitalDate: UILabel!
    @IBOutlet weak var vitalTime: UILabel!
    @IBOutlet weak var imageViewStacktopConstant: NSLayoutConstraint!
    @IBOutlet weak var cellImageBackgroundViewWidthConstant: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
}

//MARK:- Methods
//===============
extension VitalListingCell {
    
    fileprivate func setupUI(){
        self.cellImageBackgroundView.roundCorner(radius: self.cellImageBackgroundView.layer.frame.width / 2, borderColor: UIColor.clear, borderWidth: CGFloat.leastNormalMagnitude)
        self.cellImage.layer.cornerRadius = self.cellImage.layer.frame.width / 2
        self.cellImage.clipsToBounds = true
        self.vitalData.font = AppFonts.sanProSemiBold.withSize(25)
        self.vitalUnit.font = AppFonts.sanProSemiBold.withSize(12)
        self.vitalName.font = AppFonts.sanProSemiBold.withSize(13)
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
        
        guard !measurementHomeData.isEmpty else{
            return
        }
        if let image = measurementHomeData[index.item].vitalIcon, !image.isEmpty {
            let imageUrlInStr = image.replacingOccurrences(of: " ", with: "%20")
            let imgURl = URL(string: imageUrlInStr)
            self.cellImage.af_setImage(withURL: imgURl!, placeholderImage: #imageLiteral(resourceName: "icAddmenuMeasurement"))
        }else{
            self.cellImage.image = #imageLiteral(resourceName: "icAddmenuMeasurement")
        }
            
            if let rating = measurementHomeData[index.item].rating {
                
                if rating == 0 {
                    self.cellImageBackgroundView.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
                    self.cellImage.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
                    self.vitalData.textColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
                }else if rating == 1{
                    self.cellImageBackgroundView.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
                    self.cellImage.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
                    self.vitalData.textColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
                }else if rating == 2 {
                    self.cellImageBackgroundView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
                    self.cellImage.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
                    self.vitalData.textColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
                }else{
                    self.cellImageBackgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.cellImage.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.vitalData.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
            }
            
            self.vitalName.text = measurementHomeData[index.item].vitalName?.uppercased()
            
            if let measurementDate = measurementHomeData[index.item].measurementDate{
                self.vitalDate.text = measurementDate.changeDateFormat(.yyyyMMdd, .ddMMMYYYY)
            }
            
            self.vitalTime.text = measurementHomeData[index.item].measurementTime
            self.vitalUnit.text = measurementHomeData[index.item].vitalSubName
            self.vitalData.text = measurementHomeData[index.item].valueConversion
        }
    
    //    MARK:- Populate Data on Image VC
    //    ================================
    func populateImageData(_ imageData : [ImageDataModel], _ index : IndexPath){
        
        if !imageData.isEmpty {
            
            if let image = imageData[index.item].vitalIcon, !image.isEmpty {
                let imageUrlInStr = image.replacingOccurrences(of: " ", with: "%20")
                    let imgURl = URL(string: imageUrlInStr)
                self.cellImage.af_setImage(withURL: imgURl!, placeholderImage: #imageLiteral(resourceName: "icAddmenuMeasurement"))
            }else{
                self.cellImage.image = #imageLiteral(resourceName: "icAddmenuMeasurement")
            }
            
            self.cellImageBackgroundView.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
            self.cellImage.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
            self.vitalName.text = imageData[index.item].vitalName?.uppercased()
            if let measurementDate = imageData[index.item].measurementDate{
                self.vitalDate.text = measurementDate.changeDateFormat(.yyyyMMdd, .dMMMyyyy)
            }
            
            self.vitalTime.text = imageData[index.item].measurementTime
            self.vitalUnit.isHidden = true
            self.vitalData.isHidden = true
        }
    }
    
    //    MARK:- Populate Data on Image Detail Cell
    //    =========================================
    func populateImageData(_ ImageData : ImageDataModel, imageCount : [String], index : IndexPath){
        
        let imageName = imageCount[index.item]
        self.vitalName.text = imageName.uppercased()
        
        if imageName.hasSuffix(".pdf"){
            self.cellImage.image = #imageLiteral(resourceName: "icMeasurementPdf")
        }else{
            self.cellImage.image = #imageLiteral(resourceName: "icImage")
        }
    }
    
    //    MARK:- Populate Latest Vital Data
    //    =================================
    func populateLatestVitalData(_ latestVitalData : [LatestThreeVitalData], _ index : IndexPath){

        self.cellImageBackgroundViewWidthConstant.constant = 0
        self.cellImageBackgroundView.isHidden = true
        self.cellImage.isHidden = true
        guard !latestVitalData.isEmpty else{
            return
        }
        
        self.vitalData.text = latestVitalData[index.item].vitalConversion
        self.vitalUnit.text = latestVitalData[index.item].mainUnit
        self.vitalName.text = latestVitalData[index.item].vitalSubName?.uppercased()
        self.vitalTime.text = latestVitalData[index.item].measurementTime
        
        if let vitalDate = latestVitalData[index.item].measurementDate{
            self.vitalDate.text = vitalDate.changeDateFormat(.yyyyMMdd, .dMMMyyyy)
        }
        
        if index.item == 0 {
            self.vitalData.textColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
        }else if index.item == 1{
            self.vitalData.textColor = #colorLiteral(red: 0.9294117647, green: 0.1803921569, blue: 0.2862745098, alpha: 1)
        }else{
            self.vitalData.textColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
        }
    }
    
    func populateDashboardData(_ dashboardData: [DashboardDataModel], _ index: IndexPath){
        
        guard !dashboardData.isEmpty else{
            return
        }
        guard let data = dashboardData.first else{
            return
        }
        guard !data.lastSentData.isEmpty else{
            return
        }

        if let image = data.lastSentData[index.item].vitalIcon, !image.isEmpty {
            let imageUrlInStr = image.replacingOccurrences(of: " ", with: "%20")
            let imgURl = URL(string: imageUrlInStr)
            self.cellImage.af_setImage(withURL: imgURl!, placeholderImage: #imageLiteral(resourceName: "icAddmenuMeasurement"))
        }else{
            self.cellImage.image = #imageLiteral(resourceName: "icAddmenuMeasurement")
        }
        
        if let rating = data.lastSentData[index.item].severity {
            if rating == 0 {
                self.cellImageBackgroundView.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
                self.cellImage.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
                self.vitalData.textColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
            }else if rating == 1{
                self.cellImageBackgroundView.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
                self.cellImage.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
                self.vitalData.textColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
            }else if rating == 2 {
                self.cellImageBackgroundView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
                self.cellImage.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
                self.vitalData.textColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
            }else{
                self.cellImageBackgroundView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                self.cellImage.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                self.vitalData.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }
        }
        
        self.vitalName.text = data.lastSentData[index.item].vitalName?.uppercased()
        let date = data.lastSentData[index.item].measurementDate?.changeDateFormat(.utcTime, .ddMMMYYYY) ?? ""
        let time = data.lastSentData[index.item].measurementTime
        self.vitalDate.text = date
        self.vitalTime.text = time
        self.vitalUnit.text = data.lastSentData[index.item].vitalSubName
        let value = !data.lastSentData[index.item].valueConversion.isEmpty ? data.lastSentData[index.item].valueConversion : "0"
        self.vitalData.text = value
    }
}
