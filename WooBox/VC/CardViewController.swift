//
//  CardViewController.swift

import UIKit

class CardViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblCardNo: UILabel!
    @IBOutlet weak var lblSelectMonth: UILabel!
    @IBOutlet weak var lblSelectYear: UILabel!
    @IBOutlet weak var lblCardHolderName: UILabel!
    @IBOutlet weak var lblCVV: UILabel!
    @IBOutlet weak var lblCountDown: UILabel!
    
    @IBOutlet weak var txtCardNo1: UITextField!
    @IBOutlet weak var txtCardNo2: UITextField!
    @IBOutlet weak var txtCardNo3: UITextField!
    @IBOutlet weak var txtCardNo4: UITextField!
    @IBOutlet weak var txtCardHolderName: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwMain: UIView!
    
    @IBOutlet weak var btnShowCVV: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var pickerMonthYear: UIPickerView!
    
    @IBOutlet weak var lblPaymentDetail: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblShippingCharges: UILabel!
    
    
    //MARK: -
    //MARK: - Variables
    
    var count = 300
    var pickerIdentifier = String()
    
    let arrMonth = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    let arrYear = ["2019", "2020", "2021", "2022", "2023", "2024", "2025", "2026", "2027", "2028", "2029", "2030"]
    var isBackspacePressed = Bool()
    
    //MARK: -
    //MARK: - UIView life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpView()
    }

    //MARK: -
    //MARK: - SetUpView
    
    func SetUpView() {
        if #available(iOS 11.0, *) {
            
        } else {
            constraintHeaderTop.constant = UIApplication.shared.statusBarFrame.size.height
        }
        
        pickerIdentifier = ""
        self.lblPaymentDetail.text = LanguageLocal.myLocalizedString(key: "Payment_Detail")
        self.lblItemPrice.text = LanguageLocal.myLocalizedString(key: "Item_Price")
        self.lblOffer.text = LanguageLocal.myLocalizedString(key: "Offers")
        self.lblShippingCharges.text = LanguageLocal.myLocalizedString(key: "Shipping_Charges")
        self.lblTotalAmount.text = LanguageLocal.myLocalizedString(key: "Total_Amount")
        self.lblCardNo.text = LanguageLocal.myLocalizedString(key: "Card_Number")
        self.lblCVV.text = LanguageLocal.myLocalizedString(key: "Cvv")
        self.lblCardHolderName.text = LanguageLocal.myLocalizedString(key: "Card_Holder_Name")
        self.lblSelectYear.text = LanguageLocal.myLocalizedString(key: "Selected_Year")
        self.lblSelectMonth.text = LanguageLocal.myLocalizedString(key: "Selected_Month")
        self.btnDone.setTitle(LanguageLocal.myLocalizedString(key: "Done"), for: .normal)
        
    }
    
    
    //MARK: -
    //MARK: - Picker View Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerIdentifier == "month" {
            return arrMonth.count
        }
        else if pickerIdentifier == "year" {
            return arrYear.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerIdentifier == "month" {
            return arrMonth[row]
        }
        else if pickerIdentifier == "year" {
            return arrYear[row]
        }
        else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerIdentifier == "month" {
           lblSelectMonth.text = arrMonth[row]
        }
        else {
            lblSelectYear.text = arrYear[row]
        }
    }
    
    //MARK: -
    //MARK: - UITextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var length = (textField.text?.count)!
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                length = length - 1
                if length > 0 {
                    isBackspacePressed = false
                    return true
                }
                else {
                    isBackspacePressed = true
                    if textField.isEqual(txtCardNo1) {
                        textField.resignFirstResponder()
                    } else if textField.isEqual(txtCardNo2) {
                        txtCardNo1.becomeFirstResponder()
                    } else if textField.isEqual(txtCardNo3) {
                        txtCardNo2.becomeFirstResponder()
                    } else if textField.isEqual(txtCardNo4) {
                        txtCardNo3.becomeFirstResponder()
                    } else {
                    }
                    return false
                }
            }
        }
        
        if length > 3 {
            isBackspacePressed = false
            if textField.isEqual(txtCardNo1) {
                txtCardNo2.becomeFirstResponder()
            } else if textField.isEqual(txtCardNo2) {
                txtCardNo3.becomeFirstResponder()
            } else if textField.isEqual(txtCardNo3) {
                txtCardNo4.becomeFirstResponder()
            } else if textField.isEqual(txtCardNo4) {
                textField.resignFirstResponder()
            } else {
            }
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isBackspacePressed == true {
            textField.text = ""
            isBackspacePressed = false
        }
    }
    
    //MARK: -
    //MARK: - UIButton Action Method
    
    @IBAction func btnSelectMonth_Clicked(_ sender: Any) {
        pickerIdentifier = "month"
        pickerMonthYear.reloadAllComponents()
        pickerMonthYear.isHidden = false
        btnDone.isHidden = false
    }
    
    @IBAction func btnSelectYear_Clicked(_ sender: Any) {
        pickerIdentifier = "year"
        pickerMonthYear.reloadAllComponents()
        pickerMonthYear.isHidden = false
        btnDone.isHidden = false
    }
    
    @IBAction func btnPay_Clicked(_ sender: Any) {
      
    }
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShowCVV_Clicked(_ sender: Any) {
        btnShowCVV.isSelected = !btnShowCVV.isSelected
        if btnShowCVV.isSelected {
            btnShowCVV = THelper.setButtonTintColor(btnShowCVV, imageName: "icoVisibility", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
            txtCVV.isSecureTextEntry = false
        }
        else {
            btnShowCVV = THelper.setButtonTintColor(btnShowCVV, imageName: "icoVisibilityOff", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
            txtCVV.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnDone_Clicked(_ sender: Any) {
        pickerMonthYear.isHidden = true
        btnDone.isHidden = true
    }
}
