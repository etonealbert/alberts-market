//
//  MyOrderViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import GoogleMobileAds

class MyOrderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GADBannerViewDelegate {
    
    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var constraintHeightSafeArea: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cvOrder: UICollectionView!
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwBanner: UIView!
    
    @IBOutlet weak var lblNoOrderFound: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    
    //MARK: -
    //MARK: - Variables
    
    var arrOrders = NSMutableArray()
    var pageCount = Int()
    var isEnd = Bool()
    var arrProduct = NSArray()
    
    var bannerView: GADBannerView!
    
    //MARK: -
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpObject()
        
    }

    //MARK:-
    //MARK:- SetUpObject Method
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightSafeArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        self.isEnd = false
        pageCount = 1
        getProductAPI()
        getOrdersAPI(page: "\(pageCount)")
        
        self.lblHeading.text = LanguageLocal.myLocalizedString(key: "My_Orders")
        
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
    
    // MARK:-
    // MARK:- UIcollectionView Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOrders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var dicOrder = NSDictionary()
        var dicItem = NSDictionary()
        dicOrder = arrOrders[indexPath.item] as! NSDictionary
        
        let arrItems:NSArray = dicOrder.value(forKey: "line_items") as! NSArray
        if arrItems.count > 0 {
            dicItem = arrItems[0] as! NSDictionary
        }
        
        var strImage = String()
        for i in 0..<arrProduct.count {
            let dicProduct: NSDictionary = arrProduct[i] as! NSDictionary
            if "\(dicProduct.value(forKey: PRO_ID) ?? "")" == "\(dicItem.value(forKey: "product_id") ?? "")" {
                strImage = "\(dicProduct.value(forKey: FULL) ?? "")"
                break
            }
        }
        
        if "\(dicOrder.value(forKey: "status") ?? "")" == "completed" {
            cvOrder.register(UINib(nibName: "DelivereCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DellivereCell")
            let cell = cvOrder.dequeueReusableCell(withReuseIdentifier: "DellivereCell", for: indexPath) as! DelivereCollectionViewCell
            
            cell.lblProductName.text = "\(dicItem.value(forKey: "name") ?? "")"
            cell.lblNewPrice.text = "\(THelper.attributeText(price: "\(PRICE_SIGN)\(dicOrder.value(forKey: "total") ?? "")"))"
            //            cell.lblOldProductPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicItem.value(forKey: "") ?? "")")
            
            if strImage != "" {
                THelper.setImage(img: cell.imgProduct, url: URL(string: strImage)!, placeholderImage: "")
            }
            else {
                cell.imgProduct.image = UIImage(named: "")
            }
            
            return cell
        }
        else if "\(dicOrder.value(forKey: "status") ?? "")" == "processing" {
            cvOrder.register(UINib(nibName: "OrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OrderCell")
            let cell = cvOrder.dequeueReusableCell(withReuseIdentifier: "OrderCell", for: indexPath) as! OrderCollectionViewCell
            
            cell.lblProductName.text = "\(dicItem.value(forKey: "name") ?? "")"
            cell.lblNewPrice.text = "\(PRICE_SIGN)\(dicOrder.value(forKey: "total") ?? "")"
            cell.lblOrderStatus.text = "\(dicOrder.value(forKey: "status") ?? "")"
            cell.lblStatus.text = "Order \(dicOrder.value(forKey: "status") ?? "")"
//            cell.lblOldProductPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicItem.value(forKey: "") ?? "")")
            
            if strImage != "" {
                THelper.setImage(img: cell.imgProduct, url: URL(string: strImage)!, placeholderImage: "")
            }
            else {
                cell.imgProduct.image = UIImage(named: "")
            }
            
            return cell
        }
        else {
            cvOrder.register(UINib(nibName: "OrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OrderCell")
            let cell = cvOrder.dequeueReusableCell(withReuseIdentifier: "OrderCell", for: indexPath) as! OrderCollectionViewCell
            
            cell.lblProductName.text = "\(dicItem.value(forKey: "name") ?? "")"
            cell.lblNewPrice.text = "\(PRICE_SIGN)\(dicOrder.value(forKey: "total") ?? "")"
            cell.lblOrderStatus.text = "\(dicOrder.value(forKey: "status") ?? "")"
            cell.lblStatus.text = "Order \(dicOrder.value(forKey: "status") ?? "")"
            //            cell.lblOldProductPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicItem.value(forKey: "") ?? "")")
            
            if strImage != "" {
                THelper.setImage(img: cell.imgProduct, url: URL(string: strImage)!, placeholderImage: "")
            }
            else {
                cell.imgProduct.image = UIImage(named: "")
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item >= arrOrders.count - 1 {
            if isEnd == false {
                pageCount = pageCount + 1
                getOrdersAPI(page: "\(pageCount)")
            }
            else {
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dicOrder = NSDictionary()
        dicOrder = arrOrders[indexPath.item] as! NSDictionary
        
        let vc = OrderDetailViewController(nibName: "OrderDetailViewController", bundle: nil)
        vc.strOrderId = "\(dicOrder.value(forKey: "id") ?? "")"
        vc.arrProduct = arrProduct
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if IPAD {
            return CGSize(width: UIScreen.main.bounds.width - 38, height: 250)

        }else {
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 170)
        }
    }
    
    // MARK:-
    // MARK:- UIButton Action Method
   
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:-
    // MARK:- API Calling
    
    func getOrdersAPI(page: String) {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        sessionManager.request(TPreferences.getCommonURL("\(ORDER)/\(ORDER_BY_CUSTOMER)\(TPreferences.readString(USER_ID) ?? "")&page=\(page)")!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        var arrTemp = NSArray()
                        arrTemp = data as! NSArray
                        if arrTemp.count < 10 {
                            self.isEnd = true
                        }
                        else {
                            self.isEnd = false
                        }
                        
                        for i in 0..<arrTemp.count {
                            let dicOrder: NSDictionary = arrTemp[i] as! NSDictionary
                            self.arrOrders.add(dicOrder)
                        }
                        
                        if self.arrOrders.count > 0 {
                            self.lblNoOrderFound.isHidden = true
                            self.cvOrder.isHidden = false
                        }
                        else {
                            self.lblNoOrderFound.isHidden = false
                            self.cvOrder.isHidden = true
                        }
                        TPreferences.writeString(MY_ORDER_COUNT, value: "\(self.arrOrders.count)")
                        self.cvOrder.reloadData()
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
    
    func getProductAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_PRODUCTS)!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        self.arrProduct = data as! NSArray
                        self.cvOrder.reloadData()
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
                break
            }
        }
    }
}
