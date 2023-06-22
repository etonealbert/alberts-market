//
//  SubCategoriesViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import GoogleMobileAds

class SubCategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GADBannerViewDelegate {
    
    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var constraintCvNewArrivalHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintCvFeaturesProductHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintCvCategoryHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cvCategory: UICollectionView!
    @IBOutlet weak var cvPopularProduct: UICollectionView!

    @IBOutlet weak var cvNewArrivle: UICollectionView!
    
    @IBOutlet weak var ImgOffer1: UIImageView!
    @IBOutlet weak var ImgOffer2: UIImageView!
    
    @IBOutlet weak var constraintHeightSafeArea: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
        
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwBanner: UIView!
    @IBOutlet weak var vwNewArrival: UIView!
    @IBOutlet weak var vwFeaturedProducts: UIView!
    
    @IBOutlet weak var lblCategoryHeader: UILabel!
    @IBOutlet weak var lblNewArrivle: UILabel!
    @IBOutlet weak var lblFeturedProduct: UILabel!
    
    @IBOutlet weak var btnNewArrivle: UIButton!
    @IBOutlet weak var btnViewAll: UIButton!
    
    //MARK: -
    //MARK: - Variables
    
    let arrColor = [UIColor.red, UIColor.blue,UIColor.purple, UIColor.orange]

    let arrCategories = ["Cloths","Accesories","Footwear","Lugage"]
    let arrCategoryIcon = ["icoMen","icoCap","icoShoes","icoBags"]
    
    var StrHeader = String()
    var strCategoryId = String()
    var count = Int()
    var arrProducts = NSArray()
    var arrRecentSearch = NSMutableArray()
    var arrOrderProducts = NSMutableArray()
    var arrImages = NSArray()
    let arrFeaturedProduct = NSMutableArray()
    var arrCategory = NSArray()
    var subCategory = Bool()
    
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
        self.lblFeturedProduct.text = LanguageLocal.myLocalizedString(key: "Featured_Product")
         self.lblNewArrivle.text = LanguageLocal.myLocalizedString(key: "New_Arrivle")
        self.btnNewArrivle.setTitle(LanguageLocal.myLocalizedString(key: "View_All"), for: .normal)
        self.btnViewAll.setTitle(LanguageLocal.myLocalizedString(key: "View_All"), for: .normal)
        
        self.lblCategoryHeader.text = StrHeader
        
        self.vwHeader.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
        self.vwHeader.layer.shadowOpacity = 2.0
        self.vwHeader.layer.shadowRadius = 2.0
        self.vwHeader.layer.shadowOffset = CGSize(width: 0.0 , height: 2.0)
        getProductCategoriesAPI()
        getFeaturedProductAPI()
//        getProductOrderAPI()
        getArray()
        
        count = 0
                
