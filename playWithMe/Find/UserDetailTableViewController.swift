//
//  UserDetailTableViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/20.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class UserDetailTableViewController: UITableViewController {
    @IBOutlet weak var backViewImage: UIImageView!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var signLB: UILabel!
    
    @IBOutlet weak var messageBT: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        backViewImage.image = headImage.image
        let  blurEffect = UIBlurEffect(style:UIBlurEffectStyle.regular)
        let  blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(origin: backViewImage.frame.origin, size: CGSize(width: self.view.bounds.width, height: backViewImage.frame.height))
        backViewImage.addSubview(blurEffectView)
        
        UIButton.setButton(button: messageBT)
        messageBT.backgroundColor = UIColor(red: 0.0/255, green: 128.0/255, blue: 0.0/255, alpha: 1.0)
        messageBT.titleLabel?.textColor = UIColor.white
        
        headImage.layer.cornerRadius = 40.0
        headImage.layer.masksToBounds = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func sendMessage(_ sender: Any) {
        
    }

}
