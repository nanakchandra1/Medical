//
//  MeasurementConfirmationVCViewController.swift
//  Mutelcore
//
//  Created by Appinventiv on 12/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

protocol MeasurementConfirmationVCFromSuperView {
    
    func removeFromSuperView(_ remove : Bool)
}

class MeasurementConfirmationVC: UIViewController {

    var delegate : MeasurementConfirmationVCFromSuperView!
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var confirmPopUpView: UIView!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var okBtnOult: UIButton!
    
//    MARK:- ViewController LifeCycle
//    ===============================
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        
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
    
    //    MARK:- IBAction
    //    ===============
    @IBAction func okBtnTapped(_ sender: UIButton) {
        
        
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
        self.delegate.removeFromSuperView(true)
    }
    
    fileprivate func setupUI(){
 
        let attributeString = "Your measurement report has been sent to "
        
        let docName = AppUserDefaults.value(forKey :.doctorName)
        
        let docAttributeString = "Dr. \(docName) ."
        
        let attributes = [NSFontAttributeName : AppFonts.sansProRegular.withSize(15)]
        let docAttributes = [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(15),
                             NSForegroundColorAttributeName : UIColor.appColor]
        
        let attributedString = NSMutableAttributedString(string: attributeString, attributes: attributes)
        let datAttributedString = NSAttributedString(string: docAttributeString, attributes: docAttributes)
        
        attributedString.append(datAttributedString)
        
        self.confirmationLabel.attributedText = attributedString
        
        self.confirmPopUpView.roundCorner(radius: 2.0, borderColor: UIColor.clear, borderWidth: 0.0)
        self.okBtnOult.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.okBtnOult.backgroundColor = UIColor.appColor
        self.okBtnOult.titleLabel?.font = AppFonts.sanProSemiBold.withSize(14)
        self.okBtnOult.setTitle("Ok", for: UIControlState.normal)
        self.okBtnOult.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
        
    }
}
