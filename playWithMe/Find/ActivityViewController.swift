//
//  ActivityViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/14.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import RealmSwift

class ActivityViewController: UITableViewController {
    var activities: Results<Activity>?    //主页面的社团

    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    //每次进入界面,载入数据
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
        let realm = try! Realm()
        activities = realm.objects(Activity.self)
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
        return (activities?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableViewCell
        let activity = activities![indexPath.row]
        
        cell.headImage.image = UIImage(data: nameGetUser(username: activity.creater).headImage!)
        
        if activity.detail == nil {
            cell.detailTV.text = "暂无简介"
        }else{
            cell.detailTV.text = activity.detail
        }
        
        cell.numberLB.text = String(activity.num)
        cell.usernameLB.text = activity.name
        cell.timeLB.text = showDate(date: activity.date)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    

}
