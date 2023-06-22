//
//  WalkThroughViewController.swift

import UIKit
import AnimatedCollectionViewLayout

class WalkThroughViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:-
    //MARK:- Outlets
    
    @IBOutlet weak var constraintHeightArea: NSLayoutConstraint!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var btnStartToShop: UIButton!
    
    @IBOutlet weak var lblWoobox: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    
    @IBOutlet weak var cvWalkThrough: UICollectionView!
    
    let arrHeading = ["Hi, We're Woobox!", "Most Unique Styles!", "Shop Till You Drop!"]
    let arrSubHeading = ["We make around your city Affordable, easy and efficient.", "Shop the most trending fashion on the biggest shopping website.", "Grab the best seller pieces at bargain prices."]
    let arrImg = ["walkThrough","walkThrough2","walkThrough3"]
    
    //MARK:-
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpValue()
    }
    
    //MARK: -
    //MARK: - SetUpView
    
    func SetUpValue() {
        if #available(iOS 11.0, *) {
        } else {
            self.constraintHeightArea.constant = UIApplication.shared.statusBarFrame.size.height
        }
        
        self.lblMsg.text = LanguageLocal.myLocalizedString(key: "WooBox_SubTitle")
        self.lblWoobox.text = LanguageLocal.myLocalizedString(key: "WooBox_Title")
        self.btnStartToShop.setTitle(LanguageLocal.myLocalizedString(key: "Start_Shopping"), for: .normal)
        
        let layout = AnimatedCollectionViewLayout()
        layout.animator = ZoomInOutAttributesAnimator()
        layout.scrollDirection = .horizontal
        cvWalkThrough.collectionViewLayout = layout
        
        pageControl.currentPageIndicatorTintColor = .primaryColor()
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    //MARK: -
    //MARK: -UICollectionView Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cvWalkThrough.register(UINib(nibName: "WalkThroughCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        let cell = cvWalkThrough.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WalkThroughCollectionCell
        cell.imgWalkThrough.image = UIImage (named: arrImg[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cvWalkThrough.frame.width, height: cvWalkThrough.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
        
        lblWoobox.text = arrHeading[indexPath.item]
        lblMsg.text = arrSubHeading[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cvWalkThrough.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = indexPath.row
    }
    
    //MARK:-
    //MARK:- UIPageControl Action Method
    
    @IBAction func pageControl_Clicked(_ sender: UIPageControl) {
        let page: Int = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        cvWalkThrough.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //MARK:-
    //MARK:- UIButton Action Method
    
    @IBAction func btnStartToShop_Clicked(_ sender: Any) {
        TPreferences.writeBoolean(WALKTHROUGH, value: true)
        let vc = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignIn_Clicked(_ sender: Any) {
        TPreferences.writeBoolean(WALKTHROUGH, value: true)
        let vc = signInViewController(nibName: "signInViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
