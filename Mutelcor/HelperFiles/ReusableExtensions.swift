
//
//  ReusableExtensions.swift
//  Mutelcor
//
//  Created by on 10/03/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import  UIKit

//MARK:- get table view cell
//==========================
extension UIView{
    
    var getTableViewHeaderFooterView: UITableViewHeaderFooterView?{
        var subView = self
        while !(subView is UITableViewHeaderFooterView){
            
            guard let view = subView.superview else { return nil}
            subView = view
        }
        return subView as? UITableViewHeaderFooterView
    }
    
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
    
    //get tableView
    var getTableView: UITableView? {
        var view = self.superview
        while (view != nil && view!.isKind(of: UITableView.self) == false) {
            view = view!.superview
        }
        return view as? UITableView
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
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
    
    //    Dash Line
    //    =========
    func dashLine(_ startPoint : CGPoint , _ endPoint : CGPoint, _ lineDashPattern : [NSNumber] = [7, 4], _ color : UIColor = UIColor.appColor){
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        line.path = linePath.cgPath
        line.strokeColor = color.cgColor
        line.lineWidth = 1
        line.lineDashPattern = lineDashPattern
        self.layer.addSublayer(line)
    }
    
    
    //MARK:Shadow
    //    ===========
    
    func shadow(_ radius : CGFloat = 0.2, _ shadowOffSet : CGSize = CGSize(width: 0.2, height: 2), _ color : UIColor = UIColor.navigationBarShadowColor, opacity: Float = 0.34){
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffSet
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
    }
    
    //    add Gradient
    func gradient(withX: CGFloat, withY: CGFloat, cornerRadius: Bool, _ cornerRadiusValue: CGFloat = 2.2) {
        if let layerArray = self.layer.sublayers {
            for layer in layerArray {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                    break
                }
            }
            self.addGradientLayer(x: withX, y: withY, cornerRadius: cornerRadius, cornerRadiusValue)
        }else{
            self.addGradientLayer(x: withX, y: withY, cornerRadius: cornerRadius, cornerRadiusValue)
        }
    }
    
    
    fileprivate func addGradientLayer(x: CGFloat, y: CGFloat, cornerRadius: Bool, _ cornerRadiusValue: CGFloat){

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        let color2 = UIColor.gradientColor1.cgColor
        let color3 = UIColor.gradientColor2.cgColor
        gradientLayer.colors = [color2, color3]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 7)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 7)
        
        if cornerRadius {
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

//MARK:- Int Extension
//====================
public extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat.pi * CGFloat(self) / 180.0
    }
}

//MARk:- UIColor Extension
//========================
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
    
    static var linkLabelColor : UIColor{
        
        return #colorLiteral(red: 0.1019607843, green: 0.4235294118, blue: 0.6745098039, alpha: 1)
    }
    
    static var sepratorColor : UIColor {
        
        return #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
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
        
    static var activityVCBackgroundColor : UIColor {
        
        return #colorLiteral(red: 0.9254121184, green: 0.9255419374, blue: 0.9253712296, alpha: 1)
    }
    
    static var dosBtnSepratorColor : UIColor {
        
        return #colorLiteral(red: 0.03529411765, green: 0.8980392157, blue: 0.6588235294, alpha: 1)
    }
    
    static var messageBackgroundWithCount : UIColor {
        
        return #colorLiteral(red: 0.8392156863, green: 1, blue: 0.9725490196, alpha: 1)
    }
    
    static var headerTitleColor : UIColor {
        
        return #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    }
    
    func brightened(by factor: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * factor, alpha: a)
    }
}

//MARK:- Date Extension
//=======================
extension Date {
    
    static let dateFormatter = DateFormatter()
    
