//
//  AboutUsViewController.swift

import UIKit
import GoogleMobileAds

class AboutUsViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgAppIcon: UIImageView!
    
    @IBOutlet weak var lblAppYear: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblFollowUs: UILabel!
    
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    
    @IBOutlet weak var vwBanner: UIView!
    
    var strContact = String()
    var strFacebook = String()
    var strInstagram = String()
    var strTwitter = String()
    var strWhatsapp = String()
    var strTerms = String()
    var strPrivacy = String()
    var strCopyRight = String()
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpObject()
    }
    
    //MARK: -
    //MARK: - Set Up Object
    
    func setUpObject() {
        if #available(iOS 11.0, *) {} else {
            constraintHeaderTop.constant = UIApplication.shared.statusBarFrame.size.height
        }
        btnCall.tintColor = UIColor.primaryColor()
        
        strContact = TPreferences.readString(CONTACT) ?? ""
        strFacebook = TPreferences.readString(FACEBOOK) ?? ""
        strInstagram = TPreferences.readString(INSTAGRAM) ?? ""
        strTwitter = TPreferences.readString(TWITTER) ?? ""
        strWhatsapp = TPreferences.readString(WHATSAPP) ?? ""
        strTerms = TPreferences.readString(TERM_CONDITION) ?? ""
        strPrivacy = TPreferences.readString(PRIVACY_POLICY) ?? ""
        strCopyRight = TPreferences.readString(COPYRIGHT_TEXT) ?? ""
        
        self.lblHeading.text = LanguageLocal.myLocalizedString(key: "About_Us")
        self.lblFollowUs.text = LanguageLocal.myLocalizedString(key: "Follow_Us")
        btnTerms.setTitle(LanguageLocal.myLocalizedString(key: "Terms"), for: .normal)
        btnPrivacy.setTitle(LanguageLocal.myLocalizedString(key: "Privacy"), for: .normal)
        
        lblAppYear.text = strCopyRight.html2String
        
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
    
    //MARK: -
    //MARK: - ADMob Delegate
    
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
    //MARK: - UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnWhatsapp_Clicked(_ sender: Any) {
        if strWhatsapp != "" {
            UIApplication.shared.open(URL(string:"https://wa.me/\(strWhatsapp)")!)
        }
    }
    
    @IBAction func btnFacebook_Clicked(_ sender: Any) {
        if strFacebook != "" {
            UIApplication.shared.open(URL(string:"\(strFacebook)")!)
        }
    }
    
    @IBAction func btnInstagram_Clicked(_ sender: Any) {
        if strInstagram != "" {
            UIApplication.shared.open(URL(string:"\(strInstagram)")!)
        }
    }
    
    @IBAction func btnTwitter_Clicked(_ sender: Any) {
        if strTwitter != "" {
            UIApplication.shared.open(URL(string:"\(strTwitter)")!)
        }
    }
    
    @IBAction func btnCall_Clicked(_ sender: Any) {
        if strContact != "" {
            UIApplication.shared.open(URL(string:"tel://\(strContact)")!)
        }
    }
    
    @IBAction func btnTermsAndCondition_Clicked(_ sender: Any) {
        if strTerms != "" {
            let vc = WebViewController(nibName: "WebViewController", bundle: nil)
            vc.strUrl = strTerms
            vc.isFromPayment = false
            vc.strHeading = "Terms & Condition"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnPravicyPolicy_Clicked(_ sender: Any) {
        if strPrivacy != "" {
            let vc = WebViewController(nibName: "WebViewController", bundle: nil)
            vc.strUrl = strPrivacy
            vc.isFromPayment = false
            vc.strHeading = "Pravicy Policy"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
