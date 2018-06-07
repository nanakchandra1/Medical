//
//  DatePicker.swift
//  Mutelcore
//
//  Created by Ashish on 27/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit

class DatePicker : UIDatePicker {
    
    internal typealias PickerDone = (_ date : Date) -> Void
    private var doneBlock : PickerDone!
    
    class func openPicker(in textField: UITextField, currentDate: Date?, minimumDate: Date?, maximumDate: Date?, pickerMode: UIDatePickerMode, doneBlock: @escaping PickerDone) {
        
        let picker = DatePicker()
        picker.doneBlock = doneBlock
        picker.openPickerInTextField(textField: textField, currentDate: currentDate, minimumDate: minimumDate, maximumDate: maximumDate, pickerMode: pickerMode)
        
    }
    
    private func openPickerInTextField(textField: UITextField, currentDate: Date?, minimumDate: Date?, maximumDate: Date?, pickerMode: UIDatePickerMode) {
        
        self.datePickerMode = pickerMode
        
        
        self.maximumDate = maximumDate //?? NSDate() //NSDate(timeIntervalSinceNow: -1.577e+8)
        self.date = currentDate ?? Date()
        self.minimumDate = minimumDate //?? NSDate() //NSDate(timeIntervalSince1970: -1000000000)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(DatePicker.pickerDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action:nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(DatePicker.pickerCancelButtonTapped))
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [cancelButton,spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.backgroundColor = UIColor.lightText
        
        textField.inputView = self
        textField.inputAccessoryView = toolbar
        
    }
    
    @IBAction private func pickerDoneButtonTapped(){
        
        UIApplication.shared.keyWindow?.endEditing(true)
        self.doneBlock(self.date)
    }
    
    @IBAction private func pickerCancelButtonTapped(){
        
        UIApplication.shared.keyWindow?.endEditing(true)
        self.setDate(Calendar.current.date(byAdding: .year, value: 0, to: Date(), wrappingComponents: false)!, animated: false)
    }
}
