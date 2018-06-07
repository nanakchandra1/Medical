//
//  AddMeasurementVCViewController.swift
//  Mutelcor
//
//  Created by on 30/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import MobileCoreServices
import TransitionButton

protocol RefreshData: class{
    func refreshScreen()
}

class AddMeasurementVC: BaseViewControllerWithBackButton {
    
    enum IsFileAttached {
        case yes
        case no
    }
    
    enum AttachmentType {
        case image
        case pdf
        case none
    }
    
    enum AccessMediaTypes {
        case camera
        case gallery
    }
    
    //    MARK:- Proporties
    //    =================
    fileprivate var accessMediaTypes: AccessMediaTypes = .camera
    fileprivate var isFileAttached: IsFileAttached = IsFileAttached.no
    fileprivate var attachmentType: AttachmentType = AttachmentType.none
    fileprivate var noOfAttachments = [Any]()
    fileprivate var noOfImages = [UIImage]()
    fileprivate var noOFPdfs = [String]()
    var selectedVitalName: String?
    var selectedVitalID: Int?
    var vitalList = [VitalListModel]()
    fileprivate var measurementFormBuilderData = [MeasurementFormDataModel]()
    var vitalNameArray = [String]()
    var selectedIndex : Int?
    var formBuilderDic = [String: Any]()
    var addMeasurementDic = [String: Any]()
    fileprivate var formDataDic: [String: String] = [:]
    fileprivate let fromDataCellheight = 40
    weak var delegate: RefreshDelegate?
//    var selectedVital: VitalListModel?
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var addAppointmentTableView: UITableView!
    @IBOutlet weak var transitionView: TransitionButton!
    @IBOutlet weak var cancelBtnOutlt: UIButton!
    @IBOutlet weak var saveBtnOutlt: UIButton!
    @IBOutlet weak var testNameSelectionView: UIView!
    @IBOutlet weak var testNameSelectionTextField: UITextField!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.getVitalList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_ADD_MEASUREMENT_SCREEN_TITLE.localized)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.saveBtnOutlt.gradient(withX: 0, withY: 0, cornerRadius: false)
        self.view.layoutIfNeeded()
    }
    
    override func getSelectedImage(capturedImage image: UIImage){
        super.getSelectedImage(capturedImage: image)
        
        dismiss(animated: true, completion: nil)
        
        self.isFileAttached = .yes
        self.attachmentType = .image
        self.addAppointmentTableView.reloadData()
        
        if self.noOfAttachments.count <= 9{
            self.noOfAttachments.append(image)
        }
        
        let index = IndexPath(row: 0, section: 1)
        guard let cell  = self.addAppointmentTableView.cellForRow(at: index) as? MeasurementListCollectionCell else{
            return
        }
        cell.measurementListCollectionView.reloadData()
    }
    
    open override func imagePickerControllerDidCancel(){
        super.imagePickerControllerDidCancel()
        
        dismiss(animated: true, completion: nil)
        if !self.noOfAttachments.isEmpty {
            return
        }else{
            self.isFileAttached = .no
            self.addAppointmentTableView.reloadData()
        }
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension AddMeasurementVC : UITableViewDataSource {
    
    func tableView(_ tableView : UITableView, numberOfRowsInSection section: Int) -> Int{
        let sections = (section == false.rawValue) ? 2 : 1
        return sections
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0 :
            switch indexPath.row {
            case 0:
                guard let vitalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "vitalTableViewCellID", for: indexPath) as? VitalTableViewCell else{
                    fatalError("VitalTableViewCell Not Found!")
                }
                
                vitalTableViewCell.vitalTableView.isScrollEnabled = false
                vitalTableViewCell.addMeasurementTableViewHeight = self.fromDataCellheight
                vitalTableViewCell.delegate = self
                vitalTableViewCell.measurementFormData = self.measurementFormBuilderData
                vitalTableViewCell.vitalDataDic = [:]
                if self.measurementFormBuilderData.isEmpty{
                    self.convertDataIntoJSONDictionary([:])
                }
                vitalTableViewCell.vitalTableView.reloadData()
                return vitalTableViewCell
                
            case 1: guard let selectDatecell = tableView.dequeueReusableCell(withIdentifier: "selectDateCellID", for: indexPath) as? SelectDateCell else{
                fatalError("SelectDateCell Not Found!")
            }
            
            selectDatecell.selectDateLabel.text = "Select Date"
            selectDatecell.selectDateTextField.borderStyle = UITextBorderStyle.none
            selectDatecell.selectTimeLabel.text = K_SELECT_TIME_TITLE.localized
            selectDatecell.selectTimeTextField.borderStyle = UITextBorderStyle.none
            
            selectDatecell.selectTimeTextField.delegate = self
            selectDatecell.selectDateTextField.delegate = self
            
            if let date = self.addMeasurementDic["measurement_date"] as? Date {
                selectDatecell.selectDateTextField.text = date.stringFormDate(.ddMMMYYYY)
            }
            if let time = self.addMeasurementDic["measurement_time"] as? Date {
                selectDatecell.selectTimeTextField.text = time.stringFormDate(.Hmm)
            }
            
            return selectDatecell
                
            default :
                fatalError("Cell Not Found!")
            }
        case 1: if self.isFileAttached == .no {
            
            guard let attachmentReportcell = tableView.dequeueReusableCell(withIdentifier: "attachReportCellID", for: indexPath) as? AttachReportCell else{
                fatalError("attachmentReportcell Not Found!")
            }
            
            attachmentReportcell.attachReportBtnOutlt.addTarget(self, action: #selector(self.attctmentReportButtonTapped(_:)), for: UIControlEvents.touchUpInside)
            
            return attachmentReportcell
        }else{
            
            guard let attachmentCollectionCell = tableView.dequeueReusableCell(withIdentifier: "measurementListCollectionCellID", for: indexPath) as? MeasurementListCollectionCell else{
                fatalError("attachmentReportcell Not Found!")
            }
            
            attachmentCollectionCell.outerViewTrailingConstraint.constant = 0
            attachmentCollectionCell.outerViewLeadingConstraint.constant = 0
            attachmentCollectionCell.outerViewTopConstraint.constant = 0
            attachmentCollectionCell.outerViewBottomConstraint.constant = 0
            
            if !(attachmentCollectionCell.measurementListCollectionView.delegate is AddMeasurementVC ) {
                attachmentCollectionCell.measurementListCollectionView.delegate = self
                attachmentCollectionCell.measurementListCollectionView.dataSource = self
            }
            return attachmentCollectionCell
            }
            
        default :
            fatalError("Cell not Found!")
        }
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension AddMeasurementVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let cellHeight = CGFloat(self.measurementFormBuilderData.count * self.fromDataCellheight) + 48
        let cellRowHeight = (!self.measurementFormBuilderData.isEmpty) ? cellHeight : CGFloat.leastNormalMagnitude
        let rowsheight = (indexPath.row == false.rawValue) ? cellRowHeight : 90
        let height = (indexPath.section == false.rawValue ) ? rowsheight : 110
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = (section == true.rawValue) ? 36 : CGFloat.leastNormalMagnitude
        let headerHeight = (self.isFileAttached == .no) ? CGFloat.leastNormalMagnitude : height
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerViewCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as? AttachmentHeaderViewCell else{
            fatalError("Header View Not Found!")
        }
        
        headerViewCell.headerTitle.text = K_ATTACHED_REPORTS.localized
        headerViewCell.headerTitle.font = AppFonts.sanProSemiBold.withSize(15.8)
        headerViewCell.cellBackgroundView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        headerViewCell.dropDownBtn.isHidden = true
        
        return headerViewCell
    }
}

