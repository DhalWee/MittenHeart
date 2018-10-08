//
//  RegisterVC.swift
//  CareMe
//
//  Created by baytoor on 9/24/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var repeatPasswordTF: UITextField!
    
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
    
    func uiStuffs() {
        addLineToView(view: emailTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 1)
        addLineToView(view: passwordTF, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 1)
        
        emailTF.delegate = self
        passwordTF.delegate = self
        repeatPasswordTF.delegate = self
    }
    
    @IBAction func registerBtnPressed (_ sender: Any) {
        doneBtnPressed()
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
            doneBtnPressed()
            break
        default:
            emailTF.resignFirstResponder()
            view.endEditing(true)
            break
        }
        return true
    }
    
    func doneBtnPressed() {
        // cod for checking correctness of email and password
        performSegue(withIdentifier: "ChildOrParentVCSegue", sender: self)
    }

}
