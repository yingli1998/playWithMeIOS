//
//  MessageList.swift
//  playWithMe
//
//  Created by murray on 2018/3/9.
//  Copyright © 2018年 Murray. All rights reserved.
//

import Foundation
import RealmSwift

//消息列表数据库

class MessageList: Object {
    @objc dynamic var isGroup = false  //是否是群组
    @objc dynamic var username = ""   //其他用户的用户名, 是群组则为群组...
    @objc dynamic var date = Date()   //最新消息的时间
    @objc dynamic var message: String?    //最新的消息 可空
}


