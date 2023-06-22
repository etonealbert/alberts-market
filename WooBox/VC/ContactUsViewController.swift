//
//  ContactUsViewController.swift

import UIKit
import GoogleMobileAds

class ContactUsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADInterstitialDelegate {

    @IBOutlet weak var tblContactUs: UITableView!
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    
    //MARK: -
    //MARK: - Variables
    
    var arrData = ["Call_Request","Email_Request"]
    var arrData2 = [Contact_Phone_No,Your_responce_text]
    
    var interstitial: GADInterstitial!
    
    //MARK: -
    //MARK: - UIView life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpObject()
    }
    
    //MARK: -
    //MARK: - SetUpObject
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
            
        } else {
            constraintHeaderTop.constant = UIApplication.shared.statusBarFrame.size.height
        }
        
        self.tblContactUs.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.lblHeaderTitle.text = LanguageLocal.myLocalizedString(key: "Contact_Us")
        
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            self.lblCount.isHidden = false
            self.lblCount.text = TPreferences.readString(CART_ITEM_COUNT)
            if IPAD {
                self.lblCount.layer.cornerRadius = 20 / 2
            } else {
                self.lblCount.layer.cornerRadius = self.lblCount.layer.frame.height / 2
            }
        }else {
            self.lblCount.isHidden = true
            self.lblCount.text = ""
        }

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
    
    // MARK:- UITableview Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblContactUs.register(UINib.init(nibName: "ContactUsTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactUsCell" )
        
        let cell = tblContactUs.dequeueReusableCell(withIdentifier: "ContactUsCell", for: indexPath) as! ContactUsTableViewCell
        cell.lblKey.text = LanguageLocal.myLocalizedString(key: "\(arrData[indexPath.row])")
        cell.lblValue.text = arrData2[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            var phone = String()
            phone = "\("TEL://")\(Contact_Phone_No)"
            let url: NSURL = URL(string: phone)! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
        }else if indexPath.row == 1 {
            let vc = EmailViewController(nibName: "EmailViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            
        }
    }

    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCart_Clicked(_ sender: Any) {
        let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
        vc.flagHeader = false
        vc.isFormPayCard = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
