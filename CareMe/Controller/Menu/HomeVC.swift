//
//  HomeVC.swift
//  CareMe
//
//  Created by baytoor on 9/15/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import CTSlidingUpPanel

class HomeVC: UIViewController, CTBottomSlideDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBarView: UIView!
    
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    
    var bottomController:CTBottomSlideController?;
    
    let kids: [Child] = [Child.init("Адлет Касымхан", "Данные получены 3 мин назад ", "Oval1"),
                             Child.init("Саяна Касымхан", "Данные получены 5 мин назад ", "Oval2")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSettings()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kids.count+2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! headerCell
            cell.setLineTop(false)
            return cell
        } else if indexPath.row == kids.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addChildCell", for: indexPath) as! addChildCell
            cell.setLineTop(false)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "childCell", for: indexPath) as! childCell
            let child = kids[indexPath.row-1]
            cell.setChild(child.nameAndSurname, child.desc, child.imgName)
            cell.setLineTop(false)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            return 70
        }
    }
    
    func didPanelCollapse() {}
    func didPanelExpand() {}
    func didPanelAnchor() {}
    func didPanelMove(panelOffset: CGFloat) {}

    func uiSettings() {
        bottomController?.delegate = self;
        bottomController = CTBottomSlideController(parent: view, bottomView: bottomView, tabController: nil,
                                                   navController: nil, visibleHeight: 99)
        bottomController?.setExpandedTopMargin(pixels: 64)
        var anchor: Int {
            if kids.count > 0 {
                return 99 + kids.count * 70
            } else {
                return 99 + 70
            }
        }
        bottomController?.setAnchorPoint(anchor: CGFloat(anchor)/self.view.bounds.height)
        bottomController?.set(table: tableView)
        
        bottomView.roundCorners([.topLeft, .topRight], radius: 20)
        tableView.roundCorners([.topLeft, .topRight], radius: 20)
        
        addLineToView(view: tabBarView, position: .LINE_POSITION_TOP, color: UIColor(hex: lightGray), width: 0.5)
    }
    
}
