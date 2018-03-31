//
//  MyTableViewController.swift
//  playWithMe
//
//  Created by Murray on 2018/2/23.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class MyTableViewController: UITableViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var creditLB: UILabel!
    @IBOutlet weak var signLB: UILabel!
    var user: User!  //用户

    @IBOutlet weak var birthdayLB: UILabel!
    @IBOutlet weak var emailLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    @IBOutlet weak var phoneLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人中心"
        self.tableView.separatorStyle = .none
        self.navigationController?.navigationBar.tintColor = UIColor.white
        headImage.layer.cornerRadius = 40.0
        headImage.layer.masksToBounds = true
        creditLB.layer.cornerRadius = 30.0
        creditLB.layer.masksToBounds = true
        headImage.isUserInteractionEnabled = true
        
        //给用户赋值
        user = getMeInfo()
    }
    
    //更新用户信息
    func updateInfo() {
        
        //更新生日
        if user.birthday != nil {
            birthdayLB.text = user.birthday
        }else{
            birthdayLB.text = "1990-01-01"
        }

        //更新地址
        if user.address != nil {
            addressLB.text = user.address
        }else{
            addressLB.text = ""
        }

        //更新邮箱
        if user.email != nil {
            emailLB.text = user.email
        }else{
            emailLB.text = ""
        }

        //更新签名
        if user.signature != nil {
            signLB.text = user.signature
        }else{
            signLB.text = ""
        }

        //更新电话
        phoneLB.text = user.phone

        //更新用户名
        usernameLB.text = user.username
        
        //更新头像
        headImage.image = UIImage(data: user.headImage!)
    }

    //点击头像换头像
    @IBAction func changeHeadImage(_ sender: UITapGestureRecognizer) {
        
        print("选择头像")
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = .photoLibrary
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
    }
    
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let image = scaleToSize(size: CGSize(width: 200, height: 200), image: pickedImage)
        let imageData = UIImageJPEGRepresentation(image,0)!
        
        //存储头像到本地数据库
        let realm = try! Realm()
        try! realm.write {
            self.user.headImage = nil
            self.user.headImage = imageData
        }
        

//
//        let alertController = UIAlertController(title: "你确定修改头像吗", message: nil, preferredStyle: .alert)
//        let alertAction = UIAlertAction(title: "确定", style: .cancel) { (action) in
//            //获取选择的原图
//            let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//            let imageData = UIImageJPEGRepresentation(pickedImage, 1.0)
//
//            //存储头像到本地数据库
//            let realm = try! Realm()
//            try! realm.write {
//                self.user.headImage = imageData
//            }
//        }
//
//        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
//
//        alertController.addAction(alertAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
        
//        //上传图片
//        if (fileManager.fileExists(atPath: filePath)){
//            取得NSURL
//                        let imageURL = URL(fileURLWithPath: filePath)
//                        //使用Alamofire上传
//                        Alamofire.upload(imageURL, to: "http://www.hangge.com/upload.php")
//                            .responseString { response in
//                                print("Success: \(response.result.isSuccess)")
//                                print("Response String: \(response.result.value ?? "")")
//                        }
//
//        }
        
        //图片控制器退出
        picker.dismiss(animated: true, completion:nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //每次进入用户界面则更新信息
        self.tabBarController?.tabBar.isHidden = false 
        updateInfo()
    }

}
