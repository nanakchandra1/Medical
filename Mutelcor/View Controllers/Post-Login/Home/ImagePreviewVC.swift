//
//  ImagePreviewVC.swift
//  Mutelcor
//
//  Created by apple on 25/11/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol CapturedImagesDelegate: class {
    func capturedImages(images: [UIImage])
}

class ImagePreviewVC: BaseViewController {
    
    //    MARK:- PROPORTIES
    //    =================
    var capturedImageArray = [UIImage]()
    weak var delegate: CapturedImagesDelegate?
    fileprivate var selectedImage: Int = 0
    fileprivate var uploadedImages = [String]()
    fileprivate var measurementListData: [[MeasurementListModel]] = []
    fileprivate var scanReportData: [ScanReportModel] = []
    var manipulatedDataDic: [String: [TextReportModel]] = [:]
    var passsedData: [String: [[String:Any]]] = [:]
    fileprivate var numberOfTimesOcrServiceHit = 0
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionBackgroundView: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    //    MARK:- ViewController life CYCLE
    //    ===============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.getMeasurementTestList()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    //    MARK:- IBActions
    //    =================
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if !self.capturedImageArray.isEmpty {
            self.capturedImageArray.remove(at: self.selectedImage)
        }
        self.delegate?.capturedImages(images: self.capturedImageArray)
//        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        for image in self.capturedImageArray {
            let encodedImage = self.base64EncodeImage(image)
            self.uploadImage(with: encodedImage)
        }
    }
}

