//
//  EditCorporationViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/28.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift

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
        let realm = try! Realm()
        try! realm.write {
            if checkName(name: nameFT.text){
                corporation.name = nameFT.text!
            }
            
            corporation.detail = detailTV.text
            
        }
    }
    
    //检查name
    func checkName(name: String?)->Bool{
        if name == nil {
            return false
        }else{
            return true
        }
    }

}
