//
//  AppointmentListingVC.swift
//  Mutelcor
//
//  Created by  on 01/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
//import TTTAttributedLabel

enum NavigateToScreenBy {
    case noitificationVC
    case otherViewController
}

class AppointmentListingVC: BaseViewController {
    
    //    MARK:- Proporties
    //    =================
   fileprivate var typesOfAppointments = [K_UPCOMING_APPOINTMENT_TITLE.localized, K_APPOINTMENT_HISTORY_TITLE.localized]
   fileprivate var upcomingAppointment = [UpcomingAppointmentModel]()
   fileprivate var appointmentHistory = [UpcomingAppointmentModel]()
   fileprivate var cancelAppointmentDic = [String : Any]()
   fileprivate var appointmentButtonTapped = false
    var navigateToScreenBy  = NavigateToScreenBy.otherViewController
    fileprivate var isHitUpcomingAppointmentService: Bool = false
    fileprivate var isHitpreviousAppointmentService: Bool = false
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var appointmentListingCollectionView: UICollectionView!

    @IBOutlet weak var addAppointmentContainerView: UIView!
    @IBOutlet weak var addAppointmentBtn: UIButton!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftTopBarBtnType : SidemenuBtnAction = (navigateToScreenBy == .noitificationVC) ? .backBtn : .sideMenuBtn
        self.sideMenuBtnActn = leftTopBarBtnType
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .appointment
        self.setNavigationBar(screenTitle: K_APPOINTMENT_LISTING_SCREN_TITLE.localized)
    }
}

