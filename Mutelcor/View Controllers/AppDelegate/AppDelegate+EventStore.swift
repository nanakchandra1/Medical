//
//  AppDelegate+EventStore.swift
//  Mutelcor
//
//  Created by on 22/09/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit
import EventKit

extension AppDelegate {
    
    func setEventCalender(){
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String
        let eventCalenders = self.eventStore.calendars(for: .event)
        let calendarIdentifier = AppUserDefaults.value(forKey: .calenderEventStoreID, fallBackValue: "")
        var isCalendarCalender: Bool = false
        for eventCalender in eventCalenders {
            if calendarIdentifier.isEmpty && eventCalender.title == appName ?? "MutelCor" {
                do {
                    try self.eventStore.removeCalendar(eventCalender, commit: true)
                }catch{
                    //printlnDebug(error.localizedDescription)
                    showToastMessage(error.localizedDescription)
                }
            }else if eventCalender.calendarIdentifier == calendarIdentifier.string {
                self.eventStoreCalendar = eventCalender
                isCalendarCalender = true
                break
            }
        }
        
        if self.eventStoreCalendar == nil && !isCalendarCalender {
            let calendar = EKCalendar(for: .event, eventStore: self.eventStore)
            calendar.cgColor = UIColor.appColor.cgColor
            calendar.title = appName ?? "Mutelcor"
            let filteredSource = self.eventStore.sources.filter({ source in
                return source.sourceType == EKSourceType.calDAV && source.title == "iCloud"
            })
            
            let calendarSource = filteredSource.first ?? eventStore.defaultCalendarForNewEvents?.source
            calendar.source = calendarSource
            AppUserDefaults.save(value: calendar.source.sourceIdentifier, forKey: .calenderEventStoreSourceID)
            
            var isCalendarSaved: Bool?
            do {
                try eventStore.saveCalendar(calendar, commit: true)
                isCalendarSaved = true
            } catch let error {
                isCalendarSaved = false
                //printlnDebug(error.localizedDescription)
                showToastMessage(error.localizedDescription)
            }
            
            if isCalendarSaved! {
                AppUserDefaults.save(value: calendar.calendarIdentifier, forKey: .calenderEventStoreID)
                eventStoreCalendar = calendar
            }
        }
    }
}