//MARK:- UITextFieldDelegate Methods
//==================================
extension AddMeasurementVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        MultiPicker.noOfComponent = 1
        MultiPicker.openPickerIn(self.testNameSelectionTextField, firstComponentArray: self.vitalNameArray, secondComponentArray: [], firstComponent: self.testNameSelectionTextField.text, secondComponent: "", titles: ["Test Name"]) { (result, _,index,_) in
            textField.text = result
            self.selectedIndex = index!
            self.addMeasurementDic["vital_super_id"] = self.vitalList[index!].vitalID
            self.formBuilderService(vitalID: self.vitalList[index!].vitalID!)
        }
        
        guard let indexPath = textField.tableViewIndexPathIn(self.addAppointmentTableView) else{
            return
        }
        
        switch indexPath.row {
            
        case 1: guard let cell = self.addAppointmentTableView.cellForRow(at: indexPath) as?  SelectDateCell else {
            return
        }
        
        DatePicker.openPicker(in: cell.selectDateTextField, currentDate: Date(), minimumDate: nil, maximumDate: Date(), pickerMode: UIDatePickerMode.date, doneBlock: { (date) in
            
            cell.selectDateTextField.text = date.stringFormDate(.ddMMMYYYY)
            self.addMeasurementDic["measurement_date"] = date
        })
        
        DatePicker.openPicker(in: cell.selectTimeTextField, currentDate: Date(), minimumDate: nil, maximumDate: nil, pickerMode: UIDatePickerMode.time, doneBlock: { (date) in
            
            cell.selectTimeTextField.text = date.stringFormDate(.Hmm)
            self.addMeasurementDic["measurement_time"] = date
        })
        default : return
        }
    }
}

