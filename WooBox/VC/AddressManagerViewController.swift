//
//  AddressManagerViewController.swift

import UIKit
import FCAlertView
import GoogleMobileAds
import Alamofire
import OAuthSwiftAlamofire

class AddressManagerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FCAlertViewDelegate, GADBannerViewDelegate {

    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblAddress: UITableView!
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblNoAddressFound: UILabel!
    
    @IBOutlet weak var btnAddAddress: UIButton!
    
    @IBOutlet weak var vwBanner: UIView!
    
    //MARK: -
    //MARK: - Varibles
    var AddressIndex = Int()
    var DeleteIndex = Int()
    var arrAddress = NSArray()
    
    var bannerView: GADBannerView!
    
    //MARK: -
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpObject()
    }

    //MARK: -
    //MARK: - SetUpObject Method
    
    func SetUpObject(){
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        getAddressAPI()
        
        self.lblHeader.text = LanguageLocal.myLocalizedString(key: "Adderess_Manager")
        self.btnAddAddress.setTitle(LanguageLocal.myLocalizedString(key: "Add_Address"), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNotification(_:)), name: NSNotification.Name("Address"), object: nil)
        
        if IPAD {
                bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
            }
            else {
                bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            }
            bannerView.adUnitID = BANNER_ID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            bannerView.delegate = self
        }
        
        //MARK:-
        //MARK:- ADMob Delegate
        
        func adViewDidReceiveAd(_ bannerView: GADBannerView) {
            if IPAD {
                constraintVwBannerHeight.constant = 60
            }
            else {
                constraintVwBannerHeight.constant = 50
            }
            vwBanner.addSubview(bannerView)
        }

        func adView(_ bannerView: GADBannerView,
            didFailToReceiveAdWithError error: GADRequestError) {
            constraintVwBannerHeight.constant = 0
        }
    
    func SetUpValue() {
        AddressIndex = Int(TPreferences.readString(SELECTED_ADDRESS) ?? "0") ?? 0
        if arrAddress.count > 0 {
            lblNoAddressFound.isHidden = true
            tblAddress.isHidden = false
        }
        else {
            lblNoAddressFound.isHidden = false
            tblAddress.isHidden = true
        }
    }
    
    //MARK: -
    //MARK: - Other Methods
    
    @objc func receiveNotification(_ notification: Notification?) {
        if let aNotification = notification {
            print("\(aNotification)")
        }
        getAddressAPI()
        tblAddress.reloadData()
    }
    
    //MARK: -
    //MARK: - UITableview Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAddress.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblAddress.register(UINib.init(nibName: "AddressTableCell", bundle: nil), forCellReuseIdentifier: "AddressCell" )
        
        let cell = tblAddress.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressTableCell
        
        let dicAddress:NSDictionary = arrAddress[indexPath.row] as! NSDictionary
        cell.lblName.text = "\(dicAddress.value(forKey: "first_name") ?? "") \(dicAddress.value(forKey: "last_name") ?? "")"
        cell.lblAddressType.text = "\(dicAddress.value(forKey: "country") ?? "")"
        cell.lblAddress.text = "\(dicAddress.value(forKey: "address_1") ?? ""), \(dicAddress.value(forKey: "city") ?? "")-\(dicAddress.value(forKey: "postcode") ?? ""), \(dicAddress.value(forKey: "state") ?? "")"
        cell.lblContactNo.text = "\(dicAddress.value(forKey: "contact") ?? "")"
        
        if AddressIndex == indexPath.row {
            cell.btnCheck.setImage(UIImage(named: "icoRadioChecked"), for: .normal)
        }
        else {
            cell.btnCheck.setImage(UIImage(named: "icoRadioUnchecked"), for: .normal)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AddressIndex = indexPath.row
        TPreferences.writeString(SELECTED_ADDRESS, value: "\(AddressIndex)")
        tblAddress.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            let vc = AddEditAddressViewController(nibName: "AddEditAddressViewController", bundle: nil)
            vc.isFromEdit = true
            vc.isFromAddressManager = true
            vc.dicAddress = self.arrAddress[indexPath.row] as! NSDictionary
            self.present(vc, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        editAction.backgroundColor = .orange
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            THelper.displayAlert(self, title: "", message: "Are you sure you want to Delete this Address", tag: 101, firstButton: "Cancel", doneButton: "OK")
            self.DeleteIndex = indexPath.row
        }
        deleteAction.backgroundColor = .red

        return [editAction,deleteAction]
    }
    
    //MARK: -
    //MARK: -fcAlertDoneButtonClicked
    
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView?) {
        if alertView?.tag == 101 {
            print("item Delete:-\(self.DeleteIndex)")
            let dicAddress: NSDictionary = arrAddress[DeleteIndex] as! NSDictionary
            deleteAddressAPI(id: "\(dicAddress.value(forKey: "ID") ?? "")")
            
        }
    }
    
    //MARK: -
    //MARK: - UIButton Clicked Methods.

    @IBAction func btnAddAddress_Clicked(_ sender: Any) {
        let vc = AddEditAddressViewController(nibName: "AddEditAddressViewController", bundle: nil)
        vc.isFromEdit = false
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -
    //MARK: - API Calling
    
    func getAddressAPI() {
        THelper.ShowProgress(vc: self)
                                
        Alamofire.request(TPreferences.getCommonURL(NEW_GET_ADDRESS)!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    THelper.hideProgress(vc: self)
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            print(data)
                            if TValidation.isArray(data) {
                                self.arrAddress = data as! NSArray
                            }
                            else {
                                self.arrAddress = []
                            }
                            
                            if self.arrAddress.count > 0 {}
                            else {
                                TPreferences.removePreference(SELECTED_ADDRESS)
                            }
                            self.tblAddress.reloadData()
                            self.SetUpValue()
                        }
                        else {
                            print(data)
                            let dicError:NSDictionary = data as! NSDictionary
                            let str:String = dicError.value(forKey: "message") as! String
                            THelper.toast(str.html2String, vc: self)
                        }
                    }
                    break
                    
                case .failure(_):
                    THelper.hideProgress(vc: self)
                    THelper.toast(ERROR_MSG, vc: self)
                    print(response.result.error?.localizedDescription ?? "Something went wrong")
    //                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                    break
                }
            }
        }
    
    func deleteAddressAPI(id: String) {
        THelper.ShowProgress(vc: self)
                            
        let param = ["ID" : id
        ]
        
        Alamofire.request(TPreferences.getCommonURL(NEW_DELETE_ADDRESS)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    THelper.hideProgress(vc: self)
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            print(data)
                            TPreferences.writeString(SELECTED_ADDRESS, value: "0")
                            self.getAddressAPI()
                        }
                        else {
                            print(data)
                            let dicError:NSDictionary = data as! NSDictionary
                            let str:String = dicError.value(forKey: "message") as! String
                            THelper.toast(str.html2String, vc: self)
                        }
                    }
                    break
                    
                case .failure(_):
                    THelper.hideProgress(vc: self)
                    THelper.toast(ERROR_MSG, vc: self)
                    print(response.result.error?.localizedDescription ?? "Something went wrong")
    //                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                    break
                }
            }
        }
}
