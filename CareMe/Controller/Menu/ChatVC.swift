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
    
    var kids: [Kid]?
    var kid: Kid?
    
    @IBOutlet weak var barBtn: UIBarButtonItem!
    
    var socket: WebSocket! = nil
    
    let jsonObject: Any  = [
        "action": "test"
    ]
    
    let role = defaults.string(forKey: "role")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "ws://195.93.152.96:11210")!
        
        socket = WebSocket(url: url)
        socket.delegate = self
        socket.connect()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if role == "parent" {
            barBtn.isEnabled = true
            barBtn.tintColor = nil
        } else {
            barBtn.isEnabled = false
            barBtn.tintColor = UIColor.clear
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            if socket.isConnected {
                socket.write(data: data) {
                    print("MSG: Successfully sended")
                    onSuccess()
                }
            }
        } catch let error {
            print("[WEBSOCKET] Error serializing JSON:\n\(error)")
        }
    }
    
    @IBAction func barBtnPressed(_ sender: Any) {
    
    }

}


// Delegations
extension ChatVC {
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Answer from websocket\(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}

