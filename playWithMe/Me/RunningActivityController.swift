//
//  RunningActivityController.swift
//  playWithMe
//
//  Created by murray on 2018/3/21.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import DGElasticPullToRefresh

class RunningActivityController: UITableViewController {
    var activities: Results<Activity>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        var update_activities: [Activity] = []
        
        updateData()
        
        //遍历所有没有完成的活动, 只要本人不是管理者, 则更新下这个活动的状态, 本人是管理者, 则更新人数
        for activity in activities {
            update_activities.append(activity)
        }
        
        //下拉刷新, 更新状态
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            //设置参数
            let url = base_url + "activity"
            let headers = getHeaders(login: true)
            var parameters = Parameters()
            
            //更新所有待更新的活动
            for activity in update_activities {
                parameters["name"] = activity.name
                
                //拉取信息
                Alamofire.request(url, method: .post,  parameters: parameters,  headers: headers).responseJSON { (response) in
                    let json = JSON(response.result.value!)
                    print(json)
                    if(json["status"].intValue == 0){
                        let realm = try! Realm()
                        try! realm.write {
                            //如果活动显示已经完成
                            if json["data"]["status"] == 1 {
                                activity.state = false
                            }
                            //更新活动的人数
                            activity.num = json["data"]["count"].intValue
                        }
                        self?.updateData()
                        self?.tableView.reloadData()
                    }else{
                        let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                        alertController.addAction(alertAction)
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }

    override func viewWillAppear(_ animated: Bool) {
        updateData()
        tableView.reloadData()
    }
    
    //更新数据
    func updateData(){
        let realm = try! Realm()
        activities = realm.objects(Activity.self).filter("state == %@", true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if activities != nil{
            return activities.count
        }else{
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "runningCell", for: indexPath) as! RuningActivityCell
        cell.setCardView(view: cell.backImageView)
        
        let activity = activities[indexPath.row]
        cell.activityLB.text = activity.name
        cell.numLB.text = String(activity.num)
        cell.timeLB.text = activity.date
        cell.finishBT.tag = indexPath.row
        
        if activity.isManage == true {
            cell.finishBT.isHidden = false
        }else{
            cell.finishBT.isHidden = true
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    @IBAction func finish(_ sender: UIButton) {
        let index = sender.tag
        let activity = activities[index]
        let url = base_url + "activity/1"
        let headers = getHeaders(login: true)
        var parameters: Parameters = ["name": activity.name]
        parameters["status"] = 1
        
        Alamofire.request(url, method: .put,  parameters: parameters,  headers: headers).responseJSON { (response) in
            let json = JSON(response.result.value!)
            if(json["status"].intValue == 0){
                //本地的状态改变
                let realm = try! Realm()
                try! realm.write {
                    activity.state = false
                }
                self.tableView.reloadData()
                let alertController = UIAlertController(title: "完成", message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessageBoard"{
            let index = tableView.indexPathForSelectedRow?.row
            let controller = segue.destination as! MessageBoardController
            controller.activity = activities[index!]
        }
    }
    
}
