//
//  WeekPerformanceVC.swift
//  Mutelcor
//
//  Created by on 23/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SpreadsheetView

class WeekPerformanceVC: BaseViewControllerWithBackButton {
    
    
    //    MARK:- Proporties
    //    =================
    
    fileprivate var weekPerformanceValues = [[WeekPerformance]]()
    fileprivate var totalValue : Double = 0.0
    
    
    //    MARK:- IBOutlets
    //    ================
    
    @IBOutlet weak var weekPerformanceSpreadSheetView: SpreadsheetView!
    @IBOutlet weak var bottomButtonContainView: UIView!
    @IBOutlet weak var myNutritionBtnOutlt: UIButton!
    @IBOutlet weak var nutritionPlanBtnOutlt: UIButton!
    @IBOutlet weak var weekPerformanceRowgradientView: UIView!
    @IBOutlet weak var viewBetweenButtons: UIView!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.weekPerformanceData()
        self.navigationControllerOn = .dashboard
        self.sideMenuBtnActn = .backBtn
        self.addBtnDisplayedFor = .none
        self.isNavigationBarButton = false
        self.weekPerformanceSpreadSheetView.gridStyle = GridStyle.none
        self.setNavigationBar(screenTitle: K_WEEK_PERFORMANCE_SCREEN_TITLE.localized)
        self.weekPerformanceSpreadSheetView.isScrollEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.weekPerformanceRowgradientView.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    //    MARK:- IBActions
    //    ================
    @IBAction func myNutritionBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nutritionPlanBtnTapped(_ sender: UIButton) {
        let nutritionPlanScene = NutritionPlanVC.instantiate(fromAppStoryboard: .Nutrition)
        self.navigationController?.pushViewController(nutritionPlanScene, animated: true)
    }
}

//MARK:- Methods
//==============
extension WeekPerformanceVC {
    
    fileprivate func setupUI(){
        
        self.floatBtn.isHidden = true
        self.view.backgroundColor = .white
        self.weekPerformanceSpreadSheetView.backgroundColor = UIColor.clear
        self.bottomButtonContainView.gradient(withX: 0, withY: 0, cornerRadius: false)
        self.myNutritionBtnOutlt.backgroundColor = UIColor.clear
        self.nutritionPlanBtnOutlt.backgroundColor = UIColor.clear
        self.myNutritionBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.myNutritionBtnOutlt.setTitle(K_MY_NUTRITION_TITLE.localized, for: .normal)
        self.myNutritionBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        self.nutritionPlanBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.nutritionPlanBtnOutlt.setTitle(K_NUTRITION_PLAN_TITLE.localized, for: .normal)
        self.nutritionPlanBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        self.weekPerformanceSpreadSheetView.dataSource = self
        self.weekPerformanceSpreadSheetView.circularScrolling = CircularScrolling.Configuration.none
        self.weekPerformanceSpreadSheetView.alwaysBounceHorizontal = false
        self.weekPerformanceSpreadSheetView.alwaysBounceVertical = false
        self.weekPerformanceSpreadSheetView.bounces = false
        self.weekPerformanceSpreadSheetView.showsHorizontalScrollIndicator = false
        self.weekPerformanceSpreadSheetView.showsVerticalScrollIndicator = false
        self.weekPerformanceSpreadSheetView.decelerationRate = 0.2
        self.viewBetweenButtons.backgroundColor = UIColor.appColor
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.isHidden = true
        self.noDataAvailiableLabel.text = "No Records Found!"
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.weekPerformanceSpreadSheetView.isHidden = true
        self.weekPerformanceRowgradientView.isHidden = true
        self.registerNibs()
        
    }
    
    fileprivate func registerNibs(){
        
        let weekPerformCellNib = UINib(nibName: "VitalTableCell", bundle: nil)
        self.weekPerformanceSpreadSheetView.register(weekPerformCellNib, forCellWithReuseIdentifier: "vitalTableCellID")
        
    }
}

