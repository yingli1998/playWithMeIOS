//
//  MessageTableViewController.swift
//  playWithMe
//
//  Created by Murray on 2018/2/25.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift
import DGElasticPullToRefresh

class MessageTableViewController: UITableViewController {
    var messageLists: Results<MessageList>? //记录消息列表

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息"
        self.tableView.rowHeight = 80
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //设置footerView
        self.tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1.0)
        
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
        
        reloadData()
        
    }
    
    func reloadData(){
        //给消息列表赋值
        let realm = try! Realm()
        let messages = realm.objects(MessageList.self).sorted(byKeyPath: "date", ascending: false)
        messageLists = messages
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //更新消息
        reloadData()
        tableView.reloadData()
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
        if messageLists == nil {
            return 0
        }else{
            return messageLists!.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! MessageTableViewCell
        let index = indexPath.row
        
        //传递显示的信息
        let user = nameGetUser(username: messageLists![index].username)
        
        cell.nameLB.text = user.username
        cell.headImage.image = UIImage(data: (user.headImage)!)
        cell.MessageLB.text = messageLists![index].message
        cell.timeLB.text = showDate(date: messageLists![index].date)

        return cell
    }
    
    //转场传递数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChatView"{
            let index = tableView.indexPathForSelectedRow?.row
            let controller = segue.destination as! ChatViewController
            controller.you = messageLists![index!].username 
        }
    }

}
