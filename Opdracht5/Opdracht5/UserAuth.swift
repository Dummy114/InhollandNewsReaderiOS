//
//  UserAuth.swift
//  Opdracht5
//
//  Created by Christiaan Kiewiet on 05-11-15.
//  Copyright © 2015 Informatica Haarlem. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserAuth{
    let AuthToken : String
    
    init(json data: JSON){
        self.AuthToken = data["AuthToken"].string!
    }
}