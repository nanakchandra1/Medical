//
//  NutritionTargetConsumedCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 22/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NutritionTargetConsumedCell: UITableViewCell {
    
    //    MARk:- Proporties
    //    =================
    var nutrientsValues = [String]()
    var dayWiseNutritionData : [DayWiseNutrition] = []
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var nutrientsLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var consumedLabel: UILabel!
    @IBOutlet weak var nutrientsTableView: UITableView!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var viewContainObjects: UIView!
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var previousDateBtn: UIButton!
    @IBOutlet weak var nextDateBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calenderBelowSepratorView: UIView!
    @IBOutlet weak var calenderBtn: UIButton!
    
    
    
    
    //    MARK:- TableView LifeCycle
    //    ==========================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension NutritionTargetConsumedCell {
    
    fileprivate func setupUI(){
        
        self.previousDateBtn.setImage(#imageLiteral(resourceName: "icActivityplanLeftarrow"), for: UIControlState.normal)
        self.nextDateBtn.setImage(#imageLiteral(resourceName: "icActivityplanRightarrow"), for: UIControlState.normal)
        self.calenderBtn.setImage(#imageLiteral(resourceName: "icAppointmentCalendar"), for: UIControlState.normal)
        
        self.calenderBelowSepratorView.backgroundColor = UIColor.sepratorColor
        
        self.dateLabel.font = AppFonts.sansProBold.withSize(12.5)
        self.dateLabel.textColor = #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        
        self.sepratorView.backgroundColor = UIColor.appColor
        self.nutrientsLabel.text = "Nutrients"
        self.targetLabel.text = "Target"
        self.consumedLabel.text = "Consumed"
        
        for label in [self.nutrientsLabel, self.targetLabel, self.consumedLabel]{
            
            label?.textColor = UIColor.appColor
            label?.font = AppFonts.sanProSemiBold.withSize(14)
        }
        
        self.contentView.backgroundColor = UIColor.sepratorColor
        self.viewContainObjects.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.outerView.layer.cornerRadius = 2.2
        self.outerView.layer.masksToBounds = false
        self.nutrientsTableView.dataSource = self
        self.nutrientsTableView.delegate = self
        
        self.registersNib()
    }
    
    fileprivate func registersNib(){
        
        let NutrientsCellNib = UINib(nibName: "NutrientsCell", bundle: nil)
        self.nutrientsTableView.register(NutrientsCellNib, forCellReuseIdentifier: "nutrientsCellID")
        
    }
//    MARK:- Populate data
    func populateData(_ selectedDate : Date){
        
        let selectDate = selectedDate.stringFormDate(DateFormat.dMMMyyyy.rawValue)
        let currentDate = Date().stringFormDate(DateFormat.dMMMyyyy.rawValue)
        
        printlnDebug("\(selectedDate)")
        
        if selectDate == currentDate {
            
            self.dateLabel.text = "Today, \(String(describing: selectDate!))"
            
            self.nextDateBtn.isHidden = true
            
        }else {
            
            self.dateLabel.text = "\(String(describing: selectDate!))"
            self.nextDateBtn.isHidden = false
            
        }
    }
}

//MARK:- UITableViewDataSource, UITableViewDelegate
//=================================================
extension NutritionTargetConsumedCell : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        return self.nutrientsValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let nutrientsCell = tableView.dequeueReusableCell(withIdentifier: "nutrientsCellID", for: indexPath) as? NutrientsCell else{
            
            fatalError("Cell Not Found!")
        }
        
        nutrientsCell.nutrientsNameLabel.text = self.nutrientsValues[indexPath.row]
        
        if !self.dayWiseNutritionData.isEmpty{
            
            nutrientsCell.populateData(self.dayWiseNutritionData, indexPath)
        }
        return nutrientsCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 40
    }
}
