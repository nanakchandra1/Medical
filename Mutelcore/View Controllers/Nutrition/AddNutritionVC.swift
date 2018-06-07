//
//  AddAddNutritionVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 22/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddNutritionVC: BaseViewController {
    
    // MARK:- Total Nutrient Structure
    struct TotalNutrients {
        var calories = 0
        var carbs = 0
        var fats = 0
        var proteins = 0
    }
    
    // MARK:- Properties
    var userFoods: [RecentFood] = []
    var foods: [Food] = []
    var recentFoods: [RecentFood] = []
    var mealSchedules: [MealSchedule] = []
    var lastFoodIndexPath: IndexPath?
    var totalNutrients = TotalNutrients()
    var meals = [String]()
    var parameters = [String : Any]()
    
    var mealId: Int?
    var mealName: String?
    var water = 0
    
    var dateText = ""
    var timeText = ""
    var recentBtnTapped = false
    
    var isNutritionDataValid: Bool {
        
        if mealId == nil {
            showToastMessage("Please select a Meal")
        } else if water == 0 {
            showToastMessage("Please enter valid water amount")
        } else if !isUserFoodValid {
            
        } else if dateText.isEmpty {
            showToastMessage("Please select Nutrition Date")
        } else if timeText.isEmpty {
            showToastMessage("Please select Nutrition Time")
        } else {
            return true
        }
        return false
    }
    
    var isUserFoodValid: Bool {
        for food in userFoods {
            if food.id != 0 && food.quantity == 0 {
                showToastMessage("Please enter valid food quantity")
                return false
            }
        }
        return true
    }
    
    // MARK:- IBOutlets
    @IBOutlet weak var addNutritionTableView: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var waterTextField: UITextField!
    @IBOutlet weak var mealTextField: UITextField!
    
    // MARK:- View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mealTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
        self.mealTextField.rightViewMode = .always
        
        userFoods.append(RecentFood())
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
        addNutritionTableView.register(recentNutritionCellNib, forCellReuseIdentifier: recentNutritionFoodCellNibName)
        addNutritionTableView.register(addActivityCellNib, forCellReuseIdentifier: "addActivityCellID")
        addNutritionTableView.register(attachmentHeaderViewCellNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
        addNutritionTableView.register(selectDateCellNib, forCellReuseIdentifier: "selectDateCellID")
        
        addNutritionTableView.dataSource = self
        addNutritionTableView.delegate = self
        
        self.submitBtn.gradient(withX: 0, withY: 0, cornerRadius: false)
        getNutritionData()
        
        waterTextField.delegate = self
        mealTextField.delegate = self
        
        waterTextField.text = "0"
        waterTextField.setRightViewText("ltr", target: self, selector: #selector(rightViewTapped))
        
        if #available(iOS 10.0, *) {
            waterTextField.keyboardType = .asciiCapableNumberPad
        } else {
            waterTextField.keyboardType = .numberPad
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .BackBtn
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Add Nutrition", 2, 3)
        
        self.navigationControllerOn = .dashboard
    }
    
    // MARK:- Public Methods
    @objc private func rightViewTapped(_ sender: UITapGestureRecognizer) {
        waterTextField.becomeFirstResponder()
    }
    
    func getNutritionData() {
        getFoods()
        getRecentFoods()
        getMealSchedule()
    }
    
    func getFoods() {
        WebServices.getFoods(parameters: JSONDictionary(), success: { [weak self] foods in
            self?.foods = foods
            }, failure: { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    func getRecentFoods() {
        WebServices.getRecentNutritions(parameters: JSONDictionary(), success: { [weak self] recentFoods in
            self?.recentFoods = recentFoods
            self?.addNutritionTableView.reloadSections([1], with: .fade)
            }, failure: { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    func getMealSchedule() {
        WebServices.getMealSchedule(parameters: JSONDictionary(), success: { [weak self] mealSchedules in
            self?.mealSchedules = mealSchedules
            self?.setMealsArray()
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
            showToastMessage("Please enter current food details")
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
        
        CommonClass.dateFormatter.dateFormat = DateFormat.ddMMMYYYY.rawValue
        var dateText = self.dateText
        if let date = CommonClass.dateFormatter.date(from: dateText) {
            dateText = CommonClass.dateFormatter.string(from: date)
        }
        
        self.parameters = ["calories": totalNutrients.calories,
                                          "fats": totalNutrients.fats,
                                          "carbs": totalNutrients.carbs,
                                          "proteins": totalNutrients.proteins,
                                          "water": water,
                                          "meal_schedule": id,
                                          "n_date": dateText,
                                          "n_time": timeText]
        
        var meals = [[String : Any]]()
        for food in userFoods {
            if food.id == 0 {
                continue
            }
            
            let dict: [String : Any] = ["food": food.name,
                                        "food_id": food.id,
                                        "quantity": food.quantity,
                                        "unit": food.unit]
            
            meals.append(dict)
        }
        
        self.typeJSONArray(meals)

        WebServices.addNutritionData(parameters: parameters, success: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
            }, failure: { error in
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
                
                cell.addActivityBtn.setTitle(" Add Food", for: .normal)
                cell.addActivityBtn.layer.cornerRadius = 3
                cell.addActivityBtn.addTarget(self, action: #selector(addActivityBtnTapped), for: .touchUpInside)
                
                //cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, UIScreen.main.bounds.width)
                return cell
                
            } else if indexPath.row == (userFoods.count + 1) {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectDateCellID", for: indexPath) as? SelectDateCell else {
                    fatalError("Cell not found")
                }
                
                cell.separatorView.isHidden = true
                cell.selectDateLabel.text  = "Date"
                cell.selectTimeLabel.text = "Time"
                cell.selectDateTextField.borderStyle = .none
                cell.selectTimeTextField.borderStyle = .none
                cell.selectDateTextField.delegate = self
                cell.selectTimeTextField.delegate = self
                
                cell.selectDateTextField.text = dateText
                cell.selectTimeTextField.text = timeText
                
                //cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, UIScreen.main.bounds.width)
                return cell
                
            } else if indexPath.row == (userFoods.count + 2) {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionTagTableCell", for: indexPath) as? NutritionTagTableCell else {
                    fatalError("Cell not found")
                }
                
                cell.tagsCollectionView.dataSource = self
                cell.tagsCollectionView.delegate = self
                
                //cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, UIScreen.main.bounds.width)
                return cell
                
            } else {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionFoodTableCell", for: indexPath) as? NutritionFoodTableCell else {
                    fatalError("Cell not found")
                }
                
                
                let userFood = userFoods[indexPath.row]
                
                cell.quantityTextField.text = "\(userFood.quantity)"
                cell.foodTextField.text = userFood.name
                cell.unitTextField.text = userFood.unit
                
                cell.quantityTextField.delegate = self
                cell.foodTextField.delegate = self
                
                if indexPath.row == 0{
                    
                  cell.deleteButtonOutlt.isHidden = true
                }else{
                    
                   cell.deleteButtonOutlt.isHidden = false
                }
                
                cell.deleteButtonOutlt.addTarget(self, action: #selector(self.deleteBtnTapped(_:)), for: .touchUpInside)
                
                //cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, UIScreen.main.bounds.width)
                return cell
            }
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentNutritionTableCell", for: indexPath) as? RecentNutritionTableCell else {
                fatalError("Cell not found")
            }
            
            cell.populate(with: recentFoods[indexPath.row])
            cell.addRecentNutritionBtn.addTarget(self, action: #selector(addRecentNutritionBtnTapped), for: .touchUpInside)
            //cell.separatorInset = .zero
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
                    //break
                }
            }
        }
    }
    
    func addRecentNutritionBtnTapped(_ sender: UIButton) {
        guard let indexPath = sender.tableViewIndexPathIn(addNutritionTableView) else {
            return
        }
        
        let recentFood = recentFoods[indexPath.row]
        userFoods.append(recentFood)
        
        let lastIndexPath = IndexPath(row: (userFoods.count - 1), section: 0)
        addNutritionTableView.insertRows(at: [lastIndexPath], with: .fade)
        
        calculateNutrients()
    }
    
    func addActivityBtnTapped(_ sender: UIButton) {
        guard validateCurrentFoods() else {
            return
        }
        
        let indexPath = IndexPath(row: userFoods.count, section: 0)
        userFoods.append(RecentFood())
        addNutritionTableView.insertRows(at: [indexPath], with: .fade)
    }
    
}

// MARK:- TableView Delegate Methods
extension AddNutritionVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let sectionHeaderViewCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as?
            AttachmentHeaderViewCell else {
                fatalError("Table header not found")
        }
        
        sectionHeaderViewCell.headerLabelLeading.constant = 25
        sectionHeaderViewCell.headerTitle.font = AppFonts.sanProSemiBold.withSize(16)
        sectionHeaderViewCell.headerTitle.text = "My Recent"
        sectionHeaderViewCell.backgroundColor = UIColor.headerColor
        
        sectionHeaderViewCell.dropDownBtn.addTarget(self, action: #selector(dropDownTapped), for: .touchUpInside)
        
        return sectionHeaderViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func dropDownTapped(_ sender: UIButton) {
        
        self.recentBtnTapped = !self.recentBtnTapped
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
                return 80
                
            case (userFoods.count + 1):
                return 90
                
            case (userFoods.count + 2):
                return 130
                
            default:
                return UITableViewAutomaticDimension
            }
            
        case 1:
            
            if self.recentBtnTapped{
                
                return 0
            }else{
                
               return 60
            }
            
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
            nutrientTypeText = "Calories"
            nutrientUnitText = "Cal"
            nutrientValue = totalNutrients.calories
            
        case 1:
            nutrientTypeText = "Carb"
            nutrientUnitText = "g"
            nutrientValue = totalNutrients.carbs
            
        case 2:
            nutrientTypeText = "Fats"
            nutrientUnitText = "g"
            nutrientValue = totalNutrients.fats
            
        case 3:
            nutrientTypeText = "Proteins"
            nutrientUnitText = "g"
            nutrientValue = totalNutrients.proteins
            
        case 4:
            nutrientTypeText = "Water"
            nutrientUnitText = "ltr"
            nutrientValue = water
            
        default:
            break
        }
        
        let attributedString = NSMutableAttributedString(string: "\(nutrientTypeText) : \(nutrientValue) \(nutrientUnitText)")
        attributedString.addAttribute(NSFontAttributeName, value: AppFonts.sansProRegular.withSize(12), range: NSRange(location: 0, length: nutrientTypeText.characters.count))
        
        cell.tagLabel.attributedText = attributedString
        cell.tagLabel.layer.cornerRadius = 4
        
        return cell
    }
    
}

// MARK:- CollectionView Delegate Methods
extension AddNutritionVC: UICollectionViewDelegate {
    
    
    
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
            nutrientTypeText = "Calories"
            nutrientUnitText = "Cal"
            nutrientValue = totalNutrients.calories
            
        case 1:
            nutrientTypeText = "Carb"
            nutrientUnitText = "g"
            nutrientValue = totalNutrients.carbs
            
        case 2:
            nutrientTypeText = "Fats"
            nutrientUnitText = "g"
            nutrientValue = totalNutrients.fats
            
        case 3:
            nutrientTypeText = "Proteins"
            nutrientUnitText = "g"
            nutrientValue = totalNutrients.proteins
            
        case 4:
            nutrientTypeText = "Water"
            nutrientUnitText = "ltr"
            nutrientValue = water
            
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
        
        userFoods[indexPath.row] = recentFood
        calculateNutrients()
        lastFoodIndexPath = nil
    }
    
}

// MARK:- TextField Delegate Methods
extension AddNutritionVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard !textField.isAskingCanBecomeFirstResponder else {
            return false
        }
        
        guard let indexPath = textField.tableViewIndexPathIn(addNutritionTableView) else {
            return true
        }
        guard let cell = addNutritionTableView.cellForRow(at: indexPath) as? NutritionFoodTableCell else {
            return true
        }
        
        if textField === cell.foodTextField {
            
            let searchScene = SearchFoodVC.instantiate(fromAppStoryboard: .Nutrition)
            searchScene.foods = foods
            searchScene.selectedFoodId = userFoods[indexPath.row].id
            searchScene.delegate = self
            
            lastFoodIndexPath = indexPath
            navigationController?.pushViewController(searchScene, animated: true)
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
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount) {
            return false
        }
        
        let userEnteredString = textField.text ?? ""
        let newString = (userEnteredString as NSString).replacingCharacters(in: range, with: string) as String
        
        if waterTextField === textField {
            if newString.characters.count > 3 {
                return false
            }
            water = Int(newString) ?? 0
            
            let cell = addNutritionTableView.cellForRow(at: IndexPath(row: (userFoods.count + 2), section: 0)) as? NutritionTagTableCell
            cell?.tagsCollectionView.reloadItems(at: [IndexPath(row: 4, section: 0)])
        }
        
        guard let indexPath = textField.tableViewIndexPathIn(addNutritionTableView) else {
            return true
        }
        
        guard let cell = addNutritionTableView.cellForRow(at: indexPath) as? NutritionFoodTableCell else {
            return false
        }
        
        if cell.quantityTextField === textField {
            if newString.characters.count > 3 {
                return false
            }
            userFoods[indexPath.row].quantity = Int(newString) ?? 0
            
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
        
        if waterTextField === textField {
            water = 0
            textField.text = "0"
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
        
        if userFoods[indexPath.row].id != 0 {
            calculateNutrients()
        }
        textField.text = "0"
    }
    
    func calculateNutrients() {
        totalNutrients = TotalNutrients()
        
        for food in userFoods {
            let quantity = food.quantity
            
            let calorie = (food.calories * quantity)
            totalNutrients.calories += calorie
            
            let fats = (food.fats * quantity)
            totalNutrients.fats += fats
            
            let proteins = (food.proteins * quantity)
            totalNutrients.proteins += proteins
            
            let carbs = (food.carbs * quantity)
            totalNutrients.carbs += carbs
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
        self.calculateNutrients()
    }
    
    func openMultiPicker() {
        MultiPicker.noOfComponent =  1
        
        MultiPicker.openPickerIn(mealTextField, firstComponentArray: meals, secondComponentArray: [], firstComponent: mealTextField.text, secondComponent: "", titles: ["Meals"], doneBlock: { (value, _, index, _) in
            
            self.mealTextField.text = value
            
            if let unwrappedIndex = index {
                self.mealName = self.mealSchedules[unwrappedIndex].scheduleName ?? ""
                self.mealId = self.mealSchedules[unwrappedIndex].schId ?? 0
            }
        })
    }
    
    func openDateTimePicker(for indexPath: IndexPath) {
        
        guard let cell = addNutritionTableView.cellForRow(at: indexPath) as? SelectDateCell else {
            return
        }
        
        if cell.selectDateTextField.isFirstResponder{
            
            DatePicker.openPicker(in: cell.selectDateTextField, currentDate: Date(), minimumDate: nil, maximumDate: Date(), pickerMode: UIDatePickerMode.date, doneBlock: { date in
                
                let dateStr = date.stringFormDate(DateFormat.ddMMMYYYY.rawValue)
                cell.selectDateTextField.text = dateStr
                self.dateText = dateStr ?? ""
                self.addNutritionTableView.reloadData()
            })
            
        } else {
            
            DatePicker.openPicker(in: cell.selectTimeTextField, currentDate: Date(), minimumDate: nil, maximumDate: Date(), pickerMode: UIDatePickerMode.time, doneBlock: { time in
                
                let timeStr =  time.stringFormDate(DateFormat.HHmm.rawValue)
                cell.selectTimeTextField.text = timeStr
                self.timeText = timeStr ?? ""
                self.addNutritionTableView.reloadData()
            })
        }
    }
    
    fileprivate func typeJSONArray(_ dic : [[String : Any]]){
        
        do {
            
            let typejsonArray = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            guard let typeJSONString = String(data: typejsonArray, encoding: String.Encoding.utf8) else {return}
            
            self.parameters["meal"] = typeJSONString as AnyObject?
            
        }catch{
            
            printlnDebug(error.localizedDescription)
        }
    }
}

