//
//  FilterViewController.swift

import UIKit
import MultiSlider
import Alamofire
import OAuthSwiftAlamofire
import GoogleMobileAds

class FilterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource, GADInterstitialDelegate {

    //MARK:-
    //MARK:- Outlets
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    @IBOutlet weak var constraintTblBrandsHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTblDiscountHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTblRaingHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintCvColorHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintCvSizeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ConstraintCategoriesHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwPrice: UIView!
    @IBOutlet weak var vwBrand: UIView!
    @IBOutlet weak var vwColor: UIView!
    @IBOutlet weak var vwSize: UIView!
    
    @IBOutlet weak var cvColors: UICollectionView!
    @IBOutlet weak var cvSizes: UICollectionView!
    
    @IBOutlet weak var cvCategoires: UICollectionView!
    
    @IBOutlet weak var vwPriceSlider: UIView!
    
    @IBOutlet weak var vwBottom: UIView!
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblMax: UILabel!
    @IBOutlet weak var lblBrands: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblRatings: UILabel!
    @IBOutlet weak var lblColors: UILabel!
    
    @IBOutlet weak var lblMoreCategory: UILabel!
    
    @IBOutlet weak var btnMoreDropDown: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnDiscountDropDown: UIButton!
    @IBOutlet weak var btnRatingDropDown: UIButton!
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    @IBOutlet weak var tblBrands: UITableView!
    @IBOutlet weak var tblDiscount: UITableView!
    @IBOutlet weak var tblRatings: UITableView!
    
    @IBOutlet weak var CategoriesPicker: UIPickerView!
    
    //MARK:-
    //MARK:- Variables
    
    let arrDiscount = ["Less then 50%", "Flat 50%", "More then 50%"]
    let arrRating = ["4 star and Above", "3 star and Above"]
    let arrCategorie = ["Mens","Womens","Kids","Camera","Sports","Electronic","Optical","Bags"]
    
    let arrSelectedBrand = NSMutableArray()
    let arrSelectedDiscount = NSMutableArray()
    let arrSelectedRatings = NSMutableArray()
    let arrSelectedCategories = NSMutableArray()
    let arrSelectedCat = NSMutableArray()
    let arrSelectColorId = NSMutableArray()
    let arrSelectSizeId = NSMutableArray()
    let arrSelectBrandId = NSMutableArray()
    var arrSelectedSize = NSMutableArray()
    var arrSelectedColor = NSMutableArray()
    var strCategoires = String()
    var tag = Int()
    let slider = MultiSlider()
    var arrBrands = NSArray()
    var arrColor = NSArray()
    var arrSize = NSArray()
    var arrCategory = NSArray()
    var price = [CGFloat]()
    
    var interstitial: GADInterstitial!
    
    //MARK:-
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpObject()
    }
    
    //MARK: -
    //MARK: - SetUpObject Method
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
            
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        
        slider.minimumValue = 0
        slider.maximumValue = 1000
        SetUpValue()
        
        self.lblHeader.text = LanguageLocal.myLocalizedString(key: "Filters")
        self.lblSize.text = LanguageLocal.myLocalizedString(key: "Size")
        self.lblPrice.text = LanguageLocal.myLocalizedString(key: "Price")
        self.lblBrands.text = LanguageLocal.myLocalizedString(key: "Brands")
        self.lblColors.text = LanguageLocal.myLocalizedString(key: "Colors")
        self.lblRatings.text = LanguageLocal.myLocalizedString(key: "Ratings")
        self.lblDiscount.text = LanguageLocal.myLocalizedString(key: "Discount")
        self.btnSelectAll.setTitle(LanguageLocal.myLocalizedString(key: "Select_All"), for: .normal)
        self.btnDone.setTitle(LanguageLocal.myLocalizedString(key: "Done"), for: .normal)
        self.btnReset.setTitle(LanguageLocal.myLocalizedString(key: "Reset"), for: .normal)
        self.btnApply.setTitle(LanguageLocal.myLocalizedString(key: "Apply"), for: .normal)
        
        CategoriesPicker.backgroundColor = .white
        self.btnDone.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
        
        if IPAD {
            self.slider.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 200 , height: 40)
        }else {
             self.slider.frame = CGRect(x: 0, y: 0, width: vwPriceSlider.frame.width, height: 40)
        }
