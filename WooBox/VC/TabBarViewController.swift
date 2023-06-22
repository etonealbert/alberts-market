//
//  TabBarViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire

class TabBarViewController: UIViewController {
    
    //MARK:-
    //MARK:- Outlets
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnwishList: UIButton!
    @IBOutlet weak var btnMyCart: UIButton!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var btnSerach: UIButton!
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    @IBOutlet weak var imgTabBar: UIImageView!
    @IBOutlet weak var vwMain: UIView!
    
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var lblProductMyCart: UILabel!
    
    //MARK:-
    //MARK:- Variables
    
    var home = HomeViewController()
    var Profile = EditProfileViewController()
    var WishList = WishListViewController()
    var MyCart = MyCartViewController()
    var dashboard1 = Dashboard1ViewController()
    
    var arrCart = NSArray()
    
    
    //MARK:-
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpObject()
    }

    //MARK:-
    //MARK:- SetUpObject Method
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        
        self.btnMenu.addTarget(self.navigationController, action:#selector(showMenu) , for: .touchUpInside)
//        btnMenu.setImage(THelper.rotateBtn(img: "icoMenu"), for: .normal)
        
        self.imgTabBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.imgTabBar.layer.shadowRadius = 10.0
        self.imgTabBar.layer.opacity = 0.8
        self.imgTabBar.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        self.btnHome.isSelected = true
        
        getCartCount()
        
        if IPAD {
            self.btnHome.layer.cornerRadius = 50 / 2
            self.lblProductMyCart.layer.cornerRadius = 20 / 2
        }else {
            self.btnHome.layer.cornerRadius = self.btnHome.layer.frame.height / 2
            self.lblProductMyCart.layer.cornerRadius = self.lblProductMyCart.layer.frame.height / 2
        }
        setOpacity(btn: btnHome)
        self.btnHome = THelper.setButtonTintColor(self.btnHome, imageName: "icoHome", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "header_color"))
        self.btnAccount.backgroundColor = UIColor.clear
        self.btnAccount = THelper.setButtonTintColor(self.btnAccount, imageName: "icoProfile", state: .normal, tintColor: UIColor.black)
        
        self.lblHeader.text = LanguageLocal.myLocalizedString(key: "Home")
        WishList.view.removeFromSuperview()
        MyCart.view.removeFromSuperview()

        Profile.view.removeFromSuperview()
        getDashboard()
