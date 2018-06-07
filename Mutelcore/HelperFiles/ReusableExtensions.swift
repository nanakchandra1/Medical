
//
//  ReusableExtensions.swift
//  Mutelcore
//
//  Created by Appinventiv on 10/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import  UIKit

//MARK:- get table view cell
//==========================
extension UIView{
    
    
    //get table view cell
    //    ===================
    var getTableViewCell: UITableViewCell?{
        
        var subview = self
        
        while !(subview is UITableViewCell){
            guard let view = subview.superview else { return nil}
            subview = view
        }
        
        return subview as? UITableViewCell
        
    }
    //    get tableViewCell IndexPath
    //    ==========================
    public func tableViewIndexPathIn(_ tableView: UITableView) -> IndexPath? {
        
        if let cell = self.getTableViewCell {
            
            return tableView.indexPath(for: cell) as IndexPath?
            
        } else {
            
            return nil
        }
    }
    
    //get CollectionView cell
    //    ===================
    var getCollectionViewCell: UICollectionViewCell?{
        
        var subview = self
        
        while !(subview is UICollectionViewCell){
            guard let view = subview.superview else { return nil}
            subview = view
        }
        
        return subview as? UICollectionViewCell
        
    }
    //    get CollectionCell IndexPath
    //    ============================
    public func collectionViewIndexPathIn(_ collectionView: UICollectionView) -> IndexPath? {
        
        if let cell = self.getCollectionViewCell {
            
            return collectionView.indexPath(for: cell) as IndexPath?
            
        } else {
            
            return nil
        }
    }
    
    //    Rounded Corner
    //    ==============
    func roundCorner(radius:CGFloat, borderColor:UIColor, borderWidth: CGFloat){
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
    
    //    Dash Line
    //    =========
    func dashLine(_ startPoint : CGPoint , _ endPoint : CGPoint, _ lineDashPattern : [NSNumber] = [7, 4] ){
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.appColor.cgColor
        line.lineWidth = 1
        line.lineDashPattern = lineDashPattern
        self.layer.addSublayer(line)
    }
    
    //MARK:Shadow
    //    ===========
    func shadow(_ radius : CGFloat = 0.2, _ shadowOffSet : CGSize = CGSize(width: 0.2, height: 2), _ color : UIColor = UIColor.navigationBarShadowColor){
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffSet
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 0.34
        
    }
    
    //    add shadow to floatbtn
    func addShadowToFloatingBtn(_ radius : CGFloat = 19.3){
        
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0.3529411765, blue: 0.2549019608, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 1.2 , height: 1.2)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 0.47
        self.backgroundColor = UIColor.appColor
        
    }
    //    add Gradient to Button
    func gradient(withX : CGFloat , withY : CGFloat , cornerRadius : Bool, _ cornerRadiusValue : CGFloat = 2.2)
        
    {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.frame.origin = CGPoint(x: withX, y: withY)
        let color2 = UIColor.gradientColor1.cgColor
        let color3 = UIColor.gradientColor2.cgColor
        gradientLayer.colors = [color2, color3]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 7)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 7)
        
        if cornerRadius == true{
            
            let maskPath = UIBezierPath(roundedRect: gradientLayer.frame, cornerRadius: cornerRadiusValue)
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            gradientLayer.mask = shape
            
        }
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
}

//MARK:- Bool Extension
//=====================
extension Bool {
    
    var rawValue : Int {
        
        return self ? 1 : 0
    }
}

//MARk:- UIColor
//===============
extension UIColor {
    
    static var gradientColor1 : UIColor {
        
        return #colorLiteral(red: 0, green: 0.7450980392, blue: 0.5254901961, alpha: 1)
    }
    
    static var gradientColor2 : UIColor {
        
        return #colorLiteral(red: 0.07843137255, green: 0.7568627451, blue: 0.7333333333, alpha: 1)
    }
    
    static var appColor : UIColor {
        
        return #colorLiteral(red: 0.1176470588, green: 0.6862745098, blue: 0.6196078431, alpha: 1)
    }
    