//MARK:- UICollectionViewDataSource Methods
//=========================================
extension AddMeasurementVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let attachmentsCount = self.noOfAttachments.count
        let sections = (self.noOfAttachments.count == 10) ? attachmentsCount : attachmentsCount+1
        return sections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let attachmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "attachmentCellID", for: indexPath) as? AttachmentCell else{
            fatalError("Cell Not Found!")
        }
        
        attachmentCell.dateStackViewConstant.constant = 0
        attachmentCell.imageStackViewTopConstraint.constant = 20
        if self.isFileAttached == IsFileAttached.yes{
            
            if self.noOfAttachments.count <= 10{
                
                if indexPath.item == self.noOfAttachments.count{
                    
                    attachmentCell.dateLabel.isHidden = true
                    attachmentCell.sepratorView.isHidden = true
                    attachmentCell.timeLabel.isHidden = true
                    attachmentCell.pdfImageView.image = #imageLiteral(resourceName: "icMeasurementAdd")
                    attachmentCell.pdfNameLabel.text = K_ADD_ATTACHMENT_BUTTON_TITLE.localized
                    attachmentCell.pdfNameLabel.font = AppFonts.sanProSemiBold.withSize(13.6)
                    attachmentCell.pdfNameLabel.textColor = UIColor.appColor
                    attachmentCell.deleteButtonOutlt.isHidden = true
                    
                }else if !self.noOfAttachments.isEmpty {
                    
                    if self.attachmentType == AttachmentType.image {
                        attachmentCell.pdfImageView.image = #imageLiteral(resourceName: "icImage")
                        attachmentCell.pdfNameLabel.text = "Image"
                        
                    }else{
                        attachmentCell.pdfImageView.image = #imageLiteral(resourceName: "icMeasurementPdf")
                        attachmentCell.pdfNameLabel.text = "Pdf"
                    }
                    
                    attachmentCell.dateLabel.isHidden = true
                    attachmentCell.sepratorView.isHidden = true
                    attachmentCell.timeLabel.isHidden = true
                    
                    attachmentCell.deleteButtonOutlt.isHidden = false
                    attachmentCell.deleteButtonOutlt.setImage(#imageLiteral(resourceName: "icMeasurementClose"), for: UIControlState.normal)
                    attachmentCell.pdfNameLabel.textColor = UIColor.black
                    attachmentCell.deleteButtonOutlt.addTarget(self, action: #selector(self.deleteAttachedReport(_:)), for: UIControlEvents.touchUpInside)
                }
            }
        }
        return attachmentCell
    }
}

//MARK:- UICollectionViewDelegateFlowLayout, UICollectionViewDelegate Methods
//===========================================================================
extension AddMeasurementVC : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: UIDevice.getScreenWidth / 3 + 20, height: collectionView.frame.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 3, left: 2, bottom: 1, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.noOfAttachments.count{
            self.openActionSheet()
        }else{
            return
        }
    }
}

