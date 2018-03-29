//
//  Activity.swift
//  playWithMe
//
//  Created by murray on 2018/3/28.
//  Copyright © 2018年 Murray. All rights reserved.
//

import Foundation
import RealmSwift


class Activity: Object {
    @objc dynamic var name = ""   //活动名
    @objc dynamic var creater = ""    //活动创建人
    @objc dynamic var detail: String? = nil   //简介
    @objc dynamic var state = true   //true是进行中, false是完成
    @objc dynamic var num = 0   //参与活动的人数
    @objc dynamic var date = Date()    //活动发布的时间
    let users = List<User>()   //参加人
}
