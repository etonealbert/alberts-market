//
//  ReviewsViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import FCAlertView
import Cosmos

class ReviewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, FCAlertViewDelegate {
    
    @IBOutlet weak var ConstraintTableHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintLbl5StarWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintLbl4StarWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintLbl3StarWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintLbl2StarWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintLbl1StarWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tblReview: UITableView!
    @IBOutlet weak var imgStar: UIImageView!
    
    @IBOutlet weak var pvFiveStar: UIProgressView!
    @IBOutlet weak var pvFourStar: UIProgressView!
    @IBOutlet weak var pvThreeStar: UIProgressView!
    @IBOutlet weak var pvTwoStar: UIProgressView!
    @IBOutlet weak var pvOneStar: UIProgressView!
    
    @IBOutlet weak var lbl5Star: UILabel!
    @IBOutlet weak var lbl4Star: UILabel!
    @IBOutlet weak var lbl3Star: UILabel!
    @IBOutlet weak var lbl2Star: UILabel!
    @IBOutlet weak var lbl1Star: UILabel!
    @IBOutlet weak var lbl5StarValue: UILabel!
    @IBOutlet weak var lbl4StarValue: UILabel!
    @IBOutlet weak var lbl3StarValue: UILabel!
    @IBOutlet weak var lbl2StarValue: UILabel!
    @IBOutlet weak var lbl1StarValue: UILabel!
    @IBOutlet weak var lblReviews: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRatings: UILabel!
    @IBOutlet weak var lblTitleReviews: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblReviewHeading: UILabel!
    
    @IBOutlet weak var vwStars: UIView!
    @IBOutlet weak var vw5Star: UIView!
    @IBOutlet weak var vw4Star: UIView!
    @IBOutlet weak var vw3Star: UIView!
    @IBOutlet weak var vw2Star: UIView!
    @IBOutlet weak var vw1Star: UIView!
    
    @IBOutlet weak var vwReview: UIView!
    @IBOutlet weak var vwReviewBackground: UIView!
    @IBOutlet weak var vwRating: CosmosView!
    
    @IBOutlet weak var txtReview: UITextField!

    
    @IBOutlet weak var btnReviewNow: UIButton!
    @IBOutlet weak var btnSubmitReview: UIButton!
    
