//
//  LastAppointmentDateCell.swift
//  Mutelcor
//
//  Created by on 13/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class LastAppointmentDateCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var verticalView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.sepratorView.isHidden = true
        self.sepratorView.backgroundColor = UIColor.sepratorColor
        self.cellTitle.font = AppFonts.sanProSemiBold.withSize(16)
        self.verticalView.backgroundColor = UIColor.appColor
    }
    
    func populateDashboardData(_ dashboardData: [DashboardDataModel], _ indexPath: IndexPath){

        self.verticalView.isHidden = true
        guard !dashboardData.isEmpty else{
            return
        }
        guard let data = dashboardData.first else{
            return
        }
        
        switch indexPath.section {
        case 2:
            guard !data.latestAppointment.isEmpty else{
                self.cellTitle.text = "No Last Appointment"
                return
            }
            
            let date = data.latestAppointment[0].date?.changeDateFormat(.utcTime, .dMMMyyyy) ?? ""
            let time = data.latestAppointment[0].startTime ?? ""
            var timeArr = time.split(separator: ":", maxSplits: 2, omittingEmptySubsequences: true)
            let _ = timeArr.removeLast()
            let timeStr = timeArr.joined(separator: ":")
            
            if !date.isEmpty {
                let appointmentString = "Upcoming Appointment on  "
                let appointmentDate = "\(date) \(timeStr)"
                self.cellTitle.attributedText = self.attributedData(appointmentString,appointmentDate)
            }else{
                self.cellTitle.text = "No Upcoming Appointment"
            }
            
        case 5:
            guard !data.reviewDate.isEmpty else{
                self.cellTitle.text = "No Reviewed Date"
                return
            }
            let reviewedString = "Last Reviewed on  "
            let reviewedDate = data.reviewDate[0].reviewDate?.changeDateFormat(.utcTime, .ddMMMYYYY) ?? ""
            
            if !reviewedDate.isEmpty {
                self.cellTitle.attributedText = self.attributedData(reviewedString,reviewedDate)
            }else{
                self.cellTitle.text = "No Reviewed Date"
            }
        default:
            return
        }
    }
    
    fileprivate func attributedData(_ staticString: String,_ date: String) -> NSMutableAttributedString{
        let staticAttributedString = NSMutableAttributedString(string: staticString, attributes: [NSAttributedStringKey.font: AppFonts.sansProRegular.withSize(15),
                                                                                                  NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        let dateString = NSAttributedString(string: date, attributes: [NSAttributedStringKey.font: AppFonts.sanProSemiBold.withSize(15),
                                                                       NSAttributedStringKey.foregroundColor: UIColor.black])
        staticAttributedString.append(dateString)
        return staticAttributedString
    }
    
    func populateCalenderData(filteredReminder : [Reminder], filteredAppointment: [LatestAppointment],filteredSchedule: [NextSchedule],_ indexPath: IndexPath){
        self.cellTitle.numberOfLines = 0
        self.sepratorView.isHidden = false
        
        switch indexPath.section{
        case 0:
            if !filteredReminder.isEmpty {
            let eventName = filteredReminder[indexPath.row].eventName
            let date = filteredReminder[indexPath.row].startDate ?? Date()
            let increasedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
            let dateInString = increasedDate?.stringFormDate(.ddMMMYYYY) ?? ""
            let time = filteredReminder[indexPath.row].reminderTimeOnce?.stringFormDate(.Hmm) ?? ""
            let description = filteredReminder[indexPath.row].description
            let descriptionText = description.isEmpty ? "" : "\(description)\n"
//            let eventType = filteredReminder[indexPath.row].eventType
            
            let name = eventName.isEmpty ? "New Reminder" : eventName
            self.cellTitle.text = "\(name)\n\(descriptionText)\(dateInString) \(time)"
            }
            
        case 1:
            if !filteredSchedule.isEmpty {
            let scheduleName = filteredSchedule[indexPath.row].testName ?? ""
            let date = filteredSchedule[indexPath.row].time?.getDateFromString(.utcTime, .utcTime) ?? Date()
            let increasedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
            let dateInString = increasedDate?.stringFormDate(.ddMMMYYYY) ?? ""
            let time = filteredSchedule[indexPath.row].time?.changeDateFormat(.utcTime, .Hmm) ?? ""//reminderTimeOnce?.stringFormDate(.Hmm) ?? ""
            let description = filteredSchedule[indexPath.row].description ?? ""
            let descriptionText = description.isEmpty ? "" : "\(description)\n"
            
            let name = scheduleName.isEmpty ? "New Test" : scheduleName
            self.cellTitle.text = "\(name)\n\(descriptionText) \(dateInString) \(time)"
            }
        default:
            if !filteredAppointment.isEmpty {
            let appointmentName = "Your have an Upcoming Appointment"
            let date = filteredAppointment[indexPath.row].date?.getDateFromString(.utcTime, .utcTime) ?? Date()
            let increasedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
            let dateInString = increasedDate?.stringFormDate(.ddMMMYYYY) ?? ""
            let time = filteredAppointment[indexPath.row].date?.changeDateFormat(.utcTime, .Hmm) ?? ""//reminderTimeOnce?.stringFormDate(.Hmm) ?? ""
            let description = filteredAppointment[indexPath.row].appointmentDescription ?? ""
            let descriptionText = description.isEmpty ? "" : "\(description)\n"
            
            self.cellTitle.text = "\(appointmentName)\n\(descriptionText) \(dateInString) \(time)"
            }
        }
    }
}
