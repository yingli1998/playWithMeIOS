//
//  LoginIn.swift
//  playWithMe
//
//  Created by murray on 2018/3/28.
//  Copyright © 2018年 Murray. All rights reserved.
//

import Foundation
import RealmSwift

class LoginIn: Object{
    @objc dynamic var lastTime = Date()  //上次登录时间
    @objc dynamic var firstLogin = false  //是否是第一次登录
    @objc dynamic var interval = 7*24*60*60  //过期时间
}
