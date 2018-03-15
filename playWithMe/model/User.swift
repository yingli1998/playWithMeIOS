//
//  User.swift
//  playWithMe
//
//  Created by murray on 2018/3/8.
//  Copyright © 2018年 Murray. All rights reserved.
//

//用户个人数据库

import Foundation
import RealmSwift

class User: Object{
    //个人信息
    @objc dynamic var isMe = false    //判断是否是本人
    @objc dynamic var username = "Murray"   //用户名
    @objc dynamic var phone = "17671673795"  //手机号 不可空
    @objc dynamic var gender = true      //性别
    @objc dynamic var email: String?   //邮箱 可空
    @objc dynamic var address: String? //地址 可空
    @objc dynamic var birthday: String?   //生日 可空
    @objc dynamic var headImage: Data? = nil   //头像  可空
    @objc dynamic var signature: String?  //个性签名  可空

    //社团信息
    @objc dynamic var activity: String?
}
