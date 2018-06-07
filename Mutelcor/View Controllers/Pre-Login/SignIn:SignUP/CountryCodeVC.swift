//
//  CountryCodeVC.swift
//  Mutelcor
//
//  Created by on 11/05/17.
//  Copyright © 2017. All rights reserved.
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
        
        case countryCodeVC
        case countryBtnTapped
        case stateBtnTapped
        case townBtntapped
    }
    
    var navigateToScreenBy = NavigateToScreenThrough.countryCodeVC
    
    //    MARK:- Proporties
    //    ==================
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
    
    //    MARK:- ViewController Life Cycle
    //   ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationControllerOn = NavigationControllerOn.login
        self.sideMenuBtnActn = .backBtn
        
        if self.navigateToScreenBy == .countryCodeVC {
            self.setNavigationBar(screenTitle: K_COUNTRYCODE_SCREEN_TITLE.localized)
        }else if self.navigateToScreenBy == .countryBtnTapped{
            self.setNavigationBar(screenTitle: K_COUNTRY_PLACEHOLDER.localized)
        }else if self.navigateToScreenBy == .stateBtnTapped {
            self.setNavigationBar(screenTitle: K_STATE_PLACEHOLDER.localized)
        }else{
            self.setNavigationBar(screenTitle: K_TOWN_PLACEHOLDER.localized)
        }
        
        self.floatBtn.isHidden = true
    }
}

//MARK:- TableView DataSource
//===========================
extension CountryCodeVC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.navigateToScreenBy == .countryCodeVC {
            let rows = shouldShowSearchResults ? self.filteredArray.count : self.country.count
            return rows
        }else if self.navigateToScreenBy == .countryBtnTapped{
            let rows = shouldShowSearchResults ? self.filteredCountryNameArr.count : self.countryCodeModel.count
            return rows
        }else if self.navigateToScreenBy == .stateBtnTapped {
            let rows = shouldShowSearchResults ? self.filteredStateList.count : self.stateList.count
            return rows
        }else{
            let rows = shouldShowSearchResults ? self.filteredCityList.count : self.cityList.count
            return rows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "countryCodeCellID", for: indexPath) as? CountryCodeCell else{
            fatalError("CountryCode Cell Not Found!")
        }
        
        if self.navigateToScreenBy == .countryCodeVC{
            
            let countryName = self.shouldShowSearchResults ? filteredArray[indexPath.row].countryName : country[indexPath.row].countryName
            let countryCode = self.shouldShowSearchResults ? filteredArray[indexPath.row].countryCode : country[indexPath.row].countryCode
            cell.countryNameLabel.text = countryName
            cell.countryCodeLabel.text = countryCode
            
        }else if self.navigateToScreenBy == .countryBtnTapped {
            cell.countryCodeLabel.isHidden = true
            let countryName = self.shouldShowSearchResults ? filteredCountryNameArr[indexPath.row].countryName : countryCodeModel[indexPath.row].countryName
            cell.countryNameLabel.text = countryName
        }else if self.navigateToScreenBy == .stateBtnTapped {
            cell.countryCodeLabel.isHidden = true
            let stateName = self.shouldShowSearchResults ? filteredStateList[indexPath.row].stateName : stateList[indexPath.row].stateName
            cell.countryNameLabel.text = stateName
        }else{
            cell.countryCodeLabel.isHidden = true
            let cityName = self.shouldShowSearchResults ? filteredCityList[indexPath.row].cityName : cityList[indexPath.row].cityName
            cell.countryNameLabel.text = cityName
        }
        
        return cell
    }
}

//Mark:- TableView Delegate
//=========================
extension CountryCodeVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if self.navigateToScreenBy == .countryCodeVC {
            
            self.code = self.shouldShowSearchResults ? self.filteredArray[indexPath.row].countryCode : self.country[indexPath.row].countryCode
            let code = self.shouldShowSearchResults ? self.filteredArray[indexPath.row] : self.country[indexPath.row]
            self.delegate?.setCountry(code)
        }else if self.navigateToScreenBy == .countryBtnTapped {
            self.code = self.shouldShowSearchResults ? self.filteredCountryNameArr[indexPath.row].countryCode! : self.countryCodeModel[indexPath.row].countryCode!
            self.name = self.shouldShowSearchResults ? self.filteredCountryNameArr[indexPath.row].countryName! : self.countryCodeModel[indexPath.row].countryName!
            self.countryDataDelegate?.setCountryData(self.code, name: self.name)
        }else if self.navigateToScreenBy == .stateBtnTapped {
            let stateCode = self.shouldShowSearchResults ? self.filteredStateList[indexPath.row].stateCode : self.stateList[indexPath.row].stateCode
            self.code = String(stateCode ?? 0)
            self.name = self.shouldShowSearchResults ? self.filteredStateList[indexPath.row].stateName : self.stateList[indexPath.row].stateName
            self.countryDataDelegate?.setCountryData(self.code, name: self.name)
        }else{
            self.code = self.shouldShowSearchResults ? self.filteredCityList[indexPath.row].id! : self.cityList[indexPath.row].id!
            self.name = self.shouldShowSearchResults ? self.filteredCityList[indexPath.row].cityName! : self.cityList[indexPath.row].cityName!
            self.countryDataDelegate?.setCountryData(self.code, name: self.name)
        }
        self.view.endEditing(true)
        self.countryNameSearchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Search Bar Delegate
//===================================================================
extension CountryCodeVC: UISearchResultsUpdating, UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //printlnDebug("Called")
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
    func didChangeSearchText(_ searchText: String) {
         let captalizedSearchText = searchText.capitalized
        if self.navigateToScreenBy == .countryCodeVC {
            
            self.filteredArray = country.filter({ (country) -> Bool in
                let countryText: NSString = country.countryName as NSString
                return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
                
            })
            
        }else if self.navigateToScreenBy == .countryBtnTapped{
            
            self.filteredCountryNameArr = self.countryCodeModel.filter({ (countryName) -> Bool in
                if let countryName = countryName.countryName?.capitalized {
                    return countryName.contains(captalizedSearchText)
                }else{
                    return false
                }
            })
            
        }else if self.navigateToScreenBy == .stateBtnTapped {
            
            self.filteredStateList = self.stateList.filter({ (stateName) -> Bool in
                  return stateName.stateName.capitalized.contains(captalizedSearchText)
            })
        }else{
            self.filteredCityList = self.cityList.filter({ (cityName) -> Bool in
                
                if let cityName = cityName.cityName?.capitalized {
                    return cityName.contains(captalizedSearchText)
                }else{
                    return false
                }
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
                    //printlnDebug("nothing")
                }
            } catch _ {
                //printlnDebug(error.localizedDescription)
            }
        } else {
            //printlnDebug("Invalid filename/path.")
        }
    }
    
    //    MARK: Get country List 
    //    =======================
    func getCountries(fromData data: [[String: AnyObject]]){
        var countryDic = [Character : Any]()
        var count = [String]()
        for eachCountry in data{
            
            let data = CountryCode(withDict: eachCountry)
            
            let charac = data.countryName.first
            
            if data.countryName.first == charac {
                
                countryDic[charac!] = count.append(data.countryName)
                
            }
            
            //printlnDebug(count)
            self.country.append(data)
            
            count = []
        }
        
        //printlnDebug(countryDic)
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
        
        self.countryCodeLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.countryNameLabel.font = AppFonts.sanProSemiBold.withSize(16)
    }
}
