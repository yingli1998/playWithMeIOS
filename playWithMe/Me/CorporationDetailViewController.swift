//
//  CorporationDetailViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/26.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift

class CorporationDetailViewController: UITableViewController {
    @IBOutlet weak var editBT: UIButton!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var createrImage: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var numLB: UILabel!
    @IBOutlet weak var corporationImage: UIImageView!
    
    var corporation: Corporation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //界面设计
        tableView.tableFooterView = UIView()
        UIButton.setButton(button: editBT)
        editBT.backgroundColor = UIColor.white
        editBT.layer.cornerRadius = 15.0
    }
    
    //每次进入界面更新数据
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    //更新数据
    func updateData(){
        if corporation.detail == nil {
            detail.text = "暂无简介"
        }else{
            detail.text = corporation.detail
        }
        
        createrImage.image = UIImage(data: nameGetUser(username: corporation.creater).headImage!)
        nameLB.text = corporation.name
        let num = String(corporation.num)
        numLB.text = num
        corporationImage.image = UIImage(data: corporation.headImage!)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMember"{
            let controller = segue.destination as! MemeberTableViewController
            controller.users = corporation.users
        }else if segue.identifier == "editCorporation"{
            let controller = segue.destination as! EditCorporationViewController
            controller.corporation = corporation
        }
    }


}
