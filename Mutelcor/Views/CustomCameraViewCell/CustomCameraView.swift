//
//  CustomCameraView.swift
//  Mutelcor
//
//  Created by  on 29/01/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

protocol CustomCameraButtonTapped: class {
    func checkButtonTapped()
    func crossButtonTapped()
    func deleteButtonTapped()
}

class CustomCameraView: UIView {
    
    //    Mark:- Proporties
    //    =================
    weak var delegate: CustomCameraButtonTapped?
    weak var imagePicker:UIImagePickerController?
    var capturedImages: [UIImage] = []
    
    //    MARK:- IBOutlets
    //    ==============
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var capturedImageCount: UILabel!
    @IBOutlet weak var imageCountBackgroundView: UIView!
    @IBOutlet weak var capturedButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var crossButtonOutlt: UIButton!
    @IBOutlet weak var imageButtonOutlt: UIButton!
    @IBOutlet weak var checkButtonOutlt: UIButton!
    @IBOutlet weak var deleteButtonOutlt: UIButton!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.imageDisplay()
        
        self.backgroundColor = UIColor.clear
        self.imageCountBackgroundView.roundCorner(radius: self.imageCountBackgroundView.frame.width / 2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.imageCountBackgroundView.backgroundColor = UIColor.white
        self.capturedImageCount.font = AppFonts.sansProBold.withSize(16)
        self.capturedImage.layer.cornerRadius = 3.0
        self.capturedImage.clipsToBounds = true
    }
    
    class func instanciateFromNib() -> CustomCameraView {
        return Bundle.main.loadNibNamed("CustomCameraView", owner: nil, options: nil)?.first as! CustomCameraView
    }
    
    //    MARK:- IBActions
    
    @IBAction func capturedButtonTapped(_ sender: UIButton) {
       
        if self.capturedImages.count < 5{
            guard let picker = self.imagePicker else{
                return
            }
            picker.takePicture()
        }else{
            showToastMessage("you should able to capture not more than 5 images at once.")
        }
    }
    
    @IBAction func flashButtonTapped(_ sender: UIButton) {
        guard let picker = self.imagePicker else{
            return
        }
        sender.isSelected = !sender.isSelected
        let flashModelEnabled: UIImagePickerControllerCameraFlashMode = sender.isSelected ? .on : .off
        picker.cameraFlashMode = flashModelEnabled
    }
    
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        self.delegate?.checkButtonTapped()
    }
    
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        self.delegate?.crossButtonTapped()
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        self.delegate?.checkButtonTapped()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        self.delegate?.deleteButtonTapped()
    }
    
    func imageDisplay(capturedImages: [UIImage] = []){
        
        let isImageCountDisplay = self.capturedImages.isEmpty ? false : true
        self.deleteButtonOutlt.isHidden = !isImageCountDisplay
        self.capturedImageCount.isHidden = !isImageCountDisplay
        self.capturedImage.isHidden = !isImageCountDisplay
        self.imageCountBackgroundView.isHidden = !isImageCountDisplay
        self.imageButtonOutlt.isHidden = !isImageCountDisplay
        self.checkButtonOutlt.isHidden = !isImageCountDisplay
        
        if isImageCountDisplay {
            self.capturedImage.image = self.capturedImages.last
            self.capturedImageCount.text = "\(self.capturedImages.count)"
        }
    }
}
