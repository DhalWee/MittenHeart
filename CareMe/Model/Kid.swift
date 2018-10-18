//
//  File.swift
//  CareMe
//
//  Created by baytoor on 9/19/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import Foundation

struct Kid {
    var name: String
    var surname: String
    var desc: String
    var imgName: String
    
    var nameAndSurname: String
    
    init(_ name: String,_ surname: String,_ desc: String,_ imgName: String) {
        self.name = name
        self.surname = surname
        self.desc = desc
        self.imgName = imgName
        self.nameAndSurname = "\(name) \(surname)"
    }
}
