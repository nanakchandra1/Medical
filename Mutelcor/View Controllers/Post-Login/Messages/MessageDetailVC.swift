//
//  MessageDetailVC.swift
//  Mutelcor
//
//  Created by on 03/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import TransitionButton

class MessageDetailVC: BaseViewControllerWithBackButton {
    
    //    MARK:- Properties
    //    =================
    fileprivate var timer = Timer()
    fileprivate  let kMessageViewHeight : CGFloat = 30
    fileprivate  var fontHeight: CGFloat!
    fileprivate  var oldCountOfLines = 1
    fileprivate  var nextHit = 0
    fileprivate  var searchData: String?
    fileprivate  var searchBtnTapped = false
    var patientMessagesData = [PatientMessageModel]()
    fileprivate var oldMessage = [String: [PatientLatestMessages]]()
    fileprivate var sortedDateArray: [Date] = []
    fileprivate var sortedSearchDateArray: [Date] = []
    fileprivate  var searchMessage = [String: [PatientLatestMessages]]()
    var saveMessagesDic = [String: Any]()
    var threeDotBtnTapped: Bool = false
    fileprivate var isDataCalculated: Bool = true
    
    //    MARK:- IBOutlets
    //    ================
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backBtnOutlt: UIButton!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var appointmentBtnOutlt: UIButton!
    @IBOutlet weak var moreBtnOutlt: UIButton!
    @IBOutlet weak var messageDetailTableView: UITableView!
    @IBOutlet weak var bottomSendView: UIView!
    @IBOutlet weak var enterDescriptionView: UIView!
    @IBOutlet weak var sendDataTextView: IQTextView!
    @IBOutlet weak var sendBtnView: TransitionButton!
    @IBOutlet weak var sendBtnOutlt: TransitionButton!
    @IBOutlet weak var popupContainerView: UIView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var cancelBtnOutlt: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var messageBoxBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageBoxHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var popupTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerLabelView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!

    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        keyBoardMgr()
        
