//
//  Corporation.swift
//  playWithMe
//
//  Created by murray on 2018/3/28.
//  Copyright © 2018年 Murray. All rights reserved.
//

import Foundation
import RealmSwift

class Corporation: Object {
    @objc dynamic var name = ""    //社团名
    @objc dynamic var sign = "暂无介绍"    //简单介绍
    @objc dynamic var detail: String? = nil   //详细介绍, 可空
    @objc dynamic var headImage: Data? = nil   //头像  可空
    @objc dynamic var creater = ""   //创建人
    @objc dynamic var num = 0  //加入社团的人数
    @objc dynamic var state = true  //社团的状态, 运行中为true, 否则为false
    
    //关联的活动和用户
    let activities = List<Activity>()
    let users = List<User>()
}
