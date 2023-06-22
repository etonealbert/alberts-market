//
//  Dashboard1ViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import AnimatedCollectionViewLayout

class Dashboard1ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    //MARK:-
    //MARK:- Outlets
    
    @IBOutlet weak var cvCategory: UICollectionView!
    @IBOutlet weak var cvRecentSearch: UICollectionView!
    @IBOutlet weak var cvNewestProduct: UICollectionView!
    @IBOutlet weak var cvFeaturedProduct: UICollectionView!
    @IBOutlet weak var cvDealProducts: UICollectionView!
    @IBOutlet weak var cvSuggestedProducts: UICollectionView!
    @IBOutlet weak var cvOffers: UICollectionView!
    @IBOutlet weak var cvYouMayLike: UICollectionView!
    @IBOutlet weak var cvBanner: UICollectionView!
    @IBOutlet weak var cvTestimonials: UICollectionView!
    
    @IBOutlet weak var vwAds: UIView!
    
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var testimonialsPageControl: UIPageControl!
    
    @IBOutlet weak var ConstraintHeightCvCategory: NSLayoutConstraint!
    @IBOutlet weak var ConstraintHeightCvRecentSerach: NSLayoutConstraint!
    @IBOutlet weak var ConstraintHeightCvNewProduct: NSLayoutConstraint!
    @IBOutlet weak var ConstraintHeightcvFeaturedProduct: NSLayoutConstraint!
    @IBOutlet weak var constraintSliderHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintCvDealProductsHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintCvSuggestedProductsHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintCvOffersHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintCvYouMayLikeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ConstraintHeightCvRecentSearchHeader: NSLayoutConstraint!
    @IBOutlet weak var ConstraintHeightCvNewestHeader: NSLayoutConstraint!
    @IBOutlet weak var ConstraintHeightCvFeturedHeader: NSLayoutConstraint!
    @IBOutlet weak var constraintDealProductsHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintSuggestedProductsHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintOffersHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintYouMayLikeHeaderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constraintVwBanner1Height: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBanner2Height: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBanner3Height: NSLayoutConstraint!
    
    @IBOutlet weak var VwRecentSearch: UIView!
    @IBOutlet weak var VwNewestProduct: UIView!
    @IBOutlet weak var VwFeaturedProduct: UIView!
    @IBOutlet weak var vwDealProducts: UIView!
    @IBOutlet weak var vwSuggestedProducts: UIView!
    @IBOutlet weak var vwOffers: UIView!
    @IBOutlet weak var vwYouMayLike: UIView!
    @IBOutlet weak var vwBanner1: UIView!
    @IBOutlet weak var vwBanner2: UIView!
    @IBOutlet weak var vwBanner3: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgBanner1: UIImageView!
    @IBOutlet weak var imgBanner2: UIImageView!
    @IBOutlet weak var imgBanner3: UIImageView!
    
    @IBOutlet weak var btnViewAllRecentSearch: UIButton!
    @IBOutlet weak var btnViewAllNewestProduct: UIButton!
    @IBOutlet weak var btnViewAllPopularProducts: UIButton!
    @IBOutlet weak var btnViewAllDealProducts: UIButton!
    @IBOutlet weak var btnViewAllSuggestedProducts: UIButton!
    @IBOutlet weak var btnViewAllOffers: UIButton!
    @IBOutlet weak var btnViewAllYouMayLike: UIButton!
    
    @IBOutlet weak var lblRecentSearch: UILabel!
    @IBOutlet weak var lblNewestProduct: UILabel!
    @IBOutlet weak var lblFeturedProduct: UILabel!
    @IBOutlet weak var lblDealProducts: UILabel!
    @IBOutlet weak var lblSuggestedProducts: UILabel!
    @IBOutlet weak var lblOffers: UILabel!
    @IBOutlet weak var lblYouMayLike: UILabel!
    
    //MARK:-
    //MARK:- Variables
    
    let arrCategories = ["Mens","Womens","Kids","Camera","Sports","Electronic","Optical","Bags"]
    let arrCategoryIcon = ["icoMen", "icoWomen", "icoKids", "icoCamera", "icoSport", "icoElectronic", "icoOptical", "icoBags"]
    let arrColor = [UIColor.red, UIColor.orange, UIColor.brown, UIColor.purple, UIColor.gray]
    let arrImg = ["walkThrough","walkThrough","walkThrough"]
    let arrProducts1 = ["01","05","19","07","09","10","11","13","15","17"]
    
    var arrProducts = NSMutableArray()
    var arrCategory = NSArray()
    var arrSelectedProduct = NSMutableArray()
    var arrRecentSearch = NSMutableArray()
    var arrFeaturedProduct = NSMutableArray()
    var count = Int()
    var arrOrderProducts = NSMutableArray()
    var arrSlider = NSArray()
    var arrTestimonials = NSMutableArray()
    
    var arrDealProducts = NSMutableArray()
    var arrSuggestedProducts = NSMutableArray()
    var arrOffers = NSMutableArray()
    var arrYouMayLike = NSMutableArray()
    var strBanner1URL = String()
    var strBanner2URL = String()
    var strBanner3URL = String()
    
    var refreshControl: UIRefreshControl!
    var timer: Timer!
    
    //MARK:-
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getArray()
        reloadCollectionView()
        
