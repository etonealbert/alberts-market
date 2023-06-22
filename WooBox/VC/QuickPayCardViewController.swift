//
//  QuickPayCardViewController.swift

import UIKit
import FCAlertView
import GoogleMobileAds

class QuickPayCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FCAlertViewDelegate, GADBannerViewDelegate {

    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    @IBOutlet weak var constraintVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblCards: UITableView!
    
    @IBOutlet weak var btnAddCard: UIButton!
    
    @IBOutlet weak var lblQuickPay: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet weak var vwBanner: UIView!
    
    var cardIndex = Int()
    
    var bannerView: GADBannerView!
    
    //MARK: -
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpObject()
    }
    
    //MARK: -
    //MARK: - SetUpObject Method
    
    func SetUpObject(){
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
       
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
        
        self.lblQuickPay.text = LanguageLocal.myLocalizedString(key: "Quick_Pay")
        self.btnAddCard.setTitle(LanguageLocal.myLocalizedString(key: "Add_Card"), for: .normal)
        
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
    //MARK: - UITableview Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblCards.register(UINib.init(nibName: "CardsTableViewCell", bundle: nil), forCellReuseIdentifier: "CardCell" )
        
        let cell = tblCards.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardsTableViewCell
        if IPAD {
            cell.vwCard.layer.cornerRadius = 15.0
        }else {
            cell.vwCard.layer.cornerRadius = 10.0
        }
        cell.vwCard.clipsToBounds = true
        if cardIndex == indexPath.row {
            cell.btnCheck.setImage(UIImage(named: "icoRadioChecked"), for: .normal)
        }
        else {
            cell.btnCheck.setImage(UIImage(named: "icoRadioUnchecked"), for: .normal)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cardIndex = indexPath.row
        tblCards.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            let vc = AddEditAddressViewController(nibName: "AddEditAddressViewController", bundle: nil)
            vc.isFromAddressManager = true
            vc.isFromEdit = true
            self.present(vc, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        editAction.backgroundColor = .orange
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            THelper.displayAlert(self, title: "", message: "Are you sure you want to Delete this Address", tag: 101, firstButton: "Cancel", doneButton: "OK")
            self.cardIndex = indexPath.row
        }
        deleteAction.backgroundColor = .red
        
        return [editAction,deleteAction]
    }
    
    
    //MARK: -
    //MARK: -fcAlertDoneButtonClicked
    
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView?) {
        if alertView?.tag == 101 {
            print("item Delete:-\(self.cardIndex)")
            tblCards.reloadData()
        }
    }
    
    
    @IBAction func btnback_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSearch_Clicked(_ sender: Any) {
        let vc = SearchViewController(nibName: "SearchViewController", bundle: nil)
        vc.isFormPayCard = true
       self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnMyCartClicked(_ sender: Any) {
        let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
        vc.isFormPayCard = true
        vc.flagHeader = false
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnAddCard_Clicked(_ sender: Any) {
        let vc = AddNewCardViewController(nibName: "AddNewCardViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
}
