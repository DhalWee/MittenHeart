//
//  HomeVC.swift
//  CareMe
//
//  Created by baytoor on 9/15/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import CTSlidingUpPanel

class HomeVC: UIViewController, CTBottomSlideDelegate {

    @IBOutlet weak var bottomView: UIView!
    
    var bottomController:CTBottomSlideController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
         bottomController?.delegate = self;
        //You can provide nil to tabController and navigationController
        bottomController = CTBottomSlideController(parent: view, bottomView: bottomView,
                                                   tabController: nil,
                                                   navController: nil, visibleHeight: 100)
        //0 is bottom and 1 is top. 0.5 would be center
        bottomController?.setAnchorPoint(anchor: 0.9)
        
    }
    
    func didPanelCollapse() {
        //
    }
    
    func didPanelExpand() {
        //
    }
    
    func didPanelAnchor() {
        //
    }
    
    func didPanelMove(panelOffset: CGFloat) {
        //
    }
    

}
