//
//  MessageBoardController.swift
//  playWithMe
//
//  Created by murray on 2018/3/26.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class MessageBoardController: UITableViewController {

    @IBOutlet weak var toolB: UIToolbar!
    var activity: Activity!
    var messageBoards: [MessageBoard]? = []
    @IBOutlet weak var toolAddBT: UIBarButtonItem!
    @IBOutlet weak var editBT: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        tableView.rowHeight = 100.0
        toolB.barTintColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
        toolB.tintColor = UIColor(red: 0.0/255, green: 128.0/255, blue: 0.0/255, alpha: 1.0)
        
        tableView.tableFooterView = UIView() 
        
        let url = base_url + "message"
        let headers = getHeaders(login: true)
        let parameters: Parameters = ["name": activity.name]
        
        //如果加入活动
        if activity.isAdd == true && activity.state == true {
            toolAddBT.isEnabled = false
            editBT.isEnabled = true
        }else if activity.isAdd == false && activity.state == true {
            toolAddBT.isEnabled = true
            editBT.isEnabled = false
        }else {
            toolAddBT.isEnabled = false
            editBT.isEnabled = false
        }
        
        Alamofire.request(url, method: .post,  parameters: parameters,  headers: headers).responseJSON { (response) in
            let json = JSON(response.result.value!)
            if(json["status"].intValue == 0){
                if json["data"].arrayValue.isEmpty {
                    self.messageBoards = nil
                }else{
                    let messages = json["data"].arrayValue
                    for message in messages {
                        let messageBoard = MessageBoard()
                        messageBoard.username = message["username"].stringValue
                        messageBoard.date = message["create_time"].stringValue
                        messageBoard.content = message["message"].stringValue
                        let url = URL(string:  "http://47.106.122.58/" + message["image"].stringValue)
                        let image = NSData(contentsOf: url!) as Data?
                        messageBoard.image = image
                        self.messageBoards?.append(messageBoard)
                    }
                    self.tableView.reloadData()
                }
            }else{
                let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if messageBoards == nil {
            return 0
        }else{
            return messageBoards!.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let askCell = tableView.dequeueReusableCell(withIdentifier: "askCell", for: indexPath) as! AskCell

        let messageBoard = messageBoards![indexPath.row]
        askCell.contentLB.text = messageBoard.content
        askCell.nameLB.text = messageBoard.username
        askCell.timeLB.text = messageBoard.date
        askCell.imageBT.setImage(UIImage(data: messageBoard.image!)
, for: .normal)
        askCell.imageBT.setImage(UIImage(data: messageBoard.image!), for: .selected)

        return askCell
        
    }
    
    //加入活动
    @IBAction func joinIn(_ sender: Any) {
        let realm = try! Realm()
        let user = getMeInfo()
        try! realm.write {
            if !checkActivity(activity: activity){
                activity?.users.append(user)
                user.activity.append(activity)
            }
        }
        
        let alertController = UIAlertController(title: "成功加入社团", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //添加留言
    @IBAction func reply(_ sender: Any) {
        let alertController = UIAlertController(title: "留言",
                                                message: nil, preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "请写留言"
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            
            let url = base_url + "sendMess"
            let headers = getHeaders(login: true)
            var parameters = Parameters()
            
            parameters["username"] = getMeInfo().username
            parameters["activity"] = self.activity.name
            parameters["message"] = (alertController.textFields?.first?.text)!
            
            Alamofire.request(url, method: .post,  parameters: parameters,  headers: headers).responseJSON { (response) in
                let json = JSON(response.result.value!)
                if(json["status"].intValue == 0){
                    let realm = try! Realm()
                    let newMessageBoard = MessageBoard()
                    newMessageBoard.date = json["data"]["create_time"].stringValue
                    newMessageBoard.content = (alertController.textFields?.first?.text)!
                    newMessageBoard.username = getMeInfo().username
                    newMessageBoard.activity = self.activity.name
                    try! realm.write {
                        realm.add(newMessageBoard)
                    }
                    self.messageBoards?.append(newMessageBoard)
                    self.tableView.reloadData()
                    let alertController = UIAlertController(title: "成功", message: "留言创建成功", preferredStyle: .alert)
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
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //转场传递数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUser"{
            let index = tableView.indexPathForSelectedRow?.row
            let controller = segue.destination as! UserDetailTableViewController
            print(messageBoards![index!].username)
            controller.user = messageBoards![index!].username
        }
    }
}
