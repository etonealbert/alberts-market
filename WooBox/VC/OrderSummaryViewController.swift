//
//  OrderSummaryViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire

class OrderSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    @IBOutlet weak var constraintTblProductHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTblAddressHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintVwHeaderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwAddAddressBackground: UIView!
    @IBOutlet weak var vwAddAddress: UIView!
    @IBOutlet weak var vwPaymentDetail: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tblProduct: UITableView!
    @IBOutlet weak var tblAddress: UITableView!
    
    @IBOutlet weak var btnChangeAddress: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnItemDeliverHere: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddressType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var lblOrderSummary: UILabel!
    @IBOutlet weak var lblPaymentDetail: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblShippingCharges: UILabel!
    @IBOutlet weak var lblSeePriceDetail: UILabel!
    @IBOutlet weak var lblAddNewAddress: UILabel!
    
    @IBOutlet weak var lblOfferValue: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblShippingValue: UILabel!
    @IBOutlet weak var lblTotalPriceDetail: UILabel!
    
    @IBOutlet weak var imgOffer: UIImageView!
    
    //MARK: -
    //MARK: - Varibles
    
    let arrSelectedQty = NSMutableArray()
    var tag = Int()
    var AddressIndex = Int()
    var arrCart = NSArray()
    var arrAddress = NSArray()
    var dicPaymentDetail = NSDictionary()
    var arrOrderProducts = NSMutableArray()
    var count = Int()
    var strAmount = String()
    var dicAddress12 = NSDictionary()
    
    //MARK: -
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpObject()
    }

    //MARK: -
    //MARK: - SetUpObject Method
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        getAddressAPI()
        SetValue()
        
        lblAddNewAddress.text = LanguageLocal.myLocalizedString(key: "Add_New_Address")
        self.lblOrderSummary.text = LanguageLocal.myLocalizedString(key: "Order_Summary")
        self.lblPaymentDetail.text = LanguageLocal.myLocalizedString(key: "Payment_Detail")
        self.lblOffer.text = LanguageLocal.myLocalizedString(key: "Offers")
        self.lblShippingCharges.text = LanguageLocal.myLocalizedString(key: "Shipping_Charges")
        self.lblTotalAmount.text = LanguageLocal.myLocalizedString(key: "Total_Amount")
        self.lblSeePriceDetail.text = LanguageLocal.myLocalizedString(key: "See_Price_Detail")
        self.btnChangeAddress.setTitle(LanguageLocal.myLocalizedString(key: "Change_Address")
            , for: .normal)
        self.btnContinue.setTitle(LanguageLocal.myLocalizedString(key: "Continue"), for: .normal)
        self.btnItemDeliverHere.setTitle(LanguageLocal.myLocalizedString(key: "Item_Deliver_Here")
            , for: .normal)
        self.vwBottom.layer.shadowColor = UIColor.lightGray.cgColor
        self.vwBottom.layer.shadowOpacity = 5.0
        self.vwBottom.layer.shadowRadius = 10.0
        self.vwBottom.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        vwAddAddress.layer.cornerRadius = 10.0
        vwAddAddress.layer.masksToBounds = true
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwAddAddressBackground.addGestureRecognizer(tapGesture)
        
        getProductOrderAPI()
        count = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNotification(_:)), name: NSNotification.Name("Address"), object: nil)
