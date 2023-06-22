//
//  AddNewCardViewController.swift

import UIKit
import GoogleMobileAds

class AddNewCardViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, GADInterstitialDelegate {

    @IBOutlet weak var lblSelectMonth: UILabel!
    @IBOutlet weak var lblSelectYear: UILabel!
   
    @IBOutlet weak var txtCardNo1: UITextField!
    @IBOutlet weak var txtCardNo2: UITextField!
    @IBOutlet weak var txtCardNo3: UITextField!
    @IBOutlet weak var txtCardNo4: UITextField!
    @IBOutlet weak var txtCardHolderName: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblCardNo: UILabel!
    @IBOutlet weak var lblCardHolderName: UILabel!
    @IBOutlet weak var lblCVV: UILabel!
    
    @IBOutlet weak var btnShowCVV: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var btnAddCard: UIButton!
    @IBOutlet weak var pickerMonthYear: UIPickerView!   
    
    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    
    //MARK: -
    //MARK: - Variables
    
    var pickerIdentifier = String()
    let arrMonth = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    let arrYear = ["2019", "2020", "2021", "2022", "2023", "2024", "2025", "2026", "2027", "2028", "2029", "2030"]
    var isBackspacePressed = Bool()

    var interstitial: GADInterstitial!
    
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
        
        pickerIdentifier = ""
        
        self.lblHeaderTitle.text = LanguageLocal.myLocalizedString(key: "Add_New_Card")
        self.lblCardNo.text = LanguageLocal.myLocalizedString(key: "Card_Number")
        self.lblCVV.text = LanguageLocal.myLocalizedString(key: "Cvv")
        self.lblCardHolderName.text = LanguageLocal.myLocalizedString(key: "Card_Holder_Name")
        self.lblSelectYear.text = LanguageLocal.myLocalizedString(key: "Selected_Year")
        self.lblSelectMonth.text = LanguageLocal.myLocalizedString(key: "Selected_Month")
        self.btnDone.setTitle(LanguageLocal.myLocalizedString(key: "Done"), for: .normal)
        self.btnAddCard.setTitle(LanguageLocal.myLocalizedString(key: "Add_Card"), for: .normal)
        
        interstitial = GADInterstitial(adUnitID: INTERSTITIAL_ID)
            let request = GADRequest()
            interstitial.load(request)
            interstitial.delegate = self
        }
        
        //MARK: -
        //MARK: - GADInterstitialDelegate
        
        func interstitialDidReceiveAd(_ ad: GADInterstitial) {
            interstitial.present(fromRootViewController: self)
        }

        func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
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
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
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

    @IBAction func btnAddCard_Clicked(_ sender: Any) {
        if txtCardNo1.text!.count >= 4 {
            if txtCardNo2.text!.count >= 4 {
                if txtCardNo3.text!.count >= 4 {
                    if txtCardNo4.text!.count >= 4 {
                        if txtCVV.text!.count > 0 {
                            if lblSelectMonth.text != "Select Month" {
                                if lblSelectYear.text != "Select Year" {
                                    if txtCardHolderName.text!.count > 0 {
                                        THelper.toast("Card added successfully...", vc: self)
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                    else {
                                        THelper.toast("Enter card holder name", vc: self)
                                    }
                                }
                                else {
                                    THelper.toast("Select expire year", vc: self)
                                }
                            }
                            else {
                                THelper.toast("Select expire month", vc: self)
                            }
                        }
                        else {
                            THelper.toast("Enter CVV number", vc: self)
                        }
                    }
                    else {
                        THelper.toast("Enter card number", vc: self)
                    }
                }
                else {
                    THelper.toast("Enter card number", vc: self)
                }
            }
            else {
                THelper.toast("Enter card number", vc: self)
            }
        }
        else {
            THelper.toast("Enter card number", vc: self)
        }
    }
    
    @IBAction func btnDone_Clicked(_ sender: Any) {
        pickerMonthYear.isHidden = true
        btnDone.isHidden = true
    }
}
