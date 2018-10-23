//
//  HomeVC.swift
//  CareMe
//
//  Created by baytoor on 9/15/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

//Daisy disk

import UIKit
import CTSlidingUpPanel
import MapKit
import GoogleMaps
import GooglePlaces
import PureLayout
import Starscream

//Initializing and variables
class HomeVC: UIViewController, CTBottomSlideDelegate, UITableViewDelegate, UITableViewDataSource, WebSocketDelegate {
    
    @IBOutlet weak var mapMarker: UIView!
    @IBOutlet weak var mapViewer: UIView!
    
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
    
    var socket: WebSocket! = nil
    
    var jsonObject: Any  = []
    var jsonGetGeo: Any = [
        "action": "get_geo",
        "session_id": defaults.string(forKey: "sid")!,
        "kid_id": defaults.integer(forKey: "kidID")
        
    ]
    
    let kids: [Kid] = [Kid.init("1", "Адлет", "Касымхан", "Данные получены 3 мин назад ", "Oval1"),
                         Kid.init("2", "Саяна", "Касымхан", "Данные получены 5 мин назад ", "Oval2")]
    var tabBarIndex = 0
    
    //Map stuffs
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15
    
    var lastLoc = CLLocation()
    let lastCoordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(exactly: 43.243703)!,
                                                     longitude: CLLocationDegrees.init(exactly: 76.918052)!)
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSettings()
        mapFunction()
        
        tabBarBtnPressed(homeBtn)
        tableView.delegate = self
        tableView.dataSource = self
        bottomController?.delegate = self
        
        sendJson(jsonObject) {
            print("MSG: Successfully sended")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        tabBarBtnPressed(homeBtn)
        chatBtn.imageView?.image = UIImage(named: "\(chatBtn.tag)Inactive")
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setMap()
        let url = URL(string: "ws://195.93.152.96:11210")!
        socket = WebSocket(url: url)
        socket.delegate = self
        socket.connect()
    }

}

//Functions
extension HomeVC {
    func uiSettings() {
        
        bottomController = CTBottomSlideController(parent: view, bottomView: bottomView, tabController: nil, navController: nil, visibleHeight: 99)
        
        bottomController?.setExpandedTopMargin(pixels: 64)
        bottomController?.set(table: tableView)
        bottomController?.setAnchorPoint(anchor: CGFloat(0))
        
        bottomView.bounds.size.width = self.view.frame.width
        tableView.bounds.size.width = self.view.frame.width
        
        bottomView.roundCorners([.topLeft, .topRight], radius: 20)
        tableView.roundCorners([.topLeft, .topRight], radius: 20)
        
        addLineToView(view: tabBarView, position: .LINE_POSITION_TOP, color: UIColor(hex: lightGray), width: 0.5)
        
        tableView.autoPinEdge(.leading, to: .leading, of: bottomView)
        tableView.autoPinEdge(.trailing, to: .trailing, of: bottomView)
        tableView.autoPinEdge(.top, to: .top, of: bottomView)
        tableView.autoPinEdge(.bottom, to: .bottom, of: bottomView)
        
        
    }
    
    func tabBarColor(_ btn: UIButton) {
        homeBtn.imageView?.image = UIImage(named: "\(homeBtn.tag)Inactive")
        subscribeBtn.imageView?.image = UIImage(named: "\(subscribeBtn.tag)Inactive")
        chatBtn.imageView?.image = UIImage(named: "\(chatBtn.tag)Inactive")
        moreBtn.imageView?.image = UIImage(named: "\(moreBtn.tag)Inactive")
        settingsBtn.imageView?.image = UIImage(named: "\(settingsBtn.tag)Inactive")
        btn.imageView?.image = UIImage(named: "\(btn.tag)Active")
    }
    
    @IBAction func tabBarBtnPressed(_ sender: UIButton) {
        tabBarIndex = sender.tag
        tabBarColor(sender)
        
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
            bottomController?.anchorPanel()
            
        } else if tabBarIndex == 1 {
            bottomController?.setAnchorPoint(anchor: CGFloat(self.view.bounds.height-64)/self.view.bounds.height)
            bottomController?.closePanel()
            bottomController?.expandPanel()
            
        } else if tabBarIndex == 2 {
            chatBtnPressed(sender)
            
        } else if tabBarIndex == 3 {
            bottomController?.setAnchorPoint(anchor: CGFloat(99+140)/self.view.bounds.height)
            bottomController?.closePanel()
            bottomController?.anchorPanel()
            
        } else if tabBarIndex == 4 {
//            bottomController?.setAnchorPoint(anchor: CGFloat(self.view.bounds.height-64)/self.view.bounds.height)
            bottomController?.setAnchorPoint(anchor: CGFloat(99)/self.view.bounds.height)
            bottomController?.closePanel()
            bottomController?.anchorPanel()
        }
        
