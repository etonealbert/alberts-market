//
//  AddEditAddressViewController.swift

import UIKit
import CoreLocation
import GoogleMobileAds
import Alamofire
import OAuthSwiftAlamofire

class AddEditAddressViewController: UIViewController, CLLocationManagerDelegate, GADBannerViewDelegate {

    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtPincode: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtAddressLine: UITextView!
    @IBOutlet weak var txtAddressLine2: UITextView!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var btnSaveAddress: UIButton!
    @IBOutlet weak var btnCurrentLocation: UIButton!
        
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwBanner: UIView!
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblUserLocation: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblPinCode: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAddress2: UILabel!
    
    //MARK: -
    //MARK: - Variables
    
    var locationManager:CLLocationManager!
    var isFromEdit = Bool()
    var isFromAddressManager = Bool()
    var timer: Timer!
    var dicAddress = NSDictionary()
    
    var bannerView: GADBannerView!
    
    //MARK: -
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpObject()
    }
    
    //MARK: -
    //MARK: - SetUpObject Method
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        
        lblUserLocation.text = LanguageLocal.myLocalizedString(key: "Use_Current_Location")
        lblFullName.text = LanguageLocal.myLocalizedString(key: "Full_Name")
        lblPinCode.text = LanguageLocal.myLocalizedString(key: "PinCode")
        lblCity.text = LanguageLocal.myLocalizedString(key: "City")
        lblState.text = LanguageLocal.myLocalizedString(key: "State")
        lblAddress.text = LanguageLocal.myLocalizedString(key: "Address")
        lblAddress2.text = LanguageLocal.myLocalizedString(key: "Address2")
        lblCountry.text = LanguageLocal.myLocalizedString(key: "Country")
        lblPhoneNo.text = LanguageLocal.myLocalizedString(key: "Phone_Number")
        self.btnSaveAddress.setTitle(LanguageLocal.myLocalizedString(key: "Save_Address"), for: .normal)
        
        if isFromEdit {
            lblHeader.text = LanguageLocal.myLocalizedString(key: "Edit_Address")
            
            txtFullName.text = "\(dicAddress.value(forKey: "first_name") ?? "") \(dicAddress.value(forKey: "last_name") ?? "")"
            txtPincode.text = "\(dicAddress.value(forKey: "postcode") ?? "")"
            txtCity.text = "\(dicAddress.value(forKey: "city") ?? "")"
            txtState.text = "\(dicAddress.value(forKey: "state") ?? "")"
            txtCountry.text = "\(dicAddress.value(forKey: "country") ?? "")"
            txtAddressLine.text = "\(dicAddress.value(forKey: "address_1") ?? "")"
            txtAddressLine2.text = "\(dicAddress.value(forKey: "address_2") ?? "")"
            txtPhoneNumber.text = "\(dicAddress.value(forKey: "contact") ?? "")"
        }
        else {
            lblHeader.text = "Add New Address"
            lblHeader.text = LanguageLocal.myLocalizedString(key: "Add_New_Address")
            
            txtFullName.text = ""
            txtPincode.text = ""
            txtCity.text = ""
            txtState.text = ""
            txtCountry.text = ""
            txtAddressLine.text = ""
            txtAddressLine2.text = ""
            txtPhoneNumber.text = ""
        }
        
        self.vwHeader.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
        self.vwHeader.layer.shadowOpacity = 2.0
        self.vwHeader.layer.shadowRadius = 2.0
        self.vwHeader.layer.shadowOffset = CGSize(width: 0.0 , height: 2.0)
                
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
    
    //MARK: -
    //MARK: - location delegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                
                self.txtCity.text = "\(placemark.locality ?? "")"
                self.txtPincode.text = "\(placemark.postalCode ?? "")"
                self.txtState.text = "\(placemark.administrativeArea ?? "")"
                self.txtCountry.text = "\(placemark.country ?? "")"
                
                self.txtAddressLine.text = "\(placemark.subLocality ?? ""), \(placemark.locality ?? ""), \(placemark.postalCode ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")"
                
                print("\(placemark.subLocality!), \(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)")
                
                THelper.hideProgress(vc: self)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    //MARK: -
    //MARK: - UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCurrentLocation_Clicked(_ sender: Any) {
        THelper.ShowProgress(vc: self)
        btnCurrentLocation.isUserInteractionEnabled = false
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.updateView), userInfo: nil, repeats: false)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func btnSaveAddress_Clicked(_ sender: Any) {
        if txtFullName.text != "" && txtPincode.text != "" && txtCity.text != "" && txtState.text != "" && txtCountry.text != "" && txtAddressLine.text != "" && txtPhoneNumber.text != "" {
            var dicAddress = [String : Any]()
            
            print(dicAddress)
            
            if isFromEdit == false {
                dicAddress = ["first_name":txtFullName.text ?? "",
                              "last_name":"",
                              "postcode":txtPincode.text ?? "",
                              "city":txtCity.text ?? "",
                              "state":txtState.text ?? "",
                              "country":txtCountry.text ?? "",
                              "address_1":txtAddressLine.text ?? "",
                              "address_2":txtAddressLine2.text ?? "",
                              "contact":txtPhoneNumber.text ?? "",
                              "phone":txtPhoneNumber.text ?? "",
                              "company":""
                    ]
                addAddressAPI(param: dicAddress)
            }
            else {
                dicAddress = ["ID":"\(self.dicAddress.value(forKey: "ID") ?? "")",
                              "first_name":txtFullName.text ?? "",
                              "last_name":"",
                              "postcode":txtPincode.text ?? "",
                              "city":txtCity.text ?? "",
                              "state":txtState.text ?? "",
                              "country":txtCountry.text ?? "",
                              "address_1":txtAddressLine.text ?? "",
                              "address_2":txtAddressLine2.text ?? "",
                              "contact":txtPhoneNumber.text ?? "",
                              "phone":txtPhoneNumber.text ?? "",
                              "company":""
                    ]
                addAddressAPI(param: dicAddress)
            }
        }
        else {
            THelper.toast("All fields are required", vc: self)
        }
    }
    
    //MARK: -
    //MARK: - Other Method
    
    @objc func updateView(){
        timer.invalidate()
        btnCurrentLocation.isUserInteractionEnabled = true
    }
    
    //MARK: -
    //MARK: - API Calling
    
    func addAddressAPI(param: [String : Any]) {
        THelper.ShowProgress(vc: self)
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_ADD_ADDRESS)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    print(response.response?.statusCode ?? "")
                    if response.response?.statusCode == 200 {
                        print(data)
                        
                        NotificationCenter.default.post(name: NSNotification.Name("Address"), object: self, userInfo: ["flag":"1"])
//                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        print(data)
                        let dicError:NSDictionary = data as! NSDictionary
                        let str:String = "\(dicError.value(forKey: "message") ?? "")"
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
