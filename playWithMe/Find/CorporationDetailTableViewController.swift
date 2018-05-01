//
//  CorporationDetailTableViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/15.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class CorporationDetailTableViewController: UITableViewController {
    @IBOutlet weak var corporationView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var addBT: UIButton!
    @IBOutlet weak var createrView: UIButton!
    @IBOutlet weak var creditLB: UILabel!
    @IBOutlet weak var detailTV: UITextView!
    @IBOutlet weak var numLB: UILabel!
    var corporation: Corporation!
    var founer: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tabBarController?.tabBar.isHidden = true


        UIButton.setButton(button: addBT)
        addBT.backgroundColor = UIColor(red: 30/255.0, green: 144/255.0, blue: 1.0, alpha: 1.0)
        
        createrView.layer.cornerRadius = 30.0
        createrView.layer.masksToBounds = true
        
        creditLB.layer.cornerRadius = 30.0
        creditLB.layer.masksToBounds = true
        
        //本地数据
        corporationView.image = UIImage(data: corporation.headImage!)
        nameLB.text = corporation.name
        backImageView.image = corporationView.image
        
        //远程数据
        let url = base_url + "corporation"
        let headers = getHeaders(login: true)
        var parameters = Parameters()
        parameters["name"] = corporation.name
        Alamofire.request(url, method: .post,  parameters: parameters,  headers: headers).responseJSON { (response) in
            let json = JSON(response.result.value!)
            if(json["status"].intValue == 0){
                //修改信息
                self.detailTV.text = json["data"]["introduce"].string!
                self.numLB.text = String(json["data"]["count"].intValue)
                self.creditLB.text = String(json["data"]["credit"].intValue)
                self.founer =  json["data"]["founder"].string!
                let url = URL(string:  "http://47.106.122.58/" + json["data"]["headImage"].string!)
                let image = NSData(contentsOf: url!) as Data?
                self.createrView.setImage(UIImage(data: image!), for: .normal)
                self.createrView.setImage(UIImage(data: image!), for: .selected)
            }else{
                let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        let  blurEffect = UIBlurEffect(style:UIBlurEffectStyle.light)
        let  blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(origin: backImageView.frame.origin, size: CGSize(width: self.view.bounds.width, height: self.backImageView.frame.height))
        backImageView.addSubview(blurEffectView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func joinTo(_ sender: UIButton) {
        let index = sender.tag   //标记是哪个社团
        let url = base_url + "corporation/1"
        let headers = getHeaders(login: true)
        var parameters = Parameters()
        parameters["name"] = corporation.name
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
                    user.corporation.append(self.corporation)
                    self.corporation.isAdd = true
                }
                
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
    
    //转场传递数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUser"{
            let controller = segue.destination as! UserDetailTableViewController
            controller.user = self.founer
        }
    }
    
}
