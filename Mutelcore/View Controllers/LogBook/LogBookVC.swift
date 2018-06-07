//
//  LogBookVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 08/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class LogBookVC: BaseViewController {
    
//    MARK:- Proporties
//    =================
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var viewContainTextField: UIView!
    @IBOutlet weak var sepratorViewBelowTextField: UIView!
    @IBOutlet weak var dropDownTextField: UITextField!
    @IBOutlet weak var logBookTableView: UITableView!
    
    
//    MARK:-ViewController Life Cycle
//    ================================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.floatBtn.isHidden = false
        self.setupUI()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Log Book", 2, 3)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK:- UITableViewDataSource Methods
//=====================================
extension LogBookVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView === self.logBookTableView{
            
            return 2
        }else{
            
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if tableView === self.logBookTableView{
            
            return 1
        }else{
            
            return 12
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView === self.logBookTableView{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "logBookTableViewCellID", for: indexPath) as? LogBookTableViewCell else{
                
                fatalError("Log Book Cell not FOund!")
            }
            
            cell.logBookCellTableView.delegate = self
            cell.logBookCellTableView.dataSource = self
            
            return cell
        }else{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "logBookCellID", for: indexPath) as? LogBookCell else{
                
                fatalError("Log Book Cell not Found!")
            }
            
            cell.logsNameLabelOutlt.text = "HDL"
            cell.dateLabelOutlt.text = "7 Aug 2016 15:34"
            cell.logsAmmountOutlt.text = "500 mg/dl"
            
            return cell
        }
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension LogBookVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "logBookHeaderCellID") as? LogBookHeaderCell else{
            
            fatalError("Header Clell No Found!")
        }
        
        headerCell.contentView.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
        
        if tableView === self.logBookTableView {
            
            headerCell.headerLabel.textColor = UIColor.appColor
            headerCell.headerLabel.text = "2106(2)"
            
        }else{
            
            headerCell.headerLabel.textColor = UIColor.black
            headerCell.headerImage.image = #imageLiteral(resourceName: "icActivityplanGreendropdown")
            headerCell.stackViewLeadingConstratintOutlt.constant = 30
            headerCell.headerLabel.text = "June(2)"
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView === self.logBookTableView {
            
            return ((64 * 12) + 36.5)
            
        }else{
            
            return (64)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 36.5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
}

//MARK:- Methods
//==============
extension LogBookVC {
    
    fileprivate func setupUI(){
        
        self.dropDownTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
        self.dropDownTextField.rightViewMode = .always
        self.sepratorViewBelowTextField.backgroundColor = UIColor.sepratorColor
        
        self.logBookTableView.dataSource = self
        self.logBookTableView.delegate = self
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let logBookHeaderCellNib = UINib(nibName: "LogBookHeaderCell", bundle: nil)
        self.logBookTableView.register(logBookHeaderCellNib, forHeaderFooterViewReuseIdentifier: "logBookHeaderCellID")
        
        let logBookTableViewCellNib = UINib(nibName: "LogBookTableViewCell", bundle: nil)
        self.logBookTableView.register(logBookTableViewCellNib, forCellReuseIdentifier: "logBookTableViewCellID")
        
    }
}
