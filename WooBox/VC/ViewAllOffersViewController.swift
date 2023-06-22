//
//  ViewAllOffersViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire

class ViewAllOffersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var constraintHeaderTop: NSLayoutConstraint!
    
    @IBOutlet weak var cvOffers: UICollectionView!
    
    var arrProducts = NSMutableArray()
    var page = Int()
    var totalPage = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpObject()
    }
    
    //MARK: -
    //MARK: - Set Up Object
    
    func setUpObject() {
        if #available(iOS 11.0, *) {
            
        } else {
            constraintHeaderTop.constant = UIApplication.shared.statusBarFrame.size.height
        }
        page = 1
        getOffersAPI(pageNo: page)
    }
    
    //MARK: -
    //MARK: - UICollectionView Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cvOffers.register(UINib(nibName: "OfferCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "offerCell")
        let cell = cvOffers.dequeueReusableCell(withReuseIdentifier: "offerCell", for: indexPath) as! OfferCollectionViewCell
        
        let dicProduct:NSDictionary = arrProducts[indexPath.item] as! NSDictionary
        
        cell.lblProductName.text = "\(dicProduct.value(forKey: "name") ?? "")"
        cell.lblOffer.text = "\(PRICE_SIGN)\(dicProduct.value(forKey: "price") ?? "")"
        
        THelper.setImage(img: cell.imgProduct, url: URL(string: dicProduct.value(forKey: FULL) as! String)!, placeholderImage: "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item >= arrProducts.count - 1 {
            page = page + 1
            if page > totalPage {}
            else {
                getOffersAPI(pageNo: page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if IPAD {
            return CGSize(width: (cvOffers.frame.width / 2) - 24, height: 280)
        }else {
            return CGSize(width: (cvOffers.frame.width / 2) - 16, height: 220)
        }
    }

    //MARK: -
    //MARK: - UIButton Action Method
    
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:-
    //MARK:- API Calling
        
    func getOffersAPI(pageNo: Int) {
        THelper.ShowProgress(vc: self)
        
        let param = ["page":pageNo
            ] as [String : Any]
        print(param)
        
        let sessionManager = SessionManager.default
        sessionManager.adapter = OAuthSwiftRequestAdapter(THelper.oauthSwift())
        
        sessionManager.request(TPreferences.getCommonURL(NEW_GET_OFFER)!,method: .post, parameters: param, encoding: JSONEncoding.default,headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                THelper.hideProgress(vc: self)
                if let data = response.result.value{
                    if response.response?.statusCode == 200 {
                        print(data)
                        let arrtemp = NSMutableArray()
                        arrtemp.add(data)
                        let arrTempProduct:NSArray = arrtemp[0] as! NSArray
                        var dicProduct = NSDictionary()
                        
                        for i in 0..<arrTempProduct.count {
                            dicProduct = arrTempProduct[i] as! NSDictionary
                            self.totalPage = dicProduct.value(forKey: NO_OF_PAGES) as! Int
                            self.arrProducts.add(dicProduct)
                        }
                        self.cvOffers.reloadData()
                    }
                    else {
                        print(data)
                        let dicError:NSDictionary = data as! NSDictionary
                        let str:String = dicError.value(forKey: "message") as! String
                        THelper.toast(str.html2String, vc: self)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                break
                
            case .failure(_):
                THelper.hideProgress(vc: self)
                THelper.toast(ERROR_MSG, vc: self)
                print(response.result.error?.localizedDescription ?? "Something went wrong")
//                THelper.toast(response.result.error?.localizedDescription ?? "Something went wrong", vc: self)
                self.navigationController?.popViewController(animated: true)
                break
            }
        }
    }
}
