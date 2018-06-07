//
//  SymptomCell.swift
//  Mutelcor
//
//  Created by  on 27/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON

class SymptomCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellImage.image = #imageLiteral(resourceName: "icAppointmentDeselectedCheck")
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cellImage.image = #imageLiteral(resourceName: "icAppointmentDeselectedCheck")
    }
    
    func populateData(_ symptomVC : AppearSymptomVCFor, _ symptoms : [Symptoms], _ selectedSymptom : [Symptoms], _ timeSlots : [TimeSlotModel], _ indexPath : IndexPath, _ selectedTimeSlot : TimeSlotModel?, _ isSearchTapped: Bool, _ searchResult: [Symptoms], _ scheduleID : Int?) {
        
        if symptomVC == .symptoms {
            let symptoms = isSearchTapped ? searchResult : symptoms
            self.cellLabel.text = symptoms[indexPath.row].symptomName
            
            let symptom = selectedSymptom.contains(where: { (symptom) -> Bool in
                return symptom.id == symptoms[indexPath.row].id
            })
            
            let image = symptom ? #imageLiteral(resourceName: "icAppointmentSelectedcheck") : #imageLiteral(resourceName: "icAppointmentDeselectedCheck")
            self.cellImage.image = image
        }else{
            guard !timeSlots.isEmpty else{
                return
            }
            let startTime = timeSlots[indexPath.row].startTime
            let endTime = timeSlots[indexPath.row].slotEndTime
            self.cellLabel.text = "\(startTime ?? "")-\(endTime ?? "")"
            
            if let timeSlot = selectedTimeSlot {
                let image = timeSlots[indexPath.row].scheduleID == timeSlot.scheduleID ? #imageLiteral(resourceName: "icAppointmentSelectedcheck") : #imageLiteral(resourceName: "icAppointmentDeselectedradio")
                self.cellImage.image = image
            }else if let id = scheduleID {
                let image = timeSlots[indexPath.row].scheduleID == id ? #imageLiteral(resourceName: "icAppointmentSelectedcheck") : #imageLiteral(resourceName: "icAppointmentDeselectedradio")
                self.cellImage.image = image
            }else{
                self.cellImage.image = #imageLiteral(resourceName: "icAppointmentDeselectedCheck")
            }
        }
    }
}
