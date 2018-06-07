//
//  ConnectedDeviceVC.swift
//  Mutelcor
//
//  Created by on 08/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ActivityData: Int{
    case api = 1
    case device = 2
    case manual = 3
}

enum ConnectedDevice: Int {
    case iHealthApi = 1
    case iHealthDevice = 2
    case manual = 3
    case fitbitAPi = 4
    case fitbitDevice = 5
}

enum DevicesView {
    case application
    case devices
}

class ConnectedDeviceVC: BaseViewController {

    //    MARK:- Proporties
    //    ===================
    var applicationTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
    var devicesTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
    let devicesConnectionType = [K_CONNECTED_TITLE.localized, K_AVAILIABLE_TITLE.localized]
    var connectedDevice = [Any]()

    var availiableDevice: [Any] = []//[[K_IHEALTH.localized, #imageLiteral(resourceName: "ihealth")]] as [Any]
    var connectedApi = [Any]()
    var availiableApi = [[K_IHEALTH.localized, #imageLiteral(resourceName: "ihealth")],[K_FITBIT.localized, #imageLiteral(resourceName: "ic_fitbit_")]] as [Any]
    var tabViewBtnTapped  = DevicesView.application{
        willSet{
            switch newValue {
            case .application :
                self.applicationsBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
                self.devicesBtnOutlt.titleLabel?.font = AppFonts.sansProRegular.withSize(16)
                
            case .devices :
                self.devicesBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
                self.applicationsBtnOutlt.titleLabel?.font = AppFonts.sansProRegular.withSize(16)
            }
        }
    }
    
    var connectedDeviceSync: ConnectedDevice = .manual
    var calculatedValues: [CalculatedValue] = []
    var activityFormModel = [ActivityFormModel]()
    var lastSyncedData = [LastSyncedData]()
    fileprivate var activityName = [String]()
    fileprivate var distanceValue = DistanceUnit.kms
    fileprivate var durationValue = DurationUnit.mins
    fileprivate var intensityValue = IntensityValue.low
    fileprivate var isDeviceSelected: Bool = false

    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var tabBarOuterView: UIView!
    @IBOutlet weak var horizontalSepratorView: UIView!
    @IBOutlet weak var applicationsBtnOutlt: UIButton!
    @IBOutlet weak var devicesBtnOutlt: UIButton!
    @IBOutlet weak var devicesDetailScrollView: UIScrollView!
    @IBOutlet weak var noDeviceFoundLabel: UILabel!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_CONNECTED_DEVICES_TITLE.localized)
    }
    
    //    MARK:- IBActions
    //    =================
    @IBAction func applicationsBtnTapped(_ sender: UIButton) {
        self.noDeviceFoundLabel.isHidden = true
        guard self.tabViewBtnTapped != .application else{
            return
        }
        self.tabViewBtnTapped = .application
        self.applicationTableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.devicesDetailScrollView.contentOffset.x = 0
            self.horizontalSepratorView.frame.origin.x = 0
        }
    }
    
    @IBAction func devicesBtnTapped(_ sender: UIButton) {
        self.noDeviceFoundLabel.isHidden = false
        guard self.tabViewBtnTapped != .devices else{
            return
        }
        self.tabViewBtnTapped = .devices
        self.devicesTableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.devicesDetailScrollView.contentOffset.x = UIDevice.getScreenWidth
            self.horizontalSepratorView.frame.origin.x = self.horizontalSepratorView.frame.width
        }
    }
}

//MARK:- Methods
//==============
extension ConnectedDeviceVC {
    
