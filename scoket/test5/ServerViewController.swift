//
//  ClientViewController.swift
//  test5
//
//  Created by Mac on 2017/3/23.
//  Copyright © 2017年 Mac. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ServerViewController: UIViewController {
    
    // 端口
    @IBOutlet weak var portTF: UITextField!
    
    // 消息
    @IBOutlet weak var msgTF: UITextField!
    
    // 信息显示
    @IBOutlet weak var infoTV: UITextView!
    
    var serverSocket: GCDAsyncSocket?
    var clientSocket: GCDAsyncSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addText(text: "显示检测(服务端)")
        
    }
    
    // 对InfoTextView添加提示内容
    func addText(text: String) {
        infoTV.text = infoTV.text.appendingFormat("%@\n", text)
    }
    
    // 监听
    @IBAction func listeningAct(_ sender: Any) {
        serverSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        do {
            try serverSocket?.accept(onPort: UInt16(portTF.text!)!)
            addText(text: "监听成功")
        }catch _ {
            addText(text: "监听失败")
        }
    }
    
    // 发送
    @IBAction func sendAct(_ sender: Any) {
        let data = msgTF.text?.data(using: String.Encoding.utf8)
        //向客户端写入信息   Timeout设置为 -1 则不会超时, tag作为两边一样的标示
        clientSocket?.write(data!, withTimeout: -1, tag: 0)
    }
}

extension ServerViewController: GCDAsyncSocketDelegate {
    
    //当接收到新的Socket连接时执行
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        
        addText(text: "连接成功")
        addText(text: "连接地址" + newSocket.connectedHost!)
        addText(text: "端口号" + String(newSocket.connectedPort))
        clientSocket = newSocket
        
        //第一次开始读取Data
        clientSocket!.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let message = String(data: data,encoding: String.Encoding.utf8)
        addText(text: message!)
        //再次准备读取Data,以此来循环读取Data
        sock.readData(withTimeout: -1, tag: 0)
    }
}















