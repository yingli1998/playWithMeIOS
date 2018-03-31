//
//  CorporationTableViewCell.swift
//  playWithMe
//
//  Created by murray on 2018/3/14.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift



class CorporationTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var corporationView: UIImageView!
    @IBOutlet weak var corporationName: UILabel!
    @IBOutlet weak var detailLB: UILabel!
    @IBOutlet weak var addBT: UIButton!
    
    override func awakeFromNib() {
        setCardView(view: backView)
        backView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue:240/255.0 , alpha: 1.0)
        UIButton.setButton(button: addBT)
        addBT.backgroundColor = UIColor(red: 30/255.0, green: 144/255.0, blue: 1.0, alpha: 1.0)

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //加入社团
    @IBAction func joinIn(_ sender: Any) {
        print("加入社团")
        let user = getMeInfo()
        let corporation = nameGetCorporation(name: corporationName.text!)
        let realm = try! Realm()
        try! realm.write {
            //如果用户没有加入该社团, 则加入
            if !checkCorporation(corporation: corporation){
                user.attendCorporation.append(corporation)
                corporation.users.append(user)
            }
        }
    }

}
