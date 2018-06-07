//
//  PersonalInformationVC+CalculatedWeight.swift
//  Mutelcor
//
//  Created by  on 17/01/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation

enum PatientHeightInCm: Int {
    
    case oneThirtySeven = 137
    case oneForty = 140
    case oneFortyTwo = 142
    case oneFortyFive = 145
    case oneFortySeven = 147
    case oneFifty = 150
    case oneFiftyTwo = 152
    case oneFiftyFive = 155
    case oneFiftySeven = 157
    case oneSixty = 160
    case oneSixtyThree = 163
    case oneSixtyFive = 165
    case oneSixtyEight = 168
    case oneSeventy = 170
    case oneSeventyThree = 173
    case oneSeventyFive = 175
    case oneSeventyEight = 178
    case oneEighty = 180
    case oneEightyThree = 183
    case oneEightyFive = 185
    case oneEightyEight = 188
    case oneNintyOne = 191
    case oneNintyThree = 193
    case oneNintyFive = 195
    case oneNintyEight = 198
    case twoHundredOne = 201
    case twoHundredThree = 203
    case twoHundredFive = 205
    case twoHundredEight = 208
    case twoHundredTen = 210
    case twoHundredThirteen = 213
}

enum MenWeight: Int {
   
    case oneThirtySeven_ThirtyTwo = 32
    case oneFourty_ThirtyFour = 34
    case oneFortyTwo_ThirtSeven = 37
    case oneFortyFive_Fourty = 40
    case oneFortySeven_FourtyThree = 43
    case oneFifty_FourtyFive = 45
    case oneFiftyTwo_FouryEight = 48
    case oneFiftyFive_FiftyOne = 51
    case oneFiftySeven_FiftyThree = 53
    case oneSixty_FiftySix = 56
    case oneSixtyThree_FiftyNine = 59
    case oneSixtyFive_SixtyTwo = 62
    case oneSixtyEight_SixtyFour = 64
    case oneSeventy_SixtySeven = 67
    case oneSeventyThree_Seventy = 70
    case oneSeventyFive_SeventyThree = 73
    case oneSeventyEight_SevntyFive = 75
    case oneEighty_SevntyEight = 78
    case oneEightyThree_EightyOne = 81
    case oneEightyFive_EightyThree = 83
    case oneEightyEight_EightySix = 86
    case oneNintyOne_EightyNine = 89
    case oneNintyThree_NintyTwo = 92
    case oneNintyFive_nintyFour = 94
    case oneNintyEight_NintySeven = 97
    case twoHundredOne_OneHundred = 100
    case twoHundredThree_OneHundredTwo = 102
    case twoHundredFive_OneHundredFive = 105
    case twoHundredEight_OneHundredEight = 108
    case twoHundredTen_OneHundredOne = 111
    case twoHundredThirteen_OneHundredThirteen = 113
}

enum WomenWeight: Int {
    
    case oneThirtySeven_ThirtyTwo = 32
    case oneFourty_ThirtyFour = 34
    case oneFortyTwo_ThirtySix = 36
    case oneFortyFive_ThirtyNine = 39
    case oneFortySeven_FourtyOne = 41
    case oneFifty_FourtyThree = 43
    case oneFiftyTwo_FourtyFive = 45
    case oneFiftyFive_FourtyEight = 48
    case oneFiftySeven_Fifty = 50
    case oneSixty_FiftyTwo = 52
    case oneSixtyThree_FiftyFour = 54
    case oneSixtyFive_FiftySeven = 57
    case oneSixtyEight_Fiftynine = 59
    case oneSeventy_SixtyOne = 61
    case oneSeventyThree_SixtyThree = 63
    case oneSeventyFive_SixtySix = 66
    case oneSeventyEight_SixtyEight = 68
    case oneEighty_Seventy = 70
    case oneEightyThree_SeventyTwo = 72
    case oneEightyFive_SeventyFive = 75
    case oneEightyEight_SeventySeven = 77
    case oneNintyOne_SeventyNine = 79
    case oneNintyThree_EightyTwo = 82
    case oneNintyFive_EightyFour = 84
    case oneNintyEight_EightySix = 86
    case twoHundredOne_EightyEight = 88
    case twoHundredThree_NintyOne = 91
    case twoHundredFive_NintyThree = 93
    case twoHundredEight_NintyFive = 95
    case twoHundredTen_NintyEight = 98
    case twoHundredThirteen_OneHundred = 100
}

