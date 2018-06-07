//
//  ForgotPasswordVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 07/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseViewController {
    
    //    MARK:- Properties
    //    =================
    var forgotPasswordDic = [String : Any]()
    
    //    MARK:- Outlets
    //    ==============
    @IBOutlet weak var forgotPasswordDetailsTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var screenTitleView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var mutelCoreNameLabel: UILabel!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupSubViews
        self.setupUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.sideMenuBtnActn = .BackBtn
        self.navigationControllerOn = .login
        self.floatBtn.isHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar(K_FORGOTPASSWORD_SCREEN_TITLE.localized, 0, 0)
        self.submitButton.gradient(withX: 0, withY: 0, cornerRadius: true)
        self.screenTitleView.gradient(withX: 0, withY: 0, cornerRadius: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Private Functions
extension ForgotPasswordVC {
    
    fileprivate func setupUi(){
    
        
        self.submitButton.layer.cornerRadius = 2.2
        self.submitButton.shadow(2.2, CGSize(width: 0.7, height: 1.5), UIColor.navigationBarShadowColor)

        //nib registery for forgotPasswordDetailsTableView
        let detailsCellNib = UINib(nibName: "DetailsCell", bundle: nil)
        forgotPasswordDetailsTableView.register(detailsCellNib, forCellReuseIdentifier: "DetailsCellID")
        
        //setting up delegate and datasource
        self.forgotPasswordDetailsTableView.delegate = self
        self.forgotPasswordDetailsTableView.dataSource = self
        
        //adding target to buttons
        self.submitButton.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        self.submitButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.screenTitleLabel.font = AppFonts.sansProRegular.withSize(14)
        self.screenTitleLabel.text = K_FORGOTPASSWORD_SCREEN_LABEL.localized
        
        self.floatBtn.isHidden = true
        
        self.mutelCoreNameLabel.text = K_APP_LABEL_ATBOTTOM.localized
        self.mutelCoreNameLabel.textColor = UIColor.grayLabelColor
        self.mutelCoreNameLabel.font = AppFonts.sansProRegular.withSize(14)
  
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension ForgotPasswordVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let detailsCell = tableView.dequeueReusableCell(withIdentifier: "DetailsCellID", for: indexPath) as? DetailsCell else{ fatalError("Cell Not Found")
        }
        
        detailsCell.cellTitle.text = K_EMAIL_OR_MOBILE_NUMBER.localized
        detailsCell.detailsTextField.keyboardType = .emailAddress
        detailsCell.detailsTextField.returnKeyType = .done
        detailsCell.showPasswordButton.isHidden = true
        detailsCell.detailsTextField.delegate = self
        detailsCell.detailsTextField.isSecureTextEntry = false
        
        return detailsCell
    }
}

//MARK:- TextField Delegates
//==========================

extension ForgotPasswordVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let cell = textField.getTableViewCell as? DetailsCell else {
            
            return true
        }
        
        delay(0.1) {
            
            self.forgotPasswordDic[email_Id] = cell.detailsTextField.text ?? ""
            
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        guard let index = textField.tableViewIndexPathIn(self.forgotPasswordDetailsTableView) else{
            
            return true
        }
        
        guard let cell = self.forgotPasswordDetailsTableView.cellForRow(at: index) as? DetailsCell else{
            
            return true
        }
        
        if cell.detailsTextField.isFirstResponder {
            
            cell.detailsTextField.resignFirstResponder()
        }
        
        return true
    }
}

//MARK:- IBActions
//=================
extension ForgotPasswordVC{
    
    //submitTapped
    func submitTapped(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        guard let emailAndMobile = forgotPasswordDic[email_Id] as? String else{
            
            showToastMessage(AppMessages.emptyEmailAndMobileNumber.rawValue)
            
            return
        }
        guard !emailAndMobile.isEmpty else{
            
            showToastMessage(AppMessages.emptyEmailAndMobileNumber.rawValue)
            
            return
        }
        guard emailAndMobile.checkValidity(with: .Email) || emailAndMobile.checkValidity(with: .MobileNumber) else{
            
            showToastMessage(AppMessages.validEmailOrMobile.rawValue)

            return
        }
        
        if emailAndMobile.checkValidity(with: .Email){
            
            forgotPasswordDic[type] = loginType.email.rawValue
            forgotPasswordDic[email_Id] = emailAndMobile
            forgotPasswordDic[mobile_number] = ""
            
        }else{
            
            forgotPasswordDic[type] = loginType.mobileNumber.rawValue
            forgotPasswordDic[mobile_number] = emailAndMobile
            forgotPasswordDic[email_Id] = ""
            
        }
        
        printlnDebug("params : \(self.forgotPasswordDic)")
        WebServices.forgotPassword(parameters: forgotPasswordDic, success: {(_ str : String) in
         
            showToastMessage(str)
            
            let confirmationScene = PatientIDPopUpVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
            confirmationScene.forgotPasswordDic = self.forgotPasswordDic
            confirmationScene.proceedToScreen = .forgotPasswordVC
            
            sharedAppDelegate.window?.addSubview(confirmationScene.view)
            self.addChildViewController(confirmationScene)
            
            confirmationScene.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
            
            UIView.animate(withDuration: 0.3) {
                
                confirmationScene.view.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
                
            }
            
        }) { (error) in

            showToastMessage(error.localizedDescription)
 
        }
    }
}
