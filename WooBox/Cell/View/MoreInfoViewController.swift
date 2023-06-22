//
//  MoreInfoViewController.swift

import UIKit
import Alamofire
import OAuthSwiftAlamofire
import Cosmos


class MoreInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblMoreInfo: UITableView!    
    @IBOutlet weak var constraintTableHeight: NSLayoutConstraint!
    
    var arrKey = NSArray()
    var dicMoreInfo = NSDictionary()
    var arrProduct = NSArray()
    var arrMoreInfo = NSArray()
    var arrBrand = NSArray()
    var strBrand = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.SetUpObject()
    }
    
    func SetUpObject() {
        tblMoreInfo.tableFooterView = UIView(frame: .zero)
        tblMoreInfo.separatorStyle = UITableViewCell.SeparatorStyle.none
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNotification(_:)), name: NSNotification.Name("More Info"), object: nil)
    }
    
    // MARK: -
    // MARK: - UITableview Delegate Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrKey.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblMoreInfo.register(UINib.init(nibName: "moreInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "moreInfoViewCell" )
        
        let cell = tblMoreInfo.dequeueReusableCell(withIdentifier: "moreInfoViewCell", for: indexPath) as! moreInfoTableViewCell
        
        if indexPath.row >= arrKey.count {
            cell.lblValue.text = strBrand
            cell.lblKey.text = "Brand"
        }
        else {
            cell.lblValue.text = "\(arrMoreInfo[indexPath.row]) cm"
            cell.lblKey.text = "\(arrKey[indexPath.row])"
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD {
            self.constraintTableHeight.constant = CGFloat(((arrKey.count + 1) * 80))
            return 80
        }else {
            self.constraintTableHeight.constant = CGFloat(((arrKey.count + 1) * 70))
            return 70
        }
    }
    
    
    // MARK: -
    // MARK: - Receive Notification
    
    @objc func receiveNotification(_ notification: Notification?) {
        if let aNotification = notification {
            print("\(aNotification)")
        }
        
        dicMoreInfo = notification?.userInfo?["dicMoreInfo"] as! NSDictionary
        arrBrand = notification?.userInfo?["Brand"] as! NSArray
        if arrBrand.count > 0 {
            strBrand = arrBrand.componentsJoined(by: ", ")
        }
        else {
            strBrand = ""
        }
        
        self.arrMoreInfo = dicMoreInfo.allValues as NSArray
        arrKey = dicMoreInfo.allKeys as NSArray
        tblMoreInfo.reloadData()
    }
}
