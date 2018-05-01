//
//  FinishTableViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/20.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift
import PopupDialog
import Alamofire
import SwiftyJSON
import DGElasticPullToRefresh

class FinishTableViewController: UITableViewController {
    var activities: Results<Activity>!
    var rate: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //下拉刷新, 更新现在已经完成的活动
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.updateData()
            self?.tableView.reloadData()
            self?.tableView.dg_stopLoading()
        }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
        tableView.reloadData()
    }
    
    func updateData(){
        let realm = try! Realm()
        activities = realm.objects(Activity.self).filter("state == %@", false)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "finishCell", for: indexPath) as! FinishTableViewCell
        cell.setCardView(view: cell.backCardView)
        
        let activity = activities[indexPath.row]
        cell.activityLB.text = activity.name
        cell.numLB.text = String(activity.num)
        cell.timeLB.text = activity.date
        cell.rateBT.tag = indexPath.row
        
        if activity.isManage == true {
            cell.rateBT.isHidden = true
        }else if activity.isCredited == true {
            cell.rateBT.isHidden = true
        }else {
            cell.rateBT.isHidden = false
        }

        return cell
    }

    //评价
    @IBAction func rate(_ sender: UIButton) {
        //需要上传的信息
        let index = sender.tag
        let activity = activities[index]
        
        // Create a custom view controller
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            //            self.label.text = "You canceled the rating dialog"
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "RATE", height: 60) {
            if ratingVC.cosmosStarRating.rating <= 1.0 {
                self.rate = 20
            }else if ratingVC.cosmosStarRating.rating <= 2.0 {
                self.rate = 40
            }else if ratingVC.cosmosStarRating.rating <= 3.0 {
                self.rate = 60
            }else if ratingVC.cosmosStarRating.rating <= 4.0 {
                self.rate = 80
            }else {
                self.rate = 100
            }
            
            let url = base_url + "activity/1"
            let headers = getHeaders(login: true)
            var parameters: Parameters = ["name": activity.name]
            parameters["credit"] = self.rate
            
            Alamofire.request(url, method: .put,  parameters: parameters,  headers: headers).responseJSON { (response) in
                let json = JSON(response.result.value!)
                print(json)
                if(json["status"].intValue == 0){
                    //本地的状态改变
                    let realm = try! Realm()
                    try! realm.write {
                        activity.isCredited = true  //表示用户已经评价过这个活动了
                    }
                    self.updateData()
                    self.tableView.reloadData()
                }else{
                    let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
            
        // Present dialog
        present(popup, animated: true, completion: nil)
        
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessageBoard"{
            let index = tableView.indexPathForSelectedRow?.row
            let controller = segue.destination as! MessageBoardController
            controller.activity = activities[index!]
        }
    }
}
