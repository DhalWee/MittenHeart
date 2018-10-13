//
//  RegisterVC.swift
//  CareMe
//
//  Created by baytoor on 9/24/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import Starscream

class RegisterVC: UIViewController, UITextFieldDelegate, WebSocketDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var repeatPasswordTF: UITextField!
    
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
        UIApplication.shared.statusBarStyle = .default
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

//Function
extension RegisterVC {
    func uiStuffs() {
        addLineToView(view: emailTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 1)
        addLineToView(view: passwordTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 1)
        addLineToView(view: repeatPasswordTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 1)
        
        emailTF.delegate = self
        passwordTF.delegate = self
        repeatPasswordTF.delegate = self
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
    
    @IBAction func registerBtnPressed (_ sender: Any) {
        
        if getData() {
            sendJson(jsonObject) {
                print("MSG: This json was sended: \(self.jsonObject)")
                print("MSG: Succesfully sended")
//                self.doneBtnPressed()
            }
        }
        
    }
    
    func doneBtnPressed() {
        // cod for checking correctness of email and password
        performSegue(withIdentifier: "ChildOrParentVCSegue", sender: self)
    }
    
    func getData() -> Bool {
        if pwdSame() {
            jsonObject = [
                "action": "reg",
                "email": "\((emailTF.text)!)",
                "password": "\((passwordTF.text)!)"
            ]
            return true
        }
        return false
    }
    
    func pwdSame() -> Bool {
        if isEmptyTF() && (passwordTF.text == repeatPasswordTF.text) {
            return true
        } else {
            return false
        }
    }
    
    func isEmptyTF() -> Bool {
        if emailTF.text == nil {
            return false
        }
        if passwordTF.text == nil {
            return false
        }
        if repeatPasswordTF.text == nil {
            return false
        }
        return true
    }
    
}

// Delegations
extension RegisterVC {
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
            repeatPasswordTF.becomeFirstResponder()
            break
        case repeatPasswordTF:
            passwordTF.resignFirstResponder()
            registerBtnPressed(self)
            break
        default:
            emailTF.resignFirstResponder()
            view.endEditing(true)
            break
        }
        return true
    }
}
