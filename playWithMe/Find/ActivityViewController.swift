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
import Alamofire
import SwiftyJSON

class ActivityViewController: UITableViewController {
    var activities: [Activity] = []   //主页面的社团
    
    //返回是否包含这个活动, true为是, false为不是
    func checkActivity(activity: Activity) -> Bool{
        //列表中是否有
        for old_activity in self.activities{
            if old_activity.name == activity.name {
                return true
            }
        }
        //是否已经加入该活动
        let realm = try! Realm()
        let added_activity = realm.objects(Activity.self).filter("isAdd == true")
        for old_activity in added_activity {
            if old_activity.name == activity.name {
                return true
            }
        }
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            let url = base_url + "getActivity"
            let headers = getHeaders(login: true)
            let parameters: Parameters = ["username": getMeInfo().username]
            
            Alamofire.request(url, method: .post,  parameters: parameters,  headers: headers).responseJSON { (response) in
                let json = JSON(response.result.value!)
                if(json["status"].intValue == 0){
                    print(json)
                    if json["data"]["activity"].exists(){
                        for activity in json["data"]["activity"].arrayValue {
                            let new_activity = Activity()
                            
                            new_activity.name = activity["name"].stringValue
                            new_activity.detail = activity["detail"].stringValue
                            new_activity.num = activity["num"].intValue
                            new_activity.creater = activity["username"].stringValue
                            new_activity.date = activity["create_time"].stringValue
                            
                            let url = URL(string:  "http://47.106.122.58/" + activity["image"].string!)
                            let image = NSData(contentsOf: url!) as Data?
                            new_activity.image = image
                            
                            if !(self?.checkActivity(activity: new_activity))!{
                                self?.activities.append(new_activity)
                                self?.tableView.reloadData()
                            }
                        }
                    }
                }else{
                    let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
            
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

    }
    
    //每次进入界面,载入数据
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
//        return (activities?.count)!

        return activities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableViewCell
        let activity = activities[indexPath.row]
        
        cell.headImage.image = UIImage(data: activity.image!)
        cell.detailTV.text = activity.detail!
        cell.numberLB.text = String(activity.num)
        cell.usernameLB.text = activity.creater
        cell.timeLB.text = activity.date
        cell.nameLB.text = activity.name
        cell.addBT.tag = indexPath.row   //给cell设置tag
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
   
    @IBAction func joinIn(_ sender: UIButton) {
        let index = sender.tag
        let activity = activities[index]
        let url = base_url + "activity/1"
        let headers = getHeaders(login: true)
        var parameters: Parameters = ["name": activity.name]
        
        parameters["attender"] = getMeInfo().username
        
        Alamofire.request(url, method: .put,  parameters: parameters,  headers: headers).responseJSON { (response) in
            let json = JSON(response.result.value!)
            if(json["status"].intValue == 0){
                let realm = try! Realm()
                activity.isAdd = true
                activity.num += 1
                try! realm.write {
                    realm.add(activity)
                }
                //从列表中删除, 并重新载入数据
                self.activities.remove(at: index)
                self.tableView.reloadData()
                let alertController = UIAlertController(title: "成功", message: "加入成功", preferredStyle: .alert)
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
