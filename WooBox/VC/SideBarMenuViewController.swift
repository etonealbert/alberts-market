//
//  SideBarMenuViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import FCAlertView
import GoogleSignIn
import FacebookLogin
import FBSDKLoginKit

class SideBarMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FCAlertViewDelegate {

    //MARK:-
    //MARK:- Outlets
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var constraintHeightTable: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    
    @IBOutlet weak var tblCategories: UITableView!
    
    @IBOutlet weak var imgAppIcon: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMyOrder: UILabel!
    @IBOutlet weak var lblWishlist: UILabel!
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var lblAppVersion: UILabel!
    
    @IBOutlet weak var lblTotalOrderValue: UILabel!
    @IBOutlet weak var lblTotalWishlist: UILabel!
    
    @IBOutlet weak var vwAppLogo: UIView!
    
    //MARK:-
    //MARK:- Variables
    
    var dicData = NSDictionary()
    var selectedIndex = Int()
    var arrCategory = NSArray()
    var arrSectionOne = [String]()
    var arrImgSectionOne = [String]()
    var arrSectionTwo = ["Contact_Us", "About_Us", "Share_app"]
    var dicCategory = NSDictionary()
    
    //MARK:-
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SetUpViews()
        
        if TPreferences.readString(USER_FIRST_NAME) == "" && TPreferences.readString(USER_LAST_NAME) == "" {
            self.lblTotalWishlist.text = "00"
            self.lblTotalOrderValue.text = "00"
            
            if TPreferences.readBoolean(IS_LOGGED_IN) {
                imgProfile.image = UIImage(named: "icoProfile1")
                lblUserName.text = ""
            }
            else {
                imgProfile.image = UIImage(named: "icoProfile1")
                lblUserName.text = "Guest User"
            }
        }
        else {
            if "\(TPreferences.readString(USER_PROFILE_IMAGE) ?? "")" == "" {
                imgProfile.image = UIImage(named: "icoProfile1")
            }
            else {
                THelper.setImage(img: imgProfile, url: URL(string: "\(TPreferences.readString(USER_PROFILE_IMAGE) ?? "")")!, placeholderImage: "icoProfile1")
            }
            lblUserName.text = "\(TPreferences.readString(USER_FIRST_NAME) ?? "") \(TPreferences.readString(USER_LAST_NAME) ?? "")"
            
            if TPreferences.readString(WISHLIST_COUNT) == "" || TPreferences.readString(WISHLIST_COUNT) == "0" {
                self.lblTotalWishlist.text = "00"
            }
            else {
                self.lblTotalWishlist.text = TPreferences.readString(WISHLIST_COUNT)
            }
            
            if TPreferences.readString(MY_ORDER_COUNT) == "" || TPreferences.readString(MY_ORDER_COUNT) == "0" {
                self.lblTotalOrderValue.text = "00"
            }
            else {
                self.lblTotalOrderValue.text = TPreferences.readString(MY_ORDER_COUNT)
            }
        }
    }

    //MARK: -
    //MARK: - Set Up Objects
    
    func SetUpObject(){
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        
        lblMyOrder.text = LanguageLocal.myLocalizedString(key: "My_Order")
        lblWishlist.text = LanguageLocal.myLocalizedString(key: "Wishlist")
        lblAppVersion.text = "V \(THelper.getAppVersion())"
        lblAppName.text = THelper.getAppName()
        vwAppLogo.layer.masksToBounds = true
        
        getCategoriesAPI()
        selectedIndex = -1

        vwAppLogo.backgroundColor = UIColor(hexString: PRIMARY_COLOR, alpha: 0.3)
        if IPAD {
            self.imgProfile.layer.cornerRadius = 200/2
            vwAppLogo.layer.cornerRadius = 200 / 2
        }else {
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2
            vwAppLogo.layer.cornerRadius = vwAppLogo.frame.height / 2
        }
 
        tblCategories.tableFooterView = UIView(frame: .zero)
        tblCategories.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.imgProfile.layer.borderWidth = 5.0
        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        
        print(TPreferences.readString(WISHLIST_COUNT) ?? "")
        print(TPreferences.readString(MY_ORDER_COUNT) ?? "")
        
        let profileImgRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.displayProfileImg(_:)))
        profileImgRecognizer.numberOfTapsRequired = 1
        imgProfile.isUserInteractionEnabled = true
        imgProfile.addGestureRecognizer(profileImgRecognizer)
    }
    
    func SetUpViews() {
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            arrSectionOne = ["Special_Offer", "Blog", "Account", "Settings", "Logout"]
            arrImgSectionOne = ["icoTag", "icoBlog", "icoProfile", "icoSetting", "icoLogout"]
        }else {
            arrSectionOne = ["Special_Offer", "Blog","Account", "Settings","Login"]
            arrImgSectionOne = ["icoTag", "icoBlog","icoProfile", "icoSetting","icoLogin"]
        }
        tblCategories.reloadData()
    }
    
    //MARK:-
    //MARK: - UITableView DataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let Totalcount = arrCategory.count + arrImgSectionOne.count + arrSectionTwo.count
        if IPAD {
            self.constraintHeightTable.constant = CGFloat(Totalcount * 80)
        }
        else {
            self.constraintHeightTable.constant = CGFloat(Totalcount * 50)
        }
        
        if section == 0 {
            return arrCategory.count
        }else if section == 1 {
            return arrSectionOne.count
        }else if section == 2 {
            return arrSectionTwo.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD {
            return 80
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblCategories.register(UINib(nibName: "HeaderViewCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderViewCell
        if indexPath.section == 0 {
            dicCategory = arrCategory[indexPath.item] as! NSDictionary
            cell.imgSideIcon.isHidden = false
            
            if "\(dicCategory.value(forKey: "image") ?? "")" != "" {
                THelper.setImage(img: cell.imgSideIcon, url: URL(string: "\(dicCategory.value(forKey: "image") ?? "")")!, placeholderImage: "")
            }
            else {
                cell.imgSideIcon.image = UIImage(named: "")
            }
            
//            cell.imgSideIcon = THelper.setTintColor(cell.imgSideIcon, tintColor: .black)
            
            cell.lblSideText.text = "\(dicCategory.value(forKey: "name") ?? "")".html2String
            cell.btnRightArrow.isHidden = true
        }else if indexPath.section == 1 {
            cell.imgSideIcon.isHidden = false
            cell.lblSideText.text = LanguageLocal.myLocalizedString(key: "\(arrSectionOne[indexPath.row])")
            cell.imgSideIcon.image = UIImage(named: arrImgSectionOne[indexPath.row])
            cell.btnRightArrow.isHidden = true
        }else if indexPath.section == 2 {
            cell.imgSideIcon.isHidden = true
            cell.lblSideText.text = LanguageLocal.myLocalizedString(key: "\(arrSectionTwo[indexPath.row])")
            cell.btnRightArrow.isHidden = true
        }
        else {
            cell.imgSideIcon.isHidden = true
            cell.lblSideText.text = LanguageLocal.myLocalizedString(key: "\(arrSectionTwo[indexPath.row])")
            cell.btnRightArrow.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0  {
            dicCategory = arrCategory[indexPath.item] as! NSDictionary
            let arrSubCategory: NSArray = dicCategory.value(forKey: "subcategory") as! NSArray
            
            let vc = SubCategoriesViewController(nibName: "SubCategoriesViewController", bundle: nil)
            vc.StrHeader = "\(dicCategory.value(forKey: "name") ?? "")".html2String
            vc.strCategoryId = "\(dicCategory.value(forKey: CAT_ID) ?? "")"
            
            if arrSubCategory.count > 0 {
                vc.subCategory = true
            }
            else {
                vc.subCategory = false
            }
            
            AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
            frostedViewController?.hideMenuViewController()
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = OfferViewController(nibName: "OfferViewController", bundle: nil)
                AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
                frostedViewController?.hideMenuViewController()
            }else if indexPath.row == 1 {
                let vc = BlogViewController(nibName: "BlogViewController", bundle: nil)
                AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
                frostedViewController?.hideMenuViewController()
            }else if indexPath.row == 2 {
                if TPreferences.readBoolean(IS_LOGGED_IN) {
                    let vc = AccountViewController(nibName: "AccountViewController", bundle: nil)
                    AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
                    frostedViewController?.hideMenuViewController()
                }
                else {
                    let vc = signInViewController(nibName: "signInViewController", bundle: nil)
                    AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
                    frostedViewController?.hideMenuViewController()
                }
            }else if indexPath.row == 3 {
                let vc = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
                AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
                frostedViewController?.hideMenuViewController()
            }else if indexPath.row == 4 {
                if TPreferences.readBoolean(IS_LOGGED_IN) {
                    frostedViewController?.hideMenuViewController()
                    THelper.displayAlert(self, title: "", message: "Are you sure you want to Logout", tag: 101, firstButton: "Cancel", doneButton: "OK")
                }
                else {
                    let vc = signInViewController(nibName: "signInViewController", bundle: nil)
                    AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
                    frostedViewController?.hideMenuViewController()
                }
                
            }else {
                
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let vc = ContactUsViewController(nibName: "ContactUsViewController", bundle: nil)
                AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
                frostedViewController?.hideMenuViewController()
            }else if indexPath.row == 1 {
                let vc = AboutUsViewController(nibName: "AboutUsViewController", bundle: nil)
                AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
                frostedViewController?.hideMenuViewController()
            }else if indexPath.row == 2 {
                frostedViewController?.hideMenuViewController()
                share(message: "", link: "htttp://google.com")
            }
        }
    }
    
    //MARK:-
    //MARK: - UIButton Action Method
    
    @IBAction func btnCancel_Clicked(_ sender: Any) {
        frostedViewController?.hideMenuViewController()
    }
    
    @IBAction func btnProfile_Clicked(_ sender: Any) {
        let vc = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        vc.isSideMenu = true
        AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
        frostedViewController?.hideMenuViewController()
    }
    
    @IBAction func btnMyOrder_Clicked(_ sender: Any) {
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            let vc = MyOrderViewController(nibName: "MyOrderViewController", bundle: nil)
            AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
            frostedViewController?.hideMenuViewController()
        }
        else {
            let vc = signInViewController(nibName: "signInViewController", bundle: nil)
            AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
            frostedViewController?.hideMenuViewController()
        }
    }

    @IBAction func btnReward_Clicked(_ sender: Any) {
        let vc = MyRewardsViewController(nibName: "MyRewardsViewController", bundle: nil)
//        vc.isSideMenu = true
//        AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
        frostedViewController?.hideMenuViewController()
    }
    
    @IBAction func btnWishlist_Clicked(_ sender: Any) {
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            let vc = WishListViewController(nibName: "WishListViewController", bundle: nil)
            vc.isWishInList = true
            AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
            frostedViewController?.hideMenuViewController()
        }
        else {
            let vc = signInViewController(nibName: "signInViewController", bundle: nil)
            AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
            frostedViewController?.hideMenuViewController()
        }
    }
    
    // MARK: -
    // MARK: - Other Method
    
    @objc func displayProfileImg(_ gesture: UITapGestureRecognizer?) {
        THelper.displayImage(self, imageView: imgProfile)
    }
    
    func share(message: String, link: String) {
        if let link = NSURL(string: link) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    //MARK: -
    //MARK: - fcAlertDoneButtonClicked
    
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView?) {
        if alertView?.tag == 101 {
            if TPreferences.readString(LOGIN_TYPE) == "google" {
                GIDSignIn.sharedInstance()?.signOut()
            }
            else if TPreferences.readString(LOGIN_TYPE) == "facebook" {
                let loginManager = LoginManager()
                loginManager.logOut()
                let cookies = HTTPCookieStorage.shared
                let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
                for cookie in facebookCookies! {
                    cookies.deleteCookie(cookie )
                }
                
                THelper.toast("Successfully Logged out", vc: self)
            }
            
            TPreferences.writeBoolean(IS_LOGGED_IN, value: false)
            TPreferences.removePreference(USER_PROFILE_IMAGE)
            TPreferences.removePreference(USER_FIRST_NAME)
            TPreferences.removePreference(USER_LAST_NAME)
            TPreferences.removePreference(USER_EMAIL)
            TPreferences.removePreference(USER_ID)
            TPreferences.removePreference(USER_DISPLAY_NAME)
            TPreferences.removePreference(USER_NICENAME)
            TPreferences.removePreference(TOKEN)
            TPreferences.removePreference(LOGIN_TYPE)
        }
    }
    
    //MARK:-
    //MARK: - API Calling
    
    func getCategoriesAPI() {
//        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_CATEGORIES)!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
//                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        self.arrCategory = arrtemp[0] as! NSArray
                        print(self.arrCategory)
                        self.tblCategories.reloadData()
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
