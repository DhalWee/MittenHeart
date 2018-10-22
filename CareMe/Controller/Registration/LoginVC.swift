//
//  ViewController.swift
//  CareMe
//
//  Created by baytoor on 9/11/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import Starscream
import SwiftKeychainWrapper

class LoginVC: UIViewController, UITextFieldDelegate, WebSocketDelegate {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    var socket: WebSocket! = nil
    
    var jsonObject: Any  = []
    
    var action: String {
        if defaults.string(forKey: "role") == "parent" {
            return "auth"
        } else {
            return "auth_kid"
        }
    }
    
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
        errorLbl.isHidden = true
        emailTF.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailTF.text = ""
        passwordTF.text = ""
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
    //Sending log in information to web socket
    @IBAction func loginBtnPressed (_ sender: Any) {
        if getData() {
            sendJson(jsonObject) {
                print("MSG: Succesfully sended to websocket")
            }
            if !socket.isConnected {
                socket.connect()
            }
        }
    }
    
    func nextPage() {
        // cod for checking correctness of email and password
        if defaults.string(forKey: "role") == "parent" {
            performSegue(withIdentifier: "MenuVCSegue", sender: self)
        } else {
            performSegue(withIdentifier: "ChildMenuVCSegue", sender: self)
        }
        
    }
    //Setting all info from tf to JSON format
    func getData() -> Bool {
        if isEmptyTF() {
            jsonObject = [
                "action": action,
                "email": "\((emailTF.text)!)",
                "password": "\((passwordTF.text)!)"
            ]
            return true
        }
        return false
    }
    //Checking if all textfield are filled
    func isEmptyTF() -> Bool {
        if emailTF.text == nil {
            return false
        }
        if passwordTF.text == nil {
            return false
        }
        return true
    }
    
    func errorWithText(_ err: String) {
        errorLbl.text = err
        errorLbl.isHidden = false
    }
}

//Delegations
extension LoginVC {
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("MSG:\(text)")
        do {
            let data = text.data(using: .utf8)!
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
            
            if let sid = jsonObject?["sid"] as? String {
                defaults.set(sid, forKey: "sid")
                let saveSuccessful: Bool = KeychainWrapper.standard.set(sid, forKey: keyUID)
                if saveSuccessful {
                    print("MSG: Data saved to keychain")
                }
                self.nextPage()
            }
            
            if let err = jsonObject?["error"] as? String {
                self.errorWithText(err)
            }
            
        } catch let error as NSError {
            print("MSG: json error \(error)")
        }

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
            loginBtnPressed(self)
            break
        default:
            emailTF.resignFirstResponder()
            view.endEditing(true)
            break
        }
        return true
    }
}