//MARK:- Methods
//==============
extension AddMeasurementVC {
    //    Setup Ui
    fileprivate func setupUI(){
        
        self.addMeasurementDic["measurement_date"] = Date()
        self.addMeasurementDic["measurement_time"] = Date()
        
        self.floatBtn.isHidden = true
        self.isNavigationBarButton = false
        self.addAppointmentTableView.dataSource = self
        self.addAppointmentTableView.delegate = self
        ImagePicker.shared.imagePickerDelegate = self
        self.registerNibs()
        
        self.addAppointmentTableView.bounces = false
        
        self.cancelBtnOutlt.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
        self.cancelBtnOutlt.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
        self.cancelBtnOutlt.setTitle(K_CANCEL_BUTTON.localized.uppercased(), for: UIControlState.normal)
        self.cancelBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.saveBtnOutlt.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
        self.saveBtnOutlt.setTitle(K_SAVE_BUTTON_TITLE.localized.uppercased(), for: UIControlState.normal)
        self.saveBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.cancelBtnOutlt.addTarget(self, action: #selector(self.cancelButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        self.saveBtnOutlt.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        self.testNameSelectionTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icMeasurementDropdown"))
        self.testNameSelectionTextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.testNameSelectionTextField.rightViewMode = UITextFieldViewMode.always
        self.testNameSelectionTextField.tintColor = UIColor.white
        self.testNameSelectionTextField.delegate = self
        
        if let name = self.selectedVitalName{
            self.testNameSelectionTextField.text = name
        }
    }
    
    //    RegisterNib
    fileprivate func registerNibs(){
        
        let vitalTableViewCellNib = UINib(nibName: "VitalTableViewCell", bundle: nil)
        let selectDateCellNib = UINib(nibName: "SelectDateCell", bundle: nil)
        let attachReportCellNib = UINib(nibName: "AttachReportCell", bundle: nil)
        let attachReportCollectionNib = UINib(nibName: "MeasurementListCollectionCell", bundle: nil)
        let attachReportHeaderNib = UINib(nibName: "AttachmentHeaderViewCell", bundle: nil)
        
        self.addAppointmentTableView.register(vitalTableViewCellNib, forCellReuseIdentifier: "vitalTableViewCellID")
        self.addAppointmentTableView.register(selectDateCellNib, forCellReuseIdentifier: "selectDateCellID")
        self.addAppointmentTableView.register(attachReportCellNib, forCellReuseIdentifier: "attachReportCellID")
        self.addAppointmentTableView.register(attachReportCollectionNib, forCellReuseIdentifier: "measurementListCollectionCellID")
        self.addAppointmentTableView.register(attachReportHeaderNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
    }
    
    //   MARK: Button Targets
    //   ====================
    @objc fileprivate func attctmentReportButtonTapped(_ sender : UIButton){
        self.openActionSheet()
    }
    
    @objc fileprivate func cancelButtonTapped(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func saveButtonTapped(_ sender : UIButton){
        
        guard (self.addMeasurementDic["vital_super_id"] as? Int) != nil else{
            showToastMessage(AppMessages.selectVitals.rawValue.localized)
            return
        }
        
        if !self.measurementFormBuilderData.isEmpty{
            
            guard !self.formDataDic.isEmpty else{
                showToastMessage(AppMessages.allValuesOfVitals.rawValue.localized)
                return
            }
            
            let KeysArray = Array(self.formDataDic.keys)
            var isDicHaveData: Bool = false
            for keys in KeysArray {
                if !self.formDataDic[keys]!.isEmpty {
                    isDicHaveData = true
                }
            }
            
            if !isDicHaveData{
                showToastMessage(AppMessages.allValuesOfVitals.rawValue.localized)
                return
            }
            
            self.convertDataIntoJSONDictionary(self.formDataDic)
        }else{
            guard self.noOfAttachments.count > 0 else {
                showToastMessage(AppMessages.addAttachment.rawValue.localized)
                return
            }
        }
        guard let selectedDate = self.addMeasurementDic["measurement_date"] as? Date else{
            showToastMessage(AppMessages.measurementDate.rawValue.localized)
            return
        }
        guard let selectedTime = self.addMeasurementDic["measurement_time"] as? Date else{
            showToastMessage(AppMessages.measurementTime.rawValue.localized)
            return
        }
        
        self.addMeasurement(selectedDate: selectedDate, selectedTime: selectedTime)
    }
    
    @objc fileprivate func deleteAttachedReport(_ sender : UIButton){
        
        guard let collectionViewCell = sender.getTableViewCell as? MeasurementListCollectionCell else{
            return
        }
        
        guard let cellIndex = sender.collectionViewIndexPathIn(collectionViewCell.measurementListCollectionView) else{
            return
        }
        
        self.noOfAttachments.remove(at: cellIndex.item)
        
        let isFileAttached : IsFileAttached = (self.noOfAttachments.count == 0) ? .no : .yes
        self.isFileAttached = isFileAttached
        collectionViewCell.measurementListCollectionView.reloadData()
        self.addAppointmentTableView.reloadData()
    }
    
    //    MARK: Open Action Sheet
    //    =======================
    fileprivate func openActionSheet(){
        
        let actionSheet = UIAlertController(title: "Choose", message: "", preferredStyle: .actionSheet)
        let openCamera = UIAlertAction(title: K_CAMERA_TITLE.localized, style: UIAlertActionStyle.default) { (alert) in
            
            self.accessMediaTypes = .camera
            self.openCamera()
        }
        let openGallery = UIAlertAction(title: K_GALLERY_TITLE.localized, style: UIAlertActionStyle.default) { (alert) in
            
            self.accessMediaTypes = .gallery
            self.openGallery()
        }
        let openiCloud = UIAlertAction(title: K_ICLOUD_TITLE.localized, style: UIAlertActionStyle.default) { (alert) in
            self.openiCloud()
        }
        let cancel = UIAlertAction(title: K_CANCEL_BUTTON.localized, style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheet.addAction(openCamera)
        actionSheet.addAction(openGallery)
        actionSheet.addAction(openiCloud)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    fileprivate func checkMediaTypeAuthorization(){
        
        let auth = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch auth {
        case .authorized:
            if self.accessMediaTypes == .camera {
                self.openCamera()
            }else{
                self.openGallery()
            }
        case .denied:
            self.openAlertToAccessCamera()
            
        default:
            if self.accessMediaTypes == .camera {
                self.openCamera()
            }else{
                self.openGallery()
            }
        }
    }
    
    //    MARK: Open Camera
    //    =================
    fileprivate func openCamera(){
        ImagePicker.shared.checkAndOpenCamera(on: self, viewForCustomCamera: nil)
    }
    
    //    MARK: Open Gallery
    //    ==================
    fileprivate func openGallery(){
        ImagePicker.shared.checkAndOpenLibrary(on: self)
    }
    
    fileprivate func openAlertToAccessCamera(){
        
        let alert = UIAlertController(title: "Access", message: "Access is required to get the image", preferredStyle: UIAlertControllerStyle.alert)
        
        let settings = UIAlertAction(title: "Setting", style: UIAlertActionStyle.default) { (action) in
            let settingUrl = URL(string: UIApplicationOpenSettingsURLString)
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingUrl!, options: [:], completionHandler: nil)
            }else{
                showToastMessage("Setting url if availiable for iOS 10")
            }
        }
        
        let cancel = UIAlertAction(title: K_CAMERA_TITLE.localized, style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(settings)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    //    MARK: Open iCloud
    //    ==================
    fileprivate func openiCloud(){
        
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: UIDocumentPickerMode.import)
        documentPickerController.delegate = self
        present(documentPickerController, animated: true, completion: nil)
    }
    
    //    MARK:- WebServices
    //    ==================
    fileprivate func getVitalList(){
        
        self.formBuilderDic["id"] = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId)
        
        WebServices.getVitalList(parameters: self.formBuilderDic, success: {[weak self] (_ vitalListData : [VitalListModel]) in
            guard let addMeasurementVC = self else{
                return
            }
            
            addMeasurementVC.vitalList = vitalListData
            let vitalList = addMeasurementVC.vitalList.map{(value) in
                value.vitalName
            }
            
            addMeasurementVC.vitalNameArray = vitalList as! [String]
            
            if !addMeasurementVC.vitalList.isEmpty{
                if let vitalID = addMeasurementVC.selectedVitalID{
                    addMeasurementVC.addMeasurementDic["vital_super_id"] = vitalID
                    addMeasurementVC.formBuilderService(vitalID: vitalID)
                }
            }else{
                let indexPath = IndexPath(row: 0, column: 0)
                addMeasurementVC.addAppointmentTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            }, failure: {(error) in
                showToastMessage(error.localizedDescription)
        })
    }
    
    fileprivate func formBuilderService(vitalID: Int){
        
        self.formBuilderDic["id"] = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId)
        self.formBuilderDic["vital_id"] = vitalID
        WebServices.getMeasurementFormBuilder(parameters: self.formBuilderDic, success: {[weak self] (_ measurementFormData : [MeasurementFormDataModel]) in
            
            guard let addMeasurementVC = self else{
                return
            }
            
            addMeasurementVC.measurementFormBuilderData = measurementFormData
            let indexPath = IndexPath(row: 0, column: 0)
            addMeasurementVC.addAppointmentTableView.reloadRows(at: [indexPath], with: .automatic)
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func addMeasurement(selectedDate: Date, selectedTime: Date){
        
        var parameters: JSONDictionary = self.addMeasurementDic
        parameters["measurement_date"] = selectedDate.stringFormDate(.yyyyMMdd)
        parameters["measurement_time"] = selectedTime.stringFormDate(.Hmm)
        parameters["id"] = AppUserDefaults.value(forKey: .userId)
        parameters["doc_id"] = AppUserDefaults.value(forKey: .doctorId).stringValue
        
        let value = self.noOfAttachments.convertToDic("upload")
        
        self.transitionView.backgroundColor = UIColor.appColor
        self.cancelBtnOutlt.isHidden = true
        self.saveBtnOutlt.isHidden = true
        self.transitionView.startAnimation()
        WebServices.addMeasurement(parameters: parameters,
                                   imageData: value,
                                   success: {[weak self] (_ message : String) in
                                    
                                    guard let addMeasurementVC = self else{
                                        return
                                    }
                                   
                                    addMeasurementVC.stopButtonAnimation(isServiceFail: true)
                                    
        }) { (error) in
            self.stopButtonAnimation(isServiceFail: false)
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func stopButtonAnimation(isServiceFail: Bool){
        self.transitionView.stopAnimation(animationStyle: .normal, completion: {
            self.transitionView.backgroundColor = UIColor.white
            self.cancelBtnOutlt.isHidden = false
            self.saveBtnOutlt.isHidden = false
            if isServiceFail{
                self.addConfirmationVC()
            }
        })
    }
    
    fileprivate func addConfirmationVC(){
        
        let measurementConfirmScene = MeasurementConfirmationVC.instantiate(fromAppStoryboard: .Measurement)
        
        measurementConfirmScene.delegate = self
        measurementConfirmScene.refreshScreenDelegate = self
        AppDelegate.shared.window?.addSubview(measurementConfirmScene.view)
        self.addChildViewController(measurementConfirmScene)
    }
}

//MARK:- UIDocumentMenuDelegate Methods
//======================================
extension AddMeasurementVC : UIDocumentMenuDelegate, UIDocumentPickerDelegate{
    
    @available(iOS 8.0, *)
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        if url.absoluteString.hasSuffix(".pdf"){
            
            let pdfPath = url

            self.isFileAttached = IsFileAttached.yes
            self.attachmentType = AttachmentType.pdf
            self.addAppointmentTableView.reloadData()
            if self.noOfAttachments.count <= 9{
                self.noOfAttachments.append(pdfPath)
            }
            
            let index = IndexPath(row: 0, section: 1)
            guard let cell  = self.addAppointmentTableView.cellForRow(at: index) as? MeasurementListCollectionCell else{
                return
            }
            cell.measurementListCollectionView.reloadData()
        }else{
            showToastMessage(AppMessages.selectOnlyPdf.rawValue.localized)
        }
    }
    
    @available(iOS 8.0, *)
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController){
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    @available(iOS 8.0, *)
    func documentMenuWasCancelled(_ documentMenu: UIDocumentMenuViewController){
        dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func convertDataIntoJSONDictionary(_ formDataDic: [String : String]){
        
        do {
            let typejsonArray = try JSONSerialization.data(withJSONObject: formDataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            guard let typeJSONString = String(data: typejsonArray, encoding: String.Encoding.utf8) else { return }
            self.addMeasurementDic["vital_dic"] = typeJSONString as String
        }catch{
            //printlnDebug(error.localizedDescription)
        }
    }
}

//MARK:- FormDataDic Protocol
//============================
extension AddMeasurementVC : FormDataDicDelegate , MeasurementConfirmationVCFromSuperView, RefreshDelegate {
    
    func formDataDic(_ formDataDic: [String : String]) {
        self.formDataDic = formDataDic
    }
    
    func removeFromSuperView() {
        guard let nvc = self.navigationController else{
            return
        }
        nvc.popViewController(animated: true)
    }
    
    func refreshScreen() {
        self.delegate?.refreshScreen()
    }
}
