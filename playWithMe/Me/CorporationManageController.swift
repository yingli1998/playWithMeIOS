//
//  CorporationManageController.swift
//  playWithMe
//
//  Created by murray on 2018/3/21.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "corporManCell"

class CorporationManageController: UICollectionViewController {
    
    var corporations: List<Corporation>?
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func updateData(){
        user = getMeInfo()
        corporations = user.manageCorporation
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if corporations == nil {
            return 0
        }else{
            return corporations!.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CorporationManageCell
        cell.setCardView(view: cell.backCardView)
        UIButton.setButton(button: cell.stateBT)
        cell.stateBT.backgroundColor = UIColor(red: 0/255, green: 205.0/255, blue: 102.0/255, alpha: 1.0)

        let corporation = corporations![indexPath.row]
        cell.nameLB.text = corporation.name
        cell.numLB.text = String(corporation.num)
        cell.corporationImage.image = UIImage(data: corporation.headImage!)
        
        if corporation.state {
            cell.stateBT.setTitle("运行中", for: .normal)
            cell.stateBT.setTitle("运行中", for: .selected)
        }else{
            cell.stateBT.setTitle("待审核", for: .normal)
            cell.stateBT.setTitle("待审核", for: .selected)
        }
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let controller = segue.destination as! CorporationDetailViewController
            let index = collectionView?.indexPathsForSelectedItems?.first?.row
            controller.corporation = corporations![index!]
        }
    }
}


extension CorporationManageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewSize = collectionView.frame.size
        let collectionViewArea = Double(collectionViewSize.width * collectionViewSize.height)
        
        let sideSize: Double = sqrt(collectionViewArea / 8.5)
        
        return CGSize(width: sideSize, height: sideSize)
    }
}
