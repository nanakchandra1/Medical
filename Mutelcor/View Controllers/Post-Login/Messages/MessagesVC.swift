//
//  MessagesVC.swift
//  Mutelcor
//
//  Created by  on 14/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class MessagesVC: BaseViewControllerWithBackButton {
    
    //    MARK:- Properties
    //    ==================
    var proceedToScreenThrough = ProceedToScreenBy.sideMenu
    fileprivate var patientMessages = [PatientMessageModel]()
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let sideMenuBtnActn = (self.proceedToScreenThrough == .navigationBar) ? SidemenuBtnAction.backBtn : SidemenuBtnAction.sideMenuBtn
        self.sideMenuBtnActn = sideMenuBtnActn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        let panGestureEnable = self.sideMenuBtnActn == .sideMenuBtn ? true : false
        AppDelegate.shared.slideMenu.leftPanGesture?.isEnabled = panGestureEnable
        self.setNavigationBar(screenTitle: K_MESSAGE_TITLE.localized)
        
        self.getPatientMessage()
    }
}
//MARK:- UITableViewDataSource Methods
//==================================
extension MessagesVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patientMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let messageCell = tableView.dequeueReusableCell(withIdentifier: "messagesCellID", for: indexPath) as? MessagesCell else{
            fatalError("Cell Not Found!")
        }
        
        messageCell.populateMessageData(self.patientMessages, indexPath)
        return messageCell
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension MessagesVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let nvc = self.navigationController else{
            return
        }
        
        let messageDetailScene = MessageDetailVC.instantiate(fromAppStoryboard: .Message)
        messageDetailScene.saveMessagesDic["person_id"] = self.patientMessages[indexPath.row].personID
        messageDetailScene.patientMessagesData.append(self.patientMessages[indexPath.row])
        nvc.pushViewController(messageDetailScene, animated: true)
    }
}

//MARK:- Methods
//=============
extension MessagesVC {
    
    fileprivate func setupUI(){
        
        self.floatBtn.isHidden = false
        self.noDataAvailiableLabel.isHidden = true
        self.noDataAvailiableLabel.text = "No Records Found!"
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)

        self.messageTableView.dataSource = self
        self.messageTableView.delegate = self
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let messageNib = UINib(nibName: "MessagesCell", bundle: nil)
        self.messageTableView.register(messageNib, forCellReuseIdentifier: "messagesCellID")
    }
}

//MARK:- WebServices
//==================
extension MessagesVC {
    
    fileprivate func getPatientMessage(){
        
        WebServices.getPatientMessage(success: {[weak self] (_ patientMessage : [PatientMessageModel]) in
            
            guard let messageVC = self else{
                return
            }
            messageVC.patientMessages = patientMessage
            
            if !messageVC.patientMessages.isEmpty{
                messageVC.noDataAvailiableLabel.isHidden = true
            }else{
                messageVC.noDataAvailiableLabel.isHidden = false
            }
            messageVC.messageTableView.reloadSections(IndexSet.init(integer: 0), with: .fade)
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
}
