//
//  itemDetailViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import SDWebImage
import Cosmos
import FCAlertView
import GoogleMobileAds

class itemDetailViewController: UIViewController, UIScrollViewDelegate, FCAlertViewDelegate, GADBannerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK:-
    //MARK:- Outlets
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBrandHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintVwSizeHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintVwColorHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var vwStar: UIView!
    @IBOutlet weak var vwBanner: UIView!
    
    @IBOutlet weak var vwLike: UIView!
    @IBOutlet weak var vwMain: UIView!
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblReviews: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    
    @IBOutlet weak var lblAverageReview: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblColors: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblBrandHeading: UILabel!
    @IBOutlet weak var lblReviewHeading: UILabel!
    @IBOutlet weak var lblSelectQty: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    
    @IBOutlet weak var VwProductImage: UIView!
    @IBOutlet weak var vwColors: UIView!
    @IBOutlet weak var vwSizes: UIView!
    @IBOutlet weak var vwQtyBackground: UIView!
    @IBOutlet weak var vwQty: UIView!
    @IBOutlet weak var vwMoreInfo: UIView!
        
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    
    @IBOutlet weak var btnAddCart: UIButton!
    
    @IBOutlet weak var pickerQty: UIPickerView!
    
    @IBOutlet weak var cvColors: UICollectionView!
    @IBOutlet weak var cvSizes: UICollectionView!
    @IBOutlet weak var cvProductImage: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK:-
    //MARK:- Variables
        
    var arrImage = NSArray()
    var strProductID = String()
    var dicProduct = NSDictionary()
    var isFromAdd = Bool()
    var tag = Int()
    var arrReview = NSArray()
    var isFirstTime = Bool()
    var strAverageRating = String()
    var arrProduct = NSMutableArray()
    var strColor = String()
    var strSize = String()
    var strBrand = String()
    var productInCart = Bool()
    var arrWishlist = NSArray()
    var productInWishlist = Bool()
    var strShortDesc = String()
    var strQty = String()
    let arrQty = NSMutableArray()
    
    var sizeIndex = Int()
    var colorIndex = Int()
    var arrAttributes = NSArray()
    var arrProductSize = NSArray()
    var arrProductColor = NSArray()
    var isFromBuyNow = Bool()
    
    var bannerView: GADBannerView!
    
    //MARK:-
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpObject()
    }
    
    //MARK:-
    //MARK:- SetUpObject Method
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        strColor = ""
        strSize = ""
        colorIndex = -1
        sizeIndex = -1
        
        btnBack.layer.cornerRadius = btnBack.frame.height / 2
        btnBack.layer.masksToBounds = true
        btnBack.backgroundColor = .primaryColor()
//        btnBack = THelper.setButtonTintColor(btnBack, imageName: "icoBack", state: .normal, tintColor: .white)
        btnCart.layer.cornerRadius = btnCart.frame.height / 2
        
        if strProductID == "" {
            THelper.toast("Something went wrong", vc: self)
            self.navigationController?.popViewController(animated: true)
        }
        else {
            isFirstTime = true
            getProductDetailAPI()
            getProductReviewAPI()
        }
        
        if IPAD {
            self.vwLike.layer.cornerRadius = 50 / 2
        }else {
            self.vwLike.layer.cornerRadius = self.vwLike.frame.size.height / 2
        }
        self.VwProductImage.addSubview(pageControl)
        
