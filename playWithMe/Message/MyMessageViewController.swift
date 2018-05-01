//
//  MyMessageViewController.swift
//  playWithMe
//
//  Created by murray on 2018/4/26.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class MyMessageViewController: UITableViewController {
    var myMessages: [MessageBoard]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的留言"
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 120
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let url = base_url + "user/1"
        let headers = getHeaders(login: true)
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            let json = JSON(response.result.value!)
            if(json["status"].intValue == 0){
                
                //存入用户本地的留言
                if(json["data"]["messages"].exists()){
                    let messages = json["data"]["messages"].arrayValue
                    print(messages)
                    for message in messages {
                        let new_message = MessageBoard()
                        new_message.username = getMeInfo().username
                        new_message.content = message["message"].stringValue
                        new_message.date = message["create_time"].stringValue
                        new_message.activity = message["activity"].stringValue
                        
                        print(new_message.activity)
                        print(nameGetActivity(name: new_message.activity))
                        
                        self.myMessages?.append(new_message)
                        self.tableView.reloadData()
                    }
                }
            }else{
                let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
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
        if myMessages == nil {
            return 0
        }else{
            return (myMessages?.count)!
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MyMessageViewCell
        
        let message = myMessages![indexPath.row]
        
        cell.contentLB.text = message.content
        cell.nameLB.text = message.activity
        cell.timeLB.text = message.date
        cell.backView.setCardView(view: cell.backView)
        
        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessageBoard"{
            let index = tableView.indexPathForSelectedRow?.row
            let controller = segue.destination as! MessageBoardController
            print("shjabjsdnjkanmkmd")
            let activity = nameGetActivity(name: myMessages![index!].activity)
            print(activity)
            controller.activity = nameGetActivity(name: myMessages![index!].activity)
        }
    }
 

}
