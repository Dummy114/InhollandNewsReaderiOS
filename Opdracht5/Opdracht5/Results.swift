//
//  Result.swift
//  Opdracht5
//
//  Created by Informatica Haarlem on 15-10-15.
//  Copyright © 2015 Informatica Haarlem. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ResultModel {
    var NextId: Int
    var Results: [Article] = []
    
    init(json data: JSON){
        self.NextId = data["NextId"].int!
        for article in data["Results"].arrayValue{
            self.Results.append(Article(json: article))
        }
    }
}