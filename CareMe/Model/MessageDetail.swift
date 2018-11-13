//
//  MessageDetail.swift
//  CareMe
//
//  Created by baytoor on 11/13/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import Foundation

struct MessageDetail {
    
    var id: String
    var date: String
    var senderID: String
    var receiverID: String
    var message: String
    var type: String
    
    init(_ id: String,_ senderID: String,_ receiverID: String,_ message: String,_ type: String,_ date: String) {
        self.id = id
        self.senderID = senderID
        self.receiverID = receiverID
        self.message = message
        self.type = type
        self.date = date
    }
    
}