//MARK:- UICollectionViewDataSource Methods
//=========================================
extension AppointmentListingVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        let sections = (section == 0) ? self.upcomingAppointment.count : self.appointmentHistory.count
        return sections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        guard let upcomingAppointmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingAppointmentsCellID", for: indexPath) as? UpcomingAppointmentsCell else{
            fatalError("upcomingAppintmentsCell Not Found!")
        }
        
        switch indexPath.section {
            
        case 0:
            upcomingAppointmentCell.cancelBtn.isHidden = false
            upcomingAppointmentCell.populateData(self.upcomingAppointment,indexPath)
            
            upcomingAppointmentCell.rescheduleBtn.addTarget(self, action: #selector(rescheduleAppointmentBtnTapped(_:)), for: .touchUpInside)
            upcomingAppointmentCell.cancelBtn.addTarget(self, action: #selector(cancelAppointmentBtnTapped(_:)), for: .touchUpInside)
            
            return upcomingAppointmentCell
        case 1:
            upcomingAppointmentCell.populatDataForHistoryCell(self.appointmentHistory, indexPath)
            upcomingAppointmentCell.cancelBtn.isHidden = true
            return upcomingAppointmentCell
            
        default:
            fatalError("Cell Not Found!")
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return self.typesOfAppointments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let appointmentListSectionCell = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "appointmentListingHeaderCellID", for: indexPath) as? AppointmentListingHeaderCell else{
            fatalError("AppointmentListingSectionCell Not Found!")
        }
        appointmentListSectionCell.frame.size = CGSize(width: UIDevice.getScreenWidth, height: 51)
        appointmentListSectionCell.cellTitle.text = self.typesOfAppointments[indexPath.section]
        
        return appointmentListSectionCell
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//=================================================
extension AppointmentListingVC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch indexPath.section {
        case 0:
            if !self.upcomingAppointment.isEmpty {
                return CGSize(width: UIDevice.getScreenWidth - 15, height: 160)
            }else{
                return CGSize.zero
            }
        case 1:
            return CGSize(width: UIDevice.getScreenWidth - 15, height: 160)
        default:
            return CGSize.zero
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
        
        switch section{
        case 0:
            if !self.upcomingAppointment.isEmpty {
                return CGSize(width: collectionView.frame.width, height: 51)
            }else{
                return CGSize.zero
            }
            
        case 1:
            if !self.appointmentHistory.isEmpty {
                return CGSize(width: collectionView.frame.width, height: 51)
            }else{
                return CGSize.zero
            }
        default:
            return CGSize.zero
        }
    }
}

//MARK:- Methods
//===============
extension AppointmentListingVC {
    
    fileprivate func setupUI() {

        self.addAppointmentBtn.addTarget(self, action: #selector(self.addAppointmentBtnTapped), for: .touchUpInside)
        self.addAppointmentBtn.setImage(#imageLiteral(resourceName: "icMeasurementAdd"), for: .normal)
        self.addAppointmentBtn.tintColor = UIColor.appColor

        addAppointmentContainerView.backgroundColor = .clear
        self.addAppointmentContainerView.isHidden = true

        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.text = K_NO_APPOINTMENT_SCHEDULED.localized
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)

        /*
        self.noDataAvailiableLabel.delegate = self
        self.noDataAvailiableLabel.attributedText = NSAttributedString.init(string: K_NO_APPOINTMENT_SCHEDULED.localized, attributes: [NSAttributedStringKey.font: AppFonts.sansProRegular.withSize(15),
                                                                                                                                       NSAttributedStringKey.foregroundColor: UIColor.appColor])
        self.noDataAvailiableLabel.linkAttributes = [NSAttributedStringKey.font: AppFonts.sansProRegular.withSize(15),
                                                     NSAttributedStringKey.foregroundColor: UIColor.linkLabelColor,
                                                     NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
                                                     NSAttributedStringKey.underlineColor: UIColor.linkLabelColor]
        let range = NSRange(location: K_NO_APPOINTMENT_SCHEDULED.localized.count - "Book Now".count, length: "Book Now".count)
        self.noDataAvailiableLabel.addLink(to: URL(string: "www.google.com"), with: range)
        self.noDataAvailiableLabel.isHidden = true
        */
        
        self.view.backgroundColor = UIColor.headerColor
        self.appointmentListingCollectionView.backgroundColor = UIColor.headerColor
        
        //UICollectionViewDataSource And Delegate
        self.appointmentListingCollectionView.dataSource = self
        self.appointmentListingCollectionView.delegate = self
        
        //Register Nib
        self.registerNibs()
        
        self.hitUpcomingAppointmentService()
        self.hitAppointmentHistory()
    }
    
    fileprivate func registerNibs(){
        
        let appointmenmtListingSectionNib = UINib(nibName: "AppointmentListingHeaderCell", bundle: nil)
        let upcomingAppointmentNib = UINib(nibName: "UpcomingAppointmentsCell", bundle: nil)
        let noUpcomingAppointmentNib = UINib(nibName: "NoUpcomingAppointmentCell", bundle: nil)
        let appointmentHistoryNib = UINib(nibName: "AppointmentHistoryCell", bundle: nil)
                
        self.appointmentListingCollectionView.register(upcomingAppointmentNib, forCellWithReuseIdentifier: "upcomingAppointmentsCellID")
        self.appointmentListingCollectionView.register(appointmentHistoryNib, forCellWithReuseIdentifier: "appointmentHistoryCellID")
        self.appointmentListingCollectionView.register(noUpcomingAppointmentNib, forCellWithReuseIdentifier: "noUpcomingAppointmentCellID")
        self.appointmentListingCollectionView.register(appointmenmtListingSectionNib, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "appointmentListingHeaderCellID")
    }

    @objc private func addAppointmentBtnTapped(_ sender : UIButton) {
        let addAppointmentScene = AddAppointmentVC.instantiate(fromAppStoryboard: .AppointMent)
        addAppointmentScene.proceedToScreen = .addAppointment
        self.navigationController?.pushViewController(addAppointmentScene, animated: true)
    }

    //    reschedule Button Action
    @objc fileprivate func rescheduleAppointmentBtnTapped(_ sender : UIButton){
        
        let rescheduleAppointScene = AddAppointmentVC.instantiate(fromAppStoryboard: .AppointMent)
        rescheduleAppointScene.delegate = self
        rescheduleAppointScene.proceedToScreen = .reschedule
        rescheduleAppointScene.appointmentDetail = self.upcomingAppointment
        self.navigationController?.pushViewController(rescheduleAppointScene, animated: true)
    }
    
    //    Cancel ButtonAction
    @objc fileprivate func cancelAppointmentBtnTapped(_ sender : UIButton){
        let confirmationScene = ConfirmationVC.instantiate(fromAppStoryboard: .AppointMent)
        confirmationScene.cancelAppointmentDic = self.cancelAppointmentDic
        confirmationScene.openConfirmVCFor = .appointmentCancellation
        confirmationScene.confirmText = K_CANCEL_APPOINTMENT_TITLE.localized
        confirmationScene.delegate = self
        AppDelegate.shared.window?.addSubview(confirmationScene.view)
        self.addChildViewController(confirmationScene)
    }
}

/*
//MARk- TTTAttributedLabelDelegate Methods
//========================================
extension AppointmentListingVC: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let addAppointmentScene = AddAppointmentVC.instantiate(fromAppStoryboard: .AppointMent)
        addAppointmentScene.proceedToScreen = .addAppointment
        self.navigationController?.pushViewController(addAppointmentScene, animated: true)
    }
}
*/

//MARK:- Webservices Services
//===========================
extension AppointmentListingVC {
    
    //    upcoming Appointment Service
   fileprivate func hitUpcomingAppointmentService(){
        
        WebServices.upcomingAppointments(success: {[weak self] (_ upcomingAppointment : [UpcomingAppointmentModel]) in
            
            guard let appointmentListingVC = self else{
                return
            }
            appointmentListingVC.isHitUpcomingAppointmentService = true
            appointmentListingVC.upcomingAppointment = upcomingAppointment
            
            if !appointmentListingVC.upcomingAppointment.isEmpty{
                appointmentListingVC.cancelAppointmentDic["appointment_old_appointment_id"] = appointmentListingVC.upcomingAppointment[0].appointmentID
                appointmentListingVC.cancelAppointmentDic["appointment_old_slot_id"] = appointmentListingVC.upcomingAppointment[0].scheduleID
            }
            appointmentListingVC.isNoDataAvailiableTextDisplay()
            appointmentListingVC.appointmentListingCollectionView.reloadData()
        }) {(error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    //Appointment History
   fileprivate func hitAppointmentHistory(){
        
        WebServices.appointmentHistory(success: {[weak self] (_ appointmentHistory : [UpcomingAppointmentModel]) in
            
            guard let appointmentListingVC = self else{
                return
            }
            appointmentListingVC.isHitpreviousAppointmentService = true
            appointmentListingVC.appointmentHistory = appointmentHistory
            appointmentListingVC.isNoDataAvailiableTextDisplay()
            appointmentListingVC.appointmentListingCollectionView.reloadData()
            
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func isNoDataAvailiableTextDisplay(){
        
        let isServiceHit = (self.isHitUpcomingAppointmentService && self.isHitpreviousAppointmentService) ? true : false
        
        if isServiceHit {
            let isTableViewHidden = (self.upcomingAppointment.isEmpty && self.appointmentHistory.isEmpty) ? !isServiceHit : isServiceHit
            self.addAppointmentContainerView.isHidden = isTableViewHidden
        } else {
            let isTableViewHidden = (self.upcomingAppointment.isEmpty && self.appointmentHistory.isEmpty) ? isServiceHit : !isServiceHit
            self.addAppointmentContainerView.isHidden = isTableViewHidden
        }
    }
}

//MARK:- Appointment Cancellation Protocol
//========================================
extension AppointmentListingVC : AppointmentCancellationDelegate{
    
   func appointmentCancellation() {
            self.hitUpcomingAppointmentService()
            self.hitAppointmentHistory()
    }
}

extension AppointmentListingVC : AddAppointmentDelegate{
    func appointmentAddedSuccessfully(){
        self.hitUpcomingAppointmentService()
        self.hitAppointmentHistory()
    }
}
