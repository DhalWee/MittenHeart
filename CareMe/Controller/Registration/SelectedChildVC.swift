//
//  ChildVC.swift
//  CareMe
//
//  Created by baytoor on 9/11/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import Starscream

class SelectedChildVC: UIViewController, UITextFieldDelegate, WebSocketDelegate {
    
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var thirdTF: UITextField!
    @IBOutlet weak var fourthTF: UITextField!
    
    var socket: WebSocket! = nil
    
    var jsonObject: Any  = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTF.addTarget(self, action: #selector(self.textFieldDidChange(_ :)), for: UIControl.Event.editingChanged)
        secondTF.addTarget(self, action: #selector(self.textFieldDidChange(_ :)), for: UIControl.Event.editingChanged)
        thirdTF.addTarget(self, action: #selector(self.textFieldDidChange(_ :)), for: UIControl.Event.editingChanged)
        fourthTF.addTarget(self, action: #selector(self.textFieldDidChange(_ :)), for: UIControl.Event.editingChanged)
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
        firstTF.becomeFirstResponder()
        highlighTextField(firstTF, true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addLineToView(view: textField, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: green), width: 2)
    }
    
    func highlighTextField(_ textField: UITextField, _ highlight: Bool) {
        addLineToView(view: firstTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        addLineToView(view: secondTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        addLineToView(view: thirdTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        addLineToView(view: fourthTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        if highlight {
            addLineToView(view: textField, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: green), width: 2)
        }
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
    
    func sendCode() {
        let code = "\(String(describing: firstTF.text))\(String(describing: secondTF.text))\(String(describing: thirdTF.text))\(String(describing: fourthTF.text))"
        jsonObject = [
            "action": "activate_code",
            "child_code": code
        ]
        sendJson(jsonObject) {
            self.nextPage()
        }
        
    }
    
    func nextPage() {
        performSegue(withIdentifier: "ChildMenuVCSegue", sender: self)
    }
    
}

//Delegations
extension SelectedChildVC {
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text
        if text?.utf16.count == 1 {
            switch textField {
            case firstTF:
                secondTF.becomeFirstResponder()
                highlighTextField(secondTF, true)
                break
            case secondTF:
                thirdTF.becomeFirstResponder()
                highlighTextField(thirdTF, true)
                break
            case thirdTF:
                fourthTF.becomeFirstResponder()
                highlighTextField(fourthTF, true)
                break
            case fourthTF:
                fourthTF.resignFirstResponder()
                self.nextPage()
                highlighTextField(fourthTF, false)
                sendCode()
                break
            default:
                break
            }
        } else if text?.utf16.count == 0 {
            switch textField {
            case fourthTF:
                thirdTF.becomeFirstResponder()
                highlighTextField(thirdTF, true)
                break
            case thirdTF:
                secondTF.becomeFirstResponder()
                highlighTextField(secondTF, true)
                break
            case secondTF:
                firstTF.becomeFirstResponder()
                highlighTextField(firstTF, true)
                break
            case firstTF:
                break
            default:
                break
            }
        } else {
            textField.deleteBackward()
        }
    }

}
