//
//  File.swift
//  Opdracht5
//
//  Created by Informatica Haarlem on 15-10-15.
//  Copyright © 2015 Informatica Haarlem. All rights reserved.
//

import Foundation
import SwiftyJSON
struct Categorie{
    let Id: Int
    let Name: String
    
    init(json data: JSON){
        self.Id = data["Id"].int!
        self.Name = data["Name"].stringValue
    }
}