//
//  PastActivityPlanTableViewCell.swift
//  Mutelcor
//
//  Created by on 15/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol OpenWebViewToViewAttachment: class {
    func openWebView(_ open : Bool, _ attachmentUrl : [String], _ attachmentName : [String])
}

class PastActivityPlanTableViewCell: UITableViewCell {
    
    enum CellCountOnCurrentActivity {
        case currentActivity
        case previousActivity
    }
    
//    MARK:- Proporties
//    ================
    var cellCountOnCurrentActivity = CellCountOnCurrentActivity.currentActivity
    var previousActivityPlanData = [PreviousActivityPlan]()
    var currentActivityPlanData = [PreviousActivityPlan]()
    weak var delegate : OpenWebViewToViewAttachment?
    var attachmentUrl = [String]()
    var attachmentName = [String]()
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var viewContainAllObjects: UIView!
    
    @IBOutlet weak var pastActivityPlanTableView: DietAutoResizingTableView!
    @IBOutlet weak var previousActivityCollectionView: UICollectionView!
    
    @IBOutlet weak var previousActivityDateLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var shareBtnOutlt: UIButton!
    
    @IBOutlet weak var viewContainBtn: UIView!
    @IBOutlet weak var sepratorViewBtwnButton: UIView!
    @IBOutlet weak var doBtnOutlt: UIButton!
    @IBOutlet weak var dontsBtnOutlt: UIButton!
    
    @IBOutlet weak var attchmentViewHeighConstant: NSLayoutConstraint!
    @IBOutlet weak var viewAttchmentView: UIView!
    @IBOutlet weak var viewAttachmentBtnOult: UIButton!
    @IBOutlet weak var viewAttachmentWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
        self.setBlankString()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

    }
}

//MARK:- Methods
//=============
extension PastActivityPlanTableViewCell {
    
