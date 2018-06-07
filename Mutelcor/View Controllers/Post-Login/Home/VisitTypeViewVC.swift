//
//  VisitTypeViewVC.swift
//  Mutelcor
//
//  Created by  on 15/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol visitTypeSceneRemoveFromSuperView: class{
    func visitTypeViewRemove()
}

class VisitTypeViewVC: UIViewController {
    
    //    MARK:- Proporties
    //    =================
    var nextVisitDate  = ""
    weak var delegate: visitTypeSceneRemoveFromSuperView?
    var appointmentViewDisplayFor: AddBtnDisplayedFor = .none
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var visitTypeView: UIView!
    @IBOutlet weak var nextVisitLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var arrowImageTrailingConstraint: NSLayoutConstraint!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.arrowImage.image = self.arrowUiImage()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.visitTypeViewRemove()
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
        
        let arrowPath = CGMutablePath()
        arrowPath.move(to: CGPoint(x: 0, y: arrowHeight))
        arrowPath.addLine(to: CGPoint(x: arrowWidth / 2, y: 0))
        arrowPath.addLine(to: CGPoint(x: arrowWidth, y: arrowHeight))
        arrowPath.closeSubpath()
        
        let context = UIGraphicsGetCurrentContext()
        UIColor.clear.setFill()
        context?.fill(CGRect(x: 0, y: 0, width: arrowWidth, height: arrowHeight))
        context?.addPath(arrowPath)
        context?.setShadow(offset: .zero, blur: 4, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.34).cgColor)
        context?.setFillColor(UIColor(red: 235/255, green: 224/255, blue: 224/255, alpha: 1.0).cgColor)
        context?.drawPath(using: CGPathDrawingMode.fill)
        
        let arrowImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let  maskLayer = CALayer()
        maskLayer.contents = arrowImage
        return arrowImage!
    }
    
    func setupUI(){
        
        self.visitTypeView.layer.cornerRadius = 2.2
        self.visitTypeView.shadow(3, .zero, UIColor.black, opacity: 0.34)
        self.placeTheArrowImage()
        let date = Date()
        let dateInStr = date.stringFormDate(.ddMMMYYYY)
        let toadyStr = "Today : "
        let nextVisitStr = "Next Visit : "
        var todayDate = ""
        if !dateInStr.isEmpty {
            todayDate = dateInStr
        }
        
        let nextDate = AppUserDefaults.value(forKey: .nextVisitDate).stringValue
//        let fontSize: CGFloat = DeviceType.IS_IPHONE_5 ? 14 : 15
        let todayTextAttributes = [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(15)]
        let dateTextAttributes = [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(15)]
        
        //Add Attributes
        let todayAttributedString = NSMutableAttributedString(string: toadyStr, attributes: todayTextAttributes)
        let todayDateAttributedString = NSAttributedString(string: todayDate, attributes: dateTextAttributes)
        todayAttributedString.append(todayDateAttributedString)
        
        let nextVisitAttributedString = NSMutableAttributedString(string: nextVisitStr, attributes: todayTextAttributes)
        let nextDateAttributedString = NSAttributedString(string: nextDate, attributes: dateTextAttributes)
        nextVisitAttributedString.append(nextDateAttributedString)
        
        if !nextDate.isEmpty {
            self.nextVisitLabel.attributedText = nextVisitAttributedString
        }else{
            self.nextVisitLabel.text = ""
        }
        self.todayDateLabel.attributedText = todayAttributedString
        self.todayDateLabel.textColor = UIColor.appColor
    }
    
    func placeTheArrowImage(){
        switch self.appointmentViewDisplayFor {
        case .activity:
            self.arrowImageTrailingConstraint.constant = CGFloat(-130)
        case .nutrition:
            self.arrowImageTrailingConstraint.constant = CGFloat(-130)
        case .appointment:
            self.arrowImageTrailingConstraint.constant = CGFloat(-130)
        case .messageDetail:
            self.arrowImageTrailingConstraint.constant = CGFloat(-50)
        case .Timeline:
            self.arrowImageTrailingConstraint.constant = CGFloat(-50)
        case .none:
            self.arrowImageTrailingConstraint.constant = CGFloat(-98)
        }
    }
}