//        self.btnBuyNow.setTitle(LanguageLocal.myLocalizedString(key: "Buy_Now"), for: .normal)
        self.btnAddCart.setTitle(LanguageLocal.myLocalizedString(key: "Add_Cart"), for: .normal)
        self.lblColors.text = LanguageLocal.myLocalizedString(key: "Colors")
        self.lblSize.text = LanguageLocal.myLocalizedString(key: "Size")
        self.lblBrandHeading.text = LanguageLocal.myLocalizedString(key: "Brands")
        self.lblReviewHeading.text = LanguageLocal.myLocalizedString(key: "Reviews")
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: lblActualPrice.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        lblActualPrice.attributedText = attributeString
        
        self.vwStar.layer.cornerRadius = 15.0
        
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
        
        strQty = "1"
        pickerQty.backgroundColor = .clear
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
        lblItemName.text = "\(dicProduct.value(forKey: PRODUCT_NAME) ?? "")"
        
        var salesPrice = Double()
        var regularPrice = Double()
        
        if "\(dicProduct.value(forKey: SALES_PRICE) ?? "")" == "" {
            if "\(dicProduct.value(forKey: PRICE) ?? "")" == "" {
                lblItemPrice.text = ""
                salesPrice = 0
            }else {
                lblItemPrice.text = "\(PRICE_SIGN)\(dicProduct.value(forKey: PRICE) ?? "")"
                salesPrice = Double("\(dicProduct.value(forKey: PRICE) ?? "0")")!
            }
        }else {
            lblItemPrice.text = "\(PRICE_SIGN)\(dicProduct.value(forKey: SALES_PRICE) ?? "")"
            salesPrice = Double("\(dicProduct.value(forKey: SALES_PRICE) ?? "0")")!
        }
        
        if "\(dicProduct.value(forKey: REGULAR_PRICE) ?? "")" == "" {
            lblActualPrice.text = ""
            regularPrice = 0
        }else {
            lblActualPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProduct.value(forKey: REGULAR_PRICE) ?? "")")
            regularPrice = Double("\(dicProduct.value(forKey: REGULAR_PRICE) ?? 0)")!
        }
        
        if regularPrice == 0 {
            lblOffer.text = "0% Off"
        }
        else {
            let discount = regularPrice - salesPrice
            let offer: Int = Int((discount / regularPrice) * 100)
            lblOffer.text = "\(offer)% Off"
        }
        
        strAverageRating = "\(dicProduct.value(forKey: "average_rating") ?? "")"
        lblAverageReview.text = strAverageRating
        
        arrImage = dicProduct.value(forKey: "gallery") as! NSArray
        cvProductImage.reloadData()
                
        strColor = "\(dicProduct.value(forKey: "color") ?? "")"
        strSize = "\(dicProduct.value(forKey: "size") ?? "")"
        strBrand = "\(dicProduct.value(forKey: "brand") ?? "")"
        strShortDesc = "\(dicProduct.value(forKey: "short_description") ?? "")"
        lblDescription.text = strShortDesc.html2String
        
        if strColor == "" {
            lblColors.text = ""
            constraintVwColorHeight.constant = 0
            lblColors.isHidden = true
            vwColors.isHidden = true
        }
        else {
            lblColors.text = "Colors"
            constraintVwColorHeight.constant = 50
            lblColors.isHidden = false
            vwColors.isHidden = false
            
            arrProductColor = strColor.components(separatedBy: ",") as NSArray
            cvColors.reloadData()
        }
        
        if strSize == "" {
            lblSize.text = ""
            constraintVwSizeHeight.constant = 0
            lblSize.isHidden = true
            vwSizes.isHidden = true
            
        }
        else {
            lblSize.text = "Size"
            constraintVwSizeHeight.constant = 50
            lblSize.isHidden = false
            vwSizes.isHidden = false
            
            arrProductSize = strSize.components(separatedBy: ",") as NSArray
            cvSizes.reloadData()
        }
        
        if strBrand == "" {
            vwMoreInfo.isHidden = true
            lblBrand.text = ""
            constraintVwBrandHeight.constant = 0
        }
        else {
            vwMoreInfo.isHidden = false
            lblBrand.text = strBrand
            constraintVwBrandHeight.constant = 50
        }
    }
    
    //MARK: -
    //MARK: - Picker View Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrQty.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrQty[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        strQty = arrQty[row] as! String
        lblQuantity.text = strQty
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: "\(arrQty[row])", attributes: [NSAttributedString.Key.foregroundColor : ThemeManager.shared()?.color(forKey: "Secondary_Color1") as Any])
        return attributedString
    }
    
    //MARK:-
    //MARK:- CollectionView Delegate & Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvProductImage {
            return arrImage.count
        }
        else if collectionView == cvColors {
            return arrProductColor.count
        }else {
             return arrProductSize.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cvProductImage {
            self.cvProductImage.register(UINib(nibName: "BannerCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BannerCell")
            let cell = cvProductImage.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCollectionCell
            
            self.pageControl.numberOfPages = arrImage.count
            self.pageControl.currentPageIndicatorTintColor = UIColor.primaryColor()

            cell.imgBanner.contentMode = .scaleAspectFill
            THelper.setImage(img: cell.imgBanner, url: URL(string: "\(arrImage[indexPath.item])")!, placeholderImage: "")
            
            return cell
        }
        else if collectionView == cvColors {
            cvColors.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
            let cell = cvColors.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoriesCollectionCell

            if colorIndex == indexPath.item {
                cell.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
                cell.lblCategory.textColor = .white
            }
            else {
                cell.backgroundColor = .white
                cell.lblCategory.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            }
            cell.lblCategory.text = "\(arrProductColor[indexPath.item])"
            
            return cell
            
        }else {
             self.cvSizes.register(UINib(nibName: "SizeViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeViewCell")
            let cell = cvSizes.dequeueReusableCell(withReuseIdentifier: "SizeViewCell", for: indexPath) as! SizeViewCell
            cell.lblSize.text = arrProductSize[indexPath.item] as? String
            if IPAD {
                cell.vwSize.layer.cornerRadius = 50 / 2
                if sizeIndex == indexPath.item {
                    cell.vwSize.backgroundColor = UIColor.primaryColor()
                    cell.lblSize.textColor = UIColor.white
                } else {
                    cell.vwSize.backgroundColor = UIColor.clear
                    cell.lblSize.textColor = UIColor.lightGray
                }
            }else {
                cell.vwSize.layer.cornerRadius = cell.vwSize.layer.frame.height / 2
                if sizeIndex == indexPath.item {
                    cell.vwSize.backgroundColor = UIColor.primaryColor()
                    cell.lblSize.textColor = UIColor.white
                } else {
                    cell.vwSize.backgroundColor = UIColor.clear
                    cell.lblSize.textColor = UIColor.lightGray
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cvProductImage {
            let cell = cvProductImage.cellForItem(at: indexPath) as! BannerCollectionCell
            THelper.displayImage(self, imageView: cell.imgBanner)
        }
        else if collectionView == cvColors {
            colorIndex = indexPath.item
            self.cvColors.reloadData()
        }else {
            sizeIndex = indexPath.item
            self.cvSizes.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvProductImage {
            return CGSize(width:self.cvProductImage.frame.width , height: self.cvProductImage.frame.height)
        }
        else if collectionView == cvColors {
            let label = UILabel(frame: CGRect.zero)
            var strColor = String()
            strColor = "\(arrProductColor[indexPath.item])"
            label.text = strColor
            label.sizeToFit()
            return CGSize(width: label.frame.width + 16, height: 40)
        }
        else {
            return CGSize(width: 50, height: 50)
        }
    }
    
    //MARK:-
    //MARK:- Other Method
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = cvProductImage.frame.size.width
        pageControl.currentPage = Int(cvProductImage.contentOffset.x / pageWidth)
    }
        
    func getCartItems() {
        let arrTemp:NSArray = THelper.getCart()
        if arrTemp.count > 0 {
            for i in 0..<arrTemp.count {
                let dicTempProduct:NSDictionary = arrTemp[i] as! NSDictionary
                if "\(dicTempProduct.value(forKey: PRO_ID) ?? "")" == "\(self.dicProduct.value(forKey: PRO_ID) ?? "")" {
                    self.btnAddCart.setTitle(LanguageLocal.myLocalizedString(key: "Remove_Cart"), for: .normal)
                    productInCart = true
                }
                else {
                   self.btnAddCart.setTitle(LanguageLocal.myLocalizedString(key: "Add_Cart"), for: .normal)
                    productInCart = false
                }
            }
        }
    }
    
    func getLikedItem() {
        if arrWishlist.count > 0 {
            for i in 0..<arrWishlist.count {
                let dicTempProduct:NSDictionary = arrWishlist[i] as! NSDictionary
                if "\(dicTempProduct.value(forKey: PRO_ID) ?? "")" == "\(self.dicProduct.value(forKey: PRO_ID) ?? "")" {
                    vwLike.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
                    btnLike = THelper.setButtonTintColor(btnLike, imageName: "icoHeartFill", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
                    productInWishlist = true
                }
                else {
                   vwLike.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
                   btnLike = THelper.setButtonTintColor(btnLike, imageName: "icoHeart", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "vw_secoundry_background"))
                    productInWishlist = false
                }
            }
        }
    }
    
    func productOutOfStock() -> Bool {
        var stock = Int()
        if TValidation.isNull(dicProduct.value(forKey: STOCK_QUANTITY)) {
            stock = 0
        }
        else {
            stock = dicProduct.value(forKey: STOCK_QUANTITY) as! Int
        }
        
        if stock < 1 {
            return false
        }
        else {
            return true
        }
    }
    
    func addToCart(isFromBuyNow: Bool) {
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            if productInCart {
                if isFromBuyNow {
                    let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
                    vc.flagHeader = false
                    vc.isFormPayCard = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    THelper.displayAlert(self, title: "", message: "Are you sure you want to remove this item from Cart", tag: 101, firstButton: "Cancel", doneButton: "OK")
                }
            }
            else {
                if productOutOfStock() {
                    if colorIndex != -1 || strColor == "" {
                        if sizeIndex != -1 || strSize == "" {
                            addItemToCartAPI()
                            if isFromBuyNow {
                                let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
                                vc.flagHeader = false
                                vc.isFormPayCard = false
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        else {
                            THelper.toast("Select size", vc: self)
                        }
                    }
                    else {
                        THelper.toast("Select color", vc: self)
                    }
                }
                else {
                    THelper.toast("Out of stock", vc: self)
                }
            }
        }
        else {
            let vc = signInViewController(nibName: "signInViewController", bundle: nil)
            AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
            frostedViewController?.hideMenuViewController()
        }
    }
        
    //MARK: -
    //MARK: -fcAlertDoneButtonClicked
    
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView?) {
        deleteItemFromCartAPI()
    }
    
    //MARK:-
    //MARK:- UIButton Action Methods
        
    @IBAction func btnReview_Clicked(_ sender: Any) {
        let vc = ReviewsViewController(nibName: "ReviewsViewController", bundle: nil)
        vc.strProductID = self.strProductID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAddCart_Clicked(_ sender: Any) {
        isFromBuyNow = false
        addToCart(isFromBuyNow: false)
    }
    
    @IBAction func btnLike_Clicked(_ sender: Any) {
        
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            if productInWishlist {
                vwLike.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
                btnLike = THelper.setButtonTintColor(btnLike, imageName: "icoHeart", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "vw_secoundry_background"))
                
                removeWishlistAPI()
            }
            else {
                vwLike.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
                btnLike = THelper.setButtonTintColor(btnLike, imageName: "icoHeartFill", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
                
                addProductToWishlistAPI()
            }
        }
        else {
            let vc = signInViewController(nibName: "signInViewController", bundle: nil)
            AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
            frostedViewController?.hideMenuViewController()
        }
    }
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("Reload"), object: self, userInfo: ["flag":"1"])
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDone_Clicked(_ sender: Any) {
        vwQtyBackground.isHidden = true
        vwQty.isHidden = true
        if isFromBuyNow {
            let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
            vc.flagHeader = false
            vc.isFormPayCard = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnCart_Clicked(_ sender: Any) {
        let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
        vc.flagHeader = false
        vc.isFormPayCard = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSelectQuantity_Clicked(_ sender: Any) {
        arrQty.removeAllObjects()
        var stock = Int()
        if TValidation.isNull(dicProduct.value(forKey: STOCK_QUANTITY)) {
            stock = 0
        }
        else {
            stock = dicProduct.value(forKey: STOCK_QUANTITY) as! Int
        }
        
        if productOutOfStock() {
            arrQty.removeAllObjects()
            for i in 1..<stock + 1 {
                arrQty.add("\(i)")
            }
            vwQtyBackground.isHidden = false
            vwQty.isHidden = false
            pickerQty.reloadAllComponents()
        }
        else {
            THelper.toast("Out of stock", vc: self)
        }
    }
    
    //MARK:-
    //MARK:- API Calling
    
    func getProductDetailAPI() {
        THelper.ShowProgress(vc: self)
        
        let param = [PRO_ID:strProductID
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_SINGLE_PRODUCT)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        
                        self.dicProduct = data as! NSDictionary
                        self.SetUpValue()
                        self.getCartItems()
                        self.getWishlistAPI()
                    }
                    else {
                        print(data)
                        self.constraintVwColorHeight.constant = 0
                        self.constraintVwSizeHeight.constant = 0
                        self.constraintVwBrandHeight.constant = 0
                        
                        self.lblColors.isHidden = true
                        self.vwColors.isHidden = true
                        self.lblSize.isHidden = true
                        self.vwSizes.isHidden = true
                        self.vwMoreInfo.isHidden = true
                        self.lblBrand.text = ""
                                                                        
                        let dicError:NSDictionary = data as! NSDictionary
                        let str:String = dicError.value(forKey: "message") as! String
                        THelper.toast(str.html2String, vc: self)
                    }
                }
                break
                
            case .failure(_):
                self.constraintVwColorHeight.constant = 0
                self.constraintVwSizeHeight.constant = 0
                self.constraintVwBrandHeight.constant = 0
                
                THelper.hideProgress(vc: self)
                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                self.navigationController?.popViewController(animated: true)
                break
            }
        }
    }
    
    func getProductReviewAPI() {
//        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL("\(GET_PRODUCT_REVIEWS)/\(strProductID)/reviews")!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
//                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        self.arrReview = arrtemp[0] as! NSArray
                        
                        let arrReviewers = NSMutableArray()
                        for i in 0..<self.arrReview.count {
                            let dicReview:NSDictionary = self.arrReview[i] as! NSDictionary
                            if !arrReviewers.contains(dicReview.value(forKey: "name") ?? "") {
                                arrReviewers.add(dicReview.value(forKey: "name") ?? "")
                                print(dicReview.value(forKey: "name") ?? "")
                            }
                        }
                        
                        self.lblReviews.text = "\(arrReviewers.count) Reviewers"
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
//                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                break
            }
        }
    }
    
    func addProductReviewAPI(review: String, rating: Int) {
        THelper.ShowProgress(vc: self)
        let param = ["product_id":strProductID,
                     "review":review,
                     "reviewer":"\(TPreferences.readString(USER_FIRST_NAME) ?? "") \(TPreferences.readString(USER_LAST_NAME) ?? "")",
                     "reviewer_email":"\(TPreferences.readString(USER_EMAIL) ?? "")",
                     "rating":rating
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(PRODUCT_REVIEWS)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    print(response.response?.statusCode ?? "")
                    if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                        print(data)
                        self.isFirstTime = false
                        self.getProductReviewAPI()
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
    
    func editProductReviewAPI(reviewId: Int, review: String, rating: Int) {
        THelper.ShowProgress(vc: self)
        
        let param = ["product_id":strProductID,
                     "review":review,
                     "reviewer":"\(TPreferences.readString(USER_FIRST_NAME) ?? "") \(TPreferences.readString(USER_LAST_NAME) ?? "")",
            "reviewer_email":"\(TPreferences.readString(USER_EMAIL) ?? "")",
            "rating":rating
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL("\(PRODUCT_REVIEWS)/\(reviewId)")!,method: .put, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        self.isFirstTime = false
                        self.getProductReviewAPI()
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
    
    func deleteProductReviewAPI(reviewId: Int) {
        THelper.ShowProgress(vc: self)
        let param = ["force":true
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL("\(PRODUCT_REVIEWS)/\(reviewId)")!, method: .delete, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        THelper.toast("Review deleted successfully", vc: self)
                        self.isFirstTime = false
                        self.getProductReviewAPI()
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
    
    func addItemToCartAPI() {
        THelper.ShowProgress(vc: self)
        var color = String()
        var size = String()
        
        if colorIndex == -1 {
            color = ""
        }
        else {
            color = arrProductColor[colorIndex] as! String
        }
        
        if sizeIndex == -1 {
            size = ""
        }
        else {
            size = arrProductSize[colorIndex] as! String
        }
        
        let param = [PRO_ID:strProductID,
                     "quantity":strQty,
                     "color":color,
                     "size":size
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_ADD_TO_CART)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    print(response.response?.statusCode ?? "")
                    if response.response?.statusCode == 200 {
                        print(data)
                        let dicData: NSDictionary = data as! NSDictionary
                        THelper.toast("\(dicData.value(forKey: "message") ?? "")", vc: self)
                        
                        self.btnAddCart.setTitle(LanguageLocal.myLocalizedString(key: "Remove_Cart"), for: .normal)
                        self.productInCart = true
                        
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
    
    func addProductToWishlistAPI() {
//        THelper.ShowProgress(vc: self)
        
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
                        self.productInWishlist = true
                        let dicData: NSDictionary = data as! NSDictionary
                        THelper.toast("\(dicData.value(forKey: "message") ?? "")", vc: self)
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
    
    func deleteItemFromCartAPI() {
        THelper.ShowProgress(vc: self)
        let param = [PRO_ID:strProductID,
            ] as [String : Any]
        print(param)
                
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_DELETE_CART)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    print(response.response?.statusCode ?? "")
                    if response.response?.statusCode == 200 {
                        print(data)
                        self.btnAddCart.setTitle(LanguageLocal.myLocalizedString(key: "Add_Cart"), for: .normal)
                        self.productInCart = false
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
    
    func removeWishlistAPI() {
//        THelper.ShowProgress(vc: self)
        
        let param = [PRO_ID:strProductID
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_DELETE_WISHLIST)!, method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
//                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        self.productInWishlist = false
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
    
    func getWishlistAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_GET_WISHLIST)!, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        if arrtemp.count > 0 {
                            if TValidation.isNull(arrtemp[0]) {
                                self.arrWishlist = [] as NSArray
                            }
                            else {
                                if TValidation.isArray(arrtemp[0]) {
                                    self.arrWishlist = arrtemp[0] as! NSArray
                                    self.getLikedItem()
                                }
                            }
                        }
                        else {
                            self.arrWishlist = [] as NSArray
                            self.getLikedItem()
                        }
                    }
                    else {
                    }
                }
                break
                
            case .failure(_):
                THelper.hideProgress(vc: self)
                break
            }
        }
    }
}
