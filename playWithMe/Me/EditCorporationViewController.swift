//
//  EditCorporationViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/28.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class EditCorporationViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var nameFT: UITextField!
    @IBOutlet weak var detailTV: UITextView!
    @IBOutlet weak var saveBT: UIButton!
    var corporation: Corporation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIButton.setButton(button: saveBT)
        saveBT.backgroundColor = UIColor.white
        saveBT.layer.cornerRadius = 15.0
        
        updateData()
    }
    
    //更新数据
    func updateData(){
        nameFT.text = corporation.name
        if corporation.detail == nil {
            detailTV.text = "暂无简介"
        }else{
            detailTV.text = corporation.detail
        }
    }
    
    //键盘消失
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.resignFirstResponder()
    }

    //保存数据
    @IBAction func save(_ sender: Any) {
        let url = base_url + "corporation/1"
        let headers = getHeaders(login: true)
        var parameters = Parameters()
        parameters["name"] = corporation.name
        
        if nameFT.text != nil && nameFT.text != corporation.name {
            parameters["newName"] = nameFT.text!
        }
        
        if detailTV.text != corporation.detail {
            parameters["introduce"] = detailTV.text
        }
        
        //远程加入社团
        Alamofire.request(url, method: .put,  parameters: parameters,  headers: headers).responseJSON { (response) in
            let json = JSON(response.result.value!)
            print(json)
            if(json["status"].intValue == 0){
                let realm = try! Realm()
                try! realm.write {
                    self.corporation.name = self.nameFT.text!
                    self.corporation.detail = self.detailTV.text
                }
                let alertController = UIAlertController(title: "保存成功", message: nil, preferredStyle: .alert)
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
        
        let alertCtroller = UIAlertController(title: "保存成功", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertCtroller.addAction(alertAction)
        present(alertCtroller, animated: true, completion: nil)
    }
    

}
