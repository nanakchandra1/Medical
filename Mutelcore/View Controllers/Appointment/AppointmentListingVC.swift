//
//  AppointmentListingVC.swift
//  Mutelcore
//
//  Created by Ashish on 01/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit



class AppointmentListingVC: BaseViewController {
    
    //    MARK:- Proporties
    //    =================
    var noOfsectionInTableView = ["UPCOMING APPOINTMENTS", "APPOINTMENT HISTORY"]
    var upcomingAppointment = [UpcomingAppointmentModel]()
    var appointmentHistory = [UpcomingAppointmentModel]()
    var cancelAppointmentDic = [String : Any]()
    var appointmentButtonTapped = false

    //    MARK:- IBOutlets
    //    ================
    
    @IBOutlet weak var appointmentListingCollectionView: UICollectionView!
    @IBOutlet weak var addAppointmentButton: UIButton!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.hitUpcomingService()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        self.setNavigationBar("Appointment", 2, 3)
       
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        
    }
}

//MARK:- UICollectionViewDataSource Methods
//=========================================
extension AppointmentListingVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        switch section{
            
        case 0 : if !self.upcomingAppointment.isEmpty {
            
            return self.upcomingAppointment.count
        }else{
            
            return 1
            }
            
        case 1: return self.appointmentHistory.count
            
        default: fatalError("Section Not Found!")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if indexPath.section == 0{
            
            if self.upcomingAppointment.isEmpty{
                
                guard let noUpcomingAppointmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "noUpcomingAppointmentCellID", for: indexPath) as? NoUpcomingAppointmentCell else{
                    
                    fatalError("noUpcomingAppointmentCell Not Found!")
                }
                
                noUpcomingAppointmentCell.noDataAvailiableLabel.text = "No Upcoming Appointments."
                
                return noUpcomingAppointmentCell
                
            }else{
                
                guard let upcomingAppointmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingAppointmentsCellID", for: indexPath) as? UpcomingAppointmentsCell else{
                    
                    fatalError("upcomingAppintmentsCell Not Found!")
                }
                
                upcomingAppointmentCell.cancelBtn.isHidden = false
                upcomingAppointmentCell.populateData(self.upcomingAppointment,indexPath)
                
                upcomingAppointmentCell.rescheduleBtn.addTarget(self, action: #selector(rescheduleAppointmentBtnTapped(_:)), for: .touchUpInside)
                
                upcomingAppointmentCell.cancelBtn.addTarget(self, action: #selector(cancelAppointmentBtnTapped(_:)), for: .touchUpInside)
                
                return upcomingAppointmentCell
            }
            
        }else{
            
            if self.appointmentHistory.isEmpty{
                
                guard let noUpcomingAppointmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "noUpcomingAppointmentCellID", for: indexPath) as? NoUpcomingAppointmentCell else{
                    
                    fatalError("noUpcomingAppointmentCell Not Found!")
                }
                
                noUpcomingAppointmentCell.noDataAvailiableLabel.text = "No Appointment History."
                
                return noUpcomingAppointmentCell
                
            }else{
                
                guard let appointmentHistoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingAppointmentsCellID", for: indexPath) as? UpcomingAppointmentsCell else{
                    
                    fatalError("upcomingAppintmentsCell Not Found!")
                }
                
                appointmentHistoryCell.populatDataForHistoryCell(self.appointmentHistory, indexPath)
                appointmentHistoryCell.cancelBtn.isHidden = true
                
