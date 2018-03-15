//
//  LoginViewController.swift
//  playWithMe
//
//  Created by Murray on 2018/2/18.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var SMSButton: UIButton!
    @IBOutlet weak var chooseRegisterButton: UIButton!
    @IBOutlet weak var chooseLoginButton: UIButton!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var status = "register"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTF.delegate = self
        passwordTF.delegate = self
        //修改界面样式
        setBottomBorder(textField: usernameTF)
        setBottomBorder(textField: passwordTF)
        setBottomButton(button: loginButton)
        setBottomButton(button: SMSButton)
        loginButton.isHidden = true
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        // Do any additional setup after loading the view.
    }
    
    //键盘消失
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //点击其他地方键盘收回
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    //转换到注册状态
    @IBAction func changeToRegister(_ sender: UIButton) {
        usernameTF.placeholder = "手机号"
        passwordTF.placeholder = "验证码"
        chooseRegisterButton.isSelected = true
        chooseLoginButton.isSelected = false
        status = "phone_login"
        loginButton.isHidden = true
        SMSButton.isHidden = false
    }
    
    //转换到登录状态
    @IBAction func chnageToLogin(_ sender: UIButton) {
        usernameTF.placeholder = "用户名"
        passwordTF.placeholder = "密码"
        loginButton.titleLabel?.text = "登录"
        chooseRegisterButton.isSelected = false
        chooseLoginButton.isSelected = true
        status = "password_login"
        loginButton.isHidden = false
        SMSButton.isHidden = true
    }
    
    //登录按钮
    @IBAction func login(_ sender: UIButton) {
        if status == "phone_login"{
            //状态是手机号登录则检查验证码
            checkSMS()
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "Main") as! UITabBarController
            present(vc, animated: true, completion: nil)
        }else{
            //状态是密码登录则检查密码
            checkPassword()
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "Main") as! UITabBarController
            present(vc, animated: true, completion: nil)
        }
    }
    
    //获取SMS按钮
    @IBAction func getSMS(_ sender: UIButton) {
        sendSMS()
        SMSButton.isHidden = true
        loginButton.isHidden = false
        status = "phone_login"
    }
    
    //发送验证码
    func sendSMS(){
        print("send SMS")
    }
    
    //检查验证码
    func checkSMS(){
        let username = createUser()
        saveUser(username: username)
        print("check SMS")
    }
    
    //检查密码
    func checkPassword(){
        print("check password")
    }
    
    //保存用户
    func saveUser(username: String){
        let realm = try! Realm()
        let user = User()
        user.isMe = true
        user.phone = usernameTF.text!
        user.username = username
//        let defaultImage = UIImage(named: "defaultHeadImage")
//        user.headImage = UIImagePNGRepresentation(defaultImage!)
//
        try! realm.write {
            realm.add(user)
        }
    }
    
    //远程创建用户 并返回用户名
    func createUser() -> String {
        print("create user")
        return "Murray"
    }


}
