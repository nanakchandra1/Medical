//
//  SearchFoodVC.swift
//  Mutelcor
//
//  Created by  on 20/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol SelectFoodDelegate: class {
    func selected(_ food: Food)
}

class SearchFoodVC: BaseViewControllerWithBackButton {
    
    // MARK: - Properties
    var foods: [Food] = []
    var filteredFoods: [Food] = []
    var selectedFoodId: Int?
    
    weak var delegate: SelectFoodDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    // MARK:- ViewController Life Cycle
    // ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredFoods = foods
        
        searchBar.delegate = self
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.tableFooterView = UIView()
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = AppFonts.sansProRegular.withSize(15)
        //searchBar.textField?.font = AppFonts.sansProRegular.withSize(17)
        
        navigationController?.view.backgroundColor = .appColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = .dashboard
        self.setNavigationBar(screenTitle: K_SELECT_FOOD_SCREEN_TITLE.localized)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - Private methods
    
    // MARK: - Public Methods
    
    // MARK: - IBActions
    
}

// MARK: - Search Bar Delegate Methods
extension SearchFoodVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        //navigationController?.setNavigationBarHidden(true, animated: true)
        //UIApplication.shared.statusBarStyle = .default
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            resetSearch()
            
        } else {
            
            filteredFoods = foods.filter { food -> Bool in
                return food.name.lowercased().contains(searchText.lowercased())
            }
            
            searchTableView.reloadData()
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearch()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func resetSearch() {
        filteredFoods = foods
        searchTableView.reloadData()
    }
    
}

// MARK: - TableView DataSource Methods
extension SearchFoodVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchFoodTableCellID", for: indexPath) as? SearchFoodTableCell else {
            fatalError("Cell not found")
        }
        
        cell.label.text = filteredFoods[indexPath.row].name
        if filteredFoods[indexPath.row].id == selectedFoodId {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        
        return cell
    }
    
}

// MARK: - TableView Delegate Methods
extension SearchFoodVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.selected(filteredFoods[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
}

class SearchFoodTableCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Table View Cell LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
}



