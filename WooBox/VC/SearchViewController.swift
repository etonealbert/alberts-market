//
//  SearchViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import GoogleMobileAds

class SearchViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate, GADBannerViewDelegate {

    //MARK:-
    //MARK:- Outlets
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var cvSearch: UICollectionView!
        
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    @IBOutlet weak var vwBanner: UIView!
    
    @IBOutlet weak var imgSearch: UIImageView!
    
    var arrSearch = NSMutableArray()
    let arrLikePackage = NSMutableArray()
    var arrRecentSearch = NSMutableArray()
    var timer: Timer!
    var isFormPayCard = Bool()
    var page = Int()
    var totalPage = Int()
    
    var bannerView: GADBannerView!
    
    //MARK:-
    //MARK:- View Life Cycle
    
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
        cvSearch.isHidden = true
        imgSearch.isHidden = false
        self.lblNoDataFound.text = LanguageLocal.myLocalizedString(key: "Search_Product")
        
        let currentLan = TPreferences.readString(LANGUAGE)
        search.barTintColor = .primaryColor()
        if let textfield = search.value(forKey: "searchField") as? UITextField {
            textfield.textColor = .black
            textfield.backgroundColor = .white
            
            if THelper.isRTL() {
                textfield.textAlignment = .right
            }
            else {
                textfield.textAlignment = .left
            }
        }
        
