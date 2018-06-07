//
//  PersonalInformationVC.swift
//  Mutelcore
//
//  Created by Ashish on 20/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import AlamofireImage


class PersonalInformationVC: UIViewController {
    
    //    MARK:- Properties
    //    ================
    lazy var datePicker = UIDatePicker()
    lazy var pickerView = UIPickerView()
    lazy var picker = UIImagePickerController()
    
    var userInfo : UserInfo!
    var personalInfoDic = [String : Any]()
    var adhaarCardNumber = ""
    
    let cellTitleArray = [K_PATIENT_NAME_PLACEHOLDER.localized,K_EMAIL_ADDRESS_PLACEHOLDER.localized,K_DATE_OF_BIRTH_PLACEHOLDER.localized, K_GENDER_PLACEHOLDER.localized, K_MOBILE_NUMBER_PLACEHOLDER.localized, K_FATHERS_NAME_PLACEHOLDER.localized, K_SPOUSE_NAME_PLACEHOLDER.localized, K_ADHAAR_CARD_NUMBER_PLACEHOLDER.localized]
    
    let genderStatus = [K_MR_PLACEHOLDER.localized, K_MRS_PLACEHOLDER.localized, K_MS_PLACEHOLDER.localized, K_DR_PLACEHOLDER.localized]
    
    var isMale: Bool = true
    var userImage: UIImage?
    
    enum gender : Int{
        
        case male = 0
        case female = 1
    }
    
    var buildProfileVC : BuildProfileVC{
        
        return self.parent as! BuildProfileVC
    }
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var profileInformationTableView: UITableView!
    
    //    MARK:- Viewcontroller Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpViews()
        
        self.datePicker.datePickerMode = .date
        
        self.profileInformationTableView.dataSource = self
        self.profileInformationTableView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = true
        
    }
}

