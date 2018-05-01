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
import SwiftyRSA
import Alamofire
import CryptoSwift

//头常用参数
let did = UIDevice.current.identifierForVendor?.uuidString   //设备号
let app_version = "1"     //版本号

//publicKey
let publicData = "******"

//url
let base_url = "*******"

//aes_key
let aes_key = "*******"

//获取Headers
func getHeaders(login: Bool)->HTTPHeaders{
    let publicKey = try! PublicKey(pemEncoded: publicData) //给公钥赋值
    var headers = HTTPHeaders()
    headers["did"] = did!
    headers["version"] = app_version
    let str = did! + "|" + getDate()
    let clear = try! ClearMessage(string: str, using: .utf8)
    let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
    let base64String = encrypted.base64String  //加密后的值
    headers["sign"] = base64String
    
    //如果是登录状态, 则header中有token
    if login == true {
        print("------------")
        print("get token ")
        let realm = try! Realm()
        let loginIn = realm.objects(LoginIn.self).first!
        let en_token = loginIn.token
        do {
            let aes = try AES(key: aes_key.bytes, blockMode: .ECB, padding: .pkcs7) // aes128
            let token = try aes.encrypt(Array((en_token+"|"+getDate()).utf8)).toBase64()!
            headers["token"] = token
        } catch {
            print(error)
        }
        print(headers)
    }
    return headers
}

func genderCode(gender: String) -> Bool {
    if gender == "女"{
        return false
    }else{
        return true
    }
}

//获取时间戳
func getDate()->String{
    let date = Date()
    let timeInterval = date.timeIntervalSince1970 * 1000
    return String(timeInterval)
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

//用社团名获取社团信息
func nameGetCorporation(name: String)->Corporation{
    let realm = try! Realm()
    let corporation = realm.objects(Corporation.self).filter("name == %@", name).first
    return corporation!
}

//用活动名获取活动信息
func nameGetActivity(name: String) -> Activity {
    let realm = try! Realm()
    let activity = realm.objects(Activity.self).filter("name == %@", name).first
    return activity!
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
    for selfCorporation in user.corporation {
        if corporation.name == selfCorporation.name {
            return true
        }
    }
    return false
}

//检查这个社团是否已经存在数据库中
func hasCorporation(corporation: Corporation)->Bool{
    let realm = try! Realm()
    let corporations = realm.objects(Corporation.self)
    for corp in corporations {
        if corp.name == corporation.name {
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

//检查登录状态
func checkLoginStatus()->Bool{
    let realm = try! Realm()
    let loginIn = realm.objects(LoginIn.self).first!
    if Date().timeIntervalSince1970*1000 - loginIn.lastTime.timeIntervalSince1970 * 1000 > Double(loginIn.interval*60*60*24){
        return true
    }else{
        return false
    }
}

//base64解码
func base64Decoding(encodedString:String)->String
{
    let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
    let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
    return decodedString
}

/// swift Base64处理
/**
 *   编码
 */
func base64Encoding(plainString:String)->String
{
    
    let plainData = plainString.data(using: String.Encoding.utf8)
    let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
    return base64String!
}



