//
//  NewestProductListViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire

class NewestProductListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:-
    //MARK:- Outlets
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    
    @IBOutlet weak var cvNewestProductList: UICollectionView!
    
    @IBOutlet weak var ConstraintBtnFilterWidth: NSLayoutConstraint!
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var btnFillter: UIButton!
    
    @IBOutlet weak var lblCartCount: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    
    //MARK:-
    //MARK:- Variables
    
    let arrLikePackage = NSMutableArray()
    let arrItem = NSMutableArray()
    var arrProducts = NSMutableArray()
    var strHeading = String()
    var arrRecentSearch = NSMutableArray()
    var arrSelectedProduct = NSMutableArray()
    var arrFeaturedProduct = NSMutableArray()
    var strCategoryId = String()
    var arrCategoryProducts = NSArray()
    var arrBrands = NSArray()
    var arrColor = NSArray()
    var arrSize = NSArray()
    var arrCategory = NSArray()
    var arrWishlist = NSArray()
    var page = Int()
    var totalPage = Int()
    
    //MARK:-
    //MARK:- View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.cvNewestProductList.reloadData()
        self.cvNewestProductList.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpValue()
    }
    
    //MARK: -
    //MARK: - SetUpView
    
    func SetUpValue() {
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        
        lblHeading.text = strHeading
        
        if lblHeading.text == "Recent Search" {
            self.btnFillter.isHidden = true
            self.ConstraintBtnFilterWidth.constant = 0
        }else {
            self.btnFillter.isHidden = false
            if IPAD {
                self.ConstraintBtnFilterWidth.constant = 50
            }else {
                self.ConstraintBtnFilterWidth.constant = 40
            }
        }
        
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            self.lblCartCount.isHidden = false
            self.lblCartCount.text = TPreferences.readString(CART_ITEM_COUNT)
            if IPAD {
                self.lblCartCount.layer.cornerRadius = 20 / 2
            }else{
                self.lblCartCount.layer.cornerRadius = self.lblCartCount.layer.frame.height / 2
            }
        }else {
            self.lblCartCount.isHidden = true
            self.lblCartCount.text = ""
        }
        
