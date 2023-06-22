//
//  WebViewController.swift

import UIKit
import WebKit
import Alamofire
import OAuthSwiftAlamofire

class WebViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var vwWebView: UIView!
    
    var webView: WKWebView!
    var strUrl = String()
    var strHeading = String()
    var isFromPayment = Bool()
    var isFromAboutUs = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpObject()
    }
    
    //MARK: -
    //MARK: - Set Up Object
    
    func setUpObject() {
        if #available(iOS 11.0, *) {
            
        } else {
            constraintHeaderTop.constant = UIApplication.shared.statusBarFrame.size.height
        }
        THelper.ShowProgress(vc: self)
        
        webView = WKWebView()
        webView.uiDelegate = self
        self.vwWebView.addSubview(webView)
        
        let myURL = URL(string: strUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        lblHeading.text = strHeading
        
        THelper.hideProgress(vc: self)
    }
    
    override func viewDidLayoutSubviews() {
        webView.frame = CGRect(x: 0, y: 0, width: self.vwWebView.frame.size.width, height: self.vwWebView.frame.size.height)
    }
    
    //MARK: -
    //MARK: - UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        if isFromPayment {
            let vc = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
            AppDelegate.getDelegate()?.navigationController = TNavigationViewController(rootViewController: vc)
            AppDelegate.getDelegate()?.navigationController.isNavigationBarHidden = true
            if let aController = AppDelegate.getDelegate()?.navigationController {
                self.frostedViewController.contentViewController = aController
            }
            
//            let vc: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//            self.navigationController!.popToViewController(vc[vc.count - 3], animated: true)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
