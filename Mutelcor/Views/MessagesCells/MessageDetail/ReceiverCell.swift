//
//  ReceiverCell.swift
//  Mutelcor
//
//  Created by  on 14/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    @IBOutlet weak var triangleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
}

extension ReceiverCell {
    
    fileprivate func setupUI(){
        
        self.messageView.layer.cornerRadius = 5
        self.messageView.clipsToBounds = false
        self.contentView.backgroundColor = UIColor.clear
        self.messageView.shadow(1.0, .zero, UIColor.black, opacity: 0.5)
        self.messageView.backgroundColor = UIColor.messageBackgroundWithCount
        
        self.messageText.font = AppFonts.sansProRegular.withSize(14)
        self.messageTime.font = AppFonts.sansProRegular.withSize(11)
        
        self.triangleImage.image = self.traiangleImage()
    }
    
    func populateReceiverData(_ messages : [PatientLatestMessages], indexPath : IndexPath){
        
        guard !messages.isEmpty else{
            return
        }
        self.messageText.text = messages[indexPath.row].message
        if let messageTime = messages[indexPath.row].messageTimeInUtc {
           self.messageTime.text = messageTime.changeDateFormat(.utcTime,.Hmma)
        }
    }
    
    fileprivate func traiangleImage() -> UIImage {
        
        let arrowWidth = self.triangleImage.frame.width
        let arrowHeight = self.triangleImage.frame.height
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: arrowWidth, height: arrowHeight), false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        UIColor.clear.setFill()
        context?.fill(CGRect(x: 0, y: 0, width: arrowWidth, height: arrowHeight))
        
        let arrowPath = CGMutablePath()
        
        arrowPath.move(to: CGPoint(x: 0, y: 0))
        
        arrowPath.addLine(to: CGPoint(x: arrowWidth, y: arrowHeight / 2))
        arrowPath.addLine(to: CGPoint(x: 0, y: arrowHeight))
        arrowPath.closeSubpath()
        
        context?.addPath(arrowPath)
        context?.setShadow(offset: .zero, blur: 1, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor)
        
        context?.setFillColor(UIColor.messageBackgroundWithCount.cgColor)
        context?.drawPath(using: CGPathDrawingMode.fill)
        
        let arrowImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return arrowImage!
    }
}
