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
    
    var updateTimer: Timer!
    
    var isFirst: Bool = true
    
    var jsonObject: Any  = []
    var jsonKidsList: Any = [
        "action": "kids_list",
        "session_id": defaults.string(forKey: "sid")!
    ]
    
    var kids: [Kid] = []
    
    var tabBarIndex = 0
    
    //Map stuffs
    var mapView: GMSMapView!
    let marker = GMSMarker()
    var camera = GMSCameraPosition()
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 11
    
    var currentCoordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(exactly: 43.243713)!,
                                                        longitude: CLLocationDegrees.init(exactly: 76.918042)!)
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    
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
        updateTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(updateInformation), userInfo: nil, repeats: true)
        UIApplication.shared.statusBarStyle = .default
        tabBarBtnPressed(homeBtn)
        chatBtn.imageView?.image = UIImage(named: "\(chatBtn.tag)Inactive")
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer.invalidate()
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let url = URL(string: "ws://195.93.152.96:11210")!
        socket = WebSocket(url: url)
        socket.delegate = self
        socket.connect()
        
        mapFunction(currentCoordinate, isFirst)
        
    }

}

//Map functions
extension HomeVC {
    @IBAction func zoomIn(_ sender: Any) {
        let update = GMSCameraUpdate.zoomIn()
        mapView.animate(with: update)
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        let update = GMSCameraUpdate.zoomOut()
        mapView.animate(with: update)
    }
    