    var yesterday : Date {
        
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    func stringFormDate(_ dateFormat : DateFormat) -> String {
        
        let dateFormatter = Date.dateFormatter
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        
        dateFormatter.dateFormat = dateFormat.rawValue
        let dateInString = dateFormatter.string(from: self)
        return dateInString
    }
    
    func changeDateFormat(_ getDateFormat : String, _ needDateFormat : String) -> Date? {
        
            Date.dateFormatter.dateFormat = getDateFormat
            let dateInString = Date.dateFormatter.string(from: self)
            //printlnDebug(dateInString)
            Date.dateFormatter.dateFormat = needDateFormat
            let date = Date.dateFormatter.date(from: dateInString)
        //printlnDebug(dateInString)
        return date
    }
    
    func dateComponent() -> DateComponents {
        let dateComponent = Calendar.current.dateComponents([ .year, .day, .month, .weekday, .hour, .minute, .second], from: self)
        return dateComponent
    }
    
    var elapsedTime: String {
        var component: Set<Calendar.Component> = [.year]
        var interval = Calendar.current.dateComponents(component, from: self, to: Date()).year ?? 0
        if interval > 0 {
            return interval == 1 ? "\(interval) " + K_YEAR_AGO.localized :
                "\(interval) " + K_YEARS_AGO.localized
        }
        component = [.month]
        interval = Calendar.current.dateComponents(component, from: self, to: Date()).month ?? 0
        if interval > 0 {
            return interval == 1 ? "\(interval) " + K_MONTH_AGO.localized :
                "\(interval) " + K_MONTHS_AGO.localized
        }
        component = [.day]
        interval = Calendar.current.dateComponents(component, from: self, to: Date()).day ?? 0
        if interval > 0 {
            return interval == 1 ? "\(interval) " + K_DAY_AGO.localized :
                "\(interval) " + K_DAYS_AGO.localized
        }
        component = [.hour]
        interval = Calendar.current.dateComponents(component, from: self, to: Date()).hour ?? 0
        if interval > 0 {
            return interval == 1 ? "\(interval) " + K_HOUR_AGO.localized :
                "\(interval) " + K_HOURS_AGO.localized
        }
        component = [.minute]
        interval = Calendar.current.dateComponents(component, from: self, to: Date()).minute ?? 0
        if interval > 0 {
            return interval == 1 ? "\(interval) " + K_MINUTE_AGO.localized :
                "\(interval) " + K_MINUTES_AGO.localized
        }
        return K_JUST_NOW.localized
    }
}

//MARK:- Convert String Into Date
//===============================
extension String {

    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    func changeDateFormat(_ getDateFormat : DateFormat,_ needDateFormat : DateFormat) -> String{
        
        if !self.isEmpty{
            if self == "0000-00-00"{
                return self
            }else{
                
                Date.dateFormatter.dateFormat = getDateFormat.rawValue
                let date = Date.dateFormatter.date(from: self)
                
                guard let dateValue = date else{
                    return ""
                }
                Date.dateFormatter.dateFormat = needDateFormat.rawValue
                let dateInString = Date.dateFormatter.string(from: dateValue)
                return dateInString
            }
        }else{
            return ""
        }
    }
    
    func getDateFromString(_ getDateFormat : DateFormat, _ needDateFormat : DateFormat) -> Date? {
        
        let dateFormatter = Date.dateFormatter
        dateFormatter.locale = Locale.current
//        dateFormatter.timeZone = TimeZone.current
        
        if self == "0000-00-00" {
            dateFormatter.dateFormat = needDateFormat.rawValue
            return dateFormatter.date(from: self)
        }
        
        if !self.isEmpty {
            dateFormatter.dateFormat = getDateFormat.rawValue
            if let date = dateFormatter.date(from: self){
               dateFormatter.dateFormat = needDateFormat.rawValue
                let _ = dateFormatter.string(from: date)
                return date
            }
        }
        return nil
    }
    
    public func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        
        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = .byWordWrapping
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: mutableParagraphStyle], context: nil)
        
        return boundingBox.width
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        
        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = .byWordWrapping
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: mutableParagraphStyle], context: nil)
        
        return boundingBox.height
    }

    func stringHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()

        return label.frame.height
        /*
         let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
         let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

         return boundingBox.height*/
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

