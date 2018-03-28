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

//获取高斯模糊的照片
func getBlur(image: UIImage)->UIImage{
    //获取原始图片
    let inputImage =  CIImage(image: image)
    //使用高斯模糊滤镜
    let filter = CIFilter(name: "CIGaussianBlur")!
    filter.setValue(inputImage, forKey:kCIInputImageKey)
    //设置模糊半径值（越大越模糊）
    filter.setValue(5.0, forKey: kCIInputRadiusKey)
    let outputCIImage = filter.outputImage!
    let rect = CGRect(origin: CGPoint.zero, size: image.size)
    let cgImage = CIContext().createCGImage(outputCIImage, from: rect)
    //显示生成的模糊图片
    return UIImage(cgImage: cgImage!)
}


