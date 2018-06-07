//
//  NutritionPlanVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 23/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NutritionPlanVC: BaseViewController {
    
    // MARK:- Total Nutrient Structure
    struct TotalNutrients {
        var water = 0
        var carbs = 0
        var fats = 0
        var proteins = 0
        var calories = 0
    }
    
    //    MARK:- Properties
    //    =================
    enum CellBtnTapped {
        case foodToAvovid
        case dailyAllowances
    }
    
    var previousPlanTableHeight: CGFloat = 0
    var currentPlanTableHeight: CGFloat = 0
    
    var cellBtnTapped = CellBtnTapped.dailyAllowances
    var previousTotalNutrients = TotalNutrients()
    
    var previousSortedNutritionPlans = [Int: [NutritionPlan]]()
    var previousNutritionPlans: [NutritionPlan] = []
    
    var previousMinimumDate: Date!
    var previousMaximumDate: Date!
    
    var previousFoodToAvoidArray = ["Not Selected","Selected","Inrtermediate","Not Selected","Selected"]
    var previousDailyAllowancesArray = ["Not Selected","Selected","Inrtermediate","Not Selected","Selected"]
    
    var currentTotalNutrients = TotalNutrients()
    
    var currentSortedNutritionPlans = [Int: [NutritionPlan]]()
    var currentNutritionPlans: [NutritionPlan] = []
    
    var currentMinimumDate: Date!
    var currentMaximumDate: Date!
    
    var currentFoodToAvoidArray = ["Not Selected","Selected","Inrtermediate","Not Selected","Selected"]
    var currentDailyAllowancesArray = ["Not Selected","Selected","Inrtermediate","Not Selected","Selected"]
    
    var mealNamesDict: [Int: String] = [1: "Early Morning (6-7 am)",
                                        2: "Breakfast (8-9 am)",
                                        3: "Mid-Morning (11-12 pm)",
                                        4: "Lunch (1-2 pm)",
                                        5: "Evening Tea (4-5 pm)",
                                        6: "Evening Soup (6-7 pm)",
                                        7: "Dinner (8-9 pm)",
                                        8: "Bed Time (10-10.30 pm)"]
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var viewContainDoctorDetails: UIView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorSpecialityLabel: UILabel!
    @IBOutlet weak var nutritionPlanTableView: UITableView!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        getPreviousNutritionPlans()
        getCurrentNutritionPlans()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .BackBtn
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Nutrition Plan", 2, 3)
        self.navigationControllerOn = .dashboard
    }
    
    // MARK: Public Methods
    func calculatePreviousNutrients() {
        previousTotalNutrients = TotalNutrients()
        
        for plans in previousNutritionPlans {
            previousTotalNutrients.calories += plans.calories
            previousTotalNutrients.water += plans.water
            previousTotalNutrients.fats += plans.fats
            previousTotalNutrients.proteins += plans.proteins
            previousTotalNutrients.carbs += plans.carbs
        }
    }
    
    func calculateCurrentNutrients() {
        currentTotalNutrients = TotalNutrients()
        
        for plans in currentNutritionPlans {
            currentTotalNutrients.calories += plans.calories
            currentTotalNutrients.water += plans.water
            currentTotalNutrients.fats += plans.fats
            currentTotalNutrients.proteins += plans.proteins
            currentTotalNutrients.carbs += plans.carbs
        }
    }
    
    func getPreviousNutritionPlans() {
        WebServices.getPreviousNutritionPlan(success: { [weak self] (nutritionPlans, foodAvoids, dailyAllowances) in
            
            self?.previousFoodToAvoidArray.removeAll(keepingCapacity: false)
            self?.previousDailyAllowancesArray.removeAll(keepingCapacity: false)
            
            for avoids in foodAvoids {
                self?.previousFoodToAvoidArray.append(contentsOf: avoids.foodsToAvoid)
            }
            
            for dailyAllowance in dailyAllowances {
                self?.previousDailyAllowancesArray.append(contentsOf: dailyAllowance.dailyAllowances)
            }
            
            self?.previousNutritionPlans = nutritionPlans
            self?.calculatePreviousNutrients()
            self?.sortPreviousNutritionPlans()
            
            self?.isDataAvaliable()
            
            
            }, failure:  { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    func getCurrentNutritionPlans() {
        WebServices.getCurrentNutritionPlan(success: { [weak self] (nutritionPlans, foodAvoids, dailyAllowances) in
            
            self?.currentFoodToAvoidArray.removeAll(keepingCapacity: false)
            self?.currentDailyAllowancesArray.removeAll(keepingCapacity: false)
            
            for avoids in foodAvoids {
                self?.currentFoodToAvoidArray.append(contentsOf: avoids.foodsToAvoid)
            }
            
            for dailyAllowance in dailyAllowances {
                self?.currentDailyAllowancesArray.append(contentsOf: dailyAllowance.dailyAllowances)
            }
            
            self?.currentNutritionPlans = nutritionPlans
            self?.calculateCurrentNutrients()
            self?.sortCurrentNutritionPlans()
            self?.isDataAvaliable()
            
            }, failure:  { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    func sortPreviousNutritionPlans() {
        for plan in previousNutritionPlans {
            
            if let planStartDate = plan.startingDate, previousMinimumDate.compare(planStartDate) == .orderedDescending {
                previousMinimumDate = planStartDate
            }
            
            if let planEndDate = plan.endingDate, previousMaximumDate.compare(planEndDate) == .orderedAscending {
                previousMaximumDate = planEndDate
            }
            
            var nutritions = previousSortedNutritionPlans[plan.meal_type] ?? []
            nutritions.append(plan)
            previousSortedNutritionPlans[plan.meal_type] = nutritions
        }
        nutritionPlanTableView.reloadSections([1], with: .fade)
    }
    
    func sortCurrentNutritionPlans() {
        for plan in currentNutritionPlans {
            
            if let planStartDate = plan.startingDate, currentMinimumDate.compare(planStartDate) == .orderedDescending {
                currentMinimumDate = planStartDate
            }
            
            if let planEndDate = plan.endingDate, currentMaximumDate.compare(planEndDate) == .orderedAscending {
                currentMaximumDate = planEndDate
            }
            
            var nutritions = currentSortedNutritionPlans[plan.meal_type] ?? []
            nutritions.append(plan)
            currentSortedNutritionPlans[plan.meal_type] = nutritions
        }
        nutritionPlanTableView.reloadSections([0], with: .fade)
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension NutritionPlanVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView === self.nutritionPlanTableView {
            return 2
        } else {
            return 1 //sortedNutritionPlans.keys.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView === self.nutritionPlanTableView{
            return 1
        } else {
            //let key = Array(sortedNutritionPlans.keys)[section]
            
            if tableView is DietAutoResizingTableView {
                return previousSortedNutritionPlans.keys.count //sortedNutritionPlans[key]?.count ?? 0
            } else {
                return currentSortedNutritionPlans.keys.count //sortedNutritionPlans[key]?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView === self.nutritionPlanTableView {
            
            switch indexPath.section {
                
            case 0:
                guard let currentNutritionPlanCell = tableView.dequeueReusableCell(withIdentifier: "currentNutritionPlanCellID") as? CurrentNutritionPlanCell else {
                    
                    fatalError("currentNutritionPlanCell not found!")
                }
                
                currentNutritionPlanCell.populateData(self.currentNutritionPlans)
                
                
                currentNutritionPlanCell.foodsToAvoidBtnOutlt.addTarget(self, action: #selector(self.foodToAvoidBtnTapped(_:)), for: .touchUpInside)
                currentNutritionPlanCell.foodAllowncesBtn.addTarget(self, action: #selector(self.dailyAllowancesBtnTapped(_:)), for: .touchUpInside)
                
                currentNutritionPlanCell.currentPlanTableView.delegate = self
                currentNutritionPlanCell.currentPlanTableView.dataSource = self
                currentNutritionPlanCell.currentPlanTableView.heightDelegate = self
                
                currentNutritionPlanCell.viewAttachmentBtn.addTarget(self, action: #selector(self.currentViewAttachmentBtntapped(_:)), for: .touchUpInside)
                
                currentNutritionPlanCell.currentPlanTableView.reloadData()
                
                var value = currentTotalNutrients.fats
                currentNutritionPlanCell.setAttributes("\(value)", text: "\(value)g\nFats", label: currentNutritionPlanCell.fatsLabelOutlt)
                
                value = currentTotalNutrients.proteins
                currentNutritionPlanCell.setAttributes("\(value)", text: "\(value)g\nProteins", label: currentNutritionPlanCell.protiensLabelOult)
                
                value = currentTotalNutrients.carbs
                currentNutritionPlanCell.setAttributes("\(value)", text: "\(value)g\nCarbs", label: currentNutritionPlanCell.crabLabelOult)
                
                value = currentTotalNutrients.water
                currentNutritionPlanCell.setAttributes("\(value)", text: "\(value)ltr\nWater", label: currentNutritionPlanCell.waterLabelOutlt)
                
                value = currentTotalNutrients.calories
                currentNutritionPlanCell.setAttributes("\(value)", text: "\(value)\nkCal", label: currentNutritionPlanCell.caloriesValue)
                
                return currentNutritionPlanCell
                
            case 1:
                guard let targetNutritionPlanCell = tableView.dequeueReusableCell(withIdentifier: "targetCalorieTableCellID") as? TargetCalorieTableCell else{
                    
                    fatalError("currentNutritionPlanCell not found!")
                }
                
                targetNutritionPlanCell.populateData(self.previousNutritionPlans)
                
                targetNutritionPlanCell.avoidFoodsBtn.addTarget(self, action: #selector(self.foodToAvoidBtnTapped(_:)), for: .touchUpInside)
                targetNutritionPlanCell.dailyAllowancesBtn.addTarget(self, action: #selector(self.dailyAllowancesBtnTapped(_:)), for: .touchUpInside)
                
                targetNutritionPlanCell.viewAttachmentBtn.addTarget(self, action: #selector(self.previousViewAttachmentBtntapped(_:)), for: .touchUpInside)
                
                targetNutritionPlanCell.dietTableView.delegate = self
                targetNutritionPlanCell.dietTableView.dataSource = self
                targetNutritionPlanCell.dietTableView.reloadData()
                targetNutritionPlanCell.dietTableView.heightDelegate = self
                
                targetNutritionPlanCell.nutrientsCollectionView.delegate = self
                targetNutritionPlanCell.nutrientsCollectionView.dataSource = self
                targetNutritionPlanCell.nutrientsCollectionView.reloadData()
                
                let value = previousTotalNutrients.calories
                targetNutritionPlanCell.setAttributes("\(value)", text: "Target Calories : \(value)", label: targetNutritionPlanCell.totalCaloriesLabel)
                
                return targetNutritionPlanCell
                
            default : fatalError("Cell Not Found!")
                
            }
        } else {
            
            switch indexPath.row {
                
            case 0:
                
                guard let previousNutritionDurationDateCell = tableView.dequeueReusableCell(withIdentifier: "previousActivityDurationDateCellID", for: indexPath) as? PreviousActivityDurationDateCell else{
                    
                    fatalError("Current Plan Activity Cell not Found!")
                }
                
//                if !self.previousNutritionPlans.isEmpty{
//
//                    previousNutritionDurationDateCell.populatePreviousNutritionData(self.previousNutritionPlans, indexPath)
//
//                }
                
//                previousNutritionDurationDateCell.shareBtnOult.addTarget(self, action: #selector(self.shareBtntapped(_:)), for: UIControlEvents.touchUpInside)
                
                CommonClass.dateFormatter.dateFormat = "dd MMM yyyy"
                var minDateString = ""
                var maxDateString = ""
                
                if tableView is DietAutoResizingTableView {
                    minDateString = CommonClass.dateFormatter.string(from: previousMinimumDate)
                    maxDateString = CommonClass.dateFormatter.string(from: previousMaximumDate)
                } else {
                    minDateString = CommonClass.dateFormatter.string(from: currentMinimumDate)
                    maxDateString = CommonClass.dateFormatter.string(from: currentMaximumDate)
                }
                
                previousNutritionDurationDateCell.activityDurationDatelabel.text = "\(minDateString) - \(maxDateString)"
                
                previousNutritionDurationDateCell.backgroundColor = .white
                previousNutritionDurationDateCell.contentView.backgroundColor = .white
                
                previousNutritionDurationDateCell.shareBtnOult.isHidden = true
                previousNutritionDurationDateCell.noDataAvailiableLabel.isHidden = true
                return previousNutritionDurationDateCell
                
            default :
                guard let nutrientLabelTableCell = tableView.dequeueReusableCell(withIdentifier: "nutrientLabelTableCellID", for: indexPath) as? NutrientLabelTableCell else{
                    
                    fatalError("Current Plan Activity Cell not Found!")
                }
                
                var key = 0
                var nutritions: [NutritionPlan] = previousSortedNutritionPlans[key] ?? []
                
                if tableView is DietAutoResizingTableView {
                    key = Array(previousSortedNutritionPlans.keys)[indexPath.row]
                    nutritions = previousSortedNutritionPlans[key] ?? []
                } else {
                    key = Array(currentSortedNutritionPlans.keys)[indexPath.row]
                    nutritions = currentSortedNutritionPlans[key] ?? []
                }
                
                var nutrientsText = ""
                
                for (index, nutrition) in nutritions.enumerated() {
                    if index == 0 {
                        nutrientsText = ": \(nutrition.menuQuantity)"
                    } else {
                        nutrientsText = " // \(nutrition.menuQuantity)"
                    }
                }
                
                nutrientLabelTableCell.mealTypeLabel.text = mealNamesDict[key]
                nutrientLabelTableCell.foodNameQuanityLabel.text = nutrientsText
                
                nutrientLabelTableCell.foodNameQuanityLabel.sizeToFit()
                return nutrientLabelTableCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView is DietAutoResizingTableView {
            //printlnDebug("previousTableHeight: \(tableView.frame.size.height)")
        } else if tableView !== nutritionPlanTableView {
            //printlnDebug("currentTableHeight: \(tableView.frame.size.height)")
        } else {
            printlnDebug("mainTableHeight: \(tableView.frame.size.height)")
        }
    }
}

//MARK:- UITableViewDelegate Methods
//===================================
extension NutritionPlanVC : AutoResizingTableViewDelegate {
    
    func didUpdateTableHeight(_ tableView: UITableView, height: CGFloat) {
        if tableView is DietAutoResizingTableView, currentPlanTableHeight < height {
            currentPlanTableHeight = height
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(reloadTable), with: self, afterDelay: 0.05)
        } else if tableView !== nutritionPlanTableView, previousPlanTableHeight < height {
            previousPlanTableHeight = height
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(reloadTable), with: self, afterDelay: 0.05)
        }
    }
    
    func reloadTable() {
        nutritionPlanTableView.beginUpdates()
        nutritionPlanTableView.endUpdates()
    }
    
}

//MARK:- UITableViewDelegate Methods
//===================================
extension NutritionPlanVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        if tableView === self.nutritionPlanTableView{
            return 400
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0, tableView === nutritionPlanTableView {
            
            if self.currentNutritionPlans.isEmpty {
                
                return 50
            }else{
                
              return 360+currentPlanTableHeight
            }
            
        } else if indexPath.section == 1, tableView === nutritionPlanTableView {
            
            if self.previousNutritionPlans.isEmpty {
                
                return 50
            }else{
                
              return 280+previousPlanTableHeight
            }
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if tableView === self.nutritionPlanTableView{
            return 36
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        if tableView === self.nutritionPlanTableView{
            
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "activityPlanDateCellID") as? ActivityPlanDateCell else {
                
                fatalError("HeaderView Not Found!")
            }
            
            if section == 0 {
                
                CommonClass.dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
                headerView.activityDateLabel.text = CommonClass.dateFormatter.string(from: Date())
                headerView.activityStatusLabel.text = "Current"
                
            } else {
                
                if !self.previousNutritionPlans.isEmpty{
                    
                    if let date = self.previousNutritionPlans[0].startingDate{
                        
                        CommonClass.dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
                         headerView.activityDateLabel.text = CommonClass.dateFormatter.string(from: date)
                    }
                }else{
                    
                   headerView.activityDateLabel.text = "No Previous Dates"
                }
                headerView.activityStatusLabel.text = "Previous"
            }
            
            return headerView
            
        }else{
            
            return nil
        }
    }
}

extension NutritionPlanVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityPlanCollectionCellID", for: indexPath) as? ActivityPlanCollectionCell else{
            
            fatalError("Collection Cell Not Found!")
        }
        
        cell.averageLabel.isHidden = true
        
        if indexPath.item == 0 {
            
            cell.cellImageView.image = #imageLiteral(resourceName: "icAddmenuCarb")
            cell.activityUnitLabel.text = "Carb"
            
            let mutableAtt = NSMutableAttributedString(string: "\(previousTotalNutrients.carbs)", attributes: [NSFontAttributeName : AppFonts.sansProBold.withSize(27), NSForegroundColorAttributeName : #colorLiteral(red: 1, green: 0.5333333333, blue: 0.07843137255, alpha: 1)])
            let attString  = NSAttributedString(string: "g", attributes: [NSFontAttributeName : AppFonts.sansProRegular.withSize(14), NSForegroundColorAttributeName : #colorLiteral(red: 1, green: 0.5333333333, blue: 0.07843137255, alpha: 1)])
            mutableAtt.append(attString)
            
            cell.activityValueLabel.attributedText = mutableAtt
            
        } else if indexPath.item == 1 {
            
            cell.cellImageView.image = #imageLiteral(resourceName: "icAddmenuFats")
            cell.activityUnitLabel.text = "Fats"
            
            let mutableAtt = NSMutableAttributedString(string: "\(previousTotalNutrients.fats)", attributes: [NSFontAttributeName : AppFonts.sansProBold.withSize(27), NSForegroundColorAttributeName : #colorLiteral(red: 0.5607843137, green: 0.1568627451, blue: 0.3921568627, alpha: 1)])
            let attString  = NSAttributedString(string: "g", attributes: [NSFontAttributeName : AppFonts.sansProRegular.withSize(14), NSForegroundColorAttributeName : #colorLiteral(red: 0.5607843137, green: 0.1568627451, blue: 0.3921568627, alpha: 1)])
            mutableAtt.append(attString)
            
            cell.activityValueLabel.attributedText = mutableAtt
            
        } else if indexPath.item == 2 {
            
            cell.cellImageView.image = #imageLiteral(resourceName: "icAddmenuProtein")
            cell.activityUnitLabel.text = "Protiens"
            
            let mutableAtt = NSMutableAttributedString(string: "\(previousTotalNutrients.proteins)", attributes: [NSFontAttributeName : AppFonts.sansProBold.withSize(27), NSForegroundColorAttributeName : #colorLiteral(red: 0.1254901961, green: 0.8549019608, blue: 0.9019607843, alpha: 1)])
            let attString  = NSAttributedString(string: "g", attributes: [NSFontAttributeName : AppFonts.sansProRegular.withSize(14), NSForegroundColorAttributeName : #colorLiteral(red: 0.1254901961, green: 0.8549019608, blue: 0.9019607843, alpha: 1)])
            mutableAtt.append(attString)
            
            cell.activityValueLabel.attributedText = mutableAtt
            
        } else {
            
            cell.cellImageView.image = #imageLiteral(resourceName: "icAddmenuGlass")
            cell.activityUnitLabel.text = "Water"
            
            let mutableAtt = NSMutableAttributedString(string: "\(previousTotalNutrients.water)", attributes: [NSFontAttributeName : AppFonts.sansProBold.withSize(27), NSForegroundColorAttributeName : #colorLiteral(red: 0.06274509804, green: 0.3450980392, blue: 0.5764705882, alpha: 1)])
            let attString  = NSAttributedString(string: "ltr", attributes: [NSFontAttributeName : AppFonts.sansProRegular.withSize(14), NSForegroundColorAttributeName : #colorLiteral(red: 0.06274509804, green: 0.3450980392, blue: 0.5764705882, alpha: 1)])
            mutableAtt.append(attString)
            
            cell.activityValueLabel.attributedText = mutableAtt
        }
        
        return cell
    }
}

extension NutritionPlanVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let width = (UIDevice.getScreenWidth - 16) / 4
        return CGSize(width: (width), height: collectionView.frame.height - 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
}

//MARK:- Methods
//==============
extension NutritionPlanVC {
    
    fileprivate func setupUI(){
        
        self.noDataAvailiableLabel.text = "No Records Found!"
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.noDataAvailiableLabel.isHidden = true
        
        self.nutritionPlanTableView.isHidden = true
        
        previousMinimumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())!
        previousMaximumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        
        currentMinimumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())!
        currentMaximumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        
        self.doctorNameLabel.font = AppFonts.sanProSemiBold.withSize(15.8)
        self.doctorNameLabel.text = AppUserDefaults.value(forKey: .doctorName).stringValue
        self.doctorSpecialityLabel.text = AppUserDefaults.value(forKey: .patientSpeciality).stringValue
        
        self.doctorSpecialityLabel.font = AppFonts.sansProRegular.withSize(11.3)
        self.viewContainDoctorDetails.backgroundColor = UIColor.sepratorColor
        
        self.nutritionPlanTableView.delegate = self
        self.nutritionPlanTableView.dataSource = self
        
        self.nutritionPlanTableView.estimatedRowHeight = 400
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let currentNutritionPlanNib = UINib(nibName: "CurrentNutritionPlanCell", bundle: nil)
        self.nutritionPlanTableView.register(currentNutritionPlanNib, forCellReuseIdentifier: "currentNutritionPlanCellID")
        
        let targetCalorieTableCellNib = UINib(nibName: "TargetCalorieTableCell", bundle: nil)
        self.nutritionPlanTableView.register(targetCalorieTableCellNib, forCellReuseIdentifier: "targetCalorieTableCellID")
        
        let headerViewNib = UINib(nibName: "ActivityPlanDateCell", bundle: nil)
        self.nutritionPlanTableView.register(headerViewNib, forHeaderFooterViewReuseIdentifier: "activityPlanDateCellID")
    }
    
    @objc fileprivate func foodToAvoidBtnTapped(_ sender : UIButton){
        
        guard let index = sender.tableViewIndexPathIn(self.nutritionPlanTableView) else{
            return
        }
        
        switch index.section {
            
        case 0 :
            
            self.openfoodToAvoidSubView(self.currentFoodToAvoidArray, foodToAvoidBtnTapped: true)
            
        case 1:
            
            self.openfoodToAvoidSubView(self.previousFoodToAvoidArray, foodToAvoidBtnTapped: true)
            
        default : return
        }
    }
    
    @objc fileprivate func dailyAllowancesBtnTapped(_ sender : UIButton){
        
        guard let index = sender.tableViewIndexPathIn(self.nutritionPlanTableView) else{
            return
        }
        
        switch index.section {
            
        case 0 :
            
            self.openfoodToAvoidSubView(self.currentDailyAllowancesArray, foodToAvoidBtnTapped: false)
            
        case 1:
            
            self.openfoodToAvoidSubView(self.previousDailyAllowancesArray, foodToAvoidBtnTapped: false)
            
        default : return
        }
    }
    
    fileprivate func openfoodToAvoidSubView(_ foodToAvoidArray : [String], foodToAvoidBtnTapped : Bool){
        
        let foodToAvoidScene = DosDontsVC.instantiate(fromAppStoryboard: .Activity)
        
        foodToAvoidScene.foodToAvoidArray = foodToAvoidArray
        
        if foodToAvoidBtnTapped == true{
            
            foodToAvoidScene.buttonTapped = .foodToAvoid
            
        }else{
            
            foodToAvoidScene.buttonTapped = .dailyAllowances
        }
        
        foodToAvoidScene.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
        
        UIView.animate(withDuration: 0.3) {
            
            foodToAvoidScene.view.frame = CGRect(x: 0, y: 0 , width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
        }
        
        sharedAppDelegate.window?.addSubview(foodToAvoidScene.view)
        self.addChildViewController(foodToAvoidScene)
        
    }
    
    @objc fileprivate func shareBtntapped(_ sender : UIButton){
        
//        let shareScene = DosDontsVC.instantiate(fromAppStoryboard: .Activity)
//        shareScene.buttonTapped = .attachment
//
//        sharedAppDelegate.window?.addSubview(shareScene.view)
//        self.addChildViewController(shareScene)
    }
    
    @objc fileprivate func currentViewAttachmentBtntapped(_ sender : UIButton){
        
        if !self.currentNutritionPlans.isEmpty{
            
            var attachmentUrl = [String]()
            var attachmentName = [String]()
            
            if self.currentNutritionPlans[0].attachments!.count > 1{
                
                if let attachUrl = self.currentNutritionPlans[0].attachments, !attachUrl.isEmpty {
                    
                    attachmentUrl = attachUrl.components(separatedBy: ",")
                }
                
                if let attachName = self.currentNutritionPlans[0].attachments_name, !attachName.isEmpty {
                    
                    attachmentName = attachName.components(separatedBy: ",")
                }
                
                self.attachmentView(attachmentUrl, attachmentName)
                
            }else{
                
                var attachmentUrl = ""
                var attachmentName = ""
                
                if !self.currentNutritionPlans[0].attachments!.isEmpty{
                    
                    attachmentUrl = self.currentNutritionPlans[0].attachments!
                    
                }
                
                if self.currentNutritionPlans[0].attachments_name!.isEmpty{
                    
                    attachmentName = self.currentNutritionPlans[0].attachments_name!
                }
                
                self.openWebView(attachmentUrl, attachmentName)
                
            }
        }
    }
    
    @objc fileprivate func previousViewAttachmentBtntapped(_ sender : UIButton){
        
        if !self.previousNutritionPlans.isEmpty{
            
            var attachmentUrl = [String]()
            var attachmentName = [String]()
            
            if self.previousNutritionPlans[0].attachments!.count > 1{
                
                if let attachUrl = self.previousNutritionPlans[0].attachments, !attachUrl.isEmpty {
                    
                    attachmentUrl = attachUrl.components(separatedBy: ",")
                }
                
                if let attachName = self.previousNutritionPlans[0].attachments_name, !attachName.isEmpty {
                    
                    attachmentName = attachName.components(separatedBy: ",")
                }
                
                self.attachmentView(attachmentUrl, attachmentName)
                
            }else if self.previousNutritionPlans[0].attachments!.count > 0 && self.previousNutritionPlans[0].attachments!.count <= 1{
                
                var attachmentUrl = ""
                var attachmentName = ""
                
                if !self.previousNutritionPlans[0].attachments!.isEmpty{
                    
                    attachmentUrl = self.previousNutritionPlans[0].attachments!
                    
                }
                
                if self.previousNutritionPlans[0].attachments_name!.isEmpty{
                    
                    attachmentName = self.previousNutritionPlans[0].attachments_name!
                }
                
                self.openWebView(attachmentUrl, attachmentName)
                
            }
        }
    }
    
    fileprivate func attachmentView(_ attachmentUrl : [String], _ attachmentName : [String]){
        
        let dosAndDontsScene = DosDontsVC.instantiate(fromAppStoryboard: .Activity)
        dosAndDontsScene.attachmentURl = attachmentUrl
        dosAndDontsScene.attachmentName = attachmentName
        dosAndDontsScene.buttonTapped = .attachment
        dosAndDontsScene.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
        
        UIView.animate(withDuration: 0.3) {
            
            dosAndDontsScene.view.frame = CGRect(x: 0, y: 0 , width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
        }
        
        sharedAppDelegate.window?.addSubview(dosAndDontsScene.view)
        self.addChildViewController(dosAndDontsScene)
        
    }
    
    fileprivate func openWebView(_ attachmentUrl : String, _ attachmentName : String){
        
        let webViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
        webViewScene.webViewUrl = attachmentUrl
        webViewScene.screenName = attachmentName
        self.navigationController?.pushViewController(webViewScene, animated: true)
    }
    
    fileprivate func isDataAvaliable(){
        
        if self.currentNutritionPlans.isEmpty && self.previousNutritionPlans.isEmpty {
            
            self.noDataAvailiableLabel.isHidden = false
            self.nutritionPlanTableView.isHidden = true
            
        }else{
            
            self.noDataAvailiableLabel.isHidden = true
            self.nutritionPlanTableView.isHidden = false
            
        }
    }
}