//MARK :- Add badges to UIBarButton
//=================================
extension UIBarButtonItem {
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red) {
        guard let view = self.value(forKey: "view") as? UIView else {
            return
        }
        let label = CATextLayer()
        if number != 0 {
            let badgeWidth = 25
            // Initialiaze Badge's label
            label.name = "MessageViewLayer"
            let count = number > 99 ? "99+" : "\(number)"
            label.string = count
            label.alignmentMode = kCAAlignmentCenter
            label.contentsGravity = kCAGravityBottom
            label.font = AppFonts.sansProBold.withSize(6)
            label.fontSize = 12
            label.borderColor = UIColor.appColor.cgColor
            
            label.frame = CGRect(origin: CGPoint(x: view.frame.width / 2 + offset.x, y: offset.y), size: CGSize(width: badgeWidth, height: 18))
            //        label.frame = CGRect(origin: CGPoint(x: view.frame.width / 2 + offset.x, y: offset.y), size: CGSize(width: badgeWidth, height: 15))
            label.foregroundColor = UIColor.red.cgColor
            label.cornerRadius = 2.5
            label.borderWidth = 1.0
            label.borderColor = UIColor.appColor.cgColor
            label.backgroundColor = UIColor.white.cgColor
            label.contentsScale = UIScreen.main.scale
            view.layer.addSublayer(label)
        }else{
            if let subLayers = view.layer.sublayers {
                for layer in subLayers {
                    if layer.name == "MessageViewLayer" {
                        layer.removeFromSuperlayer()
                    }
                }
            }
        }
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
    
    func imageLayerForGradientBackground() -> UIImage? {
        
        var updatedFrame = self.navigationBar.bounds
        // take into account the status bar
        updatedFrame.size.height += 20
        
        let layer = CAGradientLayer.gradientLayerForBounds(bounds: updatedFrame)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let backgroundImage = image{
            return backgroundImage
        }
        return nil
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

//MARK:- UITextView Extension
//===========================
extension UITextView {
    
    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(
                forGlyphAt: index, effectiveRange: &lineRange
            )
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
    
    public func scrollToBottom() {
        let range = NSMakeRange((text as NSString).length - 1, 1)
        scrollRangeToVisible(range)
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
    
    mutating func convertToDic(_ key : String) -> [String : Any]{
        
        var dic = [String : Any]()
        for (i, value) in self.enumerated(){
            dic["\(key)\(i + 1)"] = value
        }
        return dic
    }
}

//MARK:- Date Extension
//=====================
extension Date {
    
    func timeInterval(calendarComponent: Calendar.Component, endDate: Date) -> Int{
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: calendarComponent, in: .era, for: self) else {
            return 0
        }
        
        guard let end = currentCalendar.ordinality(of: calendarComponent, in: .era, for: endDate) else {
            return 0
        }
        return end - start
    }
    
    
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

//MARK:- Remove 0 after decimal
//============================
extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//MARK:- UITableView Extension
//============================
extension UITableView {
    public func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    public func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
}

extension UIImageView {
    
    public func changeImageColor(color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
//MARK:- Scale Image
//==================
extension UIImage {
    
   public func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            let scaleFactor = size.height / size.width
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            let scaleFactor = size.width / size.height
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
    
    
}

public extension Sequence where Iterator.Element: Hashable {
    var uniqueElements: [Iterator.Element] {
        return Array( Set(self) )
    }
}
public extension Sequence where Iterator.Element: Equatable {
    var uniqueElements: [Iterator.Element] {
        return self.reduce([]){
            uniqueElements, element in
            
            uniqueElements.contains(element)
                ? uniqueElements
                : uniqueElements + [element]
        }
    }
}


extension Notification.Name {
    static let changePassNotification = Notification.Name("changePassNotification")
}
