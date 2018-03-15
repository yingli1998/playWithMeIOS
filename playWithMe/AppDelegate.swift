//
//  AppDelegate.swift
//  playWithMe
//
//  Created by Murray on 2018/2/18.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //修改颜色
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        //增加标识，用于判断是否是第一次启动应用...
        if (!(UserDefaults.standard.bool(forKey: "everLaunched"))) { //正常为!
            UserDefaults.standard.set(true, forKey:"everLaunched")
            let guideViewController = GuideViewController()
            self.window!.rootViewController = guideViewController
        }else if false {  //非登录状态进入登录注册界面
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let loginController = sb.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            //VC为该界面storyboardID，Main.storyboard中选中该界面View，Identifier inspector中修改
            self.window?.rootViewController = loginController
        }else{
            //登录状态进入主界面
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "Main") as! UITabBarController
            //VC为该界面storyboardID，Main.storyboard中选中该界面View，Identifier inspector中修改
            self.window?.rootViewController = vc
        }
        
        let config = Realm.Configuration(
            // 设置新的架构版本。必须大于之前所使用的
            // （如果之前从未设置过架构版本，那么当前的架构版本为 0）
            schemaVersion: 1,
            
            // 设置模块，如果 Realm 的架构版本低于上面所定义的版本，
            // 那么这段代码就会自动调用
            migrationBlock: { migration, oldSchemaVersion in
                // 我们目前还未执行过迁移，因此 oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // 没有什么要做的！
                    // Realm 会自行检测新增和被移除的属性
                    // 然后会自动更新磁盘上的架构
                }
        })
        
        // 通知 Realm 为默认的 Realm 数据库使用这个新的配置对象
        Realm.Configuration.defaultConfiguration = config
        
        //获取realm文件, 用于本地更改数据库
        let realm = try! Realm()
        print(realm.configuration.fileURL!)
        
        // 现在我们已经通知了 Realm 如何处理架构变化，
        // 打开文件将会自动执行迁移
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    

}




