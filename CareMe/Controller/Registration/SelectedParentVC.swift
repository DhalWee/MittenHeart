//
//  ParentVC.swift
//  CareMe
//
//  Created by baytoor on 9/14/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import Starscream

class SelectedParentVC: UIViewController, WebSocketDelegate {

    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var thirdLbl: UILabel!
    @IBOutlet weak var fourthLbl: UILabel!
    
    var socket: WebSocket! = nil
    
    var jsonObject: Any  = [
        "action": "generate_code"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiStuffs()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let url = URL(string: "ws://195.93.152.96:11210")!
        socket = WebSocket(url: url)
        socket.delegate = self
        socket.connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func uiStuffs() {
        
        addLineToView(view: firstLbl, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        addLineToView(view: secondLbl, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        addLineToView(view: thirdLbl, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        addLineToView(view: fourthLbl, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        
    }
    
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

}

//Delegations
extension SelectedParentVC {
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
        sendJson(jsonObject) {}
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("MSG: \(text)")
        do {
            let data = text.data(using: .utf8)!
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
//
            if let code = jsonObject?["code"] as? String {
                firstLbl.text = code[0]
                secondLbl.text = code[1]
                thirdLbl.text = code[2]
                fourthLbl.text = code[3]
            }
            
            
        } catch let error as NSError {
            print("MSG: json error \(error)")
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}
