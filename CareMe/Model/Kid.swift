//
//  File.swift
//  CareMe
//
//  Created by baytoor on 9/19/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import Foundation

struct Kid {
    var kidID: String
    var name: String
    var surname: String
    var desc: String
    var imgUrlString: String
    
    var nameAndSurname: String
    
    init(_ kidID: String, _ name: String,_ surname: String,_ desc: String,_ imgUrlString: String) {
        self.name = name
        self.surname = surname
        self.desc = desc
        self.imgUrlString = imgUrlString
        self.nameAndSurname = "\(name) \(surname)"
        self.kidID = kidID
    }
    
}
