//
//  AddMeasurementVCViewController.swift
//  Mutelcore
//
//  Created by Appinventiv on 30/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation


class AddMeasurementVC: BaseViewController {

//    MARK:- Proporties
//    =================
    enum IsFileAttached {
        
        case Yes, No
    }
    
    enum AttachmentType {
        
        case Image, Pdf, None
    }
    
    enum AccessMediaTypes {
        
        case camera, gallery
    }
    
    lazy var cameraPicker = UIImagePickerController()
    
    var accessMediaTypes : AccessMediaTypes = AccessMediaTypes.camera
    var isFileAttached : IsFileAttached = IsFileAttached.No
    var attachmentType : AttachmentType = AttachmentType.None
    var noOfAttachments = [Any]()
    var noOfImages = [UIImage]()
    var noOFPdfs = [String]()
    var vitalList = [VitalListModel]()
    var measurementFormBuilderData = [MeasurementFormDataModel]()
    var vitalNameArray = [String]()
    var selectedName : String?
    var formBuilderDic = [String : Any]()
    var addMeasurementDic = [String : Any]()
    let fromDataCellheight = 30
    var tableViewHeight : CGFloat?

    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var addAppointmentTableView: UITableView!
    @IBOutlet weak var cancelBtnOutlt: UIButton!
    @IBOutlet weak var saveBtnOutlt: UIButton!
    
//    MARK:- ViewController Life Cycle
//    ================================
    override func viewDidLoad() {
        super.viewDidLoad()

        printlnDebug("dic \(self.addMeasurementDic)")
        
        self.setupUI()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .BackBtn
        self.navigationControllerOn = .dashboard

        self.getVitalList()
        self.formBuilderService()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        self.setNavigationBar("Add Measurements", 2, 3)

        self.saveBtnOutlt.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension AddMeasurementVC : UITableViewDataSource {
    
    func tableView(_ tableView : UITableView, numberOfRowsInSection section: Int) -> Int{
        
        switch section {
            
        case 0: return 3
            
        case 1: return 1
            
        default : fatalError("Rows Not Found!")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0 : switch indexPath.row {
            
        case 0: guard let testNameSelectionCell = tableView.dequeueReusableCell(withIdentifier: "testNameSelectionCellID", for: indexPath) as? TestNameSelectionCell else{
            
            fatalError("TestNameselectionCell Not Found!")
        }
       
        testNameSelectionCell.selectTestNameTextField.delegate = self
        testNameSelectionCell.selectTestNameTextField.text = self.selectedName
        testNameSelectionCell.addMeasurementbtn.isHidden = true
        
        
        return testNameSelectionCell
            
        case 1: guard let vitalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "vitalTableViewCellID", for: indexPath) as? VitalTableViewCell else{
            
            fatalError("TestNameselectionCell Not Found!")
        }

        vitalTableViewCell.vitalTableView.isScrollEnabled = false
        vitalTableViewCell.addMeasurementTableViewHeight = self.tableViewHeight
        vitalTableViewCell.measurementFormData = self.measurementFormBuilderData
        vitalTableViewCell.delegate = self
        
        return vitalTableViewCell
            
        case 2: guard let selectDatecell = tableView.dequeueReusableCell(withIdentifier: "selectDateCellID", for: indexPath) as? SelectDateCell else{
            
            fatalError("SelectDateCell Not Found!")
        }
        
        selectDatecell.selectDateLabel.text = "Select Date"
        selectDatecell.selectDateLabel.textColor = UIColor.appColor
        selectDatecell.selectDateLabel.font = AppFonts.sansProRegular.withSize(16)
        
        selectDatecell.selectDateTextField.font = AppFonts.sanProSemiBold.withSize(16)
        selectDatecell.selectDateTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentCalendar"))
        selectDatecell.selectDateTextField.rightViewMode = .always
        selectDatecell.selectDateTextField.borderStyle = UITextBorderStyle.none
        selectDatecell.selectDateTextField.delegate = self
        
        selectDatecell.selectTimeLabel.text = "Select Time"
        selectDatecell.selectTimeLabel.textColor = UIColor.appColor
        selectDatecell.selectTimeLabel.font = AppFonts.sansProRegular.withSize(16)
        
        selectDatecell.selectTimeTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentClock"))
        selectDatecell.selectTimeTextField.rightViewMode = .always
        selectDatecell.selectTimeTextField.font = AppFonts.sanProSemiBold.withSize(16)
        selectDatecell.selectTimeTextField.borderStyle = UITextBorderStyle.none
        selectDatecell.selectTimeTextField.delegate = self
        
        return selectDatecell
            
        default : fatalError("Cell Not Found!")
            
            }
        case 1: if self.isFileAttached == IsFileAttached.No {
            
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
            
            attachmentCollectionCell.measurementListCollectionView.delegate = self
            attachmentCollectionCell.measurementListCollectionView.dataSource = self
            
            return attachmentCollectionCell
            }

        default : fatalError("Cell not Found!")
        
        }
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension AddMeasurementVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
           
        case 0 :
            
            switch indexPath.row {
            
            case 0: return CGFloat(45.5)
            
            case 1: if !self.measurementFormBuilderData.isEmpty {
                
                self.tableViewHeight = CGFloat(self.measurementFormBuilderData.count * self.fromDataCellheight) + 40
                
                return self.tableViewHeight!
                
            }else{
                
                return CGFloat(0)
            }
            case 2: return CGFloat(90)
                
            default : return CGFloat(0)
            
            }
        
        case 1: return CGFloat(110)
            
        default : fatalError("Rows Not Found!")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.isFileAttached == IsFileAttached.No {
            
            return CGFloat(0)
        
        }else{
           
            if section == 1{
                
               return CGFloat(36)
            }else{
                
               return CGFloat(0)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerViewCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as? AttachmentHeaderViewCell else{
            
            fatalError("Header View Not Found!")
        }
        
        headerViewCell.headerTitle.text = "ATTACHED REPORTS"
        headerViewCell.headerTitle.font = AppFonts.sanProSemiBold.withSize(15.8)
        headerViewCell.contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        headerViewCell.dropDownBtn.isHidden = true
        
        return headerViewCell
    }
}

//MARK:- UITextFieldDelegate Methods
//==================================
extension AddMeasurementVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     
        guard let index = textField.tableViewIndexPathIn(self.addAppointmentTableView) else{
            
            return
        }
        
        switch index.row {
            
        case 0: guard let cell = self.addAppointmentTableView.cellForRow(at: index) as? TestNameSelectionCell else{
            
            return
        }
        
        MultiPicker.noOfComponent = 1
        MultiPicker.openPickerIn(cell.selectTestNameTextField, firstComponentArray: self.vitalNameArray, secondComponentArray: [], firstComponent: cell.selectTestNameTextField.text, secondComponent: "", titles: ["Test Name"]) { (result, _,index,_) in
            
            cell.selectTestNameTextField.text = result
            self.selectedName = result
            self.formBuilderDic["vital_id"] = self.vitalList[index!].vitalID
            self.addMeasurementDic["vital_super_id"] = self.vitalList[index!].vitalID
           
            self.formBuilderService()
        }
        
        case 1, 4: break
            
        case 2: guard let cell = self.addAppointmentTableView.cellForRow(at: index) as?  SelectDateCell else {
            
            return
        }
        
        DatePicker.openPicker(in: cell.selectDateTextField, currentDate: Date(), minimumDate: nil, maximumDate: Date(), pickerMode: UIDatePickerMode.date, doneBlock: { (date) in
            
            cell.selectDateTextField.text = date.stringFormDate(DateFormat.ddMMMYYYY.rawValue)
            self.addMeasurementDic["measurement_date"] = date.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        })

        DatePicker.openPicker(in: cell.selectTimeTextField, currentDate: Date(), minimumDate: nil, maximumDate: nil, pickerMode: UIDatePickerMode.time, doneBlock: { (date) in
            
            cell.selectTimeTextField.text = date.stringFormDate(DateFormat.Hmm.rawValue)
            self.addMeasurementDic["measurement_time"] = date.stringFormDate(DateFormat.Hmm.rawValue)
        })
            
        default : return
            
        }
    }
}

//MARK:- UICollectionViewDataSource Methods
//=========================================
extension AddMeasurementVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.noOfAttachments.count == 10{
            
