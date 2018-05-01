//
//  CreateCorprationController.swift
//  playWithMe
//
//  Created by murray on 2018/3/30.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Alamofire

class CreateCorprationController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage: UIImage?
    @IBOutlet var saveBT: UIButton!
    var hasImage = false
    
    @IBOutlet var nameTextField: UITextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
            nameTextField.layer.cornerRadius = 5.0
            nameTextField.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var signTextField: UITextField! {
        didSet {
            signTextField.tag = 2
            signTextField.delegate = self
            signTextField.layer.cornerRadius = 5.0
            signTextField.layer.masksToBounds = true 
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 3
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    
    @IBOutlet var photoImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UIButton.setButton(button: saveBT)
        saveBT.backgroundColor = UIColor.white
        saveBT.layer.cornerRadius = 15.0
    }

    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    //点击空白处键盘收回
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        signTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //在相册中选择照片
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = pickedImage
            photoImageView.image = pickedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        //设置约束
        let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        hasImage = true
        
        picker.dismiss(animated: true, completion:nil)
    }
    
    //保存的时候上传到服务器与本地
    @IBAction func save(_ sender: Any) {
        //如果姓名栏没有填
        if nameTextField.text == "" {
            let nameAlertController = UIAlertController(title: "失败", message: "姓名不能是空", preferredStyle: .alert)
            let nameAlertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            nameAlertController.addAction(nameAlertAction)
            present(nameAlertController, animated: true, completion: nil)
            
        }else if signTextField.text == "" {
            let signAlertController = UIAlertController(title: "失败", message: "签名不能是空", preferredStyle: .alert)
            let signAlertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            signAlertController.addAction(signAlertAction)
            present(signAlertController, animated: true, completion: nil)
        }else if hasImage == false {
            let imageAlertController = UIAlertController(title: "失败", message: "图片不能是空", preferredStyle: .alert)
            let imageAlertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            imageAlertController.addAction(imageAlertAction)
            present(imageAlertController, animated: true, completion: nil)
        }
        else {
            //检查无误的时候保存到本地数据库
            let alertController = UIAlertController(title: "确定创建吗", message: nil, preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "确定", style: .default) { (action) in
                //上传数据
                let url = base_url + "create"
                print("创建社团")
                var headers = getHeaders(login: true)
                var parameters = Parameters()
                parameters["name"] = self.nameTextField.text!
                parameters["sign"] = self.signTextField.text!
                parameters["username"] = getMeInfo().username
                parameters["intro"] = self.descriptionTextView.text
                
                //提交创建社团请求
                Alamofire.request(url, method: .post,  parameters: parameters,  headers: headers).responseJSON { (response) in
                    //处理验证码的回复
                    let json = JSON(response.result.value!)
                    //上传成功
                    if(json["status"].intValue == 0){
                        print("上传成功")
                        //上传图像
                        let image = scaleToSize(size: CGSize(width: 200, height: 200), image: self.selectedImage!)
                        let imageData = UIImageJPEGRepresentation(image,0)!
                        
                        //将选择的图片保存到Document目录下
                        let fileManager = FileManager.default
                        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
                        let filePath = "\(rootPath)/image.jpg"
                        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
                        
                        let fileURL = URL(fileURLWithPath: filePath)
                        let image_url = base_url + "corImage"
                        headers["name"] = self.nameTextField.text!  //在头中传递名称
                        
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

                        //在本地保存该社团的信息
                        let realm = try! Realm()
                        let corporation = Corporation()
                        corporation.name = self.nameTextField.text!
                        corporation.creater = getMeInfo().username
                        corporation.headImage = imageData
                        corporation.sign = self.signTextField.text!
                        corporation.detail = self.descriptionTextView.text
                        corporation.num = 1
                        corporation.isAdd = true
                        corporation.isManage = true 
                        let user = getMeInfo()
                        corporation.users.append(user)
                        
                        try! realm.write {
                            realm.add(corporation)
                            user.corporation.append(corporation)
                        }
                        let alertController = UIAlertController(title: "成功", message: "创建成功", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: {
                            //进入主界面
                            let sb = UIStoryboard(name: "Main", bundle:nil)
                            let vc = sb.instantiateViewController(withIdentifier: "Main") as! UITabBarController
                            self.present(vc, animated: true, completion: nil)
                        })
                    }else{
                        //上传失败
                        let alertController = UIAlertController(title: "失败", message: json["message"].string!, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            //取消创建
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            
        }
    }
}
