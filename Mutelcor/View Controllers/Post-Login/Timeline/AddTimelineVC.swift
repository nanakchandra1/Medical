//
//  AddTimelineVC.swift
//  Mutelcor
//
//  Created by on 16/01/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit


struct AddTimelineData {
    
    var timelineImage: UIImage?
    var date: Date = Date()
    var time: Date = Date()
    init() {
    }
}

class AddTimelineVC: BaseViewController {
    
//    MARk:- Proporties
//    =================
    var timeLineImage: UIImage?
    var timelineData = AddTimelineData()
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var addTimelineTableView: UITableView!
    @IBOutlet weak var buttonBackgroundView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
//    MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_UPLOAD_IMAGE_TITLE.localized)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.submitButton.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    
    
//    MARK:- IBAction
//    ================
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        self.addPhoto()
    }
}

//MARK:- UITableViewDataSource Method
//====================================
extension AddTimelineVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineImageCell", for: indexPath) as? TimeLineImageCell else{
                fatalError("cell not found!")
            }
            
            cell.populateData(timelineImgae: self.timelineData)
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectDateCellID", for: indexPath) as? SelectDateCell else{
                fatalError("cell not found!")
            }
            
            cell.selectDateTextField.delegate = self
            cell.selectTimeTextField.delegate = self
            
            cell.populateTimelineData(timeLineData: self.timelineData)
            
            return cell
            
        default:
            fatalError("cell not found!")
            
        }
    }
}

//MARK:- UITableViewDelegate Method
//==================================
extension AddTimelineVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let datCellHeight: CGFloat = 85
        switch indexPath.row {

        case 0:
            let navigationBarHeight: CGFloat = (self.navigationController?.navigationBar.frame.height)! + 20
            let buttonBackgroundHeight: CGFloat = self.buttonBackgroundView.frame.height
            let cellHeight = UIDevice.getScreenHeight - (buttonBackgroundHeight + datCellHeight + navigationBarHeight)
           return cellHeight
        case 1:
            return CGFloat(datCellHeight)
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return CGFloat.leastNormalMagnitude
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 20
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//        guard let foooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "personalInfoHeaderCell") as? PersonalInfoHeaderCell else {
//            fatalError("HeaderView Not Found!")
//        }
//        foooterView.populateFooterView(section: section)
//
//        return foooterView
//    }
}

//MARK:- UITextFieldDelegate Methods
//===================================
extension AddTimelineVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard let indexPath = textField.tableViewIndexPathIn(self.addTimelineTableView) else{
            return
        }
        
        guard let cell = self.addTimelineTableView.cellForRow(at: indexPath) as? SelectDateCell else{
            return
        }
        
        DatePicker.openPicker(in: textField, currentDate: Date(), minimumDate: nil, maximumDate: Date(), pickerMode: UIDatePickerMode.date, doneBlock: { (date) in
            
            if cell.selectDateTextField.isFirstResponder{
                self.timelineData.date = date
            }else{
                self.timelineData.time = date
            }
        })
        self.addTimelineTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK:- Methods
//==============
extension AddTimelineVC {
    
    fileprivate func setupUI(){
        
        self.timelineData.timelineImage = self.timeLineImage
        self.timelineData.date = Date()
        self.timelineData.time = Date()
        self.floatBtn.isHidden = true
        self.isNavigationBarButton = false
        self.addTimelineTableView.delegate = self
        self.addTimelineTableView.dataSource = self

        self.cancelButton.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
        self.cancelButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
        self.cancelButton.setTitle(K_CANCEL_BUTTON.localized.uppercased(), for: UIControlState.normal)
        self.cancelButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.submitButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
        self.submitButton.setTitle(K_SUBMIT_BUTTON.localized.uppercased(), for: UIControlState.normal)
        self.submitButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        let selectDateCell = UINib(nibName: "SelectDateCell", bundle: nil)
        self.addTimelineTableView.register(selectDateCell, forCellReuseIdentifier: "selectDateCellID")
    }
    
    fileprivate func addPhoto(){
        
        var param = [String: Any]()
        param["date"] = self.timelineData.date.stringFormDate(.yyyyMMdd)
        param["time"] = self.timelineData.time.stringFormDate(.Hmm)

        var imgData : Data?
        
        if let image = self.timelineData.timelineImage {
            imgData = UIImageJPEGRepresentation(image, 0.5)
        }
        var img: JSONDictionary = [:]
        if let imageData = imgData {
            img["image"] = imageData
        }

        WebServices.addImage(parameters: param, imageData: img, success: { (success) in
            debugPrint("success")
            if success{
                let dashboardScene = TimelineVC.instantiate(fromAppStoryboard: .Timeline)
                self.navigationController?.pushViewController(dashboardScene, animated: true)
                
            }
        }) { (error) in
            debugPrint(error)
        }

    }
}

//MARK:- Cell
class TimeLineImageCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellImageView.image = nil
    }
    
    func populateData(timelineImgae: AddTimelineData?){
        
        guard let data = timelineImgae else{
            return
        }
        self.cellImageView.image = data.timelineImage
    }
}