            return self.noOfAttachments.count
        }else{
            
          return self.noOfAttachments.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     

        guard let attachmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "attachmentCellID", for: indexPath) as? AttachmentCell else{
            
            fatalError("Cell Not Found!")
        }
        
        attachmentCell.dateStackViewConstant.constant = 0
        attachmentCell.imageStackViewTopConstraint.constant = 20
        if self.isFileAttached == IsFileAttached.Yes{
            
            if self.noOfAttachments.count <= 10{
            
            if indexPath.item == self.noOfAttachments.count{
                
                attachmentCell.dateLabel.isHidden = true
                attachmentCell.sepratorView.isHidden = true
                attachmentCell.timeLabel.isHidden = true
                attachmentCell.pdfImageView.image = #imageLiteral(resourceName: "icMeasurementAdd")
                attachmentCell.pdfNameLabel.text = "Add Attachment"
                attachmentCell.pdfNameLabel.font = AppFonts.sanProSemiBold.withSize(13.6)
                attachmentCell.pdfNameLabel.textColor = UIColor.appColor
                attachmentCell.deleteButtonOutlt.isHidden = true
                
            }else if !self.noOfAttachments.isEmpty {
            
                if self.attachmentType == AttachmentType.Image {
                   
//                   attachmentCell.pdfNameLabel.text = "\(Date().timeIntervalSince1970).jpg"
                   attachmentCell.pdfImageView.image = #imageLiteral(resourceName: "icImage")
                    attachmentCell.pdfNameLabel.text = "Image"
                    
                }else{
                  
//                    if let pdfName = self.noOfAttachments[indexPath.row] as? String{
//                        
//                      let t = pdfName.components(separatedBy: "/").last
//                        
//                        printlnDebug("t :\(t)")
//                    }
                    
//                  attachmentCell.pdfNameLabel.text = "\()"  
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
        
        return CGSize(width: UIDevice.getScreenWidth / 3 + 20, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 3, left: 2, bottom: 1, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        printlnDebug(indexPath.row)
        printlnDebug(self.noOfAttachments.count)
        
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
        
        self.floatBtn.isHidden = true
        
        self.addAppointmentTableView.dataSource = self
        self.addAppointmentTableView.delegate = self
        
        self.cameraPicker.delegate = self
        
        
        self.registerNibs()
        
        self.addAppointmentTableView.bounces = false
        
        self.cancelBtnOutlt.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
        self.cancelBtnOutlt.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
        self.cancelBtnOutlt.setTitle("Cancel", for: UIControlState.normal)
        self.cancelBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.saveBtnOutlt.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
        self.saveBtnOutlt.setTitle("Save", for: UIControlState.normal)
        self.saveBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.cancelBtnOutlt.addTarget(self, action: #selector(self.cancelButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        self.saveBtnOutlt.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: UIControlEvents.touchUpInside)

    }
    
//    RegisterNib
    fileprivate func registerNibs(){
        
        let TestNameSelectionCell = UINib(nibName: "TestNameSelectionCell", bundle: nil)
        let vitalTableViewCellNib = UINib(nibName: "VitalTableViewCell", bundle: nil)
        let selectDateCellNib = UINib(nibName: "SelectDateCell", bundle: nil)
        let attachReportCellNib = UINib(nibName: "AttachReportCell", bundle: nil)
        let attachReportCollectionNib = UINib(nibName: "MeasurementListCollectionCell", bundle: nil)
        let attachReportHeaderNib = UINib(nibName: "AttachmentHeaderViewCell", bundle: nil)
        
        self.addAppointmentTableView.register(TestNameSelectionCell, forCellReuseIdentifier: "testNameSelectionCellID")
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
        
       let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func saveButtonTapped(_ sender : UIButton){
        
        guard (self.addMeasurementDic["vital_super_id"] as? Int) != nil else{
            
            showToastMessage("Please select the vitals.")
            return
        }
        
        if self.measurementFormBuilderData.isEmpty{
            
            guard self.noOfAttachments.count > 0 else {
                
                showToastMessage("Please add Attachments")
                
                return
            }
            
        }else{
            
            if let vitalDic = self.addMeasurementDic["vital_dic"] as? [String : String]{
                
                printlnDebug(vitalDic)
                
                for (_,value) in vitalDic {
                    
                    printlnDebug(value)
                    
                    guard !(value).isEmpty else{
                        
                        showToastMessage("Please enter the all values of vitals")

                        return
                    }
                }
            }
        }
        
        guard let selectedDate = self.addMeasurementDic["measurement_date"] as? String , !selectedDate.isEmpty else{
            
            showToastMessage("Please select the measurement Date.")

            return
        }
        
        guard let selectedTime = self.addMeasurementDic["measurement_time"] as? String , !selectedTime.isEmpty else{
            
            showToastMessage("Please select the measurement Time.")

            return
        }
        
        self.addMeasurementService()
    }
    
    @objc fileprivate func deleteAttachedReport(_ sender : UIButton){
        
        
        guard let collectionViewCell = sender.getTableViewCell as? MeasurementListCollectionCell else{
            return
        }
        
        guard let cellIndex = sender.collectionViewIndexPathIn(collectionViewCell.measurementListCollectionView) else{
            
            return
        }
        
        self.noOfAttachments.remove(at: cellIndex.item)
        
        if self.noOfAttachments.count == 0{
            
           self.isFileAttached = IsFileAttached.No
        
        }else{
            
           self.isFileAttached = IsFileAttached.Yes
        }
        
        collectionViewCell.measurementListCollectionView.reloadData()
        self.addAppointmentTableView.reloadData()
    
    }
    
//    MARK: Open Action Sheet
//    =======================
    fileprivate func openActionSheet(){
        
        let actionSheet = UIAlertController(title: "Choose", message: "", preferredStyle: .actionSheet)
        let openCamera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (alert) in
            
            self.accessMediaTypes = AccessMediaTypes.camera
            
            self.openCamera()
        }
        let openGallery = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) { (alert) in
            
            self.accessMediaTypes = AccessMediaTypes.gallery
            
            self.openGallery()
        }
        let openiCloud = UIAlertAction(title: "iCloud", style: UIAlertActionStyle.default) { (alert) in
            
            self.openiCloud()
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheet.addAction(openCamera)
        actionSheet.addAction(openGallery)
        actionSheet.addAction(openiCloud)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)

    }
    
    
    fileprivate func checkMediaTypeAuthorization(){
        
        let auth = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch auth {
            
        case .authorized : if self.accessMediaTypes == AccessMediaTypes.camera {
            
            self.openCamera()
            
        }else{
            
            self.openCamera()
            }
            
        case .denied : self.openAlertToAccessCamera()
            
        default : if self.accessMediaTypes == AccessMediaTypes.camera {
            
            self.openCamera()
            
        }else{
            
            self.openCamera()
            }
        }
    }
    
//    MARK: Open Camera
//    =================
    fileprivate func openCamera(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            self.cameraPicker.allowsEditing = true
            self.cameraPicker.sourceType = .camera
            self.cameraPicker.cameraCaptureMode = .photo
            self.cameraPicker.modalPresentationStyle = .fullScreen
            
            self.present(self.cameraPicker, animated: true, completion: nil)
        }
    }
    
//    MARK: Open Gallery
//    ==================
    fileprivate func openGallery(){
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            self.cameraPicker.allowsEditing = true
            self.cameraPicker.sourceType = .photoLibrary
            self.cameraPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
            
            self.cameraPicker.modalPresentationStyle = .popover
            self.present(self.cameraPicker, animated: true, completion: nil)
        }
        
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
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)

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
        
        WebServices.getVitalList(parameters: self.formBuilderDic, success: { (_ vitalListData : [VitalListModel]) in
            
            self.vitalList = vitalListData
            
            let vitalList = self.vitalList.map{(value) in
                
                value.vitalName
            }
            
            self.vitalNameArray = vitalList as! [String]
            
            
        }, failure: {(error) in
           showToastMessage(error.localizedDescription)

        })
    }
    
    fileprivate func formBuilderService(){
        
        self.formBuilderDic["id"] = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId)
        
        WebServices.getMeasurementFormBuilder(parameters: self.formBuilderDic, success: { (_ measurementFormData : [MeasurementFormDataModel]) in
            
            self.measurementFormBuilderData = measurementFormData
            
            self.addAppointmentTableView.reloadData()
            
            let index = IndexPath(row: 1, column: 0)
            
            guard let cell = self.addAppointmentTableView.cellForRow(at: index) as? VitalTableViewCell else{
                
                return
            }
            
            cell.vitalTableView.reloadData()
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)

        }
    }
    
