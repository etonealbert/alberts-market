//
//  SplashViewController.swift

import UIKit
import SwiftGifOrigin

class SplashViewController: UIViewController {

    //MARK:-
    //MARK:- Outlet
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblWooBox: UILabel!
    
    //MARK:-
    //MARK:- Variables
    
    var timer: Timer!
    
    //MARK:-
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.updateView), userInfo: nil, repeats: true)
    }
    
    //MARK:-
    //MARK:- SetUpObject Method
    
    func setUpObject() {
//        lblWooBox.text = LanguageLocal.myLocalizedString(key: "WooBox")
    }
    
    //MARK:-
    //MARK:- UpdateView Method
    
    @objc func updateView(){
        timer.invalidate()
        let vc = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
