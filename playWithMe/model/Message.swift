//
//  Message.swift
//  playWithMe
//
//  Created by murray on 2018/3/10.
//  Copyright © 2018年 Murray. All rights reserved.
//

import Foundation
import RealmSwift

class Message: Object {
    @objc dynamic var sender = ""   //发送方的名称
    @objc dynamic var message = ""   //消息内容
    @objc dynamic var date = Date()  //时间记录
    @objc dynamic var isMe = false   //是本人发的吗
    @objc dynamic var image: Data?   //如果是图片信息 发送图片
}
