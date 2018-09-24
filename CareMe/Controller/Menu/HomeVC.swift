//
//  HomeVC.swift
//  CareMe
//
//  Created by baytoor on 9/15/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import CTSlidingUpPanel
import MapKit
import GoogleMaps

//Initializing and variables
class HomeVC: UIViewController, CTBottomSlideDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBarView: UIView!
    
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    
    var bottomController:CTBottomSlideController?;
    
    var homeBtnSelected: Bool = true
    var subscribeBtnSelected: Bool = false
    var chatBtnSelected: Bool = false
    var moreBtnSelected: Bool = false
    var settingsBtnSelected: Bool = false
    
    let kids: [Child] = [Child.init("Адлет Касымхан", "Данные получены 3 мин назад ", "Oval1"),
                         Child.init("Саяна Касымхан", "Данные получены 5 мин назад ", "Oval2")]
    var tabBarIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSettings()
        
        tabBarBtnPressed(homeBtn)
        
        tableView.delegate = self
        tableView.dataSource = self
        bottomController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

}

//Functions
extension HomeVC {
    func uiSettings() {
        bottomController = CTBottomSlideController(parent: view, bottomView: bottomView, tabController: nil,
                                                   navController: nil, visibleHeight: 99)
        bottomController?.setExpandedTopMargin(pixels: 64)
        bottomController?.set(table: tableView)
        
        bottomView.roundCorners([.topLeft, .topRight], radius: 20)
        tableView.roundCorners([.topLeft, .topRight], radius: 20)
        
        addLineToView(view: tabBarView, position: .LINE_POSITION_TOP, color: UIColor(hex: lightGray), width: 0.5)
    }
    
    @IBAction func tabBarBtnPressed(_ sender: UIButton) {
        tabBarIndex = sender.tag
        
        //Setting height of contentView
        if tabBarIndex == 0 {
            var anchor: Int {
                if kids.count > 0 {
                    return 99 + kids.count * 70
                } else {
                    return 99 + 70
                }
            }
            bottomController?.setAnchorPoint(anchor: CGFloat(anchor)/self.view.bounds.height)
            bottomController?.closePanel()
            bottomController?.anchorPanel()
        } else if tabBarIndex == 1 {
            bottomController?.setAnchorPoint(anchor: CGFloat(self.view.bounds.height-64)/self.view.bounds.height)
            bottomController?.closePanel()
            bottomController?.expandPanel()
        } else if tabBarIndex == 3 {
            bottomController?.setAnchorPoint(anchor: CGFloat(99+140)/self.view.bounds.height)
            bottomController?.closePanel()
            bottomController?.anchorPanel()
        } else {
            bottomController?.setAnchorPoint(anchor: CGFloat(99+70)/self.view.bounds.height)
            bottomController?.closePanel()
            bottomController?.anchorPanel()
        }
        
        homeBtn.imageView?.image = UIImage(named: "\(homeBtn.tag)Inactive")
        subscribeBtn.imageView?.image = UIImage(named: "\(subscribeBtn.tag)Inactive")
        chatBtn.imageView?.image = UIImage(named: "\(chatBtn.tag)Inactive")
        moreBtn.imageView?.image = UIImage(named: "\(moreBtn.tag)Inactive")
        settingsBtn.imageView?.image = UIImage(named: "\(settingsBtn.tag)Inactive")
        sender.imageView?.image = UIImage(named: "\(sender.tag)Active")
        
        tableView.reloadData()
    }
    
}

//Delegates and DataSources
extension HomeVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabBarIndex == 0 {
            return kids.count+2
        //HTC Else if tabBarIndex others must be here
        } else if tabBarIndex == 3 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //HeaderCell Identification
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! headerCell
            cell.setHeader(tabBarIndex)
            return cell
        }
        if tabBarIndex == 0 {
            //ChildTabBar Identification
            if indexPath.row == kids.count + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addChildCell", for: indexPath) as! addChildCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "childCell", for: indexPath) as! childCell
                let child = kids[indexPath.row-1]
                cell.setChild(child.nameAndSurname, child.desc, child.imgName)
                return cell
            }
        } else if tabBarIndex == 3 && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreFunctionsCell", for: indexPath) as! moreFunctionsCell
            return cell
        //HTC Else if tabBarIndex others must be here
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        //HTC Else if tabBarIndex others must be here
        } else if tabBarIndex == 3 && indexPath.row == 1 {
            return 140
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tabBarIndex == 0 {
            performSegue(withIdentifier: "ChildVCSegue", sender: self)
        } else if tabBarIndex == 3 {
            
        }
    }
    
    func didPanelCollapse() {}
    func didPanelExpand() {}
    func didPanelAnchor() {}
    func didPanelMove(panelOffset: CGFloat) {}
    
}
