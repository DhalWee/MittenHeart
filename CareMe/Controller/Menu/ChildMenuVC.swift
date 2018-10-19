//
//  ChildMenuVC.swift
//  CareMe
//
//  Created by baytoor on 10/10/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import MapKit
import Starscream

class ChildMenuVC: UIViewController, CLLocationManagerDelegate, WebSocketDelegate {
    
    @IBOutlet weak var lbl: UILabel!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    var socket: WebSocket! = nil
    
    var jsonObject: Any  = []
    
    var lastLoc = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        locationManager = CLLocationManager()        
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
        
        let url = URL(string: "ws://195.93.152.96:11210")!
        socket = WebSocket(url: url)
        socket.delegate = self
        socket.connect()
        
    }
    
}

// Functions
extension ChildMenuVC {
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "ChatVCSegue", sender: self)
    }
    
    @IBAction func sosBtnPressed(_ sender: Any) {
        alert(title: "SOS", message: "Подтвердите действие")
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertCancel = UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
        let alertAction = UIAlertAction.init(title: "Подтвердить", style: .default) { (UIAlertAction) in
            //SOS btn action
        }
        
        alertController.addAction(alertAction)
        alertController.addAction(alertCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func getData(_ location: CLLocation, complition: (() -> Void)!) {
        let batteryLevel = Int (UIDevice.current.batteryLevel * 100)
        var batteryState: String {
            switch UIDevice.current.batteryState {
            case .charging:
                return "Charging"
            case .full:
                return "Full"
            case .unknown:
                return "Unknown"
            case .unplugged:
                return "Unplugged"
            default:
                return ""
            }
        }
        lbl.text = "Level: \(batteryLevel)\nState \(batteryState)"
        
        let longitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude
        let course = location.course
        let speed = location.speed
        let time = location.timestamp
        var accuracy: CLLocationAccuracy {
            if location.horizontalAccuracy>location.verticalAccuracy {
                return location.horizontalAccuracy
            } else {
                return location.verticalAccuracy
            }
        }
        
        jsonObject = [
            "action": "sendKidData",
            "session_id": defaults.string(forKey: "sid")!,
            "kid_id": "1",
            "batteryLevel": batteryLevel,
            "batteryState": batteryState,
            "longitude": longitude,
            "latitude": latitude,
            "course": course,
            "speed": speed,
            "time": time,
            "accuracy": accuracy
        ]
        complition()
    }
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func sendJson(_ value: Any, onSuccess: @escaping ()-> Void) {
        guard JSONSerialization.isValidJSONObject(value) else {
            print("[WEBSOCKET] Value is not a valid JSON object.\n \(value)")
            return
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: value, options: [])
            socket.write(data: data) {
                onSuccess()
            }
        } catch let error {
            print("[WEBSOCKET] Error serializing JSON:\n\(error)")
        }
    }
    
    
    
}

// Delegates
extension ChildMenuVC {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        getData(location) {
            print(self.jsonObject)
            self.sendJson(self.jsonObject, onSuccess: {
                print("MSG: Succesfully sended")
            })
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
        getData(locationManager.location!) {
            print(self.jsonObject)
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print(text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
}