//        _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
//            self.cvRecentSearch.reloadData()
//        }
        
        THelper.ShowProgress(vc: self)
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateView), userInfo: nil, repeats: false)
    }
    
    @objc func updateView() {
        timer.invalidate()
        THelper.hideProgress(vc: self)
        reloadCollectionView()        
    }
    
    //MARK:-
    //MARK:- SetUpObject Method
    
    func SetUpObject() {
        self.cvCategory.layer.cornerRadius = 5.0
        
        search.barTintColor = .primaryColor()
        if let textfield = search.value(forKey: "searchField") as? UITextField {
            textfield.textColor = .black
            textfield.backgroundColor = .white            
        }
        
        self.lblRecentSearch.text = LanguageLocal.myLocalizedString(key: "Recent_Search")
        self.lblNewestProduct.text = LanguageLocal.myLocalizedString(key: "Newest_Product")
        self.lblFeturedProduct.text = LanguageLocal.myLocalizedString(key: "Featured_Product")
        self.lblDealProducts.text = LanguageLocal.myLocalizedString(key: "Deal_Product")
        self.lblSuggestedProducts.text = LanguageLocal.myLocalizedString(key: "Suggested_Product")
        self.lblOffers.text = LanguageLocal.myLocalizedString(key: "Offer")
        self.lblYouMayLike.text = LanguageLocal.myLocalizedString(key: "You_May_Like")
        
        self.btnViewAllRecentSearch.setTitle(LanguageLocal.myLocalizedString(key: "View_All"), for: .normal)
        self.btnViewAllNewestProduct.setTitle(LanguageLocal.myLocalizedString(key: "View_All"), for: .normal)
        self.btnViewAllPopularProducts.setTitle(LanguageLocal.myLocalizedString(key: "View_All"), for: .normal)
        self.btnViewAllDealProducts.setTitle(LanguageLocal.myLocalizedString(key: "View_All"), for: .normal)
        self.btnViewAllSuggestedProducts.setTitle(LanguageLocal.myLocalizedString(key: "View_All"), for: .normal)
        self.btnViewAllOffers.setTitle(LanguageLocal.myLocalizedString(key: "View_All"), for: .normal)
        self.btnViewAllYouMayLike.setTitle(LanguageLocal.myLocalizedString(key: "View_All"), for: .normal)
        
        APICalling()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNotification(_:)), name: NSNotification.Name("Reload"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PullToRefresh), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        
        let layout = AnimatedCollectionViewLayout()
        layout.animator = PageAttributesAnimator()
        layout.scrollDirection = .horizontal
        cvTestimonials.collectionViewLayout = layout
    }
        
    //MARK:-
    //MARK:- Other Methods
    
    @objc func willEnterForeground() {
        reloadCollectionView()
        themeChange()
        _ =  Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(self.themeChange), userInfo: nil, repeats: false)
    }
    
    @objc func themeChange() {
        if TPreferences.readBoolean(DARK_MODE) {
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    ThemeManager.shared()?.changeTheme("default_dark")
                } else {
                    ThemeManager.shared()?.changeTheme("default_dark")
                }
            } else {
                if IPAD {
                    ThemeManager.shared()?.changeTheme("default_iPad_dark")
                }
                else {
                    ThemeManager.shared()?.changeTheme("default_dark")
                }
            }
        }
        else {
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    ThemeManager.shared()?.changeTheme("default")
                } else {
                    ThemeManager.shared()?.changeTheme("default")
                }
            } else {
                if IPAD {
                    ThemeManager.shared()?.changeTheme("default_iPad_dark")
                }
                else {
                    ThemeManager.shared()?.changeTheme("default")
                }
            }
        }
    }
    
    func reloadCollectionView() {
        cvRecentSearch.reloadData()
        cvNewestProduct.reloadData()
        cvFeaturedProduct.reloadData()
        cvCategory.reloadData()
        cvDealProducts.reloadData()
        cvSuggestedProducts.reloadData()
        cvOffers.reloadData()
        cvYouMayLike.reloadData()
        cvTestimonials.reloadData()
    }
    
    func APICalling() {
        DashboardAPI()
        getSliderAPI()
        getCategoriesAPI()
        THelper.getCartAPI()
        THelper.getWishlistAPI()
        getArray()
    }
    
    @objc func PullToRefresh() {
        APICalling()
        refreshControl?.endRefreshing()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = cvBanner.frame.size.width
        pageControl.currentPage = Int(cvBanner.contentOffset.x / pageWidth)
        
        let pageWidthTestimoneal = cvTestimonials.frame.size.width
        testimonialsPageControl.currentPage = Int(cvTestimonials.contentOffset.x / pageWidthTestimoneal)
    }
    
    func getArray() {
        let arrtemp:NSArray = THelper.getArray()
        arrRecentSearch.removeAllObjects()
        if arrtemp.count > 0 {
            for i in 0..<arrtemp.count {
                arrRecentSearch.add(arrtemp[i])
            }
        }
        else {
            arrRecentSearch.removeAllObjects()
        }
        self.cvRecentSearch.reloadData()
    }
    
    func OpenWebView(strUrl: String) {
        let vc = WebViewController(nibName: "WebViewController", bundle: nil)
        vc.strUrl = strUrl
        vc.strHeading = ""
        vc.isFromPayment = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func startTimer() {
        _ =  Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        if let coll  = cvBanner {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < arrSlider.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    pageControl.currentPage = indexPath1!.item
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    pageControl.currentPage = indexPath1!.item
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
            }
        }
    }
    
    // MARK: -
    // MARK: - Receive Notification
    
    @objc func receiveNotification(_ notification: Notification?) {
        if let aNotification = notification {
            print("\(aNotification)")
        }
        getArray()
        cvRecentSearch.reloadData()
    }
    
    //MARK:-
    //MARK:- Collectionview Delegate Methods.
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvTestimonials {
            return arrTestimonials.count
        }
        else if collectionView == cvBanner {
            self.startTimer()
            var count = Int()
            if arrSlider.count > 5 {
                count = 5
            }
            else {
                count = arrSlider.count
            }
            return count
        }else if collectionView == self.cvCategory {
            if arrCategory.count == 0 {
                self.ConstraintHeightCvCategory.constant = 0
            }else {
                if IPAD {
                    self.ConstraintHeightCvCategory.constant = 110
                }else {
                    self.ConstraintHeightCvCategory.constant = 80
                }
            }
            return arrCategory.count
        }else if collectionView == self.cvRecentSearch {
            if arrRecentSearch.count == 0 {
                self.btnViewAllRecentSearch.isUserInteractionEnabled = false
                self.ConstraintHeightCvRecentSearchHeader.constant = 0
                self.VwRecentSearch.isHidden = true
                self.ConstraintHeightCvRecentSerach.constant = 0
            }else {
                self.btnViewAllRecentSearch.isUserInteractionEnabled = true
                self.VwRecentSearch.isHidden = false
                if IPAD {
                    self.ConstraintHeightCvRecentSearchHeader.constant = 110
                }
                else {
                    self.ConstraintHeightCvRecentSearchHeader.constant = 90
                }
                
                if arrRecentSearch.count == 1 || arrRecentSearch.count == 2 {
                    if IPAD {
                        self.ConstraintHeightCvRecentSerach.constant = 400
                    }
                    else {
                        self.ConstraintHeightCvRecentSerach.constant = 260
                    }
                }
                else {
                    if IPAD {
                        self.ConstraintHeightCvRecentSerach.constant = 400 * 2
                    }else {
                        self.ConstraintHeightCvRecentSerach.constant = 260 * 2
                    }
                }
            }
            
            if arrRecentSearch.count > 4 {
                return 4
            }
            else {
                return arrRecentSearch.count
            }
        }else if collectionView == self.cvFeaturedProduct {
            if arrFeaturedProduct.count == 0 {
                self.btnViewAllPopularProducts.isUserInteractionEnabled = false
                self.VwFeaturedProduct.isHidden = true
                self.ConstraintHeightCvFeturedHeader.constant = 0
                self.ConstraintHeightcvFeaturedProduct.constant = 0
            }else {
                self.btnViewAllPopularProducts.isUserInteractionEnabled = true
                self.VwFeaturedProduct.isHidden = false
                if IPAD {
                    self.ConstraintHeightCvFeturedHeader.constant = 110
                }
                else {
                    self.ConstraintHeightCvFeturedHeader.constant = 90
                }
                
                if arrFeaturedProduct.count == 1 || arrFeaturedProduct.count == 2 {
                    if IPAD {
                        self.ConstraintHeightcvFeaturedProduct.constant = 400
                    }
                    else {
                        self.ConstraintHeightcvFeaturedProduct.constant = 260
                    }
                }
                else {
                    if IPAD {
                        self.ConstraintHeightcvFeaturedProduct.constant = 400 * 2
                    }else {
                        self.ConstraintHeightcvFeaturedProduct.constant = 260 * 2
                    }
                }
            }
            
            if arrFeaturedProduct.count > 4 {
                return 4
            }
            else {
                return arrFeaturedProduct.count
            }
        }else if collectionView == self.cvNewestProduct {
            if arrProducts.count == 0 {
                self.btnViewAllNewestProduct.isUserInteractionEnabled = false
                self.ConstraintHeightCvNewestHeader.constant = 0
                self.VwNewestProduct.isHidden = true
                self.ConstraintHeightCvNewProduct.constant = 0
            }else {
                self.btnViewAllNewestProduct.isUserInteractionEnabled = true
                self.VwNewestProduct.isHidden = false
                if IPAD {
                    self.ConstraintHeightCvNewestHeader.constant = 110
                }
                else {
                    self.ConstraintHeightCvNewestHeader.constant = 90
                }
                
                if arrProducts.count == 1 || arrProducts.count == 2 {
                    if IPAD {
                        self.ConstraintHeightCvNewProduct.constant = 400
                    }
                    else {
                        self.ConstraintHeightCvNewProduct.constant = 260
                    }
                }
                else {
                    if IPAD {
                        self.ConstraintHeightCvNewProduct.constant = 400 * 2
                    }else {
                        self.ConstraintHeightCvNewProduct.constant = 260 * 2
                    }
                }
            }
            
            if arrProducts.count > 4 {
                return 4
            }
            else {
                return arrProducts.count
            }
        }else if collectionView == self.cvDealProducts {
            if arrDealProducts.count == 0 {
                self.btnViewAllDealProducts.isUserInteractionEnabled = false
                self.constraintDealProductsHeaderHeight.constant = 0
                self.vwDealProducts.isHidden = true
                self.constraintCvDealProductsHeight.constant = 0
            }else {
                self.btnViewAllDealProducts.isUserInteractionEnabled = true
                self.vwDealProducts.isHidden = false
                if IPAD {
                    self.constraintDealProductsHeaderHeight.constant = 110
                }
                else {
                    self.constraintDealProductsHeaderHeight.constant = 90
                }
                
                if arrDealProducts.count == 1 || arrDealProducts.count == 2 {
                    if IPAD {
                        self.constraintCvDealProductsHeight.constant = 400
                    }
                    else {
                        self.constraintCvDealProductsHeight.constant = 260
                    }
                }
                else {
                    if IPAD {
                        self.constraintCvDealProductsHeight.constant = 400 * 2
                    }else {
                        self.constraintCvDealProductsHeight.constant = 260 * 2
                    }
                }
            }
            
            if arrDealProducts.count > 4 {
                return 4
            }
            else {
                return arrDealProducts.count
            }
        }else if collectionView == self.cvSuggestedProducts {
            if arrSuggestedProducts.count == 0 {
                self.btnViewAllSuggestedProducts.isUserInteractionEnabled = false
                self.constraintSuggestedProductsHeaderHeight.constant = 0
                self.vwSuggestedProducts.isHidden = true
                self.constraintCvSuggestedProductsHeight.constant = 0
            }else {
                self.btnViewAllSuggestedProducts.isUserInteractionEnabled = true
                self.vwSuggestedProducts.isHidden = false
                if IPAD {
                    self.constraintSuggestedProductsHeaderHeight.constant = 110
                }
                else {
                    self.constraintSuggestedProductsHeaderHeight.constant = 90
                }
                
                if arrSuggestedProducts.count == 1 || arrSuggestedProducts.count == 2 {
                    if IPAD {
                        self.constraintCvSuggestedProductsHeight.constant = 400
                    }
                    else {
                        self.constraintCvSuggestedProductsHeight.constant = 260
                    }
                }
                else {
                    if IPAD {
                        self.constraintCvSuggestedProductsHeight.constant = 400 * 2
                    }else {
                        self.constraintCvSuggestedProductsHeight.constant = 260 * 2
                    }
                }
            }
            
            if arrSuggestedProducts.count > 4 {
                return 4
            }
            else {
                return arrSuggestedProducts.count
            }
        }else if collectionView == self.cvOffers {
            if arrOffers.count == 0 {
                self.btnViewAllOffers.isUserInteractionEnabled = false
                self.constraintOffersHeaderHeight.constant = 0
                self.vwOffers.isHidden = true
                self.constraintCvOffersHeight.constant = 0
            }else {
                self.btnViewAllOffers.isUserInteractionEnabled = true
                self.vwOffers.isHidden = false
                if IPAD {
                    self.constraintOffersHeaderHeight.constant = 110
                }
                else {
                    self.constraintOffersHeaderHeight.constant = 90
                }
                
                if arrOffers.count == 1 || arrOffers.count == 2 {
                    if IPAD {
                        self.constraintCvOffersHeight.constant = 400
                    }
                    else {
                        self.constraintCvOffersHeight.constant = 260
                    }
                }
                else {
                    if IPAD {
                        self.constraintCvOffersHeight.constant = 400 * 2
                    }else {
                        self.constraintCvOffersHeight.constant = 260 * 2
                    }
                }
            }
            
            if arrOffers.count > 4 {
                return 4
            }
            else {
                return arrOffers.count
            }
        }else if collectionView == self.cvYouMayLike {
            if arrYouMayLike.count == 0 {
                self.btnViewAllYouMayLike.isUserInteractionEnabled = false
                self.constraintYouMayLikeHeaderHeight.constant = 0
                self.vwYouMayLike.isHidden = true
                self.constraintCvYouMayLikeHeight.constant = 0
            }else {
                self.btnViewAllYouMayLike.isUserInteractionEnabled = true
                self.vwYouMayLike.isHidden = false
                if IPAD {
                    self.constraintYouMayLikeHeaderHeight.constant = 110
                }
                else {
                    self.constraintYouMayLikeHeaderHeight.constant = 90
                }
                
                if arrYouMayLike.count == 1 || arrYouMayLike.count == 2 {
                    if IPAD {
                        self.constraintCvYouMayLikeHeight.constant = 400
                    }
                    else {
                        self.constraintCvYouMayLikeHeight.constant = 260
                    }
                }
                else {
                    if IPAD {
                        self.constraintCvYouMayLikeHeight.constant = 400 * 2
                    }else {
                        self.constraintCvYouMayLikeHeight.constant = 260 * 2
                    }
                }
            }
            
            if arrYouMayLike.count > 4 {
                return 4
            }
            else {
                return arrYouMayLike.count
            }
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cvTestimonials {
            self.cvTestimonials.register(UINib(nibName: "TestimonialsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TestimonialsCell")
            let cell = cvTestimonials.dequeueReusableCell(withReuseIdentifier: "TestimonialsCell", for: indexPath) as! TestimonialsCollectionCell
            
            let dicTestimonials: NSDictionary = arrTestimonials[indexPath.item] as! NSDictionary
            
            self.testimonialsPageControl.numberOfPages = arrTestimonials.count
            self.testimonialsPageControl.currentPageIndicatorTintColor = UIColor.primaryColor()
            
            cell.lblName.text = "\(dicTestimonials.value(forKey: "name") ?? "")"
            cell.lblMessage.text = "\"\(dicTestimonials.value(forKey: "message") ?? "")\""
            cell.lblDesignation.text = "\(dicTestimonials.value(forKey: "designation") ?? ""), \(dicTestimonials.value(forKey: "company") ?? "")"
            THelper.setImage(img: cell.imgUser, url: URL(string: "\(dicTestimonials.value(forKey: "image") ?? "")")!, placeholderImage: "")
            
            return cell
        }
        else if collectionView == cvBanner {
            self.cvBanner.register(UINib(nibName: "BannerCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BannerCell")
            let cell = cvBanner.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCollectionCell
            
            let dicBanner: NSDictionary = arrSlider[indexPath.item] as! NSDictionary
            
            self.pageControl.numberOfPages = arrSlider.count
            self.pageControl.currentPageIndicatorTintColor = UIColor.primaryColor()
            
            THelper.setImage(img: cell.imgBanner, url: URL(string: "\(dicBanner.value(forKey: "image") ?? "")")!, placeholderImage: "")
            
            return cell
        }
        else if collectionView == self.cvCategory {
            self.cvCategory.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
            let cell = cvCategory.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
            
            var dicCategory = NSDictionary()
            dicCategory = arrCategory[indexPath.item] as! NSDictionary
            
            if "\(dicCategory.value(forKey: "image") ?? "")" != "" {
                THelper.setImage(img: cell.imgCategories, url: URL(string: "\(dicCategory.value(forKey: "image") ?? "")")!, placeholderImage: "")
                cell.imgCategories = THelper.setTintColor(cell.imgCategories, tintColor: .white)
            }
            else {
                cell.imgCategories.image = UIImage(named: "")
                cell.imgCategories = THelper.setTintColor(cell.imgCategories, tintColor: .white)
            }
            
            cell.lblCategories.text = "\(dicCategory.value(forKey: "name") ?? "")".html2String
            
            cell.vwCategory.layer.cornerRadius = 10
            cell.vwCategory.layer.masksToBounds = true
            
            let index: Int = indexPath.item
            cell.lblCategories.textColor = arrColor[index % arrColor.count]
            cell.vwIcon.backgroundColor = arrColor[index % arrColor.count]
            
            return cell
        }
        else {
            var dicProducts = NSDictionary()
            
            if collectionView == self.cvRecentSearch {
                dicProducts = arrRecentSearch[indexPath.item] as! NSDictionary
            }
            else if collectionView == self.cvFeaturedProduct {
                dicProducts = arrFeaturedProduct[indexPath.item] as! NSDictionary
            }
            else if collectionView == self.cvNewestProduct {
                dicProducts = arrProducts[indexPath.item] as! NSDictionary
            }
            else if collectionView == self.cvDealProducts {
                dicProducts = arrDealProducts[indexPath.item] as! NSDictionary
            }
            else if collectionView == self.cvSuggestedProducts {
                dicProducts = arrSuggestedProducts[indexPath.item] as! NSDictionary
            }
            else if collectionView == self.cvOffers {
                dicProducts = arrOffers[indexPath.item] as! NSDictionary
            }
            else if collectionView == self.cvYouMayLike {
                dicProducts = arrYouMayLike[indexPath.item] as! NSDictionary
            }
            
            collectionView.register(UINib(nibName: "RecentSearchViewCell", bundle: nil), forCellWithReuseIdentifier: "RecentSearchViewCell")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentSearchViewCell", for: indexPath) as! RecentSearchViewCell
            
            if dicProducts.allKeys.count > 0 {
                cell.lblProductName.text = dicProducts.value(forKey: "name") as? String
                
                if dicProducts.value(forKey: "average_rating") != nil {
                    let rating = "\(dicProducts.value(forKey: "average_rating") ?? 0.0)"
                    cell.vwProductRatting.rating = Double(rating)!
                }
                else {
                    cell.vwProductRatting.rating = 0.0
                }
                
                if "\(dicProducts.value(forKey: SALES_PRICE) ?? "")" == "" {
                    if "\(dicProducts.value(forKey: PRICE) ?? "")" == "" {
                        cell.lblDiscountPrice.text = ""
                    }else {
                        cell.lblDiscountPrice.text = "\(PRICE_SIGN)\(dicProducts.value(forKey: PRICE) ?? "")"
                    }
                }else {
                    cell.lblDiscountPrice.text = "\(PRICE_SIGN)\(dicProducts.value(forKey: SALES_PRICE) ?? "")"
                }
                
                if "\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")" == "" {
                    if "\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")" == "" {
                        cell.lblActualPrice.text = ""
                    }else {
                        cell.lblActualPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
                    }
                }else {
                    cell.lblActualPrice.attributedText = THelper.attributeText(price: "\(PRICE_SIGN)\(dicProducts.value(forKey: REGULAR_PRICE) ?? "")")
                }
                
                if TValidation.isNull(dicProducts.value(forKey: FULL)) {
                    cell.imgProduct.image = UIImage(named: "")
                }
                else {
                    THelper.setImage(img: cell.imgProduct, url: URL(string: "\(dicProducts.value(forKey: FULL) ?? "")")!, placeholderImage: "")
                }
            }
            
            THelper.setShadow(view: cell)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cvTestimonials {}
        else if collectionView == cvBanner {
            let dicBanner: NSDictionary = arrSlider[indexPath.item] as! NSDictionary
            OpenWebView(strUrl: "\(dicBanner.value(forKey: "image") ?? "")")
        }
        else if collectionView == cvCategory {
            var dicCategory = NSDictionary()
            dicCategory = arrCategory[indexPath.item] as! NSDictionary
            var arrSubCategory = NSArray()
            
            if dicCategory.value(forKey: "subcategory") != nil {
                arrSubCategory = dicCategory.value(forKey: "subcategory") as! NSArray
            }
            else {
                arrSubCategory = []
            }
            
            let vc = SubCategoriesViewController(nibName: "SubCategoriesViewController", bundle: nil)
            vc.StrHeader = "\(dicCategory.value(forKey: "name") ?? "")".html2String
            vc.strCategoryId = "\(dicCategory.value(forKey: CAT_ID) ?? "")"
            if arrSubCategory.count > 0 {
                vc.subCategory = true
            }
            else {
                vc.subCategory = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if collectionView == cvRecentSearch {
            var dicProducts = NSDictionary()
            dicProducts = arrRecentSearch[indexPath.item] as! NSDictionary
            
            let vc = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
            vc.strProductID = "\(dicProducts.value(forKey: PRO_ID) ?? "")"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            var dicProducts = NSDictionary()
            var contains = Bool()
            
            if collectionView == self.cvFeaturedProduct {
                dicProducts = arrFeaturedProduct[indexPath.item] as! NSDictionary
            }
            else if collectionView == self.cvNewestProduct {
                dicProducts = arrProducts[indexPath.item] as! NSDictionary
            }
            else if collectionView == self.cvDealProducts {
                dicProducts = arrDealProducts[indexPath.item] as! NSDictionary
            }
            else if collectionView == self.cvSuggestedProducts {
                dicProducts = arrSuggestedProducts[indexPath.item] as! NSDictionary
            }
            else if collectionView == self.cvOffers {
                dicProducts = arrOffers[indexPath.item] as! NSDictionary
            }
            else if collectionView == self.cvYouMayLike {
                dicProducts = arrYouMayLike[indexPath.item] as! NSDictionary
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
                    TPreferences.removePreference(RECENT_SEARCH)
                    TPreferences.writeObject(RECENT_SEARCH, value: arrRecentSearch)
                    print(TPreferences.readObject(RECENT_SEARCH) ?? "")
                    cvRecentSearch.reloadData()
                }
            }
            else {
                arrRecentSearch.add(dicProducts)
                TPreferences.writeObject(RECENT_SEARCH, value: arrRecentSearch)
                print(TPreferences.readObject(RECENT_SEARCH) ?? "")
                cvRecentSearch.reloadData()
            }
            
            let vc = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
            vc.strProductID = "\(dicProducts.value(forKey: PRO_ID) ?? "")"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if IPAD {
            if collectionView == cvTestimonials {
                return CGSize(width:self.cvTestimonials.frame.width , height: self.cvTestimonials.frame.height)
            }
            else if collectionView == cvBanner {
                return CGSize(width:self.cvBanner.frame.width , height: self.cvBanner.frame.height)
            }
            else if collectionView == cvCategory {
                let label = UILabel(frame: CGRect.zero)
                var dicCategory = NSDictionary()
                dicCategory = arrCategory[indexPath.item] as! NSDictionary
                label.text = "\(dicCategory.value(forKey: "name") ?? "")".html2String
                label.sizeToFit()
                return CGSize(width: label.frame.width + 80, height: 100)
            }
            else if collectionView == cvRecentSearch {
                return CGSize(width:(self.cvRecentSearch.frame.width / 2) - 24 , height: 350)
            }
            else if collectionView == cvNewestProduct {
                return CGSize(width:(self.cvNewestProduct.frame.width / 2) - 24 , height: 350)
            }
            else if collectionView == cvFeaturedProduct {
                return CGSize(width:(self.cvFeaturedProduct.frame.width / 2) - 24 , height: 350)
            }
            else if collectionView == cvDealProducts {
                return CGSize(width:(self.cvDealProducts.frame.width / 2) - 24 , height: 350)
            }
            else if collectionView == cvSuggestedProducts {
                return CGSize(width:(self.cvSuggestedProducts.frame.width / 2) - 24 , height: 350)
            }
            else if collectionView == cvOffers {
                return CGSize(width:(self.cvOffers.frame.width / 2) - 24 , height: 350)
            }
            else if collectionView == cvYouMayLike {
                return CGSize(width:(self.cvYouMayLike.frame.width / 2) - 24 , height: 350)
            }
            else {
                return CGSize(width:0 , height: 0)
            }
        }else {
            if collectionView == cvTestimonials {
                return CGSize(width:self.cvTestimonials.frame.width , height: self.cvTestimonials.frame.height)
            }
            else if collectionView == cvBanner {
                return CGSize(width:self.cvBanner.frame.width , height: self.cvBanner.frame.height)
            }
            else if collectionView == cvCategory {
                let label = UILabel(frame: CGRect.zero)
                var dicCategory = NSDictionary()
                dicCategory = arrCategory[indexPath.item] as! NSDictionary
                label.text = "\(dicCategory.value(forKey: "name") ?? "")"
                label.sizeToFit()
                return CGSize(width: label.frame.width + 40, height: 70)
            }
            else if collectionView == cvRecentSearch {
                return CGSize(width:(self.cvRecentSearch.frame.width / 2) - 16 , height: 250)
            }
            else if collectionView == cvNewestProduct {
                return CGSize(width:(self.cvNewestProduct.frame.width / 2) - 16 , height: 250)
            }
            else if collectionView == self.cvFeaturedProduct {
                return CGSize(width:(self.cvFeaturedProduct.frame.width / 2) - 16 , height: 250)
            }
            else if collectionView == cvDealProducts {
                return CGSize(width:(self.cvDealProducts.frame.width / 2) - 16 , height: 250)
            }
            else if collectionView == cvSuggestedProducts {
                return CGSize(width:(self.cvSuggestedProducts.frame.width / 2) - 16 , height: 250)
            }
            else if collectionView == cvOffers {
                return CGSize(width:(self.cvOffers.frame.width / 2) - 16 , height: 250)
            }
            else if collectionView == cvYouMayLike {
                return CGSize(width:(self.cvYouMayLike.frame.width / 2) - 16 , height: 250)
            }
            else {
                return CGSize(width:0 , height: 0)
            }
        }
    }
    
    //MARK:-
    //MARK:- UIButton Clicked Events Method
    
    @IBAction func btnViewAllRecentSearch_Clicked(_ sender: Any) {
        let vc = NewestProductListViewController(nibName: "NewestProductListViewController", bundle: nil)
        vc.strHeading = "Recent Search"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnViewAllNewProduct_Clicked(_ sender: Any) {
        let vc = NewestProductListViewController(nibName: "NewestProductListViewController", bundle: nil)
        vc.strHeading = NEWEST_PRODUCT
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    @IBAction func btnViewAllPopularProduct_Clicked(_ sender: Any) {
        let vc = NewestProductListViewController(nibName: "NewestProductListViewController", bundle: nil)
        vc.strHeading = FEATURED_PRODUCTS
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnViewAllDealProducts_Clicked(_ sender: Any) {
        let vc = NewestProductListViewController(nibName: "NewestProductListViewController", bundle: nil)
        vc.strHeading = DEAL_PRODUCT
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnViewAllSuggestedProducts_Clicked(_ sender: Any) {
        let vc = NewestProductListViewController(nibName: "NewestProductListViewController", bundle: nil)
        vc.strHeading = SUGGESTED_PRODUCT
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnViewAllOffers_Clicked(_ sender: Any) {
        let vc = NewestProductListViewController(nibName: "NewestProductListViewController", bundle: nil)
        vc.strHeading = OFFER
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnViewAllYouMayLike_Clicked(_ sender: Any) {
        let vc = NewestProductListViewController(nibName: "NewestProductListViewController", bundle: nil)
        vc.strHeading = YOU_MAY_LIKE
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBanner1_Clicked(_ sender: Any) {
        OpenWebView(strUrl: strBanner1URL)
    }
    
    @IBAction func btnBanner2_Clicked(_ sender: Any) {
        OpenWebView(strUrl: strBanner2URL)
    }
    
    @IBAction func btnBanner3_Clicked(_ sender: Any) {
        OpenWebView(strUrl: strBanner3URL)
    }
    
    @IBAction func btnSearch_Clicked(_ sender: Any) {
        let vc = SearchViewController(nibName: "SearchViewController", bundle: nil)
         vc.isFormPayCard = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:-
    //MARK:- API Calling
    
    func DashboardAPI() {
        THelper.ShowProgress(vc: self)
        
        var param = [String : Any]()
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            param = [USER_ID: "\(TPreferences.readString(USER_ID) ?? "")"
                ] as [String : Any]
            print(param)
        }
        else {
            param = [USER_ID: ""] as [String : Any]
        }
            
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_DASHBOARD_URL)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        
                        self.arrProducts.removeAllObjects()
                        self.arrFeaturedProduct.removeAllObjects()
                        self.arrDealProducts.removeAllObjects()
                        self.arrSuggestedProducts.removeAllObjects()
                        self.arrOffers.removeAllObjects()
                        self.arrYouMayLike.removeAllObjects()
                        self.arrTestimonials.removeAllObjects()
                        
                        let dicDashboard: NSDictionary = data as! NSDictionary
                        let dicCurrencySymbol: NSDictionary = dicDashboard.value(forKey: "currency_symbol") as! NSDictionary
                                                
                        if dicDashboard.value(forKey: "total_order") != nil {
                            TPreferences.writeString(MY_ORDER_COUNT, value: "\(dicDashboard.value(forKey: "total_order") ?? "00")")
                        }
                        else {
                            TPreferences.writeString(MY_ORDER_COUNT, value: "00")
                        }
                        
                        if dicDashboard.value(forKey: "theme_color") != nil {
                            let strColor:  String = dicDashboard.value(forKey: "theme_color") as! String
                            var dicPlist = NSMutableDictionary()
                            var dicDefaultNight = NSMutableDictionary()
                            
                            dicPlist = THelper.plist(type: "default")!
                            dicDefaultNight = THelper.plist(type: "default_dark")!
                            
                            dicPlist.setValue(strColor, forKey: "Primary_Default_Color")
                            dicPlist.setValue(strColor, forKey: "header_color")
                            
                            dicDefaultNight.setValue(strColor, forKey: "Primary_Default_Color")
                            dicDefaultNight.setValue(strColor, forKey: "header_color")
                            
                            THelper.writeToFile(type: "default", resultDictionary: dicPlist)
                            THelper.writeToFile(type: "default_dark", resultDictionary: dicDefaultNight)
                            
                            TPreferences.writeString(THEME_COLOR, value: strColor)
                            PRIMARY_COLOR = TPreferences.readString(THEME_COLOR) ?? "fc4253"
                            if PRIMARY_COLOR == "" {
                                PRIMARY_COLOR = "fc4253"
                            }
                            self.themeChange()
                        }
                        else {
                            
                        }
                        
                        if dicDashboard.value(forKey: "social_link") != nil {
                            let dicSocialLink: NSDictionary = dicDashboard.value(forKey: "social_link") as! NSDictionary
                            
                            self.validateDic(dicSocialLink: dicSocialLink, key: CONTACT)
                            self.validateDic(dicSocialLink: dicSocialLink, key: FACEBOOK)
                            self.validateDic(dicSocialLink: dicSocialLink, key: INSTAGRAM)
                            self.validateDic(dicSocialLink: dicSocialLink, key: TWITTER)
                            self.validateDic(dicSocialLink: dicSocialLink, key: WHATSAPP)
                            self.validateDic(dicSocialLink: dicSocialLink, key: PRIVACY_POLICY)
                            self.validateDic(dicSocialLink: dicSocialLink, key: TERM_CONDITION)
                            self.validateDic(dicSocialLink: dicSocialLink, key: COPYRIGHT_TEXT)
                        }
                                
                        let dicBanner1: NSDictionary = dicDashboard.value(forKey: "banner_1") as! NSDictionary
                        if dicDashboard.value(forKey: "banner_1") != nil {
                            self.vwBanner1.isHidden = false
                            self.constraintVwBanner1Height.constant = 300
                            
                            THelper.setImage(img: self.imgBanner1, url: URL(string: "\(dicBanner1.value(forKey: "image") ?? "")")!, placeholderImage: "")
                            self.strBanner1URL = "\(dicBanner1.value(forKey: "url") ?? "")"
                        }
                        else {
                            self.vwBanner1.isHidden = true
                            self.constraintVwBanner1Height.constant = 0
                        }
                        
                        let dicBanner2: NSDictionary = dicDashboard.value(forKey: "banner_2") as! NSDictionary
                        if dicDashboard.value(forKey: "banner_2") != nil {
                            self.vwBanner2.isHidden = false
                            self.constraintVwBanner2Height.constant = 300
                            
                            THelper.setImage(img: self.imgBanner2, url: URL(string: "\(dicBanner2.value(forKey: "image") ?? "")")!, placeholderImage: "")
                            self.strBanner2URL = "\(dicBanner2.value(forKey: "url") ?? "")"
                        }
                        else {
                            self.vwBanner2.isHidden = true
                            self.constraintVwBanner2Height.constant = 0
                        }
                        
                        let dicBanner3: NSDictionary = dicDashboard.value(forKey: "banner_3") as! NSDictionary
                        if dicDashboard.value(forKey: "banner_3") != nil {
                            self.vwBanner3.isHidden = false
                            self.constraintVwBanner3Height.constant = 300
                            
                            THelper.setImage(img: self.imgBanner3, url: URL(string: "\(dicBanner3.value(forKey: "image") ?? "")")!, placeholderImage: "")
                            self.strBanner3URL = "\(dicBanner3.value(forKey: "url") ?? "")"
                        }
                        else {
                            self.vwBanner3.isHidden = true
                            self.constraintVwBanner3Height.constant = 0
                        }
                        
                        TPreferences.writeString(CURRENCY_SYMBOL, value: "\(dicCurrencySymbol.value(forKey: "currency_symbol") ?? "")")
                        
                        self.arrProducts.addObjects(from: dicDashboard.value(forKey: "newest") as! [Any])
                        self.arrFeaturedProduct.addObjects(from: dicDashboard.value(forKey: "featured") as! [Any])
                        self.arrDealProducts.addObjects(from: dicDashboard.value(forKey: "deal_product") as! [Any])
                        self.arrSuggestedProducts.addObjects(from: dicDashboard.value(forKey: "suggested_product") as! [Any])
                        self.arrOffers.addObjects(from: dicDashboard.value(forKey: "offer") as! [Any])
                        self.arrYouMayLike.addObjects(from: dicDashboard.value(forKey: "you_may_like") as! [Any])
                        self.arrTestimonials.addObjects(from: dicDashboard.value(forKey: "testimonials") as! [Any])
                        
                        self.reloadCollectionView()
                    }
                    else {
                        print(data)
                        self.reloadCollectionView()
                        self.constraintVwBanner1Height.constant = 0
                        self.constraintVwBanner2Height.constant = 0
                        self.constraintVwBanner3Height.constant = 0
                        
                        let dicError:NSDictionary = data as! NSDictionary
                        let str:String = dicError.value(forKey: "message") as! String
                        THelper.toast(str.html2String, vc: self)
                    }
                }
                break
                
            case .failure(_):
                self.reloadCollectionView()
                self.constraintVwBanner1Height.constant = 0
                self.constraintVwBanner2Height.constant = 0
                self.constraintVwBanner3Height.constant = 0
                
                THelper.hideProgress(vc: self)
                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                break
            }
        }
    }
            
    func getCategoriesAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_CATEGORIES)!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        self.arrCategory = arrtemp[0] as! NSArray
                        self.cvCategory.reloadData()
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
        
    func getSliderAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_SLIDER)!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        self.arrSlider = data as! NSArray
                        if self.arrSlider.count > 0 {
                            self.constraintSliderHeight.constant = 250
//                            self.AddImgScroll()
                            self.cvBanner.reloadData()
                        }
                        else {
                            self.constraintSliderHeight.constant = 0
                        }
                    }
                    else {
                        print(data)
                        self.constraintSliderHeight.constant = 0
                        let dicError:NSDictionary = data as! NSDictionary
                        let _:String = dicError.value(forKey: "message") as! String
//                        THelper.toast(str.html2String, vc: self)
                    }
                }
                break
                
            case .failure(_):
                self.constraintSliderHeight.constant = 0
                THelper.hideProgress(vc: self)
//                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                break
            }
        }
    }
    
    func validateDic(dicSocialLink: NSDictionary, key: String) {
        print(key.uppercased())
        
        if dicSocialLink.value(forKey: key) != nil {
            if "\(dicSocialLink.value(forKey: key) ?? "")" != "" {
                TPreferences.writeString(key, value: "\(dicSocialLink.value(forKey: key) ?? "")")
            }
            else {
                TPreferences.writeString(key, value: "")
            }
        }
        else {
            TPreferences.writeString(key, value: "")
        }
    }
}
