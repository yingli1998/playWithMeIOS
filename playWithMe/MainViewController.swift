//
//  MainViewController.swift
//  playWithMe
//
//  Created by Murray on 2018/2/23.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = UIColor(red: 0.0/255, green: 128.0/255, blue: 0.0/255, alpha: 1.0)
                
        //第一次进行app拉取数据
        if (!(UserDefaults.standard.bool(forKey: "firstLogin"))) { //第一次进入主界面, 拉取用户相关的信息
            UserDefaults.standard.set(true, forKey:"firstLogin")
            
            let url = base_url + "user/1"
            let headers = getHeaders(login: true)
            
            Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
                let json = JSON(response.result.value!)
                if(json["status"].intValue == 0){
                    let user = getMeInfo()
                    let realm = try! Realm()
                    var sign = ""
                    var headImage: Data? = nil
                    
                    if json["data"]["signature"].string! != "" {
                        sign = json["data"]["signature"].string!
                    }
                    
                    if (json["data"]["image"].null == nil) {
                        let url = URL(string:  "http://47.106.122.58/" + json["data"]["image"].string!)
                        let image = NSData(contentsOf: url!) as Data?
                        headImage = image!
                    }
                    
                    //如果用户有管理的社团
                    if (json["data"]["manage_corps"].exists()){
                        let manage_corps = json["data"]["manage_corps"].arrayValue
                        for manage_corp in manage_corps {
                            let corp = Corporation()
                            corp.isAdd = true
                            corp.isManage = true
                            corp.name = manage_corp["name"].stringValue
                            corp.num = manage_corp["count"].intValue
                            corp.creater = user.username
                            corp.sign = manage_corp["sign"].stringValue
                            print(manage_corp["image"].stringValue)
                            let url = URL(string:  "http://47.106.122.58/" + manage_corp["image"].stringValue)
                            print(url!)
                            let image = NSData(contentsOf: url!) as Data?
                            corp.headImage = image!
                
                            if(json["data"]["introduce"].null == nil){
                                corp.detail = manage_corp["introduce"].stringValue
                            }
                                try! realm.write {
                                realm.add(corp)
                                user.corporation.append(corp)
                            }
                        }
                    }
                    
                    //存入用户加入的社团
                    if(json["data"]["attend_corps"].exists()){
                        let attend_corps = json["data"]["attend_corps"].arrayValue
                        print(attend_corps)
                        for attend_corp in attend_corps {
                            let corp = Corporation()
                            corp.name = attend_corp["name"].stringValue
                            corp.sign = attend_corp["sign"].stringValue
                            corp.num = attend_corp["count"].intValue
                            if !checkCorporation(corporation: corp){ //如果此时的列表没有这个社团, 添加入这个社团
                                let url = URL(string:  "http://47.106.122.58/" + attend_corp["image"].stringValue)
                                let image = NSData(contentsOf: url!) as Data?
                                corp.headImage = image!
                                corp.isAdd = true 
                                try! realm.write {
                                    realm.add(corp)
                                    user.corporation.append(corp)
                                }
                            }
                        }
                    }
                    
                    //存入活动信息
                    if(json["data"]["activity"].exists()){
                        let activities = json["data"]["activity"].arrayValue
                        for activity in activities {
                            let new_activity = Activity()
                            new_activity.name = activity["name"].stringValue
                            new_activity.detail = activity["detail"].stringValue
                            new_activity.num = activity["num"].intValue
                            new_activity.isAdd = true
                            new_activity.creater = activity["founder_name"].stringValue
                            new_activity.date = activity["create_time"].stringValue
                            
                            if new_activity.creater == getMeInfo().username {
                                new_activity.isManage = true
                            }
                            if activity["status"].intValue == 1 {
                                new_activity.state = false
                            }else{
                                new_activity.state = true
                            }
                            
                            //写入本地数据库
                            try! realm.write {
                                realm.add(new_activity)
                                user.activity.append(new_activity)
                            }
                        }
                    }
                    
                    //更新下活动是否已经评价
                    if(json["data"]["eval_activity"].exists()){
                        let activities = json["data"]["eval_activity"].arrayValue
                        print(activities)
                        for activity in activities {
                            let old_activity = nameGetActivity(name: activity["name"].stringValue)
                            
                            //写入本地数据库
                            try! realm.write {
                                old_activity.isCredited = true
                            }
                        }
                    }
                    
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
                            
                            //写入本地数据库
                            try! realm.write {
                                realm.add(new_message)
                            }
                        }
                    }
                    
                    //将用户的信息存入
                    try! realm.write {
                        user.signature = sign
                        if headImage != nil {
                            user.headImage = headImage
                        }
                        user.birthday = json["data"]["birthday"].stringValue
                        user.email = json["data"]["email"].stringValue
                        user.cedit = json["data"]["credit"].intValue
                        user.address = json["data"]["address"].stringValue
                        if json["data"]["gender"].intValue == 1 {
                            user.gender = true
                        }else{
                            user.gender = false 
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
    }

}
