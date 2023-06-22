//
//  ProductDetailsViewController.swift
//  WooBox
//
//  Created by Rohan Patel on 02/06/20.
//  Copyright © 2020 Goldenmace. All rights reserved.
//

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import FCAlertView
import Cosmos

class ProductDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, FCAlertViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    //MARK:-
    //MARK:- Outlets
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwImg: UIView!
    @IBOutlet weak var vwDropDown: UIView!
    @IBOutlet weak var vwOffer: UIView!
    @IBOutlet weak var vwDiscount: UIView!
    @IBOutlet weak var vwSale: UIView!
    @IBOutlet weak var vwPickerBackGround: UIView!
    
    @IBOutlet weak var vwRatting: CosmosView!
    
    @IBOutlet weak var cvProductImage: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var btnAddCart: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var vwPicker: UIView!
    @IBOutlet weak var lblAvailableIn: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblitemPrices: UILabel!
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblDescriptionDetail: UILabel!
    @IBOutlet weak var lblAvailableINDetail: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    
    @IBOutlet weak var PickerView: UIPickerView!
  
    @IBOutlet weak var tblAdditionInfo: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ConstraintSafeArea: NSLayoutConstraint!
    @IBOutlet weak var ConstraintDropDownHeight: NSLayoutConstraint!
    @IBOutlet weak var ConstraintTblHeight: NSLayoutConstraint!
    @IBOutlet weak var ConstraintVwOfferHeight: NSLayoutConstraint!
    
    //MARK:-
    //MARK:- Variables
    
    var arrAttributes = NSArray()
    var arrAttri = NSMutableArray()
    var arrProduct = NSArray()
    var dicProducts = NSDictionary()
    var arrDropDown = NSMutableArray()
    var arrImages = NSArray()
    var arrWishlist = NSArray()
    var arrReview = NSArray()

    var strDropDown = String()
    var strAvailableINDetail = String()
    var strProductID = String()
    var strQty = String()

    
    var isFromBuyNow = Bool()
    var productInCart = Bool()
    var productInWishlist = Bool()
    var isFirstTime = Bool()

    
    //MARK:-
    //MARK:- UIView Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SetUpObject()
    }
    
    //MARK:-
    //MARK:- SetUpObject Methods
    
    func SetUpObject() {
        self.navigationController?.isNavigationBarHidden = true
        print("Product Id:- \(strProductID)")
        getProductDetailAPI()
        self.vwSale.layer.cornerRadius = 10.0
        self.vwDiscount.layer.borderWidth = 0.5
        self.vwDiscount.layer.borderColor = UIColor.gray.cgColor
        self.vwDiscount.layer.cornerRadius = 10.0
        self.ConstraintVwOfferHeight.constant = 0
        
        strQty = "1"
    }
    
    //MARK:-
    //MARK:- SetUpValue Methods
    
    func SetUpValue() {
        self.lblProductName.text = "\(self.dicProducts.value(forKey: "name") ?? "")"
        self.lblitemPrices.text = "\(PRICE_SIGN)\(self.dicProducts.value(forKey: PRICE) ?? "")"
        let strDescrption: String = "\(self.dicProducts.value(forKey: "description") ?? "")"
        
       if dicProducts.value(forKey: "average_rating") != nil {
            let rating = "\(dicProducts.value(forKey: "average_rating") ?? 0.0)"
            self.vwRatting.rating = Double(rating)!
        }
       else {
            self.vwRatting.rating = 0.0
        }
        if arrDropDown.count > 0 {
            self.lblAvailableINDetail.text = "\(self.arrDropDown[0])"
            self.PickerView.selectRow(0, inComponent: 0, animated: true)
        }else {}
        
        
        self.arrImages = self.dicProducts.value(forKey: "images") as! NSArray
        self.cvProductImage.reloadData()
        self.lblDescriptionDetail.text = strDescrption.html2String
    }

    // MARK:-
    // MARK:- UIScrollViewDelegate

     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         if scrollView.contentOffset.y > vwImg.frame.height - 40 {
            vwHeader.backgroundColor = UIColor.init(hexString: "23A057")
         }
         else {
             vwHeader.backgroundColor = .clear
         }
     }
    
    //MARK:-
    //MARK:- CollectionView Delegate & Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            self.cvProductImage.register(UINib(nibName: "BannerCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BannerCell")
            let cell = cvProductImage.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCollectionCell
            
            self.pageControl.numberOfPages = arrImages.count
            self.pageControl.currentPageIndicatorTintColor = UIColor.primaryColor()
        
            let url: String = "\((self.arrImages[indexPath.item] as AnyObject).value(forKey: "src") ?? "")"

            cell.imgBanner.contentMode = .scaleAspectFill
            THelper.setImage(img: cell.imgBanner, url: URL(string: "\(url)")!, placeholderImage: "")
            
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let cell = cvProductImage.cellForItem(at: indexPath) as! BannerCollectionCell
            THelper.displayImage(self, imageView: cell.imgBanner)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width:self.cvProductImage.frame.width , height: self.cvProductImage.frame.height)
    }

    //MARK:-
    //MARK:- UITableView Delegate & Data Sources
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAttributes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblAdditionInfo.register(UINib(nibName: "ProductDetailTableCell", bundle: nil), forCellReuseIdentifier: "ProductDetailTableCell")
        let cell = self.tblAdditionInfo.dequeueReusableCell(withIdentifier: "ProductDetailTableCell") as! ProductDetailTableCell

        let dic: NSDictionary = arrAttributes[indexPath.row] as! NSDictionary
        cell.lblTitle.text = "\(dic.value(forKey: "name") ?? ""):"
        cell.arrOption = (self.arrAttributes[indexPath.row] as AnyObject).value(forKey: "options") as! NSArray
        NotificationCenter.default.post(name: NSNotification.Name("cvData"), object: self, userInfo: (self.dicProducts as! [AnyHashable : Any]))
        cell.selectionStyle = .none
        cell.cvOption.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //MARK: -
      //MARK: - Picker View Delegate
      
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return arrDropDown.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return arrDropDown[row] as? String
      }
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.lblAvailableINDetail.text = "\(arrDropDown[row])"
        self.lblitemPrices.text = "\(PRICE_SIGN)\((arrProduct[row + 1] as AnyObject).value(forKey: PRICE) ?? "")"
        self.strProductID = "\((arrProduct[row + 1] as AnyObject).value(forKey: "id") ?? "")"
        print(self.strProductID)
        let isBool: Bool = (arrProduct[row + 1] as AnyObject).value(forKey: "on_sale") as! Bool
        
        if isBool == true {
            
            var salesPrice = Double()
            var regularPrice = Double()
            
            
            if "\((arrProduct[row + 1] as AnyObject).value(forKey: SALES_PRICE) ?? "")" == "" {
                if "\((arrProduct[row + 1] as AnyObject).value(forKey: PRICE) ?? "")" == "" {
                    self.lblitemPrices.text = ""
                    salesPrice = 0
                }else {
                    lblitemPrices.text = "\(PRICE_SIGN)\((arrProduct[row + 1] as AnyObject).value(forKey: PRICE) ?? "")"
                    salesPrice = Double("\((arrProduct[row + 1] as AnyObject).value(forKey: PRICE) ?? "")")!
                }
                
            }else {
                lblitemPrices.text = "\((arrProduct[row + 1] as AnyObject).value(forKey: SALES_PRICE) ?? "")"
                salesPrice = Double("\((arrProduct[row + 1] as AnyObject).value(forKey: PRICE) ?? "")")!
            }
            
            if "\((arrProduct[row + 1] as AnyObject).value(forKey: REGULAR_PRICE) ?? "")" == "" {
                lblActualPrice.text = ""
                regularPrice = 0
            }else {
                lblActualPrice.attributedText = THelper.attributeText(price: "\((arrProduct[row + 1] as AnyObject).value(forKey: REGULAR_PRICE) ?? "")")
                regularPrice = Double("\((arrProduct[row + 1] as AnyObject).value(forKey: REGULAR_PRICE) ?? "0")")!
            }
            
            if regularPrice == 0 {
                lblOffer.text = "0% Off"
            }
            else {
                let discount = regularPrice - salesPrice
                let offer: Int = Int((discount / regularPrice) * 100)
                lblOffer.text = "\(offer)% Off"
            }
            self.ConstraintVwOfferHeight.constant = 30
            
        }else {
            lblActualPrice.text = ""
            self.ConstraintVwOfferHeight.constant = 0
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
                   if "\(dicTempProduct.value(forKey: PRO_ID) ?? "")" == "\(self.dicProducts.value(forKey: PRO_ID) ?? "")" {
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
                   if "\(dicTempProduct.value(forKey: PRO_ID) ?? "")" == "\(self.dicProducts.value(forKey: PRO_ID) ?? "")" {
//                       vwLike.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
                       btnLike = THelper.setButtonTintColor(btnLike, imageName: "icoHeartFill", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
                       productInWishlist = true
                   }
                   else {
//                      vwLike.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
                      btnLike = THelper.setButtonTintColor(btnLike, imageName: "icoHeart", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "vw_secoundry_background"))
                       productInWishlist = false
                   }
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
                    addItemToCartAPI()
                    if isFromBuyNow {
                        let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
                        vc.flagHeader = false
                        vc.isFormPayCard = false
                        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func productOutOfStock() -> Bool {
        let inStock: Bool = self.dicProducts.value(forKey: "in_stock") as! Bool
        if (inStock == true) {
            return true
        }else {
            return false
        }
    }


    
    //MARK: -
    //MARK: -fcAlertDoneButtonClicked
       
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView?) {
        deleteItemFromCartAPI()
    }
    
    //MARK:-
    //MARK:- API Calling
    
    func getProductDetailAPI() {
            
        THelper.ShowProgress(vc: self)
            
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        sessionManager.request(TPreferences.getCommonURL("\(NEW_SINGLE_PRODUCT)?product_id=\(strProductID)")!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    THelper.hideProgress(vc: self)
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            let arrTemp:NSArray = data as! NSArray
                            self.arrProduct = arrTemp
                            for i in 0..<arrTemp.count {
                                if i >= 1 {
                                    self.arrAttri.add((arrTemp[i] as AnyObject).value(forKey: "attributes") as! NSArray)
                                    
                                    for j in 0..<self.arrAttri.count {
                                        let arrTemp1: NSArray = self.arrAttri[j] as! NSArray
                                        for n in 0..<arrTemp1.count {
                                            let dic:NSDictionary = arrTemp1[n] as! NSDictionary
                                            let str: String = "\(dic.value(forKey: "option") ?? "")"
                                            if n == arrTemp1.count - 1 {
                                                self.strDropDown = self.strDropDown + str
                                            }else {
                                                 self.strDropDown = self.strDropDown + " " + str + " - "
                                            }
                                        }
                                        let isBool: Bool = (arrTemp[i] as AnyObject).value(forKey: "on_sale") as! Bool
                                        if isBool == true {
                                            self.strDropDown = self.strDropDown + "[SALE]"
                                        }else {}
                                        self.arrDropDown.add(self.strDropDown)
                                        self.strDropDown.removeAll()
                                    }
                                }
                                self.arrAttri.removeAllObjects()
                            }
                            
                            
                            self.dicProducts = arrTemp[0] as! NSDictionary
                            
                            if self.dicProducts.value(forKey: "type") as! String == "simple" {
                                print("Simple")
                                self.ConstraintDropDownHeight.constant = 0
                                self.vwDropDown.isHidden = true
                                self.lblAvailableIn.text = ""
                            }else {
                                print("variable")
                                self.ConstraintDropDownHeight.constant = 40
                                self.vwDropDown.isHidden = false
                                self.lblAvailableIn.text = "Available in:"
                            }
                            
                            self.arrAttributes = self.dicProducts.value(forKey: "attributes") as! NSArray
                            self.tblAdditionInfo.reloadData()
                            self.ConstraintTblHeight.constant = CGFloat(self.arrAttributes.count * 40)
                            self.PickerView.reloadAllComponents()
                            self.SetUpValue()
                            self.getCartItems()
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
                    self.ConstraintTblHeight.constant = 0
                    print(response.result.error?.localizedDescription ?? "Something went wrong")
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
    
    func addItemToCartAPI() {
            THelper.ShowProgress(vc: self)
            
            let param = [PRO_ID:strProductID,
                         "quantity":strQty,
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
                            
//                            self.lblReviews.text = "\(arrReviewers.count) Reviewers"
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


    //MARK:-
    //MARK:- UIButton Clicked Events
    
    @IBAction func btnAddToCart_Clicked(_ sender: Any) {
        isFromBuyNow = false
        addToCart(isFromBuyNow: false)
    }
    
    @IBAction func btnReview_clicked(_ sender: Any) {
        let vc = ReviewsViewController(nibName: "ReviewsViewController", bundle: nil)
        vc.strProductID = self.strProductID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLike_Clicked(_ sender: Any) {
           if TPreferences.readBoolean(IS_LOGGED_IN) {
               if productInWishlist {
//                   vwLike.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
                   btnLike = THelper.setButtonTintColor(btnLike, imageName: "icoHeart", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "vw_secoundry_background"))
                   
                   removeWishlistAPI()
               }
               else {
//                   vwLike.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
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
    
    @IBAction func btnAvailableIn_Clicked(_ sender: Any) {
        self.vwPicker.isHidden = false
        self.vwPickerBackGround.isHidden = false
    }
    
    @IBAction func btnDone_Clicked(_ sender: Any) {
        self.vwPicker.isHidden = true
        self.vwPickerBackGround.isHidden = true
    }
    
    
    @IBAction func btnShoppingCart_Clicked(_ sender: Any) {
        let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
        vc.flagHeader = false
        vc.isFormPayCard = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
