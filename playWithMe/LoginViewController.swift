//
//  LoginViewController.swift
//  playWithMe
//
//  Created by Murray on 2018/2/18.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import SwiftyRSA
import CryptoSwift 

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var SMSButton: UIButton!
    @IBOutlet weak var chooseRegisterButton: UIButton!
    @IBOutlet weak var chooseLoginButton: UIButton!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var status = "register"
    var token = ""
    var username = ""
    
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
        passwordTF.isSecureTextEntry = false
    }
    
    //转换到登录状态
    @IBAction func chnageToLogin(_ sender: UIButton) {
        usernameTF.placeholder = "手机号"
        passwordTF.placeholder = "密码"
        loginButton.titleLabel?.text = "登录"
        chooseRegisterButton.isSelected = false
        chooseLoginButton.isSelected = true
        status = "password_login"
        loginButton.isHidden = false
        SMSButton.isHidden = true
        passwordTF.isSecureTextEntry = true
    }
    
    //登录按钮
    @IBAction func login(_ sender: UIButton) {
        if status == "phone_login"{
            //状态是手机号登录则检查验证码
            let url = base_url + "login"
            let headers = getHeaders(login: false)
            let parameters: Parameters = [
                "phone" : usernameTF.text!,
                "code": passwordTF.text!
            ]
            Alamofire.request(url, method: .post,  parameters: parameters,  headers: headers).responseJSON { (response) in
                //处理验证码的回复
                let json = JSON(response.result.value!)
                if(json["status"].intValue == 0){
                    self.username = json["data"]["username"].string!
                    self.token = json["data"]["token"].string!
                    self.saveUser(username: self.username)  //注册成功, 返回用户名
                    let sb = UIStoryboard(name: "Main", bundle:nil)
                    let vc = sb.instantiateViewController(withIdentifier: "Main") as! UITabBarController
                    self.present(vc, animated: true, completion: nil)
                }else{
                    let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }else{
            //状态是密码登录则检查密码
            let url = base_url + "login"
            let headers = getHeaders(login: false)
            var parameters: Parameters = [
                "phone" : usernameTF.text!,
            ]
            let aes = try! AES(key: aes_key.bytes, blockMode: .ECB, padding: .pkcs7) // aes128
            parameters["password"] = try! aes.encrypt((passwordTF.text!+"|"+getDate()).bytes).toBase64()!
            Alamofire.request(url, method: .post,  parameters: parameters,  headers: headers).responseJSON { (response) in
                //处理验证码的回复
                let json = JSON(response.result.value!)
                if(json["status"].intValue == 0){
                    self.token = json["data"]["token"].string!
                    self.username = json["data"]["username"].string!
                    let realm = try! Realm()
                    let loginIn = realm.objects(LoginIn.self).first
                    if(loginIn != nil){ //如果是直接登录
                        try! realm.write {
                            loginIn!["token"] = self.token
                        }
                    }else{
                        //登录但是没有先注册, 此时需要从远程获取本用户的相关信息, 并将其存在本地
                        self.saveUser(username: self.username)
                    }
                    
                    //进入主界面
                    let sb = UIStoryboard(name: "Main", bundle:nil)
                    let vc = sb.instantiateViewController(withIdentifier: "Main") as! UITabBarController
                    self.present(vc, animated: true, completion: nil)
                }else{
                    let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
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
        let api = "identify"
        let url = base_url + api
        let headers = getHeaders(login: false)  //获取headers
        let parameters: Parameters = [
            "phone" : usernameTF.text!
        ]
        
        Alamofire.request(url, method: .post,  parameters: parameters,  headers: headers).responseJSON { (response) in
            //处理验证码的回复
            let json = JSON(response.result.value!)
            if(json["status"].intValue == 0){
                let alertController = UIAlertController(title: "成功", message: "验证码发送成功", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "失败", message: "请重试", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //检查密码
    func checkPassword()->Bool{
        print("check password")
        return true
    }
    
    //保存用户
    func saveUser(username: String){
        let realm = try! Realm()
        let user = User()
        let loginIn = LoginIn()
        user.isMe = true
        user.phone = usernameTF.text!
        user.username = username
        
        //记录登录信息
        loginIn.firstLogin = false
        loginIn.lastTime = Date()
        loginIn.token = token
        let defaultImage = UIImage(named: "defaultHeadImage1")
        user.headImage = UIImagePNGRepresentation(defaultImage!)

        try! realm.write {
            realm.add(user)
            realm.add(loginIn)
        }
    }

}
