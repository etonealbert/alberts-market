//
//  DescriptionViewController.swift

import UIKit

class DescriptionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK:-
    //MARK:- Outlets
    
    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    
    @IBOutlet weak var vwPinCode: UIView!
    @IBOutlet weak var vwColors: UIView!
    @IBOutlet weak var vwSizes: UIView!
    
    @IBOutlet weak var imgUpDown: UIImageView!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblCheckAvailablity: UILabel!
    @IBOutlet weak var lblDeliveryBy: UILabel!
    @IBOutlet weak var lblColors: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    
    @IBOutlet weak var vwDescription: UIView!
//    @IBOutlet weak var vwDescrHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtPincode: UITextField!
    
    @IBOutlet weak var btnReadMore: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnRead: UIButton!
    
    @IBOutlet weak var cvColors: UICollectionView!
    @IBOutlet weak var cvSizes: UICollectionView!
    
    //MARK:-
    //MARK:- Variables
    
    var sizeIndex = Int()
    var colorIndex = Int()
    var arrAttributes = NSArray()
    var arrProductSize = NSArray()
    var arrProductColor = NSArray()
    
    var strColor = String()
    var strSize = String()
    var strShortDesc = String()
    
    //MARK:-
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpObject()
    }

    //MARK:-
    //MARK:- Set Up Object
    
    func SetUpObject() {
        if #available(iOS 11.0, *) {
            
        } else {
            constraintHeaderTop.constant = UIApplication.shared.statusBarFrame.size.height
        }
        SetUpValue()
        
        sizeIndex = -1
        colorIndex = -1
        
        self.vwPinCode.layer.borderColor = UIColor.black.cgColor
        self.vwPinCode.layer.borderWidth = 1.0
        
        self.btnCheck = THelper.setButtonTintColor(self.btnCheck, imageName: "icoCheck", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Secondary_Color1"))
        self.lblCheckAvailablity.text = LanguageLocal.myLocalizedString(key: "Check_Availablity")
        self.lblDeliveryBy.text = LanguageLocal.myLocalizedString(key: "Delivery_By")
        self.lblColors.text = LanguageLocal.myLocalizedString(key: "Colors")
        self.lblSize.text = LanguageLocal.myLocalizedString(key: "Size")
    }
    
    func SetUpValue() {
        lblDescription.text = strShortDesc.html2String
        if strColor == "" {
            lblColors.isHidden = true
            vwColors.isHidden = true
        }
        else {
            lblColors.isHidden = false
            vwColors.isHidden = false
        }
        
        if strSize == "" {
            lblSize.isHidden = true
            vwSizes.isHidden = true
        }
        else {
            lblSize.isHidden = false
            vwSizes.isHidden = false
        }
    }
    
    //MARK:-
    //MARK:- CollectionView Delegate & Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvColors {
            return arrProductColor.count
        }else {
             return arrProductSize.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cvColors {
             self.cvColors.register(UINib(nibName: "ColorViewCell", bundle: nil), forCellWithReuseIdentifier: "ColorViewCell")
            let cell = cvColors.dequeueReusableCell(withReuseIdentifier: "ColorViewCell", for: indexPath) as! ColorViewCell
            
            cell.lblColors.backgroundColor = UIColor(hexString: arrProductColor[indexPath.item] as! String, alpha: 1.0)
            if IPAD {
                 cell.lblColors.layer.cornerRadius = 20 / 2
                if colorIndex == indexPath.item {
                    cell.vwColor.backgroundColor = UIColor(hexString: arrProductColor[colorIndex] as! String, alpha: 1.0)
                    cell.vwColor.layer.cornerRadius = 40 / 2
                    cell.btnCheck.isHidden = false
                    cell.btnCheck.alpha = 1.0
                }else {
                    cell.vwColor.backgroundColor = UIColor.clear
                    cell.vwColor.layer.cornerRadius = 40 / 2
                    cell.btnCheck.isHidden = true
                    cell.btnCheck.alpha = 0.0
                }
            }else {
                 cell.lblColors.layer.cornerRadius = cell.lblColors.layer.frame.height / 2
                if colorIndex == indexPath.item {
                    cell.vwColor.backgroundColor = UIColor(hexString: arrProductColor[colorIndex] as! String, alpha: 1.0)
                    cell.vwColor.layer.cornerRadius = cell.vwColor.layer.frame.height / 2
                    cell.btnCheck.isHidden = false
                    cell.btnCheck.alpha = 1.0
                }else {
                    cell.vwColor.backgroundColor = UIColor.clear
                    cell.vwColor.layer.cornerRadius = cell.vwColor.layer.frame.height / 2
                    cell.btnCheck.isHidden = true
                    cell.btnCheck.alpha = 0.0
                }
            }
            return cell
        }else {
             self.cvSizes.register(UINib(nibName: "SizeViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeViewCell")
            let cell = cvSizes.dequeueReusableCell(withReuseIdentifier: "SizeViewCell", for: indexPath) as! SizeViewCell
            cell.lblSize.text = arrProductSize[indexPath.item] as? String
            if IPAD {
                if sizeIndex == indexPath.item {
                    cell.vwSize.backgroundColor = UIColor.primaryColor()
                    cell.lblSize.textColor = UIColor.white
                    cell.vwSize.layer.cornerRadius = 50 / 2
                } else {
                    cell.vwSize.backgroundColor = UIColor.clear
                    cell.lblSize.textColor = UIColor.black
                    cell.vwSize.layer.cornerRadius = 50 / 2
                }
            }else {
                if sizeIndex == indexPath.item {
                    cell.vwSize.backgroundColor = UIColor.primaryColor()
                    cell.lblSize.textColor = UIColor.white
                    cell.vwSize.layer.cornerRadius = cell.vwSize.layer.frame.height / 2
                } else {
                    cell.vwSize.backgroundColor = UIColor.clear
                    cell.lblSize.textColor = UIColor.black
                    cell.vwSize.layer.cornerRadius = cell.vwSize.layer.frame.height / 2
                }
            }
            
//            if sizeIndex == indexPath.item {
//                if IPAD {
//
//                }
//            }else {
//
//            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cvColors {
            colorIndex = indexPath.item
            
            NotificationCenter.default.post(name: NSNotification.Name("getColor"), object: self, userInfo: ["color":arrProductColor[colorIndex]])
            
            self.cvColors.reloadData()
        }else {
            sizeIndex = indexPath.item
            
            NotificationCenter.default.post(name: NSNotification.Name("getSize"), object: self, userInfo: ["size":arrProductSize[sizeIndex]])
            
            self.cvSizes.reloadData()
        }
    }
    
    //MARK:-
    //MARK:- UIButton Action Method
    
    @IBAction func btnReadMore_Clicked(_ sender: Any) {
//        if btnReadMore.isSelected == false {
//            self.btnReadMore.isSelected = true
//            self.btnRead.setTitle("Read Less", for: .normal)
//            self.imgUpDown.image = UIImage(named: "icoUp")
//            self.vwDescrHeight.constant = lblDescription.intrinsicContentSize.height
//        }else {
//            self.btnReadMore.isSelected = false
//            self.btnRead.setTitle("Read more", for: .normal)
//            self.imgUpDown.image = UIImage(named: "icoDropDown")
//            self.vwDescrHeight.constant = 120
//        }
    }
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
