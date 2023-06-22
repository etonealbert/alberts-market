//
//  BlogViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import GoogleMobileAds

class BlogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GADBannerViewDelegate {

    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cvBlog: UICollectionView!
    
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var vwBanner: UIView!
    
    var arrBlog = NSArray()
    var page = Int()
    var totalPage = Int()
    
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
        page = 1
        getBlogAPI(pageNo: page)
        
        self.lblHeading.text = LanguageLocal.myLocalizedString(key: "Blog")
        
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
    //MARK: -UICollectionView Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrBlog.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cvBlog.register(UINib(nibName: "BlogCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BlogCell")
        let cell = cvBlog.dequeueReusableCell(withReuseIdentifier: "BlogCell", for: indexPath) as! BlogCollectionCell
        
        let dicBlog: NSDictionary = arrBlog[indexPath.item] as! NSDictionary
        
        cell.lblBlogTitle.text = "\(dicBlog.value(forKey: "title") ?? "")"
        cell.lblBlogDate.text = "\(dicBlog.value(forKey: "publish_date") ?? "")"
        
        let url = THelper.nullToNil(value: dicBlog.value(forKey: "image") as AnyObject?)
        if url != nil {
            THelper.setImage(img: cell.imgBlog, url: URL(string: "\(dicBlog.value(forKey: "image") ?? "")")!, placeholderImage: "")
        } else {
            print("null")
            cell.imgBlog.image = UIImage(named: "")
        }

        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = BlogDetailViewController(nibName: "BlogDetailViewController", bundle: nil)
        vc.dicBlog = arrBlog[indexPath.item] as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cvBlog.frame.width - 24, height: 300)
    }
    
    //MARK: -
    //MARK: - UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:-
    //MARK:- API Calling
    
    func getBlogAPI(pageNo: Int) {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request("\(TPreferences.getCommonURL(NEW_BLOG)!)?page=\(pageNo)", method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        self.arrBlog = data as! NSArray
                                     
//                        let dicBlog: NSDictionary = self.arrBlog[0] as! NSDictionary
//                        self.totalPage = dicBlog.value(forKey: "num_pages") as! Int
                        self.cvBlog.reloadData()
                    }
                    else {
                        print(data)
                        let dicError:NSDictionary = data as! NSDictionary
                        let str:String = dicError.value(forKey: "message") as! String
                        THelper.toast(str.html2String, vc: self)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                break
                
            case .failure(_):
                THelper.hideProgress(vc: self)
                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                self.navigationController?.popViewController(animated: true)
                break
            }
        }
    }
}