//        let layout = cvNewestProductList.collectionViewLayout as? UICollectionViewFlowLayout
//        layout?.itemSize = cvNewestProductList.frame.size
//
//        if let aLayout = layout {
//            layout?.estimatedItemSize = CGSize(width: 1, height: 1)
//            cvNewestProductList.collectionViewLayout = aLayout
//        }
        

        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNotification(_:)), name: NSNotification.Name("filter"), object: nil)
        
        if strHeading == "Recent Search" || strHeading == NEWEST_PRODUCT || strHeading == FEATURED_PRODUCTS || strHeading == NEW_ARRIVAL || strHeading == DEAL_PRODUCT || strHeading == SUGGESTED_PRODUCT || strHeading == OFFER || strHeading == YOU_MAY_LIKE {
            let arrtemp:NSArray = THelper.getArray()
            if arrtemp.count > 0 {
                for i in 0..<arrtemp.count {
                    arrRecentSearch.add(arrtemp[i])
                }
            }
            else {
                arrRecentSearch.removeAllObjects()
            }
        }
        
        page = 1
        if strHeading == NEW_ARRIVAL {
            getProductCategoriesAPI()
        }
        else {
            if strHeading == FEATURED_PRODUCTS {
                getFeaturedProductAPI(page: page)
            }
            else {
                getProductAPI(page: page)
            }
        }
        
        getProductAttributeAPI()
    }
    
    // MARK: -
    // MARK: - Receive Notification
    
    @objc func receiveNotification(_ notification: Notification?) {
        if let aNotification = notification {
            print("\(aNotification)")
        }
        let params : [String : Any] = notification?.userInfo?["filters"] as! [String : Any]
        filterProductAPI(params: params)
    }
    
    //MARK: -
    //MARK: -UICollectionView Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        cvNewestProductList.register(UINib(nibName: "NewestProductListHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"Header")
        var headerView = NewestProductListHeaderReusableView()

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            headerView = cvNewestProductList.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! NewestProductListHeaderReusableView
            
            if TPreferences.readBoolean(ISLISTING) {
                headerView.btnList = THelper.setButtonTintColor(headerView.btnList, imageName: "icoList", state: .normal, tintColor: ThemeManager.shared().color(forKey: "Primary_Default_Color"))
                headerView.btnGrid = THelper.setButtonTintColor(headerView.btnGrid, imageName: "icoGrid", state: .normal, tintColor: .lightGray)
            }
            else {
                headerView.btnList = THelper.setButtonTintColor(headerView.btnList, imageName: "icoList", state: .normal, tintColor: .lightGray)
                headerView.btnGrid = THelper.setButtonTintColor(headerView.btnGrid, imageName: "icoGrid", state: .normal, tintColor: ThemeManager.shared().color(forKey: "Primary_Default_Color"))
            }
            
            headerView.btnList.addTarget(self, action: #selector(onClickList(_:)), for: UIControl.Event.touchUpInside)
            headerView.btnGrid.addTarget(self, action: #selector(onClickGrid(_:)), for: UIControl.Event.touchUpInside)
            
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if strHeading == "Recent Search" {
            return arrRecentSearch.count
        }
        else if strHeading == FEATURED_PRODUCTS {
            return arrFeaturedProduct.count
        }
        else if strHeading == NEW_ARRIVAL {
            return arrCategoryProducts.count
        }
        else {
            return arrProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if TPreferences.readBoolean(ISLISTING) {
            cvNewestProductList.register(UINib(nibName: "NewestProductListCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
            let cell = cvNewestProductList.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! NewestProductListCollectionCell
            
            var dicProducts = NSDictionary()
            
                if strHeading == "Recent Search" {
                    dicProducts = arrRecentSearch[indexPath.item] as! NSDictionary
                }
                else if strHeading == FEATURED_PRODUCTS {
                    dicProducts = arrFeaturedProduct[indexPath.item] as! NSDictionary
                }
                else if strHeading == NEW_ARRIVAL {
                    dicProducts = arrCategoryProducts[indexPath.item] as! NSDictionary
                }
                else {
                    dicProducts = arrProducts[indexPath.item] as! NSDictionary
                }
            
            if dicProducts.value(forKey: "average_rating") != nil {
                let rating = "\(dicProducts.value(forKey: "average_rating") ?? 0.0)"
                cell.vwProductRating.rating = Double(rating)!
            }
            else {
                cell.vwProductRating.rating = 0.0
            }
            
            cell.vwProductLikeBackground.backgroundColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            cell.btnProductLike = THelper.setButtonTintColor(cell.btnProductLike, imageName: "icoHeart", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Secondary_Color1"))
            
            if arrWishlist.count > 0 {
                for i in 0..<arrWishlist.count {
                    let dicWishlist: NSDictionary = arrWishlist[i] as! NSDictionary
                    if "\(dicWishlist.value(forKey: PRO_ID) ?? "")" == "\(dicProducts.value(forKey: PRO_ID) ?? "")" {
                        cell.vwProductLikeBackground.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
                        cell.btnProductLike = THelper.setButtonTintColor(cell.btnProductLike, imageName: "icoHeartFill", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
                        
                        break
                    }
                }
            }
                
                if dicProducts.allKeys.count > 0 {
                    if TValidation.isNull(dicProducts.value(forKey: FULL)) {
                        cell.imgProduct.image = UIImage(named: "")
                    }
                    else {
                        let strImages:String = dicProducts.value(forKey: FULL) as! String
                        THelper.setImage(img: cell.imgProduct, url: URL(string: strImages)!, placeholderImage: "")
                    }
                
                cell.lblProductName.text = dicProducts.value(forKey: "name") as? String
                    
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
                }else {
                    cell.lblOldProductPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
                }
                    
                cell.lblProductRaing.text = "\(dicProducts.value(forKey: "average_rating") ?? "")"
                
                cell.btnProductLike.tag = indexPath.item
                cell.btnProductLike.addTarget(self, action: #selector(onClickLikeProduct(_:)), for: UIControl.Event.touchUpInside)
            }
                
            return cell
        }
        else {
            cvNewestProductList.register(UINib(nibName: "NewestProductGridCollectionCell", bundle: nil), forCellWithReuseIdentifier: "GridCell")
            let cell = cvNewestProductList.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! NewestProductGridCollectionCell
            
            var dicProducts = NSDictionary()
            if strHeading == "Recent Search" {
                dicProducts = arrRecentSearch[indexPath.item] as! NSDictionary
            }
            else if strHeading == FEATURED_PRODUCTS {
                dicProducts = arrFeaturedProduct[indexPath.item] as! NSDictionary
            }
            else if strHeading == NEW_ARRIVAL {
                dicProducts = arrCategoryProducts[indexPath.item] as! NSDictionary
            }
            else {
                dicProducts = arrProducts[indexPath.item] as! NSDictionary
            }
            
            if dicProducts.value(forKey: "average_rating") != nil {
                let rating = "\(dicProducts.value(forKey: "average_rating") ?? 0.0)"
                cell.vwProductRating.rating = Double(rating)!
            }
            else {
                cell.vwProductRating.rating = 0.0
            }
            
            cell.vwProductLkeBackground.backgroundColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            cell.btnProductLike = THelper.setButtonTintColor(cell.btnProductLike, imageName: "icoHeart", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Secondary_Color1"))
            
            if arrWishlist.count > 0 {
                for i in 0..<arrWishlist.count {
                    let dicWishlist: NSDictionary = arrWishlist[i] as! NSDictionary
                    if "\(dicWishlist.value(forKey: PRO_ID) ?? "")" == "\(dicProducts.value(forKey: PRO_ID) ?? "")" {
                        cell.vwProductLkeBackground.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
                        cell.btnProductLike = THelper.setButtonTintColor(cell.btnProductLike, imageName: "icoHeartFill", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
                    }
                }
            }
            
            if dicProducts.allKeys.count > 0 {
                if TValidation.isNull(dicProducts.value(forKey: FULL)) {
                    cell.imgProduct.image = UIImage(named: "")
                }
                else {
                    let strImages:String = dicProducts.value(forKey: FULL) as! String
                    THelper.setImage(img: cell.imgProduct, url: URL(string: strImages)!, placeholderImage: "")
                }
                
                cell.lblProductName.text = dicProducts.value(forKey: "name") as? String
                
                if "\(dicProducts.value(forKey: SALES_PRICE) ?? "")" == "" {
                    if "\(dicProducts.value(forKey: PRICE) ?? "")" == "" {
                        cell.lblProductNewPrice.text = ""
                    }else {
                        cell.lblProductNewPrice.text = "\(PRICE_SIGN)\(dicProducts.value(forKey: PRICE) ?? "")"
                    }
                }else {
                    cell.lblProductNewPrice.text = "\(PRICE_SIGN)\(dicProducts.value(forKey: SALES_PRICE) ?? "")"
                }
                
                if "\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")" == "" {
                    if "\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")" == "" {
                        cell.lblProductOldPrice.text = ""
                    }else {
                        cell.lblProductOldPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
                    }
                }else {
                    cell.lblProductOldPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
                }
                
                cell.btnProductLike.tag = indexPath.item
                cell.btnProductLike.addTarget(self, action: #selector(onClickLikeProduct(_:)), for: UIControl.Event.touchUpInside)
                
//                if arrLikePackage.contains(indexPath.item) {
//                    cell.vwProductLkeBackground.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
//                    cell.btnProductLike = THelper.setButtonTintColor(cell.btnProductLike, imageName: "icoHeartFill", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
//                }
//                else {
//                    cell.vwProductLkeBackground.backgroundColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
//                    cell.btnProductLike = THelper.setButtonTintColor(cell.btnProductLike, imageName: "icoHeart", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Secondary_Color1"))
//                }
                
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if strHeading == FEATURED_PRODUCTS {
            if indexPath.item >= arrFeaturedProduct.count - 1 {
                page = page + 1
                if page > totalPage {}
                else {
                    getFeaturedProductAPI(page: page)
                }
            }
        }
        else {
            if indexPath.item >= arrProducts.count - 1 {
                page = page + 1
                if page > totalPage {}
                else {
                    getProductAPI(page: page)
                }
            }
        }
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if TPreferences.readBoolean(ISLISTING) {
        if IPAD{
            return CGSize(width: cvNewestProductList.frame.width - 24, height: 200)
        }else {
            return CGSize(width: cvNewestProductList.frame.width - 24, height: 140)
        }
    }
    else {
        if IPAD {
            return CGSize(width: (cvNewestProductList.frame.width / 2) - 16, height: 350)
        }else {
            return CGSize(width: (cvNewestProductList.frame.width / 2) - 16, height: 250)
        }
    }
   }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dicProducts = NSDictionary()
        var contains = Bool()
        
        if strHeading == NEWEST_PRODUCT {
            dicProducts = arrProducts[indexPath.item] as! NSDictionary
        }
        else if strHeading == FEATURED_PRODUCTS {
            dicProducts = arrFeaturedProduct[indexPath.item] as! NSDictionary
        }
        else if strHeading == NEW_ARRIVAL {
            dicProducts = arrCategoryProducts[indexPath.item] as! NSDictionary
        }
        else {
            dicProducts = arrProducts[indexPath.item] as! NSDictionary
        }
        
        if arrRecentSearch.count > 0 {
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
                TPreferences.writeObject(RECENT_SEARCH, value: arrRecentSearch)
            }
        }
        else {
            arrRecentSearch.add(dicProducts)
            TPreferences.writeObject(RECENT_SEARCH, value: arrRecentSearch)
            print(TPreferences.readObject(RECENT_SEARCH) ?? "")
        }
        
        let vc = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        vc.strProductID = "\(dicProducts.value(forKey: PRO_ID) ?? "")"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: -
    //MARK: - Cell UIButton Action Method
    
    @objc func onClickList(_ sender: UIButton?) {
        TPreferences.writeBoolean(ISLISTING, value: true)
        cvNewestProductList.reloadData()
    }
    
    @objc func onClickGrid(_ sender: UIButton?) {
        TPreferences.writeBoolean(ISLISTING, value: false)
        cvNewestProductList.reloadData()
    }
    
    @objc func onClickLikeProduct(_ sender: UIButton?) {
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            var dicProducts = NSDictionary()
            if strHeading == "Recent Search" {
                dicProducts = arrRecentSearch[sender!.tag] as! NSDictionary
            }
            else if strHeading == FEATURED_PRODUCTS {
                dicProducts = arrFeaturedProduct[sender!.tag] as! NSDictionary
            }
            else if strHeading == NEW_ARRIVAL {
                dicProducts = arrCategoryProducts[sender!.tag] as! NSDictionary
            }
            else {
                dicProducts = arrProducts[sender!.tag] as! NSDictionary
            }
            
            if arrWishlist.count > 0 {
                for i in 0..<arrWishlist.count {
                    let dicWishlist: NSDictionary = arrWishlist[i] as! NSDictionary
                    if "\(dicWishlist.value(forKey: PRO_ID) ?? "")" == "\(dicProducts.value(forKey: PRO_ID) ?? "")" {
                        removeWishlistAPI(strProductID: "\(dicProducts.value(forKey: PRO_ID) ?? "")")
                    }
                    else {
                        addProductToWishlistAPI(strProductID: "\(dicProducts.value(forKey: PRO_ID) ?? "")")
                    }
                }
            }
            else {
                addProductToWishlistAPI(strProductID: "\(dicProducts.value(forKey: PRO_ID) ?? "")")
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
    
    
    @IBAction func btnCart_Clicked(_ sender: Any) {
        let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
        vc.flagHeader = false
        vc.isFormPayCard = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnFilter_Clicked(_ sender: Any) {
        let vc = FilterViewController(nibName: "FilterViewController", bundle: nil)
        vc.arrBrands = self.arrBrands
        vc.arrColor = self.arrColor
        vc.arrSize = self.arrSize
        vc.arrCategory = self.arrCategory
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnSearch_Clicked(_ sender: Any) {
        let vc = SearchViewController(nibName: "SearchViewController", bundle: nil)
        vc.isFormPayCard = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:-
    //MARK:- API Calling
    
    func getProductAPI(page: Int) {
        THelper.ShowProgress(vc: self)
        
        let param = ["page":page
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
                
        sessionManager.request(TPreferences.getCommonURL(NEW_FILTER)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
//                        self.arrProducts.removeAllObjects()
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
//                        self.getWishlistAPI()
                        
                        let arrTempProduct:NSArray = arrtemp[0] as! NSArray
                        var dicProduct = NSDictionary()
                        
                        for i in 0..<arrTempProduct.count {
                            dicProduct = arrTempProduct[i] as! NSDictionary
                            self.totalPage = dicProduct.value(forKey: NO_OF_PAGES) as! Int
                            self.arrProducts.add(dicProduct)
                        }
                        
                        DispatchQueue.main.async {
                            self.cvNewestProductList.reloadData()
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
    
    func getFeaturedProductAPI(page: Int) {
            THelper.ShowProgress(vc: self)
        
        let param = ["page":page
            ] as [String : Any]
        print(param)
            
            let sessionManager = SessionManager.default
            sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
            
            sessionManager.request(TPreferences.getCommonURL(NEW_FEATURED_PRODUCT)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    THelper.hideProgress(vc: self)
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            print(data)
                            let arrTemp: NSArray = data as! NSArray
                            for i in 0..<arrTemp.count {
                                let dicFeaturedProduct: NSDictionary = arrTemp[i]  as! NSDictionary
                                self.totalPage = dicFeaturedProduct.value(forKey: NO_OF_PAGES) as! Int
                                self.arrFeaturedProduct.add(dicFeaturedProduct)
                            }
                            
                            DispatchQueue.main.async {
                                self.cvNewestProductList.reloadData()
                            }
                        }
                        else {
                            print(data)
                            self.cvNewestProductList.reloadData()
                            
                            let dicError:NSDictionary = data as! NSDictionary
                            let str:String = dicError.value(forKey: "message") as! String
                            THelper.toast(str.html2String, vc: self)
                        }
                    }
                    break
                    
                case .failure(_):
                    self.cvNewestProductList.reloadData()
                    
                    THelper.hideProgress(vc: self)
                    THelper.toast(ERROR_MSG, vc: self)
                    print(response.result.error?.localizedDescription ?? "Something went wrong")
    //                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                    break
                }
            }
        }
    
    func getProductCategoriesAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL("\(NEW_PRODUCTS)?category=\(strCategoryId)")!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        self.arrCategoryProducts = arrtemp[0] as! NSArray
                        self.cvNewestProductList.reloadData()
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
        
    func addProductToWishlistAPI(strProductID: String) {
            let param = [PRO_ID:strProductID
                ] as [String : Any]
            print(param)
            
            let sessionManager = SessionManager.default
            sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())

            sessionManager.request(TPreferences.getCommonURL(NEW_ADD_WISHLIST)!, method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            print(data)
                            self.getWishlistAPI()
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
    //                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                    break
                }
            }
        }
    
    func getProductAttributeAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_PRODUCT_ATTRIBUTE)!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value {
                    if response.response?.statusCode == 200 {
                        print(data)
                        let dicAttribute : NSDictionary = data as! NSDictionary
                        
                        self.arrBrands = dicAttribute.value(forKey: "brands") as! NSArray
                        self.arrColor = dicAttribute.value(forKey: "colors") as! NSArray
                        self.arrSize = dicAttribute.value(forKey: "sizes") as! NSArray
                        self.arrCategory = dicAttribute.value(forKey: "categories") as! NSArray
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
    
    func filterProductAPI(params : [String : Any]) {
        THelper.ShowProgress(vc: self)
                
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_FILTER)!,method: .post, parameters: params, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value {
                    
                    self.arrProducts.removeAllObjects()
                    
                    if response.response?.statusCode == 200 {
                        print(data)
                        
                        let arrTempProduct:NSArray = data as! NSArray
                        var dicProduct = NSDictionary()

                        for i in 0..<arrTempProduct.count {
                            dicProduct = arrTempProduct[i] as! NSDictionary
                            if (dicProduct.value(forKey: "in_stock") != nil) == true || dicProduct.value(forKey: "stock_status") as! String == "instock" {
                                self.arrProducts.add(dicProduct)
                            }
                        }

                        DispatchQueue.main.async {
                            self.cvNewestProductList.reloadData()
                        }
                        
                    }
                    else {
                        print(data)
                        self.cvNewestProductList.reloadData()
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
    
    func getWishlistAPI() {
//        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_GET_WISHLIST)!, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
//                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        if TValidation.isArray(arrtemp[0]) {
                            self.arrWishlist = arrtemp[0] as! NSArray
                        }
                        else {
                            self.arrWishlist = [] as NSArray
                        }
                        
                        self.cvNewestProductList.reloadData()
                        TPreferences.writeString(WISHLIST_COUNT, value: "\(self.arrWishlist.count)")
                    }
                    else {
                        print(data)
                        TPreferences.writeString(WISHLIST_COUNT, value: "0")
                        let dicError:NSDictionary = data as! NSDictionary
                        let _:String = dicError.value(forKey: "message") as! String
                        let arrTemp = NSArray()
                        self.arrWishlist = arrTemp
//                        THelper.toast(str.html2String, vc: self)
                    }
                }
                break
                
            case .failure(_):
                TPreferences.writeString(WISHLIST_COUNT, value: "0")
//                THelper.hideProgress(vc: self)
//                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                break
            }
        }
    }
    
    func removeWishlistAPI(strProductID: String) {
            let param = [PRO_ID:strProductID
                ] as [String : Any]
            print(param)
            
            let sessionManager = SessionManager.default
            sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
            
            sessionManager.request(TPreferences.getCommonURL(NEW_DELETE_WISHLIST)!, method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            print(data)
                            self.getWishlistAPI()
                            self.cvNewestProductList.reloadData()
                        }
                        else {
                            print(data)
                        }
                    }
                    break
                    
                case .failure(_):
                    break
                }
            }
        }
}
