//
//  ChatViewController.swift
//  playWithMe
//
//  Created by Murray on 2018/2/25.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit
import RealmSwift

class ChatViewController: UIViewController, ChatDataSource, UITextFieldDelegate {

    var Chats:NSMutableArray!  //可变数组代表聊天内容
    var tableView:TableView!
    var me:User!
    var you:String!
    var txtMsg:UITextField!
    var messages: Results<Message>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        //给用户赋值
        me = getMeInfo()
        let realm = try! Realm()
        messages = realm.objects(Message.self).filter("receiver == %@", you).sorted(byKeyPath: "date", ascending: false)
        
        //设置界面
        setupChatTable()
        setupSendPanel()
        
    }
    
    //设置发送界面
    func setupSendPanel()
    {
        let screenWidth = UIScreen.main.bounds.width
        let sendView = UIView(frame:CGRect(x: 0,y: self.view.frame.size.height - 56,width: screenWidth,height: 56))
        
        sendView.backgroundColor=UIColor(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1.0)
        sendView.alpha=0.9
        
        txtMsg = UITextField(frame:CGRect(x: 7,y: 10,width: screenWidth - 95,height: 36))
        txtMsg.backgroundColor = UIColor.white
        txtMsg.textColor=UIColor.black
        txtMsg.font=UIFont.boldSystemFont(ofSize: 12)
        txtMsg.layer.cornerRadius = 10.0
        txtMsg.returnKeyType = UIReturnKeyType.send
        
        //Set the delegate so you can respond to user input
        txtMsg.delegate=self
        sendView.addSubview(txtMsg)
        self.view.addSubview(sendView)
        
        //发送表情按钮
        let expressionBT = UIButton()
        
        //发送图片按钮
        let imageBT = UIButton()
        
        let sendButton = UIButton(frame:CGRect(x: screenWidth - 80,y: 10,width: 72,height: 36))
        sendButton.backgroundColor=UIColor(red: 0x37/255, green: 0xba/255, blue: 0x46/255, alpha: 1)
        sendButton.addTarget(self, action:#selector(ChatViewController.sendMessage) ,
                             for:UIControlEvents.touchUpInside)
        sendButton.layer.cornerRadius=6.0
        sendButton.setTitle("发送", for:UIControlState())
        sendView.addSubview(sendButton)
        sendView.addSubview(expressionBT)
        sendView.addSubview(imageBT)
    }
    
    //发送返回
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        sendMessage()
        return true
    }
    
    //发送消息
    @objc func sendMessage()
    {
        //composing=false
        let sender = txtMsg
        let thisChat =  MessageItem(body:sender!.text! as NSString, user:me, date:Date(), mtype:ChatType.mine)
        
        let thisChatMessage = Message()
        thisChatMessage.date = Date()
        thisChatMessage.isMe = true
        thisChatMessage.message = sender!.text!
        thisChatMessage.receiver = you
        
        let realm = try! Realm()
        let messageList = realm.objects(MessageList.self).filter("username == %@", you).first
        try! realm.write {
            realm.add(thisChatMessage)
            messageList?.message = sender!.text!
            messageList?.date = Date() 
        }
        
        Chats.add(thisChat)
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        //self.showTableView()
        sender?.resignFirstResponder()
        sender?.text = ""
    }
    
    //设置聊天界面
    func setupChatTable(){
        print("*************")
        print("设置聊天界面")
        self.tableView = TableView(frame:CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height - 76), style: .plain)
        
        //创建一个重用的单元格
        self.tableView!.register(TableViewCell.self, forCellReuseIdentifier: "ChatCell")
        Chats = NSMutableArray()
        
        if (messages?.count)! != 0  {
            print("Have message!!!!")
            for message in messages! {
                Chats.add(setMessageItem(message: message))
            }
        }
        
        //set the chatDataSource
        self.tableView.chatDataSource = self
        
        //call the reloadData, this is actually calling your override method
        self.tableView.reloadData()
        
        self.view.addSubview(self.tableView)
    }
    
    //返回个数
    func rowsForChatTable(_ tableView:TableView) -> Int
    {
        return self.Chats.count
    }
    
    //返回内容
    func chatTableView(_ tableView:TableView, dataForRow row:Int) -> MessageItem
    {
        return Chats[row] as! MessageItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
