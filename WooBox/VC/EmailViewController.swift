//
//  EmailViewController.swift

import UIKit
import MessageUI

class EmailViewController: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    
    @IBOutlet weak var txtDesc: UITextView!
    //MARK: -
    //MARK: - Variables
    var arrData = ["Email to Woobox","Description"]
    
    //MARK: -
    //MARK: - UIView life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SetUpObject()
    }
    //MARK: -
    //MARK: - SetUpObject
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
            
        } else {
            constraintHeaderTop.constant = UIApplication.shared.statusBarFrame.size.height
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
//            self.txtEmail.text = ""
        }
        self.txtEmail.text = Contact_us_Email
        
        self.lblHeaderTitle.text = LanguageLocal.myLocalizedString(key: "Email")
        
    }
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSent_Mail(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.txtEmail.text ?? ""])
//            mail.setSubject("Email Subject Here")
            mail.setMessageBody(self.txtDesc.text, isHTML: false)
            present(mail, animated: true)
        } else {
            print("Application is not able to send an email")
            THelper.toast("Application is not able to send an email", vc: self)
        }
    }
    
    @IBAction func btnCart_Clicked(_ sender: Any) {
        let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
        vc.flagHeader = false
        vc.isFormPayCard = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: MFMail Compose ViewController Delegate method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled: THelper.toast("Sending Mail is cancelled", vc: self)
            case .sent : THelper.toast("Your Mail has been sent successfully", vc: self)
            case .saved : THelper.toast("Sending Mail is Saved", vc: self)
            case .failed :THelper.toast("Message sending failed", vc: self)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
