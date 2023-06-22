//
//  signInViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import FacebookLogin
import FBSDKLoginKit

class signInViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate, LoginButtonDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtChar1: UITextField!
    @IBOutlet weak var txtChar2: UITextField!
    @IBOutlet weak var txtChar3: UITextField!
    @IBOutlet weak var txtChar4: UITextField!
    @IBOutlet weak var txtPoupPassword: UITextField!
    @IBOutlet weak var txtPopupConfirmPassword: UITextField!
    @IBOutlet weak var txtPopUpEmail: UITextField!
    
    @IBOutlet weak var btnTxtChar1: UIButton!
    @IBOutlet weak var btnTxtChar2: UIButton!
    @IBOutlet weak var btnTxtChar3: UIButton!
    @IBOutlet weak var btnTxtChar4: UIButton!
    @IBOutlet weak var btnResendCode: UIButton!
    @IBOutlet weak var btnVerifyNow: UIButton!
    @IBOutlet weak var btnChangeNow: UIButton!
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var btnGoogleSignIn: UIButton!
    @IBOutlet weak var btnFbSignIn: UIButton!
    
    @IBOutlet weak var lblSignInWith: UILabel!
    @IBOutlet weak var lblWooBox: UILabel!
    @IBOutlet weak var lblCountDown: UILabel!
    @IBOutlet weak var lblVwPopUpChangePwd: UILabel!
    @IBOutlet weak var lblVwChangePwd: UILabel!
    @IBOutlet weak var lblSentMail: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMailId: UILabel!
    
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var vwPopUp: UIView!
    @IBOutlet weak var vwPopUpBackGround: UIView!
    @IBOutlet weak var vwChangePassword: UIView!
    @IBOutlet weak var vwPopUpEmail: UIView!
    @IBOutlet weak var vwGoogle: UIView!
    @IBOutlet weak var vwFacebook: UIView!
    
    @IBOutlet weak var constraintHeightSafeArea: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeightForBtnResend: NSLayoutConstraint!
    
    
    //MARK:-
    //MARK:- Variables
    
    var count: Int = 0
    var timer: Timer!
    var isBackspacePressed = Bool()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpObject()
    }
    
    //MARK:-
    //MARK:- SetUpObject Method

    func SetUpObject() {
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightSafeArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
//        vwFacebook.layer.cornerRadius = vwFacebook.frame.height / 2
//        vwGoogle.layer.cornerRadius = vwGoogle.frame.height / 2
        
        if IPAD {
            self.vwPopUp.layer.cornerRadius = 10.0
            self.vwChangePassword.layer.cornerRadius = 10.0
            self.vwPopUpEmail.layer.cornerRadius = 10.0
        }else {
            self.vwPopUp.layer.cornerRadius = 5.0
            self.vwChangePassword.layer.cornerRadius = 5.0
            self.vwPopUpEmail.layer.cornerRadius = 5.0
        }
        
        
        lblWooBox.text = LanguageLocal.myLocalizedString(key: "WooBox")
        lblSignInWith.text = LanguageLocal.myLocalizedString(key: "Sign_In_With")
        lblVwPopUpChangePwd.text = LanguageLocal.myLocalizedString(key: "Change_Password")
        lblVwChangePwd.text = LanguageLocal.myLocalizedString(key: "Change_Password")
        lblSentMail.text = LanguageLocal.myLocalizedString(key: "Mail_With_Verification_Code")
        lblMailId.text = LanguageLocal.myLocalizedString(key: "Enter_Email_Username")
        
        txtEmail.placeholder = LanguageLocal.myLocalizedString(key: "Enter_Email")
        txtPassword.placeholder = LanguageLocal.myLocalizedString(key: "Enter_Password")
        txtPopUpEmail.placeholder = LanguageLocal.myLocalizedString(key: "Enter_Email_Username")
        
        self.btnVerifyNow.setTitle(LanguageLocal.myLocalizedString(key: "Verify_Now"), for: .normal)
        self.btnChangeNow.setTitle(LanguageLocal.myLocalizedString(key: "Change_Now"), for: .normal)
        self.btnSignIn.setTitle(LanguageLocal.myLocalizedString(key: "Sign_In"), for: .normal)
        self.btnSignUp.setTitle(LanguageLocal.myLocalizedString(key: "Sign_Up"), for: .normal)
        self.btnForgot.setTitle(LanguageLocal.myLocalizedString(key: "Forgot"), for: .normal)
        self.btnResendCode.setTitle(LanguageLocal.myLocalizedString(key: "Resend_code"), for: .normal)
        self.btnContinue.setTitle(LanguageLocal.myLocalizedString(key: "Continue"), for: .normal)
        
        self.vwPopUpBackGround.isHidden = true
        self.vwPopUp.isHidden = true
        self.vwChangePassword.isHidden = true
        self.vwPopUpBackGround.alpha = 0.0
        self.vwPopUp.alpha = 0.0
        self.vwChangePassword.alpha = 0.0
        self.vwPopUpEmail.isHidden = true
        self.vwPopUpEmail.alpha = 0.0
        
        self.vwPopUp.layer.cornerRadius = 5.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwPopUpBackGround.addGestureRecognizer(tapGesture)
        
        self.vwEmail.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
        self.vwPassword.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (authResult, error) in
              if error != nil {
                  return
              }
            print(authResult?.user.displayName ?? "hii")
            print(authResult?.user.phoneNumber ?? "hii")
            print(authResult?.user.email ?? "hii")
            print(authResult?.user.isAnonymous ?? "hii")
            print(authResult?.user.isEmailVerified ?? "hii")
            print(authResult?.user.photoURL ?? "hii")
            print(authResult?.user.providerID ?? "hii")
            print(authResult?.user.refreshToken ?? "hii")
            print(authResult?.user.uid ?? "hii")
            print("\(authentication.accessToken ?? "")")
            
            let fullName: String = "\(authResult?.user.displayName ?? "")"
            let fullNameArr = fullName.components(separatedBy: " ")
            let url = authResult?.user.photoURL
            let photoURL: String = "\(url!)"
            print(photoURL)
            
            let param = ["accessToken" : "\(authentication.accessToken ?? "")",
                         "firstName": fullNameArr[0],
                         "lastName" : fullNameArr[1],
                         "loginType" : "google",
                         "photoURL" : "\(url!)",
                "email" : "\(authResult?.user.email ?? "")"
                ] as [String : Any]
            TPreferences.writeString(LOGIN_TYPE, value: "google")
            self.SocialLoginAPI(param: param)
        })
    }
    
    func showEmailAddress(){
        let accesstoken = AccessToken.current;
        guard (accesstoken?.tokenString) != nil else {return}
        GraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, first_name, last_name, email, birthday,picture"]).start { (connection, result, err) in
            if(err != nil){
                print("Failed to start GraphRequest", err ?? "")
                return
            }
            print(result ?? "")
            let dicFb : NSDictionary = result as! NSDictionary
            let dicPicture : NSDictionary = dicFb.value(forKey: "picture") as! NSDictionary
            let dicData : NSDictionary = dicPicture.value(forKey: "data") as! NSDictionary
            
            let param = ["accessToken" : "\(accesstoken?.tokenString ?? "")",
                "firstName": "\(dicFb.value(forKey: "first_name") ?? "")",
                "lastName" : "\(dicFb.value(forKey: "last_name") ?? "")",
                         "loginType" : "facebook",
                         "photoURL" : "\(dicData.value(forKey: "url") ?? "")",
                "email" : "\(dicFb.value(forKey: "email") ?? "")"
                ] as [String : Any]
            TPreferences.writeString(LOGIN_TYPE, value: "facebook")
            self.SocialLoginAPI(param: param)
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let err = error {
            print(err)
        }
        print("Successfully Logged in using facebook")
        showEmailAddress()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
         print("Logged out of Facebook")
        let loginView : LoginManager = LoginManager()
        loginView.loginBehavior = LoginBehavior.browser
        THelper.toast("Successfully Logged out", vc: self)
    }
    
    //    MARK:-
    //    MARK:- TextField Delegate.
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.isEqual(self.txtEmail) || textField.isEqual(self.txtPassword){
            
        }else {
            if (string != "")  {
                textField.text = string
                if(textField.isEqual(self.txtChar1)) {
                    self.txtChar2.becomeFirstResponder()
                }else if(textField.isEqual(self.txtChar2)) {
                    self.txtChar3.becomeFirstResponder()
                }else if(textField.isEqual(self.txtChar3)) {
                    self.txtChar4.becomeFirstResponder()
                }else if(textField.isEqual(self.txtChar4)) {
                    textField.becomeFirstResponder()
                }else {
                }
                return false
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtChar1.text?.count == 0 {
            self.btnTxtChar1.isHidden = true
        }else if txtChar2.text?.count == 0 {
            self.btnTxtChar2.isHidden = true
        }else if txtChar3.text?.count == 0 {
            self.btnTxtChar3.isHidden = true
        }else if txtChar4.text?.count == 0 {
            self.btnTxtChar4.isHidden = true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing...")
        if txtEmail.isEditing {
            self.vwPassword.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwEmail.backgroundColor = UIColor(hexString: PRIMARY_COLOR, alpha: 0.3)
            self.txtEmail.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            self.txtPassword.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
        }else if txtPassword.isEditing {
            self.txtEmail.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
            self.vwEmail.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
            self.vwPassword.backgroundColor = UIColor(hexString: PRIMARY_COLOR, alpha: 0.3)
            self.txtPassword.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
        }else {
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isBackspacePressed == true {
            textField.text = ""
            isBackspacePressed = false
        }
    }
    
    //MARK:-
    //MARK:- Other Method
    
    func TimeCountDown() {
        count = 40
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateView), userInfo: nil, repeats: true)
    }
    
    @objc func updateView() {
        if count > 0 {
            count = count - 1
            self.lblCountDown.text = "\(count)"
        }else {
            timer.invalidate()
            self.lblCountDown.text = "00"
            self.btnResendCode.isHidden = false
            if IPAD {
                self.constraintHeightForBtnResend.constant = 50
            }else {
                self.constraintHeightForBtnResend.constant = 40
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.vwPopUpBackGround.isHidden = true
        self.vwPopUp.isHidden = true
        self.vwPopUpBackGround.alpha = 0
        self.vwPopUp.alpha = 0
        self.vwChangePassword.isHidden = true
        self.vwChangePassword.alpha = 0.0
        self.vwPopUpEmail.isHidden = true
        self.vwPopUpEmail.alpha = 0.0
    }

    //    MARK:-
    //    MARK:- UIbutton Clicked Events:-
    
    @IBAction func btnSignIn_Clicked(_ sender: Any) {
        if txtEmail.text!.count > 0 {
//            if TValidation.isValidEmail(self.txtEmail.text) {
                if txtPassword.text!.count > 0 {
                    LoginAPI()
                }else {
                    THelper.toast("Please Enter password", vc: self)
                }
//            }else {
//                THelper.toast("Enter Valid Email")
//            }
        }
        else {
            THelper.toast("Please Enter Email", vc: self)
        }
    }
    
    @IBAction func btnSignUp_Clicked(_ sender: Any) {
        let vc = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    @IBAction func btnForgotPassword_Clicked(_ sender: Any) {
        self.vwPopUpBackGround.isHidden = false
        self.vwPopUpBackGround.alpha = 0.4
//        self.vwPopUp.isHidden = false
//        self.TimeCountDown()
//        self.vwPopUp.alpha = 1.0
        self.vwPopUpEmail.isHidden = false
        self.vwPopUpEmail.alpha = 1.0
    }
    
    
    @IBAction func btnVerifyNow_Clicked(_ sender: Any) {
        if txtChar1.text != "" && txtChar2.text != "" && txtChar3.text != "" && txtChar4.text != ""{
            self.vwPopUp.isHidden = true
            self.vwPopUp.alpha = 0.0
            self.vwChangePassword.isHidden = false
            self.vwChangePassword.alpha = 1.0
        }else {
            THelper.toast("please Enter your Otp..", vc: self)
        }
    }
    
    @IBAction func btnChangeNow_Clicked(_ sender: Any) {
        if TValidation.isAlphaNumeric(self.txtPoupPassword.text) {
            if self.txtPoupPassword.text == self.txtPopupConfirmPassword.text {
                self.vwPopUpBackGround.isHidden = true
                self.vwPopUpBackGround.alpha = 0.0
                self.vwChangePassword.isHidden = true
                self.vwChangePassword.alpha = 0.0
                THelper.toast("Successfully Changed your Password", vc: self)
            }else{
                print("Enter Valid Re-password")
            }
        }else {
            print("Enter Valid password")
        }
    }
    
    @IBAction func btnContinue_Clicked(_ sender: Any) {
        if self.txtPopUpEmail.text != "" {
            self.vwPopUpEmail.isHidden = true
            self.vwPopUpEmail.alpha = 0.0
            self.vwPopUpBackGround.isHidden = true
            self.vwPopUpBackGround.alpha = 0.0
            self.ChangePasswordAPI(EmailText: self.txtPopUpEmail.text ?? "")
        }else {
            THelper.toast("Field must be required..", vc: self)
        }
    }
    
    
    @IBAction func btnResendCode_Clicked(_ sender: Any) {
        self.TimeCountDown()
        self.constraintHeightForBtnResend.constant = 0
        self.btnResendCode.isHidden = true
    }
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
         AppDelegate.getDelegate()?.navigationController.popViewController(animated: true)
    }
    
    @IBAction func btnGoogleSignIn_Clicked(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func btnFbSignIn_Clicked(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile], viewController: self) { (result) in
            switch result{
            case .cancelled:
                print("Cancel button click")
            case .success:
                self.showEmailAddress()
            default:
                print("??")
            }
        }
    }
    
    //    MARK:-
    //    MARK:- API Calling
    
    func LoginAPI() {
        THelper.ShowProgress(vc: self)
        let param = ["username":txtEmail.text ?? "",
                     "password":txtPassword.text ?? ""
            ] as [String : Any]
        print(param)

        let Auth_header = ["Authorization" : AUTH_KEY]
        print(Auth_header)

        Alamofire.request(TPreferences.getCommonURL(LOGIN)!, method: .post, parameters: param, encoding: JSONEncoding.default, headers: Auth_header).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let dicData:NSDictionary = data as! NSDictionary
                        
                        TPreferences.writeString(USER_ID, value: "\(dicData.value(forKey: USER_ID) ?? "")")
                        TPreferences.writeString(TOKEN, value: dicData.value(forKey: TOKEN) as? String)
                        TPreferences.writeString(USER_EMAIL, value: dicData.value(forKey: USER_EMAIL) as? String)
                        TPreferences.writeString(USER_DISPLAY_NAME, value: dicData.value(forKey: USER_DISPLAY_NAME) as? String)
                        TPreferences.writeString(USER_NICENAME, value: dicData.value(forKey: USER_NICENAME) as? String)
                        TPreferences.writeString(PASSWORD, value: self.txtPassword.text)
                        
                        self.getCustomerAPI()
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
    
    func SocialLoginAPI(param: [String : Any]) {
        THelper.ShowProgress(vc: self)
        
        print(param)

        let Auth_header = ["Authorization" : AUTH_KEY]
        print(Auth_header)

        Alamofire.request(TPreferences.getCommonURL(NEW_SOCIAL_LOGIN)!, method: .post, parameters: param, encoding: JSONEncoding.default, headers: Auth_header).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let dicData:NSDictionary = data as! NSDictionary
                        
                        TPreferences.writeString(USER_ID, value: "\(dicData.value(forKey: USER_ID) ?? "")")
                        TPreferences.writeString(TOKEN, value: dicData.value(forKey: TOKEN) as? String)
                        TPreferences.writeString(USER_EMAIL, value: dicData.value(forKey: USER_EMAIL) as? String)
                        TPreferences.writeString(USER_DISPLAY_NAME, value: dicData.value(forKey: USER_DISPLAY_NAME) as? String)
                        TPreferences.writeString(USER_NICENAME, value: dicData.value(forKey: USER_NICENAME) as? String)
                        TPreferences.writeString(PASSWORD, value: self.txtPassword.text)
                        
                        self.getCustomerAPI()
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
    
    func getCustomerAPI() {
        THelper.ShowProgress(vc: self)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL("\(CUSTOMER)\(TPreferences.readString(USER_ID) ?? "")")!,method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
                case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let dicData:NSDictionary = data as! NSDictionary
                        
                        TPreferences.writeString(USER_FIRST_NAME, value: dicData.value(forKey: USER_FIRST_NAME) as? String)
                        TPreferences.writeString(USER_LAST_NAME, value: dicData.value(forKey: USER_LAST_NAME) as? String)
                        TPreferences.writeString(USERNAME, value: dicData.value(forKey: USERNAME) as? String)
                        TPreferences.writeBoolean(IS_LOGGED_IN, value: true)
                        
                        THelper.toast("Login Succefull", vc: self)
                        
                        let vc = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
//                        print(data)
//                        let dicData:NSDictionary = data as! NSDictionary
//
//                        let arrMetaData: NSArray = dicData.value(forKey: "meta_data") as! NSArray
//                        var dicMetaData =  NSDictionary()
//                        if (arrMetaData.count > 1) {
//                           dicMetaData = arrMetaData[1] as! NSDictionary
//                        }else {
//                            dicMetaData = arrMetaData[0] as! NSDictionary
//                        }
//
//
//                        TPreferences.writeString(USER_PROFILE_IMAGE, value: dicMetaData.value(forKey: "value") as? String)
//                        TPreferences.writeString(USER_FIRST_NAME, value: dicData.value(forKey: USER_FIRST_NAME) as? String)
//                        TPreferences.writeString(USER_LAST_NAME, value: dicData.value(forKey: USER_LAST_NAME) as? String)
//                        TPreferences.writeString(USERNAME, value: dicData.value(forKey: USERNAME) as? String)
//                        TPreferences.writeBoolean(IS_LOGGED_IN, value: true)
//
//                        THelper.toast("Login Succefull", vc: self)
//
//                        let vc = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
//                        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func ChangePasswordAPI(EmailText: String) {
        
        THelper.ShowProgress(vc: self)
        let param = ["user_login": EmailText
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL("\(LOSTPASSWORD)")!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    print(data)
                    let dicData:NSDictionary = data as! NSDictionary
                    THelper.toast("\(dicData.value(forKey: "message") ?? "")", vc: self)
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
