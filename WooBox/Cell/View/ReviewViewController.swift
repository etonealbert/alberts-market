//
//  ReviewViewController.swift

import UIKit

class ReviewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblReview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func SetUpObject() {
        self.tblReview.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    // mark: UITableview Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblReview.register(UINib.init(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell" )
        
        let cell = tblReview.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.tblReview.register(UINib.init(nibName: "ReviewHeaderViewCell", bundle: nil), forCellReuseIdentifier: "HeaderViewCell" )
        
        let cell = tblReview.dequeueReusableCell(withIdentifier: "HeaderViewCell") as! ReviewHeaderViewCell
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if IPAD {
//            return 100
//        }else {
//            return 70
//        }
//    }

}
