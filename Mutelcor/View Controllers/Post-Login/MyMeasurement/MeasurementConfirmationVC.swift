//
//  MeasurementConfirmationVCViewController.swift
//  Mutelcor
//
//  Created by on 12/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol MeasurementConfirmationVCFromSuperView: class {
    func removeFromSuperView()
}

protocol RefreshDelegate: class {
    func refreshScreen()
}

class MeasurementConfirmationVC: UIViewController {
    
    weak var delegate : MeasurementConfirmationVCFromSuperView?
    weak var refreshScreenDelegate : RefreshDelegate?
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var confirmPopUpView: UIView!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var okBtnOult: UIButton!
    
    //    MARK:- ViewController LifeCycle
    //    ===============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.animatePopUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let nvc = self.navigationController else{
            return
        }
        nvc.setToolbarHidden(true, animated: false)
    }
    
    //    MARK:- IBAction
    //    ===============
    @IBAction func okBtnTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.confirmPopUpView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }, completion: { (true) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
        
        self.delegate?.removeFromSuperView()
        self.refreshScreenDelegate?.refreshScreen()
    }
    
    fileprivate func setupUI(){
        
        let attributeString = "Your measurement report has been sent to "
        
        let docName = AppUserDefaults.value(forKey :.doctorName).stringValue
        let docAttributeString = "\(docName) ."
        
        let attributes = [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(15)]
        let docAttributes = [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(15),
                             NSAttributedStringKey.foregroundColor : UIColor.appColor]
        let attributedString = NSMutableAttributedString(string: attributeString, attributes: attributes)
        let datAttributedString = NSAttributedString(string: docAttributeString, attributes: docAttributes)
        
        attributedString.append(datAttributedString)
        self.confirmationLabel.attributedText = attributedString
        self.confirmPopUpView.roundCorner(radius: 2.0, borderColor: UIColor.clear, borderWidth: 0.0)
        self.okBtnOult.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.okBtnOult.backgroundColor = UIColor.appColor
        self.okBtnOult.titleLabel?.font = AppFonts.sanProSemiBold.withSize(14)
        self.okBtnOult.setTitle(K_OK_TITLE.localized, for: UIControlState.normal)
        self.okBtnOult.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
    }
    
    fileprivate func animatePopUpView(){
        
        self.confirmPopUpView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.confirmPopUpView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
