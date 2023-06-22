//
//  OfferViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import GoogleMobileAds

class OfferViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GADBannerViewDelegate {

    //MARK: -
    //MARK:- Outlets
    
    @IBOutlet weak var cvOffer: UICollectionView!
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintcvOfferHeight: NSLayoutConstraint!

    @IBOutlet weak var BtnViewAll: UIButton!
    
    @IBOutlet weak var lblCartCount: UILabel!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblSpecialOffer: UILabel!
    
    @IBOutlet weak var vwBanner: UIView!
    
    @IBOutlet weak var ImgOffer1: UIImageView!
    
    var timeRemaining = NSTimeIntervalSince1970
    var secondsLeft = 0
    let df = DateFormatter()
    var strDate = String()
    var arrProducts = NSMutableArray()
    var arrOrderProducts = NSMutableArray()
    var count = Int()
//    var days = 0
    var hours = 0
    var minutes = 0
    var seconds = 0
    var timer = Timer()
    
    var bannerView: GADBannerView!
    
    //MARK: -
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupObject()
    }
    
    //MARK: -
    //MARK: - SetupObject Method
    
    func SetupObject() {
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        getOffersAPI(pageNo: 1)
        
        if IPAD {
             self.lblCartCount.layer.cornerRadius = 20 / 2
        }else {
            self.lblCartCount.layer.cornerRadius = self.lblCartCount.layer.frame.height / 2
        }
        lblCartCount.text = TPreferences.readString(CART_ITEM_COUNT)
        self.BtnViewAll.setTitle(LanguageLocal.myLocalizedString(key: "View_All"), for: .normal)
        self.lblHeaderTitle.text = LanguageLocal.myLocalizedString(key: "Offer")
        self.lblSpecialOffer.text = LanguageLocal.myLocalizedString(key: "Special_Offer")
        
        strDate = "\(Date.tomorrow)"
        print(strDate)
        count = 0
          
        getProductOrderAPI()
        
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
    //MARK: -UICollectionView Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if IPAD {
            self.constraintcvOfferHeight.constant = (280 * 2) + 24
        }else {
            self.constraintcvOfferHeight.constant = (220 * 2) + 16
        }
        if arrProducts.count > 4 {
            return 4
        }
        else {
            return arrProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cvOffer.register(UINib(nibName: "OfferCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "offerCell")
        let cell = cvOffer.dequeueReusableCell(withReuseIdentifier: "offerCell", for: indexPath) as! OfferCollectionViewCell
        
        let dicProduct:NSDictionary = arrProducts[indexPath.item] as! NSDictionary
        
        cell.lblProductName.text = "\(dicProduct.value(forKey: "name") ?? "")"
        cell.lblOffer.text = "\(PRICE_SIGN)\(dicProduct.value(forKey: "price") ?? "")"
        
        let arrImages:NSArray = dicProduct.value(forKey: "gallery") as! NSArray
        if arrImages.count > 0 {
            THelper.setImage(img: cell.imgProduct, url: URL(string: arrImages[0] as! String)!, placeholderImage: "")
        }
        else {
            cell.imgProduct.image = UIImage(named: "")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if IPAD {
            return CGSize(width: (cvOffer.frame.width / 2) - 24, height: 280)
        }else {
        return CGSize(width: (cvOffer.frame.width / 2) - 16, height: 220)
        }
    }
    
    //MARK: -
    //MARK:- Other Method
    
    @objc func changeImage() {
        if arrOrderProducts.count > 0 {
            if arrOrderProducts.count == count {
                count = 0
            }
            THelper.setImage(img: ImgOffer1, url: URL(string: arrOrderProducts[count] as! String)!, placeholderImage: "")
            //        ImgOffer1.image = UIImage(named: arrImages[count])
            count = count + 1
        }
        else {
            
        }
    }
    
    //MARK: -
    //MARK:- UIButton Clicked Events Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearch_Clicked(_ sender: Any) {
        let vc = SearchViewController(nibName: "SearchViewController", bundle: nil)
        vc.isFormPayCard = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnViewAll_Clicked(_ sender: Any) {
        let vc = ViewAllOffersViewController(nibName: "ViewAllOffersViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCart_Clicked(_ sender: Any) {
        let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
        vc.isFormPayCard = true
        vc.flagHeader = false
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:-
    //MARK:- API Calling
    
    func getOffersAPI(pageNo: Int) {
        THelper.ShowProgress(vc: self)
        
        let param = ["page":pageNo
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_GET_OFFER)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        let arrTempProduct:NSArray = arrtemp[0] as! NSArray
                        var dicProduct = NSDictionary()
                        
                        for i in 0..<arrTempProduct.count {
                            dicProduct = arrTempProduct[i] as! NSDictionary
                            self.arrProducts.add(dicProduct)
                        }
                        
                        self.cvOffer.reloadData()
                    }
                    else {
                        print(data)
                        let dicError:NSDictionary = data as! NSDictionary
                        let str:String = dicError.value(forKey: "message") as! String
                        THelper.toast(str.html2String, vc: self)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                break
                
            case .failure(_):
                THelper.hideProgress(vc: self)
                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                self.navigationController?.popViewController(animated: true)
                break
            }
        }
    }
    
    func getProductOrderAPI() {
        //        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(PRODUCT_ORDER)!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                //                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        
                        let arrTempProduct:NSArray = arrtemp[0] as! NSArray
                        var dicProduct = NSDictionary()
                        
                        for i in 0..<arrTempProduct.count {
                            dicProduct = arrTempProduct[i] as! NSDictionary
                            
                            let arrImages:NSArray = dicProduct.value(forKey: "images") as! NSArray
                            if arrImages.count > 0 {
                                let dicTemp:NSDictionary = arrImages[0] as! NSDictionary
                                self.arrOrderProducts.add(dicTemp.value(forKey: "src") ?? "")
                            }
                        }
                        self.cvOffer.reloadData()
                        
                        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
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
                //                THelper.hideProgress(vc: self)
                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                break
            }
        }
    }
}
