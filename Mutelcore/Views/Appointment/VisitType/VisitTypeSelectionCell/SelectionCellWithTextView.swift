//
//  selectionCellWithTextView.swift
//  Mutelcore
//
//  Created by Ashish on 28/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class SelectionCellWithTextView: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var symptomTextView: UITextView!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.cellTitle.textColor = UIColor.appColor
        self.cellTitle.font = AppFonts.sanProSemiBold.withSize(16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.symptomTextView.text = ""
    }
}

extension SelectionCellWithTextView {
    
    func populateData(_ appointment : [UpcomingAppointmentModel], proceedThroughBtn : Bool){
        
        if proceedThroughBtn == false{
            
            self.symptomTextView.text = appointment[0].appointmentSymptoms
            
        }else{
            
           self.symptomTextView.text = ""
            
        }
    }
}
