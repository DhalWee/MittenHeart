//
//  ChildVC.swift
//  CareMe
//
//  Created by baytoor on 9/20/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit

class ChildVC: UIViewController {
    
    var kid: Kid? = nil
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var imgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if kid != nil {
            nameTF.text = kid!.name
            surnameTF.text = kid!.surname
            imgView.image = UIImage(named: kid!.imgName)
        }

        nameTF.isEnabled = false
        surnameTF.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
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
