//
//  AKMultiPicker.swift
//  Engage
//
//  Created by Anupam Katiyar on 28/10/15.
//  Copyright © 2015 Anupam Katiyar. All rights reserved.
//

import UIKit

class AKMultiPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    internal typealias PickerDone = (_ firstValue: String, _ secondValue: String) -> Void
    private var doneBlock : PickerDone!
    
    private var firstValueArray  = [String]()
    private var secondValueArray = [String]()
    static var noOfComponent = 2
    
    class func openPickerIn(_ textField: UITextField, firstComponentArray: [String], secondComponentArray: [String], firstComponent: String?, secondComponent: String?, titles: [String]?, doneBlock: @escaping PickerDone) {
        
        let picker = AKMultiPicker()
        picker.doneBlock = doneBlock
        picker.openPickerInTextField(textField, firstComponentArray: firstComponentArray, secondComponentArray: secondComponentArray, firstComponent: firstComponent, secondComponent: secondComponent)
        
        if titles != nil {
            let label = UILabel(frame: CGRect(x: screenWidth/4 - 10, y: 0, width: 100, height: 30))
            label.text = titles![0].uppercased()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            picker.addSubview(label)
            
            if AKMultiPicker.noOfComponent > 1 {
                let label = UILabel(frame: CGRect(x: screenWidth * 3/4 - 50, y: 0, width: 100, height: 30))
                label.text = titles![1].uppercased()
                label.font = UIFont.boldSystemFont(ofSize: 18)
                picker.addSubview(label)
            } else {
                label.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 30)
                label.textAlignment = NSTextAlignment.center
            }
        }
    }
    
    private func openPickerInTextField(_ textField: UITextField, firstComponentArray: [String], secondComponentArray: [String], firstComponent: String?, secondComponent: String?) {
        
        firstValueArray  = firstComponentArray
        secondValueArray = secondComponentArray
        
        self.delegate = self
        self.dataSource = self
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AKMultiPicker.pickerDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action:nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.backgroundColor = UIColor.lightText
        
        textField.inputView = self
        textField.inputAccessoryView = toolbar
        
        let index = self.firstValueArray.index(where: {$0 == firstComponent })
        self.selectRow(index ?? 0, inComponent: 0, animated: true)
        
        if AKMultiPicker.noOfComponent > 1 {
            let index1 = self.secondValueArray.index(where: {$0 == secondComponent })
            self.selectRow(index1 ?? 0, inComponent: 1, animated: true)
        }
    }
    
    @IBAction private func pickerDoneButtonTapped(){
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        let index1 = self.selectedRow(inComponent: 0)
        let firstValue = firstValueArray[index1]
        
        var secondValue: String!
        if AKMultiPicker.noOfComponent > 1 {
            let index2 = self.selectedRow(inComponent: 1)
            secondValue = secondValueArray[index2]
        }
        self.doneBlock(firstValue, secondValue ?? "")
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0 {
            return firstValueArray.count
        }
        return secondValueArray.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return AKMultiPicker.noOfComponent
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
            
        case 0:
            return firstValueArray[row]
        case 1:
            return secondValueArray[row]
        default:
            return ""
        }
    }
    
}
