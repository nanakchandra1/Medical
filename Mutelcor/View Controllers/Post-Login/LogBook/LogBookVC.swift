 //
 //  LogBookVC.swift
 //  Mutelcor
 //
 //  Created by on 08/06/17.
 //  Copyright © 2017. All rights reserved.
 //
 
 import UIKit
 
 typealias YearlyMonthCountTuple = (month : String, monthNumber : Int ,monthDataCount : Int, year : String)
 
 enum FilteredLog : Int {
    case all
    case appointment = 1
    case measurement = 2
    case activity = 3
    case nutrition = 4
 }
 
 class LogBookVC: BaseViewController {
    
    //    MARK:- Proporties
    //    =================
    fileprivate var yearlyData = [YearlyMonthCountTuple]()
    fileprivate var logBookList = [K_ALL_BUTTON_TITLE_PLACEHOLDER.localized,K_APPOINTMENT_LISTING_SCREN_TITLE.localized, K_MEASUREMENT_SCREEN_TITLE.localized, K_ACTIVITY_SCREEN_TITLE.localized, K_NUTRITION_SCREEN_TITLE.localized]
    
    fileprivate var logBookArray = [LogBookModel]()
    fileprivate var yearlyLogBookData = [YearlyLogBookModel]()
    fileprivate var logBookFormattedDic = [String: [YearlyMonthCountTuple]]()
    
    fileprivate var logBookYearDic = [String : Any]()
    fileprivate var outerTableViewheight = false
    fileprivate var innerTableViewHeight = false
    fileprivate var yearArray = [String]()
    fileprivate var selectedSection : Int?
    fileprivate var isOuterTableViewReload = false
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var viewContainTextField: UIView!
    @IBOutlet weak var sepratorViewBelowTextField: UIView!
    @IBOutlet weak var dropDownTextField: UITextField!
    @IBOutlet weak var logBookTableView: UITableView!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    //    MARK:-ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.floatBtn.isHidden = false
        self.setupUI()
        self.getYearlyLogBookData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_LOG_BOOK_TITLE.localized)
    }
 }
 
 //MARK:- UITableViewDataSource Methods
 //=====================================
 extension LogBookVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.logBookFormattedDic.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if self.selectedSection == section, self.selectedSection != nil {
            let rows = (self.outerTableViewheight) ? 1 : 0
            return rows
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "logBookTableViewCellID", for: indexPath) as? LogBookTableViewCell else {
            fatalError("Log Book Cell not Found!")
        }
        
        cell.delegate = self
        cell.updateTableViewDeleagte = self
        if !self.yearArray.isEmpty {
            if self.selectedSection == indexPath.section, self.selectedSection != nil{
                cell.monthArray = self.logBookFormattedDic[self.yearArray[indexPath.section]]!
                cell.monthData = self.logBookArray
                cell.logBookTableHeightConstraint.constant = CGFloat((36 * cell.monthArray.count) + (64 * cell.monthData.count))
                
                cell.logBookCellTableView.reloadData()
            }
        }
        return cell
    }
 }
 
 //MARK:- UITableViewDelegate Methods
 //==================================
 extension LogBookVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "logBookHeaderCellID") as? LogBookHeaderCell else{
            fatalError("Header Cell No Found!")
        }
        
        headerCell.contentView.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
        
        headerCell.headerBtnOutlt.addTarget(self, action: #selector(self.headerBtnTapped(_:)), for: .touchUpInside)
        headerCell.headerBtnOutlt.outerIndex = section
        headerCell.populateYears(section, self.logBookFormattedDic, self.yearArray)
        headerCell.headerImage.image = #imageLiteral(resourceName: "icLogbookBlackdownarrow")
        if self.outerTableViewheight {
            UIView.animate(withDuration: 0.3, animations: {
                let labelColor = (self.selectedSection == section) ? UIColor.appColor : UIColor.black
                headerCell.headerImage.changeImageColor(color: labelColor)
                let angle = (self.selectedSection == section) ? (180.0 * CGFloat(Double.pi)) / 180.0 : (180.0 * CGFloat(Double.pi)) * 180.0
                headerCell.headerImage.transform = CGAffineTransform(rotationAngle: angle)
                headerCell.headerLabel.textColor = labelColor
            })
//            let image = (self.selectedSection == section) ? #imageLiteral(resourceName: "icLogbookUparrowGreen") : #imageLiteral(resourceName: "icLogbookBlackdownarrow")
//            let labelColor = (self.selectedSection == section) ? UIColor.appColor : UIColor.black
//
//            headerCell.headerImage.image = image
//            headerCell.headerLabel.textColor = labelColor
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                 headerCell.headerImage.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) * 180.0)
                headerCell.headerImage.changeImageColor(color: UIColor.black)
            })
            
