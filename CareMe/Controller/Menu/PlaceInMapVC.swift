//
//  PlaceInMapView.swift
//  CareMe
//
//  Created by baytoor on 11/8/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Starscream

class PlaceInMapVC: UIViewController, WebSocketDelegate {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var radiusLbl: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var mapViewer: UIView!
    
    var kids: [Kid]?
    var kid: Kid?
    
    var socket: WebSocket! = nil
    
    //Map stuffs
    var mapView: GMSMapView!
    var camera = GMSCameraPosition()
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 11
    let geocoder = GMSGeocoder()
    
    var currentCoordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(exactly: 43.243713)!,
                                                        longitude: CLLocationDegrees.init(exactly: 76.918042)!)
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    var radius = 150.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiStuffs()
        mapFunction(currentCoordinate)
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let url = URL(string: "ws://195.93.152.96:11210")!
        socket = WebSocket(url: url)
        socket.delegate = self
        socket.connect()
    }


}

//Functions
extension PlaceInMapVC {
    
    func uiStuffs() {
        radiusSlider.minimumValue = 0.1
        radiusSlider.setValue(0.1, animated: false)
        radiusLbl.text = "\(Int(radius)) m"
    }
    
    @IBAction func sliderMove(sender: UISlider) {
        radius = Double(sender.value * 1500)
        radiusLbl.text = "\(Int(radius)) m"
        setRadius()
    }
}

//Map functions
extension PlaceInMapVC {
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
    
    func newMarkerView() -> UIView {
        
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
        
        backView.addSubview(markerImg)
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
    
    func setRadius() {
        self.mapView.clear()
        setMarker()
        let circ = GMSCircle(position: currentCoordinate, radius: CLLocationDistance(radius))
        circ.fillColor = UIColor(red: 34/255, green: 193/255, blue: 195/255, alpha: 0.2)
        circ.strokeColor = UIColor.clear
        circ.strokeWidth = 0
        circ.map = mapView
        print("MSG Circle location \(currentCoordinate)")
    }
    
    func setMarker() {
        let marker = GMSMarker(position: currentCoordinate)
        //Set child's photo
        let newMarker = newMarkerView()
        marker.iconView = newMarker
        marker.map = mapView
        print("MSG Marker location \(currentCoordinate)")
    }
    
    func mapFunction(_ location: CLLocationCoordinate2D) {
        
        placesClient = GMSPlacesClient.shared()
        
        camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                          longitude: location.longitude,
                                          zoom: 11,
                                          bearing: 0,
                                          viewingAngle: 0)
        
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

// Delegations
extension PlaceInMapVC: GMSMapViewDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Answer from websocket\(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            guard error == nil else {
                return
            }
            if let result = response?.firstResult() {
                let fullAddress = result.lines?[0].components(separatedBy: ",")
                let address = fullAddress?[0]
                self.addressTF.text = address
                self.currentCoordinate = coordinate
                self.setRadius()
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //Tapping the marker
        return true
    }
}
