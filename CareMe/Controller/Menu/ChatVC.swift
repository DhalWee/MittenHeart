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
    
    let jsonObject: Any  = [
        "action": "test"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "ws://195.93.152.96:11210")!
        
        socket = WebSocket(url: url)
        socket.delegate = self
        socket.connect()

        socket.onConnect = {
            print("connected")
        }
        
    }
    
    
    
   
    
    
}

// Functions
extension ChatVC {
    func sendJson(_ value: Any, onSuccess: @escaping ()-> Void) {
        guard JSONSerialization.isValidJSONObject(value) else {
            print("[WEBSOCKET] Value is not a valid JSON object.\n \(value)")
            return
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: value, options: [])
            socket.write(data: data) {
                onSuccess()
            }
        } catch let error {
            print("[WEBSOCKET] Error serializing JSON:\n\(error)")
        }
    }
    
    
    @IBAction func isB () {
        self.sendJson(self.jsonObject, onSuccess: {
            print("Succesfully sended")
        })
    }
    
    
}


// Delegations
extension ChatVC {
    func websocketDidConnect(socket: WebSocketClient) {
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("MSG: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}

