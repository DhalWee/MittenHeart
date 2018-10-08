//
//  File.swift
//  CareMe
//
//  Created by baytoor on 9/19/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import Foundation

struct Child {
    var nameAndSurname: String
    var desc: String
    var imgName: String
    
    init(_ nameAndSurname: String,_ desc: String,_ imgName: String) {
        self.nameAndSurname = nameAndSurname
        self.desc = desc
        self.imgName = imgName
    }
}
