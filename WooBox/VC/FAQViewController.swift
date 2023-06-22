//
//  FAQViewController.swift

import UIKit
import GoogleMobileAds

class FAQViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, GADInterstitialDelegate {

    @IBOutlet weak var tblFAQ: UITableView!
    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    //MARK: -
    //MARK: - Variables
    
    var arrData = ["Account_Deactive","Quick_Pay","Return_Items","Replace_Items"]
    var selectedIndex = 0
    
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
        
        self.tblFAQ.separatorStyle = UITableViewCell.SeparatorStyle.none
       
        
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
        
        self.lblHeaderTitle.text = LanguageLocal.myLocalizedString(key: "FAQ")
        
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
    
    // mark: UITableview Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblFAQ.register(UINib.init(nibName: "FAQTableViewCell", bundle: nil), forCellReuseIdentifier: "FAQCell" )
        
        let cell = tblFAQ.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as! FAQTableViewCell
        cell.lblkey.text = LanguageLocal.myLocalizedString(key: "\(arrData[indexPath.row])")
        if selectedIndex == indexPath.row {
            cell.lblValue.isHidden = false
            if IPAD {
                cell.constraintlblValueHeight.constant = 70.0
            }else {
                cell.constraintlblValueHeight.constant = 60.0
            }
        }else {
            cell.lblValue.isHidden = true
            cell.constraintlblValueHeight.constant = 0.0
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        print("Selected Index = \(selectedIndex)")
        self.tblFAQ.reloadData()
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
