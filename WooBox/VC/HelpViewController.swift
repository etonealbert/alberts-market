//
//  HelpViewController.swift

import UIKit
import GoogleMobileAds

class HelpViewController: UIViewController, GADBannerViewDelegate {

    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwBanner: UIView!
    
    @IBOutlet weak var btnNotification: UIButton!
    
    @IBOutlet weak var lblProductMyCart: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblFillDetails: UILabel!
    
    @IBOutlet weak var vwContactNo: UIView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwDesc: UIView!
    @IBOutlet weak var vwMain: UIView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    var bannerView: GADBannerView!
    
    //MARK: -
    //MARK: - UIView life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpView()
    }

    //MARK: -
    //MARK: - SetUpView

    func SetUpView() {
        if #available(iOS 11.0, *) {
            
        } else {
            constraintHeaderTop.constant = UIApplication.shared.statusBarFrame.size.height
        }
        
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            self.lblProductMyCart.isHidden = false
            self.lblProductMyCart.text = TPreferences.readString(CART_ITEM_COUNT)
            if IPAD {
                self.lblProductMyCart.layer.cornerRadius = 20 / 2
            }else {
                self.lblProductMyCart.layer.cornerRadius = self.lblProductMyCart.layer.frame.height / 2
            }
        }else {
            self.lblProductMyCart.isHidden = true
            self.lblProductMyCart.text = ""
        }
        
        self.lblHeading.text = LanguageLocal.myLocalizedString(key: "Help")
        self.btnSubmit.setTitle(LanguageLocal.myLocalizedString(key: "Submit"), for: .normal)
        self.lblProductMyCart.text = TPreferences.readString(CART_ITEM_COUNT)
        
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
    //MARK: - UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit_Clicked(_ sender: Any) {
        
    }
    
    @IBAction func btnNotification_Clicked(_ sender: UIButton) {
        let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
        vc.flagHeader = false
        vc.isFormPayCard = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