                return appointmentHistoryCell
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return self.noOfsectionInTableView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let appointmentListSectionCell = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "appointmentListingSectionCellID", for: indexPath) as? AppointmentListingSectionCell else{
            
            fatalError("AppointmentListingSectionCell Not Found!")
        }
        
        appointmentListSectionCell.addBtnOutlet.addTarget(self, action: #selector(self.addAppointmentBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        appointmentListSectionCell.cellTitle.text = self.noOfsectionInTableView[indexPath.section]
        appointmentListSectionCell.addBtnOutlet.setImage(#imageLiteral(resourceName: "icMeasurementAdd"), for: UIControlState.normal)
        appointmentListSectionCell.addBtnOutlet.setTitleColor(UIColor.appColor, for: UIControlState.normal)
        
        if indexPath.section == 0 {
            
            appointmentListSectionCell.addBtnOutlet.isHidden = false
            
        }else{
            
            appointmentListSectionCell.addBtnOutlet.isHidden = true
        }
        
        return appointmentListSectionCell
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//=================================================
extension AppointmentListingVC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if self.upcomingAppointment.isEmpty, self.appointmentHistory.isEmpty{
            
           return CGSize(width: 0, height: 0)
            
        }else{
            
            if indexPath.section == 0{
                
                if self.upcomingAppointment.isEmpty {
                    
                    return CGSize(width: UIDevice.getScreenWidth - 15, height: 80)
                }else{
                    
                    return CGSize(width: UIDevice.getScreenWidth - 15, height: 140)
                }
            }else{
                
                return CGSize(width: UIDevice.getScreenWidth - 15, height: 140)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0, left: 7.5, bottom: 0, right: 7.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{

        if self.upcomingAppointment.isEmpty, self.appointmentHistory.isEmpty{
            
            return CGSize(width: 0, height: 0)
        }else{
            
           return CGSize(width: UIDevice.getScreenWidth, height: 51)
        }
    }
}

//MARK:- Methods
//===============
extension AppointmentListingVC {
    
    fileprivate func setupUI() {
        
        self.addAppointmentButton.isHidden = true
        self.noDataAvailiableLabel.isHidden = true
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.font = AppFonts.sansProBold.withSize(16)
        self.noDataAvailiableLabel.text = "No Appointment Scheduled. Tap icon to Book Appointment"
        self.addAppointmentButton.setImage(#imageLiteral(resourceName: "icMeasurementAdd"), for: UIControlState.normal)
        
        
        self.addAppointmentButton.addTarget(self, action: #selector(self.addAppointmentBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        
        //Register Nib
        self.registerNibs()
        
        //UICollectionViewDataSource And Delegate
        self.appointmentListingCollectionView.dataSource = self
        self.appointmentListingCollectionView.delegate = self
        
    }
    
    fileprivate func registerNibs(){
       
        let appointmenmtsectionNib = UINib(nibName: "AppointmentListingSectionCell", bundle: nil)
        let upcomingAppointmentNib = UINib(nibName: "UpcomingAppointmentsCell", bundle: nil)
        let noUpcomingAppointmentNib = UINib(nibName: "NoUpcomingAppointmentCell", bundle: nil)
        let appointmentHistory = UINib(nibName: "AppointmentHistoryCell", bundle: nil)
        
        
        self.appointmentListingCollectionView.register(upcomingAppointmentNib, forCellWithReuseIdentifier: "upcomingAppointmentsCellID")
        self.appointmentListingCollectionView.register(appointmentHistory, forCellWithReuseIdentifier: "appointmentHistoryCellID")
        self.appointmentListingCollectionView.register(noUpcomingAppointmentNib, forCellWithReuseIdentifier: "noUpcomingAppointmentCellID")
        self.appointmentListingCollectionView.register(appointmenmtsectionNib, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "appointmentListingSectionCellID")
    }
    
    @objc fileprivate func addAppointmentBtnTapped(_ sender : UIButton){
        
        let addAppointmentScene = AddAppointmentVC.instantiate(fromAppStoryboard: .AppointMent)
        addAppointmentScene.proceedToScreen = .addAppointment
        self.navigationController?.pushViewController(addAppointmentScene, animated: true)
    }
    
    //    reschedule Button Action
    @objc fileprivate func rescheduleAppointmentBtnTapped(_ sender : UIButton){
        
        let rescheduleAppointScene = AddAppointmentVC.instantiate(fromAppStoryboard: .AppointMent)
        
        rescheduleAppointScene.proceedToScreen = .reschedule
        rescheduleAppointScene.appointmentDetail = self.upcomingAppointment
        
        if let scheduleID = self.upcomingAppointment[0].scheduleID{
            
            rescheduleAppointScene.addAppointmentDic["appointment_old_slot_id"] = scheduleID
            rescheduleAppointScene.addAppointmentDic["schedule_id"] = scheduleID
        }
        if let appointmentID = self.upcomingAppointment[0].appointmentID{
            
         rescheduleAppointScene.addAppointmentDic["appointment_old_appointment_id"] = appointmentID
        }
        if let appointmentType = self.upcomingAppointment[0].appointmentType{
            
            rescheduleAppointScene.addAppointmentDic["appointment_type"] = appointmentType
        }
        if let severity = self.upcomingAppointment[0].appointmentSeverity{
            
           rescheduleAppointScene.addAppointmentDic["severity"] = severity
        }
        if let date = self.upcomingAppointment[0].appointmentDate{
            
            rescheduleAppointScene.timeSlotDic["check_date"] = date.stringFormDate(DateFormat.yyyyMMdd.rawValue)
            rescheduleAppointScene.addAppointmentDic["appointmentDate"] = date.stringFormDate(DateFormat.dMMMyyyy.rawValue)
            rescheduleAppointScene.selectedDay = date.getDayOfWeek()!
            rescheduleAppointScene.selectedDate = date
            
        }
        
        rescheduleAppointScene.addAppointmentDic["specification"] = self.upcomingAppointment[0].specification
        rescheduleAppointScene.addAppointmentDic["details"] = self.upcomingAppointment[0].appointmentSpecify
        rescheduleAppointScene.addAppointmentDic["symptomes"] = self.upcomingAppointment[0].appointmentSymptoms
        
        var startTime = ""
        var endTime = ""
        
        if let startTim = self.upcomingAppointment[0].appointmentStartTime?.timeFromStringInHours(DateFormat.HHmm.rawValue){
            
            startTime = startTim
        }
        if let endTim = self.upcomingAppointment[0].appointmentEndTime?.timeFromStringInHours(DateFormat.HHmm.rawValue){
            
            endTime = endTim
        }
        rescheduleAppointScene.selectedTimeSlot = "\(startTime) - \(endTime)"
        rescheduleAppointScene.selectedTime = "\(startTime) - \(endTime)"

         self.navigationController?.pushViewController(rescheduleAppointScene, animated: true)
        
    }
    
    //    Cancel ButtonAction
    @objc fileprivate func cancelAppointmentBtnTapped(_ sender : UIButton){
        
        let confirmationScene = ConfirmationVC.instantiate(fromAppStoryboard: .AppointMent)
        
        confirmationScene.cancelAppointmentDic = self.cancelAppointmentDic
        confirmationScene.openConfirmVCFor = .appointmentCancellation
        confirmationScene.confirmText = "Are you sure you want to cancel the Appointment?"
        confirmationScene.delegate = self
        
        sharedAppDelegate.window?.addSubview(confirmationScene.view)
        self.addChildViewController(confirmationScene)
        
        confirmationScene.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
        
        UIView.animate(withDuration: 0.3) {
            
            confirmationScene.view.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
            
        }
        
        for childVC in self.childViewControllers{
            
            if childVC === confirmationScene {
                
            }else{
             
                childVC.view.removeFromSuperview()
                childVC.removeFromParentViewController()
                
            }
        }
    }
}

//MARK:- Hit Services
//====================
extension AppointmentListingVC {
    
    //    upcoming Service
     func hitUpcomingService(){
        
        WebServices.upcomingAppointments(success: { (_ upcomingAppointment : [UpcomingAppointmentModel]) in
            
            self.upcomingAppointment = upcomingAppointment
            
            printlnDebug("Upcoming Appointment : \(upcomingAppointment)")
            
            if !self.upcomingAppointment.isEmpty{
               
                self.cancelAppointmentDic["appointment_old_appointment_id"] = self.upcomingAppointment[0].appointmentID
                self.cancelAppointmentDic["appointment_old_slot_id"] = self.upcomingAppointment[0].scheduleID

            }
            
            self.hitAppointmentHistory()

            self.appointmentListingCollectionView.reloadData()
            
                        
        }) { (error) in
        
            showToastMessage(error.localizedDescription)
       

            self.hitAppointmentHistory()
            
        }
    }
    
    //Appointment History
     func hitAppointmentHistory(){
        
        WebServices.appointmentHistory(success: { (_ appointmentHistory : [UpcomingAppointmentModel]) in
            
            printlnDebug("Appointment History : \(appointmentHistory)")
            
            self.appointmentHistory = appointmentHistory
            
            if self.upcomingAppointment.isEmpty , self.appointmentHistory.isEmpty {
                
                self.addAppointmentButton.isHidden = false
                self.noDataAvailiableLabel.isHidden = false

            }else{
                
                self.addAppointmentButton.isHidden = true
                self.noDataAvailiableLabel.isHidden = true
            }
            
            self.appointmentListingCollectionView.reloadData()
            
        }) { (error) in

            showToastMessage(error.localizedDescription)

        }
    }
}

//MARK:- Appointment Cancellation Protocol
//========================================
extension AppointmentListingVC : AppointmentCancellationDelegate{
    
    internal func apointmentCancellation(_ isAppointmentCancelled: Bool) {
       
        if isAppointmentCancelled == true{
            
            self.hitUpcomingService()
            self.hitAppointmentHistory()
        }
    }
}
