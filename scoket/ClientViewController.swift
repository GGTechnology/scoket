//
//  ServerViewController.swift
//  test5
//
//  Created by Mac on 2017/3/23.
//  Copyright © 2017年 Mac. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ClientViewController: UIViewController {

    // IP 地址
    @IBOutlet weak var ipTF: UITextField!
    
    // 端口
    @IBOutlet weak var portTF: UITextField!
    
    // 消息
    @IBOutlet weak var msgTF: UITextField!
    
    // 消息显示
    @IBOutlet weak var infoTV: UITextView!
    
    var socket: GCDAsyncSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addText(text: "显示检测(客户端)")
    }
    
    func addText(text: String) {
        infoTV.text = infoTV.text.appendingFormat("%@\n", text)
    }
    
    // 连接
    @IBAction func connectionAct(_ sender: Any) {
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        do {
            try socket?.connect(toHost: ipTF.text!, onPort: UInt16(portTF.text!)!)
            addText(text: "连接成功")
        }catch _ {
            addText(text: "连接失败")
        }
    }
    
    // 断开
    @IBAction func disconnectAct(_ sender: Any) {
        socket?.disconnect()
        addText(text: "断开连接")
    }
    
    // 发送
    @IBAction func sendMsgAct(_ sender: Any) {
        socket?.write((msgTF.text?.data(using: String.Encoding.utf8))!, withTimeout: -1, tag: 0)
    }
}

extension ClientViewController: GCDAsyncSocketDelegate {
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        addText(text: "连接服务器" + host)
        self.socket?.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let msg = String(data: data as Data, encoding: String.Encoding.utf8)
        addText(text: msg!)
        socket?.readData(withTimeout: -1, tag: 0)
    }
    
}







