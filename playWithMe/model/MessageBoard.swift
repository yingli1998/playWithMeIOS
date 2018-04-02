//
//  MessageBoard.swift
//  playWithMe
//
//  Created by murray on 2018/4/2.
//  Copyright © 2018年 Murray. All rights reserved.
//

import Foundation
import RealmSwift

class MessageBoard: Object {
    @objc var username = ""    //留言的用户名
    @objc var content = ""   //留言的内容
    @objc var date = Date()   //留言的时间
    
    //所属的社团
    @objc var activity: Activity?  //所属的社团
}
