//
//  AccountViewController.swift

import UIKit
import FCAlertView
import GoogleMobileAds

class AccountViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, FCAlertViewDelegate,UITextFieldDelegate, GADInterstitialDelegate {

    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
//    @IBOutlet weak var lblVerifyEmailOrNumber: UILabel!
//    @IBOutlet weak var lblGetNewestOffer: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtPhoneNo: UITextField!
    
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var constraintHeightSafeArea: NSLayoutConstraint!
    @IBOutlet weak var constraintTableHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintVwHeaderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnSignOut: UIButton!
    @IBOutlet weak var btnVerfiyNow: UIButton!
    @IBOutlet weak var btnBlink: UIButton!
    
    @IBOutlet weak var tblSettings: UITableView!
    
    //MARK: -
    //MARK: - Variables
    
    let arrtblData = ["Adderess_Manager","My_Orders","Wishlist", "Help_Center"]
    
    var interstitial: GADInterstitial!
    
    //MARK: -
    //MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        startBlink()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpObject()
    }
    
    //MARK:-
    //MARK:- SetUpObject Method
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightSafeArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        self.btnVerfiyNow.layer.cornerRadius = 25.0
        
        if IPAD {
            self.imgProfile.layer.cornerRadius = 200 / 2
            self.btnVerfiyNow.layer.cornerRadius = 30.0
             self.btnBlink.layer.cornerRadius = 20 / 2
        }else {
            self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.height / 2
            self.btnVerfiyNow.layer.cornerRadius = 25.0
             self.btnBlink.layer.cornerRadius = self.btnBlink.layer.frame.height / 2
        }

        if TPreferences.readString(USER_FIRST_NAME) == "" && TPreferences.readString(USER_LAST_NAME) == "" {
            lblUserName.text = "Guest User"
        }
        else {
            lblUserName.text = "\(TPreferences.readString(USER_FIRST_NAME) ?? "") \(TPreferences.readString(USER_LAST_NAME) ?? "")"
        }
        
        self.lblHeader.text = LanguageLocal.myLocalizedString(key: "My_Account")
//        self.lblVerifyEmailOrNumber.text = LanguageLocal.myLocalizedString(key: "Please_Verify_Your_Email_Or_Number")
//        self.lblGetNewestOffer.text = LanguageLocal.myLocalizedString(key: "Get_Newest_offer")
        self.btnSignOut.setTitle(LanguageLocal.myLocalizedString(key: "Sign_Out"), for: .normal)
        self.btnVerfiyNow.setTitle(LanguageLocal.myLocalizedString(key: "Verify_Now"), for: .normal)

        self.imgProfile.layer.borderWidth = 5.0
        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        
        tblSettings.tableFooterView = UIView(frame: .zero)
        tblSettings.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startBlink) , userInfo: nil, repeats: true)
        
        let profileImgRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.displayProfileImg(_:)))
        profileImgRecognizer.numberOfTapsRequired = 1
        imgProfile.isUserInteractionEnabled = true
        imgProfile.addGestureRecognizer(profileImgRecognizer)
        
        interstitial = GADInterstitial(adUnitID: INTERSTITIAL_ID)
            let request = GADRequest()
            interstitial.load(request)
            interstitial.delegate = self
        }
        
        //MARK: -
        //MARK: - GADInterstitialDelegate
        
        func interstitialDidReceiveAd(_ ad: GADInterstitial) {
            interstitial.present(fromRootViewController: self)
        }

        func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        }
    
    // MARK: -
    // MARK: - Other Method
    
    @objc func displayProfileImg(_ gesture: UITapGestureRecognizer?) {
        THelper.displayImage(self, imageView: imgProfile)
    }
    
    @objc func startBlink() {
        UIView.animate(withDuration: 0.8,//Time duration
            delay:0.0,
            options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
            animations: { self.btnBlink.alpha = 0 },
            completion: nil)
    }
    
    //MARK:-
    //MARK:- UITableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrtblData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD {
            self.constraintTableHeight.constant = CGFloat((arrtblData.count * 80))
            return 80
        }
        else {
            self.constraintTableHeight.constant = CGFloat((arrtblData.count * 60))
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblSettings.register(UINib(nibName: "AcountTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountCell")
        let cell = tblSettings.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AcountTableViewCell
        cell.lblKey.text = LanguageLocal.myLocalizedString(key: "\(arrtblData[indexPath.row])")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = AddressManagerViewController(nibName: "AddressManagerViewController", bundle: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
        }
        else if indexPath.row == 1 {
            let vc = MyOrderViewController(nibName: "MyOrderViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            let vc = WishListViewController(nibName: "WishListViewController", bundle: nil)
            vc.isWishInList = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3 {
            let vc = HelpViewController(nibName: "HelpViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: -
    //MARK: - fcAlertDoneButtonClicked
    
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView?) {
        if alertView?.tag == 101 {
            TPreferences.writeBoolean(IS_LOGGED_IN, value: false)
            TPreferences.removePreference(USER_FIRST_NAME)
            TPreferences.removePreference(USER_LAST_NAME)
            TPreferences.removePreference(USER_EMAIL)
            TPreferences.removePreference(USER_ID)
            TPreferences.removePreference(USER_DISPLAY_NAME)
            TPreferences.removePreference(USER_NICENAME)
            TPreferences.removePreference(TOKEN)
            
            let vc = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
            AppDelegate.getDelegate()?.navigationController = TNavigationViewController(rootViewController: vc)
            AppDelegate.getDelegate()?.navigationController.isNavigationBarHidden = true
            if let aController = AppDelegate.getDelegate()?.navigationController {
                self.frostedViewController.contentViewController = aController
            }
        }
    }
    
    //MARK: -
    //MARK:- UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func btnSignOut_Clicked(_ sender: Any) {
        THelper.displayAlert(self, title: "", message: "Are you sure you want to Logout", tag: 101, firstButton: "Cancel", doneButton: "OK")
    }
}
