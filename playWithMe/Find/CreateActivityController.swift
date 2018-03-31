//
//  CreateActivityController.swift
//  playWithMe
//
//  Created by murray on 2018/3/30.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift 

class CreateActivityController: UITableViewController, UITextFieldDelegate {

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
            
        }
        else {
            //上传数据
            uploadData()
            //检查无误的时候保存到本地数据库
            let alertController = UIAlertController(title: "确定创建吗", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "确定", style: .default) { (action) in
                let realm = try! Realm()
                let activity = Activity()
                activity.name = self.nameTF.text!
                activity.creater = getMeInfo().username
                activity.detail = self.detailTV.text
                activity.num = 1
                let user = getMeInfo()
                activity.users.append(user)
                
                try! realm.write {
                    realm.add(activity)
                    user.activity.append(activity)
                }
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    //数据上传
    func uploadData(){
        
    }
}