        tableView.reloadData()
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
        signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InitialPage")
        self.show(vc!, sender: self)
//        performSegue(withIdentifier: "SendSignalVCSegue", sender: self)
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        let update = GMSCameraUpdate.zoomIn()
        mapView.animate(with: update)
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        let update = GMSCameraUpdate.zoomOut()
        mapView.animate(with: update)
    }
    
    @IBAction func centerMap(_ sender: Any) {
        let coordinate = lastCoordinate
        let update = GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                                      longitude: coordinate.longitude))
        mapView.animate(with: update)
        
    }

    func mapFunction() {
        
        placesClient = GMSPlacesClient.shared()
        
        let camera = GMSCameraPosition.camera(withLatitude: lastCoordinate.latitude,
                                              longitude: lastCoordinate.longitude,
                                              zoom: zoomLevel)
        
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        mapViewer.addSubview(mapView)
        mapView.autoPinEdge(.bottom, to: .bottom, of: mapViewer)
        mapView.autoPinEdge(.top, to: .top, of: mapViewer)
        mapView.autoPinEdge(.right, to: .right, of: mapViewer)
        mapView.autoPinEdge(.left, to: .left, of: mapViewer)
        mapView.isHidden = true
    }
    
    func setMap() {
        let camera = GMSCameraPosition.camera(withLatitude: lastCoordinate.latitude,
                                              longitude: lastCoordinate.longitude,
                                              zoom: zoomLevel)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lastCoordinate.latitude,
                                                 longitude: lastCoordinate.longitude)
        marker.iconView = mapMarker
        marker.map = mapView
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        listLikelyPlaces()

    }
    
    func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                }
            }
        })
        print(likelyPlaces)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if tabBarIndex == 0 &&
            ((tableView.indexPathForSelectedRow?.row)! > 0 && (tableView.indexPathForSelectedRow?.row)! <= kids.count ) {
            let destination = segue.destination as! ChildVC
            destination.kid = kids[(tableView.indexPathForSelectedRow?.row)!-1]
        }
    }
    
    func sendJson(_ value: Any, onSuccess: @escaping ()-> Void) {
        guard JSONSerialization.isValidJSONObject(value) else {
            print("[WEBSOCKET] Value is not a valid JSON object.\n \(value)")
            return
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: value, options: [])
            if socket.isConnected {
                socket.write(data: data) {
                    print("MSG: Successfully sended")
                    onSuccess()
                }
            }
        } catch let error {
            print("[WEBSOCKET] Error serializing JSON:\n\(error)")
        }
    }
    
}

//Table View Delegates and DataSources
extension HomeVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabBarIndex == 0 {
            return kids.count+2
        //HTC Else if tabBarIndex others must be here
        } else if tabBarIndex == 3 {
            //More functions
            return 2
        } else if tabBarIndex == 1 || tabBarIndex == 4 {
            //Settings
            return 1
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "addKidCell", for: indexPath) as! addKidCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "kidCell", for: indexPath) as! kidCell
                let kid = kids[indexPath.row-1]
                cell.setKid(kid.nameAndSurname, kid.desc, kid.imgUrlString)
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
        } else if tabBarIndex == 1 || tabBarIndex == 3 || tabBarIndex == 4 {
            return 320
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tabBarIndex == 0 {
            if indexPath.row > 0 && indexPath.row <= kids.count {
                performSegue(withIdentifier: "ChildVCSegue", sender: self)
            } else if indexPath.row == kids.count+1 {
                performSegue(withIdentifier: "NewChildVCSegue", sender: self)
                print("MSG: Adding child")
            }
        } else if tabBarIndex == 3 {
            
        }
    }
    
    func didPanelCollapse() {}
    func didPanelExpand() {}
    func didPanelAnchor() {}
    func didPanelMove(panelOffset: CGFloat) {}
    
}
//Websocket Delegate 
extension HomeVC {
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("MSG:\(text)")
//        do {
//            let data = text.data(using: .utf8)!
//            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
//
//        } catch let error as NSError {
//            print("MSG: json error \(error)")
//        }
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}


////Map delegates
//extension HomeVC {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location: CLLocation = locations.last!
//        lastLoc = location
//        print("MSG Location: \(location)")
//
//        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                              longitude: location.coordinate.longitude,
//                                              zoom: zoomLevel)
//
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
//                                                 longitude: location.coordinate.longitude)
//        marker.iconView = mapMarker
//        marker.map = mapView
//
//        if mapView.isHidden {
//            mapView.isHidden = false
//            mapView.camera = camera
//        } else {
//            mapView.animate(to: camera)
//        }
//
//        listLikelyPlaces()
//    }
//
//    // Handle authorization for the location manager.
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .restricted:
//            print("Location access was restricted.")
//        case .denied:
//            print("User denied access to location.")
//            // Display the map using the default location.
//            mapView.isHidden = false
//        case .notDetermined:
//            print("Location status not determined.")
//        case .authorizedAlways: fallthrough
//        case .authorizedWhenInUse:
//            print("Location status is OK.")
//        }
//    }
//
//    // Handle location manager errors.
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
//        print("Error: \(error)")
//    }
//}
