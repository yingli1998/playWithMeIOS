//
//  ActivityManageController.swift
//  playWithMe
//
//  Created by murray on 2018/3/21.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

import PagingMenuController

//分页菜单配置
private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    
    //社团类型控制器
    private let  finishView = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "FinishActivity") as! FinishTableViewController
    
    //活动类型控制器
    private let runningView = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "RunningActivity") as! RunningActivityController
    
    //组件类型
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    //所有子视图控制器
    fileprivate var pagingControllers: [UIViewController] {
        return [runningView, finishView]
    }
    
    
    //菜单配置项
    fileprivate struct MenuOptions: MenuViewCustomizable {
        //设置下划线的颜色
        var focusMode: MenuFocusMode = .underline(height: 3, color: UIColor(red: 0.0/255, green: 128.0/255, blue: 0.0/255, alpha: 1.0), horizontalPadding: 0,
                                                  verticalPadding: 0)
        
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
        
        //设置动画时间
        var animationDuration: TimeInterval = 0
    }
    
    //第1个菜单项
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "进行中"))
        }
    }
    
    //第2个菜单项
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "已完成"))
        }
    }
}


class ActivityManageController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        //分页菜单配置
        let options = PagingMenuOptions()
        //分页菜单控制器初始化
        let pagingMenuController = PagingMenuController(options: options)
        //分页菜单控制器尺寸设置
        pagingMenuController.view.frame.origin.y += 64
        pagingMenuController.view.frame.size.height -= 64
        
        //建立父子关系
        addChildViewController(pagingMenuController)
        //分页菜单控制器视图添加到当前视图中
        view.addSubview(pagingMenuController.view)
    }

}