//            headerCell.headerImage.image = #imageLiteral(resourceName: "icLogbookBlackdownarrow")
            headerCell.headerLabel.textColor = UIColor.black
        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.selectedSection == indexPath.section, self.selectedSection != nil {
            
            let monthCount = self.logBookFormattedDic[self.yearArray[indexPath.section]]?.count
            let monthSectionHeight = 36 * monthCount!
            let monthDataCount = 64 * self.logBookArray.count
            
            let cellHeight = (self.innerTableViewHeight) ? CGFloat(monthSectionHeight + monthDataCount) : CGFloat(monthSectionHeight)
            
            return cellHeight
        }else{
            return CGFloat.leastNormalMagnitude
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
 }
 
 // MARK:- UITextFieldDelegate Methods
 // ==================================
 extension LogBookVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        MultiPicker.noOfComponent = 1
        MultiPicker.openPickerIn(self.dropDownTextField, firstComponentArray: self.logBookList, secondComponentArray: [], firstComponent: self.dropDownTextField.text, secondComponent: nil, titles: [""]) { (value, _, index, _) in
            
            self.dropDownTextField.text = value
            
            if index == 1{
                self.logBookYearDic["list_type"] = FilteredLog.appointment.rawValue
            }else if index == 2 {
                self.logBookYearDic["list_type"] = FilteredLog.measurement.rawValue
            }else if index == 3 {
                self.logBookYearDic["list_type"] = FilteredLog.activity.rawValue
            }else if index == 4 {
                self.logBookYearDic["list_type"] = FilteredLog.nutrition.rawValue
            }else{
                self.logBookYearDic["list_type"] = ""
            }
            self.getYearlyLogBookData()
        }
    }
 }
 
 //MARK:- Methods
 //==============
 extension LogBookVC {
    
    fileprivate func setupUI(){
        self.dropDownTextField.tintColor = UIColor.white
        self.dropDownTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icActivityplanGreendropdown"))
        self.dropDownTextField.rightViewMode = .always
        self.dropDownTextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.dropDownTextField.text = self.logBookList[0]
        self.sepratorViewBelowTextField.backgroundColor = UIColor.sepratorColor
        self.noDataAvailiableLabel.isHidden = true
        self.noDataAvailiableLabel.text = K_NO_LOGBOOK.localized
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        
        self.dropDownTextField.delegate = self
        self.logBookTableView.dataSource = self
        self.logBookTableView.delegate = self
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        let logBookHeaderCellNib = UINib(nibName: "LogBookHeaderCell", bundle: nil)
        self.logBookTableView.register(logBookHeaderCellNib, forHeaderFooterViewReuseIdentifier: "logBookHeaderCellID")
        
        let logBookTableViewCellNib = UINib(nibName: "LogBookTableViewCell", bundle: nil)
        self.logBookTableView.register(logBookTableViewCellNib, forCellReuseIdentifier: "logBookTableViewCellID")
    }
 }
 //MARK:- WebServices Methods
 //==========================
 extension LogBookVC {
    
    fileprivate func getYearlyLogBookData(){
        
        WebServices.getLogBookYearlyData(parameters: self.logBookYearDic,
                                         success: {[weak self] (_ yearlylogBookData : [YearlyLogBookModel]) in
                                            
                                            guard let logBookVC = self else{
                                                return
                                            }
                                            
                                            logBookVC.yearlyLogBookData = yearlylogBookData
                                            
                                            if !logBookVC.yearlyLogBookData.isEmpty{
                                                
                                                logBookVC.noDataAvailiableLabel.isHidden = true
                                                logBookVC.logBookFormattedDic = [:]
                                                
                                                var year : String?
                                                
                                                for yearData in logBookVC.yearlyLogBookData {
                                                    
                                                    if year == yearData.year1 {
                                                        logBookVC.yearlyData.append((month : yearData.month1!, monthNumber : yearData.month2!, monthDataCount : yearData.count1!, year : yearData.year1!))
                                                    }else{
                                                        year = yearData.year1
                                                        logBookVC.yearlyData = []
                                                        logBookVC.yearlyData.append((month : yearData.month1!, monthNumber : yearData.month2!, monthDataCount : yearData.count1!, year : yearData.year1!))
                                                    }
                                                    logBookVC.logBookFormattedDic[year!] = logBookVC.yearlyData
                                                }
                                                logBookVC.yearArray = Array(logBookVC.logBookFormattedDic.keys).sorted()
                                            }else{
                                                logBookVC.logBookFormattedDic = [:]
                                                logBookVC.noDataAvailiableLabel.isHidden = false
                                            }
                                            logBookVC.logBookTableView.reloadData()
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func getLogBookData(){
        WebServices.getlogBookData(parameters: self.logBookYearDic,
                                   success: { [weak self](_ logBookData : [LogBookModel]) in
                                    
                                    if let logBookVC = self{
                                        logBookVC.logBookArray = logBookData
                                        logBookVC.logBookTableView.reloadData()
                                    }
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    @objc fileprivate func headerBtnTapped(_ sender : IndexedButton){
        
        if self.selectedSection == sender.outerIndex {
            self.outerTableViewheight = !self.outerTableViewheight
        }else{
            self.selectedSection = sender.outerIndex
            self.outerTableViewheight = true
            self.logBookYearDic["list_year"] = self.yearArray[sender.outerIndex!]
        }
        self.logBookTableView.reloadData()
    }
 }
 
 // MARK:- delegate Methods
 // ========================
 extension LogBookVC : MonthDataDelegate, UpdateTableViewDelegate {
    func monthData(_ selectedMonth: Int, _ selectedYear : String, _ isHeaderSelected : Bool) {
        self.logBookYearDic["list_month"] = selectedMonth
        self.logBookYearDic["list_year"] = selectedYear
        self.innerTableViewHeight = isHeaderSelected
        
        if isHeaderSelected {
            self.getLogBookData()
        }else{
            self.logBookTableView.reloadData()
        }
    }
    
    func updateOuterTableView() {
        self.logBookTableView.beginUpdates()
        self.logBookTableView.endUpdates()
    }
 }

