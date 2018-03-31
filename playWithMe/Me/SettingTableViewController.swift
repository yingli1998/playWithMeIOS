//
//  SettingTableViewController.swift
//  playWithMe
//
//  Created by Murray on 2018/2/26.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var LogOutBT: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        self.tabBarController?.tabBar.isHidden = true
        
        UIButton.setButton(button: LogOutBT)
        LogOutBT.backgroundColor = UIColor.red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LogOut(_ sender: UIButton) {
        let alertController = UIAlertController(title: "退出登录", message: "你确定退出登录吗", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let logOutAction = UIAlertAction(title: "确定", style: .default){  action in
            print("退出登录")
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let loginController = sb.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            self.present(loginController, animated: true, completion: nil)
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(logOutAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
