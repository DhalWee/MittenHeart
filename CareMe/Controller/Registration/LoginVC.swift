//
//  ViewController.swift
//  CareMe
//
//  Created by baytoor on 9/11/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import Starscream

class LoginVC: UIViewController, UITextFieldDelegate, WebSocketDelegate {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var socket: WebSocket! = nil
    
    var jsonObject: Any  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiStuffs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTF.becomeFirstResponder()
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailTF.text = ""
        passwordTF.text = ""
//        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let url = URL(string: "ws://195.93.152.96:11210")!
        
        socket = WebSocket(url: url)
        socket.delegate = self
        socket.connect()
        
        socket.onConnect = {
            print("connected")
        }
    }
    
    
}

//Functions
extension LoginVC {
    func uiStuffs() {
        addLineToView(view: emailTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 1)
        addLineToView(view: passwordTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 1)
        
        emailTF.delegate = self
        passwordTF.delegate = self
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
    
    @IBAction func loginBtnPressed (_ sender: Any) {
        if getData() {
            sendJson(jsonObject) {
                print("MSG: This json was sended: \(self.jsonObject)")
                print("MSG: Succesfully sended")
                self.doneBtnPressed()
            }
        }
    }
    
    func doneBtnPressed() {
        // cod for checking correctness of email and password
        performSegue(withIdentifier: "ChildOrParentVCSegue", sender: self)
    }
    
    func getData() -> Bool {
        if isEmptyTF() {
            jsonObject = [
                "action": "auth",
                "email": "\((emailTF.text)!)",
                "password": "\((passwordTF.text)!)"
            ]
            return true
        }
        return false
    }
    
    func isEmptyTF() -> Bool {
        if emailTF.text == nil {
            return false
        }
        if passwordTF.text == nil {
            return false
        }
        return true
    }
}

//Delegations
extension LoginVC {
    func websocketDidConnect(socket: WebSocketClient) {
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("MSG from webSocket: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTF:
            passwordTF.becomeFirstResponder()
            break
        case passwordTF:
            passwordTF.resignFirstResponder()
            doneBtnPressed()
            break
        default:
            emailTF.resignFirstResponder()
            view.endEditing(true)
            break
        }
        return true
    }
}
