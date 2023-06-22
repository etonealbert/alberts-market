//
//  TrackItemViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import GoogleMobileAds

class TrackItemViewController: UIViewController, GADBannerViewDelegate {

    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var constraintHeightSafeArea: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwBanner: UIView!
    
    @IBOutlet weak var lblTrackOrder1: UILabel!
    @IBOutlet weak var lblTrackOrderDate1: UILabel!
    @IBOutlet weak var lblTrackNo1: UILabel!
    @IBOutlet weak var lblTrackOrder2: UILabel!
    @IBOutlet weak var lblTrackOrderDate2: UILabel!
    @IBOutlet weak var lblTrackNo2: UILabel!
    @IBOutlet weak var lblTrackOrder3: UILabel!
    @IBOutlet weak var lblTrackOrderDate3: UILabel!
    @IBOutlet weak var lblTrackNo3: UILabel!
    @IBOutlet weak var lblTrackOrder4: UILabel!
    @IBOutlet weak var lblTrackOrderDate4: UILabel!
    @IBOutlet weak var lblTrackNo4: UILabel!
    @IBOutlet weak var lblTrackOrder5: UILabel!
    @IBOutlet weak var lblTrackOrderDate5: UILabel!
    @IBOutlet weak var lblTrackNo5: UILabel!
    
    @IBOutlet weak var btnReplace: UIButton!
    @IBOutlet weak var btnTrackOrder1: UIButton!
    @IBOutlet weak var btnTrackOrder2: UIButton!
    @IBOutlet weak var btnTrackOrder3: UIButton!
    @IBOutlet weak var btnTrackOrder4: UIButton!
    @IBOutlet weak var btnTrackOrder5: UIButton!
    
    //MARK: -
    //MARK: - Variables
    
    var strItemId = String()
    var strOrderId = String()
    var arrTrackOrder = NSArray()
    
    var bannerView: GADBannerView!
    
    //MARK: -
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpObject()
    }
    
    //MARK: -
    //MARK:- SetUpObject Method
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightSafeArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        getTrackOrderAPI()
        
        if IPAD {
            self.btnReplace.layer.cornerRadius = 30.0
        }else {
            self.btnReplace.layer.cornerRadius = 25.0
        }
    }
    
    func SetUpValue() {
        var dicTrackOrder = NSDictionary()
        for i in 0..<arrTrackOrder.count {
            dicTrackOrder = arrTrackOrder[i] as! NSDictionary
            if i == 0 {
                lblTrackOrder1.text = "Order Shipped by \(dicTrackOrder.value(forKey: "tracking_provider") ?? "")"
                lblTrackOrderDate1.text = "\(dicTrackOrder.value(forKey: "date_shipped") ?? "")"
                lblTrackNo1.text = "Tracking number: \(dicTrackOrder.value(forKey: "tracking_number") ?? "")"
                btnTrackOrder1.isUserInteractionEnabled = true
            }
            else if i == 1 {
                lblTrackOrder2.text = "Order Shipped by \(dicTrackOrder.value(forKey: "tracking_provider") ?? "")"
                lblTrackOrderDate2.text = "\(dicTrackOrder.value(forKey: "date_shipped") ?? "")"
                lblTrackNo2.text = "Tracking number: \(dicTrackOrder.value(forKey: "tracking_number") ?? "")"
                btnTrackOrder2.isUserInteractionEnabled = true
            }
            else if i == 2 {
                lblTrackOrder3.text = "Order Shipped by \(dicTrackOrder.value(forKey: "tracking_provider") ?? "")"
                lblTrackOrderDate3.text = "\(dicTrackOrder.value(forKey: "date_shipped") ?? "")"
                lblTrackNo3.text = "Tracking number: \(dicTrackOrder.value(forKey: "tracking_number") ?? "")"
                btnTrackOrder3.isUserInteractionEnabled = true
            }
            else if i == 3 {
                lblTrackOrder4.text = "Order Shipped by \(dicTrackOrder.value(forKey: "tracking_provider") ?? "")"
                lblTrackOrderDate4.text = "\(dicTrackOrder.value(forKey: "date_shipped") ?? "")"
                lblTrackNo4.text = "Tracking number: \(dicTrackOrder.value(forKey: "tracking_number") ?? "")"
                btnTrackOrder4.isUserInteractionEnabled = true
            }
            else if i == 4 {
                lblTrackOrder5.text = "Order Shipped by \(dicTrackOrder.value(forKey: "tracking_provider") ?? "")"
                lblTrackOrderDate5.text = "\(dicTrackOrder.value(forKey: "date_shipped") ?? "")"
                lblTrackNo5.text = "Tracking number: \(dicTrackOrder.value(forKey: "tracking_number") ?? "")"
                btnTrackOrder5.isUserInteractionEnabled = true
            }
        }
        
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
    //MARK:- UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTrackOrder1(_ sender: Any) {
        var dicTrackOrder = NSDictionary()
        dicTrackOrder = arrTrackOrder[0] as! NSDictionary
        
        let vc = WebViewController(nibName: "WebViewController", bundle: nil)
        vc.strUrl = "\(dicTrackOrder.value(forKey: "tracking_link") ?? "")"
        vc.isFromPayment = false
        vc.strHeading = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTrackOrder2(_ sender: Any) {
        var dicTrackOrder = NSDictionary()
        dicTrackOrder = arrTrackOrder[1] as! NSDictionary
        
        let vc = WebViewController(nibName: "WebViewController", bundle: nil)
        vc.strUrl = "\(dicTrackOrder.value(forKey: "tracking_link") ?? "")"
        vc.isFromPayment = false
        vc.strHeading = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTrackOrder3(_ sender: Any) {
        var dicTrackOrder = NSDictionary()
        dicTrackOrder = arrTrackOrder[2] as! NSDictionary
        
        let vc = WebViewController(nibName: "WebViewController", bundle: nil)
        vc.strUrl = "\(dicTrackOrder.value(forKey: "tracking_link") ?? "")"
        vc.isFromPayment = false
        vc.strHeading = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTrackOrder4(_ sender: Any) {
        var dicTrackOrder = NSDictionary()
        dicTrackOrder = arrTrackOrder[3] as! NSDictionary
        
        let vc = WebViewController(nibName: "WebViewController", bundle: nil)
        vc.strUrl = "\(dicTrackOrder.value(forKey: "tracking_link") ?? "")"
        vc.isFromPayment = false
        vc.strHeading = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTrackOrder5(_ sender: Any) {
        var dicTrackOrder = NSDictionary()
        dicTrackOrder = arrTrackOrder[4] as! NSDictionary
        
        let vc = WebViewController(nibName: "WebViewController", bundle: nil)
        vc.strUrl = "\(dicTrackOrder.value(forKey: "tracking_link") ?? "")"
        vc.isFromPayment = false
        vc.strHeading = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:-
    // MARK:- API Calling
    
    func getTrackOrderAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL("\(SHIPMENT)/\(strOrderId)/\(SHIPMENT_TRACKINGS)")!, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        self.arrTrackOrder = arrtemp[0] as! NSArray
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
}
