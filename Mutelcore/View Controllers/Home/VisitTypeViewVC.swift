//
//  VisitTypeViewVC.swift
//  Mutelcore
//
//  Created by Ashish on 15/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

protocol visitTypeSceneRemoveFromSuperView {
    
    func visitTypeViewRemove(remove : Bool)
    
}

class VisitTypeViewVC: UIViewController {

//    MARK:- Proporties
//    =================
    var nextVisitDate  = ""
    var delegate : visitTypeSceneRemoveFromSuperView!
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var visitTypeView: UIView!
    @IBOutlet weak var nextVisitLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.arrowImage.image = self.arrowUiImage()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        self.delegate.visitTypeViewRemove(remove: true)
        
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}

extension VisitTypeViewVC {
    
    //    MARK: create Triangle using UIBeizer Path
    //    ==========================================
    func arrowUiImage() -> UIImage {
        
        let arrowWidth = self.arrowImage.frame.width
        let arrowHeight = self.arrowImage.frame.height
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: arrowWidth, height: arrowHeight), false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        UIColor.clear.setFill()
        context?.fill(CGRect(x: 0, y: 0, width: arrowWidth, height: arrowHeight))
        
        let arrowPath = CGMutablePath()
        
        arrowPath.move(to: CGPoint(x: 0, y: arrowHeight))
        
        arrowPath.addLine(to: CGPoint(x: arrowWidth / 2, y: 0))
        arrowPath.addLine(to: CGPoint(x: arrowWidth, y: arrowHeight))
        
        arrowPath.closeSubpath()
        
        context?.addPath(arrowPath)

        context?.setFillColor(UIColor(red: 235/255, green: 224/255, blue: 224/255, alpha: 1.0).cgColor)
        context?.drawPath(using: CGPathDrawingMode.fill)
        
        let arrowImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let  maskLayer = CALayer()
        maskLayer.contents = arrowImage
        //        maskLayer.contentsRect = CGRectMake(0, 0, self.imageView.bounds.width, self.imageView.bounds.height)
        
        
        return arrowImage!
        
    }
    
    func setupUI(){
        
        self.visitTypeView.layer.cornerRadius = 2.2
        self.visitTypeView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        
        
        let date = Date()
        let dateInStr = date.stringFormDate(DateFormat.ddMMMYYYY.rawValue)
        
        let toadyStr = "Today : "
        let nextVisitStr = "Next Visit : "
        var todayDate = ""
        
        if dateInStr != nil, !(dateInStr?.isEmpty)!{
            
            todayDate = dateInStr!
        }

        var nextDate = ""
        
        if !self.nextVisitDate.isEmpty{
            
            nextDate = self.nextVisitDate
            
        }
        
        let todayTextAttributes = [NSFontAttributeName : AppFonts.sansProRegular.withSize(13.5)]
        let dateTextAttributes = [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(13.5)]
        
        //Add Attributes
        let todayAttributedString = NSMutableAttributedString(string: toadyStr, attributes: todayTextAttributes)
        let todayDateAttributedString = NSAttributedString(string: todayDate, attributes: dateTextAttributes)
        todayAttributedString.append(todayDateAttributedString)
        
        let nextVisitAttributedString = NSMutableAttributedString(string: nextVisitStr, attributes: todayTextAttributes)
        let nextDateAttributedString = NSAttributedString(string: nextDate, attributes: dateTextAttributes)
        nextVisitAttributedString.append(nextDateAttributedString)
        
        self.nextVisitLabel.attributedText = nextVisitAttributedString
        self.todayDateLabel.attributedText = todayAttributedString
        self.todayDateLabel.textColor = UIColor.appColor
        
    }
}
