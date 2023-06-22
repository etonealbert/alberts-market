//
//  EditProfileViewController.swift

import UIKit
import FCAlertView
import Alamofire
import OAuthSwiftAlamofire

class EditProfileViewController: UIViewController,FCAlertViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    @IBOutlet weak var ConstraintVwHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightForBtnResend: NSLayoutConstraint!
    
    @IBOutlet weak var vwPopUpBackGround: UIView!
    @IBOutlet weak var vwPopup: UIView!
    @IBOutlet weak var vwChangePassword: UIView!
    @IBOutlet weak var vwPopUpEmail: UIView!
    @IBOutlet weak var VwFirstName: UIView!
    @IBOutlet weak var vwLastName: UIView!
    @IBOutlet weak var vwGender: UIView!
    @IBOutlet weak var vwPhoneno: UIView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwPicker: UIView!
    
    @IBOutlet weak var txtChar1: UITextField!
    @IBOutlet weak var txtChar2: UITextField!
    @IBOutlet weak var txtChar3: UITextField!
    @IBOutlet weak var txtChar4: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtPopUpEmail: UITextField!
    @IBOutlet weak var txtOldPassword: UITextField!
    
    @IBOutlet weak var lblCountDown: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblVwPopUpChangePwd: UILabel!
    @IBOutlet weak var lblVwChangePwd: UILabel!
    @IBOutlet weak var lblSentMail: UILabel!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnTxtChar1: UIButton!
    @IBOutlet weak var btnTxtChar2: UIButton!
    @IBOutlet weak var btnTxtChar3: UIButton!
    @IBOutlet weak var btnTxtChar4: UIButton!
    @IBOutlet weak var btnResendCode: UIButton!
    @IBOutlet weak var btnChangeNow: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnVerifyNow: UIButton!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var btnSaveProfile: UIButton!
    @IBOutlet weak var BtnChangePassword: UIButton!
    @IBOutlet weak var btnAccountDeactive: UIButton!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var genderPickerView: UIPickerView!
    
    var isSideMenu = Bool()
    
    //MARK:-
    //MARK:- Variables
    
    var count: Int = 0
    var timer: Timer!
    var isBackspacePressed = Bool()
    
    var arrGender = ["Male","Female","Other"]

    //MARK: -
    //MARK: - UIView life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setTextField(primaryView: VwFirstName, secondaryView1: vwLastName, secondaryView2: vwGender, secondaryView3: vwPhoneno, secondaryView4: vwEmail, primaryTxtField: txtFirstName, secondaryTxtField1: txtLastName, secondaryTxtField2: txtGender, secondaryTxtField3: txtPhoneNo, secondaryTxtField4: txtEmail)
    }
    
    //MARK: -
    //MARK: - SetUpObject
    
    func SetUpObject() {
        lblSentMail.text = LanguageLocal.myLocalizedString(key: "Mail_With_Verification_Code")
        lblHeaderTitle.text = LanguageLocal.myLocalizedString(key: "Edit_Profile")
        lblVwPopUpChangePwd.text = LanguageLocal.myLocalizedString(key: "Change_Password")
        lblVwChangePwd.text = LanguageLocal.myLocalizedString(key: "Change_Password")
        
        
        self.btnVerifyNow.setTitle(LanguageLocal.myLocalizedString(key: "Verify_Now"), for: .normal)
        self.btnChangeNow.setTitle(LanguageLocal.myLocalizedString(key: "Change_Now"), for: .normal)
        self.btnDone.setTitle(LanguageLocal.myLocalizedString(key: "Done"), for: .normal)
        
        self.btnSaveProfile.setTitle(LanguageLocal.myLocalizedString(key: "Save_Profile"), for: .normal)
        self.BtnChangePassword.setTitle(LanguageLocal.myLocalizedString(key: "Change_Password"), for: .normal)
//        self.btnAccountDeactive.setTitle(LanguageLocal.myLocalizedString(key: "Account_Deactive"), for: .normal)
        
        if #available(iOS 11.0, *) {} else {
            self.constraintHeaderTop.constant = UIApplication.shared.statusBarFrame.size.height
        }
        
        if isSideMenu == true {
            self.vwHeader.isHidden = false
            if IPAD {
                self.ConstraintVwHeaderHeight.constant = 66
            }else{
                self.ConstraintVwHeaderHeight.constant = 56
            }
        }else{
            self.vwHeader.isHidden = true
            self.ConstraintVwHeaderHeight.constant = 0
            self.constraintHeaderTop.constant = 0
        }
        
        
        if IPAD {
            self.imgProfile.layer.cornerRadius =  150 / 2
            self.btnEditProfile.layer.cornerRadius = 40 / 2
            self.vwPopup.layer.cornerRadius = 10.0
            self.vwChangePassword.layer.cornerRadius = 10.0
            self.vwPopUpEmail.layer.cornerRadius = 10.0

        }else {
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height / 2
            self.btnEditProfile.layer.cornerRadius = self.btnEditProfile.frame.height / 2
            self.vwPopup.layer.cornerRadius = 5.0
            self.vwChangePassword.layer.cornerRadius = 5.0
            self.vwPopUpEmail.layer.cornerRadius = 10.0
        }
     
        self.btnEditProfile.layer.borderColor = ThemeManager.shared()?.color(forKey: "header_color")?.cgColor
        self.btnEditProfile.layer.borderWidth = 1.0
        self.btnEditProfile = THelper.setButtonTintColor(self.btnEditProfile, imageName: "icoCamera", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "header_color"))
        
        self.vwPopUpBackGround.isHidden = true
        self.vwPopup.isHidden = true
