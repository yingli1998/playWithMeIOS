//
//  EditTableViewController.swift
//  playWithMe
//
//  Created by Murray on 2018/2/23.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import Alamofire
import SwiftyJSON


class EditTableViewController: UITableViewController, UITextFieldDelegate{
    @IBOutlet weak var genderLB: UILabel!
    @IBOutlet weak var birthdayLB: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var signTF: UITextField!
    
    var user: User!   //绑定个人用户
    let datePicker = UIDatePicker()
    var finishBT = UIButton()
    var isRepeat = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true 
        
        signTF.delegate = self
        emailTF.delegate = self
        addressTF.delegate = self
        usernameTF.delegate = self
        genderLB.isUserInteractionEnabled = true
        birthdayLB.isUserInteractionEnabled = true
        
        let imgView = UIImageView(image: UIImage(named: "叉号"))
        usernameTF.leftView = imgView
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        //给用户赋值
        user = getMeInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          showInfo()
    }
    
    //键盘消失
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //此时是在编辑用户名, 则进行用户名重复性检查
        if textField == usernameTF {
            print("正在修改用户名")
            //如果用户名修改过且非空
            if usernameTF.text != user.username && usernameTF.text != nil{
                let url = base_url + "username"
                let headers = getHeaders(login: true)
                let parameters: Parameters = [
                    "username": usernameTF.text!
                ]
                Alamofire.request(url, method: .post,  parameters: parameters,  headers: headers).responseJSON { (response) in
                    //处理验证码的回复
                    print(response)
                    let json = JSON(response.result.value!)
                    if(json["status"].intValue == 1){
                        self.isRepeat = true
                        //右边栏提示
                        textField.leftViewMode = UITextFieldViewMode.always
                    }else{
                        self.isRepeat = false
                        textField.leftView = nil
                        textField.leftViewMode = UITextFieldViewMode.never
                    }
                }
                
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("触摸移动")
        emailTF.resignFirstResponder()
        usernameTF.resignFirstResponder()
        addressTF.resignFirstResponder()
        signTF.resignFirstResponder()
    }
    
    func showInfo(){
        signTF.text = user.signature
        emailTF.text = user.email
        addressTF.text = user.address
        usernameTF.text = user.username
        if user.gender {
            genderLB.text = "男"
        }else{
            genderLB.text = "女"
        }
        birthdayLB.text = user.birthday
    }
    
    //选择性别
    @IBAction func changeGender(_ sender: UITapGestureRecognizer) {
        print("选择性别")
        var gender = genderLB.text
        
        let genderController = UIAlertController(title: "性别", message: nil, preferredStyle: .actionSheet)
        let maleAction = UIAlertAction(title: "男", style: .default, handler: { (action) in
            gender = "男"
            self.genderLB.text = gender
        })
        let femaleAction = UIAlertAction(title: "女", style: .default, handler: { (action) in
            gender = "女"
            self.genderLB.text = gender
        })
        
        genderController.addAction(maleAction)
        genderController.addAction(femaleAction)
        present(genderController, animated: true, completion: nil)
    }
    
    //选择生日
    @IBAction func changeBirthday(_ sender: Any) {
        print("选择生日")
        //创建日期选择器
        print(self.view.bounds.height)
        datePicker.isHidden = false
        finishBT.isHidden = false
        finishBT.frame = CGRect(x: 0, y: self.view.bounds.height/2-35, width: 50, height: 30)
        UIButton.setButton(button: finishBT)
        finishBT.setTitleColor(UIColor(red: 82/255, green: 139/255, blue: 139/255, alpha: 1.0), for: .normal)
        finishBT.setTitle("完成", for: .normal)
        finishBT.backgroundColor = UIColor(red: 245/255, green: 255/255, blue: 250/255, alpha: 1.0)
        datePicker.frame = CGRect(x: 0, y: self.view.bounds.height/2, width: self.view.bounds.width, height: 150)
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.backgroundColor = UIColor.white
        datePicker.addTarget(self, action: #selector(dateChanged), for: UIControlEvents.valueChanged)
        finishBT.addTarget(self, action: #selector(finish), for: UIControlEvents.touchDown)
        self.view.addSubview(datePicker)
        self.view.addSubview(finishBT)
    }
    
    //日期改变时,记录现在选择日期
    @objc func dateChanged(datePicker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        birthdayLB.text = formatter.string(from: datePicker.date)
    }
    
    //选择完毕
    @objc func finish(button: UIButton){
        finishBT.isHidden = true
        datePicker.isHidden = true
    }

    //保存信息
    @IBAction func save(_ sender: UIBarButtonItem) {
        let url = base_url + "user/1"
        let headers = getHeaders(login: true)
        var parameters:Parameters = Parameters()
        
        //设置参数
        if emailTF.text != nil {
            parameters["email"] = emailTF.text!
        }
        if addressTF.text != nil {
            parameters["address"] = addressTF.text!
        }
        if signTF.text != nil {
            parameters["signature"] = signTF.text!
        }
        if birthdayLB.text != nil {
            parameters["birthday"] = birthdayLB.text!
        }
        if self.genderLB.text == "女"{
            parameters["gender"] = 1
        }else{
            parameters["gender"] = 0
        }
        
        //如果用户名为空
        if usernameTF.text == nil{
            let alertController = UIAlertController(title: "失败", message: "用户名不可空", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            if usernameTF.text! != user.username {
                //如果用户名重复
                if isRepeat {
                    let alertController = UIAlertController(title: "失败", message: "用户名重复", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                }else {
                    //如果用户名可用
                    parameters["username"] = usernameTF.text!
                }
            }
            Alamofire.request(url, method: .put,  parameters: parameters,  headers: headers).responseJSON { (response) in
                //处理验证码的回复
                let json = JSON(response.result.value!)
                if(json["status"].intValue == 0){
                    let realm = try! Realm()
            
                    try! realm.write {
                        //保存性别信息
                        if self.genderLB.text != nil {
                            self.user.gender = genderCode(gender: self.genderLB.text!)
                        }else{
                            self.user.gender = true  //如果没有, 默认是男性
                        }
                        //保存生日信息
                        self.user.birthday = self.birthdayLB.text
                        //保存个性签名
                        self.user.signature = self.signTF.text
                        //保存地址信息
                        self.user.address = self.addressTF.text
                        //保存邮箱信息
                        self.user.email = self.emailTF.text
                        //检查查用户名是否重复 重复则用原来的名称
                        if self.isRepeat == false {
                            self.user.username = self.usernameTF.text!
                        }
                    }
                    
                }else{
                    //确定信息
                    let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                //确定信息
                let alertController = UIAlertController(title: nil, message: "保存成功", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