    static var popUpBackgroundColor : UIColor {
        
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.80078125)
    }
    static var textColor : UIColor {
        
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    static var grayLabelColor : UIColor{
        
        return #colorLiteral(red: 0.5215686275, green: 0.5215686275, blue: 0.5215686275, alpha: 1)
    }
    
    static var sepratorColor : UIColor {
        
        return #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
    }
    
    static var headerColor : UIColor {
        
        return #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    }
    
    static var navigationBarShadowColor : UIColor {
        
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6450931079)
    }
    
    static var ePrescriptionBtnColor : UIColor {
        
        return #colorLiteral(red: 0.01568627451, green: 0.5294117647, blue: 0.8235294118, alpha: 1)
    }
    
    static var senderMessageBackgroundColor : UIColor {
        
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.35)
    }
    
    static var receiverMessageBackgroundColor : UIColor {
        
        return #colorLiteral(red: 0.8392156863, green: 1, blue: 0.9725490196, alpha: 0.35)
    }
    
    static var activityVCBackgroundColor : UIColor {
        
        return #colorLiteral(red: 0.9254121184, green: 0.9255419374, blue: 0.9253712296, alpha: 1)
    }
    
    static var dosBtnSepratorColor : UIColor {
        
        return #colorLiteral(red: 0.03529411765, green: 0.8980392157, blue: 0.6588235294, alpha: 1)
    }
}

//MARK:- Get Day of Week
//=======================
extension Date {
    
    static let dateFormatter = DateFormatter()
    
    func getDayOfWeek(_ format : String = "EEEE") -> String? {
        
        Date.dateFormatter.dateFormat = format
        
        return Date.dateFormatter.string(from: self).capitalized
    }
    
    var yesterday : Date {
        
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    func stringFormDate(_ dateFormat : String) -> String?{
        
        Date.dateFormatter.dateFormat = dateFormat
        let dateInString = Date.dateFormatter.string(from: self)
        
        return dateInString 
    }
    
    var stringFromTime : String? {
        
        get {
            
            Date.dateFormatter.dateFormat = DateFormat.HHmm.rawValue
            
            let timeInString = Date.dateFormatter.string(from: self)
            
            return timeInString
        }
    }
    
    func dateComponent() -> DateComponents{
        
        let dateComponent = Calendar.current.dateComponents([.day, .hour, .month, .year], from: self)
        
        return dateComponent
    }
}

//MARK:- Convert String Into Date
//===============================
extension String {
    
    func timeFromString(_ dateFormat : String) -> String?{
        
        if !self.isEmpty{
            
            Date.dateFormatter.dateFormat = "hh:mm:ss a"
            let date = Date.dateFormatter.date(from: self)
            Date.dateFormatter.dateFormat = dateFormat
            
            let timeInString = Date.dateFormatter.string(from: date!)
            
            return timeInString
        }else{
            
            return ""
        }
    }
    func timeFromStringInHours(_ dateFormat : String) -> String?{
        
        if !self.isEmpty{
            
            Date.dateFormatter.dateFormat = "HH:mm:ss"
            let date = Date.dateFormatter.date(from: self)
            Date.dateFormatter.dateFormat = dateFormat
            
            let timeInString = Date.dateFormatter.string(from: date!)
            
            return timeInString
        }else{
            
            return ""
        }
    }
    
    //    *************************
    func dateFString(_ getDateFormat : String,_ needDateFormat : String) -> String?{
        
        if !self.isEmpty{
            
            if self == "0000-00-00"{
                
                return self
            }else{
                
                Date.dateFormatter.dateFormat = getDateFormat
                let date = Date.dateFormatter.date(from: self)
                Date.dateFormatter.dateFormat = needDateFormat
                
                let dateInString = Date.dateFormatter.string(from: date!)
                
                return dateInString
                
            }
            
        }else{
            
            return ""
        }
    }
    
    func dateFrString(_ getDateFormat : String?, _ needDateFormat : String?) -> Date? {
        
        Date.dateFormatter.dateFormat = getDateFormat
        let date = Date.dateFormatter.date(from: self)
        Date.dateFormatter.dateFormat = needDateFormat
        let _ = Date.dateFormatter.string(from: date!)
        
        printlnDebug("\(date!)")
        return date!
    }
    
    var dateFromString : Date? {
        
        get {
            
            if self == "0000-00-00"{
                
                Date.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
                return Date.dateFormatter.date(from: self)
                
            }else if !self.isEmpty{
                
                Date.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date = Date.dateFormatter.date(from: self)
                Date.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
                let dateInStr = Date.dateFormatter.string(from: date!)
                
                printlnDebug(dateInStr)
                printlnDebug(date)
                
                return date
                
            }else{
                
                return nil
            }
        }
    }
    
    var timeInString : String? {
        
        get {
            
            if !self.isEmpty{
                
                Date.dateFormatter.dateFormat = "hh:mm:ss a"
                let date = Date.dateFormatter.date(from: self)
                Date.dateFormatter.dateFormat = "HH:mm a"
                printlnDebug(date)
                let dateInString = Date.dateFormatter.string(from: date!)
                
                printlnDebug(dateInString)
                
                return dateInString
            }else{
                
                return ""
            }
        }
    }
    
