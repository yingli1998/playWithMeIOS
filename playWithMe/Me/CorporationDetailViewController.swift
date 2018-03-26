//
//  CorporationDetailViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/26.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class CorporationDetailViewController: UITableViewController {

    @IBOutlet weak var editBT: UIButton!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var createrImage: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var numLB: UILabel!
    @IBOutlet weak var corporationImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        UIButton.setButton(button: editBT)
        editBT.backgroundColor = UIColor.white
        editBT.layer.cornerRadius = 15.0

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
