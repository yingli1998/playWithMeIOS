//
//  PasswordViewController.swift
//  playWithMe
//
//  Created by Murray on 2018/2/23.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift
import SwiftyJSON

class PasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var submitBT: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "密码设置"
        
        self.tabBarController?.tabBar.isHidden = true
        
        passwordTF.isSecureTextEntry = true
        passwordTF.delegate = self
        submitBT.layer.cornerRadius = 3
        UIButton.setButton(button: submitBT)
        submitBT.backgroundColor =  UIColor(red: 0.0/255, green: 128.0/255, blue: 0.0/255, alpha: 1.0)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if passwordTF.text == nil {
            let alertController = UIAlertController(title: "错误", message: "请输入密码", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }else {
            let url = base_url + "user/1"
            let headers = getHeaders(login: true)
            var parameters:Parameters = Parameters()
            let aes = try! AES(key: aes_key.bytes, blockMode: .ECB, padding: .pkcs7) // aes128
            parameters["password"] = try! aes.encrypt(passwordTF.text!.bytes).toBase64()!
            
            Alamofire.request(url, method: .put,  parameters: parameters,  headers: headers).responseJSON { (response) in
                let json = JSON(response.result.value!)
                if(json["status"].intValue == 0){
                    let alertController = UIAlertController(title: "成功", message: "密码修改成功", preferredStyle: .alert)
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
        self.passwordTF.text = nil
    }
    
    //使键盘消失
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        passwordTF.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
