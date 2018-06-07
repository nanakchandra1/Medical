//
//  SettingVC.swift
//  Mutelcor
//
//  Created by on 08/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class SettingVC: BaseViewController {
    
    //    MARK:- Proporties
    //    =================
    fileprivate let settingRows = [K_CHANGE_PASSWORD_TITLE.localized,K_CHANGE_PHONENUMBER_TITLE.localized,K_TERMS_AND_CONDITION_TITLE.localized,K_PRIVACY_POLICY.localized,K_LOGOUT.localized]//[K_CHANGE_PASSWORD_TITLE.localized,K_CHANGE_PHONENUMBER_TITLE.localized,K_TERMS_AND_CONDITION_TITLE.localized,K_PRIVACY_POLICY.localized,K_ABOUT_APP.localized,K_LOGOUT.localized]
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var settingTableView: UITableView!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_SETTINGS_SCREEN_TITLE.localized)
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension SettingVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingCellID") as? SettingCell else{
            fatalError("Setting Cell Not Found!")
        }
        
        cell.CellTitle.text = self.settingRows[indexPath.row]
        cell.cellImage.image = #imageLiteral(resourceName: "icNotificationRightarrow")
        cell.bottomView.backgroundColor = UIColor.sepratorColor
        
        if indexPath.row == self.settingRows.count - 1{
            cell.cellImage.isHidden = true
            cell.bottomView.isHidden = true
        }
        return cell
    }
}

//extension SettingVC : UITableViewDelegate Methods
//=================================================
extension SettingVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let nvc = self.navigationController else{
            return
        }
        switch indexPath.row {
        case 0:
            let changePassowrdScene = ChangePasswordVC.instantiate(fromAppStoryboard: .Settings)
            changePassowrdScene.proceedToScreenFor = .changePassword
            nvc.pushViewController(changePassowrdScene, animated: true)
        case 1:
            let changePassowrdScene = ChangePasswordVC.instantiate(fromAppStoryboard: .Settings)
            changePassowrdScene.proceedToScreenFor = .changeMobileNumber
            nvc.pushViewController(changePassowrdScene, animated: true)
        case 2:
            self.openWebView(url: WebServices.EndPoint.termsCondition.url, screenName: settingRows[indexPath.row])
        case 3:
            self.openWebView(url: WebServices.EndPoint.privacyPolicy.url, screenName: settingRows[indexPath.row])
        /*case 4:
            showToastMessage("No Data Found!")*/
        case self.settingRows.count - 1:
            self.openLogoutPopUpView()
        default:
            return
        }
    }
    
    fileprivate func openWebView(url: String, screenName: String){
        let webViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
        webViewScene.openWebViewVC = .termsAndCondition
        webViewScene.webViewUrl = url
        webViewScene.screenName = screenName
        self.navigationController?.pushViewController(webViewScene, animated: true)
    }
}

//MARK:- Methods
//===============
extension SettingVC {
    
    fileprivate func setupUI(){
        self.settingTableView.dataSource = self
        self.settingTableView.delegate = self
        
        let settingCellnib = UINib(nibName: "SettingCell", bundle: nil)
        self.settingTableView.register(settingCellnib, forCellReuseIdentifier: "settingCellID")
    }
    
    fileprivate func openLogoutPopUpView(){
        let confirmationScene = ConfirmationVC.instantiate(fromAppStoryboard: .AppointMent)
        confirmationScene.openConfirmVCFor = .logout
        confirmationScene.confirmText = K_CANCEL_APPOINTMENT_TITLE.localized
        AppDelegate.shared.window?.addSubview(confirmationScene.view)
        self.addChildViewController(confirmationScene)
    }
}