//MARK:- UITableViewDataSource Methods
//       =============================
extension PersonalInformationVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            guard let userImageCell = tableView.dequeueReusableCell(withIdentifier: "userImageCell", for: indexPath) as? UserImageCell else {
                fatalError("UserImageCell Not Found !")
            }
            userImageCell.celltextField.delegate = self
            userImageCell.genderStatusTextField.delegate = self
            userImageCell.middleNameTextField.delegate = self
            userImageCell.lastNameTextField.delegate = self
            
            userImageCell.populateData(self.userInfo, self.userImage)
            
            userImageCell.celltextField.placeholder = "FIRST NAME"
            userImageCell.middleNameTextField.placeholder = "MIDDLE NAME"
            userImageCell.lastNameTextField.placeholder = "LAST NAME"
            
            userImageCell.cellTitle.text = cellTitleArray[indexPath.row]
            
            let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldtap(_:)))
            userImageCell.genderStatusTextField.rightView?.addGestureRecognizer(rightViewTapGesture)
            userImageCell.setUserImagebutton.addTarget(self, action: #selector(openActionSheet), for: .touchUpInside)
            
            return userImageCell
            
        case 1: guard let emailAddressCell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as? EmailCell else {
            
            fatalError("EmailAddressCell Not Found !")
        }
        emailAddressCell.celltextField.delegate = self
        emailAddressCell.celltextField.keyboardType = .emailAddress
        emailAddressCell.cellTitle.setTitle(cellTitleArray[indexPath.row], for: .normal)
        
        emailAddressCell.populateData(self.userInfo)
        
        return emailAddressCell
            
        case 2: guard let dateOfBirthCell = tableView.dequeueReusableCell(withIdentifier: "dateOfBirthCell", for: indexPath) as? DateOfBirthCell else {
            
            fatalError("DateOfBirthCell Not Found !")
        }
        dateOfBirthCell.cellBtnOutlt.isHidden = true
        dateOfBirthCell.celltextField.delegate = self
        
        dateOfBirthCell.celltitleBtn.setTitle(cellTitleArray[indexPath.row], for: .normal)
        
        dateOfBirthCell.celltextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_next_arrow"))
        dateOfBirthCell.celltextField.rightViewMode = .always
        
        dateOfBirthCell.celltitleBtn.addTarget(self, action: #selector(dateOfBirthBtnActn(sender:)), for: .touchUpInside)
        
        let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldtap(_:)))
        dateOfBirthCell.celltextField.rightView?.addGestureRecognizer(rightViewTapGesture)
        
        dateOfBirthCell.populateData(self.userInfo)
        
        return dateOfBirthCell
            
        case 3: guard let genderDetailCell = tableView.dequeueReusableCell(withIdentifier: "genderDetailCell", for: indexPath) as? GenderDetailCell else {
            
            fatalError("GenderDetailCell Not Found !")
        }
        
        genderDetailCell.cellTitle.text = cellTitleArray[indexPath.row]
        genderDetailCell.maleLabel.text = K_GENDER_MALE_PLACEHOLDER.localized
        genderDetailCell.femaleLabel.text = K_GENDER_FEMALE_PLACEHOLDER.localized
        
        if let genderStatus = self.userInfo.patientGender {       
            
            if genderStatus == gender.male.rawValue {
                
                genderDetailCell.genderBtn.isSelected = false
                genderDetailCell.genderBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on"), for: .normal)
                genderDetailCell.maleLabel.textColor = UIColor.appColor
                genderDetailCell.femaleLabel.textColor = UIColor.grayLabelColor
                
            }else{
                
                genderDetailCell.genderBtn.isSelected = true
                genderDetailCell.genderBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                genderDetailCell.femaleLabel.textColor = UIColor.appColor
                genderDetailCell.maleLabel.textColor = UIColor.grayLabelColor
                
            }
        }else{
            
            genderDetailCell.genderBtn.isSelected = false
            genderDetailCell.genderBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on"), for: .normal)
            genderDetailCell.maleLabel.textColor = UIColor.appColor
            genderDetailCell.femaleLabel.textColor = UIColor.grayLabelColor
            
        }
 
        genderDetailCell.genderBtn.addTarget(self, action: #selector(genderSelection(_:)), for: .touchUpInside)
        
        return genderDetailCell
            
        case 4: guard let phoneNumberCell = tableView.dequeueReusableCell(withIdentifier: "phoneNumberCell", for: indexPath) as? PhoneNumberCell else {
            
            fatalError("PhoneNumberCell Not Found !")
        }
        
        phoneNumberCell.cellTitleBtn.setTitle(cellTitleArray[indexPath.row], for: .normal)
 
        phoneNumberCell.cellTextField.delegate = self
        phoneNumberCell.cellTextField.keyboardType = .numberPad
        phoneNumberCell.cellTitleBtn.addTarget(self, action: #selector(phoneNumberBtnActn(sender:)), for: .touchUpInside)
        
        phoneNumberCell.populateDataForNumber(self.userInfo)
        
        return phoneNumberCell
            
        case 5...6: guard let fatherNameCell = tableView.dequeueReusableCell(withIdentifier: "FatherNameCell", for: indexPath) as? FatherNameCell else{
            
            fatalError("Father Name Cell not Found!")
        }
        
        fatherNameCell.cellLabel.text = cellTitleArray[indexPath.row]
        fatherNameCell.cellSelectTitle.delegate = self
        fatherNameCell.cellTextField.delegate  = self
        
        if indexPath.row == 5{
            
           fatherNameCell.cellSelectTitle.text = "Mr."
        }else{
            
            
           fatherNameCell.cellSelectTitle.text = "Mrs."
        }
        
        let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldtap(_:)))
        fatherNameCell.cellSelectTitle.rightView?.addGestureRecognizer(rightViewTapGesture)
        
        switch indexPath.row{
            
        case 5: fatherNameCell.cellTextField.delegate = self
        
           fatherNameCell.cellSelectTitle.text = K_MR_PLACEHOLDER.localized
            fatherNameCell.populateDataForFather(self.userInfo)
            
        case 6: fatherNameCell.cellTextField.delegate = self
        
        fatherNameCell.cellSelectTitle.text = K_MRS_PLACEHOLDER.localized
            fatherNameCell.populateDataForSpouse(self.userInfo)
            
        default: fatalError("FatherName cell Not Found!")
        }
        
        return fatherNameCell
            
        case 7: guard let adhaardCardNumberCell = tableView.dequeueReusableCell(withIdentifier: "phoneNumberCell", for: indexPath) as? PhoneNumberCell else {
            
            fatalError("PhoneNumberCell Not Found !")
        }

        adhaardCardNumberCell.cellTextField.returnKeyType = .done
        adhaardCardNumberCell.cellTextField.delegate = self

        adhaardCardNumberCell.cellTitleBtn.setTitle(cellTitleArray[indexPath.row], for: .normal)
        adhaardCardNumberCell.cellTitleBtn.addTarget(self, action: #selector(phoneNumberBtnActn(sender:)), for: .touchUpInside)
        
        adhaardCardNumberCell.populateDataForAdhaarCardNumber(self.userInfo)
        
        return adhaardCardNumberCell
            
        default: fatalError("TaleViewCell Not Found !")
            
        }
    }
}