//MARK:- CollectionViewDataSource Methods
//=======================================
extension WeekPerformanceVC : SpreadsheetViewDataSource{
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int{
        
        let spreadsheetColumns = (!self.weekPerformanceValues.isEmpty) ? (self.weekPerformanceValues[0].count + 2) : 1
        return spreadsheetColumns
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int{
        let spreadsheetRows = (!self.weekPerformanceValues.isEmpty) ? self.weekPerformanceValues.count + 1 : 1
        return spreadsheetRows
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        
        if !self.weekPerformanceValues.isEmpty{
            return (CGFloat(Int(UIDevice.getScreenWidth) / (self.weekPerformanceValues[0].count + 2)) - 0.1)
        }else{
            return UIDevice.getScreenWidth / 6
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 38.5
    }
    
    //     The cell that is returned must be retrieved from a call to `dequeueReusableCell(withReuseIdentifier:for:)`
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell?{
        
        guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
            
            fatalError("cell not found!")
        }
        
        switch (indexPath.column , indexPath.row){
            
        case (0,0):
            
            cell.timeLabelOult.isHidden = true
            cell.verticalSepratorView.isHidden = true
            cell.bottomSepratorView.isHidden = true
            cell.dateLabelOult.textColor = UIColor.white
            cell.dateLabelOult.isHidden = false
            cell.dateLabelOult.text = K_DAYS_TITLE.localized
            cell.dateLabelOult.font = AppFonts.sanProSemiBold.withSize(10.1)
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
        case (0, 0...self.weekPerformanceValues.count) :
            
            cell.contentView.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.white
            cell.dateLabelOult.textColor = UIColor.appColor
            cell.dateLabelOult.font = AppFonts.sansProBold.withSize(10.1)
            cell.timeLabelOult.isHidden = true
            
            if !self.weekPerformanceValues[indexPath.row-1].isEmpty {
                
                if let date = self.weekPerformanceValues[indexPath.row - 1][indexPath.column].mealDate {
                    let day = date.changeDateFormat(.utcTime, .eee)
                    cell.dateLabelOult.text = day.uppercased()
                }
            }
            
            cell.bottomSepratorView.isHidden = false
            cell.verticalSepratorView.isHidden = false
            
        case (0...self.weekPerformanceValues[0].count + 1,0) :
            
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            cell.dateLabelOult.textColor = UIColor.white
            cell.dateLabelOult.font = AppFonts.sansProBold.withSize(10.1)
            cell.timeLabelOult.isHidden = true
            cell.verticalSepratorView.isHidden = true
            cell.bottomSepratorView.isHidden = true
            
            if !weekPerformanceValues[indexPath.row].isEmpty {
                
                if indexPath.column <= self.weekPerformanceValues[indexPath.row].count{
                    cell.dateLabelOult.text = self.weekPerformanceValues[indexPath.row][indexPath.column - 1].mealDuration?.uppercased()
                }else{
                    cell.dateLabelOult.text = "Total"
                }
            }
            
        case (1...self.weekPerformanceValues[0].count+2, 1...self.weekPerformanceValues.count + 1) :
            
            cell.contentView.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.white
            cell.dateLabelOult.textColor = UIColor.black
            cell.timeLabelOult.isHidden = true
            cell.bottomSepratorView.isHidden = false
            cell.verticalSepratorView.isHidden = false
            
            if !self.weekPerformanceValues[indexPath.row - 1].isEmpty {
                
                if indexPath.column <= self.weekPerformanceValues[indexPath.row - 1].count,
                    let value = self.weekPerformanceValues[indexPath.row - 1][indexPath.column - 1].value{
                    cell.dateLabelOult.text = value.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero).cleanValue
                    self.totalValue = self.totalValue + value
                }else{
                    cell.dateLabelOult.text = self.totalValue.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero).cleanValue
                    self.totalValue = 0.0
                }
            }
        default :
            fatalError("Cell not Found!")
            
        }
        return cell
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int{
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int{
        return 1
    }
}


//MARK:- WebServices
//==================

extension WeekPerformanceVC {
    
    fileprivate func weekPerformanceData(){
        
        let param = [String : Any]()
        
        WebServices.getWeekPerformance(parameters: param, success: { (_ weekPerformanceData : [[WeekPerformance]]) in
            
            if !weekPerformanceData.isEmpty{
                self.weekPerformanceRowgradientView.isHidden = false
                self.weekPerformanceSpreadSheetView.isHidden = false
                self.noDataAvailiableLabel.isHidden = true
                self.weekPerformanceValues = weekPerformanceData
                self.weekPerformanceSpreadSheetView.reloadData()
                
            }else{
                self.noDataAvailiableLabel.isHidden = false
                self.weekPerformanceSpreadSheetView.isHidden = true
                self.weekPerformanceRowgradientView.isHidden = true
            }
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
}