    fileprivate func addMeasurementService(){
        
        self.addMeasurementDic["id"] = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId)
        self.addMeasurementDic["doc_id"] = AppUserDefaults.value(forKey: AppUserDefaults.Key.doctorId)
        
//        if self.measurementFormBuilderData.isEmpty {
//            
//            self.addMeasurementDic["vital_dic"] = {}
//        }
        
        let value = self.noOfAttachments.convertToDic("upload")
        
        printlnDebug("val : \(value)")
        
        printlnDebug("AddDic : \(self.addMeasurementDic)")
        
        WebServices.addMeasuremnet(parameters: self.addMeasurementDic, imageData: value, success: { (_ message : String) in
            
            showToastMessage(message)
            
            self.addConfirmationVC()

        }) { (error) in
          
          showToastMessage(error.localizedDescription)

        }
    }
    
    fileprivate func addConfirmationVC(){
        
        let measurementConfirmScene = MeasurementConfirmationVC.instantiate(fromAppStoryboard: .Measurement)
        
        measurementConfirmScene.delegate = self
        measurementConfirmScene.view.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: 0)
        
        UIView.animate(withDuration: 0.3) { 
         
          measurementConfirmScene.view.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
            
        }
        
        sharedAppDelegate.window?.addSubview(measurementConfirmScene.view)
        self.addChildViewController(measurementConfirmScene)

    }
}

