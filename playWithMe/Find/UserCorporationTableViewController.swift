//
//  UserCorporationTableViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/20.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class UserCorporationTableViewController: UITableViewController {
    var corporations: [Corporation]? = []   //该用户参加的社团
    var user: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        
        //进入的时候, 从后端拉取数据, 并存入本地
        let url = base_url + "user"
        let headers = getHeaders(login: true)
        var parameters = Parameters()
        parameters["name"] = user
        parameters["corp"] = 1
        
        Alamofire.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            let json = JSON(response.result.value!)
            print(json)
            if(json["status"].intValue == 0){
                let realm = try! Realm()
                //存入用户加入的社团
                if(json["data"]["attend_corps"].exists()){
                    let attend_corps = json["data"]["attend_corps"].arrayValue
                    for attend_corp in attend_corps {
                        let corp = Corporation()
                        corp.name = attend_corp["name"].stringValue
                        corp.sign = attend_corp["sign"].stringValue
                        if !hasCorporation(corporation: corp){ //如果此时的列表没有这个社团, 添加入这个社团
                            let url = URL(string:  "http://47.106.122.58/" + attend_corp["image"].stringValue)
                            let image = NSData(contentsOf: url!) as Data?
                            corp.headImage = image!
                            corp.isAdd = false
                            try! realm.write {
                                realm.add(corp)
                            }
                            self.corporations?.append(corp)
                        }else{
                            let old_corp = realm.objects(Corporation.self).filter("name == %@", corp.name).first!
                            self.corporations?.append(old_corp)
                        }
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
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if corporations == nil {
            return 0
        }else{
            return corporations!.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "corporCell", for: indexPath) as! CorporationTableViewCell
        cell.setCardView(view: cell.backView)
        
        let corporation = corporations![indexPath.row]
        cell.corporationName.text = corporation.name
        cell.corporationView.image = UIImage(data: corporation.headImage!)
        cell.detailLB.text = corporation.sign
        cell.addBT.tag = indexPath.row
        
        //如果已经加入, 则不显示button, 否则显示button
        if corporation.isAdd == true {
            cell.addBT.isHidden = true
        }else{
            cell.addBT.isHidden = false
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //转场传递数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "corporationDetail"{
            let index = tableView.indexPathForSelectedRow?.row
            let controller = segue.destination as! CorporationDetailTableViewController
            controller.corporation = corporations![index!]
        }
    }

    @IBAction func joinIn(_ sender: UIButton) {
        let index = sender.tag   //标记是哪个社团
        let corp = corporations![index]
        let url = base_url + "corporation/1"
        let headers = getHeaders(login: true)
        var parameters = Parameters()
        parameters["name"] = corp.name
        parameters["member"] = getMeInfo().username
        
        //远程加入社团
        Alamofire.request(url, method: .put,  parameters: parameters,  headers: headers).responseJSON { (response) in
            let json = JSON(response.result.value!)
            print(json)
            if(json["status"].intValue == 0){
                //本地加入社团
                let user = getMeInfo()
                let realm = try! Realm()
                try! realm.write {
                    user.corporation.append(corp)
                    corp.isAdd = true
                }
                
                //刷新界面
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
}
    

