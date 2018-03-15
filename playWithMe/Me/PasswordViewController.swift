//
//  PasswordViewController.swift
//  playWithMe
//
//  Created by Murray on 2018/2/23.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var submitBT: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "密码设置"
        
        passwordTF.delegate = self
        submitBT.layer.cornerRadius = 3
        UIButton.setButton(button: submitBT)
        submitBT.backgroundColor =  UIColor(red: 0.0/255, green: 128.0/255, blue: 0.0/255, alpha: 1.0)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: UIButton) {
        print("提交密码")
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
    

}
