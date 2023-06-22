//
//  SettingsViewController.swift

import UIKit
import GoogleMobileAds

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GADInterstitialDelegate, UITableViewDataSource, UITableViewDelegate, CollapsibleTableViewHeaderDelegate {

    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    @IBOutlet weak var constraintTblMultipalDashboardHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwLanguage: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwLanguagePicker: UIView!
    
    @IBOutlet weak var imgLanguage: UIImageView!
    
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblLanguageSetting: UILabel!
    @IBOutlet weak var lblLanguageValue: UILabel!
    @IBOutlet weak var lblDarkMode: UILabel!
    
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var pickerLanguage: UIPickerView!
    
    @IBOutlet weak var switchDarkMode: UISwitch!
    
    @IBOutlet weak var tblMultipalDashboard: UITableView!
    
    //MARK: -
    //MARK: - Variables
    
    var arrLanguage = [String]();
    var arrLanguageShort = [Any]();
    
    var languageIndex = Int()
    
    let obj = Language()
    var curruntLan = String()
    
    var interstitial: GADInterstitial!
    
    var sections = sectionsData
    
    //MARK: -
    //MARK: - UIView life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpObject()
        
        let mirror = Mirror(reflecting: obj)
        arrLanguage = mirror.children.compactMap { $0.label }
        arrLanguageShort = mirror.children.compactMap { $0.value }
        
        print(arrLanguage)
        print(arrLanguageShort)
        
    }
    
    //MARK: -
    //MARK: - SetUpObject
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
            
        } else {
            constraintHeaderTop.constant = UIApplication.shared.statusBarFrame.size.height
        }
        languageIndex = 0
        if "\(TPreferences.readString(LANGUAGE_NAME) ?? "")" != "" {
            lblLanguageValue.text = "\(TPreferences.readString(LANGUAGE_NAME) ?? "")"
        }
        else {
            lblLanguageValue.text = "English"
        }

        self.lblLanguageSetting.text = LanguageLocal.myLocalizedString(key: "Language")
        self.lblHeading.text = LanguageLocal.myLocalizedString(key: "Settings")
        self.lblDarkMode.text = LanguageLocal.myLocalizedString(key: "Dark_Mode")
                
        if TPreferences.readBoolean(IS_LOGGED_IN) {
            self.lblBadge.isHidden = false
            self.lblBadge.text = TPreferences.readString(CART_ITEM_COUNT)
            if IPAD {
                self.lblBadge.layer.cornerRadius = 20 / 2
            } else {
                self.lblBadge.layer.cornerRadius = self.lblBadge.layer.frame.height / 2
            }
        }else {
            self.lblBadge.isHidden = true
            self.lblBadge.text = ""
        }
        
        if TPreferences.readBoolean(DARK_MODE) {
            switchDarkMode.isOn = true
        }
        else {
            switchDarkMode.isOn = false
        }

//        tblMultipalDashboard.estimatedRowHeight = 44.0
//        tblMultipalDashboard.rowHeight = UITableView.automaticDimension
        
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
    
    //MARK:-
    //MARK:- UITableView Delegates and DataSources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        constraintTblMultipalDashboardHeight.constant = CGFloat(sections[section].collapsed ? 50 : (sections[section].items.count * 40) + 50)
        return sections[section].collapsed ? 0 : sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblMultipalDashboard.register(UINib.init(nibName: "MultipalDashboardTableCell", bundle: nil), forCellReuseIdentifier: "Cell")
        let cell = tblMultipalDashboard.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MultipalDashboardTableCell
        
        let item: Item = sections[indexPath.section].items[indexPath.row]
        cell.lblDashboardName.text = item.name
        
        if TPreferences.readString(DASHBOARD_STYLE) == "\(indexPath.row)" {
            cell.btnSelectDashboard.setImage(UIImage(named: "icoRadioChecked"), for: .normal)
            cell.btnSelectDashboard = THelper.setButtonTintColor(cell.btnSelectDashboard, imageName: "icoRadioChecked", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Secondary_Color1"))
        }
        else {
            cell.btnSelectDashboard.setImage(UIImage(named: "icoRadioUnchecked"), for: .normal)
            cell.btnSelectDashboard = THelper.setButtonTintColor(cell.btnSelectDashboard, imageName: "icoRadioUnchecked", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Secondary_Color1"))
        }
           
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TPreferences.writeString(DASHBOARD_STYLE, value: "\(indexPath.row)")
        tblMultipalDashboard.reloadData()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = LanguageLocal.myLocalizedString(key: sections[section].name)
        if THelper.isRTL() {
            header.arrowLabel.text = "<"
        }
        else {
            header.arrowLabel.text = ">"
        }
        header.setCollapsed(sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    //MARK:-
    //MARK:- CollapsibleTableViewHeaderDelegate Methods.
     
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
           // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        tblMultipalDashboard.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    //MARK: -
    //MARK: - Picker View Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrLanguage.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrLanguage[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lblLanguageValue.text = arrLanguage[row]
        languageIndex = row
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: "\(arrLanguage[row])", attributes: [NSAttributedString.Key.foregroundColor : ThemeManager.shared()?.color(forKey: "Secondary_Color1") as Any])
        return attributedString
    }
    
    //MARK: -
    //MARK: - Other Method
    
    func changeLanguage(language: String) {
        TPreferences.writeString(LANGUAGE, value: language)
        AppDelegate.getDelegate()?.sideDrawerDirection()
        THelper.SetLanguage_RTL()
        navigationController?.popToRootViewController(animated: true)
        curruntLan = TPreferences.readString(LANGUAGE) ?? ""
    }
    
    //MARK: -
    //MARK: - UISwitch Action Method
    
    @IBAction func switchDarkMode_Changed(_ sender: UISwitch) {
        if sender.isOn {
            TPreferences.writeBoolean(DARK_MODE, value: true)
            if IPAD {
                ThemeManager.shared()?.changeTheme("default_iPad_dark")
            }
            else {
                ThemeManager.shared()?.changeTheme("default_dark")
            }
        }
        else {
            TPreferences.writeBoolean(DARK_MODE, value: false)
            if IPAD {
                ThemeManager.shared()?.changeTheme("default_iPad")
            }
            else {
                ThemeManager.shared()?.changeTheme("default")
            }
        }
    }
    
    //MARK: -
    //MARK: - UIButton Action Method
    
    @IBAction func vwBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCart_Clicked(_ sender: Any) {
        let vc = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
        vc.flagHeader = false
        vc.isFormPayCard = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLanguage_Clicked(_ sender: Any) {
        pickerLanguage.reloadAllComponents()
        vwLanguagePicker.isHidden = false
    }
    
    @IBAction func btnDone_Clicked(_ sender: Any) {
        vwLanguagePicker.isHidden = true
        
        TPreferences.writeString(LANGUAGE_NAME, value: arrLanguage[languageIndex])
                
        if "\(arrLanguageShort[languageIndex])" == "\(TPreferences.readString(LANGUAGE) ?? "")" {
            THelper.toast("You have selected the same language", vc: self)
        }
        else {
            if "\(arrLanguageShort[languageIndex])" != "" {
                changeLanguage(language: "\(arrLanguageShort[languageIndex])")
            }
            else {
                changeLanguage(language: "en")
            }
        }
    }
    
    @IBAction func btnCancel_Clicked(_ sender: Any) {
        vwLanguagePicker.isHidden = true
    }
    
    @IBAction func btnNotification_Clicked(_ sender: UIButton) {
     
    }
}
