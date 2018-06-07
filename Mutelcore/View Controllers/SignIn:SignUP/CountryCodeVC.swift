//
//  CountryCodeVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 11/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

protocol CountryCodeDelegate:class {
    
    func setCountry(_ country: CountryCode)
    
}

protocol CountryDataDelegate:class {
    
    func setCountryData(_ code : String, name : String)
}

class CountryCodeVC: BaseViewController {
    
    enum NavigateToScreenThrough {
        
        case countryCodeVC, countryBtnTapped, stateBtnTapped, townBtntapped
    }
    
    var navigateToScreenBy = NavigateToScreenThrough.countryCodeVC
    
//    MARK:- Proporties
//    ==================
    let sectionArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var shouldShowSearchResults = false
    weak var delegate: CountryCodeDelegate?
    weak var countryDataDelegate : CountryDataDelegate?
    
    var countryCodeModel = [CountryCodeModel]()
    var filteredCountryNameArr = [CountryCodeModel]()
    
    var country = [CountryCode]()
    var filteredArray = [CountryCode]()
    
    var stateList = [StateNameModel]()
    var filteredStateList = [StateNameModel]()
    
    var cityList = [CityNameModel]()
    var filteredCityList = [CityNameModel]()
    
    var countryArray = [[String:AnyObject]]()
    let sectiArray = [String]()
    var code = ""
    var name = ""
    var sortedCountryCode : [Character : [String]] = [:]
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var countryCodeListingTableView: UITableView!
    @IBOutlet weak var countryNameSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationControllerOn = NavigationControllerOn.login
        self.sideMenuBtnActn = SidemenuBtnAction.BackBtn
        self.floatBtn.isHidden = true
                
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.navigateToScreenBy == .countryCodeVC {
            
           self.setNavigationBar(K_COUNTRYCODE_SCREEN_TITLE.localized, 0, 0)
        }else if self.navigateToScreenBy == .countryBtnTapped{
            
           self.setNavigationBar("Country", 0, 0)
        }else if self.navigateToScreenBy == .stateBtnTapped {
            
           self.setNavigationBar("State", 0, 0)
        }else{
            
           self.setNavigationBar("Town", 0, 0)
        }
    }
}

//MARK:- TableView DataSource
//===========================
extension CountryCodeVC : UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.navigateToScreenBy == .countryCodeVC {
            
