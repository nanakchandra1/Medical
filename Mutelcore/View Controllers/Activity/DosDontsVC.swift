//
//  DosDontsVCViewController.swift
//  Mutelcore
//
//  Created by Appinventiv on 16/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class DosDontsVC: UIViewController {

//    MARk:- Proporties
//    ==================
    enum ButtonTapped {
        
        case dos, donts, foodToAvoid, dailyAllowances, attachment
    }
    
    var buttonTapped  = ButtonTapped.dos
    
    var dosDontsValues = [JSON]()
    var foodToAvoidArray = [String]()
    var attachmentURl = [String]()
    var attachmentName = [String]()

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var viewContainTableView: UIView!
    @IBOutlet weak var ViewTitle: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var okBtnOutlt: UIButton!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    

    @IBOutlet weak var DosDontsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
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
    @IBAction func okBtnTapped(_ sender: UIButton) {
     
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        
    }
    
    fileprivate func setupUI(){
        
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        
        self.view.backgroundColor = UIColor.popUpBackgroundColor
        self.viewContainTableView.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: 0.0)
        
        self.okBtnOutlt.setTitle("OK", for: UIControlState.normal)
        self.okBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.6)
        self.okBtnOutlt.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.okBtnOutlt.backgroundColor = UIColor.appColor
        self.okBtnOutlt.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: 0.0)
        
        if self.buttonTapped == ButtonTapped.dos{
            
           self.ViewTitle.text = "DO'S"
            
        }else if self.buttonTapped == .donts {
            
           self.ViewTitle.text = "DONT'S"
        }else if self.buttonTapped == .foodToAvoid {
            
            self.ViewTitle.text = "FOOD'S TO AVOID"
        }else if self.buttonTapped == .dailyAllowances{
            
            self.ViewTitle.text = "DAILY ALLOWANCES"
        }else{
            
           self.ViewTitle.text = "ATTACHMENTS"
        }
        
        if self.dosDontsValues.isEmpty && self.foodToAvoidArray.isEmpty{
            
            self.noDataAvailiableLabel.isHidden = false
            self.noDataAvailiableLabel.text = "No Record Found!"
            
        }else{
           
            self.noDataAvailiableLabel.isHidden = true
            
        }

        self.view.backgroundColor = UIColor.popUpBackgroundColor
        self.ViewTitle.textColor = UIColor.appColor
        self.sepratorView.backgroundColor = UIColor.appColor
        self.ViewTitle.font = AppFonts.sansProBold.withSize(12)
    
        self.DosDontsTableView.dataSource = self
        self.DosDontsTableView.delegate = self
        
        self.registerNibs()
        
    }
    
    fileprivate func registerNibs(){
    
        let dosDontsNib = UINib(nibName: "DosDontsCell", bundle: nil)
        self.DosDontsTableView.register(dosDontsNib, forCellReuseIdentifier: "dosDontsCellID")
    
    }
}

//MARK:- UITableViewDelegate and UITableViewDataSource
//====================================================
extension DosDontsVC : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if self.buttonTapped == .foodToAvoid {
            
            return self.foodToAvoidArray.count
        }else if self.buttonTapped == .dailyAllowances{
            
            return self.foodToAvoidArray.count
        }else if self.buttonTapped == .attachment{
            
          return self.attachmentURl.count
        }else{
            
          return self.dosDontsValues.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dosDontsCellID", for: indexPath) as? DosDontsCell else{
            
            fatalError("Dos And Donts Cell Not Found!")
        }
        
        if self.buttonTapped == .foodToAvoid {
            
            cell.cellTitleLabel.text = self.foodToAvoidArray[indexPath.row]
        }else if self.buttonTapped == .dailyAllowances {
            
            cell.cellTitleLabel.text = self.foodToAvoidArray[indexPath.row]
        }else if self.buttonTapped == .attachment {
            
            cell.cellTitleLabel.text = self.attachmentName[indexPath.row]
        }else{
            
           cell.cellTitleLabel.text = self.dosDontsValues[indexPath.row].stringValue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return CGFloat(30)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.buttonTapped == .attachment{
            
            let webViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
            
            webViewScene.webViewUrl = self.attachmentURl[indexPath.row]
            webViewScene.screenName = self.attachmentName[indexPath.row]
            self.navigationController?.pushViewController(webViewScene, animated: true)
            
        }
    }
}