//MARK:- UITableViewDelegate Methods
// =================================
extension PersonalInformationVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
            
        case 0: return 118
        case 1: return 65
        case 2...4 : return 43
        case 5...6: return 65
        case 7: return 45
        default: fatalError("Cell Not Found!")
            
        }
        
        return UITableViewAutomaticDimension
    }
}

//MARK:- UITextFieldDelegate methods
// ==================================

extension PersonalInformationVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard let index = textField.tableViewIndexPathIn(self.profileInformationTableView) else{
            
            return
        }
        
        MultiPicker.noOfComponent = 1
        switch index.row {
            
        case 0 : guard let userImageCell = self.profileInformationTableView.cellForRow(at: index) as? UserImageCell else{
            
            return
        }
        
        if userImageCell.genderStatusTextField.isFirstResponder {
            
            MultiPicker.openPickerIn(userImageCell.genderStatusTextField, firstComponentArray: genderStatus, secondComponentArray: [], firstComponent: userImageCell.genderStatusTextField.text, secondComponent: nil, titles: ["Choose Gender"]) { (firstValue, _,_,_) in
                printlnDebug(firstValue)
                
                userImageCell.genderStatusTextField.text = firstValue
                printlnDebug(firstValue)
                self.userInfo.patientTitle = userImageCell.genderStatusTextField.text ?? ""
                
                self.profileInformationTableView.reloadRows(at: [index], with: .none)
                
            }
        }

        case 1: return
        case 2 : guard let dateOfBirthCell = textField.getTableViewCell as? DateOfBirthCell else{return}
        
        DatePicker.openPicker(in: dateOfBirthCell.celltextField, currentDate: nil, minimumDate: nil, maximumDate: nil, pickerMode: .date, doneBlock: { (Date) in
            
            let dateInString = Date.stringFormDate(DateFormat.yyyyMMdd.rawValue)
            
            dateOfBirthCell.celltextField.text = dateInString
            
            self.userInfo.patientDob = Date
            printlnDebug(Date)
        })
            
        case 3,4 : return
            
        case 5...6 : guard let fatherCell  = self.profileInformationTableView.cellForRow(at: index) as? FatherNameCell else{
            
            return
        }
        
        MultiPicker.openPickerIn(fatherCell.cellSelectTitle, firstComponentArray: genderStatus, secondComponentArray: [], firstComponent: fatherCell.cellSelectTitle.text, secondComponent: nil, titles: ["Choose Gender"]) { (firstValue, _,_,_) in

            fatherCell.cellSelectTitle.text = firstValue

            if index.row == 5{
                
                self.userInfo.patientFatherTitle = fatherCell.cellSelectTitle.text ?? ""
            }
            else {
                
                self.userInfo.patientSpouseTitle = fatherCell.cellSelectTitle.text ?? ""
            }
            self.profileInformationTableView.reloadRows(at: [index], with: .none)
            }
        case 7: return
        default: fatalError("TextField Celll Not Found !")
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let indexpath = textField.tableViewIndexPathIn(profileInformationTableView)
            else{
                
                return true
        }
        
        switch indexpath.row {
            
        case 0: guard let userImageCell = self.profileInformationTableView.cellForRow(at: indexpath) as? UserImageCell else {
            
            return true
        }
        
        delay(0.1, closure: {
            
            self.userInfo.patientFirstname = userImageCell.celltextField.text ?? ""
            self.userInfo.patientMiddleName = userImageCell.middleNameTextField.text ?? ""
            self.userInfo.patientLastName = userImageCell.lastNameTextField.text ?? ""
            
        })
            
        case 1: guard let emailAddressCell = self.profileInformationTableView.cellForRow(at: indexpath) as? EmailCell else {
            return true
        }
        
        delay(0.1, closure: {
            
            self.userInfo.patientEmail = emailAddressCell.celltextField.text ?? ""
            
        })
            
        case 2 , 3: break
            
        case 4: guard let phoneNumber = self.profileInformationTableView.cellForRow(at: indexpath) as? PhoneNumberCell else {
            return true
        }
        
        delay(0.1, closure: {
            
            self.userInfo.patientMobileNumber = phoneNumber.cellTextField.text ?? ""
            
        })
            
        case 5: guard let phoneNumber = self.profileInformationTableView.cellForRow(at: indexpath) as? FatherNameCell else {return true}
        
        delay(0.1, closure: {
            
            
            self.userInfo.patientFathername = phoneNumber.cellTextField.text ?? ""
            
        })
            
        case 6: guard let phoneNumber = self.profileInformationTableView.cellForRow(at: indexpath) as? FatherNameCell else {return true}
        
        delay(0.1, closure: {
            
            self.userInfo.patientSpouseName = phoneNumber.cellTextField.text ?? ""
            
        })
            
        case 7: guard let phoneNumberCell = self.profileInformationTableView.cellForRow(at: indexpath) as? PhoneNumberCell else {return true}
        
        delay(0.1, closure: {
            
            if let phoneNumber = phoneNumberCell.cellTextField.text{
                
                
                
                self.userInfo.patientNationalId = phoneNumber
            }
        })
        if textField === phoneNumberCell.cellTextField {
            var str = ""
            if (range.location==4 || range.location==9 || range.location==14) && range.length==0{
                str = "-" + string
                textField.text = textField.text! + str
                return false
            }
            if range.location>=12 && range.length<1{
                return false
            }
        }
                        
        default: fatalError("Cell Not Found!")
            
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        guard let indexpath = textField.tableViewIndexPathIn(profileInformationTableView)
            else{return true}
        let nextIndexpath = NSIndexPath(row: indexpath.row + 1, section: 0) as IndexPath
        
        
        switch indexpath.row {
            
        case 0: guard let userImageCell = textField.getTableViewCell as? UserImageCell else{return true}
        
        if userImageCell.celltextField.isFirstResponder{
            
            userImageCell.middleNameTextField.becomeFirstResponder()
        
        }else if userImageCell.middleNameTextField.isFirstResponder{
           
            userImageCell.lastNameTextField.becomeFirstResponder()
        
        }else if userImageCell.lastNameTextField.isFirstResponder{
            
            guard let emailAddressCell = self.profileInformationTableView.cellForRow(at: nextIndexpath) as? EmailCell else {return true}
            
            emailAddressCell.celltextField.becomeFirstResponder()
            }
        case 1: guard let dateOfbirthCell = self.profileInformationTableView.cellForRow(at: nextIndexpath) as? DateOfBirthCell else{return true}
        
        dateOfbirthCell.celltextField.becomeFirstResponder()
            
        case 2: guard let dateOfbirthCell = self.profileInformationTableView.cellForRow(at: nextIndexpath) as? DateOfBirthCell else{return true}
        
        dateOfbirthCell.celltextField.resignFirstResponder()
            
        case 3: break

        case 4: guard let fatherCell = self.profileInformationTableView.cellForRow(at: nextIndexpath) as? FatherNameCell else{return true}
            
              fatherCell.cellTextField.becomeFirstResponder()
            
        case 5: guard let spouseCell = self.profileInformationTableView.cellForRow(at: nextIndexpath) as? FatherNameCell else{return true}
        
        spouseCell.cellTextField.becomeFirstResponder()
            
        case 6 : guard let adhaarCardCell = self.profileInformationTableView.cellForRow(at: nextIndexpath) as? PhoneNumberCell else{return true}
        
        adhaarCardCell.cellTextField.becomeFirstResponder()
            
        case 7: guard let phoneNumberCell = self.profileInformationTableView.cellForRow(at: nextIndexpath) as? PhoneNumberCell else{return true}
        
         phoneNumberCell.cellTextField.resignFirstResponder()
            
        default: fatalError("cell Not Found")
            
        }
        return true
    }
}

