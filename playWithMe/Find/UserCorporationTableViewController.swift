//
//  UserCorporationTableViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/20.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import RealmSwift

class UserCorporationTableViewController: UITableViewController {
    var corporations: List<Corporation>!   //该用户参加的社团
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
    }
    
    //每次进入界面,更新数据
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    //更新数据
    func updateData(){
        corporations = user.attendCorporation
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (corporations?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "corporCell", for: indexPath) as! CorporationTableViewCell
        cell.setCardView(view: cell.backView)
        
        let corporation = corporations[indexPath.row]
        cell.corporationName.text = corporation.name
        cell.corporationView.image = UIImage(data: corporation.headImage!)
        cell.detailLB.text = corporation.sign
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //转场传递数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "corporationDetail"{
            let index = tableView.indexPathForSelectedRow?.row
            let controller = segue.destination as! CorporationDetailTableViewController
            controller.corporation = corporations![index!]
        }
    }
    

}
