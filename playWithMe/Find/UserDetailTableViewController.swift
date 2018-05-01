//
//  UserDetailTableViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/20.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserDetailTableViewController: UITableViewController {
    @IBOutlet weak var backViewImage: UIImageView!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var signLB: UILabel!
    @IBOutlet weak var creditLB: UILabel!
    @IBOutlet weak var birthdayLB: UILabel!
    @IBOutlet weak var genderLB: UILabel!

    var user: String!
    
    @IBOutlet weak var messageBT: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        headImage.layer.cornerRadius = 40.0
        headImage.layer.masksToBounds = true
        
        creditLB.layer.cornerRadius = 30.0
        creditLB.layer.masksToBounds = true
        
        //加载远程数据
        let url = base_url + "user"
        let headers = getHeaders(login: true)
        let parameters: Parameters = [
            "name" : user
        ]
        
        print(user)
        
        Alamofire.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            let json = JSON(response.result.value!)
            if(json["status"].intValue == 0){
                //修改内容
                self.usernameLB.text = self.user
                self.signLB.text = json["data"]["signature"].stringValue
                self.creditLB.text = json["data"]["credit"].stringValue
                self.birthdayLB.text = json["data"]["birthday"].stringValue
                if json["data"]["gender"].intValue == 1 {
                    self.genderLB.text = "男"
                }else{
                    self.genderLB.text = "女"
                }
                
                let url = URL(string:  "http://47.106.122.58/" + json["data"]["image"].stringValue)
                let image = NSData(contentsOf: url!) as Data?
                self.headImage.image = UIImage(data: image!)
                self.backViewImage.image = self.headImage.image
            }else{
                let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        let  blurEffect = UIBlurEffect(style:UIBlurEffectStyle.regular)
        let  blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(origin: backViewImage.frame.origin, size: CGSize(width: self.view.bounds.width, height: backViewImage.frame.height))
        backViewImage.addSubview(blurEffectView)
        
    }


    //转场传递数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "showCorporation"{
            let controller = segue.destination as! UserCorporationTableViewController
            controller.user = self.user
        }
    }
}
