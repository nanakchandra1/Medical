//
//  WeekPerformanceVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 23/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SpreadsheetView

class WeekPerformanceVC: BaseViewController {
    
    //    MARK:- Proporties
    //    =================
    var nutritionDuration = ["BREAKFAST", "LUNCH", "DINNER","SNAKS","WATER","TOTAL CAL"]
    var daysInWeek = ["SUN","MON","TUES","WED","THU","FRI","SAT"]
    var weekPerformanceValues = [[WeekPerformance]]()
    var totalValue : Double = 0.0
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var nutritionSelectionView: UIView!
    @IBOutlet weak var nutritionSelectionTextField: UITextField!
    @IBOutlet weak var addBtnOutlt: UIButton!
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
        
        // Do any additional setup after loading the view.
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.weekPerformanceData()
        self.navigationControllerOn = .dashboard
        self.sideMenuBtnActn = .BackBtn
        self.weekPerformanceSpreadSheetView.gridStyle = GridStyle.none
        self.setNavigationBar("Week Performance", 2, 2)
  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
//    MARK:- IBActions
//    ================
    @IBAction func addBtnTapped(_ sender: UIButton) {
        
        let addNutritionScene = AddNutritionVC.instantiate(fromAppStoryboard: .Nutrition)
        self.navigationController?.pushViewController(addNutritionScene, animated: true)
    }
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
        
        self.nutritionSelectionView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        
        self.view.backgroundColor = .white
        self.weekPerformanceSpreadSheetView.backgroundColor = UIColor.clear
        
        self.nutritionSelectionTextField.font = AppFonts.sanProSemiBold.withSize(15.8)
        self.nutritionSelectionTextField.borderStyle = UITextBorderStyle.roundedRect
        self.nutritionSelectionTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icMeasurementDropdown"))
        self.nutritionSelectionTextField.rightViewMode = UITextFieldViewMode.always
        
        self.addBtnOutlt.setImage(#imageLiteral(resourceName: "icMeasurementAdd"), for: UIControlState.normal)
        
        self.bottomButtonContainView.gradient(withX: 0, withY: 0, cornerRadius: false)
        
        self.myNutritionBtnOutlt.backgroundColor = UIColor.clear
        self.nutritionPlanBtnOutlt.backgroundColor = UIColor.clear
        
        self.myNutritionBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.myNutritionBtnOutlt.setTitle("MY NUTRITION", for: .normal)
        self.myNutritionBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        
        self.nutritionPlanBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.nutritionPlanBtnOutlt.setTitle("NUTRITION PLAN", for: .normal)
        self.nutritionPlanBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        
        self.weekPerformanceSpreadSheetView.dataSource = self
        
        self.weekPerformanceSpreadSheetView.circularScrolling = CircularScrolling.Configuration.none
        self.weekPerformanceSpreadSheetView.alwaysBounceHorizontal = false
        self.weekPerformanceSpreadSheetView.alwaysBounceVertical = false
        
        self.weekPerformanceSpreadSheetView.bounces = false
        self.weekPerformanceSpreadSheetView.showsHorizontalScrollIndicator = false
        self.weekPerformanceSpreadSheetView.showsVerticalScrollIndicator = false
        
        self.weekPerformanceSpreadSheetView.decelerationRate = 0.2
        
        self.weekPerformanceRowgradientView.gradient(withX: 0, withY: 0, cornerRadius: false)
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
        
        if !self.weekPerformanceValues.isEmpty {
            
            return self.weekPerformanceValues[0].count + 2
        }else{
            
            return 1
        }
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int{
        
        if !self.weekPerformanceValues.isEmpty {
            
            return self.weekPerformanceValues.count + 1
        }else{
            
            return 1
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        
        if !self.weekPerformanceValues.isEmpty{
            
           return (CGFloat(Int(UIDevice.getScreenWidth) / (self.weekPerformanceValues[0].count + 2)) - 0.1)
        }else{
            
            return UIDevice.getScreenWidth / 6
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        
        return CGFloat(38.5)
    }
    
    //     The cell that is returned must be retrieved from a call to `dequeueReusableCell(withReuseIdentifier:for:)`
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell?{
        
        guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
            
            fatalError("cell not found!")
        }
        cell.verticalSepratorView.dashLine(CGPoint(x: 0.0, y: self.view.layer.frame.origin.y), CGPoint(x: 0, y: self.view.layer.frame.height))
        
        switch (indexPath.column , indexPath.row){
            
        case (0,0):
            cell.timeLabelOult.isHidden = true
            cell.verticalSepratorView.isHidden = false
            cell.bottomSepratorView.isHidden = true
            cell.dateLabelOult.textColor = UIColor.white
            cell.dateLabelOult.isHidden = false
            cell.dateLabelOult.text = "DAYS"
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
                    let convertToDate = date.dateFromString
                    let day = convertToDate?.getDayOfWeek("EEE")
                    cell.dateLabelOult.text = day
                }
            }
            
            cell.bottomSepratorView.dashLine(CGPoint(x: 0.0, y: 0.0), CGPoint(x: self.view.layer.frame.width, y: 0))
            
        case (0...self.weekPerformanceValues[0].count + 1,0) :
            
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            cell.dateLabelOult.textColor = UIColor.white
            cell.dateLabelOult.font = AppFonts.sanProSemiBold.withSize(10.1)
            cell.timeLabelOult.isHidden = true
            
            if !weekPerformanceValues[indexPath.row].isEmpty {
                
                if indexPath.column <= self.weekPerformanceValues[indexPath.row].count{
                    
                  cell.dateLabelOult.text = self.weekPerformanceValues[indexPath.row][indexPath.column - 1].mealDuration
                }else{
                    
                  cell.dateLabelOult.text = "Total"
                }
            }
            
        case (1...self.weekPerformanceValues[0].count+2, 1...self.weekPerformanceValues.count + 1) :
            
            cell.contentView.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.white
            cell.dateLabelOult.textColor = UIColor.black
            cell.timeLabelOult.isHidden = true
            cell.bottomSepratorView.dashLine(CGPoint(x: 0.0, y: 0.0), CGPoint(x: self.view.layer.frame.width, y: 0))
            
            if !self.weekPerformanceValues[indexPath.row - 1].isEmpty {
                
                if indexPath.column <= self.weekPerformanceValues[indexPath.row - 1].count {
                    
                    let value = self.weekPerformanceValues[indexPath.row - 1][indexPath.column - 1].value
                    
                                        cell.dateLabelOult.text = "\(value!)"
                                        self.totalValue = self.totalValue + value!
                    
                }else{
                    
                    cell.dateLabelOult.text = "\(self.totalValue)"
                    self.totalValue = 0.0
                }
            }
        default : fatalError("Cell not Found!")
            
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
