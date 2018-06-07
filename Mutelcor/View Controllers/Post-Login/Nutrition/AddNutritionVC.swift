//
//  AddAddNutritionVC.swift
//  Mutelcor
//
//  Created by on 22/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON
import TransitionButton

class AddNutritionVC: BaseViewControllerWithBackButton {
//    MARK:- Enum for select the Activity type
    fileprivate enum ActivityTypeSelection {
        case water
        case other
    }

    // MARK:- Total Nutrient Structure
    struct TotalNutrients {
        var calories = 0
        var carbs = 0
        var fats = 0
        var proteins = 0
        var water = 0
    }
    
    // MARK:- Properties
    var userFoods: [RecentFood] = []
    var waterFood: [RecentFood] = []
    var otherUserFood: [RecentFood] = []
    var foods: [Food] = []
    var recentFoods: [RecentFood] = []
    var mealSchedules: [MealSchedule] = []
    var lastFoodIndexPath: IndexPath?
    var totalNutrients = TotalNutrients()
    var meals = [String]()
    var parameters = [String : Any]()
    
    var mealId: Int?
    var waterID: Int?
    var mealName: String?
    
    var visibleDateText = ""
    var serverDateText = ""
    var timeText = ""
    var recentBtnTapped = false
    fileprivate var activityTypeSelection: ActivityTypeSelection = .other
    
    var isNutritionDataValid: Bool {
        
        if mealId == nil {
            showToastMessage(AppMessages.selectAMeal.rawValue.localized)
        } else if !isUserFoodValid {
            
        } else if serverDateText.isEmpty {
            showToastMessage(AppMessages.selectNutritionDate.rawValue.localized)
        } else if timeText.isEmpty {
            showToastMessage(AppMessages.selectNutritionTime.rawValue.localized)
        } else {
            return true
        }
        return false
    }
    
    var isUserFoodValid: Bool {
        
        for food in userFoods {
            if /*food.id != 0 &&*/ food.quantity == 0 {
                showToastMessage(AppMessages.enterValidFoodQuantity.rawValue.localized)
                return false
            }
        }
        return true
    }
    
    // MARK:- IBOutlets
    @IBOutlet weak var addNutritionTableView: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtnOutlt: UIButton!
    @IBOutlet weak var transitionView: TransitionButton!
    @IBOutlet weak var mealTextField: UITextField!
    @IBOutlet weak var selectMealLabel: UILabel!
    
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()

        let currentDate = Date()
        self.timeText = currentDate.stringFormDate(.Hmm)
        self.serverDateText = currentDate.stringFormDate(.yyyyMMdd)
        self.visibleDateText = currentDate.stringFormDate(.ddMMMYYYY)

        self.selectMealLabel.text = K_SELECTMEAL_WATER.localized
        self.mealTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icActivityplanGreendropdown"))
        self.mealTextField.rightViewMode = .always
        self.mealTextField.tintColor = UIColor.clear
        self.submitBtn.setTitle(K_SUBMIT_BUTTON.localized.uppercased(), for: .normal)
        userFoods.append(RecentFood())
        self.otherUserFood.append(RecentFood())
        self.waterFood.append(RecentFood())
        self.floatBtn.isHidden = true
        
        let nutritionFoodCellNibName = "NutritionFoodTableCell"
        let nutritionFoodCellNib = UINib(nibName: nutritionFoodCellNibName, bundle: nil)
        
        let nutritionTagCellNibName = "NutritionTagTableCell"
        let nutritionTagCellNib = UINib(nibName: nutritionTagCellNibName, bundle: nil)
        
        let recentNutritionFoodCellNibName = "RecentNutritionTableCell"
        let recentNutritionCellNib = UINib(nibName: recentNutritionFoodCellNibName, bundle: nil)
        
        let addActivityCellNibName = "AddActivityCell"
        let addActivityCellNib = UINib(nibName: addActivityCellNibName, bundle: nil)
        
        let attachmentHeaderViewCellNibName = "AttachmentHeaderViewCell"
        let attachmentHeaderViewCellNib = UINib(nibName: attachmentHeaderViewCellNibName, bundle: nil)
        