        if subCategory {
            getSubCategoriesAPI()
        }
        else {
            constraintCvCategoryHeight.constant = 0
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
    
    func SetUpValue() {
        if arrFeaturedProduct.count > 0 {
            if IPAD {
                self.constraintCvFeaturesProductHeight.constant = 400
            }
            else {
                self.constraintCvFeaturesProductHeight.constant = 260
            }
            self.vwFeaturedProducts.isHidden = false
            
            DispatchQueue.main.async {
                self.cvPopularProduct.reloadData()
            }
        }
        else {
            self.constraintCvFeaturesProductHeight.constant = 0
            self.vwFeaturedProducts.isHidden = true
        }
    }
    
    //MARK: -
    //MARK: - Other Methods
    
    @objc func changeImage() {
        if arrOrderProducts.count == count {
            count = 0
        }
        THelper.setImage(img: ImgOffer1, url: URL(string: arrOrderProducts[count] as! String)!, placeholderImage: "")
//        ImgOffer1.image = UIImage(named: arrImages[count])
        count = count + 1
    }
    
    func getArray() {
        let arrtemp:NSArray = THelper.getArray()
        //        TPreferences.removePreference(RECENT_SEARCH)
        arrRecentSearch.removeAllObjects()
        if arrtemp.count > 0 {
            for i in 0..<arrtemp.count {
                arrRecentSearch.add(arrtemp[i])
            }
        }
        else {
            arrRecentSearch.removeAllObjects()
        }
    }

    //MARK: -
    //MARK:- Collectionview Delegate Methods.
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cvCategory {
            if arrCategory.count == 0 {
                self.constraintCvCategoryHeight.constant = 0
            }else {
                if IPAD {
                    self.constraintCvCategoryHeight.constant = 110
                }else {
                    self.constraintCvCategoryHeight.constant = 90
                }
            }
            return arrCategory.count
        }
        else if collectionView == self.cvNewArrivle {
            if arrProducts.count > 5 {
                return 5
            }
            else {
                return arrProducts.count
            }
        }else {
            if arrFeaturedProduct.count > 5 {
                return 5
            }
            else {
                return arrFeaturedProduct.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cvCategory {
            self.cvCategory.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
            let cell = cvCategory.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
            
            var dicCategory = NSDictionary()
            dicCategory = arrCategory[indexPath.item] as! NSDictionary
            
            if "\(dicCategory.value(forKey: "image") ?? "")" != "" {
                THelper.setImage(img: cell.imgCategories, url: URL(string: "\(dicCategory.value(forKey: "image") ?? "")")!, placeholderImage: "")
            }
            else {
                cell.imgCategories.image = UIImage(named: "")
            }
            cell.imgCategories = THelper.setTintColor(cell.imgCategories, tintColor: .white)
            
            cell.lblCategories.text = "\(dicCategory.value(forKey: "name") ?? "")".html2String
            
            cell.vwCategory.layer.cornerRadius = 10
            cell.vwCategory.layer.masksToBounds = true
//            cell.vwCategory.layer.borderWidth = 1
            
            let index: Int = indexPath.item
            cell.lblCategories.textColor = arrColor[index % arrColor.count]
//            cell.vwCategory.layer.borderColor = arrColor[index % arrColor.count].cgColor
            cell.vwIcon.backgroundColor = arrColor[index % arrColor.count]
            
            return cell
        }
        else if collectionView == self.cvNewArrivle {
            self.cvNewArrivle.register(UINib(nibName: "RecentSearchViewCell", bundle: nil), forCellWithReuseIdentifier: "RecentSearchViewCell")
            let cell = cvNewArrivle.dequeueReusableCell(withReuseIdentifier: "RecentSearchViewCell", for: indexPath) as! RecentSearchViewCell
            
            var dicProducts = NSDictionary()
            dicProducts = arrProducts[indexPath.item] as! NSDictionary
            
            cell.lblProductName.text = dicProducts.value(forKey: "name") as? String
            
            if "\(dicProducts.value(forKey: SALES_PRICE) ?? "")" == "" {
                if "\(dicProducts.value(forKey: PRICE) ?? "")" == "" {
                    cell.lblDiscountPrice.text = ""
                }else {
                    cell.lblDiscountPrice.text = "\(PRICE_SIGN)\(dicProducts.value(forKey: PRICE) ?? "")"
                }
            }else {
                cell.lblDiscountPrice.text = "\(PRICE_SIGN)\(dicProducts.value(forKey: SALES_PRICE) ?? "")"
            }
            
            if "\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")" == "" {
                if "\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")" == "" {
                    cell.lblActualPrice.text = ""
                }else {
                    cell.lblActualPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
                }
                cell.lblActualPrice.text = ""
            }else {
                cell.lblActualPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
            }
            
            if TValidation.isNull(dicProducts.value(forKey: FULL)) || "\(dicProducts.value(forKey: FULL) ?? "")" == "" {
                cell.imgProduct.image = UIImage(named: "")
            }
            else {
               THelper.setImage(img: cell.imgProduct, url: URL(string: "\(dicProducts.value(forKey: FULL) ?? "")")!, placeholderImage: "")
            }
            