            if shouldShowSearchResults {
                
                return self.filteredArray.count
            }
            else {
                
                return self.country.count
            }
            
        }else if self.navigateToScreenBy == .countryBtnTapped{
            
            if shouldShowSearchResults {
                
                return self.filteredCountryNameArr.count
            }
            else {
                
                return self.countryCodeModel.count
            }
            
        }else if self.navigateToScreenBy == .stateBtnTapped {
            
            if shouldShowSearchResults {
                
                return self.filteredStateList.count
            }
            else {
                
                return self.stateList.count
            }
            
        }else{
            
            if shouldShowSearchResults {
                
                return self.filteredCityList.count
            }
            else {
                
                return self.cityList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "countryCodeCellID", for: indexPath) as? CountryCodeCell else{
            
            fatalError("CountryCode Cell Not Found!")
        }
        
        if self.navigateToScreenBy == .countryCodeVC{
            
            if self.shouldShowSearchResults {
                
                cell.countryNameLabel.text = filteredArray[indexPath.row].countryName
                cell.countryCodeLabel.text = self.filteredArray[indexPath.row].countryCode
            }
            else {
                cell.countryNameLabel.text = country[indexPath.row].countryName
                cell.countryCodeLabel.text = self.country[indexPath.row].countryCode
            }
            
        }else if self.navigateToScreenBy == .countryBtnTapped {
            
            cell.countryCodeLabel.isHidden = true
            
            if self.shouldShowSearchResults {
                cell.countryNameLabel.text = self.filteredCountryNameArr[indexPath.row].countryName
            }
            else {
                cell.countryNameLabel.text = self.countryCodeModel[indexPath.row].countryName
                
            }
            
        }else if self.navigateToScreenBy == .stateBtnTapped {
            
            cell.countryCodeLabel.isHidden = true
            
            if self.shouldShowSearchResults {
                cell.countryNameLabel.text = self.filteredStateList[indexPath.row].stateName
                
            }
            else {
                cell.countryNameLabel.text = self.stateList[indexPath.row].stateName
                
            }
            
        }else{
            
            cell.countryCodeLabel.isHidden = true
            
            if self.shouldShowSearchResults {
                cell.countryNameLabel.text = self.filteredCityList[indexPath.row].cityName
                
            }
            else {
                cell.countryNameLabel.text = self.cityList[indexPath.row].cityName
                
            }
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "countryCodeHeaderViewID") as? CountryCodeHeaderView else{
//            
//            fatalError("CountryCodeHeaderView Cell Not Found!")
//        }india
//        
//        headerCell.headerImageView.isHidden = true
//        headerCell.haederLabel.text = self.sectionArray[section]
//        
//        return headerCell
//    }
}

//Mark:- TableView Delegate
//=========================
extension CountryCodeVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 30
    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
//
//        return 30
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if self.navigateToScreenBy == .countryCodeVC {
            
            if self.shouldShowSearchResults {
                
                self.code = self.filteredArray[indexPath.row].countryCode
                self.delegate?.setCountry(self.filteredArray[indexPath.row])
                
            }
            else {
                
                self.code = self.country[indexPath.row].countryCode
                self.delegate?.setCountry(self.country[indexPath.row])
                
            }
            
        }else if self.navigateToScreenBy == .countryBtnTapped {
            
            if self.shouldShowSearchResults {
                
                self.code = self.filteredCountryNameArr[indexPath.row].countryCode!
                self.name = self.filteredCountryNameArr[indexPath.row].countryName!
                self.countryDataDelegate?.setCountryData(self.code, name: self.name)
                
            }
            else {
                
                self.code = self.countryCodeModel[indexPath.row].countryCode!
                self.name = self.countryCodeModel[indexPath.row].countryName!
                self.countryDataDelegate?.setCountryData(self.code, name: self.name)
                
            }
            
        }else if self.navigateToScreenBy == .stateBtnTapped {
            
            if self.shouldShowSearchResults {
                
                self.code = self.filteredStateList[indexPath.row].stateCode!
                self.name = self.filteredStateList[indexPath.row].stateName!
                self.countryDataDelegate?.setCountryData(self.code, name: self.name)
                
            }
            else {
                
                self.code = self.stateList[indexPath.row].stateCode!
                self.name = self.stateList[indexPath.row].stateName!
                self.countryDataDelegate?.setCountryData(self.code, name: self.name)
                
            }
            
        }else{
            
            if self.shouldShowSearchResults {
                
                if let id = self.filteredCityList[indexPath.row].id{
                    
                   self.code = "\(id)"
                }
                self.name = self.filteredCityList[indexPath.row].cityName!
                self.countryDataDelegate?.setCountryData(self.code, name: self.name)
                
            }
            else {
                
                if let id = self.cityList[indexPath.row].id{
                    
                    self.code = "\(id)"
                }
                self.name = self.cityList[indexPath.row].cityName!
                self.countryDataDelegate?.setCountryData(self.code, name: self.name)
            }
        }
        
        self.view.endEditing(true)
        self.countryNameSearchBar.resignFirstResponder()
        
        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc(sectionIndexTitlesForTableView:) func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//       
//        return sectionArray
//    }
//    
//    // tell about returned section
//    @objc(tableView:sectionForSectionIndexTitle:atIndex:) func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        
//        return index
//    }
}

