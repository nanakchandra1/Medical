//
//  senderCellTableViewCell.swift
//  Mutelcore
//
//  Created by Ashish on 14/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {

//    MARK:- Outlets
//    ==============
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    @IBOutlet weak var triangleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        var layer = CAShapeLayer()
//       let path = UIBezierPath()
        
      self.setupUI()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//     let image = drawTriangle()
//        image.
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func drawTriangle() -> UIImage {
//
//        UIGraphicsBeginImageContextWithOptions(CGSize(width : 10, height : 10), false, UIScreen.main.scale)
//        let context = UIGraphicsGetCurrentContext()
//        context?.fill(CGRect(x: 0, y: 0, width: 10, height: 10))
//        let arrowpath = CGMutablePath()
//        arrowpath.move(to: CGPoint(x: 10, y: 10))
//        arrowpath.addLine(to: CGPoint(x: 10, y: 5))
//        arrowpath.addLine(to: CGPoint(x: 5, y: 10))
//        arrowpath.closeSubpath()
//        context?.addPath(arrowpath)
//        context?.setFillColor(UIColor.red.cgColor)
//        context?.drawPath(using: CGPathDrawingMode.fill)
//
//        let arrowImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return arrowImage!
//    }
}

//MARK:- Methods
extension SenderCell {
    
    fileprivate func setupUI(){
        
        self.messageView.layer.cornerRadius = 2.2
        self.messageView.clipsToBounds = false
        
        self.messageView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.messageView.backgroundColor = UIColor.senderMessageBackgroundColor
        
        self.messageText.font = AppFonts.sansProRegular.withSize(14)
        self.messageTime.font = AppFonts.sansProRegular.withSize(11)
        
    }
}