    @IBAction func centerMap(_ sender: Any) {
        let update = GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: currentCoordinate.latitude,
                                                                      longitude: currentCoordinate.longitude))
        mapView.animate(with: update)
    }
    
    func newChildMarkerView(_ kid: Kid) -> UIView {
        
        let backView: UIView = {
            let bv = UIView()
            bv.layer.masksToBounds = true
            bv.autoSetDimensions(to: CGSize(width: 36, height: 45))
            bv.backgroundColor = UIColor.clear
            return bv
        }()
        
        let markerImg: UIImageView = {
            let img = UIImage(named: "mapMarker")
            let imgView = UIImageView(image: img)
            imgView.clipsToBounds = true
            imgView.autoSetDimensions(to: CGSize(width: 36, height: 45))
            imgView.backgroundColor = UIColor.clear
            return imgView
        }()
        
        let childImgView: UIImageView = {
            let imgView = UIImageView(image: UIImage(named: "\(kid.imgUrlString)"))
            imgView.clipsToBounds = true
            imgView.backgroundColor = UIColor.clear
            imgView.autoSetDimensions(to: CGSize(width: 28, height: 28))
            return imgView
        }()
        
        let lettersView: UIView = {
            let bv = UIView()
            bv.clipsToBounds = true
            bv.backgroundColor = UIColor(hex: 0xfcfcfc)
            bv.layer.cornerRadius = 14
            bv.autoSetDimensions(to: CGSize(width: 28, height: 28))
            return bv
        }()

        let lettersLbl: UILabel = {
            let lbl = UILabel()
            lbl.text = kid.name[0..<2]
            lbl.font = UIFont(name: "Montserrat-Medium", size: 12)
            return lbl
        }()
        
        lettersView.addSubview(lettersLbl)
        backView.addSubview(markerImg)
        backView.addSubview(lettersView)
        backView.addSubview(childImgView)
        
        lettersLbl.autoAlignAxis(.vertical, toSameAxisOf: lettersView)
        lettersLbl.autoAlignAxis(.horizontal, toSameAxisOf: lettersView)
        
        lettersView.autoPinEdge(.top, to: .top, of: backView, withOffset: 4)
        lettersView.autoAlignAxis(.vertical, toSameAxisOf: backView)
        
        childImgView.autoPinEdge(.top, to: .top, of: backView, withOffset: 4)
        childImgView.autoAlignAxis(.vertical, toSameAxisOf: backView)
        
        if kid.imgUrlString == "" {
            childImgView.isHidden = true
            lettersView.isHidden = false
        } else {
            childImgView.isHidden = false
            lettersView.isHidden = true
        }
        
        return backView
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
    
//    ========================= Map repairing
    
    func setRadius(_ coordinate: CLLocationCoordinate2D,_ accuracy: Double,_ color: UIColor) {
        let circ = GMSCircle(position: coordinate, radius: CLLocationDistance(accuracy))
        circ.fillColor = color
        circ.strokeColor = UIColor.clear
        circ.strokeWidth = 0
        circ.map = mapView
    }
    
    func setChildMarker(_ kid: Kid) {
        let marker = GMSMarker()
        let latitude: Double = Double(kid.kidInfo.latitude)!
        let longitude: Double = Double(kid.kidInfo.longitude)!
        
        let coordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(latitude),
                                                        longitude: CLLocationDegrees.init(longitude))
        //Set child's photo
        let newMarker = newChildMarkerView(kid)
        marker.iconView = newMarker
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.map = mapView
//        setRadius(coordinate, Double(kid.kidInfo.accuracy)!, UIColor(hex: green, alpha: 0.2))
    }
    
    func putKidsToMap() {
        for kid in kids {
            let latitude: Double = Double(kid.kidInfo.latitude)!
            let longitude: Double = Double(kid.kidInfo.longitude)!
            
            currentCoordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(latitude),
                                                            longitude: CLLocationDegrees.init(longitude))
            
            setChildMarker(kid)
        }
    }
    
    func mapFunction(_ location: CLLocationCoordinate2D,_ isfirst: Bool) {
        
        var zoom:Float = zoomLevel
        var viewingAngle:Double = 0
        var bearing:CLLocationDirection = CLLocationDirection(exactly: 0)!
        
        if isFirst {
            isFirst = false
            zoom = zoomLevel
            viewingAngle = 0
            bearing = 0
        } else {
            zoom = mapView.camera.zoom
            viewingAngle = mapView.camera.viewingAngle
            bearing = mapView.camera.bearing
        }
        
        placesClient = GMSPlacesClient.shared()
        
        camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                          longitude: location.longitude,
                                          zoom: zoom,
                                          bearing: bearing,
                                          viewingAngle: viewingAngle)
        
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
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        listLikelyPlaces()
        
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
        
        addLineToView(view: tabBarView, position: .top, color: UIColor(hex: lightGray), width: 0.5)
        
        tableView.autoPinEdge(.leading, to: .leading, of: bottomView)
        tableView.autoPinEdge(.trailing, to: .trailing, of: bottomView)
        tableView.autoPinEdge(.top, to: .top, of: bottomView)
        tableView.autoPinEdge(.bottom, to: .bottom, of: bottomView)
        
    }
    
    func tabBarColor(_ btn: UIButton) {
        let tag = btn.tag
        homeBtn.imageView?.image = UIImage(named: "\(homeBtn.tag)Inactive")
        subscribeBtn.imageView?.image = UIImage(named: "\(subscribeBtn.tag)Inactive")
        chatBtn.imageView?.image = UIImage(named: "\(chatBtn.tag)Inactive")
        moreBtn.imageView?.image = UIImage(named: "\(moreBtn.tag)Inactive")
        settingsBtn.imageView?.image = UIImage(named: "\(settingsBtn.tag)Inactive")
        if tag == 5 {
            moreBtn.imageView?.image = UIImage(named: "\(moreBtn.tag)Active")
        } else if tag != 2 {
            btn.imageView?.image = UIImage(named: "\(tag)Active")
        }
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
            //Change the height of more functions 140/250 ToChange
            bottomController?.setAnchorPoint(anchor: CGFloat(99+140)/self.view.bounds.height)
            bottomController?.closePanel()
            bottomController?.anchorPanel()
            
        } else if tabBarIndex == 4 {
//            bottomController?.setAnchorPoint(anchor: CGFloat(self.view.bounds.height-64)/self.view.bounds.height)
            bottomController?.setAnchorPoint(anchor: CGFloat(99)/self.view.bounds.height)
            bottomController?.closePanel()
            bottomController?.anchorPanel()
        } else if tabBarIndex == 5 {
            //Settings of places instead of kids ToChange
            var anchor: Int {
                if kids.count > 0 {
                    return 99 + kids.count * 70
                } else {
                    return 99 + 70
                }
            }
            bottomController?.setAnchorPoint(anchor: CGFloat(anchor)/self.view.bounds.height)
            bottomController?.anchorPanel()
        }
        
        tableView.reloadData()
    }
    
    func chatBtnPressed(_ sender: Any) {
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
    
    @IBAction func headerBtnPressed() {
        if tabBarIndex == 0 {
            updateInformation()
        } else if tabBarIndex == 5 {
            print("MSG Adding ")
            performSegue(withIdentifier: "PlaceInMapViewSegue", sender: self)
        }
        
    }
    
    @IBAction func signOutBtnPressed() {
        signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InitialPage")
        self.show(vc!, sender: self)
    }
    
    
    
    @objc func updateInformation() {
        if socket.isConnected {
            if defaults.string(forKey: "kidID0") != nil {
                sendJson(jsonKidsList) {}
            }
        } else {
            socket.connect()
        }
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
    
    func kidsListParse(_ jsonObject: NSDictionary) {

        let count = jsonObject.count-1
        print("Kid count: \(count)")
        defaults.set(count, forKey: "kidCount")

        kids.removeAll()
        for i in 0..<count {
            let kid = jsonObject["\(i)"] as? NSDictionary
            let kidID = kid!["id"] as? String
            defaults.set(kidID, forKey: "kidID\(i)")

            let name = kid!["name"] as? String
            let surname = kid!["lastname"] as? String
            
            print("Kid id: \(kidID!)")
            
            let date = kid!["date"] as? String
            let latitude = kid!["latitude"] as? String
            let longitude = kid!["longitude"] as? String
            let batteryState = kid!["batteryState"] as? String
            let batteryLevel = kid!["batteryLevel"] as? String
            let course = kid!["course"] as? String
            let accuracy = kid!["accuracy"] as? String
            let avatar = kid!["avatar"] as? String
            
            let newKidInfo = KidInfo(kidID!, batteryLevel!, batteryState!, longitude! , latitude!, course!, date!, accuracy!)
            
            let newKid = Kid(kidID!, name!, surname!, avatar!, newKidInfo)
            kids.append(newKid)
        }
        let kidInfo1 = KidInfo("3", "53", "Charging", "76.86022583395243", "43.20581023751256", "1", "afa", "30")
        let kid1 = Kid("3", "Testing", "kid", "OvalMini", kidInfo1)
        kids.append(kid1)
        putKidsToMap()
        tableView.reloadData()
        

    }
    
}

//Websocket Delegate 
extension HomeVC {
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
        if defaults.string(forKey: "kidID0") != nil {
            sendJson(jsonKidsList) {
                print("MSG: Successfully sended")
                print(self.jsonKidsList)
            }
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("MSG:\(text)")
        do {
            let data = text.data(using: .utf8)!
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary

            if let action = jsonObject?["action"] as? String {
                if action == "kids_list" {
                    kidsListParse(jsonObject!)
                }
            }
            
            
        } catch let error as NSError {
            print("MSG: json error \(error)")
        }
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}

//Table View Delegates and DataSources
extension HomeVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabBarIndex == 0 {
            return kids.count+2
            //HTC Else if tabBarIndex others must be here
        } else if tabBarIndex == 1 {
            //Settings
            return 2
        } else if tabBarIndex == 3 {
            //More functions
            return 2
        } else if tabBarIndex == 4 {
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "addKidCell", for: indexPath) as! addKidCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "kidCell", for: indexPath) as! kidCell
                let kid = kids[indexPath.row-1]
                cell.setKid(kid.name, kid.surname, "Данные получены 3 минуты назад", kid.imgUrlString, kid.kidInfo.batteryLevel)
                return cell
            }
        } else if tabBarIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "repairCell", for: indexPath) as! repairCell
            return cell
        } else if tabBarIndex == 3 && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreFunctionsCell", for: indexPath) as! moreFunctionsCell
            return cell
            //HTC Else if tabBarIndex others must be here
        } else if tabBarIndex == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! settingsCell
            return cell
        } else if tabBarIndex == 5 {
            return UITableViewCell()
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
            //HTC Else if tabBarIndex others must be here
        } else if tabBarIndex == 3 && indexPath.row == 1 {
            //Change the height of more functions 140/240 ToChange
            return 140
        } else if tabBarIndex == 1 || tabBarIndex == 4 {
            return CGFloat(self.view.bounds.height-180)
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
