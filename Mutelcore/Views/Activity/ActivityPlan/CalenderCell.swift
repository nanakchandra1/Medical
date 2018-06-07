//
//  CalenderCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 16/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class CalenderCell: UITableViewCell {

//    MARK:- IBOUtlets
//    ================
    @IBOutlet weak var previousDateBtn: UIButton!
    @IBOutlet weak var nextDateBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var calenderBtn: UIButton!
    @IBOutlet weak var viewContainAllObjects: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CalenderCell {
    
    fileprivate func setupUI(){
        
        self.previousDateBtn.setImage(#imageLiteral(resourceName: "icActivityplanLeftarrow"), for: UIControlState.normal)
        self.nextDateBtn.setImage(#imageLiteral(resourceName: "icActivityplanRightarrow"), for: UIControlState.normal)
        self.calenderBtn.setImage(#imageLiteral(resourceName: "icAppointmentCalendar"), for: UIControlState.normal)
        
        self.sepratorView.backgroundColor = UIColor.sepratorColor
        
        self.dateLabel.font = AppFonts.sansProBold.withSize(12.5)
        self.dateLabel.textColor = #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        
    }
    
    func populateData(_ selectedDate : Date){
        
        let selectDate = selectedDate.stringFormDate(DateFormat.dMMMyyyy.rawValue)
        let currentDate = Date().stringFormDate(DateFormat.dMMMyyyy.rawValue)
        
        printlnDebug("\(selectedDate)")
        
        if selectDate == currentDate {
            
            self.dateLabel.text = "Today, \(String(describing: selectDate!))"
            
            self.nextDateBtn.isHidden = true
            
        }else {
            
            self.dateLabel.text = "\(String(describing: selectDate!))"
            self.nextDateBtn.isHidden = false
            
        }
    }
}