//        TPreferences.removePreference(ADDRESS)
        self.PaymentAPI()
    }
    
    func SetUpValue() {
        AddressIndex = Int(TPreferences.readString(SELECTED_ADDRESS) ?? "0") ?? 0
        
        let dicAddress:NSDictionary = arrAddress[AddressIndex] as! NSDictionary
        lblName.text = "\(dicAddress.value(forKey: "first_name") ?? "") \(dicAddress.value(forKey: "last_name") ?? "")"
        lblAddressType.text = "\(dicAddress.value(forKey: "country") ?? "")"
        lblAddress.text = "\(dicAddress.value(forKey: "address_1") ?? ""), \(dicAddress.value(forKey: "city") ?? "")-\(dicAddress.value(forKey: "postcode") ?? ""), \(dicAddress.value(forKey: "state") ?? "")"
        lblContactNo.text = "\(dicAddress.value(forKey: "contact") ?? "")"
    }
    
    func SetValue() {
        self.lblOfferValue.text = "Offer Not Available"
        self.lblShippingValue.text = "Free"
        
        self.lblTotalPrice.text = strAmount
        self.lblTotalPriceDetail.text = strAmount
    }
    
    //MARK: -
    //MARK: - Other Methods
    
    @objc func receiveNotification(_ notification: Notification?) {
        if let aNotification = notification {
            print("\(aNotification)")
        }
        getAddressAPI()
    }
    
    @objc func changeImage() {
        if arrOrderProducts.count == count {
            count = 0
        }
        THelper.setImage(img: self.imgOffer, url: URL(string: arrOrderProducts[count] as! String)!, placeholderImage: "")
        //        ImgOffer1.image = UIImage(named: arrImages[count])
        count = count + 1
    }
    
    //MARK: -
    //MARK: - UITableView DataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblProduct {
            if IPAD {
                constraintTblProductHeight.constant = CGFloat(200 * arrCart.count)
            }else {
                constraintTblProductHeight.constant = CGFloat(130 * arrCart.count)
            }
            return arrCart.count
        }
        else {
            if arrAddress.count > 2 {
                constraintTblAddressHeight.constant = 200 * 2
            }
            else {
                constraintTblAddressHeight.constant = CGFloat(200 * arrAddress.count)
            }
            return arrAddress.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblProduct {
            if IPAD {
                 return 200
            }else {
                 return 130
            }
           
        }
        else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblProduct {
            tblProduct.register(UINib(nibName: "OrderSummaryProductTableCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! OrderSummaryProductTableCell
            
            let dicCartTemp: NSDictionary = arrCart[indexPath.row] as! NSDictionary
                        
            let qty: Int = Int("\(dicCartTemp.value(forKey: "quantity") ?? "1")") ?? 1
            let strPrice: Int = Int("\(dicCartTemp.value(forKey: PRICE) ?? "0")") ?? 0
            let strSalesPrice: Int = Int("\(dicCartTemp.value(forKey: SALES_PRICE) ?? "0")") ?? 0
            let strRegularPrice: String = "\(dicCartTemp.value(forKey: REGULAR_PRICE) ?? "")"
            
            cell.lblQuentity.text = "\(qty)"
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
            
            if strRegularPrice == "" {
                cell.lblOldAmount.text = ""
            }
            else {
                cell.lblOldAmount.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(strRegularPrice)")
            }
            
            let arrImages:NSArray = dicCartTemp.value(forKey: "gallery") as! NSArray
            if arrImages.count > 0 {
                let strImages:String = arrImages[0] as! String
                THelper.setImage(img: cell.imgProduct, url: URL(string: strImages)!, placeholderImage: "")
            }
            else {
                cell.imgProduct.image = UIImage(named: "")
            }
            
            cell.lblOldAmount.isHidden = true
            cell.selectionStyle = .none
            return cell
        }
        else {
            tblAddress.register(UINib(nibName: "AddressTableCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressTableCell
            
            let dicAddress:NSDictionary = arrAddress[indexPath.row] as! NSDictionary
            cell.lblName.text = "\(dicAddress.value(forKey: "first_name") ?? "") \(dicAddress.value(forKey: "last_name") ?? "")"
            cell.lblAddressType.text = "\(dicAddress.value(forKey: "country") ?? "")"
            cell.lblAddress.text = "\(dicAddress.value(forKey: "address_1") ?? ""), \(dicAddress.value(forKey: "city") ?? "")-\(dicAddress.value(forKey: "postcode") ?? ""), \(dicAddress.value(forKey: "state") ?? "")"
            cell.lblContactNo.text = "\(dicAddress.value(forKey: "contact") ?? "")"
            
            if AddressIndex == indexPath.row {
                cell.btnCheck.setImage(UIImage(named: "icoRadioChecked"), for: .normal)
                cell.btnEdit.isHidden = false
            }
            else {
                cell.btnCheck.setImage(UIImage(named: "icoRadioUnchecked"), for: .normal)
                cell.btnEdit.isHidden = true
            }
            cell.btnCheck.tintColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(onClickEdit(_:)), for: UIControl.Event.touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblAddress {
            AddressIndex = indexPath.row
            TPreferences.writeString(SELECTED_ADDRESS, value: "\(AddressIndex)")
            tblAddress.reloadData()
        }
    }
    
    //MARK: -
    //MARK: - UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddEditAddress_Clicked(_ sender: Any) {
        tblAddress.reloadData()
        
        vwAddAddressBackground.isHidden = false
        vwAddAddress.isHidden = false
    }
    
    @IBAction func btnContinue_Clicked(_ sender: Any) {
        createOrdersAPI()
    }
    
    @IBAction func btnAddNewAddress_Clicked(_ sender: Any) {
        vwAddAddressBackground.isHidden = true
        vwAddAddress.isHidden = true
        
        let vc = AddEditAddressViewController(nibName: "AddEditAddressViewController", bundle: nil)
        vc.isFromEdit = false
        vc.isFromAddressManager = false
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.vwAddAddressBackground.isHidden = true
        self.vwAddAddress.isHidden = true
    }
    
    @IBAction func btnDeliverHere_Clicked(_ sender: Any) {
        SetUpValue()
        vwAddAddressBackground.isHidden = true
        vwAddAddress.isHidden = true
    }
    
    @IBAction func btnPriceDetail_Clicked(_ sender: Any) {
        let frame = CGRect(x: 0, y: vwPaymentDetail.frame.origin.y, width: vwPaymentDetail.frame.width, height: vwPaymentDetail.frame.height)
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    //MARK: -
    //MARK: - Cell UIButton Action Method
    
    @objc func onClickEdit(_ sender: UIButton?) {
        vwAddAddressBackground.isHidden = true
        vwAddAddress.isHidden = true
        
        tag = sender!.tag
        let vc = AddEditAddressViewController(nibName: "AddEditAddressViewController", bundle: nil)
        vc.isFromEdit = true
        vc.isFromAddressManager = false
        vc.dicAddress = arrAddress[tag] as! NSDictionary
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:-
    // MARK:- API Calling
    
    func createOrdersAPI() {
        THelper.ShowProgress(vc: self)
        let dicAddress:NSDictionary = arrAddress[AddressIndex] as! NSDictionary
        var dicAddress1 = [String : Any]()
        
            dicAddress1 = ["ID":"\(dicAddress.value(forKey: "ID") ?? "")",
                          "first_name":"\(dicAddress.value(forKey: "first_name") ?? "")",
                          "last_name":"\(dicAddress.value(forKey: "last_name") ?? "")",
                          "postcode":"\(dicAddress.value(forKey: "postcode") ?? "")",
                          "city":"\(dicAddress.value(forKey: "city") ?? "")",
                          "state":"\(dicAddress.value(forKey: "state") ?? "")",
                          "country":"\(dicAddress.value(forKey: "country") ?? "")",
                          "address_1":"\(dicAddress.value(forKey: "address_1") ?? "")",
                          "address_2":"\(dicAddress.value(forKey: "address_2") ?? "")",
                          "phone":"\(dicAddress.value(forKey: "contact") ?? "")"]
          
        var lineItems = [String : Any]()
        var dicCartTemp = NSDictionary()
        let arrLineItems = NSMutableArray()
        
        for i in 0..<arrCart.count {
            dicCartTemp = arrCart[i] as! NSDictionary
            lineItems = ["product_id":dicCartTemp.value(forKey: PRO_ID) ?? "",
                          "quantity":dicCartTemp.value(forKey: "quantity") ?? ""
                ] as [String : Any]
            arrLineItems.add(lineItems)
        }
        
        let param = ["billing":dicAddress1,
                     "shipping":dicAddress1,
                     "line_items":arrLineItems,
                     "customer_id":Int("\(TPreferences.readString(USER_ID) ?? "0")") ?? 0
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL("\(ORDER)")!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                        print(data)
                        let dicOrder:NSDictionary = data as! NSDictionary
                        self.CheckoutAPI(orderId: "\(dicOrder.value(forKey: "id") ?? "")")
                        
                        
                        
//                        let vc = PaymentsViewController(nibName: "PaymentsViewController", bundle: nil)
//                        vc.StrOrderId = "\(dicOrder.value(forKey: "id") ?? "")"
//                        vc.strTotalPrice = self.lblTotalPrice.text ?? ""
//                        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func CheckoutAPI(orderId: String) {
        THelper.ShowProgress(vc: self)
        
        let param = ["order_id":orderId
           ] as [String : Any]
       print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_GET_CHECKOUT_URL)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let dicData: NSDictionary = data as! NSDictionary
                        
                        let webVc = WebViewController(nibName: "WebViewController", bundle: nil)
                        webVc.strUrl = "\(dicData.value(forKey: "checkout_url") ?? "")"
                        webVc.isFromPayment = true
                        webVc.strHeading = ""
                        self.navigationController?.pushViewController(webVc, animated: true)
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
    
    func PaymentAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        print("\(GET_CART_ITEM)/\(TPreferences.readString(USER_ID) ?? "")")
        sessionManager.request(TPreferences.getCommonURL("\(TOTAL_AMOUNT)")!, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        if TValidation.isDictionary(data) {
                            self.dicPaymentDetail = data as! NSDictionary
                            print(self.dicPaymentDetail)
                            self.SetValue()
                        }
                        else {
                            THelper.toast("No data found", vc: self)
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
    
    func getAddressAPI() {
//        THelper.ShowProgress(vc: self)
                                
        Alamofire.request(TPreferences.getCommonURL(NEW_GET_ADDRESS)!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
//                    THelper.hideProgress(vc: self)
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            print(data)
                            if TValidation.isArray(data) {
                                self.arrAddress = data as! NSArray
                            }
                            else {
                                self.arrAddress = []
                            }
                            self.tblAddress.reloadData()
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
//                    THelper.hideProgress(vc: self)
                    THelper.toast(ERROR_MSG, vc: self)
                    print(response.result.error?.localizedDescription ?? "Something went wrong")
    //                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                    break
                }
            }
        }
}