//MARK:- UIImagePickerControllerDelegate Methods
// =============================================

extension PersonalInformationVC :  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        dismiss(animated: true, completion: nil)
        guard let choosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
            
        self.userImage = choosenImage
        self.userInfo.patientPic = ""
        self.buildProfileVC.userImage = choosenImage
        
        profileInformationTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Methods
//==============
extension PersonalInformationVC {
    
    //    MARK:- setUp The NibFiles
    //    =========================
    fileprivate func setUpViews(){
        
        let userImageNib = UINib(nibName: "UserImageCell", bundle: nil)
        profileInformationTableView.register(userImageNib, forCellReuseIdentifier: "userImageCell")
        
        let emailNib = UINib(nibName: "EmailCell", bundle: nil)
        profileInformationTableView.register(emailNib, forCellReuseIdentifier: "emailCell")
        
        let dateOfBirthNib = UINib(nibName: "DateOfBirthCell", bundle: nil)
        profileInformationTableView.register(dateOfBirthNib, forCellReuseIdentifier: "dateOfBirthCell")
        
        let genderDetailNib = UINib(nibName: "GenderDetailCell", bundle: nil)
        profileInformationTableView.register(genderDetailNib, forCellReuseIdentifier: "genderDetailCell")
        
        let phoneNumberNib = UINib(nibName: "PhoneNumberCell", bundle: nil)
        profileInformationTableView.register(phoneNumberNib, forCellReuseIdentifier: "phoneNumberCell")
        
        let fatherNameCell = UINib(nibName: "FatherNameCell", bundle: nil)
        profileInformationTableView.register(fatherNameCell, forCellReuseIdentifier: "FatherNameCell")
        
    }
    
