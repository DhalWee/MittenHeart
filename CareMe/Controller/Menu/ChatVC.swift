//
//  ChatVC.swift
//  CareMe
//
//  Created by baytoor on 9/24/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import Starscream
import PureLayout

class ChatVC: UIViewController, WebSocketDelegate {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var kid: Kid?
    
    var bottomConstraints: NSLayoutConstraint?
    var refreshControl: UIRefreshControl!
    
    var messages: [MessageDetail] = []
    
    @IBOutlet weak var barBtn: UIBarButtonItem!
    
    var socket: WebSocket! = nil
    
    var previusMsgCount = 0
    
    var updateTimer: Timer!
    
    var roleInt: Int {
        if defaults.string(forKey: "role") == "parent" {
            return 0
        } else {
            return 1
        }
    }
    
    var parentID: String {
        if roleInt == 0 {
            return defaults.string(forKey: "uid")!
        } else {
            return defaults.string(forKey: "parentID")!
        }
    }
    
    var kidID: String {
        if roleInt == 0 {
            return "\(kid!.kidID)"
        } else {
            return defaults.string(forKey: "uid")!
        }
    }
    
    var jsonGetMessage: Any  = []
    
    var jsonSendMessage: Any = []
    
    let role = defaults.string(forKey: "role")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        let url = URL(string: "ws://195.93.152.96:11210")!
        socket = WebSocket(url: url)
        socket.delegate = self
        socket.connect()
        
        updateTimer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(updateInformation), userInfo: nil, repeats: true)
        
        bottomConstraints = NSLayoutConstraint(item: bottomView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.addConstraint(bottomConstraints!)
        updateTableViewConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(updateInformation), for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.beginRefreshing()
        
        
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
    
    @objc func handleKeyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            if isKeyboardShowing {
                bottomConstraints?.constant = -keyboardFrame!.height
            } else {
                bottomConstraints?.constant = +keyboardFrame!.height
            }
            scrollToBottom()
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        updateTableViewConstraints()
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
    
    func updateTableViewConstraints() {
        tableView.autoPinEdge(.top, to: .top, of: view)
        tableView.autoPinEdge(.left, to: .left, of: view)
        tableView.autoPinEdge(.right, to: .right, of: view)
        tableView.autoPinEdge(.bottom, to: .top, of: bottomView)
    }
    
    func messageParse(_ jsonObject: NSDictionary) {
        
        let count = jsonObject.count-1
        
        messages.removeAll()
        for i in 0..<count {
            let message = jsonObject["\(i)"] as? NSDictionary
            
            let id = message!["id"] as? String
            let date = message!["date"] as? String
            let sender_id = message!["parent_id"] as? String
            let receiver_id = message!["kid_id"] as? String
            let msg = message!["message"] as? String
            let type = message!["type"] as? String
            
            let newMsg = MessageDetail(id!, sender_id!, receiver_id!, msg!, type!, date!)
            messages.append(newMsg)
        }
        messages.reverse()
        if previusMsgCount != messages.count {
            tableView.reloadData()
            updateTableViewConstraints()
            scrollToBottom()
            previusMsgCount = messages.count
        }
        self.refreshControl.endRefreshing()
    }
    
    func scrollToBottom(){
        if self.messages.count > 0 {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func sendBtnPressed() {
        self.view.endEditing(true)
        
        if self.textField.text != "" {
//            sendingProcess {
                self.jsonSendMessage = [
                    "action": "send_message",
                    "parent_id": self.parentID,
                    "kid_id": self.kidID,
                    "message": self.textField.text!,
                    "type": "\(self.roleInt)"
                ]
                print(self.jsonSendMessage)
                self.sendJson(self.jsonSendMessage) {}
                self.textField.text = ""
//            }
        }
        
    }
    
//    func sendingProcess(completionHandler: (() -> Void)!) {
//        let tempMsg = MessageDetail("0", parentID, kidID, textField.text!, "\(roleInt)", "Отправляется...")
//        messages.append(tempMsg)
//        tableView.reloadData()
//        updateTableViewConstraints()
//        completionHandler()
//    }
    
    
   @objc func updateInformation() {
        jsonGetMessage = [
            "action": "get_message",
            "parent_id": parentID,
            "kid_id": kidID
        ]
        sendJson(jsonGetMessage) {
            print(self.jsonGetMessage)
        }
    }
    
}

//TableView delegates and datasource
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageDetailCell", for: indexPath) as! MessageDetailCell
        cell.setMsg(message)
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = messages[indexPath.row].message
        let height: CGFloat = estimateFrameForText(text: text).height + 45
        return height
    }
    
    
}

// Delegations
extension ChatVC {
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
        updateInformation()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("Answer from websocket\(text)")
        do {
            let data = text.data(using: .utf8)!
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
            
            if let action = jsonObject?["action"] as? String {
                if action == "get_message" {
                    messageParse(jsonObject!)
                } else if action == "send_message" {
                    updateInformation()
                }
            }
            
            
        } catch let error as NSError {
            print("MSG: json error \(error)")
        }
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}