//        addChild(home)
//        vwMain.addSubview(home.view)
//        home.didMove(toParent: self)
//        home.view.frame = vwMain.bounds
//        home.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNotification(_:)), name: NSNotification.Name("CartCount"), object: nil)
    }
    
    //MARK:-
    //MARK:- Other Method
    
    @objc func showMenu() {
        let vc = SideMenuViewController(nibName: "SideMenuViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getCartCount() {
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            self.lblProductMyCart.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            self.lblProductMyCart.isHidden = false
            lblProductMyCart.text = TPreferences.readString(CART_ITEM_COUNT)
        }else {
            self.lblProductMyCart.isHidden = true
        }
    }
    
    func setOpacity(btn: UIButton) {
        btn.backgroundColor = UIColor.primaryColor().withAlphaComponent(0.20)
        btn.isOpaque = false
    }
    
    func getDashboard() {
        let dashboardStyle: String = TPreferences.readString(DASHBOARD_STYLE) ?? "0"
        btnSerach.isHidden = false
        if dashboardStyle == "0" {
            changeDashboard(vc: home)
        }
        else if dashboardStyle == "1" {
            btnSerach.isHidden = true
            changeDashboard(vc: dashboard1)
        }
        else {
            changeDashboard(vc: home)
        }
    }
    
    func changeDashboard(vc: UIViewController) {
        addChild(vc)
        vwMain.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.view.frame = vwMain.bounds
        vc.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    // MARK: -
    // MARK: - Receive Notification
    
    @objc func receiveNotification(_ notification: Notification?) {
        
        if let aNotification = notification {
            print("\(aNotification)")
        }
        getCartCount()
    }
    
    //MARK:-
    //MARK:- UIButton Clicked Events Method
    
    @IBAction func btnHome_Clicked(_ sender: Any) {
        self.lblHeader.text = LanguageLocal.myLocalizedString(key: "Home")
        if IPAD {
            self.btnHome.layer.cornerRadius = 50 / 2
        }else {
            self.btnHome.layer.cornerRadius = self.btnHome.layer.frame.height / 2
        }
        
        setOpacity(btn: btnHome)
        self.btnHome = THelper.setButtonTintColor(self.btnHome, imageName: "icoHome", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "header_color"))
        
        self.btnwishList.backgroundColor = UIColor.clear
        self.btnwishList = THelper.setButtonTintColor(self.btnwishList, imageName: "icoHeart", state: .normal, tintColor: UIColor.black)
        
        self.btnMyCart.backgroundColor = UIColor.clear
        
        getCartCount()
        
        self.btnMyCart = THelper.setButtonTintColor(self.btnMyCart, imageName: "icoShoppingCart", state: .normal, tintColor: UIColor.black)
        
        self.btnAccount.backgroundColor = UIColor.clear
        self.btnAccount = THelper.setButtonTintColor(self.btnAccount, imageName: "icoProfile", state: .normal, tintColor: UIColor.black)
        self.btnSerach.isHidden = false
        
        WishList.view.removeFromSuperview()
        MyCart.view.removeFromSuperview()
        Profile.view.removeFromSuperview()
        getDashboard()
//        addChild(home)
//        vwMain.addSubview(home.view)
//        home.didMove(toParent: self)
//        home.view.frame = vwMain.bounds
//        home.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    @IBAction func btnFavourite(_ sender: Any) {
        WishList.isWishInList = false
        self.lblHeader.text = LanguageLocal.myLocalizedString(key: "Wishlist")
        self.btnwishList.isSelected = false
        if IPAD {
            self.btnwishList.layer.cornerRadius = 50 / 2
        }else {
            self.btnwishList.layer.cornerRadius = self.btnHome.layer.frame.height / 2
        }
        
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            self.btnwishList.layer.cornerRadius = self.btnwishList.layer.frame.height / 2
            setOpacity(btn: btnwishList)
            self.btnwishList = THelper.setButtonTintColor(self.btnwishList, imageName: "icoHeart", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "header_color"))
            
            self.btnHome.backgroundColor = UIColor.clear
            self.btnHome = THelper.setButtonTintColor(self.btnHome, imageName: "icoHome", state: .normal, tintColor: UIColor.black)
            
            self.btnMyCart.backgroundColor = UIColor.clear
            self.btnMyCart = THelper.setButtonTintColor(self.btnMyCart, imageName: "icoShoppingCart", state: .normal, tintColor: UIColor.black)
            
            self.btnAccount.backgroundColor = UIColor.clear
            self.btnAccount = THelper.setButtonTintColor(self.btnAccount, imageName: "icoProfile", state: .normal, tintColor: UIColor.black)
            self.btnSerach.isHidden = true
            
            self.lblProductMyCart.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            self.lblProductMyCart.isHidden = false
            lblProductMyCart.text = TPreferences.readString(CART_ITEM_COUNT)
            
            home.view.removeFromSuperview()
            MyCart.view.removeFromSuperview()
            Profile.view.removeFromSuperview()
            addChild(WishList)
            vwMain.addSubview(WishList.view)
            WishList.didMove(toParent: self)
            WishList.view.frame = vwMain.bounds
            WishList.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            WishList.getWishlistAPI()
        }
        else {
            self.lblProductMyCart.isHidden = true
            
            setOpacity(btn: btnHome)
            self.btnHome = THelper.setButtonTintColor(self.btnHome, imageName: "icoHome", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "header_color"))
            
            let vc = signInViewController(nibName: "signInViewController", bundle: nil)
            AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
            frostedViewController?.hideMenuViewController()
        }
    }
    
    @IBAction func btnShoppingCart_Clicked(_ sender: Any) {
        self.lblHeader.text = LanguageLocal.myLocalizedString(key: "My_Cart")
        if IPAD {
            self.btnMyCart.layer.cornerRadius = 50 / 2
        }else {
            self.btnMyCart.layer.cornerRadius = self.btnHome.layer.frame.height / 2
        }
        
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            self.btnMyCart.layer.cornerRadius = self.btnMyCart.layer.frame.height / 2
            self.lblProductMyCart.isHidden = true
            
            setOpacity(btn: btnMyCart)
            self.btnMyCart = THelper.setButtonTintColor(self.btnMyCart, imageName: "icoShoppingCart", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "header_color"))
            
            self.btnHome.backgroundColor = UIColor.clear
            self.btnHome = THelper.setButtonTintColor(self.btnHome, imageName: "icoHome", state: .normal, tintColor: UIColor.black)
            
            self.btnwishList.backgroundColor = UIColor.clear
            self.btnwishList = THelper.setButtonTintColor(self.btnwishList, imageName: "icoHeart", state: .normal, tintColor: UIColor.black)
            
            self.btnAccount.backgroundColor = UIColor.clear
            self.btnAccount = THelper.setButtonTintColor(self.btnAccount, imageName: "icoProfile", state: .normal, tintColor: UIColor.black)
            self.btnSerach.isHidden = true
            
            home.view.removeFromSuperview()
            WishList.view.removeFromSuperview()
            Profile.view.removeFromSuperview()
            addChild(MyCart)
            vwMain.addSubview(MyCart.view)
            MyCart.didMove(toParent: self)
            MyCart.view.frame = vwMain.bounds
            MyCart.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            MyCart.flagHeader = true
            MyCart.getCartAPI()
        }
        else {
            setOpacity(btn: btnHome)
            self.btnHome = THelper.setButtonTintColor(self.btnHome, imageName: "icoHome", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "header_color"))
            
            let vc = signInViewController(nibName: "signInViewController", bundle: nil)
            AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
            frostedViewController?.hideMenuViewController()
        }
    }
    
    @IBAction func btnProfile_Clicked(_ sender: Any) {
        Profile.isSideMenu = false
        self.lblHeader.text = LanguageLocal.myLocalizedString(key: "Profile")
        if IPAD {
            self.btnAccount.layer.cornerRadius = 50 / 2
        }else {
            self.btnAccount.layer.cornerRadius = self.btnHome.layer.frame.height / 2
        }
        
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            self.lblProductMyCart.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            self.lblProductMyCart.isHidden = false
            
            lblProductMyCart.text = TPreferences.readString(CART_ITEM_COUNT)
            
            setOpacity(btn: btnAccount)
            self.btnAccount = THelper.setButtonTintColor(self.btnAccount, imageName: "icoProfile", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "header_color"))
            
            self.btnHome.backgroundColor = UIColor.clear
            self.btnHome = THelper.setButtonTintColor(self.btnHome, imageName: "icoHome", state: .normal, tintColor: UIColor.black)
            
            self.btnwishList.backgroundColor = UIColor.clear
            self.btnwishList = THelper.setButtonTintColor(self.btnwishList, imageName: "icoHeart", state: .normal, tintColor: UIColor.black)
            
            self.btnMyCart.backgroundColor = UIColor.clear
            self.btnMyCart = THelper.setButtonTintColor(self.btnMyCart, imageName: "icoShoppingCart", state: .normal, tintColor: UIColor.black)
            
            self.btnSerach.isHidden = true
            home.view.removeFromSuperview()
            WishList.view.removeFromSuperview()
            MyCart.view.removeFromSuperview()
            addChild(Profile)
            vwMain.addSubview(Profile.view)
            Profile.didMove(toParent: self)
            Profile.view.frame = vwMain.bounds
            Profile.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        }
        else {
            self.lblProductMyCart.isHidden = true
            
            setOpacity(btn: btnHome)
            self.btnHome = THelper.setButtonTintColor(self.btnHome, imageName: "icoHome", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "header_color"))
            
            let vc = signInViewController(nibName: "signInViewController", bundle: nil)
            AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
            frostedViewController?.hideMenuViewController()
        }
    }
    
    @IBAction func btnSearch_Clicked(_ sender: Any) {
        let vc = SearchViewController(nibName: "SearchViewController", bundle: nil)
         vc.isFormPayCard = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