//        self.vwChangePassword.isHidden = true
//        self.vwPopUpBackGround.alpha = 0.0
//        self.vwPopup.alpha = 0.0
//        self.vwChangePassword.alpha = 0.0
        
        if "\(TPreferences.readString(USER_PROFILE_IMAGE) ?? "")" == "" {
            imgProfile.image = UIImage(named: "icoProfile1")
        }
        else {
            THelper.setImage(img: imgProfile, url: URL(string: "\(TPreferences.readString(USER_PROFILE_IMAGE) ?? "")")!, placeholderImage: "icoProfile1")
        }
        
        self.txtEmail.text = "\(TPreferences.readString(USER_EMAIL) ?? "")"
        self.txtFirstName.text = "\(TPreferences.readString(USER_FIRST_NAME) ?? "")"
        self.txtLastName.text = "\(TPreferences.readString(USER_LAST_NAME) ?? "")"
        self.txtPopUpEmail.text = "\(TPreferences.readString(USER_EMAIL) ?? "")"


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwPopUpBackGround.addGestureRecognizer(tapGesture)
    }
    
    //MARK: -
    //MARK: - Picker View Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrGender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return LanguageLocal.myLocalizedString(key: "\(arrGender[row])")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.txtGender.text = LanguageLocal.myLocalizedString(key: "\(arrGender[row])")
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: "\(arrGender[row])", attributes: [NSAttributedString.Key.foregroundColor : ThemeManager.shared()?.color(forKey: "Secondary_Color1") as Any])
        return attributedString
    }
    
    //MARK:-
    //MARK:- UITextFieldDelegate Method.
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.isEqual(self.txtFirstName) || textField.isEqual(self.txtLastName) || textField.isEqual(self.txtGender) || textField.isEqual(self.txtEmail)  || textField.isEqual(self.txtPhoneNo) {
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
        if txtFirstName.isEditing {
            self.setTextField(primaryView: VwFirstName, secondaryView1: vwLastName, secondaryView2: vwGender, secondaryView3: vwPhoneno, secondaryView4: vwEmail, primaryTxtField: txtFirstName, secondaryTxtField1: txtLastName, secondaryTxtField2: txtGender, secondaryTxtField3: txtPhoneNo, secondaryTxtField4: txtEmail)
        }else if txtLastName.isEditing {
            self.setTextField(primaryView: vwLastName, secondaryView1: VwFirstName, secondaryView2: vwGender, secondaryView3: vwPhoneno, secondaryView4: vwEmail, primaryTxtField: txtLastName, secondaryTxtField1: txtFirstName, secondaryTxtField2: txtGender, secondaryTxtField3: txtPhoneNo, secondaryTxtField4: txtEmail)
        }else if txtGender.isEditing {
            self.setTextField(primaryView: vwGender, secondaryView1: VwFirstName, secondaryView2: vwLastName, secondaryView3: vwPhoneno, secondaryView4: vwEmail, primaryTxtField: txtGender, secondaryTxtField1: txtFirstName, secondaryTxtField2: txtLastName, secondaryTxtField3: txtPhoneNo, secondaryTxtField4: txtEmail)
        }else if txtPhoneNo.isEditing {
            self.setTextField(primaryView: vwPhoneno, secondaryView1: VwFirstName, secondaryView2: vwLastName, secondaryView3: vwGender, secondaryView4: vwEmail, primaryTxtField: txtPhoneNo, secondaryTxtField1: txtFirstName, secondaryTxtField2: txtGender, secondaryTxtField3: txtLastName, secondaryTxtField4: txtEmail)
        }else if txtEmail.isEditing {
            self.setTextField(primaryView: vwEmail, secondaryView1: VwFirstName, secondaryView2: vwLastName, secondaryView3: vwGender, secondaryView4: vwPhoneno, primaryTxtField: txtEmail, secondaryTxtField1: txtFirstName, secondaryTxtField2: txtGender, secondaryTxtField3: txtLastName, secondaryTxtField4: txtPhoneNo)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isBackspacePressed == true {
            textField.text = ""
            isBackspacePressed = false
        }
    }
    
    //MARK:-
    //MARK:- UIImagePickerView Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.originalImage] as? UIImage
        self.imgProfile.image = img
        
        let defaultImg: UIImage = UIImage(named: "icoProfile1")!
        SaveProfileImageAPI(img: img ?? defaultImg)
        picker.dismiss(animated: true, completion: nil)
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
//        self.vwPopup.isHidden = true
//        self.vwPopup.alpha = 0.0
        self.vwChangePassword.isHidden = true
        self.vwPopUpEmail.isHidden = true
        self.vwPopUpEmail.alpha = 0.0
    }
    
    func checkPermissionForCamera() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
            if granted {
                print("user has granted access to camera, do nothing...")
            } else {
                self.showAlertNoPermission(true)
            }
        })
    }
    
    func showAlertNoPermission(_ forCamera: Bool) {
        let noPermissionAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        var customFontAttrib: NSMutableAttributedString
        
        if forCamera {
            customFontAttrib = NSMutableAttributedString(string: "We need your permission\n This app needs to access your camera.\nGo to Settings > THE_NAME_OF_YOURAPP > Camera > Switch ON.")
        } else {
            customFontAttrib = NSMutableAttributedString(string: "We need your permission\n This app needs to access your photo library.\nGo to Settings > THE_NAME_OF_YOURAPP > Photos > Switch ON.")
        }
        
        customFontAttrib.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0), range: NSRange(location: 22, length: customFontAttrib.length - 22))
        customFontAttrib.addAttribute(.font, value: UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight(rawValue: 10.0)), range: NSRange(location: 0, length: 23))
        customFontAttrib.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: customFontAttrib.length))
        
        noPermissionAlert.setValue(customFontAttrib, forKey: "attributedTitle")
        
        let ok = UIAlertAction(title: "Ok, I got it!", style: .default, handler: { action in
            //Do some thing here
            noPermissionAlert.dismiss(animated: true)
        })
        
        noPermissionAlert.addAction(ok)
        
        // UIAlertController BG
        let firstView = noPermissionAlert.view.subviews.first
        let nextView = firstView?.subviews.first
        nextView?.backgroundColor = UIColor.red
        
        noPermissionAlert.view.tintColor = UIColor.white
        
        present(noPermissionAlert, animated: true)
    }
    
    func setTextField(primaryView:UIView, secondaryView1:UIView, secondaryView2:UIView, secondaryView3:UIView, secondaryView4:UIView, primaryTxtField:UITextField, secondaryTxtField1:UITextField, secondaryTxtField2:UITextField, secondaryTxtField3:UITextField, secondaryTxtField4:UITextField) {
        primaryView.backgroundColor = UIColor(hexString: PRIMARY_COLOR, alpha: 0.3)
        primaryTxtField.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
        secondaryView1.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
        secondaryView2.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
        secondaryView3.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
        secondaryView4.backgroundColor = ThemeManager.shared()?.color(forKey: "vw_secoundry_background")
        secondaryTxtField1.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
        secondaryTxtField2.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
        secondaryTxtField3.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
        secondaryTxtField4.textColor = ThemeManager.shared()?.color(forKey: "Secondary_Color1")
    }
    
    
    //MARK: -
    //MARK: - fcAlertDoneButtonClicked
    
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView?) {
        if alertView?.tag == 101 {
            THelper.toast("Account has DeActived..", vc: self)
        }
    }
    
    //MARK: -
    //MARK:- UIButton Action Method
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnresendCode_Clicked(_ sender: Any) {
        self.TimeCountDown()
        self.constraintHeightForBtnResend.constant = 0
        self.btnResendCode.isHidden = true
    }
    
    
    @IBAction func btnSaveProfile_Clicked(_ sender: Any) {
        self.EditProfileAPI()
    }
    
    @IBAction func btnGender_Clicked(_ sender: Any) {
        self.genderPickerView.reloadAllComponents()
        self.vwPicker.isHidden = false
        self.setTextField(primaryView: vwGender, secondaryView1: VwFirstName, secondaryView2: vwLastName, secondaryView3: vwPhoneno, secondaryView4: vwEmail, primaryTxtField: txtGender, secondaryTxtField1: txtFirstName, secondaryTxtField2: txtLastName, secondaryTxtField3: txtPhoneNo, secondaryTxtField4: txtEmail)
    }
    
    
    @IBAction func btnDone_Clicked(_ sender: Any) {
        vwPicker.isHidden = true
    }
    
    @IBAction func btnEditProfile_Clicked(_ sender: Any) {
            let alert = UIAlertController(title: "Choose Options", message: "", preferredStyle: .actionSheet)
            let GalleryAction = UIAlertAction(title: "Gallery", style: .default, handler: { action in
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                self.present(imagePicker, animated: true)
            })
            
            let CameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let picker = UIImagePickerController()
                    //                self.checkPermissionForCamera()
                    picker.delegate = self
                    picker.allowsEditing = true
                    picker.sourceType = .camera
                    self.present(picker, animated: true)
                } else {
                    print("Camera  not available")
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(GalleryAction)
            alert.addAction(CameraAction)
            alert.addAction(cancelAction)
            
            alert.popoverPresentationController?.sourceView = view
            alert.popoverPresentationController?.sourceRect = CGRect(x: (SCREEN_SIZE.width / 2) - 150, y: SCREEN_SIZE.height, width: 300, height: 300)
            alert.popoverPresentationController?.permittedArrowDirections = .down
            present(alert, animated: true)
    }
    
    @IBAction func btnChangePassword_Clicked(_ sender: Any) {
        self.vwPopUpBackGround.isHidden = false
        self.vwChangePassword.isHidden = false
//        TimeCountDown()
    }
    
    
    @IBAction func btnAccountDeactive_Clicked(_ sender: Any) {
        THelper.displayAlert(self, title: "", message: "Are you sure you want to Account Deactive", tag: 101, firstButton: "Cancel", doneButton: "OK")
    }
    
    
    @IBAction func btnVerifyNow_Clicked(_ sender: Any) {
        if txtChar1.text != "" && txtChar2.text != "" && txtChar3.text != "" && txtChar4.text != ""{
            self.vwPopup.isHidden = true
            self.vwPopup.alpha = 0.0
            self.vwChangePassword.isHidden = false
            self.vwChangePassword.alpha = 1.0
        }else {
            THelper.toast("please Enter your Otp..", vc: self)
        }
    }
    
    
    @IBAction func btnChangeNow_Clicked(_ sender: Any) {
        if txtOldPassword.text == "\(TPreferences.readString(PASSWORD) ?? "")" {
            if self.txtNewPassword.text!.count >= 6 {
                if txtNewPassword.text != "\(TPreferences.readString(PASSWORD) ?? "")" {
                    if self.txtNewPassword.text == self.txtConfirmPassword.text {
                        self.vwPopUpBackGround.isHidden = true
                        self.vwChangePassword.isHidden = true
                        ChangePasswordAPI()
                    }else{
                        THelper.toast("Password does not match.", vc: self)
                    }
                }
                else {
                    THelper.toast("New password should not be equal to old password.", vc: self)
                }
            }else {
                THelper.toast("Password should contain atleast 6 characters.", vc: self)
            }
        }
        else {
            THelper.toast("Existing password does not match.", vc: self)
        }
    }
    
    
    @IBAction func btnContinue_Clicked(_ sender: Any) {
        if self.txtPopUpEmail.text != "" {
            self.vwPopUpBackGround.isHidden = true
            self.vwPopUpBackGround.alpha = 0.0
            self.vwPopUpEmail.isHidden = true
            self.vwPopUpEmail.alpha = 0.0
            self.ChangePasswordAPI()
        }
    }
    
    
    //    MARK:-
    //    MARK:- API Calling
    
    func EditProfileAPI() {
        
        THelper.ShowProgress(vc: self)
        let param = ["first_name":txtFirstName.text ?? "",
                     "last_name":txtLastName.text ?? "",
                     "email":txtEmail.text ?? ""
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL("\(CUSTOMER)\(TPreferences.readString(USER_ID) ?? "")")!,method: .put, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
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
                        
                        let vc = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
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
        
    func ChangePasswordAPI() {
        THelper.ShowProgress(vc: self)
        
        let param = ["password":txtNewPassword.text ?? ""
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL("\(CHANGE_PASSWORD)/\(TPreferences.readString(USER_ID) ?? "")")!, method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    print(data)
                    THelper.toast("Password changed successfully...", vc: self)
                }
                break
                
            case .failure(_):
                THelper.hideProgress(vc: self)
                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                    THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                break
            }
        }
    }
    
    func SaveProfileImageAPI(img: UIImage) {
        THelper.ShowProgress(vc: self)
        
        let param = ["base64_img": THelper.compressImageFromSize(image: img)?.base64EncodedString() ?? ""
        ] as [String : Any]
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_SAVE_PROFILE_IMAGE)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: THelper.setHeader()).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    print(response.response?.statusCode ?? "")
                    if response.response?.statusCode == 200 {
                        print(data)
                        let dicData:NSDictionary = data as! NSDictionary
                        let str:String = "\(dicData.value(forKey: "message") ?? "")"
                        THelper.toast(str.html2String, vc: self)
                        
                        TPreferences.writeString(USER_PROFILE_IMAGE, value: "\(dicData.value(forKey: "profile_image") ?? "")")
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
}