    fileprivate func setupUI(){
        self.applicationsBtnOutlt.setTitle(K_APPLICATION_TITLE.localized, for: .normal)
        self.devicesBtnOutlt.setTitle(K_DEVICES_TITLE.localized, for: .normal)
        self.applicationsBtnOutlt.setTitleColor(UIColor.black, for: .normal)
        self.devicesBtnOutlt.setTitleColor(UIColor.black, for: .normal)
        self.horizontalSepratorView.backgroundColor = UIColor.appColor
        self.tabBarOuterView.shadow(10, CGSize.zero, .black, opacity: 1.0)
        self.tabViewBtnTapped = .application
        self.calculatedValues.append(CalculatedValue())
        self.calculatedValues[0].intensityType = .moderate
        
        self.noDeviceFoundLabel.isHidden = true

        self.addSubView()
        self.setupTableViewUI()
        self.registerNibs()
        self.getActivityFormData()
        self.lastSyncData()
    }

    fileprivate func setupTableViewUI(){
        self.applicationTableView.separatorStyle = .none
        self.devicesTableView.separatorStyle = .none
        self.applicationTableView.dataSource = self
        self.applicationTableView.delegate = self
        self.devicesTableView.dataSource = self
        self.devicesTableView.delegate = self
        self.devicesDetailScrollView.delegate = self
    }
    
    fileprivate func addSubView(){
        
        guard let nvc = self.navigationController else{
            return
        }
        let height = nvc.navigationBar.frame.height + self.tabBarOuterView.frame.height
        let applicationTableViewFrame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight - height - 20)
        let deviceTableViewFrame = CGRect(x: UIDevice.getScreenWidth, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight - height - 20)
        self.applicationTableView.frame = applicationTableViewFrame
        self.devicesTableView.frame = deviceTableViewFrame
        self.devicesDetailScrollView.contentSize = CGSize(width: 2 * UIDevice.getScreenWidth, height: 2)
        self.devicesDetailScrollView.backgroundColor = UIColor.white
        self.devicesDetailScrollView.addSubview(self.applicationTableView)
        self.devicesDetailScrollView.addSubview(self.devicesTableView)
    }
    
    fileprivate func registerNibs(){
        let notificationDetailCellNib = UINib(nibName: "ConnectedDevicesCell", bundle: nil)
        let headerViewNib = UINib(nibName: "AttachmentHeaderViewCell", bundle: nil)
        self.devicesTableView.register(notificationDetailCellNib, forCellReuseIdentifier: "connectedDevicesCellID")
        self.applicationTableView.register(notificationDetailCellNib, forCellReuseIdentifier: "connectedDevicesCellID")
        self.applicationTableView.register(headerViewNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
        self.devicesTableView.register(headerViewNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
    }
}

//MARK:- UIScrollViewDelegate Methods
//===================================
extension ConnectedDeviceVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView === self.devicesDetailScrollView {
            
            let horizontalSepratorViewXAxis = (self.devicesDetailScrollView.contentOffset.x < UIDevice.getScreenWidth) ? 0 : self.horizontalSepratorView.frame.width
            let tabBarviewBtn: DevicesView = (horizontalSepratorViewXAxis == 0) ? .application : .devices
            UIView.animate(withDuration: 0.33, animations: {
                self.horizontalSepratorView.frame.origin.x = horizontalSepratorViewXAxis
                self.tabViewBtnTapped = tabBarviewBtn
            })
            let tableView: UITableView = (horizontalSepratorViewXAxis == 0) ? self.applicationTableView : self.devicesTableView
            let isLabelHidden: Bool = tableView === self.applicationTableView ? true : false
            self.noDeviceFoundLabel.isHidden = isLabelHidden
            tableView.reloadData()
        }
    }
}