        self.search.endEditing(true)
        let arrtemp:NSArray = THelper.getArray()
        if arrtemp.count > 0 {
            for i in 0..<arrtemp.count {
                arrRecentSearch.add(arrtemp[i])
            }
        }
        else {
            arrRecentSearch.removeAllObjects()
        }
        let tapGeture = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        tapGeture.numberOfTapsRequired = 1
        tapGeture.isEnabled = true
        tapGeture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGeture)
        
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
    //MARK: - SearchBar Delegate & DataSource
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if self.search.text!.count >= 3  {
            page = 1
            getSearchAPI(strSearchText: self.search.text ?? "", pageNo: page)
            search.resignFirstResponder()
        }
    }
    
    //MARK: -
    //MARK: -UICollectionView Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cvSearch.register(UINib(nibName: "NewestProductListCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
        let cell = cvSearch.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! NewestProductListCollectionCell
        
        var dicProducts = NSDictionary()
        dicProducts = arrSearch[indexPath.item] as! NSDictionary
        
        if TValidation.isNull(dicProducts.value(forKey: FULL)) {
            cell.imgProduct.image = UIImage(named: "")
        }
        else {
            THelper.setImage(img: cell.imgProduct, url: URL(string: dicProducts.value(forKey: FULL) as! String)!, placeholderImage: "")
        }
        
        cell.lblProductName.text = dicProducts.value(forKey: "name") as? String
        cell.lblProductRaing.text = "\(dicProducts.value(forKey: "average_rating") ?? "")"
        
        if "\(dicProducts.value(forKey: SALES_PRICE) ?? "")" == "" {
            if "\(dicProducts.value(forKey: PRICE) ?? "")" == "" {
                cell.lblNewProductPrice.text = ""
            }else {
                cell.lblNewProductPrice.text = "\(PRICE_SIGN)\(dicProducts.value(forKey: PRICE) ?? "")"
            }
        }else {
            cell.lblNewProductPrice.text = "\(PRICE_SIGN)\(dicProducts.value(forKey: SALES_PRICE) ?? "")"
        }
        
        if "\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")" == "" {
            if "\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")" == "" {
                cell.lblOldProductPrice.text = ""
            }else {
                cell.lblOldProductPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
            }
            cell.lblOldProductPrice.text = ""
        }else {
            cell.lblOldProductPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
        }
        
        cell.btnProductLike.tag = indexPath.item
        cell.btnProductLike.addTarget(self, action: #selector(onClickLikeProduct(_:)), for: UIControl.Event.touchUpInside)
        
        if arrLikePackage.contains(indexPath.item) {
            cell.vwProductLikeBackground.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            cell.btnProductLike = THelper.setButtonTintColor(cell.btnProductLike, imageName: "icoHeartFill", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
        }
        else {
            cell.vwProductLikeBackground.backgroundColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            cell.btnProductLike = THelper.setButtonTintColor(cell.btnProductLike, imageName: "icoHeart", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Secondary_Color1"))
        }
        
//        cell.imgProduct.image = UIImage(named: "") THelper.setImage(img: cell.imgProduct, url: URL(string: dicProducts.value(forKey: "") as! String)!, placeholderImage: "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item >= arrSearch.count - 1 {
            page = page + 1
            if page > totalPage {}
            else {
                getSearchAPI(strSearchText: self.search.text ?? "", pageNo: page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if IPAD {
            return CGSize(width: cvSearch.frame.width - 32, height: 250)
        }else {
            return CGSize(width: cvSearch.frame.width - 24, height: 140)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dicProducts: NSDictionary = arrSearch[indexPath.item] as! NSDictionary
        
        let vc = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        vc.strProductID = "\(dicProducts.value(forKey: PRO_ID) ?? "")"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: -
    //MARK: - Other Method
    
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.search.resignFirstResponder()
    }
    
    //MARK: -
    //MARK: - Cell UIButton Action Method
    
    @objc func onClickLikeProduct(_ sender: UIButton?) {
        var dicProducts = NSDictionary()
        dicProducts = arrSearch[sender!.tag] as! NSDictionary
        
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            if sender!.isSelected {
                sender?.isSelected = false
                arrLikePackage.remove(sender?.tag as Any)
            }
            else {
                sender?.isSelected = true
                if arrLikePackage.contains(sender?.tag as Any)
                {
                    print("All Ready Selected")
                }else {
                    arrLikePackage.add(sender?.tag as Any)
                    addProductToWishlistAPI(strProductID: "\(dicProducts.value(forKey: PRO_ID) ?? "")")
                }
            }
            cvSearch.reloadData()
        }
        else {
            let vc = signInViewController(nibName: "signInViewController", bundle: nil)
            AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
            frostedViewController?.hideMenuViewController()
        }
        
        
        
    }

    //MARK:-
    //MARK:- UIButton Action Method

    @IBAction func btnBack_Clicked(_ sender: Any) {
        if isFormPayCard == true {
            self.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:-
    //MARK:- Api calling
        
    func getSearchAPI(strSearchText: String, pageNo: Int) {
        THelper.ShowProgress(vc: self)
        
        let param = ["text":strSearchText,
                     "page":pageNo
            ] as [String : Any]
        print(param)
                        
        Alamofire.request(TPreferences.getCommonURL(NEW_SEARCH)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    THelper.hideProgress(vc: self)
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            print(data)
                            if pageNo == 1 {
                                self.arrSearch.removeAllObjects()
                            }
                            
                            var arrTemp = NSArray()
                            arrTemp = data as! NSArray
                            
                            for i in 0..<arrTemp.count {
                                let dicSearch: NSDictionary = arrTemp[i] as! NSDictionary
                                self.totalPage = dicSearch.value(forKey: NO_OF_PAGES) as! Int
                                self.arrSearch.add(dicSearch)
                            }
                            
                            if self.arrSearch.count > 0 {
                                self.cvSearch.reloadData()
                                self.cvSearch.isHidden = false
                                self.lblNoDataFound.isHidden = true
                                self.imgSearch.isHidden = true
                            }
                            else {
                                self.cvSearch.isHidden = true
                                self.lblNoDataFound.isHidden = false
                                self.imgSearch.isHidden = false
                                self.lblNoDataFound.text = LanguageLocal.myLocalizedString(key: "No_Product_Found")
                                THelper.toast(LanguageLocal.myLocalizedString(key: "No_Product_Found"), vc: self)
                            }
                        }
                        else {
                            print(data)
                            self.cvSearch.isHidden = true
                            self.lblNoDataFound.isHidden = false
                            self.imgSearch.isHidden = false
                            self.lblNoDataFound.text = LanguageLocal.myLocalizedString(key: "No_Product_Found")
                            
                            let dicError:NSDictionary = data as! NSDictionary
                            let str:String = dicError.value(forKey: "message") as! String
                            THelper.toast(str.html2String, vc: self)
                        }
                    }
                    break
                    
                case .failure(_):
                    self.cvSearch.isHidden = true
                    self.lblNoDataFound.isHidden = false
                    self.imgSearch.isHidden = false
                    self.lblNoDataFound.text = LanguageLocal.myLocalizedString(key: "No_Product_Found")
                    
                    THelper.hideProgress(vc: self)
                    THelper.toast(ERROR_MSG, vc: self)
                    print(response.result.error?.localizedDescription ?? "Something went wrong")
    //                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                    break
                }
            }
        }
        
    func addProductToWishlistAPI(strProductID: String) {
        let param = [PRO_ID:strProductID
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())

        sessionManager.request(TPreferences.getCommonURL(NEW_ADD_WISHLIST)!, method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
//                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
//                        let dicData: NSDictionary = data as! NSDictionary
//                        THelper.toast("\(dicData.value(forKey: "message") ?? "")", vc: self)
                    }
                    else {
                        print(data)
//                        let dicError:NSDictionary = data as! NSDictionary
//                        let str:String = dicError.value(forKey: "message") as! String
//                        THelper.toast(str.html2String, vc: self)
                    }
                }
                break
                
            case .failure(_):
//                THelper.hideProgress(vc: self)
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                break
            }
        }
    }
}