    //    MARK:- ActionSheet To Open the Camera
    //    =====================================
    @objc fileprivate func openActionSheet(){
        
        let alert = UIAlertController(title: "Choose Image" , message: "", preferredStyle: .actionSheet)
        let cameraActn = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            self.photoFromcamera()
            printlnDebug("Camera")
        }
        
        let galleryActn = UIAlertAction(title: "Gallery", style: .default) { (UIAlertAction) in
            
            self.photoFromGallery()
            printlnDebug("Gallery")
        }
        let cancelBtnActn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.removeFromParentViewController()
        alert.addAction(cameraActn)
        alert.addAction(galleryActn)
        alert.addAction(cancelBtnActn)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //    MARK:- Capture Photo from camera
    //       =============================
    fileprivate func photoFromcamera(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            picker.allowsEditing = true
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    //    MARK:- Select Photo from Gallery
    //     ===============================
    fileprivate func photoFromGallery(){
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
            picker.delegate = self
            picker.modalPresentationStyle = .popover
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    //    MARK:- Gender Selection
    //     =======================
    @objc fileprivate func genderSelection(_ sender : UIButton ){
        
        guard let index = sender.tableViewIndexPathIn(self.profileInformationTableView) else{
            
            return
        }
        guard let cell = self.profileInformationTableView.cellForRow(at: index) as? GenderDetailCell else{
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            cell.genderBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
            cell.femaleLabel.textColor = UIColor.appColor
            cell.maleLabel.textColor = UIColor.grayLabelColor
            
            userInfo.patientGender = gender.female.rawValue
        }
        else{
            cell.genderBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on"), for: .normal)
            cell.maleLabel.textColor = UIColor.appColor
            cell.femaleLabel.textColor = UIColor.grayLabelColor
            
            userInfo.patientGender = gender.male.rawValue
        }
        
        self.profileInformationTableView.reloadRows(at: [index], with: .none)
    }
    
    //    MARK: Cell Title Button Actions
    //    ================================
    @objc fileprivate func dateOfBirthBtnActn(sender : UIButton){
        
        let index = sender.tableViewIndexPathIn(self.profileInformationTableView)
        guard let dateOfBirthcell = profileInformationTableView.cellForRow(at: index! as IndexPath) as? DateOfBirthCell else{
            fatalError("GenderCell not Found !")
        }
        dateOfBirthcell.celltextField.becomeFirstResponder()
    }
    
    @objc fileprivate func phoneNumberBtnActn(sender : UIButton){
        
        let index = sender.tableViewIndexPathIn(self.profileInformationTableView)
        guard let phoneNumbercell = profileInformationTableView.cellForRow(at: index! as IndexPath) as? PhoneNumberCell else{
            fatalError("phoneNumbercell not Found !")
        }
        phoneNumbercell.cellTextField.becomeFirstResponder()
    }
    
    //    MARK: Tap on icon of textfield
    //    ==============================
    func textFieldtap(_ sender : UITapGestureRecognizer){
        
        textFieldTapped(sender)
    }
}
