//
//  MessageBoardController.swift
//  playWithMe
//
//  Created by murray on 2018/3/26.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift

class MessageBoardController: UITableViewController {

    @IBOutlet weak var toolB: UIToolbar!
    var activity: Activity!
    var messageBoards: Results<MessageBoard>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100.0
        toolB.barTintColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
        toolB.tintColor = UIColor(red: 0.0/255, green: 128.0/255, blue: 0.0/255, alpha: 1.0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
    }
    
    func loadData(){
        let realm = try! Realm()
        messageBoards = realm.objects(MessageBoard.self).filter("activity == %@", activity)
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
        askCell.timeLB.text = showDate(date: messageBoard.date)
        askCell.imageBT.setImage(UIImage(data: nameGetUser(username: messageBoard.username).headImage!)
, for: .normal)
        askCell.imageBT.setImage(UIImage(data: nameGetUser(username: messageBoard.username).headImage!), for: .selected)

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
            let realm = try! Realm()
            let newMessageBoard = MessageBoard()
            newMessageBoard.date = Date()
            newMessageBoard.content = (alertController.textFields?.first?.text)!
            newMessageBoard.username = getMeInfo().username
            newMessageBoard.activity = self.activity
            try! realm.write {
                realm.add(newMessageBoard)
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
            controller.user = nameGetUser(username: messageBoards![index!].username)
        }
    }
}
