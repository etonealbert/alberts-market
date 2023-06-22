//
//  WishListViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import FCAlertView


class WishListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,FCAlertViewDelegate {
    
    @IBOutlet weak var cvWishList: UICollectionView!
    
    @IBOutlet weak var constraintHeightSafeArea: NSLayoutConstraint!
    @IBOutlet weak var constaintVwHaderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    
    var arrWishlist = NSArray()
    var isWishInList = Bool()
    var remove_item_id = Int()
    var tag = Int()
    
    //MARK:-
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isWishInList == false {
            self.vwHeader.isHidden = true
            self.constaintVwHaderHeight.constant = 0
             self.constraintHeightSafeArea.constant = 0
        }else {
            self.vwHeader.isHidden = false
            if IPAD {
                self.constaintVwHaderHeight.constant = 66
            } else {
                self.constaintVwHaderHeight.constant = 56
            }
        }
    }
    
    //MARK: -
    //MARK: - SetUpView
    
    func SetUpValue() {
        
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightSafeArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        self.lblHeading.text = LanguageLocal.myLocalizedString(key: "Wishlist")
        
        getWishlistAPI()
    }
    
    //MARK: -
    //MARK: - UICollectionView Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrWishlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         cvWishList.register(UINib(nibName: "WishListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WishlistCell")
        let cell = cvWishList.dequeueReusableCell(withReuseIdentifier: "WishlistCell", for: indexPath) as! WishListCollectionViewCell
        
        var dicProducts = NSDictionary()
        dicProducts = arrWishlist[indexPath.item] as! NSDictionary
        
        if TValidation.isNull(dicProducts.value(forKey: FULL)) {
            cell.imgProduct.image = UIImage(named: "")
        }
        else {
            THelper.setImage(img: cell.imgProduct, url: URL(string: dicProducts.value(forKey: FULL) as! String)!, placeholderImage: "")
        }
            
        cell.lblProductName.text = dicProducts.value(forKey: "name") as? String
        
        if "\(dicProducts.value(forKey: SALES_PRICE) ?? "")" == "" {
            if "\(dicProducts.value(forKey: PRICE) ?? "")" == "" {
                cell.lblNewPrice.text = ""
            }else {
                cell.lblNewPrice.text = "\(PRICE_SIGN)\(dicProducts.value(forKey: PRICE) ?? "")"
            }
        }else {
            cell.lblNewPrice.text = "\(PRICE_SIGN)\(dicProducts.value(forKey: SALES_PRICE) ?? "")"
        }
        
        cell.lblOldPrice.isHidden = true
//        if "\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")" == "" {
//            if "\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")" == "" {
//                cell.lblOldPrice.text = ""
//            }else {
//                cell.lblOldPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
//            }
//        }else {
//            cell.lblOldPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
//        }

        cell.btnMoveToCart.tag = indexPath.item
        cell.btnMoveToCart.addTarget(self, action: #selector(onClickMoveToCart(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btnRemove.tag = dicProducts.value(forKey: PRO_ID) as! Int
        cell.btnRemove.addTarget(self, action: #selector(onClickWishlistDelete), for: UIControl.Event.touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if IPAD {
            return CGSize(width: cvWishList.frame.width - 32, height: 180)
        }else {
            return CGSize(width: cvWishList.frame.width - 24, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dicProducts = NSDictionary()
        dicProducts = arrWishlist[indexPath.item] as! NSDictionary
        
        let vc = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        vc.strProductID = "\(dicProducts.value(forKey: PRO_ID) ?? "")"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: -
    //MARK: - Cell UIButton Action Method
    
    @objc func onClickWishlistDelete(_ sender: UIButton?) {
        tag = sender!.tag
         THelper.displayAlert(self, title: "", message: "Are you sure you want to Remove this item from wishlist.", tag: 101, firstButton: "Cancel", doneButton: "OK")
    }
    
    @objc func onClickMoveToCart(_ sender: UIButton?) {
        let dicProducts:NSDictionary = arrWishlist[sender!.tag] as! NSDictionary
        
        var stock = Int()
        if TValidation.isNull(dicProducts.value(forKey: STOCK_QUANTITY)) {
            stock = 0
        }
        else {
            stock = dicProducts.value(forKey: STOCK_QUANTITY) as! Int
        }
        
        if stock < 1 {
            THelper.toast("Out of stock", vc: self)
        }
        else {
            remove_item_id = dicProducts.value(forKey: PRO_ID) as! Int
            addItemToCartAPI(Product_id: remove_item_id)
        }
    }
    
    //MARK: -
    //MARK: - fcAlertDoneButtonClicked
    
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView?) {
        if alertView?.tag == 101 {
           removeWishlistAPI(item_id: tag)
        }
    }
    
    //MARK:-
    //MARK:- UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:-
    //MARK:- API Calling
    
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
                            if TValidation.isNull(arrtemp[0]) || !TValidation.isArray(arrtemp[0]) {
                                self.arrWishlist = [] as NSArray
                            }
                            else {
                                self.arrWishlist = arrtemp[0] as! NSArray
                            }
                        }
                        else {
                            self.arrWishlist = [] as NSArray
                        }
                       
                        if self.arrWishlist.count > 0 {
                            self.lblNoDataFound.isHidden = true
                            self.cvWishList.isHidden = false
                        }
                        else {
                            self.lblNoDataFound.isHidden = false
                            self.cvWishList.isHidden = true
                        }
                        
                        TPreferences.writeString(WISHLIST_COUNT, value: "\(self.arrWishlist.count)")
                        DispatchQueue.main.async {
                            self.cvWishList.reloadData()
                        }
                    }
                    else {
                        print(data)
                        TPreferences.writeString(WISHLIST_COUNT, value: "0")
                        let dicError:NSDictionary = data as! NSDictionary
                        let str:String = dicError.value(forKey: "message") as! String
                        let arrTemp = NSArray()
                        self.arrWishlist = arrTemp
                        self.cvWishList.reloadData()
                        
                        self.lblNoDataFound.isHidden = false
                        self.cvWishList.isHidden = true
                        
                        THelper.toast(str.html2String, vc: self)
                    }
                }
                break
                
            case .failure(_):
                TPreferences.writeString(WISHLIST_COUNT, value: "0")
                THelper.hideProgress(vc: self)
                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                
                self.lblNoDataFound.isHidden = false
                self.cvWishList.isHidden = true
                
                print(response.result.error?.localizedDescription as Any)
                break
            }
        }
    }
    
    func removeWishlistAPI(item_id:Int) {
        THelper.ShowProgress(vc: self)
        
        let param = [PRO_ID:item_id
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_DELETE_WISHLIST)!, method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        self.getWishlistAPI()
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
    
    func addItemToCartAPI(Product_id:Int) {
        THelper.ShowProgress(vc: self)
        let param = [PRO_ID:Product_id,
                     "quantity":"1",
                     "color":"black",
                     "size":"XL"
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
                        THelper.toast("Item added to cart successfully...", vc: self)
                        THelper.getCartAPI()
                        self.removeWishlistAPI(item_id: self.remove_item_id)
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
