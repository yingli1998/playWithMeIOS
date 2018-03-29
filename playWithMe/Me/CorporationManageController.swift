//
//  CorporationManageController.swift
//  playWithMe
//
//  Created by murray on 2018/3/21.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

private let reuseIdentifier = "corporManCell"

class CorporationManageController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        var imageView = UIImageView(image: UIImage(named: "LoginImage"))
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CorporationManageCell
        cell.setCardView(view: cell.backCardView)
        UIButton.setButton(button: cell.stateBT)
        cell.stateBT.backgroundColor = UIColor(red: 0/255, green: 205.0/255, blue: 102.0/255, alpha: 1.0)

    
        return cell
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