    fileprivate func setupUI(){
        
        self.viewContainAllObjects.layer.cornerRadius = 2.2
        self.viewContainAllObjects.layer.masksToBounds = true
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.outerView.layer.cornerRadius = 2.2
        self.outerView.clipsToBounds = false
        self.outerView.layer.masksToBounds = false
        
        self.previousActivityCollectionView.backgroundColor = UIColor.activityVCBackgroundColor
        
        self.contentView.backgroundColor = UIColor.activityVCBackgroundColor
        
        self.shareBtnOutlt.setImage(#imageLiteral(resourceName: "icActivityplanShare"), for: UIControlState.normal)
        self.shareBtnOutlt.tintColor = UIColor.appColor
        self.shareBtnOutlt.roundCorner(radius: 2.5, borderColor: UIColor.appColor, borderWidth: 1.0)
        
        self.viewAttachmentBtnOult.setImage(#imageLiteral(resourceName: "icActivityplanGreenattachment"), for: .normal)
        self.viewAttachmentBtnOult.tintColor = UIColor.appColor
        self.viewAttachmentBtnOult.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        
        self.rightImageView.image = #imageLiteral(resourceName: "ic_activity_line")
        self.leftImageView.image =  #imageLiteral(resourceName: "ic_activity_line")
        
        self.previousActivityDateLabel.font = AppFonts.sansProBold.withSize(12.5)
        self.previousActivityDateLabel.textColor = #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        
        self.doBtnOutlt.setTitle(K_DOS_TITLE.localized, for: .normal)
        self.doBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.doBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        
        self.dontsBtnOutlt.setTitle(K_DONTS_TITLE.localized, for: .normal)
        self.dontsBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.dontsBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        
        self.sepratorViewBtwnButton.backgroundColor = UIColor.appColor
        
        let viewAttachmentNib = UINib(nibName: "ViewAttachmentCell", bundle: nil)
        self.pastActivityPlanTableView.register(viewAttachmentNib, forCellReuseIdentifier: "viewAttachmentCellID")
        
        self.previousActivityCollectionView.register(UINib(nibName: "ActivityPlanCollectionCell", bundle: nil), forCellWithReuseIdentifier: "activityPlanCollectionCellID")
    }
    
    fileprivate func setBlankString(){
        self.previousActivityDateLabel.text = ""
    }
    
//    MARK:- Populate PreviousActivity Plan Date
//    ===========================================
    func populateData(_ previousActivityData : [PreviousActivityPlan]){
        
        guard !previousActivityData.isEmpty else{
            return
        }
        
        let attchmentUrl = previousActivityData[0].attachments ?? ""
        let isAttachmentBtnHidden = (!attchmentUrl.isEmpty) ? false : true
        self.viewAttchmentView.isHidden = isAttachmentBtnHidden
        let height = (!isAttachmentBtnHidden) ? CGFloat(50) : CGFloat.leastNormalMagnitude
        self.attchmentViewHeighConstant.constant = height
        
        var startActivityDate = ""
        var endActivityDate = ""
        if let startDate = previousActivityData[0].planStartDate, !startDate.isEmpty {
            startActivityDate = startDate.changeDateFormat(.utcTime, .ddMMMYYYY)
            
        }
        
        if let endDat = previousActivityData[0].planEndDate, !endDat.isEmpty {
            endActivityDate = endDat.changeDateFormat(.utcTime, .ddMMMYYYY)
        }
        self.previousActivityDateLabel.text = "\(String(describing: startActivityDate)) - \(String(describing: endActivityDate))"
    }
}

//MARK:- UITableViewDataSource
//============================
//extension PastActivityPlanTableViewCell : UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//
//        if self.cellCountOnCurrentActivity == CellCountOnCurrentActivity.currentActivity{
//
//            return self.currentActivityPlanData.count
//        }else{
//
//            return self.previousActivityPlanData.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//
//        guard let viewAttachmentCell = tableView.dequeueReusableCell(withIdentifier: "viewAttachmentCellID") as? ViewAttachmentCell else{
//
//            fatalError("viewAttachmentCell not found!")
//        }
//
//        if self.cellCountOnCurrentActivity == CellCountOnCurrentActivity.currentActivity{
//
//            viewAttachmentCell.populateCurrentActivityData(self.currentActivityPlanData, indexPath)
//
//        }else{
//
//            viewAttachmentCell.populatePreviousActivityData(self.previousActivityPlanData, indexPath)
//
//        }
//
//        viewAttachmentCell.viewAttachmentBtn.addTarget(self, action: #selector(self.attachmentBtnTapped(_:)), for: UIControlEvents.touchUpInside)
//
//        return viewAttachmentCell
//
//    }
//}

//MARK:- UITableViewDelegate
//===========================
//extension PastActivityPlanTableViewCell : UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//
//        return CGFloat(50)
//    }
//}

//MARK:- Methods
//==============
extension PastActivityPlanTableViewCell {
    @objc fileprivate func attachmentBtnTapped(_ sender : UIButton){
        
        guard let index = sender.tableViewIndexPathIn(self.pastActivityPlanTableView) else {
            return
        }
        
        if self.cellCountOnCurrentActivity == CellCountOnCurrentActivity.currentActivity{
            if let attachUrl = self.currentActivityPlanData[index.row].attachments, !attachUrl.isEmpty {
                self.attachmentUrl = attachUrl.components(separatedBy: ",")
            }
            
            if let attachName = self.currentActivityPlanData[index.row].attachemntsName, !attachName.isEmpty {
             self.attachmentName = attachName.components(separatedBy: ",")
            }
        }else{
            
            if let attachUrl = self.previousActivityPlanData[index.row].attachments, !attachUrl.isEmpty {
                self.attachmentUrl = attachUrl.components(separatedBy: ",")
            }
            
            if let attachName = self.previousActivityPlanData[index.row].attachemntsName, !attachName.isEmpty {
                self.attachmentName = attachName.components(separatedBy: ",")
            }
        }
        self.delegate?.openWebView(true, self.attachmentUrl, self.attachmentName)
    }
}

class DietAutoResizingTableView: AutoResizingTableView {
    
}
