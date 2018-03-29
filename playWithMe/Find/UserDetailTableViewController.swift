//
//  UserDetailTableViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/20.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class UserDetailTableViewController: UITableViewController {
    @IBOutlet weak var backViewImage: UIImageView!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var signLB: UILabel!
    var user: User!
    
    @IBOutlet weak var messageBT: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        UIButton.setButton(button: messageBT)
        messageBT.backgroundColor = UIColor(red: 0.0/255, green: 128.0/255, blue: 0.0/255, alpha: 1.0)
        messageBT.titleLabel?.textColor = UIColor.white
        headImage.layer.cornerRadius = 40.0
        headImage.layer.masksToBounds = true
        
        loadData()
        
        backViewImage.image = headImage.image
        let  blurEffect = UIBlurEffect(style:UIBlurEffectStyle.regular)
        let  blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(origin: backViewImage.frame.origin, size: CGSize(width: self.view.bounds.width, height: backViewImage.frame.height))
        backViewImage.addSubview(blurEffectView)
        
    }
    
    func loadData(){
        self.headImage.image = UIImage(data: user.headImage!)
        self.usernameLB.text = user.username
        self.signLB.text = user.signature
    }

    //转场传递数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendMessage"{
            let controller = segue.destination as! ChatViewController
            controller.you = user.username
            createNewMessage(receiver: user.username) //创建新的消息列表
        }
    }
}
