//
//  CreateActivityController.swift
//  playWithMe
//
//  Created by murray on 2018/3/30.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Alamofire

class CreateActivityController: UITableViewController, UITextFieldDelegate {
    
    var corporations: [String]? = []   //本人加入的社团
    var corporation: String?   //相应的社团
    
    @IBOutlet weak var chooseSV: UIStackView!
    @IBOutlet weak var detailTV: UITextView!{
        didSet {
            detailTV.tag = 2
            detailTV.layer.cornerRadius = 5.0
            detailTV.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var nameTF: UITextField!{
        didSet {
            nameTF.tag = 1
            nameTF.becomeFirstResponder()
            nameTF.delegate = self
            nameTF.layer.cornerRadius = 5.0
            nameTF.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var saveBT: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none 
        UIButton.setButton(button: saveBT)
        saveBT.backgroundColor = UIColor.white
        saveBT.layer.cornerRadius = 15.0
        
        let realm = try! Realm()
        let results = realm.objects(Corporation.self).filter("isAdd == true")
        for corp in results{
            corporations?.append(corp.name)
        }
        
        //添加下拉菜单
        let defaultTitle = "请选择相应的社团"
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width , height: 50)
        var dropBoxView: TGDropBoxView
        if corporations?.count == 0 {
            let choices = ["暂无加入的社团"]
            dropBoxView = TGDropBoxView(parentVC: self, title: defaultTitle, items: choices, frame: rect)
        }else{
            dropBoxView = TGDropBoxView(parentVC: self, title: defaultTitle, items: corporations!, frame: rect)
        }
        
//        dropBoxView.isHightWhenShowList = true
//        dropBoxView.willShowOrHideBoxListHandler = { (isShow) in
//            if isShow { NSLog("will show choices") }
//            else { NSLog("will hide choices") }
//        }
//        dropBoxView.didShowOrHideBoxListHandler = { (isShow) in
//            if isShow { NSLog("did show choices") }
//            else { NSLog("did hide choices") }
//        }
        dropBoxView.didSelectBoxItemHandler = { (row) in
            if dropBoxView.currentTitle() != "暂无加入的社团" {
                self.corporation = dropBoxView.currentTitle()  //选择的社团赋值
            }
        }
        chooseSV.addArrangedSubview(dropBoxView)
    }

    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    @IBAction func save(_ sender: Any) {
        //如果姓名栏没有填
        if nameTF.text == "" {
            let nameAlertController = UIAlertController(title: "失败", message: "姓名不能是空", preferredStyle: .alert)
            let nameAlertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            nameAlertController.addAction(nameAlertAction)
            present(nameAlertController, animated: true, completion: nil)
            
        }else if detailTV.text == "请写入详细的介绍"{
            let alertController = UIAlertController(title: "失败", message: "介绍不能为空", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
        else {
            //检查无误的时候保存到本地数据库
            let alertController = UIAlertController(title: "确定创建吗", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "确定", style: .default) { (action) in
                //上传数据
                let url = base_url + "createActivity"
                let headers = getHeaders(login: true)
                var parameters = Parameters()
                parameters["username"] = getMeInfo().username
                parameters["name"] = self.nameTF.text!
                parameters["corporation"] = self.corporation!
                parameters["detail"] = self.detailTV.text
                
                //提交创建社团请求
                Alamofire.request(url, method: .post,  parameters: parameters,  headers: headers).responseJSON { (response) in
                    //处理验证码的回复
                    let json = JSON(response.result.value!)
                    //上传成功
                    if(json["status"].intValue == 0){
                        
                        let realm = try! Realm()
                        let activity = Activity()
                        activity.name = self.nameTF.text!
                        activity.creater = getMeInfo().username
                        activity.detail = self.detailTV.text
                        activity.num = 1
                        activity.isManage = true
                        activity.isAdd = true
                        activity.date = json["data"]["create_time"].stringValue
                        let user = getMeInfo()
                        activity.users.append(user)
                        
                        try! realm.write {
                            realm.add(activity)
                            user.activity.append(activity)
                        }
                        
                        let alertController = UIAlertController(title: "成功", message: "创建成功", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: {
                            //进入主界面
                            let sb = UIStoryboard(name: "Main", bundle:nil)
                            let vc = sb.instantiateViewController(withIdentifier: "Main") as! UITabBarController
                            self.present(vc, animated: true, completion: nil)
                        })
                        
                    }else{
                        //上传失败
                        let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            
            
        }
    }
}
