//
//  LogBookHeaderCell.swift
//  Mutelcor
//
//  Created by on 03/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class LogBookHeaderCell: UITableViewHeaderFooterView {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerBtnOutlt: IndexedButton!
    @IBOutlet weak var stackViewLeadingConstratintOutlt: NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.headerBtnOutlt.removeTarget(nil, action: nil, for: .allEvents)
        self.headerLabel.text = ""
    }
}

extension LogBookHeaderCell {
    
    func populateYears(_ section : Int, _ logBookFormattedDic: [String: [YearlyMonthCountTuple]], _ yearArray: [String]){
        
        guard !logBookFormattedDic.isEmpty else{
            return
        }

        var cumulativeLogCount = 0
        if let yearDataArray = logBookFormattedDic[yearArray[section]] {
            for yearData in yearDataArray {
                cumulativeLogCount = yearData.monthDataCount
            }
        }

        self.headerLabel.text = "\(yearArray[section]) (\(cumulativeLogCount))"
    }
    
    func populateMonthData(_ monthData : [YearlyMonthCountTuple], _ section : Int){
        
        guard !monthData.isEmpty else{
            return
        }
        self.headerLabel.text = "\(monthData[section].month) (\(monthData[section].monthDataCount))"
    }
}
