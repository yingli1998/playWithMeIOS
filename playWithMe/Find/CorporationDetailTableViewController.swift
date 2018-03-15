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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        backImageView.image = corporationView.image
        let  blurEffect = UIBlurEffect(style:UIBlurEffectStyle.light)
        let  blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(origin: backImageView.frame.origin, size: CGSize(width: self.view.bounds.width, height: self.backImageView.frame.height))
        backImageView.addSubview(blurEffectView)

//        backImageView.image =  getBlur(image: corporationView.image!)
        UIButton.setButton(button: addBT)
        addBT.backgroundColor = UIColor(red: 30/255.0, green: 144/255.0, blue: 1.0, alpha: 1.0)
        
        createrView.layer.cornerRadius = 30.0
        createrView.layer.masksToBounds = true
        
        creditLB.layer.cornerRadius = 30.0
        creditLB.layer.masksToBounds = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func joinTo(_ sender: UIButton) {
    }


}
