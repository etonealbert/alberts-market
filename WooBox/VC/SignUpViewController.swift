//
//  SignUpViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var vwRePassword: UIView!
    @IBOutlet weak var vwFirstName: UIView!
    @IBOutlet weak var vwLastName: UIView!
    
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var lblWooBox: UILabel!
    @IBOutlet weak var lblSignInWith: UILabel!
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    
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
        lblWooBox.text = LanguageLocal.myLocalizedString(key: "WooBox")
        lblSignInWith.text = LanguageLocal.myLocalizedString(key: "Sign_In_With")
        self.btnSignIn.setTitle(LanguageLocal.myLocalizedString(key: "Sign_In"), for: .normal)
        self.btnSignUp.setTitle(LanguageLocal.myLocalizedString(key: "Sign_Up"), for: .normal)
        txtEmail.placeholder = LanguageLocal.myLocalizedString(key: "Enter_Email")
        txtPassword.placeholder = LanguageLocal.myLocalizedString(key: "Enter_Password")
        txtFirstName.placeholder = LanguageLocal.myLocalizedString(key: "Enter_First_Name")
        txtLastName.placeholder = LanguageLocal.myLocalizedString(key: "Enter_Last_Name")
        txtRePassword.placeholder = LanguageLocal.myLocalizedString(key: "Enter_Re_Password")
        
        self.vwRePassword.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
        self.vwEmail.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
        self.vwPassword.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
        self.vwFirstName.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
        self.vwLastName.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
    }
    
    //MARK:-
    //MARK:- TextField Delegate.
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing...")
        if txtFirstName.isEditing {
            self.vwFirstName.backgroundColor = UIColor(hexString: PRIMARY_COLOR, alpha: 0.3)
            self.vwLastName.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwEmail.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwPassword.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwRePassword.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            
            self.txtFirstName.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            self.txtLastName.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtEmail.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtPassword.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtRePassword.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
        }else if txtLastName.isEditing {
            self.vwLastName.backgroundColor = UIColor(hexString: PRIMARY_COLOR, alpha: 0.3)
            self.vwPassword.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwRePassword.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwEmail.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwFirstName.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            
            self.txtLastName.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            self.txtEmail.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtFirstName.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtPassword.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtRePassword.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            
        }else if txtEmail.isEditing {
            
            self.vwEmail.backgroundColor = UIColor(hexString: PRIMARY_COLOR, alpha: 0.3)
            self.vwFirstName.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwLastName.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwPassword.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwRePassword.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            
            self.txtEmail.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            self.txtPassword.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtRePassword.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtFirstName.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtLastName.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            
        }else if txtPassword.isEditing {
            self.vwPassword.backgroundColor = UIColor(hexString: PRIMARY_COLOR, alpha: 0.3)
            self.vwEmail.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwRePassword.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwFirstName.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwLastName.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            
            self.txtPassword.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            self.txtEmail.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtRePassword.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtFirstName.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtLastName.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            
        }else if txtRePassword.isEditing {
            self.vwRePassword.backgroundColor = UIColor(hexString: PRIMARY_COLOR, alpha: 0.3)
            self.vwEmail.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwPassword.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwFirstName.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwLastName.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            
            self.txtRePassword.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            self.txtEmail.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtPassword.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtFirstName.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.txtLastName.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
        }else {
            
        }
    }
    
    //MARK:-
    //MARK:- UIbutton Clicked Events:-
    
    @IBAction func btnSignUp_Clicked(_ sender: Any) {
        if txtFirstName.text!.count > 0 {
            if txtLastName.text!.count > 0 {
                if self.txtEmail.text?.count != 0 {
                    if TValidation.isValidEmail(self.txtEmail.text) {
                        if TValidation.isAlphaNumeric(self.txtPassword.text) {
                            if self.txtPassword.text == self.txtRePassword.text {
                                self.signUpAPI()
                            }else{
                                THelper.toast("Enter Valid  Re - password", vc: self)
                            }
                        }else {
                            THelper.toast("Enter Valid password", vc: self)
                        }
                    }else {
                        THelper.toast("Enter Valid email", vc: self)
                    }
                }else {
                    THelper.toast("Enter email", vc: self)
                }
            }
            else {
                THelper.toast("Enter lastname", vc: self)
            }
        }
        else {
            THelper.toast("Enter firstname", vc: self)
        }
    }
    
    @IBAction func btnSignIn_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnFaceBook_Clicked(_ sender: Any) {
        let vc = NewestProductListViewController(nibName: "NewestProductListViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnGoogle_Clicked(_ sender: Any) {
    }
    
    @IBAction func btnTwitter_Clicked(_ sender: Any) {
    }
    
    
    //    MARK:-
    //    MARK:- API Calling
    
    func signUpAPI() {
        
        THelper.ShowProgress(vc: self)
        let param = ["first_name":txtFirstName.text ?? "",
                     "last_name":txtLastName.text ?? "",
                     "email":txtEmail.text ?? "",
                     "password": txtPassword.text ?? ""
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL("\(CUSTOMER)\(TPreferences.readString(USER_ID) ?? "")")!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                print(response.response?.statusCode ?? "")
                if let data = response.result.value{
                    if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                        print(data)
                        
                        THelper.toast("Registration Succefull", vc: self)
                        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
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
    
    @objc func update() {
       self.navigationController?.popViewController(animated: true)
    }
}