        self.getOldMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let nvc = self.navigationController else{
            return
        }
        nvc.navigationBar.setValue(false, forKey: "hidesShadow")
        self.addBtnDisplayedFor = .messageDetail
        nvc.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let nvc = self.navigationController else{
            return
        }
        nvc.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.outerView.gradient(withX: 0, withY: 0, cornerRadius: false)
        self.searchView.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(NSNotification.Name.UIKeyboardWillShow)
        NotificationCenter.default.removeObserver(NSNotification.Name.UIKeyboardWillHide)
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().enable = true
        self.timer.invalidate()
    }
    
    //    MARK:- Private Methods
    //    ======================
    func keyBoardMgr(){
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !searchBtnTapped {
                UIView.animate(withDuration: 0.33, animations: {
                    self.messageBoxBottomConstraint.constant = keyboardSize.height
                    
                    self.view.layoutIfNeeded()
                }, completion: { (true) in
                    
                })
            }
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if !searchBtnTapped {
            UIView.animate(withDuration: 0.33, animations: {
                self.messageBoxBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    //    MARK:- IBActions
    //    ================
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreBtnTapped(_ sender: UIButton) {
//        self.threeDotBtnTapped = !self.threeDotBtnTapped
        if !appointmentBtnTapped {
            let height: CGFloat = self.outerView.frame.height - 20
            self.appointmentButtonTapped(height)
        }
        self.morePopUpHidden()
    }
    
    @IBAction func sendBtnTapped(_ sender: TransitionButton) {
        hidePopUpsIfNeeded()
        self.sendDataTextView.text = ""
        self.sendBtnOutlt.isEnabled = false
        guard let message = self.saveMessagesDic["message"] as? String, !message.isEmpty else{
            showToastMessage(AppMessages.emptyMessage.rawValue.localized)
            return
        }
        sendBtnView.backgroundColor = UIColor.appColor
        sendBtnView.startAnimation()
        sender.isHidden = true
        self.messageSave()
    }
    
    @IBAction func searchBtnTapped(_ sender: UIButton) {
//        self.threeDotBtnTapped = !self.threeDotBtnTapped

        hidePopUpsIfNeeded()
        self.moreBtnOutlt.isHidden = true
        self.searchTextField.text = ""
        self.morePopUpHidden()
        self.doctorImageView.isHidden = true
        self.doctorNameLabel.isHidden = true
        self.doctorSpeciality.isHidden = true
        self.appointmentBtnOutlt.isHidden = true
        self.searchView.isHidden = false

        UIView.animate(withDuration: 0.33) {
            self.messageBoxBottomConstraint.constant =  -self.bottomSendView.frame.height
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func emailChatBtnTapped(_ sender: UIButton) {
//        self.threeDotBtnTapped = !self.threeDotBtnTapped
        self.morePopUpHidden()
        self.sendPdf()
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.3) {
            self.messageBoxBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }

        self.searchMessage = [:]
        self.moreBtnOutlt.isHidden = false
        self.doctorImageView.isHidden = false
        self.doctorNameLabel.isHidden = false
        self.doctorSpeciality.isHidden = false
        self.appointmentBtnOutlt.isHidden = false
        self.searchView.isHidden = true
        
        if self.searchBtnTapped {
            self.searchBtnTapped = false
            self.messageDetailTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
            self.messageDetailTableView.reloadData()
        }
    }
    @IBAction func appointmentBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.threeDotBtnTapped{
            self.morePopUpHidden()
        }
        let height: CGFloat = self.outerView.frame.height - 20
        self.appointmentButtonTapped(height)
    }

    fileprivate func hidePopUpsIfNeeded() {
        if self.threeDotBtnTapped{
            self.morePopUpHidden()
        }
        if !appointmentBtnTapped {
            let height: CGFloat = self.outerView.frame.height - 20
            self.appointmentButtonTapped(height)
        }
    }
}

//MARK:- UITableViewDataSource Methods
//=====================================
extension MessageDetailVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionInTable = !self.searchBtnTapped ? self.sortedDateArray.count : self.sortedSearchDateArray.count
        return sectionInTable
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchBtnTapped {
            let dateKey = self.sortedDateArray[section].timeIntervalSince1970
            if let patientMessage = self.oldMessage["\(dateKey)"] {
                return patientMessage.count
            }else{
                return 0
            }
        }else{
            let searchDateKey = self.sortedSearchDateArray[section].timeIntervalSince1970
            if let patientMessage = self.searchMessage["\(searchDateKey)"] {
                return patientMessage.count
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let receiverCell = tableView.dequeueReusableCell(withIdentifier: "receiverCellID", for: indexPath) as? ReceiverCell else{
            fatalError("Receiver Cell Not Found!")
        }
        
        guard let senderCell = tableView.dequeueReusableCell(withIdentifier: "senderCellID", for: indexPath) as? SenderCell else{
            fatalError("Sender Cell Not Found!")
        }
        
        switch self.searchBtnTapped {
            
        case true :
            let searchDateKey = self.sortedSearchDateArray[indexPath.section].timeIntervalSince1970
            if let patientMessage = self.searchMessage["\(searchDateKey)"] {
                if patientMessage[indexPath.row].senderId == AppUserDefaults.value(forKey: .userId).intValue {
                    receiverCell.transform = CGAffineTransform(scaleX: 1, y: 1)
                    receiverCell.populateReceiverData(patientMessage, indexPath: indexPath)
                    return receiverCell
                }else{
                    senderCell.transform = CGAffineTransform(scaleX: 1, y: 1)
                    senderCell.populateSenderData(patientMessage, indexPath: indexPath)
                    return senderCell
                }
            }else{
                fatalError("Data Not Found!")
            }
            
        case false :
            let dateKey = self.sortedDateArray[indexPath.section].timeIntervalSince1970
            if let patientMessage = self.oldMessage["\(dateKey)"] {
                if patientMessage[indexPath.row].senderId == AppUserDefaults.value(forKey: .userId).intValue {
                    receiverCell.transform = CGAffineTransform(scaleX: 1, y: -1)
                    receiverCell.populateReceiverData(patientMessage, indexPath: indexPath)
                    return receiverCell
                }else{
                    senderCell.transform = CGAffineTransform(scaleX: 1, y: -1)
                    senderCell.populateSenderData(patientMessage, indexPath: indexPath)
                    return senderCell
                }
            }else{
                fatalError("Data Not Found!")
            }
        }
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension MessageDetailVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerViewCellID") as? HeaderViewCell else{
            fatalError("HeaderView Not Found!")
        }
         headerView.contentView.backgroundColor = UIColor.clear
        headerView.transform = CGAffineTransform(scaleX: 1, y: -1)
        headerView.dateTextView.isHidden = false
        headerView.MessageDateLabel.isHidden = false
        headerView.headerImage.isHidden = true
        headerView.headerTitle.isHidden = true
        if !self.searchBtnTapped {
            let date = self.sortedDateArray[section]
            if date.stringFormDate(.ddMMMYYYY) == Date().stringFormDate(.ddMMMYYYY){
                self.headerLabelView.isHidden = true
                headerView.MessageDateLabel.text = "Today"
            }else{
                self.headerLabelView.isHidden = false
                headerView.MessageDateLabel.text = date.stringFormDate(.ddMMMYYYY)
            }
        }
        let returnView = !self.searchBtnTapped ? headerView : nil
        return returnView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerViewCellID") as? HeaderViewCell else{
            fatalError("HeaderView Not Found!")
        }
        headerView.contentView.backgroundColor = UIColor.clear
        headerView.transform = CGAffineTransform(scaleX: 1, y: 1)
        headerView.dateTextView.isHidden = false
        headerView.MessageDateLabel.isHidden = false
        headerView.headerImage.isHidden = true
        headerView.headerTitle.isHidden = true
        if self.searchBtnTapped {
            let date = self.sortedSearchDateArray[section]
            if date.stringFormDate(.ddMMMYYYY) == Date().stringFormDate(.ddMMMYYYY){
                self.headerLabelView.isHidden = true
                headerView.MessageDateLabel.text = "Today"
            }else{
                self.headerLabelView.isHidden = false
                headerView.MessageDateLabel.text = date.stringFormDate(.ddMMMYYYY)
            }
        }
        let returnView = self.searchBtnTapped ? headerView : nil
        return returnView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let heightForFooter = !self.searchBtnTapped ? 40 : CGFloat.leastNormalMagnitude
        return heightForFooter
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let heightForHeader = self.searchBtnTapped ? 40 : CGFloat.leastNormalMagnitude
        return heightForHeader
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hidePopUpsIfNeeded()
    }
}

//MARK:- UIScrollViewDelegate Method
//==================================
extension MessageDetailVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        guard let cell = self.messageDetailTableView.visibleCells.last else{
            return
        }
        guard let index = self.messageDetailTableView.indexPath(for: cell) else{
            return
        }
        let date = self.sortedDateArray[index.section]
        if date.stringFormDate(.ddMMMYYYY) == Date().stringFormDate(.ddMMMYYYY){
           self.headerLabelView.isHidden = true
           self.headerLabel.text = "Today"
        }else{
            self.headerLabelView.isHidden = false
          self.headerLabel.text = date.stringFormDate(.ddMMMYYYY)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if !self.oldMessage.isEmpty {
            self.headerViewHidden(isHidden: false)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.headerViewHidden(isHidden: true)
        
        if self.isDataCalculated,
            scrollView === self.messageDetailTableView,
            let date = self.sortedDateArray.last?.timeIntervalSince1970,
            !"\(date)".isEmpty {
            self.saveMessagesDic["first_msg_id"] = self.oldMessage["\(date)"]?.last?.messageId
            
            if self.nextHit == 1 {
                self.getOldMessages()
            }
        }
    }
}

//MARK:- Methods
//==============
extension MessageDetailVC {
    
    fileprivate func setupUI(){
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        sendDataTextView.delegate = self
        popupContainerView.layer.cornerRadius = 4
        
        self.sendBtnOutlt.isEnabled = false
        self.floatBtn.isHidden = true
        
        self.backBtnOutlt.setImage(#imageLiteral(resourceName: "icAppointmentBack"), for: .normal)
        self.doctorImageView.roundCorner(radius: self.doctorImageView.frame.width / 2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.doctorNameLabel.textColor = UIColor.white
        self.doctorNameLabel.font = AppFonts.sanProSemiBold.withSize(18.1)
        self.doctorSpeciality.textColor = UIColor.white
        self.doctorSpeciality.font = AppFonts.sansProRegular.withSize(14)
        self.appointmentBtnOutlt.setImage(#imageLiteral(resourceName: "icAppointmentInfo"), for: .normal)
        self.moreBtnOutlt.setImage(#imageLiteral(resourceName: "icMessagesMore"), for: .normal)
        
        self.bottomSendView.backgroundColor = UIColor.appColor
        self.enterDescriptionView.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.sendBtnView.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.sendBtnOutlt.setImage(#imageLiteral(resourceName: "icMessagesSend"), for: .normal)
        self.messageBoxHeightConstraint.constant = 35
        self.searchView.isHidden = true
        self.cancelBtnOutlt.setTitle(K_CANCEL_BUTTON.localized, for: .normal)
        self.cancelBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.searchTextField.returnKeyType = .search
        self.searchTextField.font = AppFonts.sansProRegular.withSize(16)
        self.searchTextField.delegate = self
        //self.searchTextField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        self.messageDetailTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.saveMessagesDic["first_msg_id"] = ""
        self.messageDetailTableView.dataSource = self
        self.messageDetailTableView.delegate = self
        
        self.headerLabelView.roundCorner(radius: 3, borderColor: UIColor.clear, borderWidth: 0.0)
        self.headerLabelView.backgroundColor = UIColor.appColor
        self.headerLabelView.shadow(2.0, CGSize.init(width: 1.0, height: 1.0), UIColor.navigationBarShadowColor, opacity: 1.0)
        self.headerLabelView.isHidden = true
        self.headerLabel.textColor = UIColor.white
        self.headerLabel.font = AppFonts.sansProRegular.withSize(12)
        self.headerView.shadow(10.0, .zero, UIColor.appColor, opacity: 0.6)
        
        self.appointmentBtnOutlt.isSelected = false
        
        self.headerViewHidden(isHidden: true)
        self.registerNibs()
        self.populateDataOnHeader()
    }
    
    fileprivate func morePopUpHidden(){
        let isMoreHidden = (popupTopConstraint.constant == -8)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            self.popupTopConstraint.constant = (isMoreHidden ? 25:-8)
            self.popupContainerView.alpha = (isMoreHidden ? 0:1)
            self.threeDotBtnTapped = isMoreHidden ? false : true

            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func headerViewHidden(isHidden: Bool = false){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.headerViewTopConstraint.constant = (!isHidden ? 10:0 )
            self.headerLabelView.alpha = (!isHidden ? 1:0)
            self.view.layoutIfNeeded()
        }, completion:  { (true) in
            self.headerLabelView.isHidden = isHidden
        })
    }
    
    fileprivate func registerNibs(){
        
        let senderNibs = UINib(nibName: "SenderCell", bundle: nil)
        self.messageDetailTableView.register(senderNibs, forCellReuseIdentifier: "senderCellID")
        
        let receiverNibs = UINib(nibName: "ReceiverCell", bundle: nil)
        self.messageDetailTableView.register(receiverNibs, forCellReuseIdentifier: "receiverCellID")
        
        let headerView = UINib(nibName: "HeaderViewCell", bundle: nil)
        self.messageDetailTableView.register(headerView, forHeaderFooterViewReuseIdentifier: "headerViewCellID")
    }
    
    fileprivate func populateDataOnHeader(){
        if let personImage = self.patientMessagesData[0].doctorPic, !personImage.isEmpty{
            let percentageEncodingStr = personImage.replacingOccurrences(of: " ", with: "%20")
            let imgUrl = URL(string: percentageEncodingStr)
            self.doctorImageView.af_setImage(withURL: imgUrl!, placeholderImage: #imageLiteral(resourceName: "personal_info_place_holder"))
        }
        
        self.doctorNameLabel.text = self.patientMessagesData[0].personName
        self.doctorSpeciality.text = self.patientMessagesData[0].docSpecailization
        self.saveMessagesDic["receiver_id"] = self.patientMessagesData[0].personID
    }
}

//    MARK:- TextView Delegate
//    ========================
extension MessageDetailVC: UITextViewDelegate{

    func textViewDidBeginEditing(_ textView: UITextView) {
        hidePopUpsIfNeeded()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == " " && range.location == 0{
            self.sendBtnOutlt.isEnabled = false
            return false
        }
        
        delay(0.1) {
            let isBtnEnabled = !textView.text.isEmpty ? true : false
            self.sendBtnOutlt.isEnabled = isBtnEnabled
            self.saveMessagesDic["message"] = textView.text
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        hidePopUpsIfNeeded()

        let topBottomPadding: CGFloat = 16
        let threeLineTextHeight: CGFloat = 57
        
        let minimumTextHeight: CGFloat = 35
        let maximumTextHeight: CGFloat = (threeLineTextHeight + topBottomPadding)
        let textHeight = textView.text.stringHeight(withConstrainedWidth: (textView.frame.width - 10.0), font: textView.font!)
        
        if textHeight > threeLineTextHeight {
            textView.isScrollEnabled = true
            self.messageBoxHeightConstraint.constant = maximumTextHeight

        } else {
            textView.isScrollEnabled = false
            self.messageBoxHeightConstraint.constant = max(minimumTextHeight, textHeight + topBottomPadding)
        }

        //animateTableScroll()
    }
    
    func animateTableScroll() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: { 
            self.view.layoutIfNeeded()
            self.messageDetailTableView.scrollToTop(animated: true)
        })
    }
}

//MARK:- UITextFieldDelegate Methods
//===================================
extension MessageDetailVC : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchBtnTapped = true
        hidePopUpsIfNeeded()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hidePopUpsIfNeeded()
        delay(0.1) {
            self.searchData = textField.text ?? ""
            self.searchMessage = [:]
            if let searchText = self.searchData, !searchText.isEmpty {
                for date in self.sortedDateArray {
                    let sortedDate = date.timeIntervalSince1970
                    if let message = self.oldMessage["\(sortedDate)"]{
                        let filterMessage = message.filter({ (data) -> Bool in
                            if let text = data.message?.lowercased() {
                                if text.contains(searchText.lowercased()){
                                    return true
                                }
                            }
                            return false
                        })
                        if !filterMessage.isEmpty {
                            self.searchMessage["\(sortedDate)"] = filterMessage
                        }else{
                            //self.searchMessage = [:]
                        }
                    }
                }
                
                let sortedSearchDataKeys: [Date] = Array(self.searchMessage.keys).map({ (date) -> Date in
                    if let interval = TimeInterval(date){
                        let dateValue = Date.init(timeIntervalSince1970: interval)
                        return dateValue
                    }else{
                        return Date()
                    }
                }).sorted().reversed()
                
                self.sortedSearchDateArray = sortedSearchDataKeys
                if self.searchBtnTapped {
                    self.messageDetailTableView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            } else {
                self.searchMessage = self.oldMessage
            }
            
            self.messageDetailTableView.reloadData()

        }
        return true
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        hidePopUpsIfNeeded()
//        textField.resignFirstResponder()
//
//        return true
//    }
    
}

//MARK:- WebServices Methods
//===========================
extension MessageDetailVC {
    
    fileprivate func messageSave() {
        
        if let key = self.sortedDateArray.last?.timeIntervalSince1970,
            !"\(key)".isEmpty, !self.oldMessage.isEmpty{
            self.saveMessagesDic["last_msg_id"] = self.oldMessage["\(key)"]?.first?.messageId
        }
        
        WebServices.saveMessages(parameters: self.saveMessagesDic,
                                 success: {[weak self] (_ saveMesssages : [String: [PatientLatestMessages]]) in
                                    
                                    guard let messageDetailVC = self else {
                                        return
                                    }
                                    
                                    messageDetailVC.sendBtnView.stopAnimation(animationStyle: .normal, completion: {
                                        messageDetailVC.sendBtnView.backgroundColor = UIColor.white
                                        messageDetailVC.sendBtnOutlt.isHidden = false
                                    })
                                    messageDetailVC.saveMessagesDic["message"] = ""
                                    messageDetailVC.sendBtnOutlt.isEnabled = false
                                    messageDetailVC.messageBoxHeightConstraint.constant = 30
                                    messageDetailVC.sendDataTextView.text = ""
                                    messageDetailVC.timer.invalidate()
                                    messageDetailVC.timer = Timer.scheduledTimer(timeInterval: 3, target: messageDetailVC, selector: #selector(messageDetailVC.getLatestMessages), userInfo: nil, repeats: true)
        }) {[weak self] (error) in
            guard let messageDetailVC = self else {
                return
            }
             messageDetailVC.sendBtnView.stopAnimation()
            showToastMessage(error.localizedDescription)
        }
    }
    
    @objc fileprivate func getLatestMessages(){
        let date = self.sortedDateArray.first?.timeIntervalSince1970
        if let key = date, !"\(key)".isEmpty {
            self.saveMessagesDic["last_msg_id"] = self.oldMessage["\(key)"]?.first?.messageId
        }else{
            self.saveMessagesDic["last_msg_id"] = ""
        }
        WebServices.getPatientLatestMessage(parameters: self.saveMessagesDic,
                                            loader : false,
                                            success: {[weak self] (_ latestMesssage : [String: [PatientLatestMessages]]) in

                                                guard let messageDetailVC = self else{
                                                    return
                                                }
                                                if !latestMesssage.isEmpty {
                                                    messageDetailVC.sortedDateArray(latestMesssage)
                                                    messageDetailVC.addMessages(latestMesssage)
                                                }
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    func addMessages(_ messages : [String: [PatientLatestMessages]]){
        if !messages.isEmpty {
            let messagesKey = Array(messages.keys)
            let lastDate = self.sortedDateArray.first?.timeIntervalSince1970
            
            for (_, messageDate) in messagesKey.enumerated() {
                if let data = messages[messageDate], let interval = lastDate, !"\(interval)".isEmpty {
                    if messageDate == "\(interval)" {
                        for (index, value) in data.enumerated() {
                            if let _ = self.oldMessage[messageDate]{
                               self.oldMessage[messageDate]?.insert(value, at: index)
                                let indexPath = IndexPath.init(row: index, section: 0)
                                self.messageDetailTableView.insertRows(at: [indexPath], with: .bottom)
                                self.messageDetailTableView.reloadRows(at: [indexPath], with: .bottom)
                            }else{
                               self.oldMessage[messageDate] = messages[messageDate]
                                self.messageDetailTableView.reloadData()
                            } 
                        }
                    }else{
                        self.oldMessage[messageDate] = messages[messageDate]
                        self.messageDetailTableView.reloadData()
                    }
                }
            }
        }
    }
    
    fileprivate func getOldMessages() {
        
        guard isDataCalculated else {
            return
        }
        
        isDataCalculated = false
        WebServices.getPatientOldMessage(parameters: self.saveMessagesDic,
                                         success: { [weak self] (_ messsages: [String: [PatientLatestMessages]], _ nextHit : Int) in
                                            
                                            guard let messageDetailVC = self else {
                                                return
                                            }
                                            messageDetailVC.nextHit = nextHit
                                            if messageDetailVC.oldMessage.isEmpty {
                                                messageDetailVC.sortedDateArray(messsages)
                                                messageDetailVC.oldMessage = messsages
                                                messageDetailVC.messageDetailTableView.reloadData()
                                            } else if !messsages.isEmpty {
                                                messageDetailVC.sortedDateArray(messsages)
                                                messageDetailVC.addTwoDictionary(message: messsages)
                                                messageDetailVC.messageDetailTableView.reloadData()
                                            }
                                            
                                            messageDetailVC.isDataCalculated = true
                                            messageDetailVC.timer.invalidate()
                                            messageDetailVC.timer = Timer.scheduledTimer(timeInterval: 3, target: messageDetailVC, selector: #selector(messageDetailVC.getLatestMessages), userInfo: nil, repeats: true)
            }, failure: { (error) in
            showToastMessage(error.localizedDescription)
        })
    }
    
    func sortedDateArray(_ messages: [String: [PatientLatestMessages]]){
        var sortedDate: [Date] = Array(messages.keys).map({(date) -> Date in
            if let interval = TimeInterval(date) {
                let dateValue = Date(timeIntervalSince1970: interval)
                return dateValue
            }else{
                return Date()
            }
        })//.sorted().reversed()
        
        if self.sortedDateArray.isEmpty {
            self.sortedDateArray = sortedDate.reversed() //sortedDate
        }else {
            let lastDateInterval = self.sortedDateArray.last?.timeIntervalSince1970//self.sortedDateArray.first?.timeIntervalSince1970
            let firstDate = sortedDate.first?.timeIntervalSince1970
            if lastDateInterval == firstDate {
                if !sortedDate.isEmpty {
                    sortedDate.remove(at: 0)
                    self.sortedDateArray += sortedDate
                }
            }else{
                self.sortedDateArray += sortedDate
            }
        }
    }
    
    func addTwoDictionary(message: [String: [PatientLatestMessages]]){
        if !message.isEmpty {
            let newKeys = Array(message.keys).sorted()
            let oldSortedDateArray = self.sortedDateArray.reversed()
            for newKeysvalue in newKeys {
                for sortedDate in oldSortedDateArray {
                    let oldDateKey = sortedDate.timeIntervalSince1970
                    if "\(oldDateKey)" == newKeysvalue {
                        var previousData = self.oldMessage["\(oldDateKey)"] ?? []
                        previousData.append(contentsOf: message[newKeysvalue]!)
                        self.oldMessage["\(oldDateKey)"] = previousData
                    }else{
                        if self.sortedDateArray.contains(Date.init(timeIntervalSince1970: Double(newKeysvalue)!)){
                            continue
                        }else{
                           self.oldMessage[newKeysvalue] = message[newKeysvalue]
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func sendPdf(){
        
        var param = [String: Any]()
        param["doc_id"] = self.saveMessagesDic["person_id"]
        
        WebServices.sendPdf(parameters: param, success: { (_ message: String) in
            showToastMessage(message)
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
}