            THelper.setShadow(view: cell)
            return cell
        }
        else {
            self.cvPopularProduct.register(UINib(nibName: "RecentSearchViewCell", bundle: nil), forCellWithReuseIdentifier: "RecentSearchViewCell")
            let cell = cvPopularProduct.dequeueReusableCell(withReuseIdentifier: "RecentSearchViewCell", for: indexPath) as! RecentSearchViewCell
            
            var dicProducts = NSDictionary()
            dicProducts = arrFeaturedProduct[indexPath.item] as! NSDictionary
            
            cell.lblProductName.text = dicProducts.value(forKey: "name") as? String
            
            if "\(dicProducts.value(forKey: SALES_PRICE) ?? "")" == "" {
                if "\(dicProducts.value(forKey: PRICE) ?? "")" == "" {
                    cell.lblDiscountPrice.text = ""
                }else {
                    cell.lblDiscountPrice.text = "\(PRICE_SIGN)\(dicProducts.value(forKey: PRICE) ?? "")"
                }
            }else {
                cell.lblDiscountPrice.text = "\(PRICE_SIGN)\(dicProducts.value(forKey: SALES_PRICE) ?? "")"
            }
            
            if "\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")" == "" {
                if "\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")" == "" {
                    cell.lblActualPrice.text = ""
                }else {
                    cell.lblActualPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
                }
                cell.lblActualPrice.text = ""
            }else {
                cell.lblActualPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
            }
            
            if TValidation.isNull(dicProducts.value(forKey: FULL)) || "\(dicProducts.value(forKey: FULL) ?? "")" == "" {
                cell.imgProduct.image = UIImage(named: "")
            }
            else {
               THelper.setImage(img: cell.imgProduct, url: URL(string: "\(dicProducts.value(forKey: FULL) ?? "")")!, placeholderImage: "")
            }
            
            THelper.setShadow(view: cell)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dicProducts = NSDictionary()
        var contains = Bool()
        dicProducts = arrProducts[indexPath.item] as! NSDictionary
        
        if collectionView == cvCategory {
            var dicCategory = NSDictionary()
            dicCategory = arrCategory[indexPath.item] as! NSDictionary
            let arrSubCategory: NSArray = dicCategory.value(forKey: "subcategory") as! NSArray
            
            let vc = SubCategoriesViewController(nibName: "SubCategoriesViewController", bundle: nil)
            vc.StrHeader = "\(dicCategory.value(forKey: "name") ?? "")"
            vc.strCategoryId = "\(dicCategory.value(forKey: CAT_ID) ?? "")"
            if arrSubCategory.count > 0 {
                vc.subCategory = true
            }
            else {
                vc.subCategory = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if arrRecentSearch.count > 0 {
            for i in 0..<arrRecentSearch.count {
                let dicItems:NSDictionary = arrRecentSearch[i] as! NSDictionary
                if "\(dicItems.value(forKey: PRO_ID) ?? "")" == "\(dicProducts.value(forKey: PRO_ID) ?? "")" {
                    contains = true
                    break
                }
                else {
                    contains = false
                }
            }
            
            if contains == false {
                arrRecentSearch.insert(dicProducts, at: 0)
                TPreferences.removePreference(RECENT_SEARCH)
                TPreferences.writeObject(RECENT_SEARCH, value: arrRecentSearch)
                print(TPreferences.readObject(RECENT_SEARCH) ?? "")
                cvNewArrivle.reloadData()
            }
            
            let vc = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
            vc.strProductID = "\(dicProducts.value(forKey: PRO_ID) ?? "")"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            arrRecentSearch.add(dicProducts)
            TPreferences.writeObject(RECENT_SEARCH, value: arrRecentSearch)
            print(TPreferences.readObject(RECENT_SEARCH) ?? "")
            cvNewArrivle.reloadData()
            
            let vc = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
            vc.strProductID = "\(dicProducts.value(forKey: PRO_ID) ?? "")"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if IPAD {
             if collectionView == cvCategory {
                let label = UILabel(frame: CGRect.zero)
                var dicCategory = NSDictionary()
                dicCategory = arrCategory[indexPath.item] as! NSDictionary
                label.text = "\(dicCategory.value(forKey: "name") ?? "")".html2String
                label.sizeToFit()
                return CGSize(width: label.frame.width + 80, height: 110)
                            
            }else if collectionView == cvNewArrivle {
                return CGSize(width:self.cvNewArrivle.frame.width - 420 , height: 350)
            }else if collectionView == cvPopularProduct {
                return CGSize(width:self.cvPopularProduct.frame.width - 420 , height: 350)
            }
            else {
                return CGSize(width:0 , height: 0)
            }
        }else {
            if collectionView == cvCategory {
                let label = UILabel(frame: CGRect.zero)
                var dicCategory = NSDictionary()
                dicCategory = arrCategory[indexPath.item] as! NSDictionary
                label.text = "\(dicCategory.value(forKey: "name") ?? "")"
                label.sizeToFit()
                return CGSize(width: label.frame.width + 40, height: 80)
                            
            }else if collectionView == cvNewArrivle {
                return CGSize(width:self.cvNewArrivle.frame.width - 180 , height: 250)
            }else if collectionView == cvPopularProduct {
                return CGSize(width:self.cvPopularProduct.frame.width - 180 , height: 250)
            }
            else {
                return CGSize(width:0 , height: 0)
            }
        }
    }
    
    //MARK:-
    //MARK:- UIButton Clicked Events Method
    
    @IBAction func btnViewAllNewArrivle_Clicked(_ sender: Any) {
        let vc = NewestProductListViewController(nibName: "NewestProductListViewController", bundle: nil)
        vc.strHeading = NEW_ARRIVAL
        vc.strCategoryId = self.strCategoryId
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnViewAllFeturedProduct_Clicked(_ sender: Any) {
        let vc = NewestProductListViewController(nibName: "NewestProductListViewController", bundle: nil)
        vc.strHeading = FEATURED_PRODUCTS
        vc.strCategoryId = self.strCategoryId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack_Clicked(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("Reload"), object: self, userInfo: ["flag":"1"])
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearch_clicked(_ sender: Any) {
         let vc = SearchViewController(nibName: "SearchViewController", bundle: nil)
        vc.isFormPayCard = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:-
    //MARK:- API Calling
        
    func getProductCategoriesAPI() {
        THelper.ShowProgress(vc: self)
        
        let param = ["category":[strCategoryId],
                     "page":1
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_PRODUCTS)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        self.arrProducts = arrtemp[0] as! NSArray
                        if self.arrProducts.count > 0 {
                            if IPAD {
                                self.constraintCvNewArrivalHeight.constant = 400
                            }
                            else {
                                self.constraintCvNewArrivalHeight.constant = 260
                            }
                            self.vwNewArrival.isHidden = false
                            
                            self.cvNewArrivle.reloadData()
                        }
                        else {
                            self.constraintCvNewArrivalHeight.constant = 0
                            self.vwNewArrival.isHidden = true
                        }
                    }
                    else {
                        print(data)
                        self.constraintCvNewArrivalHeight.constant = 0
                        self.vwNewArrival.isHidden = true

                        let dicError:NSDictionary = data as! NSDictionary
                        let str:String = dicError.value(forKey: "message") as! String
                        THelper.toast(str.html2String, vc: self)
                    }
                }
                break
                
            case .failure(_):
                self.constraintCvNewArrivalHeight.constant = 0
                self.vwNewArrival.isHidden = true
                
                THelper.hideProgress(vc: self)
                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                break
            }
        }
    }
    
    func getFeaturedProductAPI() {
            THelper.ShowProgress(vc: self)
            
        let param = ["category":strCategoryId,
                     "page":1
            ] as [String : Any]
        print(param)
        
            let sessionManager = SessionManager.default
            sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
            
            sessionManager.request(TPreferences.getCommonURL(NEW_FEATURED_PRODUCT)!, method: .post, parameters:  param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    THelper.hideProgress(vc: self)
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            print(data)
                            let arrTemp: NSArray = data as! NSArray
                            for i in 0..<arrTemp.count {
                                let dicTemp: NSDictionary = arrTemp[i] as! NSDictionary
                                self.arrFeaturedProduct.add(dicTemp)
                            }
                            
                            self.SetUpValue()
                            self.cvPopularProduct.reloadData()
                        }
                        else {
                            print(data)
                            self.constraintCvFeaturesProductHeight.constant = 0
                            self.vwFeaturedProducts.isHidden = true
                            
                            let dicError:NSDictionary = data as! NSDictionary
                            let str:String = dicError.value(forKey: "message") as! String
//                            THelper.toast(str.html2String, vc: self)
                            print("Error: \(str)")
                        }
                    }
                    break
                    
                case .failure(_):
                    self.constraintCvFeaturesProductHeight.constant = 0
                    self.vwFeaturedProducts.isHidden = true
                    
                    THelper.hideProgress(vc: self)
//                    THelper.toast(ERROR_MSG, vc: self)
                    print(response.result.error?.localizedDescription ?? "Something went wrong")
    //                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
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
                        
                        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                        
                        self.cvNewArrivle.reloadData()
                        self.changeImage()
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
    
    func getSubCategoriesAPI() {
        THelper.ShowProgress(vc: self)
        
        let param = ["cat_id":strCategoryId
           ] as [String : Any]
       print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_SUB_CATEGORIES)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        self.arrCategory = arrtemp[0] as! NSArray
                        
                        self.constraintCvCategoryHeight.constant = 90
                        self.cvCategory.reloadData()
                    }
                    else {
                        print(data)
                        self.constraintCvCategoryHeight.constant = 0
                        let dicError:NSDictionary = data as! NSDictionary
                        let str:String = dicError.value(forKey: "message") as! String
                        THelper.toast(str.html2String, vc: self)
                    }
                }
                break
                
            case .failure(_):
                self.constraintCvCategoryHeight.constant = 0
                THelper.hideProgress(vc: self)
                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                break
            }
        }
    }
}
