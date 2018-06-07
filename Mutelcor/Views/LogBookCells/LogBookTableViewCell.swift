//
//  LogBookTableViewCell.swift
//  Mutelcor
//
//  Created by on 03/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol MonthDataDelegate : class{
    func monthData(_ selectedMonth : Int,_ selectedYear : String,_ isHeaderSelected : Bool)
}
protocol UpdateTableViewDelegate : class{
    func updateOuterTableView()
}

class LogBookTableViewCell: UITableViewCell {
    
    //    MARK:- Proporties
    //    =================
    var monthArray = [YearlyMonthCountTuple]()
    var monthData = [LogBookModel]()
    fileprivate var selectedSection : Int?
    fileprivate var isHeaderSelected = false
    weak var delegate : MonthDataDelegate?
    weak var updateTableViewDeleagte : UpdateTableViewDelegate?
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var logBookCellTableView: AutoResizingTableView!
    @IBOutlet weak var logBookTableHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
}

//MARK:- Methods
//==============
extension LogBookTableViewCell {
    
    fileprivate func setupUI(){
        
        self.logBookCellTableView.dataSource = self
        self.logBookCellTableView.delegate = self
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let logBookCellNib = UINib(nibName: "LogBookCell", bundle: nil)
        self.logBookCellTableView.register(logBookCellNib, forCellReuseIdentifier: "logBookCellID")
        
        let logBookHeaderCellNib = UINib(nibName: "LogBookHeaderCell", bundle: nil)
        self.logBookCellTableView.register(logBookHeaderCellNib, forHeaderFooterViewReuseIdentifier: "logBookHeaderCellID")
    }
    
    @objc fileprivate func headerBtnTapped(_ sender : IndexedButton){
        
        if self.selectedSection == sender.outerIndex {
            self.isHeaderSelected = !self.isHeaderSelected
        }else{
            self.selectedSection = sender.outerIndex
            self.isHeaderSelected = true
        }
        self.delegate?.monthData(self.monthArray[sender.outerIndex!].monthNumber, self.monthArray[sender.outerIndex!].year, self.isHeaderSelected)
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension LogBookTableViewCell : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.monthArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = (self.selectedSection == section) ? self.monthData.count : 0
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "logBookCellID", for: indexPath) as? LogBookCell else{
            fatalError("Log Book Cell not Found!")
        }
        
        cell.populateData(self.monthData, indexPath)
        self.updateTableViewDeleagte?.updateOuterTableView()
        return cell
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension LogBookTableViewCell : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if self.selectedSection == indexPath.section {
            let headerSelected : CGFloat = (self.isHeaderSelected) ? 64 : CGFloat.leastNormalMagnitude
            return headerSelected
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "logBookHeaderCellID") as? LogBookHeaderCell else{
            fatalError("Header Cell No Found!")
        }
        
        headerCell.contentView.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
        headerCell.headerBtnOutlt.outerIndex = section
        headerCell.headerBtnOutlt.addTarget(self, action: #selector(self.headerBtnTapped(_:)), for: .touchUpInside)
        
        if self.isHeaderSelected {
            let image = (self.selectedSection == section) ? #imageLiteral(resourceName: "icLogbookUparrowGreen") : #imageLiteral(resourceName: "icLogbookBlackdownarrow")
            let labelColor = (self.selectedSection == section) ? UIColor.appColor : UIColor.black
            
            headerCell.headerImage.image = image
            headerCell.headerLabel.textColor = labelColor
        }else{
            headerCell.headerImage.image = #imageLiteral(resourceName: "icLogbookBlackdownarrow")
            headerCell.headerLabel.textColor = UIColor.black
        }
        
        headerCell.stackViewLeadingConstratintOutlt.constant = 30
        headerCell.populateMonthData(self.monthArray, section)
        
        return headerCell
    }
}

