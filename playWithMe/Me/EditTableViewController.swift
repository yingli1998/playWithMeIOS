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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true 
        
        signTF.delegate = self
        emailTF.delegate = self
        addressTF.delegate = self
        usernameTF.delegate = self
        genderLB.isUserInteractionEnabled = true
        birthdayLB.isUserInteractionEnabled = true
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        //给用户赋值
        user = getMeInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          showInfo()
    }
    
    //键盘消失
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
        print("保存信息")

        let realm = try! Realm()
        
        try! realm.write {
            //保存性别信息
            if genderLB.text != nil {
                user.gender = genderCode(gender: genderLB.text!)
            }else{
                user.gender = true  //如果没有, 默认是男性
            }
            
            //保存生日信息
            user.birthday = birthdayLB.text
            
            //保存个性签名
            user.signature = signTF.text

            //保存地址信息
            user.address = addressTF.text
            
            //保存邮箱信息
            user.email = emailTF.text
            
            //检查用户名是否重复 重复则用原来的名称
            if checkUsername(username: usernameTF.text!){
                user.username = usernameTF.text!
            }
        }

        //确定信息
        let alertController = UIAlertController(title: nil, message: "保存成功", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)

        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)

    }
    
    //检查用户名重复问题
    func checkUsername(username: String) -> Bool{
        print("检查用户名重复")
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
