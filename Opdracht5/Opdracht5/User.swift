//
//  User.swift
//  Opdracht5
//
//  Created by Christiaan Kiewiet on 04-11-15.
//  Copyright © 2015 Informatica Haarlem. All rights reserved.
//

import Foundation

struct User{
    let UserName : String
    let Password : String
    
    init(username: String, password: String){
        self.UserName = username
        self.Password = password
    }
}