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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var bottomController:CTBottomSlideController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomController?.delegate = self;
        //You can provide nil to tabController and navigationController
        bottomController = CTBottomSlideController(parent: view, bottomView: bottomView,
                                                   tabController: nil,
                                                   navController: nil, visibleHeight: 64)
        bottomController?.setExpandedTopMargin(pixels: 64)
        bottomController?.setAnchorPoint(anchor: 0.3)
        bottomController?.set(table: tableView)
        
    }
    
    func didPanelCollapse() {}
    func didPanelExpand() {}
    func didPanelAnchor() {}
    func didPanelMove(panelOffset: CGFloat) {}

}
