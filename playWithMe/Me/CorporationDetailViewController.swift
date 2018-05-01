//
//  CorporationDetailViewController.swift
//  playWithMe
//
//  Created by murray on 2018/3/26.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class CorporationDetailViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var editBT: UIButton!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var createrImage: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var numLB: UILabel!
    @IBOutlet weak var corporationImage: UIImageView!
    
    var corporation: Corporation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //界面设计
        tableView.tableFooterView = UIView()
        UIButton.setButton(button: editBT)
        editBT.backgroundColor = UIColor.white
        editBT.layer.cornerRadius = 15.0
    }
    
    //每次进入界面更新数据
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    //更新数据
    func updateData(){
        if corporation.detail == nil {
            detail.text = "暂无简介"
        }else{
            detail.text = corporation.detail
        }
        
        createrImage.image = UIImage(data: getMeInfo().headImage!)
        nameLB.text = corporation.name
        let num = String(corporation.num)
        numLB.text = num
        corporationImage.image = UIImage(data: corporation.headImage!)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMember"{
            let controller = segue.destination as! MemeberTableViewController
            controller.users = corporation.users
        }else if segue.identifier == "editCorporation"{
            let controller = segue.destination as! EditCorporationViewController
            controller.corporation = corporation
        }
    }

    @IBAction func changeImage(_ sender: Any) {
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
            let alertController = UIAlertController(title: "错误", message: "读取相册错误", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let image = scaleToSize(size: CGSize(width: 200, height: 200), image: pickedImage)
        let imageData = UIImageJPEGRepresentation(image,0)!
        
        //将选择的图片保存到Document目录下
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/image.jpg"
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        
        let fileURL = URL(fileURLWithPath: filePath)
        let image_url = base_url + "corImage"
        var headers = getHeaders(login: true)
        headers["name"] = corporation.name  //在头中传递名称
        
        //存储头像到本地数据库
        let realm = try! Realm()
        try! realm.write {
            self.corporation.headImage = imageData
        }
        
        //上传图片
        Alamofire.upload(
            multipartFormData:{ multipartFormData in
                multipartFormData.append(fileURL, withName: "image")
        },
            usingThreshold:UInt64.init(),
            to:image_url,
            method:.post,
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }}
        )
        //图片控制器退出
        picker.dismiss(animated: true, completion:nil)
    }
    
    
}
