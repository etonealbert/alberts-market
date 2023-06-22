//
//  SideMenuViewController.swift

import UIKit
import FCAlertView
import Alamofire
import MBProgressHUD

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FCAlertViewDelegate {

    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    
    @IBOutlet weak var vwBack: UIView!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var tblSideMenu: UITableView!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    let arrSideMenu1 = ["Women", "Men", "Kids", "Sports", "Camera"]
    let arrSideMenu2 = ["Account", "Settings"]
    let arrSideMenu3 = ["FAQ", "Help","Contact us"]
    
    let arrIcon = ["icoWomen","icoMen","icoKids","icoSport","icoCamera"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpObject()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        lblEmail.text = TPreferences.readString(EMAILID)
//        lblPhoneNo.text = TPreferences.readString(PHONE)
//        lblName.text = "\(TPreferences.readString(FIRSTNAME) ?? "") \(TPreferences.readString(LASTNAME) ?? "")"
//        THelper.setImage(img: self.imgUser, url: URL(string: "\(imgBaseURL)\("profile-image/")\(TPreferences.readString(PROFILEIMAGE) ?? "")")!, placeholderImage: "icoUser")
    }
    
    //MARK: -
    //MARK: -Set Up Method
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
            
        } else {
            constraintHeaderTop.constant = UIApplication.shared.statusBarFrame.size.height
        }
        
        if IPAD {
            imgUser.layer.cornerRadius = 100/2
            imgUser.layer.masksToBounds = true
        }
        else {
            imgUser.layer.cornerRadius = imgUser.frame.height/2
            imgUser.layer.masksToBounds = true
        }
        
        tblSideMenu.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tblSideMenu.tableFooterView = UIView(frame: .zero)
        tblSideMenu.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let profileImgRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.displayProfileImg(_:)))
        profileImgRecognizer.numberOfTapsRequired = 1
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(profileImgRecognizer)
    }
    
    // MARK: -
    // MARK: - Other Method
    
    @objc func displayProfileImg(_ gesture: UITapGestureRecognizer?) {
//        THelper.displayImage(self, imageView: imgUser)
    }
    
    //MARK: -
    //MARK: -UITableView DataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrSideMenu1.count
        }else if section == 1 {
            return arrSideMenu2.count
        }else if section == 2 {
            return arrSideMenu3.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD {
            return 80
        }
        else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.tblSideMenu.register(UINib(nibName: "HeaderViewCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        self.tblSideMenu.register(UINib(nibName: "HeaderViewCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderViewCell
            return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SideMenuTableViewCell
        
        if indexPath.section == 0 {
            cell.imgIcon.isHidden = false
            cell.imgIcon.image = UIImage(named: arrIcon[indexPath.row])
            cell.lblMenu.text = arrSideMenu1[indexPath.row]
            cell.btnRightArrow.isHidden = false
        }else if indexPath.section == 1 {
            //            cell.imgIcon.image = UIImage(named: arrIcon[indexPath.row])
            cell.lblMenu.text = arrSideMenu2[indexPath.row]
            cell.btnRightArrow.isHidden = true
            cell.imgIcon.isHidden = true
        }else {
            //            cell.imgIcon.image = UIImage(named: arrIcon[indexPath.row])
            cell.lblMenu.text = arrSideMenu3[indexPath.row]
            cell.btnRightArrow.isHidden = true
            cell.imgIcon.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            frostedViewController?.hideMenuViewController()
        }
    }
    
    //MARK: -
    //MARK: -fcAlertDoneButtonClicked
    
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView?) {
        if alertView?.tag == 1001 {
//            logoutAPI()
        }
    }
 
    //MARK: -
    //MARK: -UIButton Action Method
    
    @IBAction func btnHeader_Clicked(_ sender: Any) {
//        let vc = UserProfileViewController(nibName: "UserProfileViewController", bundle: nil)
//        AppDelegate.getDelegate()?.navigationController.pushViewController(vc, animated: true)
//        frostedViewController?.hideMenuViewController()
    }
    
    // MARK: -
    // MARK: - API Calling
    
   /* func logoutAPI() {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = MSG_REQUEST_PROGRESS
        
        let param = ["device_id":"\(TPreferences.readString(DEVICETOKEN_ID) ?? "")",
                     "api":"1"
        ] as [String : Any]
        print(param)
        
        let Auth_header = ["Authorization" : "Bearer \(TPreferences.readString(AUTHKEY)!)"]
        print(Auth_header)
        
        Alamofire.request(TPreferences.getCommonURL(Logout)!, method: .post, parameters: param, encoding: JSONEncoding.default, headers: Auth_header).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                hud.hide(animated: true)
                if let data = response.result.value{
                    print(data)
                    let dicTemp:NSDictionary = data as! NSDictionary
                    let status: Bool = dicTemp.value(forKey: "status") as! Bool
                    
                    if status {
                        print(status)
                        TPreferences .writeBoolean(USER_LOGIN, value: false)
                        let vc = ViewController(nibName: AppDelegate.loadXIBBased(onDevice: "ViewController"), bundle: nil)
                        AppDelegate.getDelegate()?.navigationController = TNavigationViewController(rootViewController: vc)
                        AppDelegate.getDelegate()?.navigationController.isNavigationBarHidden = true
                        if let aController = AppDelegate.getDelegate()?.navigationController {
                            self.frostedViewController.contentViewController = aController
                        }
                        self.frostedViewController.hideMenuViewController()
                    }
                    else {
                        print(status)
                        THelper.toast(dicTemp.value(forKey: "message") as? String)
                        print(dicTemp.value(forKey: "message") ?? "Default")
                    }
                }
                break
                
            case .failure(_):
                hud.hide(animated: true)
                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong")
                break
                
            }
            
        }
    }*/
}
