//
//  ChatVC.swift
//  CareMe
//
//  Created by baytoor on 9/24/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import Starscream

class ChatVC: UIViewController, WebSocketDelegate {
    
    var socket: WebSocket! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "ws://195.93.152.96:11210")!
        
        socket = WebSocket(url: url)
        socket.delegate = self
        socket.connect()

        socket.onConnect = {
            print("connected")
            self.socket.write(string: "Text sended")
        }
        
        
        
    }
    
    
    @IBAction func isB () {
        print(socket.isConnected)
    }
    
    
}

// Delegations
extension ChatVC {
    func websocketDidConnect(socket: WebSocketClient) {
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}
