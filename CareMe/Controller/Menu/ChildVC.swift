//
//  ChildVC.swift
//  CareMe
//
//  Created by baytoor on 9/20/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit

class ChildVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTF.isEnabled = false
        surnameTF.isEnabled = false
        
    }
    
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "ChatVCSegue", sender: self)
    }
    
    @IBAction func movementBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "MovementVCSegue", sender: self)
    }
    
    @IBAction func soundAroundBtnPressed (_ sender: Any) {
        performSegue(withIdentifier: "SoundAroundVCSegue", sender: self)
    }
    
    @IBAction func sendSignalBtnPressed (_ sender: Any) {
        performSegue(withIdentifier: "SendSignalVCSegue", sender: self)
    }

    

}