//MARK:- UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
//=====================================================================
extension ImagePreviewVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.capturedImageArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionCellID", for: indexPath) as? ImageCollectionCell else{
            fatalError("cell not found!")
        }
        if indexPath.row == self.capturedImageArray.count {
            cell.cellImage.image = #imageLiteral(resourceName: "icCamera")
        }else{
            cell.cellImage.image = self.capturedImageArray[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize.init(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.capturedImageArray.count {
            self.delegate?.capturedImages(images: self.capturedImageArray)
            self.navigationController?.popViewController(animated: true)
        }else{
            self.selectedImageView.image = self.capturedImageArray[indexPath.item]
        }
    }
}

//MARK:- Functions
//=================
extension ImagePreviewVC {
    
    fileprivate func setupUI(){
        self.floatBtn.isHidden = true
        
        self.selectedImageView.image = self.capturedImageArray.first
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
    }
    
    //MARK: Uploading Image To S3Server
    //===================================
    fileprivate func uploadImage(with imageBase64: String) {
        
        let parameters = ["requests":["image": ["content": imageBase64],
                                      "features": [["type": "DOCUMENT_TEXT_DETECTION", "maxResults": 1]]]] as [String : Any]
        AppNetworking.showLoader()
        DispatchQueue.global().async {
            WebServices.ocrRequest(parameter: parameters,
                                   loader: false,
                                   success: {[weak self] (report: [ScanReportModel]) in
                guard let strongSelf = self else{
                    return
                }
                
                strongSelf.numberOfTimesOcrServiceHit += 1
                
                if strongSelf.scanReportData.isEmpty {
                    strongSelf.scanReportData = report
                }else{
                    strongSelf.scanReportData.append(contentsOf: report)
                }
                strongSelf.calaulateMeasurementData(reportData: strongSelf.scanReportData, measurementListData: strongSelf.measurementListData)
                strongSelf.scanReportData = []
                
                }, failure: {[weak self] (error) in
                    guard let strongSelf = self else{
                        return
                    }
                    
                    strongSelf.numberOfTimesOcrServiceHit += 1
                    strongSelf.calaulateMeasurementData(reportData: strongSelf.scanReportData, measurementListData: strongSelf.measurementListData)
                    showToastMessage(error.localizedDescription)
            })
        }
    }
    
    fileprivate func calaulateMeasurementData(reportData: [ScanReportModel], measurementListData: [[MeasurementListModel]]){
        
        let descriptionText = reportData.first?.completeText ?? ""
        
        var isTestContain: Bool {
            var textContain: Bool = false
            for test in measurementListData {
                for testValue in test {
                    if descriptionText.capitalized.contains(testValue.vitalSubName.capitalized) {
                        textContain = true
                    }
                }
            }
            return textContain
        }
        if isTestContain {
            let scannedTextReport = reportData.first?.scannedTextReport ?? []
            var yCoordinateSortedDic: [String: [TextReportModel]] = [:]
            let sortedTextReport = scannedTextReport.sorted(by: {($0.y4Coordinate) <= ($1.y4Coordinate)})

            var yCoordinate: Int = 0
            for test in sortedTextReport {
                
                if abs((test.y4Coordinate - yCoordinate)) <= 9 {
                    var dicData = yCoordinateSortedDic["\(yCoordinate)"]
                    dicData?.append(test)
                    yCoordinateSortedDic["\(yCoordinate)"] = dicData
                }else{
                    yCoordinate = test.y4Coordinate
                    yCoordinateSortedDic["\(test.y4Coordinate)"] = [test]
                }
            }

            let yCoordinateSortedDicKeys = Array(yCoordinateSortedDic.keys).sorted(by: {(Int($0) ?? 0) < (Int($1) ?? 0)})
            
            for key in yCoordinateSortedDicKeys {
               yCoordinateSortedDic[key] = yCoordinateSortedDic[key]?.sorted(by: {($0.x4Coordinate) <= ($1.x4Coordinate)})
            }

            for test in measurementListData {
                for testValue in test {
                    for key in yCoordinateSortedDicKeys {

                        if let data = yCoordinateSortedDic[key] {
                            let text = data.map({ (report) -> String in
                                return report.text
                            })
                            let reportInLine = text.joined(separator: " ")
                            let report = TextReportModel()
                            if reportInLine.capitalized.contains(testValue.vitalSubName.capitalized) {
                                report.vitalName = testValue.vitalName
                                report.vitalID = testValue.vitalID
                                report.vitalSubName = testValue.vitalSubName
                                report.vitalSuperID = testValue.superID
                                let valueAndUnit = matchedString(forRegex: ValidityExression.getNumberAndUnit.rawValue, inText: reportInLine)
                                
                                if let measurementValueAndunit = valueAndUnit.first {
                                    let value = matchedString(forRegex: ValidityExression.getMeasurementValue.rawValue, inText: measurementValueAndunit)
                                    if let measurementValue = value.first {
                                        report.value = Double(measurementValue.replacingOccurrences(of: " ", with: "")) ?? 0.0
                                        let measurementUnit = measurementValueAndunit.replacingOccurrences(of: measurementValue, with: "").replacingOccurrences(of: " ", with: "")
                                        if measurementUnit == testValue.unit || measurementUnit == testValue.mainUnit {
                                            report.unit = measurementUnit
                                        }else{
                                            report.unit = ""
                                        }
                                    }
                                }

                                if let textReport = self.manipulatedDataDic[testValue.vitalName], !textReport.isEmpty, !report.unit.isEmpty {
                                    var updatedReport = textReport
                                    updatedReport.append(contentsOf: [report])
                                    self.manipulatedDataDic[testValue.vitalName] = updatedReport
                                }else if !report.unit.isEmpty{
                                    self.manipulatedDataDic[testValue.vitalName] = [report]
                                }
                                break
                            }else{
                                continue
                            }
                        }
                    }
                }
            }
        }else{
            showToastMessage("Vitals is not matched")
        }
        AppNetworking.hideLoader()
        DispatchQueue.main.sync {
            
            if self.capturedImageArray.count <= self.numberOfTimesOcrServiceHit, !self.manipulatedDataDic.isEmpty {
                
                let matchedMeasurementTextScene = MatchedMeasurementTextVC.instantiate(fromAppStoryboard: .Dashboard)
                matchedMeasurementTextScene.delegate = self
                matchedMeasurementTextScene.measurementListDic = self.manipulatedDataDic
                matchedMeasurementTextScene.measurementDicKeys = Array(self.manipulatedDataDic.keys)
                AppDelegate.shared.window?.addSubview(matchedMeasurementTextScene.view)
                self.addChildViewController(matchedMeasurementTextScene)
            }else{
                showToastMessage("Vitals is not matched")
            }
        }
    }
    
//    MARK:- GetMeasurementTestList
//    =============================
    fileprivate func getMeasurementTestList(){
        
        WebServices.getMeasurementTestList(success: {[weak self] (test: [[MeasurementListModel]]) in
            
            guard let strongSelf = self else{
                return
            }
            strongSelf.measurementListData = test
        }) { (error: Error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    func getJsonObject(_ Detail: Any) -> String{
        var data = Data()
        do {
            data = try JSONSerialization.data(
                withJSONObject: Detail ,
                options: JSONSerialization.WritingOptions(rawValue: 0))
        }
        catch{
            
        }
        let paramData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        return paramData
    }
    
    
    //    Base64Encoded Image
    //    ==================
    fileprivate func base64EncodeImage(_ image: UIImage) -> String {
        var imageData: NSData = UIImagePNGRepresentation(image)! as NSData
        
        // Resize the image if it exceeds the 2MB API limit
        if (imageData.length > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imageData = resizeImage(newSize, image: image) as NSData
        }
        
        return imageData.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}

extension ImagePreviewVC: RemoveViewDelegate {
    
    func removeView(){
        self.manipulatedDataDic = [:]
    }
}


//MARK:- CollectionViewCell
//=========================
class ImageCollectionCell: UICollectionViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellImage.roundCorner(radius: 10.0, borderColor: UIColor.clear, borderWidth: CGFloat.leastNormalMagnitude)
    }
}
