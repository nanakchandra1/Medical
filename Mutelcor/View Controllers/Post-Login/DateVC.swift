//
//  DateVC.swift
//  
//
//  Created by on 17/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol SelectedDate: class {
    func donebtnActn(_ date : Date)
}

class DateVC: UIViewController {
    //    MARK:- Proporties
    //    ==================
    var minDate: Date?
    var maxDate: Date?
    var startDate: Date?
    weak var delegate: SelectedDate?
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewContainDatePicker: UIView!
    @IBOutlet weak var datePickerContainerViewBottomConstraint: NSLayoutConstraint!
    
//    MARK:- ViewController Life Cycle
//    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.datePickerContainerViewBottomConstraint.constant = -300
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.view.backgroundColor = UIColor.clear
            UIView.animate(withDuration: 0.33, delay: 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.transitionCurlUp, animations: {
                self.datePickerContainerViewBottomConstraint.constant = 0.0
                self.view.layoutIfNeeded()
            }) { (true) in
            }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        UIView.animate(withDuration: 0.3, animations: {
//            self.datePickerContainerViewBottomConstraint.constant = 0
//            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//            //self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.removeDateVC()
    }
    
    fileprivate func removeDateVC(){
        UIView.animate(withDuration: 0.3, animations: {
            self.datePickerContainerViewBottomConstraint.constant = -300
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            //self.view.layoutIfNeeded()
        }) { (true) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //    MARK:- IBActions
    //    =================
    @IBAction func cancelBtnActn(_ sender: UIButton) {
        self.removeDateVC()
    }
    @IBAction func doneBtnActn(_ sender: UIButton) {
           if let date = self.startDate{
            self.delegate?.donebtnActn(date)
        }
        self.removeDateVC()
    }
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        self.startDate = sender.date
    }
    
    fileprivate func setupUI(){
        
        self.toolBarView.backgroundColor = UIColor.appColor
        self.cancelBtnOutlet.setTitle(K_CANCEL_BUTTON.localized, for: UIControlState.normal)
        self.cancelBtnOutlet.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        self.doneBtnOutlet.setTitle(K_DONE_BUTTON.localized, for: UIControlState.normal)
        self.doneBtnOutlet.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        self.view.layoutIfNeeded()
        self.startDate = Date()
        self.datePicker.datePickerMode = .date
        if let minDate = self.minDate {
            datePicker.minimumDate = minDate
        }
        if let maxDate = self.maxDate{
            datePicker.maximumDate = maxDate
        }
    }
}
