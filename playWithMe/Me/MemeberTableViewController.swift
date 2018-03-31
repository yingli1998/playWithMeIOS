//
//  MemeberTableViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/26.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift

class MemeberTableViewController: UITableViewController {
    var users: List<User>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60.0
        tableView.tableFooterView = UIView() 
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! MemeberTableViewCell
        
        let user = users[indexPath.row]
        cell.nameLB.text = user.username
        cell.creditLB.text = String(user.cedit)
        cell.headImage.image = UIImage(data: user.headImage!)

        return cell
    }
 
}
