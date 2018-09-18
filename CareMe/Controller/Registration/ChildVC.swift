//
//  ChildVC.swift
//  CareMe
//
//  Created by baytoor on 9/11/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit

class ChildVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var thirdTF: UITextField!
    @IBOutlet weak var fourthTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTF.addTarget(self, action: #selector(self.textFieldDidChange(_ :)), for: UIControl.Event.editingChanged)
        secondTF.addTarget(self, action: #selector(self.textFieldDidChange(_ :)), for: UIControl.Event.editingChanged)
        thirdTF.addTarget(self, action: #selector(self.textFieldDidChange(_ :)), for: UIControl.Event.editingChanged)
        fourthTF.addTarget(self, action: #selector(self.textFieldDidChange(_ :)), for: UIControl.Event.editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        firstTF.becomeFirstResponder()
        highlighTextField(firstTF, true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addLineToView(view: textField, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: green), width: 2)
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
                performSegue(withIdentifier: "MainVCSegue", sender: self)
                highlighTextField(fourthTF, false)
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
    
    func highlighTextField(_ textField: UITextField, _ highlight: Bool) {
        addLineToView(view: firstTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        addLineToView(view: secondTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        addLineToView(view: thirdTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        addLineToView(view: fourthTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        if highlight {
            addLineToView(view: textField, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: green), width: 2)
        }
    }


}
