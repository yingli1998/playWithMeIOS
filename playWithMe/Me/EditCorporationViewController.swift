//
//  EditCorporationViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/28.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class EditCorporationViewController: UITableViewController {
    @IBOutlet weak var nameFT: UITextField!
    @IBOutlet weak var detailTV: UITextView!
    @IBOutlet weak var saveBT: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIButton.setButton(button: saveBT)
        saveBT.backgroundColor = UIColor.white
        saveBT.layer.cornerRadius = 15.0
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(_ sender: Any) {
    }
    // MARK: - Table view data source

}
