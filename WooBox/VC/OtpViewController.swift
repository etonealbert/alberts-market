//
//  OtpViewController.swift

import UIKit

class OtpViewController: UIViewController,UITextFieldDelegate {
    
    //MARK:-
    //MARK:- Outlet
    
    @IBOutlet weak var txtChar1: UITextField!
    @IBOutlet weak var txtChar2: UITextField!
    @IBOutlet weak var txtChar3: UITextField!
    @IBOutlet weak var txtChar4: UITextField!
    
    @IBOutlet weak var lblEnterCode: UILabel!
    @IBOutlet weak var lblSentMail: UILabel!
    
    @IBOutlet weak var btnTxtChar1: UIButton!
    @IBOutlet weak var btnTxtChar2: UIButton!
    @IBOutlet weak var btnTxtChar3: UIButton!
    @IBOutlet weak var btnTxtChar4: UIButton!
    @IBOutlet weak var btnResendCode: UIButton!
    @IBOutlet weak var btnVerify: UIButton!
    
    @IBOutlet weak var lblCountDown: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    
    //MARK:-
    //MARK:- Variables
    
    var count: Int = 0
    var timer: Timer!

    //MARK:-
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpObject()
    }
    
    //MARK:-
    //MARK:- SetUpObject Method
    
    func SetUpObject(){
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        
        lblSentMail.text = LanguageLocal.myLocalizedString(key: "Mail_With_Verification_Code")
        lblEnterCode.text = LanguageLocal.myLocalizedString(key: "Verify_Email")
        self.btnVerify.setTitle(LanguageLocal.myLocalizedString(key: "Verify"), for: .normal)
        lblEmail.text = "\(TPreferences.readString(USER_EMAIL) ?? "")"
        print("\(TPreferences.readString(USER_EMAIL) ?? "")")
        self.TimeCountDown()
    }
    
    //MARK:-
    //MARK:- UITextFieldDelegate Method.
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
    
    //MARK:-
    //MARK:- Other Method
    
    func TimeCountDown() {
        btnResendCode.isHidden = true
        count = 60
        
         self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateView), userInfo: nil, repeats: true)        
    }
    
    @objc func updateView() {
        if count > 0 {
            count = count - 1
            self.lblCountDown.text = "\(count)"
        }else {
            timer.invalidate()
            btnResendCode.isHidden = false
            self.lblCountDown.text = "00"
        }
    }
    
    //MARK:-
    //MARK:- UIButton Click Events.

    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendCode_Clicked(_ sender: Any) {
        self.TimeCountDown()
    }
    
    @IBAction func btnVerify_Clicked(_ sender: Any) {
        let vc = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