//MARK:- UIImagePickerController Methods
//======================================
extension AddMeasurementVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        dismiss(animated: true, completion: nil)
        
        guard let choosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        self.isFileAttached = IsFileAttached.Yes
        
        self.attachmentType = AttachmentType.Image
        
        self.addAppointmentTableView.reloadData()
        
        if self.noOfAttachments.count <= 9{
            
         self.noOfAttachments.append(choosenImage)
            
        }

//        let fileName = "\(info["UIImagePickerControllerReferenceURL"])".components(separatedBy: "-").last
        
        let index = IndexPath(row: 0, section: 1)
        
        guard let cell  = self.addAppointmentTableView.cellForRow(at: index) as? MeasurementListCollectionCell else{
            
            return
        }
        
        cell.measurementListCollectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        dismiss(animated: true, completion: nil)
        
        if !self.noOfAttachments.isEmpty {
            
            return
            
        }else{
          
            self.isFileAttached = IsFileAttached.No
            self.addAppointmentTableView.reloadData()
            
        }
    }
}

//MARK:- UIDocumentMenuDelegate Methods
//======================================
extension AddMeasurementVC : UIDocumentMenuDelegate, UIDocumentPickerDelegate{
    
    @available(iOS 8.0, *)
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        if url.absoluteString.hasSuffix(".pdf"){
            
            let pdf = url.lastPathComponent
          
            printlnDebug(pdf)
            
            let pdfPath = url
            
            self.isFileAttached = IsFileAttached.Yes
            self.attachmentType = AttachmentType.Pdf
            
            self.addAppointmentTableView.reloadData()
            
            if self.noOfAttachments.count <= 9{
                
                self.noOfAttachments.append(pdfPath)
                
            }
            
            let index = IndexPath(row: 0, section: 1)
            
            guard let cell  = self.addAppointmentTableView.cellForRow(at: index) as? MeasurementListCollectionCell else{
                
                return
            }
            
            cell.measurementListCollectionView.reloadData()

        }
        else{
            
            showToastMessage("Please select only pdf file")

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
}

//MARK:- FormDataDic Protocol
//============================
extension AddMeasurementVC : FormDataDicDelegate , MeasurementConfirmationVCFromSuperView {
    
    func formDataDic(_ formDataDic: [String : String]) {
        
        if !self.measurementFormBuilderData.isEmpty{
            
            do {
                
                let typejsonArray = try JSONSerialization.data(withJSONObject: formDataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                guard let typeJSONString = String(data: typejsonArray, encoding: String.Encoding.utf8) else { return }
                
                self.addMeasurementDic["vital_dic"] = typeJSONString as AnyObject?
                
                
                
            }catch{
                
                printlnDebug(error.localizedDescription)
            }
            
        }else{
            
            self.addMeasurementDic["vital_dic"] = []
            
        }
    }
    
    func removeFromSuperView(_ remove: Bool) {
        
        if remove == true{
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