//MARK:- UITableViewDataSource Methods
//===================================
extension ConnectedDeviceVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.devicesConnectionType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var connectedDevicesCount = 0
        var availiableDevicesCount = 0
        if tableView === self.applicationTableView {
            connectedDevicesCount = self.connectedApi.count
            availiableDevicesCount = self.availiableApi.count
        }
        let rows = (section == 1) ? availiableDevicesCount : connectedDevicesCount
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "connectedDevicesCellID", for: indexPath) as? ConnectedDevicesCell else{
            fatalError("NotificationDetailCell not found!")
        }
        
        switch tableView {
            
        case self.applicationTableView:
            cell.populateData(deviceView: self.tabViewBtnTapped, indexPath: indexPath, avaliable: self.availiableApi, connected: self.connectedApi)
        default:
            cell.populateData(deviceView: self.tabViewBtnTapped, indexPath: indexPath, avaliable: self.availiableDevice, connected: self.connectedDevice)
        }
        
        return cell
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension ConnectedDeviceVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch tableView {
        case self.applicationTableView:
            switch indexPath.section {
            case 1:
                switch indexPath.row {
                case 0:
                    return self.connectedDeviceSync == .iHealthApi ? CGFloat.leastNormalMagnitude : UITableViewAutomaticDimension
                case 1:
                    return self.connectedDeviceSync == .fitbitAPi ? CGFloat.leastNormalMagnitude : UITableViewAutomaticDimension
                default:
                    return UITableViewAutomaticDimension
                }
            default:
                return UITableViewAutomaticDimension
            }
        case self.devicesTableView:
            return UITableViewAutomaticDimension
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch tableView {
            
        case self.applicationTableView :
            switch section {
            case 0:
                let height = !self.connectedApi.isEmpty ? 30 : CGFloat.leastNormalMagnitude
                return height
            case 1:
                let height = !self.availiableApi.isEmpty ? 30 : CGFloat.leastNormalMagnitude
                return height
            default:
                return CGFloat.leastNormalMagnitude
            }
            
        case self.devicesTableView :
            switch section {
            case 0:
                let height = !self.connectedDevice.isEmpty ? 30 : CGFloat.leastNormalMagnitude
                return height
            case 1:
                let height = !self.availiableDevice.isEmpty ? 30 : CGFloat.leastNormalMagnitude
                return height
            default:
                return CGFloat.leastNormalMagnitude
            }
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppNetworking.showLoader()

        if tableView === self.applicationTableView {
            switch indexPath.section {
            case 1:
                switch indexPath.row {
                case 0:
                    let json = AppUserDefaults.value(forKey: .iHealthToken)
                    if json == JSON.null {
                        self.iHealthTapped()
                    } else {
                        self.iHealthTapped()
                    }
                case 1:
                    let json = AppUserDefaults.value(forKey: .fitBitToken)
                    if json == JSON.null {
                        self.fibitTapped()
                    }else{
                        self.fibitTapped()
                    }
                default:
                    return
                }
            default:
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as? AttachmentHeaderViewCell else{
            fatalError("Header not Found!")
        }
        headerView.headerTitle.textColor = UIColor.appColor
        headerView.cellBackgroundView.backgroundColor = UIColor.white
        headerView.headerTitle.text = self.devicesConnectionType[section]
        headerView.dropDownBtn.isHidden = true
        return headerView
    }
}

//MARK:- iHealth Methods
//======================
extension ConnectedDeviceVC {
    
    func openWebView(authUrl: URL, webViewVCFor: OpenWebViewVC){
        guard let nvc = self.navigationController else{
            return
        }
        let webViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
        webViewScene.iHealthAuthUrl = authUrl
        webViewScene.openWebViewVC = webViewVCFor
        webViewScene.delegate = self
        nvc.pushViewController(webViewScene, animated: true)
    }
    
    func queryItems(dictionary: [String: String]) -> [URLQueryItem] {
        return dictionary.map {
            URLQueryItem(name: $0, value: $1)
        }
    }
}

//MARK:- iHealth LoginDelegate Methods
//====================================
extension ConnectedDeviceVC: HealthApiLoginDelegate {
    func codeRetrieved(_ code: String, openWebViewVC: OpenWebViewVC) {
        
        var parameters = [
            "grant_type": "authorization_code",
            "code": code
        ]
        
        switch openWebViewVC {
        case .fitbit:
            self.addFitbitMandatoryFields(&parameters)
            self.getfitbitToken(parameters: parameters)
        case .iHealth:
//                    self.isHealthApiConnected()
            addiHealthMandatoryFields(&parameters)
            getiHealthToken(parameters: parameters)
        default:
            return
        }
    }
}






