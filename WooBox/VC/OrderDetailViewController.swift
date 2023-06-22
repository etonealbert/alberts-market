//
//  OrderDetailViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import Cosmos
import GoogleMobileAds

class OrderDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GADBannerViewDelegate {
    
    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var constraintHeightSafeArea: NSLayoutConstraint!
    @IBOutlet weak var constraintCvOrderDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwBanner: UIView!
    @IBOutlet weak var vwRating: CosmosView!
    
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblShippingCharge: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var lblPaymentDetail: UILabel!
    @IBOutlet weak var lblItemPrices: UILabel!
    @IBOutlet weak var lblOffers: UILabel!
    @IBOutlet weak var lblTotalAmounts: UILabel!
    @IBOutlet weak var lblShippingCharges: UILabel!
    @IBOutlet weak var lblVwStarPaymentDetail: UILabel!
    @IBOutlet weak var lblTitleOrderDate: UILabel!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblShoppingDetail: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var lblPaymentMethodValue: UILabel!
    
    @IBOutlet weak var cvOrderDetails: UICollectionView!
    
    //MARK: -
    //MARK: - Variables
    
    var dicOrderDetail = NSDictionary()
    var strOrderId = String()
    var arrItems = NSArray()
    var arrProduct = NSArray()
    
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
        getOrderDetailAPI()
        
        self.lblPaymentDetail.text = LanguageLocal.myLocalizedString(key: "Payment_Detail")
//        self.lblItemPrices.text = LanguageLocal.myLocalizedString(key: "Item_Price")
        self.lblOffers.text = LanguageLocal.myLocalizedString(key: "Offers")
        self.lblShippingCharges.text = LanguageLocal.myLocalizedString(key: "Shipping_Charges")
        self.lblTotalAmounts.text = LanguageLocal.myLocalizedString(key: "Total_Amount")
        self.lblShoppingDetail.text = LanguageLocal.myLocalizedString(key: "Shopping_Detail")
        self.lblOrderID.text = LanguageLocal.myLocalizedString(key: "Order_Id")
        self.lblTitleOrderDate.text = LanguageLocal.myLocalizedString(key: "Order_date")
        self.lblVwStarPaymentDetail.text = LanguageLocal.myLocalizedString(key: "Payment_Detail")
        lblPaymentMethod.text = LanguageLocal.myLocalizedString(key: "Payment_Method")
        
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
        arrItems = dicOrderDetail.value(forKey: "line_items") as! NSArray
        cvOrderDetails.reloadData()
        
        let strOrderId:String = dicOrderDetail.value(forKey: "order_key") as! String
        let arrOrderId:NSArray = strOrderId.components(separatedBy: "_") as NSArray
        
        lblOrderId.text = "\(arrOrderId[2])"
        lblHeading.text = "\(arrOrderId[2])"
        lblItemPrice.text = ""
        lblOffer.text = "No Offer Available"
        lblShippingCharge.text = "Free"
        lblTotalAmount.text = "\(PRICE_SIGN)\(dicOrderDetail.value(forKey: "total") ?? "")"
        lblPaymentMethodValue.text = "\(dicOrderDetail.value(forKey: "payment_method_title") ?? "")"
        lblOrderDate.text = "\(dicOrderDetail.value(forKey: "date_created") ?? "")"
        
        lblOrderStatus.text = "Order \(dicOrderDetail.value(forKey: "status") ?? "")"
        lblDate.text = THelper.convertLocaldate("\(dicOrderDetail.value(forKey: "date_created") ?? "")")
        lblStatus.text = "Order \(dicOrderDetail.value(forKey: "status") ?? "")"
        
        vwRating.settings.fillMode = .half
        vwRating.didFinishTouchingCosmos = { rating in
            self.lblRating.text = "\(rating)"
        }
    }

    //MARK: -
    //MARK:- Collectionview Delegate Methods.
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.cvOrderDetails.register(UINib(nibName: "OrderDetailsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "OrderDetailCell")
        let cell = cvOrderDetails.dequeueReusableCell(withReuseIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailsCollectionCell
        
        let dicItems:NSDictionary = arrItems[indexPath.item] as! NSDictionary
        
        var strImage = String()
        for i in 0..<arrProduct.count {
            let dicProduct: NSDictionary = arrProduct[i] as! NSDictionary
            if "\(dicProduct.value(forKey: PRO_ID) ?? "")" == "\(dicItems.value(forKey: "product_id") ?? "")" {
                strImage = "\(dicProduct.value(forKey: FULL) ?? "")"
                break
            }
        }
        
        cell.lblItemName.text = "\(dicItems.value(forKey: "name") ?? "")"
        cell.lblTotalItem.text = "\(dicItems.value(forKey: "quantity") ?? "")"
        cell.lblPrice.text = "\(PRICE_SIGN)\(dicItems.value(forKey: "total") ?? "")"
        cell.lblActualPrice.text = ""
        
        if strImage != "" {
            THelper.setImage(img: cell.imgItem, url: URL(string: strImage)!, placeholderImage: "")
        }
        else {
            cell.imgItem.image = UIImage(named: "")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if IPAD {
            constraintCvOrderDetailsHeight.constant = CGFloat(arrItems.count * 250)
            return CGSize(width:cvOrderDetails.frame.width - 24 , height: 250)
        }else {
            constraintCvOrderDetailsHeight.constant = CGFloat(arrItems.count * 115)
            return CGSize(width:cvOrderDetails.frame.width - 24 , height: 115)
        }
    }
    
    //MARK: -
    //MARK:- UIButton Clicked Events Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTrackItem_Clicked(_ sender: Any) {
        if "\(dicOrderDetail.value(forKey: "status") ?? "")" == "compleated" {
            let vc = TrackItemViewController(nibName: "TrackItemViewController", bundle: nil)
            vc.strOrderId = self.strOrderId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
        }
    }
    
    // MARK:-
    // MARK:- API Calling
    
    func getOrderDetailAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL("\(ORDER)/\(strOrderId)\(ORDER_BY_CUSTOMER)\(TPreferences.readString(USER_ID) ?? "")")!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                        print(data)
                        self.dicOrderDetail = data as! NSDictionary
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
