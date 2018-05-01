//
//  CorporationTableViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/14.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import RealmSwift
import Alamofire
import SwiftyJSON

class CorporationViewController: UITableViewController {
    
    var corporations: Results<Corporation>?    //主页面的社团

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        
        //下拉刷新
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            //设置参数
            let url = base_url + "getCorp"
            let headers = getHeaders(login: true)
            var parameters = Parameters()
            
            //记录当前需要刷新到的页数
            if(UserDefaults.standard.object(forKey: "corp_page") == nil){  //如果没有page这个项
                UserDefaults.standard.set(1, forKey: "corp_page")
            }
            
            let now_page = UserDefaults.standard.object(forKey: "corp_page") as! Int
            parameters["page"] = now_page   //拉去需要刷新的页数
            
            //拉取信息
            Alamofire.request(url, method: .post,  parameters: parameters,  headers: headers).responseJSON { (response) in
                let json = JSON(response.result.value!)
                print(json)
                if(json["status"].intValue == 0){
                    let realm = try! Realm()
                    let corps = json["data"]["list"].arrayValue
                    let count = corps.count
                    
                    //如果返回的数量不满足应该刷新出的size
                    if json["data"]["size"].intValue > count {
                         UserDefaults.standard.set(json["data"]["page_num"].intValue, forKey: "corp_page")
                    }else{
                        //如果返回的数量满足刷新出的size, 则下次刷新到下一页
                        UserDefaults.standard.set(json["data"]["page_num"].intValue + 1, forKey: "corp_page")
                    }
                    
                    //遍历返回的社团
                    for data in corps {
                        let corp = Corporation()
                        corp.name = data["name"].string!
                        //如果数据库中没有这个社团, 则存入数据库
                        if !hasCorporation(corporation: corp){
                            corp.sign = data["sign"].stringValue
                            corp.num = data["count"].intValue
                            corp.isAdd = false    //没有加入该社团, 这个不需要显示, 因为默认没有加入, 只有在加入的时候才需要填
                            //下载头像
                            let url = URL(string:  "http://47.106.122.58/" + data["image"].string!)
                            let image = NSData(contentsOf: url!) as Data?
                            corp.headImage = image
                            try! realm.write {
                                realm.add(corp)
                            }
                        }
                        self?.updateData()
                        self?.tableView.reloadData()
                    }
                }else{
                    let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        updateData()
    }
    
    //每次进入界面,更新数据
    override func viewWillAppear(_ animated: Bool) {
        updateData()
        self.tabBarController?.tabBar.isHidden = false 
        tableView.reloadData()
    }
    
    //更新数据
    func updateData(){
        let realm = try! Realm()
        corporations = realm.objects(Corporation.self).filter("isAdd == false")
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
        if corporations == nil {
            return 0
        }
        return (corporations?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "corporCell", for: indexPath) as! CorporationTableViewCell
        cell.setCardView(view: cell.backView)
        
        //给单元格各项赋值
        let corporation = corporations![indexPath.row]
        cell.corporationName.text = corporation.name
        cell.corporationView.image = UIImage(data: corporation.headImage!)
        cell.detailLB.text = corporation.sign
        cell.addBT.tag = indexPath.row
        
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
    
    //加入社团
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
                //更新本地数据并刷新界面
                self.updateData()
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
