//
//  MyCartViewController.swift

import UIKit
import FCAlertView
import Alamofire
import OAuthSwiftAlamofire

class MyCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FCAlertViewDelegate {
    
    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwPaymentDetail: UIView!
    @IBOutlet weak var vwNoItemFound: UIView!
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    @IBOutlet weak var constraintTblCartHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintVwHeaderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tblCart: UITableView!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblOfferValue: UILabel!
    @IBOutlet weak var lblShippingCharge: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblShippingCharges: UILabel!
    @IBOutlet weak var lblTotalAmounts: UILabel!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblSeePriceDetail: UILabel!
    @IBOutlet weak var lblPaymentDetail: UILabel!
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var vwBottom: UIView!
    
    //MARK: -
    //MARK: - Variables
    
    let arrSelectedQty = NSMutableArray()
    let arrQty = NSMutableArray()
    var strQty = String()
    var tag = Int()
    var flagHeader = true
    var cartDeleteTag = Int()
    var arrCart = NSArray()
    var dicPaymentDetail = NSDictionary()
    var strCartItemKey = String()
    var isFormPayCard = Bool()
    var isNotification = Bool()
    var cardKey = String()
    var strProductID = String()
    var arrAddress = NSArray()
    var arrCollectionStepperTag = NSMutableArray()
    var stepperValue = Int()
    var arrStepperValue = NSMutableArray()
    var dicStepper = NSMutableDictionary()