    @IBOutlet weak var btn1Star: UIButton!
    @IBOutlet weak var btn2Star: UIButton!
    @IBOutlet weak var btn3Star: UIButton!
    @IBOutlet weak var btn4Star: UIButton!
    @IBOutlet weak var btn5Star: UIButton!

    
    var arrReviews = NSArray()
    var tag = Int()
    var isFromAdd = Bool()
    var isFirstTime = Bool()
    var strProductID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.SetUpObject()
    }
    
    // MARK:-
    // MARK:- Set Up Object
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
            
        } else {
            constraintHeaderTop.constant = UIApplication.shared.statusBarFrame.size.height
        }
        getProductReviewAPI()
        tag = -1
        
        tblReview.tableFooterView = UIView(frame: .zero)
        tblReview.separatorStyle = UITableViewCell.SeparatorStyle.none
        if IPAD {
            self.vwStars.layer.cornerRadius = 200 / 2
        }else {
            self.vwStars.layer.cornerRadius = self.vwStars.frame.size.height / 2
        }
        imgStar = THelper.setTintColor(imgStar, tintColor: UIColor.yellow)
                
        self.lblRatings.text = LanguageLocal.myLocalizedString(key: "Rattings")
        self.lblTitleReviews.text = LanguageLocal.myLocalizedString(key: "Reviews")
        self.lblHeading.text = LanguageLocal.myLocalizedString(key: "More_Info")
        self.lblReviewHeading.text = LanguageLocal.myLocalizedString(key: "Reviews")
        self.btnReviewNow.setTitle(LanguageLocal.myLocalizedString(key: "Rate_Now"), for: .normal)
        self.btnSubmitReview.setTitle(LanguageLocal.myLocalizedString(key: "Submit_Review"), for: .normal)
        
        vwReview.layer.cornerRadius = 10.0
        vwReview.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwReviewBackground.addGestureRecognizer(tapGesture)
    }
    
    func SetUpValue() {
        let widthOfSuperview = vw1Star.bounds.width
        var dicReviews = NSDictionary()
        var fiveStar:Int = 0
        var fourStar:Int = 0
        var threeStar:Int = 0
        var twoStar:Int = 0
        var oneStar:Int = 0
        let totalStar:Int = arrReviews.count
        
        for i in 0..<arrReviews.count {
            dicReviews = arrReviews[i] as! NSDictionary
            let star:Int = dicReviews.value(forKey: "rating") as! Int
            if star == 5 {
                fiveStar += 1
            }
            else if star == 4 {
                fourStar += 1
            }
            else if star == 3 {
                threeStar += 1
            }
            else if star == 2 {
                twoStar += 1
            }
            else if star == 1 {
                oneStar += 1
            }
        }
        
        if oneStar != 0 {
            pvOneStar.progress = calculate(total: totalStar, starCount: oneStar)
            lbl1StarValue.text = "\(oneStar)"
//            constraintLbl1StarWidth.constant = widthOfSuperview * CGFloat(((totalStar / oneStar) / 100))
        }
        else {
            pvOneStar.progress = 0.0
            lbl1StarValue.text = "0"
        }
        if twoStar != 0 {
            pvTwoStar.progress = calculate(total: totalStar, starCount: twoStar)
            lbl2StarValue.text = "\(twoStar)"
//            constraintLbl2StarWidth.constant = widthOfSuperview * CGFloat(((totalStar / twoStar) / 100))
        }
        else {
            pvTwoStar.progress = 0.0
            lbl2StarValue.text = "0"
        }
        if threeStar != 0 {
            pvThreeStar.progress = calculate(total: totalStar, starCount: threeStar)
            lbl3StarValue.text = "\(threeStar)"
//           constraintLbl3StarWidth.constant = widthOfSuperview * CGFloat(((totalStar / threeStar) * 10) / 100)
        }
        else {
            pvThreeStar.progress = 0.0
            lbl3StarValue.text = "0"
        }
        if fourStar != 0 {
            pvFourStar.progress = calculate(total: totalStar, starCount: fourStar)
            lbl4StarValue.text = "\(fourStar)"
//            constraintLbl4StarWidth.constant = widthOfSuperview * CGFloat(((totalStar / fourStar) * 10) / 100)
        }
        else {
            pvFourStar.progress = 0.0
            lbl4StarValue.text = "0"
        }
        if fiveStar != 0 {
            pvFiveStar.progress = calculate(total: totalStar, starCount: fiveStar)
            lbl5StarValue.text = "\(fiveStar)"
//            constraintLbl5StarWidth.constant = widthOfSuperview * CGFloat(((totalStar / fiveStar) * 10) / 100)
        }
        else {
            pvFiveStar.progress = 0.0
            lbl5StarValue.text = "0"
        }
        
        lblRating.text = "\(arrReviews.count)"
    }
    
    func calculate(total:Int, starCount:Int) -> Float {
        let a:Float = Float(total / starCount)
        let b:Float = Float(a * 10)
        let c:Float = Float(b / 100)
        let d:Float = Float(1.0 - c)
        return d
    }

    // MARK:-
    // MARK:- UITableview Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lblReviews.text = "\(arrReviews.count) \(LanguageLocal.myLocalizedString(key: "Reviews"))"
        return arrReviews.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD {
            self.ConstraintTableHeight.constant = CGFloat((arrReviews.count * 100))
            return 100
        }else {
            self.ConstraintTableHeight.constant = CGFloat((arrReviews.count * 70))
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblReview.register(UINib.init(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell" )
        
        let cell = tblReview.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
        
        var dicReview = NSDictionary()
        dicReview = arrReviews[indexPath.row] as! NSDictionary
        cell.lblReview.text = "\(dicReview.value(forKey: "review") ?? "")".html2String
        cell.lblReviewerName.text = "\(dicReview.value(forKey: "name") ?? "")"
        cell.lblRating.text = "\(dicReview.value(forKey: "rating") ?? "")"
        
        cell.lblDate.text = "\(dicReview.value(forKey: "date_created") ?? "")"
//            THelper.dateFormatter(dicReview.value(forKey: "date_created") as? String, format1: "dd/MMM/yyyy", format2: "yyyy-MM-ddThh:mm:ss")
        print(cell.lblDate.text ?? "")
        
        if cell.lblRating.text == "5" || cell.lblRating.text == "4" {
            cell.vwRating.backgroundColor = UIColor.init(hexString: "049109")
        }else if cell.lblRating.text == "3" || cell.lblRating.text == "3" {
            cell.vwRating.backgroundColor = UIColor.init(hexString: "D5B000")
        }else {
            cell.vwRating.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
        }
        
        if "\(dicReview.value(forKey: "email") ?? "")" == "\(TPreferences.readString(USER_EMAIL) ?? "")" {
            cell.btnEditDelete.isHidden = false
        }
        else {
            cell.btnEditDelete.isHidden = true
        }
        
        cell.btnEditDelete.tag = indexPath.row
        cell.btnEditDelete.addTarget(self, action: #selector(onClickEditDelete(_:)), for: UIControl.Event.touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: -
    //MARK: - Cell UIButton Action Method
    
    @objc func onClickEditDelete(_ sender: UIButton?) {
        tag = sender!.tag
        let dicReview: NSDictionary = arrReviews[tag] as! NSDictionary
        
        let alert = UIAlertController(title: "", message: "Choose Action", preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default, handler: { action in
            self.txtReview.text = "\(dicReview.value(forKey: "review") as! String)".html2String
            self.vwReviewBackground.isHidden = false
            self.vwReview.isHidden = false
        })
        let delete = UIAlertAction(title: "Delete", style: .default, handler: { action in
            THelper.displayAlert(self, title: "", message: "Are you sure you want to delete the review", tag: 101, firstButton: "Cancel", doneButton: "OK")
        })
        let defaultAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(defaultAction)
        
        alert.popoverPresentationController?.sourceView = view
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        alert.popoverPresentationController?.sourceRect = CGRect(x: (screenWidth / 2) - 150, y: screenHeight, width: 300, height: 300)
        alert.popoverPresentationController?.permittedArrowDirections = .down
        present(alert, animated: true)
    }
    
    //MARK: -
    //MARK: - UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitReview(_ sender: Any) {
        let strReview: String = txtReview.text ?? ""
        let rating: Int = Int(vwRating?.rating ?? 0.0)
        if isFromAdd {
            if TPreferences.readBoolean(IS_LOGGED_IN) {
                addProductReviewAPI(review: strReview, rating: rating)
            }
            else {
                let vc = signInViewController(nibName: "signInViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            if TPreferences.readBoolean(IS_LOGGED_IN) {
                editProductReviewAPI(reviewId: tag, review: strReview, rating: rating)
            }
            else {
                let vc = signInViewController(nibName: "signInViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        vwReviewBackground.isHidden = true
        vwReview.isHidden = true
    }
    
    @IBAction func btnReviewNow_Clicked(_ sender: Any) {
        self.txtReview.text = ""
        isFromAdd = true
        vwReviewBackground.isHidden = false
        vwReview.isHidden = false
    }
    
    //MARK: -
    //MARK: -fcAlertDoneButtonClicked
    
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView?) {
        let dicReview: NSDictionary = arrReviews[tag] as! NSDictionary
        if alertView?.tag == 101 {
            deleteProductReviewAPI(reviewId: dicReview.value(forKey: "id") as! Int)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.vwReviewBackground.isHidden = true
        self.vwReview.isHidden = true
    }
    
    //MARK: -
    //MARK: - API Calling
    
    func getProductReviewAPI() {
            THelper.ShowProgress(vc: self)
            
            let sessionManager = SessionManager.default
            sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
            
            sessionManager.request(TPreferences.getCommonURL("\(GET_PRODUCT_REVIEWS)/\(strProductID)/reviews")!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    THelper.hideProgress(vc: self)
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            print(data)
                            let arrtemp = NSMutableArray()
                            arrtemp.add(data)
                            self.arrReviews = arrtemp[0] as! NSArray
                            
                            let arrReviewers = NSMutableArray()
                            for i in 0..<self.arrReviews.count {
                                let dicReview:NSDictionary = self.arrReviews[i] as! NSDictionary
                                if !arrReviewers.contains(dicReview.value(forKey: "name") ?? "") {
                                    arrReviewers.add(dicReview.value(forKey: "name") ?? "")
                                    print(dicReview.value(forKey: "name") ?? "")
                                }
                            }
                            
                            self.lblReviews.text = "\(arrReviewers.count) Reviewers"
                            
                            self.SetUpValue()
                            self.tblReview.reloadData()
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
    
    func addProductReviewAPI(review: String, rating: Int) {
            THelper.ShowProgress(vc: self)
            let param = ["product_id":strProductID,
                         "review":review,
                         "reviewer":"\(TPreferences.readString(USER_FIRST_NAME) ?? "") \(TPreferences.readString(USER_LAST_NAME) ?? "")",
                         "reviewer_email":"\(TPreferences.readString(USER_EMAIL) ?? "")",
                         "rating":rating
                ] as [String : Any]
            print(param)
            
            let sessionManager = SessionManager.default
            sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
            
            sessionManager.request(TPreferences.getCommonURL(PRODUCT_REVIEWS)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    THelper.hideProgress(vc: self)
                    if let data = response.result.value{
                        print(response.response?.statusCode ?? "")
                        if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                            print(data)
                            self.isFirstTime = false
                            self.getProductReviewAPI()
                        }
                        else {
                            print(data)
                            let dicError:NSDictionary = data as! NSDictionary
                            let str:String = "\(dicError.value(forKey: "message") ?? "")"
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
        
        func editProductReviewAPI(reviewId: Int, review: String, rating: Int) {
            THelper.ShowProgress(vc: self)
            
            let param = ["product_id":strProductID,
                         "review":review,
                         "reviewer":"\(TPreferences.readString(USER_FIRST_NAME) ?? "") \(TPreferences.readString(USER_LAST_NAME) ?? "")",
                "reviewer_email":"\(TPreferences.readString(USER_EMAIL) ?? "")",
                "rating":rating
                ] as [String : Any]
            print(param)
            
            let sessionManager = SessionManager.default
            sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
            
            sessionManager.request(TPreferences.getCommonURL("\(PRODUCT_REVIEWS)/\(reviewId)")!,method: .put, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    THelper.hideProgress(vc: self)
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            print(data)
                            self.isFirstTime = false
                            self.getProductReviewAPI()
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
    
     func deleteProductReviewAPI(reviewId: Int) {
            THelper.ShowProgress(vc: self)
            let param = ["force":true
                ] as [String : Any]
            print(param)
            
            let sessionManager = SessionManager.default
            sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
            
            sessionManager.request(TPreferences.getCommonURL("\(PRODUCT_REVIEWS)/\(reviewId)")!, method: .delete, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success( _):
                    THelper.hideProgress(vc: self)
                    if let data = response.result.value{
                        if response.response?.statusCode == 200 {
                            print(data)
                            THelper.toast("Review deleted successfully", vc: self)
                            self.isFirstTime = false
                            self.getProductReviewAPI()
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
