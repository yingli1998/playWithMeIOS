//
//  MessageBoard.swift
//  playWithMe
//
//  Created by murray on 2018/4/2.
//  Copyright © 2018年 Murray. All rights reserved.
//

import Foundation
import RealmSwift

//存储自己的留言
class MessageBoard: Object {
    @objc var username = ""    //留言的用户名
    @objc var content = ""   //留言的内容
    @objc var date = ""   //留言的时间
    @objc var activity = ""   //所属的社团
    @objc dynamic var image: Data? = nil   //头像  可空
}
