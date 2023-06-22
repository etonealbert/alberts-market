//
//  BlogDetailViewController.swift

import UIKit
import GoogleMobileAds

class BlogDetailViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblBlogTitle: UILabel!
    @IBOutlet weak var lblBlogDate: UILabel!
    @IBOutlet weak var lblBlogDescription: UILabel!
    
    @IBOutlet weak var imgBlog: UIImageView!
    
    @IBOutlet weak var vwBanner: UIView!
    
    var dicBlog = NSDictionary()
    
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
        let htmlString = "\(dicBlog.value(forKey: "description") ?? "")"
        let str = htmlString.html2String
        lblBlogDescription.attributedText = str.html2AttributedString
        lblHeading.text = "\(dicBlog.value(forKey: "title") ?? "")"
        lblBlogTitle.text = "\(dicBlog.value(forKey: "title") ?? "")"
        lblBlogDate.text = "\(dicBlog.value(forKey: "publish_date") ?? "")"
        
        let url = THelper.nullToNil(value: dicBlog.value(forKey: "image") as AnyObject?)
        if url != nil {
            THelper.setImage(img: imgBlog, url: URL(string: "\(dicBlog.value(forKey: "image") ?? "")")!, placeholderImage: "")
        } else {
            imgBlog.image = UIImage(named: "")
        }
        
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
}
