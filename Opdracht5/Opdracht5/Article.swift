//
//  Article.swift
//  Opdracht5
//
//  Created by Informatica Haarlem on 15-10-15.
//  Copyright © 2015 Informatica Haarlem. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Article{
    
    let Id: Int
    let Feed: Int
    let Image: String
    let IsLiked: Bool
    let PublishDate: String
    var Related: [String] = []
    let Summary: String
    let Title: String
    let Url: String
    var Categories: [Categorie] = []
    init(json data: JSON){
        self.Id = data["Id"].int!
        self.Feed = data["Feed"].int!
        self.Image = data["Image"].stringValue
        self.IsLiked = data["IsLiked"].boolValue
        self.PublishDate = data["PublishDate"].stringValue
        self.Summary = data["Summary"].stringValue
        self.Title = data["Title"].stringValue
        self.Url = data["Url"].stringValue
        for categorie in data["Categories"].arrayValue {
            self.Categories.append(Categorie(json: categorie))
        }
        for related in data["Related"].arrayObject!{
            self.Related.append(related as! String)
        }
    }
}