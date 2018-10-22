//
//  ChildOrParentVC.swift
//  CareMe
//
//  Created by baytoor on 9/11/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit

class ChildOrParentVC: UIViewController {
    
    @IBOutlet weak var parentBtn: UIButton!
    @IBOutlet weak var childBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        uiStuffs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaults.removeObject(forKey: "role")
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func uiStuffs() {
        parentBtn.layer.cornerRadius = 5
        childBtn.layer.cornerRadius = 5
    }

    @IBAction func nextBtnPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            defaults.set("parent", forKey: "role")
        } else {
            defaults.set("kid", forKey: "role")
        }
        performSegue(withIdentifier: "LoginOrRegisterVCSegue", sender: self)
    }
}
