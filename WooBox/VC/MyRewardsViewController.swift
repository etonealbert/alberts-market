//
//  MyRewardsViewController.swift

import UIKit
import SRScratchView
import Alamofire
import OAuthSwiftAlamofire

class MyRewardsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,SRScratchViewDelegate {
   
    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var constraintCvScratchCardHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    
    @IBOutlet weak var ConstraintPopupHeightArea: NSLayoutConstraint!
    @IBOutlet weak var cvScratchCard: UICollectionView!
    
    @IBOutlet weak var vwScratch: UIView!

    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgCuopn: UIImageView!
    @IBOutlet weak var scratchCardView: UIView!
    @IBOutlet weak var vwPopup: UIView!
    @IBOutlet weak var scratchImageView: SRScratchView!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblRewardMsg: UILabel!
    
    @IBOutlet weak var btnInviteNow: UIButton!
    //MARK: -
    //MARK: - Variables
    
    var arrImgScartchCard = ["Samantha","walkThrough","Samantha","Samantha","walkThrough","Samantha","Samantha"]

    var arrScartch = NSMutableArray()
    var arrCoupons = NSArray()
    var scartchIndex: Int = 0
    var isSideMenu = Bool()
    
    //MARK: -
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpObject()
    }

    //MARK: -
    //MARK: - Other Methods
    
    func scratchCardEraseProgress(eraseProgress: Float) {
        print(eraseProgress)
        if eraseProgress > 75.0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.arrScartch.add(self.scartchIndex)
                self.scratchImageView.alpha = 0.0
            })
        }
    }
    
    func scratchCard() {
        scratchImageView.lineWidth = 40.0
        self.scratchImageView.delegate = self
        self.scratchCardView.layer.cornerRadius = 8
        self.scratchCardView.layer.masksToBounds = true
        self.scratchImageView.layer.cornerRadius = 8
        self.scratchImageView.layer.masksToBounds = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.vwPopup.isHidden = true
        self.vwScratch.isHidden = true
        self.cvScratchCard.reloadData()
    }
    
    //MARK: -
    //MARK: - SetUpObject Method
    
    func SetUpObject(){
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
            self.ConstraintPopupHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        self.lblHeaderTitle.text = LanguageLocal.myLocalizedString(key: "My_Rewards")
        self.lblRewardMsg.text = LanguageLocal.myLocalizedString(key: "Rewards_Msg")
        self.btnInviteNow.setTitle(LanguageLocal.myLocalizedString(key: "Invite_Now"), for: .normal)
        self.vwPopup.isHidden = true
        self.vwScratch.isHidden = true
        self.btnClose = THelper.setButtonTintColor(self.btnClose, imageName: "icoCancel", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
        TPreferences.writeString(REWARD_COUNT, value: "\(self.arrImgScartchCard.count)")
    }
    
    //MARK: -
    //MARK: - UICollectionView Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        var temp: Int = 0
        if arrImgScartchCard.count % 2 == 0  {
            count = arrImgScartchCard.count
        }else {
            count = arrImgScartchCard.count + 1
        }
        temp = (count / 2) * 10
        if IPAD {
            self.constraintCvScratchCardHeight.constant = CGFloat(count * 250) / 2 + CGFloat(temp)
        }else {
            self.constraintCvScratchCardHeight.constant = CGFloat(count * 180) / 2 + CGFloat(temp)
        }
        return arrImgScartchCard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cvScratchCard.register(UINib(nibName: "ScratchCardCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ScratchCell")
        let cell = cvScratchCard.dequeueReusableCell(withReuseIdentifier: "ScratchCell", for: indexPath) as! ScratchCardCollectionCell
        cell.imgCoupon.image = UIImage(named: arrImgScartchCard[indexPath.row])
        cell.imgMask.image = UIImage(named: "srachView")
        if arrScartch.contains(indexPath.item) {
            cell.imgMask.isHidden = true
        }else {
            cell.imgMask.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwPopup.addGestureRecognizer(tapGesture)
        imgCuopn.image = UIImage(named: arrImgScartchCard[indexPath.row])

        if arrScartch.contains(indexPath.item) {
          THelper.toast("Coupon has been already used", vc: self)
            self.vwPopup.isHidden = false
            self.vwScratch.isHidden = false
        } else {
            scartchIndex = indexPath.item
            self.scratchImageView.alpha = 1.0
            self.scratchImageView.image = UIImage(named: "srachView")
            self.vwPopup.isHidden = false
            self.vwScratch.isHidden = false
            scratchCard()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if IPAD {
            return CGSize(width: (cvScratchCard.frame.width / 2) - 16, height: 250)
        }else {
            return CGSize(width: (cvScratchCard.frame.width / 2) - 16, height: 180)
        }
    }
    
    //MARK: -
    //MARK: - UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnInvite_Clicked(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: (SCREEN_SIZE.width / 2) - 150, y: SCREEN_SIZE.height, width: 300, height: 300)
        activityVC.popoverPresentationController?.permittedArrowDirections = .down
        present(activityVC, animated: true)
    }
    
    
    @IBAction func btnColse_Clicked(_ sender: Any) {
        self.vwPopup.isHidden = true
        self.vwScratch.isHidden = true
        self.cvScratchCard.reloadData()
    }
    
    
    //MARK: -
    //MARK: - API Calling
    
    func getCouponsAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(COUPONS)!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        self.arrCoupons = arrtemp[0] as! NSArray
                        self.cvScratchCard.reloadData()
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
}
