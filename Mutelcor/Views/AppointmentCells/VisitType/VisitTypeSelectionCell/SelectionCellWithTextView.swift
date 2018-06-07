//
//  selectionCellWithTextView.swift
//  Mutelcor
//
//  Created by  on 28/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class SelectionCellWithTextView: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var symptomTextView: UITextView!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellTitle.textColor = UIColor.appColor
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        let borderColor = UIColor.headerColor
        self.symptomTextView.roundCorner(radius: 2.2, borderColor: borderColor, borderWidth: 1.0)
    }
}

extension SelectionCellWithTextView {
    
    func populateData(_ appointment : [UpcomingAppointmentModel], proceedThroughBtn : Bool){
        
        let text = (proceedThroughBtn) ? "" : appointment[0].appointmentSymptoms
        self.symptomTextView.text = text
    }
}