extension PersonalInformationVC {
    //To Calculate the ideal and excess weight
    func getCalculatedIdealWeight(isServiceHit: Bool){
        
        let genderType = self.userInfo?.patientGender ?? 0
        var gender: Gender = .male
        var idealWeight: Int = 0
        let heightValue: Int?
        
        self.feetunitState = self.userInfo?.medicalInfo.first?.patientHeightType == 1 ? .ft : .cm
        if self.feetunitState == .ft {
            let feet = self.userInfo?.medicalInfo[0].patientHeight1 ?? 0
            let inch = self.userInfo?.medicalInfo[0].patientHeight2 ?? 0
            heightValue = Int((Double(feet) * 30.48) + (Double(inch) * 2.54))
        }else{
            heightValue = self.userInfo?.medicalInfo[0].patientHeight1 ?? 0
        }
        
        guard let height = heightValue, height != 0 else{
            return
        }
        
        switch genderType {
        case Gender.male.rawValue:
            gender = .male
        case Gender.female.rawValue:
            gender = .female
        default:
            gender = .others
        }
        
        switch height {
        case (PatientHeightInCm.oneThirtySeven.rawValue..<PatientHeightInCm.oneForty.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneThirtySeven_ThirtyTwo.rawValue : MenWeight.oneThirtySeven_ThirtyTwo.rawValue
        
        case (PatientHeightInCm.oneForty.rawValue..<PatientHeightInCm.oneFortyTwo.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneFourty_ThirtyFour.rawValue : MenWeight.oneFourty_ThirtyFour.rawValue
            
        case (PatientHeightInCm.oneFortyTwo.rawValue..<PatientHeightInCm.oneFortyFive.rawValue) :
            idealWeight =  gender == .female ? WomenWeight.oneFortyTwo_ThirtySix.rawValue : MenWeight.oneFortyTwo_ThirtSeven.rawValue
            
        case (PatientHeightInCm.oneFortyFive.rawValue..<PatientHeightInCm.oneFortySeven.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneFortyFive_ThirtyNine.rawValue : MenWeight.oneFortyFive_Fourty.rawValue
            
        case (PatientHeightInCm.oneFortySeven.rawValue..<PatientHeightInCm.oneFifty.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneFortySeven_FourtyOne.rawValue : MenWeight.oneFortySeven_FourtyThree.rawValue
            
        case (PatientHeightInCm.oneFifty.rawValue..<PatientHeightInCm.oneFiftyTwo.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneFifty_FourtyThree.rawValue : MenWeight.oneFifty_FourtyFive.rawValue
            
        case (PatientHeightInCm.oneFiftyTwo.rawValue..<PatientHeightInCm.oneFiftyFive.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneFiftyTwo_FourtyFive.rawValue : MenWeight.oneFiftyTwo_FouryEight.rawValue
            
        case (PatientHeightInCm.oneFiftyFive.rawValue..<PatientHeightInCm.oneFiftySeven.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneFiftyFive_FourtyEight.rawValue : MenWeight.oneFiftyFive_FiftyOne.rawValue
            
        case (PatientHeightInCm.oneFiftySeven.rawValue..<PatientHeightInCm.oneSixty.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneFiftySeven_Fifty.rawValue : MenWeight.oneFiftySeven_FiftyThree.rawValue
            
        case (PatientHeightInCm.oneSixty.rawValue..<PatientHeightInCm.oneSixtyThree.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneSixty_FiftyTwo.rawValue : MenWeight.oneSixty_FiftySix.rawValue
            
        case (PatientHeightInCm.oneSixtyThree.rawValue..<PatientHeightInCm.oneSixtyFive.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneSixtyThree_FiftyFour.rawValue : MenWeight.oneSixtyThree_FiftyNine.rawValue
            
        case (PatientHeightInCm.oneSixtyFive.rawValue..<PatientHeightInCm.oneSixtyEight.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneSixtyFive_FiftySeven.rawValue : MenWeight.oneSixtyFive_SixtyTwo.rawValue
            
        case (PatientHeightInCm.oneSixtyEight.rawValue..<PatientHeightInCm.oneSeventy.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneSixtyEight_Fiftynine.rawValue : MenWeight.oneSixtyEight_SixtyFour.rawValue
            
        case (PatientHeightInCm.oneSeventy.rawValue..<PatientHeightInCm.oneSeventyThree.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneSeventy_SixtyOne.rawValue : MenWeight.oneSeventy_SixtySeven.rawValue
            
        case (PatientHeightInCm.oneSeventyThree.rawValue..<PatientHeightInCm.oneSeventyFive.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneSeventyThree_SixtyThree.rawValue : MenWeight.oneSeventyThree_Seventy.rawValue
            
        case (PatientHeightInCm.oneSeventyFive.rawValue..<PatientHeightInCm.oneSeventyEight.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneSeventyFive_SixtySix.rawValue : MenWeight.oneSeventyFive_SeventyThree.rawValue
            
        case (PatientHeightInCm.oneSeventyEight.rawValue..<PatientHeightInCm.oneEighty.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneSeventyEight_SixtyEight.rawValue : MenWeight.oneSeventyEight_SevntyFive.rawValue
            
        case (PatientHeightInCm.oneEighty.rawValue..<PatientHeightInCm.oneEightyThree.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneEighty_Seventy.rawValue : MenWeight.oneEighty_SevntyEight.rawValue
            
        case (PatientHeightInCm.oneEightyThree.rawValue..<PatientHeightInCm.oneEightyFive.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneEightyThree_SeventyTwo.rawValue : MenWeight.oneEightyThree_EightyOne.rawValue
            
        case (PatientHeightInCm.oneEightyThree.rawValue..<PatientHeightInCm.oneEightyFive.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneEightyFive_SeventyFive.rawValue : MenWeight.oneEightyFive_EightyThree.rawValue
            
        case (PatientHeightInCm.oneEightyEight.rawValue..<PatientHeightInCm.oneNintyOne.rawValue)  :
            idealWeight = gender == .female ? WomenWeight.oneEightyEight_SeventySeven.rawValue : MenWeight.oneEightyEight_EightySix.rawValue
            
        case (PatientHeightInCm.oneNintyOne.rawValue..<PatientHeightInCm.oneNintyThree.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneNintyOne_SeventyNine.rawValue : MenWeight.oneNintyOne_EightyNine.rawValue
            
        case (PatientHeightInCm.oneNintyThree.rawValue..<PatientHeightInCm.oneNintyFive.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneNintyThree_EightyTwo.rawValue : MenWeight.oneNintyThree_NintyTwo.rawValue
            
        case (PatientHeightInCm.oneNintyFive.rawValue..<PatientHeightInCm.oneNintyEight.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneNintyFive_EightyFour.rawValue : MenWeight.oneNintyFive_nintyFour.rawValue
            
        case (PatientHeightInCm.oneNintyEight.rawValue..<PatientHeightInCm.twoHundredOne.rawValue) :
            idealWeight = gender == .female ? WomenWeight.oneNintyEight_EightySix.rawValue : MenWeight.oneNintyEight_NintySeven.rawValue
            
        case (PatientHeightInCm.twoHundredOne.rawValue..<PatientHeightInCm.twoHundredThree.rawValue) :
            idealWeight = gender == .female ? WomenWeight.twoHundredOne_EightyEight.rawValue : MenWeight.twoHundredOne_OneHundred.rawValue
            
        case (PatientHeightInCm.twoHundredThree.rawValue..<PatientHeightInCm.twoHundredFive.rawValue) :
            idealWeight = gender == .female ? WomenWeight.twoHundredThree_NintyOne.rawValue : MenWeight.twoHundredThree_OneHundredTwo.rawValue
            
        case (PatientHeightInCm.twoHundredFive.rawValue..<PatientHeightInCm.twoHundredEight.rawValue) :
            idealWeight = gender == .female ? WomenWeight.twoHundredFive_NintyThree.rawValue : MenWeight.twoHundredFive_OneHundredFive.rawValue
            
        case (PatientHeightInCm.twoHundredEight.rawValue..<PatientHeightInCm.twoHundredTen.rawValue) :
            idealWeight = gender == .female ? WomenWeight.twoHundredEight_NintyFive.rawValue : MenWeight.twoHundredEight_OneHundredEight.rawValue
            
        case (PatientHeightInCm.twoHundredTen.rawValue..<PatientHeightInCm.twoHundredThirteen.rawValue) :
            idealWeight = gender == .female ? WomenWeight.twoHundredTen_NintyEight.rawValue : MenWeight.twoHundredTen_OneHundredOne.rawValue

        default:
            idealWeight = 0 // when height less 4 ft. 6 inch
        }
        
        guard let userData = self.userInfo else{
            return
        }
        if idealWeight != 0 {
        userData.medicalInfo[0].patientIdealWeight = idealWeight
        }
        if let weight = userData.medicalInfo[0].patientWeight, idealWeight != 0 {
            let UpdatedWeightInKG = userData.medicalInfo[0].patientWeightType == 0 ? weight : Int(Double(weight) * 2.2)
            let excessWeight = UpdatedWeightInKG - idealWeight
            userData.medicalInfo[0].patientExcessWeight = max(excessWeight, 0)
            if !isServiceHit {
                let indexPath1 = IndexPath(row: 4, section: 1)
                let indexPath2 = IndexPath(row: 5, section: 1)
                self.profileInformationTableView.reloadRows(at: [indexPath1,indexPath2], with: .automatic)
            }
        }
    }
}
