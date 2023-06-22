//
//  PaymentsViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import GoogleMobileAds

class PaymentsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {

    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    @IBOutlet weak var constraintTblPaymentHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblPayment: UITableView!
    
    @IBOutlet weak var vwPaymentDetail: UIView!
    
    @IBOutlet weak var cvCards: UICollectionView!
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwBanner: UIView!
    
    @IBOutlet weak var btnAddCard: UIButton!
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblPaymentDetail: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    
    @IBOutlet weak var lblOfferValue: UILabel!
    @IBOutlet weak var lblShippingCharges: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblShippingValue: UILabel!
    @IBOutlet weak var lblQuickPay: UILabel!
    //MARK: -
    //MARK: - Variables
    
    let arrPaymentTypes = ["PayPal", "Cash_On_Delivery"]
    let arrPaymentTypesIcons = ["icoPublic", "icoCash"]
    var StrOrderId = String()
    var dicPaymentDetail = NSDictionary()
    var strTotalPrice = String()
    
    var bannerView: GADBannerView!
    
    //MARK: -
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpObject()
    }

    //MARK: -
    //MARK: - SetUpObject Method
    
    func SetUpObject(){
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        self.lblHeader.text = LanguageLocal.myLocalizedString(key: "Payments")
        self.lblPaymentDetail.text = LanguageLocal.myLocalizedString(key: "Payment_Detail")
        self.lblOffer.text = LanguageLocal.myLocalizedString(key: "Offers")
        self.lblTotalAmount.text = LanguageLocal.myLocalizedString(key: "Total_Amount")
        self.lblShippingCharges.text = LanguageLocal.myLocalizedString(key: "Shipping_Charges")
        self.lblQuickPay.text = LanguageLocal.myLocalizedString(key: "Quick_Pay")
        self.btnAddCard.setTitle(LanguageLocal.myLocalizedString(key: "Add_Card"), for: .normal)
//        PaymentAPI()
        SetValue()
        
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
    
    func SetValue() {
        self.lblOfferValue.text = "Offer Not Available"
        self.lblShippingValue.text = "Free"
        self.lblTotalPrice.text = "\(strTotalPrice)"
    }
    
    //MARK: -
    //MARK: - UITableView DataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPaymentTypes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        constraintTblPaymentHeight.constant = CGFloat(70 * arrPaymentTypes.count)
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tblPayment.register(UINib(nibName: "PaymentsTableCell", bundle: nil), forCellReuseIdentifier: "PaymentCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentsTableCell
        
        cell.btnPayment.setImage(UIImage(named: arrPaymentTypesIcons[indexPath.row]), for: .normal)
        cell.btnPayment = THelper.setButtonTintColor(cell.btnPayment, imageName: arrPaymentTypesIcons[indexPath.row], state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Secondary_Color1"))
        cell.lblPayment.text = LanguageLocal.myLocalizedString(key: arrPaymentTypes[indexPath.row])
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            processPaymentAPI(paymentMethod: "paypal")
        }
        else if indexPath.row == 1 {
            processPaymentAPI(paymentMethod: "cod")
        }
    }
    
    //MARK: -
    //MARK: - UICollectionView Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cvCards.register(UINib(nibName: "CardsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CardCell")
        let cell = cvCards.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardsCollectionCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cvCards.frame.width - 24, height: cvCards.frame.height - 8)
    }
    
    //MARK: -
    //MARK: - UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnAddCard_Clicked(_ sender: Any) {
        let vc = AddNewCardViewController(nibName: "AddNewCardViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK:-
    // MARK:- API Calling
    
    func processPaymentAPI(paymentMethod:String) {
        THelper.ShowProgress(vc: self)
        
        let param = ["order_id":StrOrderId,
                     "payment_method":paymentMethod
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(PAYMENT)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                        print(data)
                        let dicData:NSDictionary = data as! NSDictionary
                        THelper.toast("\(dicData.value(forKey: "message") ?? "Payment Successful.")", vc: self)
                        
                        let dicTemp:NSDictionary = dicData.value(forKey: "data") as! NSDictionary
                        
                        let vc = WebViewController(nibName: "WebViewController", bundle: nil)
                        vc.strUrl = "\(dicTemp.value(forKey: "redirect") ?? "")"
                        vc.isFromPayment = true
                        vc.strHeading = "Payment"
                        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func PaymentAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        print("\(GET_CART_ITEM)/\(TPreferences.readString(USER_ID) ?? "")")
        
        sessionManager.request(TPreferences.getCommonURL("\(TOTAL_AMOUNT)")!, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        if TValidation.isDictionary(data) {
                            self.dicPaymentDetail = data as! NSDictionary
                            print(self.dicPaymentDetail)
                            self.SetValue()
                        }
                        else {
                            THelper.toast("No data found", vc: self)
                        }
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
