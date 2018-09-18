//
//  ParentVC.swift
//  CareMe
//
//  Created by baytoor on 9/14/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit

class ParentVC: UIViewController {

    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var thirdLbl: UILabel!
    @IBOutlet weak var fourthLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiStuffs()
        addLineToView(view: firstLbl, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        addLineToView(view: secondLbl, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        addLineToView(view: thirdLbl, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
        addLineToView(view: fourthLbl, position: LINE_POSITION.LINE_POSITION_BOTTOM, color: UIColor.init(hex: navy), width: 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    func uiStuffs() {
        firstLbl.text = "5"
        secondLbl.text = "1"
        thirdLbl.text = "3"
        fourthLbl.text = "8"
        
    }

}
