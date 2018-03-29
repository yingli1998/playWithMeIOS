//
//  CorporationTableViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/14.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import RealmSwift

class CorporationViewController: UITableViewController {
    
    var corporations: Results<Corporation>?    //主页面的社团

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        
        //下拉刷新
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        //更新数据
        updateData()
    }
    
    //更新数据
    func updateData(){
        let realm = try! Realm()
        corporations = realm.objects(Corporation.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        //给单元格各项赋值
        let corporation = corporations![indexPath.row]
        cell.corporationName.text = corporation.name
        cell.corporationView.image = UIImage(data: corporation.headImage!)
        cell.detailLB.text = corporation.sign
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //从数据库中删除某个社团的信息
        if editingStyle == .delete {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(corporations![indexPath.row])
            }
            updateData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