//MARK:- Search Bar Delegate
//===================================================================
extension CountryCodeVC: UISearchResultsUpdating, UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        printlnDebug("Called")
        
        self.countryNameSearchBar.showsCancelButton = true

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            
            self.shouldShowSearchResults = false
            self.countryCodeListingTableView.reloadData()
        
        }else{
            
            self.shouldShowSearchResults = true
            self.didChangeSearchText(searchText)
        
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
        self.shouldShowSearchResults = false
       
        self.countryNameSearchBar.showsCancelButton = false
       
        self.countryNameSearchBar.resignFirstResponder()
        
        self.countryCodeListingTableView.reloadData()
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//        if !shouldShowSearchResults {
//            
//            self.shouldShowSearchResults = true
//            self.countryCodeListingTableView.reloadData()
//        }
//    }
    
    // MARK: CustomSearchControllerDelegate functions
//    func didStartSearching() {
//        self.shouldShowSearchResults = true
//        self.countryCodeListingTableView.reloadData()
//    }
    
    
//    func didTapOnSearchButton() {
//        if !self.shouldShowSearchResults {
//            
//            self.shouldShowSearchResults = true
//            self.countryCodeListingTableView.reloadData()
//        }
//    }
    

    func didChangeSearchText(_ searchText: String) {
        
        if self.navigateToScreenBy == .countryCodeVC {
        
        self.filteredArray = country.filter({ (country) -> Bool in
            let countryText: NSString = country.countryName as NSString
            return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            
        })
            
        }else if self.navigateToScreenBy == .countryBtnTapped{
            
           self.filteredCountryNameArr = self.countryCodeModel.filter({ (countryName) -> Bool in
                
            let countryName = countryName.countryName!
            
            let countryText: NSString = countryName as NSString
            return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            
//            let range = searchText.range(of: searchText)
//
//            return (countryName.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: range, locale: nil) != nil)
            })
            
        }else if self.navigateToScreenBy == .stateBtnTapped {
            
            self.filteredStateList = self.stateList.filter({ (stateName) -> Bool in
                
                let stateName = stateName.stateName!
                
                let range = searchText.range(of: searchText)
                
                return (stateName.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: range, locale: nil) != nil)
            })
            
            
        }else{
            
            self.filteredCityList = self.cityList.filter({ (cityName) -> Bool in
                
                let cityName = cityName.cityName!
                
                let range = searchText.range(of: searchText)
                
                return (cityName.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: range, locale: nil) != nil)
            })
        }
        
        self.countryCodeListingTableView.reloadData()
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    func updateSearchResults(for searchController: UISearchController) {
        
        self.filteredArray.removeAll()
        
        guard let searchString = searchController.searchBar.text else {
            return
        }
        // Filter the data array and get only those countries that match the search text.
        self.filteredArray = country.filter({ (country) -> Bool in
            let countryText:NSString = country.countryName as NSString
            return (countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        self.countryCodeListingTableView.reloadData()
    }
}

//MARK:- Methods
//===============
extension CountryCodeVC {
    
    fileprivate func setupUI(){
        
        self.countryCodeListingTableView.delegate = self
        self.countryCodeListingTableView.dataSource = self
        
        let headerNib = UINib(nibName: "CountryCodeHeaderView", bundle: nil)
        self.countryCodeListingTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "countryCodeHeaderViewID")

        self.countryNameSearchBar.delegate = self
        self.floatBtn.isHidden = true
        
        self.getList()

    }
    
//    MARK: Get Country Data From JSON
//    ================================
    func getList(){
        
        if let path = Bundle.main.path(forResource: "CountryCode", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObject =  try JSONSerialization.jsonObject(with: data , options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? [String: AnyObject] {
                    
                    if let sendData = jsonDict["countryDetails"] as? [[String: AnyObject]]{
                        self.getCountries(fromData: sendData)
                        self.countryArray = sendData
                    }
                }else {
                    printlnDebug("nothing")
                }
                
            } catch let error {
                printlnDebug(error.localizedDescription)
            }
        } else {
            printlnDebug("Invalid filename/path.")
        }
    }
    
//    MARK: Get country List 
//    =======================
    func getCountries(fromData data: [[String: AnyObject]]){
        var countryDic = [Character : Any]()
        var count = [String]()
        for eachCountry in data{
            
            let data = CountryCode(withDict: eachCountry)
            
            let charac = data.countryName.characters.first
            
            if data.countryName.characters.first == charac {
                
                countryDic[charac!] = count.append(data.countryName)
                
            }
            
            printlnDebug(count)
            self.country.append(data)
            
            count = []
        }
        
        printlnDebug(countryDic)
        self.countryCodeListingTableView.reloadData()
    }
}

//MARK:- TableViewCell
//====================
class CountryCodeCell : UITableViewCell {
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.countryCodeLabel.font = AppFonts.sanProSemiBold.withSize(14)
        self.countryNameLabel.font = AppFonts.sanProSemiBold.withSize(14)
        
    }
}
