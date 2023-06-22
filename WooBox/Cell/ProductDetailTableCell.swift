//
//  ProductDetailTableCell.swift
//  WooBox
//
//  Created by Goldenmace-E41 on 04/06/20.
//  Copyright © 2020 Goldenmace. All rights reserved.
//

import UIKit

class ProductDetailTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cvOption: UICollectionView!
    
    var arrAttirbutes = NSArray()
    var arrOption = NSArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNotification(_:)), name: NSNotification.Name("cvData"), object: nil)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        cvOption.collectionViewLayout = layout
    }
    
    // MARK: -
    // MARK: - Receive Notification
    
    @objc func receiveNotification(_ notification: Notification?) {
        if let aNotification = notification {
            print("\(aNotification)")
        }
        cvOption.delegate = self
        cvOption.dataSource = self
        cvOption.reloadData()
    }	

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOption.count
    }
       
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       self.cvOption.register(UINib(nibName: "AttributesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "AttributesCollectionCell")
        let cell = self.cvOption.dequeueReusableCell(withReuseIdentifier: "AttributesCollectionCell", for: indexPath) as! AttributesCollectionCell
        cell.lblTitle.text = "\(arrOption[indexPath.item])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.cvOption {
            let label = UILabel(frame: CGRect.zero)
            label.text = "\(arrOption[indexPath.item])"
            print(label.text ?? "")
            label.sizeToFit()
            return CGSize(width: 80, height: 30)
        }else {
             return CGSize(width: 0, height: 0)
        }
    }
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