        let selectDateCellNibName = "SelectDateCell"
        let selectDateCellNib = UINib(nibName: selectDateCellNibName, bundle: nil)
        
        addNutritionTableView.register(nutritionFoodCellNib, forCellReuseIdentifier: nutritionFoodCellNibName)
        addNutritionTableView.register(nutritionTagCellNib, forCellReuseIdentifier: nutritionTagCellNibName)
        addNutritionTableView.register(recentNutritionCellNib, forCellReuseIdentifier: "recentNutritionTableCellID")
        addNutritionTableView.register(addActivityCellNib, forCellReuseIdentifier: "addActivityCellID")
        addNutritionTableView.register(attachmentHeaderViewCellNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
        addNutritionTableView.register(selectDateCellNib, forCellReuseIdentifier: "selectDateCellID")
        
        addNutritionTableView.dataSource = self
        addNutritionTableView.delegate = self
        
        self.submitBtn.gradient(withX: 0, withY: 0, cornerRadius: false)
        getNutritionData()
        
        mealTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_ADD_NUTRITION_SCREEN_TITLE.localized)
    }
    
    func getNutritionData() {
        getFoods()
        getRecentFoods()
        getMealSchedule()
    }
    
    func getFoods() {
        WebServices.getFoods(success: { [weak self] foods in
            guard let strongSelf = self else{
                return
            }
            strongSelf.foods = foods.filter({ (food) -> Bool in
                return food.name.uppercased() != K_WATER_TITLE.localized.uppercased()
            })
            let food = foods.filter({ (food) -> Bool in
                return food.name.uppercased() == K_WATER_TITLE.localized.uppercased()
            })
            strongSelf.waterID = food.first?.id
            }, failure: { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    func getRecentFoods() {
        WebServices.getRecentNutritions(success: { [weak self] recentFoods in
            
            guard let strongSelf = self else{
                return
            }
            strongSelf.recentFoods = recentFoods
            strongSelf.addNutritionTableView.reloadSections([1], with: .fade)
            }, failure: { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    func getMealSchedule() {
        WebServices.getMealSchedule(success: { [weak self] mealSchedules in
            guard let strongSelf = self else{
                return
            }
            let waterValue: [String: Any] = ["sch_id" : 0, "schedule_name": "Water"]
            let value = convertDictionaryIntoJSON(dic:waterValue)
            strongSelf.mealSchedules = mealSchedules
            if value != JSON.null, let waterData = MealSchedule.init(json: value) {
                strongSelf.mealSchedules.append(waterData)
            }
            strongSelf.setMealsArray()
            }, failure: { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    func setMealsArray() {
        for meal in mealSchedules {
            if let scheduleName = meal.scheduleName {
                meals.append(scheduleName)
            }
        }
    }
    
    func validateCurrentFoods() -> Bool {
        for food in userFoods {
            if food.id == 0 {
                
            } else if food.quantity == 0 {
                
            } else {
                continue
            }
            showToastMessage(AppMessages.enterCurrentFoodDetails.rawValue.localized)
            return false
        }
        return true
    }
    
    // MARK:- IBActions
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        guard isNutritionDataValid, let id = mealId else {
            return
        }
        let scheduleId = id == 0 ? 1 : id
        self.parameters = ["calories": totalNutrients.calories,
                           "fats": totalNutrients.fats,
                           "carbs": totalNutrients.carbs,
                           "proteins": totalNutrients.proteins,
                           "water": totalNutrients.water,
                           "meal_schedule": scheduleId,
                           "n_date": self.serverDateText,
                           "n_time": timeText]
        
        var meals = [[String : Any]]()
        for food in userFoods {
            guard let id = food.id else{
                return
            }
            //            if food.id == 0 {
            //                continue
            //            }
            
            let dict: [String : Any] = ["food": food.name,
                                        "food_id": id,
                                        "quantity": food.quantity,
                                        "unit": food.unit]
            meals.append(dict)
        }
        
        self.typeJSONArray(meals)
        
        self.transitionView.backgroundColor = UIColor.appColor
        self.transitionView.startAnimation()
        self.cancelBtnOutlt.isHidden = true
        self.submitBtn.isHidden = true
        WebServices.addNutritionData(parameters: parameters, success: { [weak self] _ in
            guard let strongSelf = self else{
                return
            }
            strongSelf.transitionView.stopAnimation(animationStyle: .normal, completion: {
                strongSelf.cancelBtnOutlt.isHidden = false
                strongSelf.submitBtn.isHidden = false
                strongSelf.transitionView.backgroundColor = UIColor.white
                strongSelf.navigationController?.popViewController(animated: true)
            })
            }, failure: {[weak self] error in
                guard let strongSelf = self else{
                    return
                }
                strongSelf.transitionView.stopAnimation(animationStyle: .normal, completion: {
                    strongSelf.cancelBtnOutlt.isHidden = false
                    strongSelf.submitBtn.isHidden = false
                    strongSelf.transitionView.backgroundColor = UIColor.white
                })
                showToastMessage(error.localizedDescription)
        })
    }
}

// MARK:- TableView DataSource Methods
extension AddNutritionVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? (userFoods.count + 3) : (recentFoods.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            if indexPath.row == userFoods.count {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "addActivityCellID", for: indexPath) as? AddActivityCell else {
                    fatalError("Cell not found")
                }
                
                cell.addActivityBtn.setTitle(K_ADD_FOOD_TITLE.localized, for: .normal)
                cell.addActivityBtn.layer.cornerRadius = 3
                cell.addActivityBtn.addTarget(self, action: #selector(addActivityBtnTapped), for: .touchUpInside)

                return cell
            } else if indexPath.row == (userFoods.count + 1) {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectDateCellID", for: indexPath) as? SelectDateCell else {
                    fatalError("Cell not found")
                }
                
                cell.separatorView.isHidden = true
                cell.selectDateLabel.text  = K_DATE_TEXT.localized
                cell.selectTimeLabel.text = K_TIME_TEXT.localized
                cell.selectDateTextField.borderStyle = .none
                cell.selectTimeTextField.borderStyle = .none
                
                cell.selectDateTextField.delegate = self
                cell.selectTimeTextField.delegate = self
                
                cell.selectDateTextField.text = visibleDateText
                cell.selectTimeTextField.text = timeText
                
                return cell
                
            } else if indexPath.row == (userFoods.count + 2) {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionTagTableCell", for: indexPath) as? NutritionTagTableCell else {
                    fatalError("Cell not found")
                }
                
                cell.tagsCollectionView.dataSource = self
                cell.tagsCollectionView.delegate = self
                
                return cell
                
            } else {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionFoodTableCell", for: indexPath) as? NutritionFoodTableCell else {
                    fatalError("Cell not found")
                }
                
                let userFood = userFoods[indexPath.row]
                if userFood.quantity == 0 {
                   cell.quantityTextField.placeholder = "\(userFood.quantity)"
                }else{
                  cell.quantityTextField.text = "\(userFood.quantity)"
                }
                cell.foodTextField.text = userFood.name
                cell.unitTextField.text = userFood.unit
                if let id = self.waterID, userFoods[indexPath.row].id == id{
                   cell.foodTitleLabel.text = K_ADD_WATER.localized
                }else{
                   cell.foodTitleLabel.text = K_ADD_FOOD.localized
                }
                
                cell.deleteButtonOutlt.addTarget(self, action: #selector(self.deleteBtnTapped(_:)), for: .touchUpInside)
                cell.quantityTextField.delegate = self
                cell.foodTextField.delegate = self

                cell.deleteButtonOutlt.alpha = CGFloat((indexPath.row != 0).rawValue)
                return cell
            }
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "recentNutritionTableCellID", for: indexPath) as? RecentNutritionTableCell else {
                fatalError("Cell not found")
            }
            
            cell.populate(with: recentFoods[indexPath.row])
            cell.addRecentNutritionBtn.addTarget(self, action: #selector(addRecentNutritionBtnTapped), for: .touchUpInside)
            
            return cell
            
        default:
            fatalError("Invalid section")
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let subviews = cell.subviews
        if subviews.count >= 3 {
            for subview in subviews {
                if subview != cell.contentView {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    @objc func addRecentNutritionBtnTapped(_ sender: UIButton) {
        
        guard let id = self.mealId, id != 0 else{
            showToastMessage(AppMessages.selectAMeal.rawValue.localized)
            return
        }
        
        guard let indexPath = sender.tableViewIndexPathIn(addNutritionTableView) else {
            return
        }
        
        let recentFood = recentFoods[indexPath.row]
        if let waterID = self.waterID, (id == waterID && recentFood.id != waterID) {
            showToastMessage(AppMessages.selectFoodAsWater.rawValue.localized)
        }else if let waterID = self.waterID, (id != waterID && recentFood.id == waterID) {
            showToastMessage(AppMessages.selectedMealTypeAsWater.rawValue.localized)
        }else{
           self.addRecentFood(recentFood: recentFood)
        }
    }
    
    func addRecentFood(recentFood: RecentFood){
        if userFoods.count == 1, userFoods.first?.id == nil{
            userFoods = [recentFood]
            let lastIndexPath = IndexPath(row: (userFoods.count - 1), section: 0)
            addNutritionTableView.reloadRows(at: [lastIndexPath], with: .fade)
        }else{
            userFoods.append(recentFood)
            let lastIndexPath = IndexPath(row: (userFoods.count - 1), section: 0)
            addNutritionTableView.insertRows(at: [lastIndexPath], with: .fade)
        }
        calculateNutrients(userFood: self.userFoods, activitySelectionType: self.activityTypeSelection)
    }
    
    @objc func addActivityBtnTapped(_ sender: UIButton) {
        guard validateCurrentFoods() else {
            return
        }
        
        let indexPath = IndexPath(row: userFoods.count, section: 0)
        userFoods.append(RecentFood())
        addNutritionTableView.insertRows(at: [indexPath], with: .fade)
    }
}


// MARK:- TableView Delegate Methods
//==================================

extension AddNutritionVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let sectionHeaderViewCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as?
            AttachmentHeaderViewCell else {
                fatalError("Table header not found")
        }
        
        sectionHeaderViewCell.headerLabelLeading.constant = 25
        sectionHeaderViewCell.headerTitle.font = AppFonts.sanProSemiBold.withSize(16)
        sectionHeaderViewCell.headerTitle.text = K_MY_RECENT.localized
        sectionHeaderViewCell.cellBackgroundView.backgroundColor = UIColor.headerColor
        let image = !self.recentBtnTapped ? #imageLiteral(resourceName: "icLogbookUparrowGreen") : #imageLiteral(resourceName: "icAppointmentDownarrow")
        sectionHeaderViewCell.dropDownBtn.setImage(image, for: .normal)
        sectionHeaderViewCell.dropDownBtn.addTarget(self, action: #selector(dropDownTapped), for: .touchUpInside)
        
        return sectionHeaderViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNormalMagnitude
        default:
            let heightForHeader = (self.recentFoods.isEmpty) ? CGFloat.leastNormalMagnitude : 50
            return heightForHeader
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    @objc func dropDownTapped(_ sender: UIButton) {
        
        guard let cell = sender.getTableViewHeaderFooterView as? AttachmentHeaderViewCell else{
            return
        }
        self.recentBtnTapped = !self.recentBtnTapped
        UIView.animate(withDuration: 0.3, animations: {
            let angle = (180.0 * CGFloat(Double.pi)) / 180.0
            cell.dropDownBtn.imageView?.transform = CGAffineTransform(rotationAngle: angle)
        })
        self.addNutritionTableView.reloadSections([1], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
        case 0:
            
            switch indexPath.row {
                
            case userFoods.count:
                if let id = self.mealId, id == 0 {
                    return CGFloat.leastNormalMagnitude
                }
                return 80
            case (userFoods.count + 1):
                return 90
            case (userFoods.count + 2):
                return 130
            default:
                return UITableViewAutomaticDimension
            }
        case 1:
            let height = (self.recentBtnTapped) ? CGFloat.leastNormalMagnitude : 60
            return height
            
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
}

// MARK:- CollectionView DataSource Methods
extension AddNutritionVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NutritionTagCollectionCell", for: indexPath) as? NutritionTagCollectionCell else {
            fatalError("Cell not found")
        }
        
        var nutrientTypeText = ""
        var nutrientUnitText = ""
        var nutrientValue = 0
        
        switch indexPath.item {
        case 0:
            nutrientTypeText = K_CALORIES_BUTTON.localized
            nutrientUnitText = K_CALORIES_UNIT.localized
            nutrientValue = totalNutrients.calories
        case 1:
            nutrientTypeText = K_CARB_TITLE.localized
            nutrientUnitText = K_GRAM_TITLE.localized
            nutrientValue = totalNutrients.carbs
        case 2:
            nutrientTypeText = K_FATS_TITLE.localized
            nutrientUnitText = K_GRAM_TITLE.localized
            nutrientValue = totalNutrients.fats
        case 3:
            nutrientTypeText = K_PROTIENS_TITLE.localized
            nutrientUnitText = K_GRAM_TITLE.localized
            nutrientValue = totalNutrients.proteins
        case 4:
            nutrientTypeText = K_WATER_TITLE.localized
            nutrientUnitText = K_LITRE_TITLE.localized
            nutrientValue = totalNutrients.water
        default:
            break
        }
        
        let attributedString = NSMutableAttributedString(string: "\(nutrientTypeText) : \(nutrientValue) \(nutrientUnitText)")
        attributedString.addAttribute(NSAttributedStringKey.font, value: AppFonts.sansProRegular.withSize(10), range: NSRange(location: 0, length: nutrientTypeText.count + 2))
        
        cell.tagLabel.attributedText = attributedString
        cell.tagLabel.layer.cornerRadius = 4
        
        return cell
    }
}

// MARK:- CollectionView Delegate FlowLayout Methods
extension AddNutritionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var nutrientTypeText = ""
        var nutrientUnitText = ""
        var nutrientValue = 0
        
        switch indexPath.item {
            
        case 0:
            nutrientTypeText = K_CALORIES_BUTTON.localized
            nutrientUnitText = K_CALORIES_UNIT.localized
            nutrientValue = totalNutrients.calories
            
        case 1:
            nutrientTypeText = K_CARB_TITLE.localized
            nutrientUnitText = K_GRAM_TITLE.localized
            nutrientValue = totalNutrients.carbs
            
        case 2:
            nutrientTypeText = K_FATS_TITLE.localized
            nutrientUnitText = K_GRAM_TITLE.localized
            nutrientValue = totalNutrients.fats
            
        case 3:
            nutrientTypeText = K_PROTIENS_TITLE.localized
            nutrientUnitText = K_GRAM_TITLE.localized
            nutrientValue = totalNutrients.proteins
            
        case 4:
            nutrientTypeText = K_WATER_TITLE.localized
            nutrientUnitText = K_LITRE_TITLE.localized
            nutrientValue = totalNutrients.water
            
        default:
            break
        }
        
        let text = "\(nutrientTypeText) : \(nutrientValue) \(nutrientUnitText)"
        let textWidth = text.widthWithConstrainedHeight(height: 35, font: AppFonts.sanProSemiBold.withSize(12))
        return CGSize(width: (textWidth + 20), height: 35)
    }
}

// MARK: - EXTENSION FOR TEXTVIEW DELEGATES METHODS
extension AddNutritionVC: SelectFoodDelegate {
    
    func selected(_ food: Food) {
        guard let indexPath = lastFoodIndexPath else {
            return
        }
        guard let cell = addNutritionTableView.cellForRow(at: indexPath) as? NutritionFoodTableCell else {
            return
        }
        
        var dictionary = JSONDictionary()
        
        dictionary["food_id"]       = food.id
        dictionary["food"]          = food.name
        dictionary["unit"]          = food.unit
        dictionary["water"]         = food.water
        dictionary["calories"]      = food.calories
        dictionary["carbs"]         = food.carbs
        dictionary["fats"]          = food.fats
        dictionary["proteins"]      = food.proteins
        dictionary["quantity"]      = 0
        
        let json = JSON(dictionary)
        
        guard let recentFood = RecentFood(json: json) else {
            return
        }
        cell.foodTextField.text = recentFood.name
        cell.unitTextField.text = recentFood.unit
        if recentFood.quantity == 0{
            cell.quantityTextField.placeholder = "\(recentFood.quantity)"
        }else {
            cell.quantityTextField.text = "\(recentFood.quantity)"
        }
        
        userFoods[indexPath.row] = recentFood
        calculateNutrients(userFood: self.userFoods, activitySelectionType: self.activityTypeSelection)
        lastFoodIndexPath = nil
    }
}

// MARK:- TextField Delegate Methods
//==================================
extension AddNutritionVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        guard let indexPath = textField.tableViewIndexPathIn(addNutritionTableView) else {
            return true
        }
        guard let cell = addNutritionTableView.cellForRow(at: indexPath) as? NutritionFoodTableCell else {
            return true
        }
        
        if textField === cell.foodTextField {
            if let id = self.mealId, id != 0 {
                let searchScene = SearchFoodVC.instantiate(fromAppStoryboard: .Nutrition)
                searchScene.foods = foods
                searchScene.selectedFoodId = userFoods[indexPath.row].id
                searchScene.delegate = self
                
                lastFoodIndexPath = indexPath
                navigationController?.pushViewController(searchScene, animated: true)
                return false
            }else {
                return false
            }
        }else if textField === cell.unitTextField {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField === mealTextField {
            openMultiPicker()
            return
        }
        
        guard let indexPath = textField.tableViewIndexPathIn(addNutritionTableView) else {
            return
        }
        
        switch indexPath.row {
            
        case (userFoods.count + 1):
            openDateTimePicker(for: indexPath)
            
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Return false if user tries to delete when textfield is empty
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount) {
            return false
        }
        
        let userEnteredString = textField.text ?? ""
        let newString = (userEnteredString as NSString).replacingCharacters(in: range, with: string) as String
        
        guard let indexPath = textField.tableViewIndexPathIn(addNutritionTableView) else {
            return true
        }
        
        guard let cell = addNutritionTableView.cellForRow(at: indexPath) as? NutritionFoodTableCell else {
            return false
        }
        
        if cell.quantityTextField === textField {
            if newString.count > 3 {
                return false
            }

            userFoods[indexPath.row].quantity = Int(newString) ?? 0
            calculateNutrients(userFood: userFoods, activitySelectionType: self.activityTypeSelection)
            
        } else if cell.foodTextField === textField {
            userFoods[indexPath.row].name = newString
            
        } else if mealTextField === textField {
            //foods[indexPath.row].meal = newString
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard (textField.text == nil) || (textField.text == "") else {
            return
        }
        
        guard let indexPath = textField.tableViewIndexPathIn(addNutritionTableView) else {
            return
        }
        
        guard let cell = addNutritionTableView.cellForRow(at: indexPath) as? NutritionFoodTableCell else {
            return
        }
        
        if cell.quantityTextField === textField {
            userFoods[indexPath.row].quantity = 0
        }
        
        calculateNutrients(userFood: userFoods, activitySelectionType: self.activityTypeSelection)
        //textField.text = "0"
        
    }
    
   fileprivate func calculateNutrients(userFood: [RecentFood], activitySelectionType: ActivityTypeSelection) {
        totalNutrients = TotalNutrients()
        
        for food in userFood {
            let quantity = food.quantity
            
            let calorie = (food.calories * quantity)
            totalNutrients.calories += calorie
            
            let fats = (food.fats * quantity)
            totalNutrients.fats += fats
            
            let proteins = (food.proteins * quantity)
            totalNutrients.proteins += proteins
            
            let carbs = (food.carbs * quantity)
            totalNutrients.carbs += carbs
            
            let waterQuantity = activitySelectionType == .water ? (food.water + quantity) : 0
            totalNutrients.water += waterQuantity
        }
        
        let cell = addNutritionTableView.cellForRow(at: IndexPath(row: (userFoods.count + 2), section: 0)) as? NutritionTagTableCell
        cell?.tagsCollectionView.reloadData()
    }
    
    @objc func deleteBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.addNutritionTableView) else{
            return
        }
        
        self.userFoods.remove(at: indexPath.row)
        self.addNutritionTableView.deleteRows(at: [indexPath], with: .automatic)
        self.calculateNutrients(userFood: self.userFoods, activitySelectionType: self.activityTypeSelection)
    }
    
    func openMultiPicker() {
        MultiPicker.noOfComponent =  1
        
        MultiPicker.openPickerIn(mealTextField, firstComponentArray: meals, secondComponentArray: [], firstComponent: mealTextField.text, secondComponent: "", titles: ["Meals"], doneBlock: { (value, _, index, _) in
            
            self.mealTextField.text = value
            
            if let unwrappedIndex = index , let id = self.mealSchedules[unwrappedIndex].schId{
                self.mealName = self.mealSchedules[unwrappedIndex].scheduleName ?? ""
                self.mealId = id
            }
            
            if let id = self.mealId, id == 0{
                if self.waterFood[0].id != 0, let waterID = self.waterID {
                    var dictionary = JSONDictionary()
                    
                    dictionary["food_id"]       = waterID
                    dictionary["food"]          = self.mealName
                    dictionary["unit"]          = "ltr"
                    dictionary["calories"]      = 0
                    dictionary["carbs"]         = 0
                    dictionary["fats"]          = 0
                    dictionary["water"]         = 0
                    dictionary["proteins"]      = 0
                    dictionary["quantity"]      = 0
                    
                    let json = JSON(dictionary)
                    
                    guard let recentFood = RecentFood(json: json) else {
                        return
                    }
                    self.waterFood = [recentFood]
                }
                self.activityTypeSelection = .water
                self.otherUserFood = self.userFoods
                self.userFoods = self.waterFood
            }else{
                if let id = self.userFoods[0].id, let waterID = self.waterID, id == waterID {
                    self.waterFood = self.userFoods
                    self.activityTypeSelection = .water
                }
                self.activityTypeSelection = .other
                self.userFoods = self.otherUserFood
            }
            
            self.calculateNutrients(userFood: self.userFoods, activitySelectionType: self.activityTypeSelection)
            self.addNutritionTableView.reloadData()
        })
    }
    
    func openDateTimePicker(for indexPath: IndexPath) {
        
        guard let cell = addNutritionTableView.cellForRow(at: indexPath) as? SelectDateCell else {
            return
        }
        
        if cell.selectDateTextField.isFirstResponder{
            
            DatePicker.openPicker(in: cell.selectDateTextField, currentDate: Date(), minimumDate: nil, maximumDate: Date(), pickerMode: UIDatePickerMode.date, doneBlock: { date in
                
                self.visibleDateText = date.stringFormDate(.ddMMMYYYY)
                self.serverDateText = date.stringFormDate(.yyyyMMdd)
                cell.selectDateTextField.text = self.visibleDateText
            })
            
        } else {
            
            DatePicker.openPicker(in: cell.selectTimeTextField, currentDate: Date(), minimumDate: nil, maximumDate: Date(), pickerMode: UIDatePickerMode.time, doneBlock: { time in
                
                let timeStr =  time.stringFormDate(.Hmm)
                cell.selectTimeTextField.text = timeStr
                self.timeText = timeStr
            })
        }
    }
    
    fileprivate func typeJSONArray(_ dic : [[String : Any]]){
        
        do {
            
            let typejsonArray = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            guard let typeJSONString = String(data: typejsonArray, encoding: String.Encoding.utf8) else {return}
            self.parameters["meal"] = typeJSONString as AnyObject?
            
        }catch{
            //printlnDebug(error.localizedDescription)
        }
    }
}