    //MARK: -
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SetUpObject()
    }

    //MARK: -
    //MARK: - SetUpObject Method
    
    func SetUpObject(){
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        getAddressAPI()
        stepperValue = 1
        self.lblHeaderTitle.text = LanguageLocal.myLocalizedString(key: "My_Cart")
        self.lblPaymentDetail.text = LanguageLocal.myLocalizedString(key: "Payment_Detail")
        self.lblShippingCharges.text = LanguageLocal.myLocalizedString(key: "Shipping_Charges")
        self.lblTotalAmounts.text = LanguageLocal.myLocalizedString(key: "Total_Amount")
        self.lblSeePriceDetail.text = LanguageLocal.myLocalizedString(key: "See_Price_Detail")
        self.lblOffer.text = LanguageLocal.myLocalizedString(key: "Offer`")
        self.btnContinue.setTitle(LanguageLocal.myLocalizedString(key: "Continue"), for: .normal)
        
        if flagHeader == true {
            self.constraintVwHeaderHeight.constant = 0;
            self.constraintHeightArea.constant = 0;
            vwHeader.isHidden = true
        }else {
            if IPAD {
                self.constraintVwHeaderHeight.constant = 56;
            }else {
                self.constraintVwHeaderHeight.constant = 66;
            }
            vwHeader.isHidden = false
        }
        
        self.vwBottom.layer.shadowColor = UIColor.lightGray.cgColor
        self.vwBottom.layer.shadowOpacity = 5.0
        self.vwBottom.layer.shadowRadius = 10.0
        self.vwBottom.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNotification(_:)), name: NSNotification.Name("Address"), object: nil)
        
        getCartAPI()
    }
    
    func SetValue() {
        self.lblOfferValue.text = "Offer Not Available"
        self.lblShippingCharge.text = "Free"
        var price: Int = 0
        
        for i in 0..<arrCart.count {
            let dicCart: NSDictionary = arrCart[i] as! NSDictionary
            let qty: Int = Int("\(dicCart.value(forKey: "quantity") ?? "1")") ?? 1
            let strPrice: Int = Int("\(dicCart.value(forKey: PRICE) ?? "0")") ?? 0
            let strSalesPrice: Int = Int("\(dicCart.value(forKey: SALES_PRICE) ?? "0")") ?? 0
//            let qty: Int = Int("\(arrStepperValue[i])") ?? 1

            if "\(strSalesPrice)" == "0" {
                if "\(strPrice)" == "0" {
                    price = price + (strPrice * qty)
                }
                else {
                    price = price + (strPrice * qty)
                }
            }
            else {
                price = price + (strSalesPrice * qty)
            }
        }
        
        self.lblTotalPrice.text = "\(PRICE_SIGN)\(price)"
        self.lblTotalAmount.text = "\(PRICE_SIGN)\(price)"
    }
        
    func getCartArray() {
        let arrTemp:NSArray = THelper.getCart()
        if arrTemp.count > 0 {
            for i in 0..<arrTemp.count {
                let _:NSDictionary = arrTemp[i] as! NSDictionary
//                arrProduct.add(dicTemp)
            }
        }
        else {
//            arrProduct.removeAllObjects()
        }
    }
    
    @objc func receiveNotification(_ notification: Notification?) {
        isNotification = true
        if let aNotification = notification {
            print("\(aNotification)")
        }
        getAddressAPI()
    }
    
    //MARK: -
    //MARK: - UITableView DataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        constraintTblCartHeight.constant = CGFloat(175 * arrCart.count)
        return arrCart.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tblCart.register(UINib(nibName: "MyCartTableCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        let cell = tblCart.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! MyCartTableCell
        
        let dicCartTemp: NSDictionary = arrCart[indexPath.row] as! NSDictionary
        
        let qty: Int = Int("\(dicCartTemp.value(forKey: "quantity") ?? "1")") ?? 1
        let strPrice: Int = Int("\(dicCartTemp.value(forKey: PRICE) ?? "0")") ?? 0
        let strSalesPrice: Int = Int("\(dicCartTemp.value(forKey: SALES_PRICE) ?? "0")") ?? 0
        let strRegularPrice: String = "\(dicCartTemp.value(forKey: REGULAR_PRICE) ?? "")"
        
        cell.lblCount.text = "\(Int(qty))"
        cell.lblProductName.text = "\(dicCartTemp.value(forKey: "name") ?? "")"
        cell.lblSize.text = "\(dicCartTemp.value(forKey: "size") ?? "")"
        
        if "\(dicCartTemp.value(forKey: "color") ?? "")".contains("#") {
            cell.btnColor.backgroundColor = UIColor(hexString: "\(dicCartTemp.value(forKey: "color") ?? "")")
            cell.constrainBtnColorWidth.constant = 30
            cell.btnColor.isHidden = false
        }
        else {
            cell.constrainBtnColorWidth.constant = 0
            cell.btnColor.isHidden = true
        }
        
        if "\(strSalesPrice)" == "0" {
            if "\(strPrice)" == "0" {
                cell.lblAmount.text = ""
            }
            else {
                cell.lblAmount.text = "\(PRICE_SIGN)\(strPrice * qty)"
            }
        }
        else {
            cell.lblAmount.text = "\(PRICE_SIGN)\(strSalesPrice  * qty)"
        }
        
        cell.lblOldAmount.isHidden = true
//        if strRegularPrice == "" {
//            cell.lblOldAmount.text = ""
//        }
//        else {
//            cell.lblOldAmount.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(strRegularPrice)")
//        }
        
        let arrImages:NSArray = dicCartTemp.value(forKey: "gallery") as! NSArray
        if arrImages.count > 0 {
            let strImages:String = arrImages[0] as! String
            THelper.setImage(img: cell.imgProduct, url: URL(string: strImages)!, placeholderImage: "")
        }
        else {
            cell.imgProduct.image = UIImage(named: "")
        }
        
        cell.Stepper.tag = indexPath.item
        cell.Stepper.addTarget(self, action: #selector(collectionStepper_Clicked(_:)), for: .valueChanged)
                    
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(onClickCartDelete(_:)), for: UIControl.Event.touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicCartTemp: NSDictionary = arrCart[indexPath.row] as! NSDictionary
        
        let vc = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        vc.strProductID = "\(dicCartTemp.value(forKey: PRO_ID) ?? "")"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: -
    //MARK: -fcAlertDoneButtonClicked
    
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView?) {
        if alertView?.tag == 101 {
            let dicCart: NSDictionary = arrCart[cartDeleteTag] as! NSDictionary
            let productId: String = "\(dicCart.value(forKey: PRO_ID) ?? "")"
            deleteItemFromCartAPI(id: productId)
        }
    }
    
    //MARK: -
    //MARK: - UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        if isFormPayCard == true {
            self.dismiss(animated: true, completion: nil)
        }else {
         self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnSeePriceDetail_Clicked(_ sender: Any) {
        let frame = CGRect(x: 0, y: vwPaymentDetail.frame.origin.y, width: vwPaymentDetail.frame.width, height: vwPaymentDetail.frame.height)
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    @IBAction func btnContinueClicked(_ sender: Any) {
        if arrAddress.count > 0 {
            let vc = OrderSummaryViewController(nibName: "OrderSummaryViewController", bundle: nil)
            vc.arrCart = self.arrCart
            vc.strAmount = self.lblTotalAmount.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = AddEditAddressViewController(nibName: "AddEditAddressViewController", bundle: nil)
            self.present(vc, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    @IBAction func btnDone_Clicked(_ sender: Any) {
//        let dicCart: NSDictionary = arrCart[tag] as! NSDictionary
//        let productId: String = "\(dicCart.value(forKey: PRO_ID) ?? "")"
//        let cartId: String = "\(dicCart.value(forKey: "cart_id") ?? "")"
//
//
//        vwPicker.isHidden = true
//    }
//
//    @IBAction func btnCancel_Clicked(_ sender: Any) {
//        vwPicker.isHidden = true
//    }
    
    //MARK: -
    //MARK: - Cell UIButton Action Method
    
    @objc func collectionStepper_Clicked(_ sender: UIStepper) {
        let dicCart: NSDictionary = arrCart[sender.tag] as! NSDictionary
        let productId: String = "\(dicCart.value(forKey: PRO_ID) ?? "")"
        let cartId: String = "\(dicCart.value(forKey: "cart_id") ?? "")"
    
        updateItemInCartAPI(productId: productId, cartId: cartId,strQty: Int(sender.value))
       
    }
    
    
    @objc func onClickCartQty(_ sender: UIButton?) {
        arrQty.removeAllObjects()
        tag = sender!.tag
        let dicCartTemp: NSDictionary = arrCart[tag] as! NSDictionary
        
        var stock = Int()
        if TValidation.isNull(dicCartTemp.value(forKey: STOCK_QUANTITY)) {
            stock = 0
        }
        else {
            stock = dicCartTemp.value(forKey: STOCK_QUANTITY) as! Int
        }
        
        if stock < 1 {
            THelper.toast("Out of stock", vc: self)
//            vwPicker.isHidden = true
        }
        else {
            for i in 1..<stock + 1 {
                arrQty.add("\(i)")
            }
//            qtyPicker.reloadAllComponents()
//            vwPicker.isHidden = false
        }
    }
    
    @objc func onClickCartDelete(_ sender: UIButton?) {
        THelper.displayAlert(self, title: "", message: "Are you sure you want to remove this item from Cart", tag: 101, firstButton: "Cancel", doneButton: "OK")
        cartDeleteTag = sender!.tag
    }
        
    @IBAction func btnShopNow_Clicked(_ sender: Any) {
        let vc = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
        AppDelegate.getDelegate()?.navigationController = TNavigationViewController(rootViewController: vc)
        AppDelegate.getDelegate()?.navigationController.isNavigationBarHidden = true
        if let aController = AppDelegate.getDelegate()?.navigationController {
            self.frostedViewController.contentViewController = aController
        }
    }
    
    //MARK:-
    //MARK:- API Calling
    
    func getCartAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
                
        sessionManager.request(TPreferences.getCommonURL(NEW_GET_CART)!, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp:NSArray = THelper.getCartArray()
                        if TValidation.isArray(data) {
                            self.arrCart = data  as! NSArray
                            self.tblCart.reloadData()
                            self.SetValue()
                            self.vwNoItemFound.isHidden = true
                            
                            TPreferences.writeString(CART_ITEM_COUNT, value: "\(self.arrCart.count)")
                        }
                        else {
                            TPreferences.writeString(CART_ITEM_COUNT, value: "0")
                            if arrtemp.count > 0 {
                                self.vwNoItemFound.isHidden = true
                            }
                            else {
                                self.vwNoItemFound.isHidden = false
                            }
                            
                            let arrTemp = NSArray()
                            self.arrCart = arrTemp
                            self.tblCart.reloadData()
                            THelper.toast("Cart empty", vc: self)
                        }
                    }
                    else {
                        print(data)
                        TPreferences.writeString(CART_ITEM_COUNT, value: "0")
                        let dicError:NSDictionary = data as! NSDictionary
                        let str:String = dicError.value(forKey: "message") as! String
                        THelper.toast(str.html2String, vc: self)
                        self.vwNoItemFound.isHidden = false
                    }
                }
                break
                
            case .failure(_):
                THelper.hideProgress(vc: self)
                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                self.vwNoItemFound.isHidden = false
                break
            }
        }
    }
    
    func deleteItemFromCartAPI(id: String) {
        THelper.ShowProgress(vc: self)
        let param = [PRO_ID:id
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_DELETE_CART)!, method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        self.getCartAPI()
                    }
                    else {
                        print(data)
                        self.getCartAPI()
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
    
    func updateItemInCartAPI(productId: String, cartId: String,strQty: Int) {
        THelper.ShowProgress(vc: self)
        let param = [PRO_ID:productId,
                     "quantity":strQty,
                     "cart_id":cartId
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_UPDATE_CART)!, method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        self.getCartAPI()
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
    
    func addItemToCartAPI(strProductID:String, strQuentity:String) {
        THelper.ShowProgress(vc: self)
        let param = ["product_id":strProductID,
                     "quantity":strQuentity
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(ADD_CART_ITEM)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    print(response.response?.statusCode ?? "")
                    if response.response?.statusCode == 200 {
                        print(data)
                        self.getCartAPI()
                        THelper.toast("Item added to cart successfully...", vc: self)
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
    
    func getAddressAPI() {
        THelper.ShowProgress(vc: self)
                                
        Alamofire.request(TPreferences.getCommonURL(NEW_GET_ADDRESS)!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    THelper.hideProgress(vc: self)
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            print(data)
                            if TValidation.isArray(data) {
                                self.arrAddress = data as! NSArray
                            }
                            else {
                                self.arrAddress = []
                            }
                        }
                        else {
                            print(data)
//                            let dicError:NSDictionary = data as! NSDictionary
//                            let str:String = dicError.value(forKey: "message") as! String
//                            THelper.toast(str.html2String, vc: self)
                        }
                    }
                    break
                    
                case .failure(_):
                    THelper.hideProgress(vc: self)
//                    THelper.toast(ERROR_MSG, vc: self)
//                    print(response.result.error?.localizedDescription ?? "Something went wrong")
    //                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                    break
                }
            }
        }
}