//        let slider = MultiSlider(frame: CGRect(x: 0, y: 0, width: vwPriceSlider.frame.width, height: 40))
        
        var imgTemp = UIImageView()
        imgTemp.image = UIImage(named: "icoDot")
        imgTemp = THelper.setTintColor(imgTemp, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))!
        
        slider.thumbImage = imgTemp.image
        slider.valueLabelFormatter.positivePrefix = "\(PRICE_SIGN)"
        slider.outerTrackColor = .groupTableViewBackground
        slider.orientation = .horizontal
        slider.valueLabelPosition = .top // .notAnAttribute = don't show labels
        slider.tintColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color") // color of track
        slider.trackWidth = 5
        slider.hasRoundTrackEnds = true
        
        slider.addTarget(self, action: #selector(sliderChanged(slider:)), for: .valueChanged)
        
        vwPriceSlider.addSubview(slider)
        
        self.vwBottom.layer.shadowColor = UIColor.lightGray.cgColor
        self.vwBottom.layer.shadowOpacity = 5.0
        self.vwBottom.layer.shadowRadius = 10.0
        self.vwBottom.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
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
    
    @objc func sliderChanged(slider: MultiSlider) {
        price = slider.value
    }
        
    func SetUpValue() {
        if arrBrands.count > 0 {
            vwBrand.isHidden = false
        }
        else {
            vwBrand.isHidden = true
            constraintTblBrandsHeight.constant = 0
        }
        
        if arrColor.count > 0 {
            vwColor.isHidden = false
            constraintCvColorHeight.constant = 50
        }
        else {
            vwColor.isHidden = true
            constraintCvColorHeight.constant = 0
        }
        
        if arrSize.count > 0 {
            vwSize.isHidden = false
            constraintCvSizeHeight.constant = 50
        }
        else {
            vwSize.isHidden = true
            constraintCvSizeHeight.constant = 0
        }
        
        if TValidation.isDictionary(TPreferences.readObject(FILTER_ATTRIBUTES_INDEXPATH)) {
            let dicFilteAttrbuteIndexPath: NSDictionary = TPreferences.readObject(FILTER_ATTRIBUTES_INDEXPATH) as! NSDictionary
            let dicFilteAttrbute: NSDictionary = TPreferences.readObject(FILTER_ATTRIBUTES) as! NSDictionary
            
            if dicFilteAttrbuteIndexPath.value(forKey: "brandIndexPath") != nil {
                let arrBrandIndexPath: NSArray = dicFilteAttrbuteIndexPath.value(forKey: "brandIndexPath") as! NSArray
                let arrBrand: NSArray = dicFilteAttrbute.value(forKey: "brand") as! NSArray
                
                for i in 0..<arrBrandIndexPath.count {
                    arrSelectedBrand.add(arrBrandIndexPath[i])
                }
                
                for i in 0..<arrBrand.count {
                    arrSelectBrandId.add(arrBrand[i])
                }
            }
            
            if dicFilteAttrbuteIndexPath.value(forKey: "categoryIndexPath") != nil {
                let arrCategoryIndexPath: NSArray = dicFilteAttrbuteIndexPath.value(forKey: "categoryIndexPath") as! NSArray
                let arrCategory: NSArray = dicFilteAttrbute.value(forKey: "category") as! NSArray
                
                for i in 0..<arrCategoryIndexPath.count {
                    arrSelectedCategories.add(arrCategoryIndexPath[i])
                }
                
                for i in 0..<arrCategory.count {
                    arrSelectedCat.add(arrCategory[i])
                }
            }
            
            if dicFilteAttrbuteIndexPath.value(forKey: "colorIndexPath") != nil {
                let arrColorIndexPath: NSArray = dicFilteAttrbuteIndexPath.value(forKey: "colorIndexPath") as! NSArray
                let arrColor: NSArray = dicFilteAttrbute.value(forKey: "color") as! NSArray
                
                for i in 0..<arrColorIndexPath.count {
                    arrSelectedColor.add(arrColorIndexPath[i])
                }
                
                for i in 0..<arrColor.count {
                    arrSelectColorId.add(arrColor[i])
                }
            }
            
            if dicFilteAttrbuteIndexPath.value(forKey: "sizeIndexPath") != nil {
                let arrSizeIndexPath: NSArray = dicFilteAttrbuteIndexPath.value(forKey: "sizeIndexPath") as! NSArray
                let arrSize: NSArray = dicFilteAttrbute.value(forKey: "size") as! NSArray
                
                for i in 0..<arrSizeIndexPath.count {
                    arrSelectedSize.add(arrSizeIndexPath[i])
                }
                
                for i in 0..<arrSize.count {
                    arrSelectSizeId.add(arrSize[i])
                }
            }
            
            if dicFilteAttrbuteIndexPath.value(forKey: "price") != nil {
                let arrPrice: [CGFloat] = dicFilteAttrbuteIndexPath.value(forKey: "price") as! [CGFloat]
                price = arrPrice
                slider.value = [arrPrice[0], arrPrice[1]]
            }
            else {
                slider.value = [slider.minimumValue, slider.maximumValue]
            }
        }
    }
    
    //MARK: -
    //MARK: - Picker View Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCategorie.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrCategorie[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        strCategoires = arrCategorie[row]
    }
    
    //MARK: -
    //MARK: - UICollectionView Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvCategoires {
            return arrCategory.count
        }
        else if collectionView == cvColors {
            return arrColor.count
        }
        else { //if collectionView == cvSizes
            return arrSize.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cvColors {
            cvColors.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
            let cell = cvColors.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoriesCollectionCell
            
            let dicColor:NSDictionary = arrColor[indexPath.row] as! NSDictionary
                        
            if arrSelectedColor.count > 0 {
                if arrSelectedColor.contains(indexPath.item) {
                    cell.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
                    cell.lblCategory.textColor = .white
                }
                else {
                    cell.backgroundColor = .white
                    cell.lblCategory.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
                }
            }
            else {
                cell.backgroundColor = .white
                cell.lblCategory.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            }
            
            cell.lblCategory.text = "\(dicColor.value(forKey: "name") ?? "")"
            
            return cell
            
//            self.cvColors.register(UINib(nibName: "ColorViewCell", bundle: nil), forCellWithReuseIdentifier: "ColorViewCell")
//            let cell = cvColors.dequeueReusableCell(withReuseIdentifier: "ColorViewCell", for: indexPath) as! ColorViewCell
//
//            let dicColor:NSDictionary = arrColor[indexPath.row] as! NSDictionary
//            cell.lblColors.backgroundColor = UIColor(hexString: "\(dicColor.value(forKey: "name") ?? "")", alpha: 1.0)
//
//            if IPAD {
//                 cell.lblColors.layer.cornerRadius = 20 / 2
//            }else {
//                cell.lblColors.layer.cornerRadius = cell.lblColors.layer.frame.height / 2
//            }
//            if arrSelectedColor.count > 0 {
//                if arrSelectedColor.contains(indexPath.item) {
//                    cell.vwColor.backgroundColor = UIColor(hexString: "\(dicColor.value(forKey: "name") ?? "")", alpha: 1.0)
//                    cell.vwColor.layer.cornerRadius = cell.vwColor.layer.frame.height / 2
//                    cell.btnCheck.isHidden = false
//                    cell.btnCheck.alpha = 1.0
//                }
//                else {
//                    cell.vwColor.backgroundColor = UIColor.clear
//                    cell.vwColor.layer.cornerRadius = cell.vwColor.layer.frame.height / 2
//                    cell.btnCheck.isHidden = true
//                    cell.btnCheck.alpha = 0.0
//                }
//            }
//            else {
//                cell.vwColor.backgroundColor = UIColor.clear
//                cell.vwColor.layer.cornerRadius = cell.vwColor.layer.frame.height / 2
//                cell.btnCheck.isHidden = true
//                cell.btnCheck.alpha = 0.0
//            }
//
//            return cell
        }
        else if collectionView == cvSizes {
            self.cvSizes.register(UINib(nibName: "SizeViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeViewCell")
            let cell = cvSizes.dequeueReusableCell(withReuseIdentifier: "SizeViewCell", for: indexPath) as! SizeViewCell
            
            let dicSize:NSDictionary = arrSize[indexPath.row] as! NSDictionary
            cell.lblSize.text = "\(dicSize.value(forKey: "name") ?? "")"
            
            if arrSelectedSize.count > 0 {
                if arrSelectedSize.contains(indexPath.item) {
                    cell.vwSize.backgroundColor = UIColor.primaryColor()
                    cell.lblSize.textColor = UIColor.white
                    cell.vwSize.layer.cornerRadius = cell.vwSize.layer.frame.height / 2
                }
                else {
                    cell.vwSize.backgroundColor = UIColor.clear
                    cell.lblSize.textColor = UIColor.black
                    cell.vwSize.layer.cornerRadius = cell.vwSize.layer.frame.height / 2
                }
            }
            else {
                cell.vwSize.backgroundColor = UIColor.clear
                cell.lblSize.textColor = UIColor.black
                cell.vwSize.layer.cornerRadius = cell.vwSize.layer.frame.height / 2
            }

            return cell
        }
        else {
            cvCategoires.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
            let cell = cvCategoires.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoriesCollectionCell
            
            var dicCategory = NSDictionary()
            dicCategory = arrCategory[indexPath.item] as! NSDictionary
            
            print(dicCategory)
            
            if arrSelectedCategories.count > 0 {
                if arrSelectedCategories.contains(indexPath.item) {
                    cell.backgroundColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
                    
                    cell.lblCategory.textColor = .white
                }
                else {
                    cell.backgroundColor = .white
                    cell.lblCategory.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
                    
                }
            }
            else {
                cell.backgroundColor = .white
                cell.lblCategory.textColor = ThemeManager.shared()?.color(forKey: "Primary_Default_Color")
            }
            
            cell.lblCategory.text = "\(dicCategory.value(forKey: "name") ?? "")"
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cvColors {
            let dicColor:NSDictionary = arrColor[indexPath.row] as! NSDictionary
            if arrSelectedColor.count > 0 {
                if arrSelectedColor.contains(indexPath.row) {
                    arrSelectedColor.remove(indexPath.row)
                    arrSelectColorId.remove("\(dicColor.value(forKey: "slug") ?? "")")
                }
                else {
                    arrSelectedColor.add(indexPath.row)
                    arrSelectColorId.add("\(dicColor.value(forKey: "slug") ?? "")")
                }
            }
            else {
                arrSelectedColor.add(indexPath.row)
                arrSelectColorId.add("\(dicColor.value(forKey: "slug") ?? "")")
            }
            self.cvColors.reloadData()
        }
        else if collectionView == cvSizes {
             let dicSize:NSDictionary = arrSize[indexPath.row] as! NSDictionary
            if arrSelectedSize.count > 0 {
                if arrSelectedSize.contains(indexPath.row) {
                    arrSelectedSize.remove(indexPath.row)
                    arrSelectSizeId.remove("\(dicSize.value(forKey: "name") ?? "")")
                }
                else {
                    arrSelectedSize.add(indexPath.row)
                    arrSelectSizeId.add("\(dicSize.value(forKey: "name") ?? "")")
                }
            }
            else {
                arrSelectedSize.add(indexPath.row)
                arrSelectSizeId.add("\(dicSize.value(forKey: "name") ?? "")")
            }
            self.cvSizes.reloadData()
        }
        else {
            var dicCategory = NSDictionary()
            dicCategory = arrCategory[indexPath.item] as! NSDictionary
            
            if arrSelectedCategories.count > 0 {
                if arrSelectedCategories.contains(indexPath.item) {
                    self.arrSelectedCat.remove("\(dicCategory.value(forKey: "cat_ID") ?? "")")
                    arrSelectedCategories.remove(indexPath.item)
                }
                else {
                    self.arrSelectedCat.add("\(dicCategory.value(forKey: "cat_ID") ?? "")")
                    arrSelectedCategories.add(indexPath.item)
                }
            }
            else {
                self.arrSelectedCat.add("\(dicCategory.value(forKey: "cat_ID") ?? "")")
                arrSelectedCategories.add(indexPath.item)
            }
            cvCategoires.reloadData()
        }
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvCategoires {
            let label = UILabel(frame: CGRect.zero)
            var dicCategory = NSDictionary()
            dicCategory = arrCategory[indexPath.item] as! NSDictionary
            label.text = "\(dicCategory.value(forKey: "name") ?? "")"
            label.sizeToFit()
            return CGSize(width: label.frame.width + 16, height: 40)
        }
        else if collectionView == cvColors {
            let lblColor = UILabel(frame: CGRect.zero)
            var dicColor = NSDictionary()
            dicColor = arrColor[indexPath.item] as! NSDictionary
            lblColor.text = "\(dicColor.value(forKey: "name") ?? "")"
            lblColor.sizeToFit()
            return CGSize(width: lblColor.frame.width + 16, height: 40)
        }
        else {
            return CGSize(width: 50, height: 50)
        }
    }
    
    //MARK: -
    //MARK: - UITableView DataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblBrands {
            return arrBrands.count
        }
        else if tableView == tblDiscount {
            return arrDiscount.count
        }
        else {
            return arrRating.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblBrands {
            if IPAD {
                if arrBrands.count > 0 {
                    constraintTblBrandsHeight.constant = CGFloat(arrBrands.count * 80)
                }
                else {
                    constraintTblBrandsHeight.constant = 0
                }
                return 80
            }
            else {
                if arrBrands.count > 0 {
                    constraintTblBrandsHeight.constant = CGFloat(arrBrands.count * 50)
                }
                else {
                    constraintTblBrandsHeight.constant = 0
                }
                return 50
            }
        }
        else {
            if IPAD {
                constraintTblRaingHeight.constant = CGFloat(arrRating.count * 80)
                return 80
            }
            else {
                constraintTblRaingHeight.constant = CGFloat(arrRating.count * 50)
                return 50
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblBrands {
            tblBrands.register(UINib(nibName: "BrandsTableCell", bundle: nil), forCellReuseIdentifier: "BrandCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath) as! BrandsTableCell
            
            if arrSelectedBrand.contains(indexPath.row) {
                cell.btnSelectBrand.backgroundColor = .clear
                cell.btnSelectBrand.setImage(UIImage(named: "icoCheck-1"), for: .normal)
                cell.btnSelectBrand = THelper.setButtonTintColor(cell.btnSelectBrand, imageName: "icoCheck-1", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
            }
            else {
                cell.btnSelectBrand.backgroundColor = .lightGray
                cell.btnSelectBrand.setImage(UIImage(named: ""), for: .normal)
            }
            
            let dicBrand:NSDictionary = arrBrands[indexPath.row] as! NSDictionary
            cell.lblBrands.text = "\(dicBrand.value(forKey: "name") ?? "")"
            
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == tblDiscount {
            tblDiscount.register(UINib(nibName: "DiscountTableCell", bundle: nil), forCellReuseIdentifier: "DiscountCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiscountCell", for: indexPath) as! DiscountTableCell
            
            if arrSelectedDiscount.contains(indexPath.row) {
                cell.btnSelectDiscount.backgroundColor = .clear
                cell.btnSelectDiscount.setImage(UIImage(named: "icoCheck-1"), for: .normal)
                cell.btnSelectDiscount = THelper.setButtonTintColor(cell.btnSelectDiscount, imageName: "icoCheck-1", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
            }
            else {
                cell.btnSelectDiscount.backgroundColor = .lightGray
                cell.btnSelectDiscount.setImage(UIImage(named: ""), for: .normal)
            }
            cell.lblDiscount.text = arrDiscount[indexPath.row]
            
            cell.selectionStyle = .none
            return cell
        }
        else {
            tblRatings.register(UINib(nibName: "DiscountTableCell", bundle: nil), forCellReuseIdentifier: "DiscountCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiscountCell", for: indexPath) as! DiscountTableCell
            
            if arrSelectedRatings.contains(indexPath.row) {
                cell.btnSelectDiscount.backgroundColor = .clear
                cell.btnSelectDiscount.setImage(UIImage(named: "icoCheck-1"), for: .normal)
                cell.btnSelectDiscount = THelper.setButtonTintColor(cell.btnSelectDiscount, imageName: "icoCheck-1", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))

            }
            else {
                cell.btnSelectDiscount.backgroundColor = .lightGray
                cell.btnSelectDiscount.setImage(UIImage(named: ""), for: .normal)
            }
            
            cell.lblDiscount.text = arrRating[indexPath.row]
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblBrands {
              let dicBrand:NSDictionary = arrBrands[indexPath.row] as! NSDictionary
            if arrSelectedBrand.contains(indexPath.row) {
                arrSelectedBrand.remove(indexPath.row)
                 self.arrSelectBrandId.remove("\(dicBrand.value(forKey: "name") ?? "")")
            }
            else {
                arrSelectedBrand.add(indexPath.row)
                self.arrSelectBrandId.add("\(dicBrand.value(forKey: "name") ?? "")")
            }
            
            tblBrands.reloadData()
        }
        else if tableView == tblDiscount {
            if arrSelectedDiscount.contains(indexPath.row) {
                arrSelectedDiscount.remove(indexPath.row)
            }
            else {
                arrSelectedDiscount.add(indexPath.row)
            }
            
            tblDiscount.reloadData()
        }
        else if tableView == tblRatings {
            if arrSelectedRatings.contains(indexPath.row) {
                arrSelectedRatings.remove(indexPath.row)
            }
            else {
                arrSelectedRatings.add(indexPath.row)
            }
            
            tblRatings.reloadData()
        }
        print("Selcted Brand \(arrSelectBrandId)")
    }
    
    //MARK: -
    //MARK: - UIButton Action Method
    
    @IBAction func btnSelectAllBrands_Clicked(_ sender: Any) {
        if arrSelectedBrand.count == arrBrands.count {
            arrSelectedBrand.removeAllObjects()
        }
        else {
            if arrSelectedBrand.count > 0 {
                for i in 0..<arrBrands.count {
                    if arrSelectedBrand.contains(i) {
                        
                    }
                    else {
                        arrSelectedBrand.add(i)
                    }
                }
            }
            else {
                for i in 0..<arrBrands.count {
                    arrSelectedBrand.add(i)
                }
            }
        }
        
        tblBrands.reloadData()
    }
    
    @IBAction func btnSelectCategories_Clicked(_ sender: UIButton) {
        tag = sender.tag
        CategoriesPicker.isHidden = false
        btnDone.isHidden = false
    }
    
    @IBAction func btnDone_Clicked(_ sender: Any) {
//        arrSelectedCat.replaceObject(at: tag, with: strCategoires)
        CategoriesPicker.isHidden = true
        btnDone.isHidden = true
    }
    
    @IBAction func btnDiscountDropDown_Clicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            constraintTblDiscountHeight.constant = 0
        }
        else {
            if IPAD {
                constraintTblDiscountHeight.constant = CGFloat(arrDiscount.count * 80)
            }
            else {
                constraintTblDiscountHeight.constant = CGFloat(arrDiscount.count * 50)
            }
        }
    }
    
    @IBAction func btnRatingDropDown_Clicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            constraintTblRaingHeight.constant = 0
        }
        else {
            if IPAD {
                constraintTblRaingHeight.constant = CGFloat(arrRating.count * 80)
            }
            else {
                constraintTblRaingHeight.constant = CGFloat(arrRating.count * 50)
            }
        }
    }
    
    @IBAction func btnClose_Clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnReset_Clicked(_ sender: Any) {
        arrSelectedCategories.removeAllObjects()
        cvCategoires.reloadData()
        
        arrSelectedSize.removeAllObjects()
        cvSizes.reloadData()
        
        arrSelectedColor.removeAllObjects()
        cvColors.reloadData()
        
        arrSelectedBrand.removeAllObjects()
        tblBrands.reloadData()
        
        arrSelectedDiscount.removeAllObjects()
        tblDiscount.reloadData()
        
        arrSelectedRatings.removeAllObjects()
        tblRatings.reloadData()
    }
    
    @IBAction func btnApply_Clicked(_ sender: Any) {
        let dicFilter = NSMutableDictionary()
        let dicFilterIndexPath = NSMutableDictionary()
        
        if arrSelectColorId.count > 0 {
            dicFilter.setValue(arrSelectColorId, forKey: "color")
            dicFilterIndexPath.setValue(arrSelectedColor, forKey: "colorIndexPath")
        }
        
        if arrSelectBrandId.count > 0 {
            dicFilter.setValue(arrSelectBrandId, forKey: "brand")
            dicFilterIndexPath.setValue(arrSelectedBrand, forKey: "brandIndexPath")
        }
        
        if arrSelectSizeId.count > 0 {
            dicFilter.setValue(arrSelectSizeId, forKey: "size")
            dicFilterIndexPath.setValue(arrSelectedSize, forKey: "sizeIndexPath")
        }
        
        if arrSelectedCat.count > 0 {
            dicFilter.setValue(arrSelectedCat, forKey: "category")
            dicFilterIndexPath.setValue(arrSelectedCategories, forKey: "categoryIndexPath")
        }
        
        dicFilter.setValue(price, forKey: "price")
        dicFilterIndexPath.setValue(price, forKey: "price")
        
        print(dicFilter)
        
        TPreferences.writeObject(FILTER_ATTRIBUTES_INDEXPATH, value: dicFilterIndexPath)
        TPreferences.writeObject(FILTER_ATTRIBUTES, value: dicFilter)
        
        NotificationCenter.default.post(name: NSNotification.Name("filter"), object: self, userInfo: ["filters": dicFilter])
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnMoreCategory_Clicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            ConstraintCategoriesHeight.constant = cvCategoires.contentSize.height
            lblMoreCategory.text = "Less"
            btnMoreDropDown.setImage(UIImage(named: "icoUpArrow"), for: .normal)
        }
        else {
            lblMoreCategory.text = "More"
            btnMoreDropDown.setImage(UIImage(named: "icoDropDown"), for: .normal)
            ConstraintCategoriesHeight.constant = 100
        }
    }
}
