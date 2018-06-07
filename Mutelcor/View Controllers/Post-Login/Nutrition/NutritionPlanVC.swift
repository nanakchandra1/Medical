//
//  NutritionPlanVC.swift
//  Mutelcor
//
//  Created by on 23/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class NutritionPlanVC: BaseViewControllerWithBackButton {
    
    enum CellBtnTapped {
        case foodToAvovid
        case dailyAllowances
    }
    
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
    fileprivate var previousPlanTableHeight: CGFloat = 0
    fileprivate var currentPlanTableHeight: CGFloat = 0

    fileprivate var isCurrentPlanTableCompletelyUpdated = false
    fileprivate var isPreviousPlanTableCompletelyUpdated = false
    
    fileprivate var cellBtnTapped = CellBtnTapped.dailyAllowances
    fileprivate var previousTotalNutrients = TotalNutrients()
    
    fileprivate var previousSortedNutritionPlans = [Int: [NutritionPlan]]()
    fileprivate var previousNutritionPlans: [NutritionPlan] = []
    
    fileprivate var previousMinimumDate: Date!
    fileprivate var previousMaximumDate: Date!
    
    fileprivate var previousFoodToAvoidArray = [String]()
    fileprivate var previousPointsToRemember = [NutritionPointToRemember]()
    fileprivate var previousDailyAllowancesArray = [String]()
    
    fileprivate var currentTotalNutrients = TotalNutrients()
    
    fileprivate var currentSortedNutritionPlans = [Int: [NutritionPlan]]()
    fileprivate var currentNutritionPlans: [NutritionPlan] = []
    
    fileprivate var currentMinimumDate: Date!
    fileprivate var currentMaximumDate: Date!
    
    fileprivate var currentFoodToAvoidArray = [String]()
    fileprivate var currentPointsToRemember = [NutritionPointToRemember]()
    fileprivate var currentDailyAllowancesArray = [String]()
    
    fileprivate var mealNamesDict: [Int: String] = [1: "Early Morning (6-7 am)",
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
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        getPreviousNutritionPlans()
        getCurrentNutritionPlans()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .nutrition
        self.setNavigationBar(screenTitle: K_NUTRITION_PLAN_SCREEN_TITLE.localized)
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
            currentTotalNutrients.water = plans.water
            currentTotalNutrients.fats += plans.fats
            currentTotalNutrients.proteins += plans.proteins
            currentTotalNutrients.carbs += plans.carbs
        }
    }
    
    func getPreviousNutritionPlans() {
        WebServices.getPreviousNutritionPlan(success: { [weak self] (nutritionPlans, foodAvoids, dailyAllowances, pointToRemember) in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.previousFoodToAvoidArray = []
            strongSelf.previousDailyAllowancesArray = []
            
            for avoids in foodAvoids {
                strongSelf.previousFoodToAvoidArray.append(avoids.foodToAvoid ?? "")
            }
            
            for dailyAllowance in dailyAllowances {
                strongSelf.previousDailyAllowancesArray.append(dailyAllowance.dailyAllowance ?? "")
            }
            
            if !pointToRemember.isEmpty{
                strongSelf.previousPointsToRemember = pointToRemember
                }
            
            strongSelf.previousNutritionPlans = nutritionPlans
            strongSelf.calculatePreviousNutrients()
            strongSelf.sortPreviousNutritionPlans()
            
            strongSelf.isDataAvaliable()
            }, failure:  { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    func getCurrentNutritionPlans() {
        WebServices.getCurrentNutritionPlan(success: { [weak self] (nutritionPlans, foodAvoids, dailyAllowances, pointToRemember) in
            
            guard let nutritionPlanVC = self else{
                return
            }
            
            nutritionPlanVC.currentFoodToAvoidArray.removeAll(keepingCapacity: false)
            nutritionPlanVC.currentDailyAllowancesArray.removeAll(keepingCapacity: false)
            
            for avoids in foodAvoids {
                nutritionPlanVC.currentFoodToAvoidArray.append(avoids.foodToAvoid ?? "")
            }
            
            for dailyAllowance in dailyAllowances {
                nutritionPlanVC.currentDailyAllowancesArray.append(dailyAllowance.dailyAllowance ?? "")
            }
            
            if !pointToRemember.isEmpty{
                nutritionPlanVC.currentPointsToRemember = pointToRemember
                }
            
            nutritionPlanVC.currentNutritionPlans = nutritionPlans
            nutritionPlanVC.calculateCurrentNutrients()
            nutritionPlanVC.sortCurrentNutritionPlans()
            nutritionPlanVC.isDataAvaliable()
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
        
        let sections = (tableView === self.nutritionPlanTableView) ? 2 : 1
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        let rowsInDietAutoResizingTableView = (tableView is DietAutoResizingTableView) ? previousSortedNutritionPlans.keys.count : currentSortedNutritionPlans.keys.count
        let rowsInTableView = (tableView === self.nutritionPlanTableView) ? 1 : 1+rowsInDietAutoResizingTableView
        return rowsInTableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView === self.nutritionPlanTableView {
            
            switch indexPath.section {
                
            case 0:
                guard let currentNutritionPlanCell = tableView.dequeueReusableCell(withIdentifier: "currentNutritionPlanCellID") as? CurrentNutritionPlanCell else {
                    fatalError("currentNutritionPlanCell not found!")
                }
                
                currentNutritionPlanCell.populateData(self.currentNutritionPlans)
                currentNutritionPlanCell.shareBtnOutlt.addTarget(self, action: #selector(self.shareBtntapped(_:)), for: .touchUpInside)
                currentNutritionPlanCell.foodsToAvoidBtnOutlt.addTarget(self, action: #selector(self.foodToAvoidBtnTapped(_:)), for: .touchUpInside)
                currentNutritionPlanCell.foodAllowncesBtn.addTarget(self, action: #selector(self.dailyAllowancesBtnTapped(_:)), for: .touchUpInside)
                currentNutritionPlanCell.viewAttachmentBtn.addTarget(self, action: #selector(self.currentViewAttachmentBtnTapped(_:)), for: .touchUpInside)
                
                currentNutritionPlanCell.currentPlanTableView.delegate = self
                currentNutritionPlanCell.currentPlanTableView.dataSource = self
                currentNutritionPlanCell.currentPlanTableView.heightDelegate = self
                currentNutritionPlanCell.currentPlanTableView.reloadData()
                
                var value = currentTotalNutrients.fats
                currentNutritionPlanCell.setAttributes("\(value)", text: "\(value)\(K_GRAM_TITLE.localized)\n\(K_FATS_TITLE.localized)", label: currentNutritionPlanCell.fatsLabelOutlt)
                
                value = currentTotalNutrients.proteins
                currentNutritionPlanCell.setAttributes("\(value)", text: "\(value)\(K_GRAM_TITLE.localized)\n\(K_PROTIENS_TITLE.localized)", label: currentNutritionPlanCell.protiensLabelOult)
                
                value = currentTotalNutrients.carbs
                currentNutritionPlanCell.setAttributes("\(value)", text: "\(value)\(K_GRAM_TITLE.localized)\n\(K_CARB_TITLE.localized)", label: currentNutritionPlanCell.crabLabelOult)
                
                value = currentTotalNutrients.water
                currentNutritionPlanCell.setAttributes("\(value)", text: "\(value)\(K_LITRE_TITLE.localized)\n\(K_WATER_TITLE.localized)", label: currentNutritionPlanCell.waterLabelOutlt)
                
                value = currentTotalNutrients.calories
                currentNutritionPlanCell.setAttributes("\(value)", text: "\(value)\n\(K_CALORIES_UNIT.localized)", label: currentNutritionPlanCell.caloriesValue)
                
                return currentNutritionPlanCell
            case 1:
                guard let targetNutritionPlanCell = tableView.dequeueReusableCell(withIdentifier: "targetCalorieTableCellID") as? TargetCalorieTableCell else{
                    fatalError("currentNutritionPlanCell not found!")
                }
                
                targetNutritionPlanCell.populateData(self.previousNutritionPlans)
                targetNutritionPlanCell.shareBtnOutlt.addTarget(self, action: #selector(self.shareBtntapped(_:)), for: .touchUpInside)
                targetNutritionPlanCell.avoidFoodsBtn.addTarget(self, action: #selector(self.foodToAvoidBtnTapped(_:)), for: .touchUpInside)
                targetNutritionPlanCell.dailyAllowancesBtn.addTarget(self, action: #selector(self.dailyAllowancesBtnTapped(_:)), for: .touchUpInside)
                targetNutritionPlanCell.viewAttachmentBtn.addTarget(self, action: #selector(self.previousViewAttachmentBtnTapped(_:)), for: .touchUpInside)
                
                if !(targetNutritionPlanCell.dietTableView.delegate is NutritionPlanVC) {
                    targetNutritionPlanCell.dietTableView.delegate = self
                    targetNutritionPlanCell.dietTableView.dataSource = self
                }
                
                targetNutritionPlanCell.dietTableView.heightDelegate = self
                targetNutritionPlanCell.dietTableView.reloadData()
                
                if !(targetNutritionPlanCell.nutrientsCollectionView.delegate is NutritionPlanVC) {
                    targetNutritionPlanCell.nutrientsCollectionView.delegate = self
                    targetNutritionPlanCell.nutrientsCollectionView.dataSource = self
                }
                targetNutritionPlanCell.nutrientsCollectionView.reloadData()
                
                let value = previousTotalNutrients.calories
                targetNutritionPlanCell.setAttributes("\(value)", text: "Target Calories : \(value)", label: targetNutritionPlanCell.totalCaloriesLabel)
                
                return targetNutritionPlanCell
                
            default:
                fatalError("Cell Not Found!")
            }
        } else {
            switch indexPath.row {
            case 0:
                guard let previousNutritionDurationDateCell = tableView.dequeueReusableCell(withIdentifier: "previousActivityDurationDateCellID", for: indexPath) as? PreviousActivityDurationDateCell else{
                    fatalError("Previous Plan Activity Cell not Found!")
                }
                
                var minDateString = ""
                var maxDateString = ""
                
                if tableView is DietAutoResizingTableView {
                    minDateString = previousMinimumDate.stringFormDate(.ddMMMYYYY)
                    maxDateString = previousMaximumDate.stringFormDate(.ddMMMYYYY)
                } else {
                    minDateString = currentMinimumDate.stringFormDate(.ddMMMYYYY)
                    maxDateString = currentMaximumDate.stringFormDate(.ddMMMYYYY)
                }
                
                previousNutritionDurationDateCell.activityDurationDatelabel.text = "\(minDateString) - \(maxDateString)"
                
                previousNutritionDurationDateCell.backgroundColor = .white
                previousNutritionDurationDateCell.contentView.backgroundColor = .white
                
                previousNutritionDurationDateCell.shareBtnOult.isHidden = true
                previousNutritionDurationDateCell.noDataAvailiableLabel.isHidden = true
                return previousNutritionDurationDateCell
                
            default :
                guard let nutrientLabelTableCell = tableView.dequeueReusableCell(withIdentifier: "nutrientLabelTableCellID", for: indexPath) as? NutrientLabelTableCell else{
                    fatalError("NutrientLabelTableCell not Found!")
                }
                
                var key = 0
                var nutritions: [NutritionPlan] = previousSortedNutritionPlans[key] ?? []
                
                if tableView is DietAutoResizingTableView {
                    key = Array(previousSortedNutritionPlans.keys)[indexPath.row-1]
                    nutritions = previousSortedNutritionPlans[key] ?? []
                } else {
                    key = Array(currentSortedNutritionPlans.keys)[indexPath.row-1]
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
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if tableView is DietAutoResizingTableView {
//
//        } else if tableView !== nutritionPlanTableView {
//
//        } else {
//            //printlnDebug("mainTableHeight: \(tableView.frame.size.height)")
//        }
//    }
}

//MARK:- UITableViewDelegate Methods
//===================================
extension NutritionPlanVC : AutoResizingTableViewDelegate {
    
    func didUpdateTableHeight(_ tableView: UITableView, height: CGFloat) {

        if !isPreviousPlanTableCompletelyUpdated, tableView is DietAutoResizingTableView, previousPlanTableHeight != height/*, previousPlanTableHeight < height*/ {
            previousPlanTableHeight = height
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(reloadTable), with: self, afterDelay: 0.05)

        } else if !isCurrentPlanTableCompletelyUpdated, tableView is AutoResizingTableView, currentPlanTableHeight != height/*, currentPlanTableHeight < height*/ {
            currentPlanTableHeight = height
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(reloadTable), with: self, afterDelay: 0.05)
        }
    }
    
    @objc func reloadTable() {
        nutritionPlanTableView.beginUpdates()
        nutritionPlanTableView.endUpdates()
        //nutritionPlanTableView.reloadData()
    }
}

//MARK:- UITableViewDelegate Methods
//===================================
extension NutritionPlanVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let estimatedHeight = (tableView === self.nutritionPlanTableView) ? 400 : 30
        return CGFloat(estimatedHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0, tableView === nutritionPlanTableView {
            
            if !self.currentNutritionPlans.isEmpty {

                let otherComponentsHeight: CGFloat = 144
                let attachmentBtnHeight: CGFloat = 50
                let designImageViewHeight = ((UIDevice.getScreenWidth - 10) * 2/3)

                let height = self.currentNutritionPlans[0].attachments!.isEmpty ? (otherComponentsHeight + designImageViewHeight + currentPlanTableHeight) : (otherComponentsHeight + designImageViewHeight + attachmentBtnHeight + currentPlanTableHeight)
                return height

            } else {
               return CGFloat.leastNormalMagnitude
            }
            
        } else if indexPath.section == 1, tableView === nutritionPlanTableView {
            
            if !self.previousNutritionPlans.isEmpty {

                let otherComponentsHeight: CGFloat = 231
                let attachmentBtnHeight: CGFloat = 50

                let height = self.previousNutritionPlans[0].attachments!.isEmpty ? (otherComponentsHeight + previousPlanTableHeight) : (otherComponentsHeight + attachmentBtnHeight + previousPlanTableHeight)
                return height

            } else {
                return CGFloat.leastNormalMagnitude
            }
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if tableView === self.nutritionPlanTableView {
            switch section{
            case 0:
                let height = (!self.currentNutritionPlans.isEmpty) ? 36 : CGFloat.leastNormalMagnitude
                return height
            case 1:
                let height = (!self.previousNutritionPlans.isEmpty) ? 36 : CGFloat.leastNormalMagnitude
                return height
            default:
                return CGFloat.leastNormalMagnitude
            }
        }else{
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        if tableView === self.nutritionPlanTableView {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "activityPlanDateCellID") as? ActivityPlanDateCell else {
                fatalError("HeaderView Not Found!")
            }
            
            if section == 0 {
                
                if let data = self.currentNutritionPlans.first {
                    headerView.activityDateLabel.text = data.createdDate.changeDateFormat(.utcTime, .ddMMMYYYYHHmm)
                }
                headerView.activityStatusLabel.text = K_CURRENT_TITLE.localized.uppercased()
            } else {
                if !self.previousNutritionPlans.isEmpty{
                    let date = self.previousNutritionPlans[0].createdDate
                    headerView.activityDateLabel.text = date.changeDateFormat(.utcTime, .ddMMMYYYYHHmm)
                }else{
                    headerView.activityDateLabel.text = K_NO_PREVIOUS_DATES.localized
                }
                headerView.activityStatusLabel.text = K_PREVIOUS_TITLE.localized.uppercased()
            }
            return headerView
        }else{
            return nil
        }
    }

    /*
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tableView === self.nutritionPlanTableView else {
            return
        }

        if indexPath.section == 0 {
            isCurrentPlanTableCompletelyUpdated = true
        } else {
            isPreviousPlanTableCompletelyUpdated = true
        }
    }
    */
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
            cell.activityUnitLabel.text = K_CARB_TITLE.localized
            
            let mutableAtt = NSMutableAttributedString(string: "\(previousTotalNutrients.carbs)", attributes: [NSAttributedStringKey.font : AppFonts.sansProBold.withSize(27), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 1, green: 0.5333333333, blue: 0.07843137255, alpha: 1)])
            let attString  = NSAttributedString(string: K_GRAM_TITLE.localized, attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(14), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 1, green: 0.5333333333, blue: 0.07843137255, alpha: 1)])
            mutableAtt.append(attString)
            
            cell.activityValueLabel.attributedText = mutableAtt
            
        } else if indexPath.item == 1 {
            
            cell.cellImageView.image = #imageLiteral(resourceName: "icAddmenuFats")
            cell.activityUnitLabel.text = K_FATS_TITLE.localized
            
            let mutableAtt = NSMutableAttributedString(string: "\(previousTotalNutrients.fats)", attributes: [NSAttributedStringKey.font : AppFonts.sansProBold.withSize(27), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.5607843137, green: 0.1568627451, blue: 0.3921568627, alpha: 1)])
            let attString  = NSAttributedString(string: K_GRAM_TITLE.localized, attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(14), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.5607843137, green: 0.1568627451, blue: 0.3921568627, alpha: 1)])
            mutableAtt.append(attString)
            
            cell.activityValueLabel.attributedText = mutableAtt
            
        } else if indexPath.item == 2 {
            
            cell.cellImageView.image = #imageLiteral(resourceName: "icAddmenuProtein")
            cell.activityUnitLabel.text = K_PROTIENS_TITLE.localized
            
            let mutableAtt = NSMutableAttributedString(string: "\(previousTotalNutrients.proteins)", attributes: [NSAttributedStringKey.font : AppFonts.sansProBold.withSize(27), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.1254901961, green: 0.8549019608, blue: 0.9019607843, alpha: 1)])
            let attString  = NSAttributedString(string: K_GRAM_TITLE.localized, attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(14), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.1254901961, green: 0.8549019608, blue: 0.9019607843, alpha: 1)])
            mutableAtt.append(attString)
            
            cell.activityValueLabel.attributedText = mutableAtt
            
        } else {
            
            cell.cellImageView.image = #imageLiteral(resourceName: "icAddmenuGlass")
            cell.activityUnitLabel.text = K_WATER_TITLE.localized
            
            let mutableAtt = NSMutableAttributedString(string: "\(previousTotalNutrients.water)", attributes: [NSAttributedStringKey.font : AppFonts.sansProBold.withSize(27), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.06274509804, green: 0.3450980392, blue: 0.5764705882, alpha: 1)])
            let attString  = NSAttributedString(string: K_LITRE_TITLE.localized, attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(14), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.06274509804, green: 0.3450980392, blue: 0.5764705882, alpha: 1)])
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
        
        self.noDataAvailiableLabel.text = K_NO_NUTRITION_PLAN.localized
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.noDataAvailiableLabel.isHidden = true
        
        self.nutritionPlanTableView.isHidden = true
        
        previousMinimumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())!
        previousMaximumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        
        currentMinimumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())!
        currentMaximumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        
        self.doctorNameLabel.font = AppFonts.sanProSemiBold.withSize(15.8)
        
        let docName = AppUserDefaults.value(forKey: .doctorName).stringValue
        let name = !docName.isEmpty ? "\(docName)" : ""
        self.doctorNameLabel.text = name
        self.doctorSpecialityLabel.text = AppUserDefaults.value(forKey: .doctorSpecialization).stringValue
        
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
        case 0:
            self.openfoodToAvoidSubView(self.currentFoodToAvoidArray, foodToAvoidBtnTapped: true, pointToRemember: [])
        case 1:
            self.openfoodToAvoidSubView(self.previousFoodToAvoidArray, foodToAvoidBtnTapped: true, pointToRemember: [])
        default :
            return
        }
    }
    
    @objc fileprivate func dailyAllowancesBtnTapped(_ sender : UIButton){
        
        guard let index = sender.tableViewIndexPathIn(self.nutritionPlanTableView) else{
            return
        }
        switch index.section {
        case 0:
            self.openfoodToAvoidSubView(self.currentDailyAllowancesArray, foodToAvoidBtnTapped: false, pointToRemember: self.currentPointsToRemember)
        case 1:
            self.openfoodToAvoidSubView(self.previousDailyAllowancesArray, foodToAvoidBtnTapped: false, pointToRemember: self.previousPointsToRemember)
            
        default:
            return
        }
    }
    
    fileprivate func openfoodToAvoidSubView(_ foodToAvoidArray : [String], foodToAvoidBtnTapped : Bool, pointToRemember : [NutritionPointToRemember]){
        
        let foodToAvoidScene = DosDontsVC.instantiate(fromAppStoryboard: .Activity)
        
        foodToAvoidScene.foodToAvoidArray = foodToAvoidArray
        foodToAvoidScene.nutritionPointToRemember = pointToRemember
        let btnTapped = (foodToAvoidBtnTapped) ? ButtonTapped.foodToAvoid : .dailyAllowances
        foodToAvoidScene.buttonTapped = btnTapped
        
        foodToAvoidScene.modalPresentationStyle = .overCurrentContext
        self.present(foodToAvoidScene, animated: false, completion: nil)
    }
    
    @objc fileprivate func shareBtntapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.nutritionPlanTableView) else{
            return
        }
        switch indexPath.section {
        case 0:
            guard !self.currentNutritionPlans.isEmpty else{
                return
            }
            let pdfFile = self.currentNutritionPlans[indexPath.row].pdfFile
            self.openShareViewController(pdfLink: pdfFile)
        case 1:
            guard !self.previousNutritionPlans.isEmpty else{
                return
            }
            let pdfFile = self.previousNutritionPlans[indexPath.row].pdfFile
            self.openShareViewController(pdfLink: pdfFile)
        default:
            return
        }
    }
    
    @objc fileprivate func currentViewAttachmentBtnTapped(_ sender : UIButton){
        
        if !self.currentNutritionPlans.isEmpty{
            
            var attachmentUrl = [String]()
            var attachmentName = [String]()
            let attcahment = self.currentNutritionPlans[0].attachments ?? ""
            
            if !attcahment.isEmpty{
                attachmentUrl = attcahment.components(separatedBy: ",")
            }
            if let attachName = self.currentNutritionPlans[0].attachments_name{
                attachmentName = attachName.components(separatedBy: ",")
            }
            
            if !attachmentUrl.isEmpty{
                if  attachmentUrl.count > 1{
                    self.attachmentView(attachmentUrl, attachmentName)
                }else{
                    let attachName = attachmentName.first ?? ""
                    self.openWebView(attachmentUrl[0], attachName)
                }
            }
        }else{
            showToastMessage("No attachments.")
        }
    }
    
    
    @objc fileprivate func previousViewAttachmentBtnTapped(_ sender : UIButton){
        
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
                let name = self.previousNutritionPlans[0].attachments_name!
                let attcahName = !name.isEmpty ? name : K_PREVIOUS_ATTACHMENT.localized
                if !self.previousNutritionPlans[0].attachments!.isEmpty{
                    let attachmentUrl = self.previousNutritionPlans[0].attachments!
                    self.openWebView(attachmentUrl, attcahName)
                }
            }
        }
    }
    
    fileprivate func attachmentView(_ attachmentUrl : [String], _ attachmentName : [String]){
        
        let dosAndDontsScene = DosDontsVC.instantiate(fromAppStoryboard: .Activity)
        dosAndDontsScene.attachmentURl = attachmentUrl
        dosAndDontsScene.attachmentName = attachmentName
        dosAndDontsScene.buttonTapped = .attachment
        dosAndDontsScene.delegate = self
        dosAndDontsScene.modalPresentationStyle = .overCurrentContext
        self.present(dosAndDontsScene, animated: false, completion: nil)
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

extension NutritionPlanVC : OpenWebViewDelegate {
    
    func attachmentData(_ attachmentURl : String, attachmentData : String) {
        self.openWebView(attachmentURl, attachmentData)
    }
}
