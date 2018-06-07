//
//  DateVC.swift
//  TNIGHT Venue App_Ashish
//
//  Created by Appinventiv on 17/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit


protocol SelectedDate {
    
    func donebtnActn(_ date : Date)
    
}

class DateVC: UIViewController {
    //    MARK:- Proporties
    //    ==================
    var minDate : Date?
    var maxDate : Date?
    var startDate : Date?
    
    var delegate : SelectedDate!
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewContainDatePicker: UIView!
    @IBOutlet weak var datePickerContainerViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.33, delay: 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.transitionCurlUp, animations: {
            
            self.datePickerContainerViewBottomConstraint.constant = 0.0
            
            self.view.layoutIfNeeded()
            
        }) { (true) in
            
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    MARK:- IBActions
    //    =================
    @IBAction func cancelBtnActn(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    @IBAction func doneBtnActn(_ sender: UIButton) {
        
        if let date = self.startDate{
            
            self.delegate.donebtnActn(date)
        }
        
        self.view.removeFromSuperview()
    }
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        
        self.startDate = sender.date
        
    }
    
    fileprivate func setupUI(){
        
        self.cancelBtnOutlet.setTitle("Cancel", for: UIControlState.normal)
        self.cancelBtnOutlet.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        self.doneBtnOutlet.setTitle("Done", for: UIControlState.normal)
        self.doneBtnOutlet.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        self.datePickerContainerViewBottomConstraint.constant = -500
        
        self.view.layoutIfNeeded()
        
        self.datePicker.datePickerMode = .date
        
        if let minDate = self.minDate {
            
            datePicker.minimumDate = minDate
        }
        
        if let maxDate = self.maxDate{
            
            datePicker.maximumDate = maxDate
        }
    }
}
