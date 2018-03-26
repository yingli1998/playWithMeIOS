//
//  MessageBoardController.swift
//  playWithMe
//
//  Created by murray on 2018/3/26.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class MessageBoardController: UITableViewController {

    @IBOutlet weak var toolB: UIToolbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100.0
        toolB.barTintColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
        toolB.tintColor = UIColor(red: 0.0/255, green: 128.0/255, blue: 0.0/255, alpha: 1.0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let askCell = tableView.dequeueReusableCell(withIdentifier: "askCell", for: indexPath) as! AskCell

        let replyCell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! ReplyCell
        
        if(indexPath.row % 2 == 0){
            return askCell
        }else{
            return replyCell
        }

    }
    
    @IBAction func joinIn(_ sender: Any) {
    }
    
    @IBAction func reply(_ sender: Any) {
    }
}
