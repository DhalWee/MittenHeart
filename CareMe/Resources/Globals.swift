//
//  Globals.swift
//  CareMe
//
//  Created by baytoor on 9/11/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

let preWhite = 0xFAFAFA
let navy = 0x35485D
let green = 0x22C1C3
let mapBlue = 0x2A8ECC
let yellow = 0xFFC000
let actionBlue = 0x007AFF
let lightGray = 0xD8D8D8
let darkGray = 0x979797

let mapApi = "AIzaSyBlrYJ3j9_BsUDRv4yp25PeazJx9I0Q3g0"

enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}

func addLineToView(view : UIView, position : LINE_POSITION, color: UIColor, width: Double) {
    let lineView = UIView()
    lineView.backgroundColor = color
    lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
    view.addSubview(lineView)
    
    let metrics = ["width" : NSNumber(value: width)]
    let views = ["lineView" : lineView]
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
    
    switch position {
    case .LINE_POSITION_TOP:
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        break
    case .LINE_POSITION_BOTTOM:
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        break
    }
}

func isInternetAvailable() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
}
