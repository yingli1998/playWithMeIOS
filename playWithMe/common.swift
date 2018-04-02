//
//  common.swift
//  playWithMe
//
//  Created by murray on 2018/3/8.
//  Copyright © 2018年 Murray. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

func genderCode(gender: String) -> Bool {
    if gender == "女"{
        return false
    }else{
        return true
    }
}

//卡片式设计
extension UIView {
    
    func setCardView(view : UIView){
        
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 3.0;
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        view.backgroundColor = UIColor.white
        
    }
}

extension UIButton {
    static func setButton(button: UIButton){
        button.layer.cornerRadius = 5.0
        //button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        //button.backgroundColor = UIColor.greenColor()
        button.layer.backgroundColor = UIColor.blue.cgColor
        
    }
}


//把输入框变成横线
func setBottomBorder(textField:UITextField){
    textField.borderStyle = .none
    textField.layer.backgroundColor = UIColor.white.cgColor
    
    textField.layer.masksToBounds = false
    textField.layer.shadowColor = UIColor.gray.cgColor
    textField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    textField.layer.shadowOpacity = 1.0
    textField.layer.shadowRadius = 0.0
}

//登录界面底部按钮
func setBottomButton(button: UIButton){
    button.tintColor = UIColor.black
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 5
    button.layer.borderColor = UIColor.black.cgColor
}

//由用户名获取User的信息
func nameGetUser(username: String)->User{
    let realm = try! Realm()
    let user = realm.objects(User.self).filter("username == %@", username).first
    return user!  //注意返回的是可空的值
}

//用用户名获取社团信息
func nameGetCorporation(name: String)->Corporation{
    let realm = try! Realm()
    let corporation = realm.objects(Corporation.self).filter("name == %@", name).first
    return corporation!
}

//显示时间
func showDate(date: Date)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.locale = Locale.current //用本地系统时间
    return dateFormatter.string(from: date)
}

//获取本人信息
func getMeInfo()->User{
    //给用户赋值
    let realm = try! Realm()
    let user = realm.objects(User.self).filter("isMe == true").first
    return user!
}

//更新登录状态
func updateLoginState(){
    let realm = try! Realm()
    let loginIn = realm.objects(LoginIn.self).first  //获取登录状态并更新
    try! realm.write {
        loginIn?.lastTime = Date()
    }
}

//设置消息体
func setMessageItem(message: Message)->MessageItem{
    let receiver: User
    let chatType: ChatType
    if message.isMe {
        receiver = nameGetUser(username: message.receiver)
        chatType = .someone
    }else{
        receiver = getMeInfo()
        chatType = .mine
    }
    
    let messageItem = MessageItem(body: message.message as NSString, user: receiver, date: message.date, mtype: chatType)
    
    return messageItem
}

//创建新的消息
func createNewMessage(receiver: String){
    let realm = try! Realm()
    if !(realm.objects(MessageList.self).filter("username == %@", receiver).first != nil){
        let newMessageList = MessageList()
        newMessageList.username = receiver
        newMessageList.date = Date()
        try! realm.write {
            realm.add(newMessageList)
        }
    }
}

//修改图片尺寸
func scaleToSize(size:CGSize, image: UIImage) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    image.draw(in: CGRect(origin:CGPoint(x: 0, y: 0) , size: size))
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
}

//查看用户是否已经参加了该社团 true代表了参加  false代表了没有参加
func checkCorporation(corporation: Corporation)->Bool{
    let user = getMeInfo()
    for selfCorporation in user.attendCorporation {
        if corporation.name == selfCorporation.name {
            return true
        }
    }
    return false
}

//查看用户是否已经参加了该活动 true代表了参加  false代表了没有参加
func checkActivity(activity: Activity)->Bool{
    let user = getMeInfo()
    for selfActivity in user.activity {
        if activity.name == selfActivity.name {
            return true
        }
    }
    return false
}



