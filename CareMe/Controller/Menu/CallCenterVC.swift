//
//  CallCenterView.swift
//  CareMe
//
//  Created by baytoor on 11/8/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit

class CallCenterVC: UIViewController {
    
    @IBOutlet weak var btn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        btn.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    @IBAction func callBtnPressed(_ sender: Any){
        if let url = URL(string: "TEL://87014557050") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let urlString = "telprompt:87014557050";
                let url = NSURL(fileURLWithPath: urlString);
                if UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        }
    }


}
