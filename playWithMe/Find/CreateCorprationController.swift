//
//  CreateCorprationController.swift
//  playWithMe
//
//  Created by murray on 2018/3/30.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift

class CreateCorprationController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage: UIImage?
    @IBOutlet var saveBT: UIButton!
    
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
        
        picker.dismiss(animated: true, completion:nil)
    }
    
    //保存的时候上传到服务器与本地
    @IBAction func save(_ sender: Any) {
        //如果姓名栏没有填
        if nameTextField.text == nil {
            let nameAlertController = UIAlertController(title: "失败", message: "姓名不能是空", preferredStyle: .alert)
            let nameAlertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            nameAlertController.addAction(nameAlertAction)
            present(nameAlertController, animated: true, completion: nil)
            
        }else if signTextField.text == nil {
            let signAlertController = UIAlertController(title: "失败", message: "姓名不能是空", preferredStyle: .alert)
            let signAlertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            signAlertController.addAction(signAlertAction)
            present(signAlertController, animated: true, completion: nil)
        }
        else {
            //上传数据
            uploadData()
            //检查无误的时候保存到本地数据库
            let alertController = UIAlertController(title: "确定创建吗", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "确定", style: .default) { (action) in
                let realm = try! Realm()
                let corporation = Corporation()
                corporation.name = self.nameTextField.text!
                corporation.creater = getMeInfo().username
                if self.selectedImage != nil {
                    let image = scaleToSize(size: CGSize(width: 200, height: 200), image: self.selectedImage!)
                    let imageData = UIImageJPEGRepresentation(image,0)!
                    corporation.headImage = imageData
                }
                corporation.sign = self.signTextField.text!
                corporation.detail = self.descriptionTextView.text
                corporation.num = 1
                let user = getMeInfo()
                corporation.users.append(user)
                
                try! realm.write {
                    realm.add(corporation)
                    user.manageCorporation.append(corporation)
                    user.attendCorporation.append(corporation)
                }
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    //数据上传
    func uploadData(){
        
    }
}
