//
//  RunningActivityController.swift
//  playWithMe
//
//  Created by murray on 2018/3/21.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift

class RunningActivityController: UITableViewController {
    var activities: Results<Activity>!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateData()
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
        return activities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "runningCell", for: indexPath) as! RuningActivityCell
        cell.setCardView(view: cell.backImageView)
        
        let activity = activities[indexPath.row]
        cell.activityLB.text = activity.name
        cell.numLB.text = String(activity.num)
        cell.timeLB.text = showDate(date: activity.date)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    

}
