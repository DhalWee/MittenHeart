//
//  ViewController.swift
//  CareMe
//
//  Created by baytoor on 9/11/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit

class LoginOrRegisterVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiStuffs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func uiStuffs() {
        loginBtn.layer.cornerRadius = 5
        registerBtn.layer.cornerRadius = 5
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        endEditing()
        performSegue(withIdentifier: "LoginVCSegue", sender: self)
    }
    
    @IBAction func regBtnPressed(_ sender: Any) {
        endEditing()
        performSegue(withIdentifier: "RegisterVCSegue", sender: self)
    }
}

