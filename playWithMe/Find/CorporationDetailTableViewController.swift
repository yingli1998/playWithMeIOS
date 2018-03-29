//
//  CorporationDetailTableViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/15.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class CorporationDetailTableViewController: UITableViewController {
    @IBOutlet weak var corporationView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var addBT: UIButton!
    @IBOutlet weak var createrView: UIButton!
    @IBOutlet weak var creditLB: UILabel!
    @IBOutlet weak var detailTV: UITextView!
    @IBOutlet weak var numLB: UILabel!
    var corporation: Corporation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()

        UIButton.setButton(button: addBT)
        addBT.backgroundColor = UIColor(red: 30/255.0, green: 144/255.0, blue: 1.0, alpha: 1.0)
        
        createrView.layer.cornerRadius = 30.0
        createrView.layer.masksToBounds = true
        
        creditLB.layer.cornerRadius = 30.0
        creditLB.layer.masksToBounds = true
        
        loadData()
        
        backImageView.image = corporationView.image
        let  blurEffect = UIBlurEffect(style:UIBlurEffectStyle.light)
        let  blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(origin: backImageView.frame.origin, size: CGSize(width: self.view.bounds.width, height: self.backImageView.frame.height))
        backImageView.addSubview(blurEffectView)
    }
    
    //加载数据
    func loadData(){
        backImageView.image = UIImage(data: corporation.headImage!)
        nameLB.text = corporation.name
        if corporation.detail != nil {
            detailTV.text = corporation.detail
        }else{
            detailTV.text = "目前暂无介绍"
        }
        numLB.text = String(corporation.num)
        
        createrView.imageView?.image = UIImage(data: nameGetUser(username: corporation.creater).headImage!)
        creditLB.text = String(nameGetUser(username: corporation.creater).cedit)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func joinTo(_ sender: UIButton) {
    }

    @IBAction func chat(_ sender: Any) {
    }
    
    //转场传递数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUser"{
            let controller = segue.destination as! UserDetailTableViewController
            controller.user = nameGetUser(username: corporation.creater)
        }
    }
    
}