    public func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        
        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = .byWordWrapping
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName: mutableParagraphStyle], context: nil)
        
        return boundingBox.width
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        
        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = .byWordWrapping
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName: mutableParagraphStyle], context: nil)
        
        return boundingBox.height
    }
}

//MARK:- Merge To Dictionary
//==========================
extension Dictionary {
    mutating func append(other:Dictionary) {
        for (key,value) in other {
            self[key] = value
        }
    }
}

//MARK:- Convert Array to Dictionary
//=================================
extension Array {
    
    mutating func convertToDic(_ key : String) -> [String : Any]{
        
        var dic = [String : Any]()
        
        for (i, value) in self.enumerated(){
            
            dic["\(key)\(i + 1)"] = value
        }
        
        return dic
    }
}

//MARK :- Add badges to UIBarButton
//=================================
extension UIBarButtonItem {
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red) {
        
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        let badgeWidth = 21
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = kCAAlignmentCenter
        label.contentsGravity = kCAGravityBottom
        label.font = AppFonts.sfCompactDisplayBold.withSize(6)
        label.fontSize = 10.5
        label.borderColor = UIColor.appColor.cgColor
        
        label.frame = CGRect(origin: CGPoint(x: view.frame.width / 2 + offset.x, y: offset.y), size: CGSize(width: badgeWidth, height: 13))
        label.foregroundColor = UIColor.red.cgColor
        label.cornerRadius = 2.5
        label.borderWidth = 1.0
        
        label.borderColor = UIColor.appColor.cgColor
        label.backgroundColor = UIColor.white.cgColor
        label.contentsScale = UIScreen.main.scale
        
        view.layer.addSublayer(label)
    }
}

extension CAGradientLayer {
    
    class func gradientLayerForBounds(bounds: CGRect) -> CAGradientLayer {
        
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [UIColor.gradientColor1.cgColor, UIColor.gradientColor2.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        return layer
    }
}


//MARK:- Gradient on Navigation Bar
//=================================
extension UINavigationController {
    
    func imageLayerForGradientBackground() -> UIImage {
        
        var updatedFrame = self.navigationBar.bounds
        // take into account the status bar
        updatedFrame.size.height += 20
        
        let layer = CAGradientLayer.gradientLayerForBounds(bounds: updatedFrame)
        
        UIGraphicsBeginImageContext(layer.bounds.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}

//MARK:- Right view over textField
//================================
extension UITextField {
    
    func setRightViewText(_ text: String, target: Any?, selector: Selector?) {
        
        let textWidth = text.widthWithConstrainedHeight(height: frame.height, font: AppFonts.sansProRegular.withSize(17))
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: (textWidth + 10), height: frame.height))
        containerView.backgroundColor = .clear
        
        let label = UILabel(frame: .zero)
        label.backgroundColor = .clear
        label.text = text
        label.font = AppFonts.sansProRegular.withSize(17)
        label.sizeToFit()
        label.center = containerView.center
        
        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        containerView.addGestureRecognizer(tapGesture)
        
        containerView.addSubview(label)
        
        rightViewMode = .always
        rightView = containerView
    }
    
    func removeRightView() {
        rightViewMode = .never
        rightView = nil
    }
    
}

//MARK:- Array Extension
//======================
extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

//MARK:- Date Extension
//=====================
extension Date {
    
    var calendar: Calendar {
        return Calendar.current
    }
    
    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .day, value: newValue, of: self) {
                self = date
            }
        }
    }
    
    var startOfDay: Date {
        let localTimeInterval = TimeInterval(calendar.timeZone.secondsFromGMT())
        return calendar.startOfDay(for: self).addingTimeInterval(localTimeInterval)
    }
    
    var startOfMonth: Date {
        let localTimeInterval = TimeInterval(calendar.timeZone.secondsFromGMT())
        return calendar.date(from: calendar.dateComponents([.year, .month], from: self.startOfDay))!.addingTimeInterval(localTimeInterval)
    }
    
    var endOfMonth: Date {
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    func numberOfDays(from date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: self, to: date)
        return components.day!
    }
    
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: self)!
    }
    
    mutating func add(_ component: Calendar.Component, value: Int) {
        self = adding(component, value: value)
    }
}

//MARK:- UIApplication Extension
//==============================
extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
